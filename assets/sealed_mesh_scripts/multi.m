%% Parameters
lengthX = 10;
widthY = 20;
ptsPerUnit = 10;             % points per unit length for borders
seamWidth = 0.5;            % seam frame thickness
seamGridDensity = 5;        % resolution of seam grid
diamondGridDensity = 10;    % resolution of diamonds

% Diamonds defined by: [cx, cy, a, b1, b2] (asymmetric vertical halves)
% diamond_defs = [5 10 3 2 3;
%                 3 5 2 1.5 1.5;
%                 7 15 2.5 2 1];
diamond_defs = [5 10 3 4 4];

vertices = [];
lines = [];
v_counter = 0;

%% --- RECTANGLE BORDER ---
rectCorners = [0 0;
               lengthX 0;
               lengthX widthY;
               0 widthY];

rectPts = [];
startIdx = v_counter + 1;

for i = 1:4
    p1 = rectCorners(i,:);
    p2 = rectCorners(mod(i,4)+1,:);
    edgeLen = norm(p2 - p1);
    nPts = max(2, round(edgeLen * ptsPerUnit));
    edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];

    if i > 1
        edgePts = edgePts(2:end,:); % remove duplicate
    end

    for j = 1:size(edgePts,1)
        rectPts(end+1,:) = edgePts(j,:);
        if v_counter > 0
            lines(end+1,:) = [v_counter, v_counter + 1];
        end
        v_counter = v_counter + 1;
    end
end

% Close rectangle explicitly
lines(end+1,:) = [v_counter, startIdx];
vertices = [vertices; rectPts];

%% --- ASYMMETRIC DIAMONDS ---
for d = 1:size(diamond_defs,1)
    cx = diamond_defs(d,1);
    cy = diamond_defs(d,2);
    a = diamond_defs(d,3);
    b1 = diamond_defs(d,4);  % top height
    b2 = diamond_defs(d,5);  % bottom height

    % Define corner points
    A = [cx - a, cy];
    B = [cx, cy + b1];
    C = [cx + a, cy];
    D = [cx, cy - b2];

    % Top triangle: A → B → C → A
    top = [A; B; C; A];
    for i = 1:3
        p1 = top(i,:);
        p2 = top(i+1,:);
        edgeLen = norm(p2 - p1);
        nPts = max(2, round(edgeLen * ptsPerUnit));
        edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];
        vertices = [vertices; edgePts];
        for j = 1:nPts-1
            lines = [lines; v_counter + j, v_counter + j + 1];
        end
        v_counter = v_counter + nPts;
    end

    % Bottom triangle: A → D → C → A
    bot = [A; D; C; A];
    for i = 1:3
        p1 = bot(i,:);
        p2 = bot(i+1,:);
        edgeLen = norm(p2 - p1);
        nPts = max(2, round(edgeLen * ptsPerUnit));
        edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];
        vertices = [vertices; edgePts];
        for j = 1:nPts-1
            lines = [lines; v_counter + j, v_counter + j + 1];
        end
        v_counter = v_counter + nPts;
    end
end

%% --- RECTANGULAR SEAM GRID ---
x_vals = linspace(0, lengthX, round(lengthX * seamGridDensity));
y_vals = linspace(0, widthY, round(widthY * seamGridDensity));
[X, Y] = meshgrid(x_vals, y_vals);

isInOuter = X >= 0 & X <= lengthX & Y >= 0 & Y <= widthY;
isOutInner = X >= seamWidth & X <= (lengthX - seamWidth) & ...
             Y >= seamWidth & Y <= (widthY - seamWidth);
seamMask = isInOuter & ~isOutInner;
fused_points = [X(seamMask), Y(seamMask)];

%% --- DIAMOND INTERIOR GRIDS ---
for d = 1:size(diamond_defs,1)
    cx = diamond_defs(d,1);
    cy = diamond_defs(d,2);
    a = diamond_defs(d,3);
    b1 = diamond_defs(d,4);
    b2 = diamond_defs(d,5);

    x_vals = linspace(cx - a, cx + a, round(2*a*diamondGridDensity));
    y_vals = linspace(cy - b2, cy + b1, round((b1 + b2)*diamondGridDensity));
    [Xg, Yg] = meshgrid(x_vals, y_vals);

    % Use scaled diamond mask: asymmetric vertically
    mask_top = (Yg >= cy) & (abs((Xg - cx)/a) + abs((Yg - cy)/b1) <= 1);
    mask_bot = (Yg < cy)  & (abs((Xg - cx)/a) + abs((Yg - cy)/b2) <= 1);
    mask = mask_top | mask_bot;

    diamondPts = [Xg(mask), Yg(mask)];
    fused_points = [fused_points; diamondPts];
end

%% --- Remove duplicate vertices ---
[unique_vertices, ~, ic] = unique(vertices, 'rows', 'stable');
validMask = all(lines <= length(ic), 2);
lines = ic(lines(validMask, :));
vertices = unique_vertices;
lines = lines(lines(:,1) ~= lines(:,2), :);  % remove self-loops

%% --- Export to OBJ and TXT ---
fid = fopen('T10e.obj', 'w');%<-----------------------------------------------------
for i = 1:size(vertices,1)
    fprintf(fid, 'v %.5f %.5f 0.00\n', vertices(i,1), vertices(i,2));
end
for i = 1:size(lines,1)
    fprintf(fid, 'l %d %d\n', lines(i,1), lines(i,2));
end
fclose(fid);

writematrix(fused_points, 'T10e.txt', 'Delimiter','\t');% <------------------------------

%% --- Plot everything ---
figure; hold on; axis equal;
plot(vertices(:,1), vertices(:,2), 'k.', 'MarkerSize', 5);
plot(fused_points(:,1), fused_points(:,2), 'b.', 'MarkerSize', 2);
title('Borders and Asymmetric Diamonds');
xlabel('X'); ylabel('Y');

% Number the vertices
for i = 1:size(vertices,1)
    text(vertices(i,1), vertices(i,2), sprintf('%d', i), ...
        'VerticalAlignment','bottom', 'HorizontalAlignment','right', ...
        'FontSize', 6, 'Color', [0.1 0.6 0.1]);
end

% Draw line segments and number them
for i = 1:size(lines,1)
    p1 = vertices(lines(i,1), :);
    p2 = vertices(lines(i,2), :);
    mid = (p1 + p2) / 2;
    plot([p1(1), p2(1)], [p1(2), p2(2)], 'g-');
    text(mid(1), mid(2), sprintf('l%d', i), ...
        'FontSize', 5, 'Color', [0 0.5 0], ...
        'HorizontalAlignment','center', 'VerticalAlignment','middle');
end
