% Parameters
lengthX = 10;
widthY = 20;
seamOffset = .5;    % fused region thickness from border
nDiamondInside = 1e3; % points inside each diamond

ptsPerUnit = 1e3;  % points per unit length

% For rectangle edges
rectEdges = [0 lengthX;
             0 widthY;
             lengthX widthY;
             widthY 0];

% Reset vertices and lines
vertices = [];
lines = [];
v_counter = 0;
rectPts = [];

% Define rectangle corners
rectCorners = [0 0;
               lengthX 0;
               lengthX widthY;
               0 widthY];

for i = 1:4
    p1 = rectCorners(i,:);
    p2 = rectCorners(mod(i,4)+1,:);
    edgeLen = norm(p2 - p1);
    nPts = max(2, round(edgeLen * ptsPerUnit)); % at least 2 points per edge
    edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];
    rectPts = [rectPts; edgePts];
    for j = 1:nPts-1
        lines = [lines; v_counter + j, v_counter + j + 1];
    end
    v_counter = v_counter + nPts;
end

vertices = [vertices; rectPts];

% Define diamonds: [center_x, center_y, a, b]
%diamond_defs = [5 30 3 2; 5 20 3 2; 5 10 3 2];%%% <-------------------------
diamond_defs = [5 30 3 2];

vertices = [];
lines = [];
v_counter = 0;

%% --- RECTANGLE BORDER POINTS ---
rectCorners = [0 0;
               lengthX 0;
               lengthX widthY;
               0 widthY];

% Generate points along each edge
rectPts = [];
for i = 1:4
    p1 = rectCorners(i,:);
    p2 = rectCorners(mod(i,4)+1,:);
    edgePts = [linspace(p1(1), p2(1), nPerEdge)', ...
               linspace(p1(2), p2(2), nPerEdge)'];
    rectPts = [rectPts; edgePts];
    for j = 1:nPerEdge-1
        lines = [lines; v_counter + j, v_counter + j + 1];
    end
    v_counter = v_counter + nPerEdge;
end
vertices = [vertices; rectPts];

%% --- DIAMOND BORDERS + CENTRAL SPLIT ---
% Inside diamond loop:
edgeLen = norm(p2 - p1);
nPts = max(2, round(edgeLen * ptsPerUnit));
edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];

for d = 1:size(diamond_defs,1)
    cx = diamond_defs(d,1);
    cy = diamond_defs(d,2);
    a = diamond_defs(d,3);
    b = diamond_defs(d,4);
    
    corners = [cx, cy + b;
               cx + a, cy;
               cx, cy - b;
               cx - a, cy];
    
    % Outer diamond edges
    for i = 1:4
        p1 = corners(i,:);
        p2 = corners(mod(i,4)+1,:);
        edgePts = [linspace(p1(1), p2(1), nPerEdge)', ...
                   linspace(p1(2), p2(2), nPerEdge)'];
        vertices = [vertices; edgePts];
        for j = 1:nPerEdge-1
            lines = [lines; v_counter + j, v_counter + j + 1];
        end
        v_counter = v_counter + nPerEdge;
    end

    % Center line (left to right corners)
    p1 = corners(4,:);
    p2 = corners(2,:);
    midPts = [linspace(p1(1), p2(1), nPerEdge)', ...
              linspace(p1(2), p2(2), nPerEdge)'];
    vertices = [vertices; midPts];
    for j = 1:nPerEdge-1
        lines = [lines; v_counter + j, v_counter + j + 1];
    end
    v_counter = v_counter + nPerEdge;
end

%% --- FUSED SEAM POINTS: RECTANGULAR FRAME (starting at border) ---
seamWidth = 0.50;    % how far inward the frame goes %%% <--------------------------
density = 1e3;       % points per unit length (higher = denser)%%% <---------------

x_full = linspace(0, lengthX, round(lengthX * density));
y_full = linspace(0, widthY, round(widthY * density));
[X, Y] = meshgrid(x_full, y_full);

% Create mask for seam frame
isIn = X >= 0 & X <= lengthX & ...
       Y >= 0 & Y <= widthY;

isOut = X >= seamWidth & X <= (lengthX - seamWidth) & ...
        Y >= seamWidth & Y <= (widthY - seamWidth);

seamMask = isIn & ~isOut;

fused_rect = [X(seamMask), Y(seamMask)];
fused_points = fused_rect;  % start new list

%% --- FUSED POINTS INSIDE DIAMONDS (GRID-BASED) ---
diamond_density = 1e4; % points per unit, increase for denser grid %%% <-----------

for d = 1:size(diamond_defs,1)
    cx = diamond_defs(d,1);
    cy = diamond_defs(d,2);
    a = diamond_defs(d,3);
    b = diamond_defs(d,4);

    % Generate grid over bounding box
    x_vals = linspace(cx - a, cx + a, round(2*a*diamond_density));
    y_vals = linspace(cy - b, cy + b, round(2*b*diamond_density));
    [X, Y] = meshgrid(x_vals, y_vals);

    % Rhombus condition: Manhattan norm in rotated ellipse space
    mask = abs((X - cx)/a) + abs((Y - cy)/b) <= 1;

    % Add valid points only
    diamondPoints = [X(mask), Y(mask)];
    fused_points = [fused_points; diamondPoints];
end


%% --- EXPORT OBJ (borders only) ---
fid = fopen('mesh_borders10.obj', 'w');%%% <------
for i = 1:size(vertices,1)
    fprintf(fid, 'v %.5f %.5f 0.00\n', vertices(i,1), vertices(i,2));
end
for i = 1:size(lines,1)
    fprintf(fid, 'l %d %d\n', lines(i,1), lines(i,2));
end
fclose(fid);

%% --- EXPORT FUSED POINTS ---
writematrix(fused_points, 'fused_points10.txt', 'Delimiter','tab');%%% <-----------

%% --- PLOT ---
figure; hold on; axis equal;
plot(vertices(:,1), vertices(:,2), 'k.', 'MarkerSize', 5);
plot(fused_points(:,1), fused_points(:,2), 'b.', 'MarkerSize', 3);
title('Border and Fused Points');
xlabel('X'); ylabel('Y');
