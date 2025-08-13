%% Parameters
lengthX = 10;
widthY = 20;
ptsPerUnit = 1;      % points per unit length for borders
seamWidth = 0.5;       % how far inward the rectangular seam goes
seamGridDensity = 5;  % grid points per unit in seam area
diamondGridDensity = 10;  % grid density inside diamonds

% Diamonds: [cx, cy, a, b]
% diamond_defs = [5 30 3 2;
%                 5 20 3 2;
%                 5 10 3 2];
diamond_defs = [5 10 3 2];

vertices = [];
lines = [];
v_counter = 0;


%% --- RECTANGLE BORDER (clean version) ---
rectCorners = [0 0;
               lengthX 0;
               lengthX widthY;
               0 widthY];

rectPts = [];
line_start_idx = v_counter + 1;

for i = 1:4
    p1 = rectCorners(i,:);
    p2 = rectCorners(mod(i,4)+1,:);
    edgeLen = norm(p2 - p1);
    nPts = max(2, round(edgeLen * ptsPerUnit));
    edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];

    if i > 1
        edgePts = edgePts(2:end,:);  % avoid duplicating point
    end

    rectPts = [rectPts; edgePts];
    for j = 1:size(edgePts,1)-1
        lines = [lines; v_counter + j, v_counter + j + 1];
    end
    v_counter = v_counter + size(edgePts,1);
end

% Close the rectangle loop
lines = [lines; v_counter, line_start_idx];

vertices = [vertices; rectPts];



%% --- DIAMOND BORDERS (including center line) ---
for d = 1:size(diamond_defs,1)
    cx = diamond_defs(d,1);
    cy = diamond_defs(d,2);
    a = diamond_defs(d,3);
    b = diamond_defs(d,4);

    corners = [cx, cy + b;
               cx + a, cy;
               cx, cy - b;
               cx - a, cy];

    diamond_start = v_counter + 1;
    diamondPts = [];

    % Diamond edges
    for i = 1:4
        p1 = corners(i,:);
        p2 = corners(mod(i,4)+1,:);
        edgeLen = norm(p2 - p1);
        nPts = max(2, round(edgeLen * ptsPerUnit));
        edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];

        if i > 1
            edgePts = edgePts(2:end,:);
        end

        diamondPts = [diamondPts; edgePts];
        for j = 1:size(edgePts,1)-1
            lines = [lines; v_counter + j, v_counter + j + 1];
        end
        v_counter = v_counter + size(edgePts,1);
    end

    % Close the diamond loop
    lines = [lines; v_counter, diamond_start];

    vertices = [vertices; diamondPts];

    % Center line
    p1 = corners(4,:);
    p2 = corners(2,:);
    edgeLen = norm(p2 - p1);
    nPts = max(2, round(edgeLen * ptsPerUnit));
    edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];

    center_start = v_counter + 1;
    for j = 1:size(edgePts,1)-1
        vertices(end+1,:) = edgePts(j,:);
        lines = [lines; v_counter + j, v_counter + j + 1];
    end
    vertices(end+1,:) = edgePts(end,:);
    v_counter = v_counter + size(edgePts,1);
end


%% --- RECTANGULAR SEAM (from border inward by width) ---
x_vals = linspace(0, lengthX, round(lengthX * seamGridDensity));
y_vals = linspace(0, widthY, round(widthY * seamGridDensity));
[X, Y] = meshgrid(x_vals, y_vals);

% Keep only points in seam area (a frame of width "seamWidth")
isInOuter = X >= 0 & X <= lengthX & Y >= 0 & Y <= widthY;
isOutInner = X >= seamWidth & X <= (lengthX - seamWidth) & ...
             Y >= seamWidth & Y <= (widthY - seamWidth);
seamMask = isInOuter & ~isOutInner;

fused_points = [X(seamMask), Y(seamMask)];

%% --- GRID-BASED POINTS INSIDE DIAMONDS ---
for d = 1:size(diamond_defs,1)
    cx = diamond_defs(d,1);
    cy = diamond_defs(d,2);
    a = diamond_defs(d,3);
    b = diamond_defs(d,4);

    x_vals = linspace(cx - a, cx + a, round(2*a*diamondGridDensity));
    y_vals = linspace(cy - b, cy + b, round(2*b*diamondGridDensity));
    [Xg, Yg] = meshgrid(x_vals, y_vals);
    mask = abs((Xg - cx)/a) + abs((Yg - cy)/b) <= 1;

    diamondPts = [Xg(mask), Yg(mask)];
    fused_points = [fused_points; diamondPts];
end

%% --- EXPORT OBJ FILE (border only) ---
% Remove duplicate vertices (based on 2D x-y)
[unique_vertices, ~, new_indices] = unique(vertices, 'rows', 'stable');
vertices = unique_vertices;
%lines = new_indices(lines);  % remap indices to the unique set
% Remove duplicate vertices and update line indices
[unique_vertices, ~, ic] = unique(vertices, 'rows', 'stable');

% Only keep lines that map to valid, non-duplicate points
validMask = all(lines <= length(ic), 2);       % discard lines pointing to invalid vertices
lines = ic(lines(validMask, :));               % remap indices safely
vertices = unique_vertices;


% Remove any self-looping lines (like l 1 1)
lines = lines(lines(:,1) ~= lines(:,2), :);

fid = fopen('mesh_bordersX.obj', 'w');%<---------------------------------------
for i = 1:size(vertices,1)
    fprintf(fid, 'v %.5f %.5f 0.00\n', vertices(i,1), vertices(i,2));
end
for i = 1:size(lines,1)
    fprintf(fid, 'l %d %d\n', lines(i,1), lines(i,2));
end
fclose(fid);

% --- EXPORT FUSED POINTS TXT FILE ---
writematrix(fused_points, 'fused_pointsX.txt', 'Delimiter','tab');%<------------

%% --- PLOT ---
figure; hold on; axis equal;
plot(vertices(:,1), vertices(:,2), 'k.', 'MarkerSize', 4);
plot(fused_points(:,1), fused_points(:,2), 'b.', 'MarkerSize', 2);
title('Borders and Fused Points');
xlabel('X'); ylabel('Y');

figure; hold on; axis equal;
plot(vertices(:,1), vertices(:,2), 'k.', 'MarkerSize', 6);        % Border vertices
plot(fused_points(:,1), fused_points(:,2), 'b.', 'MarkerSize', 3); % Fused seam points

% Add vertex labels
for i = 1:size(vertices,1)
    text(vertices(i,1), vertices(i,2), sprintf('%d', i), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', ...
        'FontSize', 6, 'Color', [0.2 0.2 0.2]);
end

% Add line segments and labels
for i = 1:size(lines,1)
    p1 = vertices(lines(i,1), :);
    p2 = vertices(lines(i,2), :);
    mid = (p1 + p2) / 2;
    plot([p1(1), p2(1)], [p1(2), p2(2)], 'g-');
    text(mid(1), mid(2), sprintf('l%d', i), ...
        'FontSize', 5, 'Color', [0 0.5 0], ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end
