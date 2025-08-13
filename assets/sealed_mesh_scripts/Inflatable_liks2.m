%% Parameters, esta version no deberia tener errores con los vertices
lengthX = 10;
widthY = 20;
ptsPerUnit = 1;
seamWidth = 0.5;
seamGridDensity = 10;
diamondGridDensity = 10;

diamond_defs = [5 10 3 2];  % [cx, cy, a, b]

vertices = [];
lines = [];
v_counter = 0;

%% --- RECTANGLE BORDER ---
rectCorners = [0 0; lengthX 0; lengthX widthY; 0 widthY];
rectPts = [];
cornerIdx = [];  % store corner indices

for i = 1:4
    p1 = rectCorners(i,:);
    p2 = rectCorners(mod(i,4)+1,:);
    edgeLen = norm(p2 - p1);
    nPts = max(2, round(edgeLen * ptsPerUnit));
    edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];

    startIdx = v_counter + 1;
    vertices = [vertices; edgePts];
    for j = 1:size(edgePts,1)-1
        lines = [lines; v_counter + j, v_counter + j + 1];
    end
    % Connect last point of this edge to first of next edge
    cornerIdx(end+1) = startIdx;  % first point of this edge
    v_counter = v_counter + nPts;
end
% Close rectangle
lines = [lines; v_counter, cornerIdx(1)];

%% --- DIAMOND BORDERS + CENTER LINE ---
for d = 1:size(diamond_defs,1)
    cx = diamond_defs(d,1);
    cy = diamond_defs(d,2);
    a = diamond_defs(d,3);
    b = diamond_defs(d,4);

    corners = [cx, cy + b;
               cx + a, cy;
               cx, cy - b;
               cx - a, cy];

    start_diamond = v_counter + 1;
    for i = 1:4
        p1 = corners(i,:);
        p2 = corners(mod(i,4)+1,:);
        edgeLen = norm(p2 - p1);
        nPts = max(2, round(edgeLen * ptsPerUnit));
        edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];

        vertices = [vertices; edgePts];
        for j = 1:nPts-1
            lines = [lines; v_counter + j, v_counter + j + 1];
        end
        v_counter = v_counter + nPts;
    end
    % Close diamond
    lines = [lines; v_counter, start_diamond];

    % Center line (left to right corners)
    p1 = corners(4,:);
    p2 = corners(2,:);
    edgeLen = norm(p2 - p1);
    nPts = max(2, round(edgeLen * ptsPerUnit));
    edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];
    vertices = [vertices; edgePts];
    for j = 1:nPts-1
        lines = [lines; v_counter + j, v_counter + j + 1];
    end
    v_counter = v_counter + nPts;
end

%% --- SEAM POINTS ---
x_vals = linspace(0, lengthX, round(lengthX * seamGridDensity));
y_vals = linspace(0, widthY, round(widthY * seamGridDensity));
[X, Y] = meshgrid(x_vals, y_vals);
isInOuter = X >= 0 & X <= lengthX & Y >= 0 & Y <= widthY;
isOutInner = X >= seamWidth & X <= (lengthX - seamWidth) & ...
             Y >= seamWidth & Y <= (widthY - seamWidth);
seamMask = isInOuter & ~isOutInner;
fused_points = [X(seamMask), Y(seamMask)];

%% --- INNER DIAMOND POINTS ---
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

%% --- CLEAN DUPLICATES & SELF LOOPS ---
[unique_vertices, ~, ic] = unique(vertices, 'rows', 'stable');
validMask = all(lines <= length(ic), 2);
lines = ic(lines(validMask, :));
lines = lines(lines(:,1) ~= lines(:,2), :);
vertices = unique_vertices;

% %% --- EXPORT FILES ---
% fid = fopen('T10.obj', 'w');%<---------------------------------------------
% for i = 1:size(vertices,1)
%     fprintf(fid, 'v %.5f %.5f 0.00\n', vertices(i,1), vertices(i,2));
% end
% for i = 1:size(lines,1)
%     fprintf(fid, 'l %d %d\n', lines(i,1), lines(i,2));
% end
% fclose(fid);
% 
% writematrix(fused_points, 'T10.txt', 'Delimiter','tab');%<---------------------------------------------

% %% --- PLOT WITH LABELS ---
% figure; hold on; axis equal;
% plot(vertices(:,1), vertices(:,2), 'k.', 'MarkerSize', 6);
% plot(fused_points(:,1), fused_points(:,2), 'b.', 'MarkerSize', 3);
% 
% for i = 1:size(vertices,1)
%     text(vertices(i,1), vertices(i,2), sprintf('%d', i), ...
%         'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', ...
%         'FontSize', 6, 'Color', [0.2 0.2 0.2]);
% end
% 
% for i = 1:size(lines,1)
%     p1 = vertices(lines(i,1), :);
%     p2 = vertices(lines(i,2), :);
%     mid = (p1 + p2) / 2;
%     plot([p1(1), p2(1)], [p1(2), p2(2)], 'g-');
%     text(mid(1), mid(2), sprintf('l%d', i), ...
%         'FontSize', 5, 'Color', [0 0.5 0], ...
%         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
% end
% title('Pre-Simulation Visualization: Vertex Connectivity and Seam Constraints');
% xlabel('X'); ylabel('Y');
% legend(fused_points, {'Fused Seam Points'}, 'Location', 'bestoutside');
% ylim padded  % automatically adds 5% padding to top and bottom

%% --- PLOT WITH LABELS ---
figure; hold on; axis equal;

% Store plot handles
h_vertices = plot(vertices(:,1), vertices(:,2), 'k.', 'MarkerSize', 6);
h_fused = plot(fused_points(:,1), fused_points(:,2), 'b.', 'MarkerSize', 3);

% Vertex labels
for i = 1:size(vertices,1)
    text(vertices(i,1), vertices(i,2), sprintf('%d', i), ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', ...
        'FontSize', 6, 'Color', [0.2 0.2 0.2]);
end

% Line segments and labels
for i = 1:size(lines,1)
    p1 = vertices(lines(i,1), :);
    p2 = vertices(lines(i,2), :);
    mid = (p1 + p2) / 2;
    plot([p1(1), p2(1)], [p1(2), p2(2)], 'g-');
    text(mid(1), mid(2), sprintf('l%d', i), ...
        'FontSize', 5, 'Color', [0 0.5 0], ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
end

title('Pre-Simulation Visualization: Vertex Connectivity and Seam Constraints');
xlabel('X'); ylabel('Y');

% Add legend (using handles, not data)
legend( h_fused, {'Fused Seam Points'}, 'Location', 'bestoutside');

% Expand y-axis a bit
ylim padded
