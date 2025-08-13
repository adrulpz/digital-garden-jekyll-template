%% Parameters
lengthX = 10;
widthY = 20;
ptsPerUnit = 1;
nestingLevels = 3;
diamond_defs = [5 10 3 4 4;
                3 5 2 3 2;
                7 15 2.5 2 1];

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
        edgePts = edgePts(2:end,:);
    end
    for j = 1:size(edgePts,1)
        rectPts(end+1,:) = edgePts(j,:);
        if v_counter > 0
            lines(end+1,:) = [v_counter, v_counter + 1];
        end
        v_counter = v_counter + 1;
    end
end
lines(end+1,:) = [v_counter, startIdx];
vertices = [vertices; rectPts];

%% --- DIAMONDS WITH NESTED TRIANGLES ---
for d = 1:size(diamond_defs,1)
    cx = diamond_defs(d,1); cy = diamond_defs(d,2);
    a = diamond_defs(d,3); b1 = diamond_defs(d,4); b2 = diamond_defs(d,5);

    A = [cx - a, cy]; B = [cx, cy + b1]; C = [cx + a, cy]; D = [cx, cy - b2];

    % Top triangle: A-B-C
    topEdges = [A; B; C; A];
    for i = 1:3
        p1 = topEdges(i,:); p2 = topEdges(i+1,:);
        edgeLen = norm(p2 - p1);
        nPts = max(2, round(edgeLen * ptsPerUnit));
        edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];
        vertices = [vertices; edgePts];
        for j = 1:nPts-1
            lines = [lines; v_counter + j, v_counter + j + 1];
        end
        v_counter = v_counter + nPts;
    end
    [vNew, lNew] = addNestedTriangle(A, B, C, nestingLevels, v_counter);
    vertices = [vertices; vNew];
    lines = [lines; lNew + v_counter];
    v_counter = v_counter + size(vNew,1);

    % Bottom triangle: A-D-C
    botEdges = [A; D; C; A];
    for i = 1:3
        p1 = botEdges(i,:); p2 = botEdges(i+1,:);
        edgeLen = norm(p2 - p1);
        nPts = max(2, round(edgeLen * ptsPerUnit));
        edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];
        vertices = [vertices; edgePts];
        for j = 1:nPts-1
            lines = [lines; v_counter + j, v_counter + j + 1];
        end
        v_counter = v_counter + nPts;
    end
    [vNew, lNew] = addNestedTriangle(A, D, C, nestingLevels, v_counter);
    vertices = [vertices; vNew];
    lines = [lines; lNew + v_counter];
    v_counter = v_counter + size(vNew,1);
end

%% --- Cleanup & Export ---
[unique_vertices, ~, ic] = unique(vertices, 'rows', 'stable');
validMask = all(lines <= length(ic), 2);
lines = ic(lines(validMask, :));
vertices = unique_vertices;
lines = lines(lines(:,1) ~= lines(:,2), :);

% Export OBJ
fid = fopen('nested_diamonds.obj', 'w');
for i = 1:size(vertices,1)
    fprintf(fid, 'v %.5f %.5f 0.00\n', vertices(i,1), vertices(i,2));
end
for i = 1:size(lines,1)
    fprintf(fid, 'l %d %d\n', lines(i,1), lines(i,2));
end
fclose(fid);

% Dummy fused points file
writematrix([0 0], 'nested_diamonds.txt', 'Delimiter','\t');

%% --- Plot ---
figure; hold on; axis equal;
plot(vertices(:,1), vertices(:,2), 'k.', 'MarkerSize', 5);

for i = 1:size(vertices,1)
    text(vertices(i,1), vertices(i,2), sprintf('%d', i), ...
        'VerticalAlignment','bottom', 'HorizontalAlignment','right', ...
        'FontSize', 6, 'Color', [0.1 0.6 0.1]);
end

for i = 1:size(lines,1)
    p1 = vertices(lines(i,1), :); p2 = vertices(lines(i,2), :);
    mid = (p1 + p2)/2;
    plot([p1(1), p2(1)], [p1(2), p2(2)], 'g-');
    text(mid(1), mid(2), sprintf('l%d', i), ...
        'FontSize', 5, 'Color', [0 0.5 0], ...
        'HorizontalAlignment','center', 'VerticalAlignment','middle');
end
title('Nested Triangles Inside Asymmetric Diamonds');
xlabel('X'); ylabel('Y');

%% --- Helper function at end of file
function [v, l] = addNestedTriangle(p1, p2, p3, nLevels, startIdx)
v = []; l = [];
for k = 0:nLevels
    alpha = 1 - k / nLevels;
    v1 = alpha*p1 + (1-alpha)*p2;
    v2 = alpha*p2 + (1-alpha)*p3;
    v3 = alpha*p3 + (1-alpha)*p1;
    idx1 = size(v,1)+1 + startIdx;
    v = [v; v1; v2; v3];
    l = [l; idx1 idx1+1;
            idx1+1 idx1+2;
            idx1+2 idx1];
end
end
