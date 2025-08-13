%% Parameters
lengthX = 10;
widthY = 20;
ptsPerUnit = 10;
layers = 50;  % Number of nested triangle layers

fid = fopen('N10.obj','w');
% Each diamond is defined by: [cx, cy, a, b1, b2]
% diamond_defs = [
%     5 10 2 2 3;
%     3 5 1.5 1.5 1.5;
%     7 15 2.5 2 1
% ];
diamond_defs = [5 10 3 2 2];

vertices = [];
lines = [];
v_counter = 0;

%% --- RECTANGLE BORDER ---
rectCorners = [0 0; lengthX 0; lengthX widthY; 0 widthY];
startIdx = v_counter + 1;
rectPts = [];

for i = 1:4
    p1 = rectCorners(i,:);
    p2 = rectCorners(mod(i,4)+1,:);
    edgeLen = norm(p2 - p1);
    nPts = max(2, round(edgeLen * ptsPerUnit));
    edgePts = [linspace(p1(1), p2(1), nPts)', linspace(p1(2), p2(2), nPts)'];
    if i > 1, edgePts = edgePts(2:end,:); end
    for j = 1:size(edgePts,1)
        rectPts(end+1,:) = edgePts(j,:);
        if v_counter > 0
            lines(end+1,:) = [v_counter, v_counter + 1];
        end
        v_counter = v_counter + 1;
    end
end

lines(end+1,:) = [v_counter, startIdx]; % close border
vertices = [vertices; rectPts];

%% --- NESTED TRIANGLES IN DIAMONDS ---
for d = 1:size(diamond_defs,1)
    cx = diamond_defs(d,1);
    cy = diamond_defs(d,2);
    a  = diamond_defs(d,3);
    b1 = diamond_defs(d,4);  % top
    b2 = diamond_defs(d,5);  % bottom

    for i = 1:layers
        t = i / layers;

        % Top triangle
        A = [cx - a * (1 - t), cy];
        B = [cx, cy + b1 * (1 - t)];
        C = [cx + a * (1 - t), cy];

        vertices = [vertices; A; B; C];
        lines = [lines; v_counter+1, v_counter+2;
                          v_counter+2, v_counter+3;
                          v_counter+3, v_counter+1];
        v_counter = v_counter + 3;

        % Bottom triangle
        D = [cx, cy - b2 * (1 - t)];

        vertices = [vertices; A; D; C];
        lines = [lines; v_counter+1, v_counter+2;
                          v_counter+2, v_counter+3;
                          v_counter+3, v_counter+1];
        v_counter = v_counter + 3;
    end
end

%% --- OBJ EXPORT ---
% fid = fopen('nested_full.obj','w'); %<--------------------------------------------- 
for i = 1:size(vertices,1)
    fprintf(fid, 'v %.5f %.5f 0.0\n', vertices(i,1), vertices(i,2));
end
for i = 1:size(lines,1)
    fprintf(fid, 'l %d %d\n', lines(i,1), lines(i,2));
end
fclose(fid);

% %% --- PLOT ---
% figure; hold on; axis equal;
% plot(vertices(:,1), vertices(:,2), 'k.', 'MarkerSize', 6);
% title('Nested Triangles Inside Asymmetric Diamonds');
% xlabel('X'); ylabel('Y');
% 
% for i = 1:size(vertices,1)
%     text(vertices(i,1), vertices(i,2), sprintf('%d', i), ...
%         'VerticalAlignment','bottom', 'HorizontalAlignment','right', ...
%         'FontSize', 6, 'Color', [0.1 0.6 0.1]);
% end
% 
% for i = 1:size(lines,1)
%     p1 = vertices(lines(i,1), :);
%     p2 = vertices(lines(i,2), :);
%     mid = (p1 + p2) / 2;
%     plot([p1(1), p2(1)], [p1(2), p2(2)], 'g-');
%     text(mid(1), mid(2), sprintf('l%d', i), ...
%         'FontSize', 5, 'Color', [0 0.5 0], ...
%         'HorizontalAlignment','center', 'VerticalAlignment','middle');
% end
