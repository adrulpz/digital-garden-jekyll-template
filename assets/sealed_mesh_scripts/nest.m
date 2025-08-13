%% Parameters
cx = 5; cy = 10;       % Center of diamond
a = 2;                 % Half-width (horizontal)
b1 = 2;                % Top height
b2 = 3;                % Bottom height
layers = 25;            % Number of nested triangles

vertices = [];
lines = [];
v_counter = 0;

%% Generate nested triangles (top and bottom)
for i = 1:layers
    t = (i) / layers;
    
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

%% Export to OBJ
fid = fopen('nested_diamond.obj','w');
for i = 1:size(vertices,1)
    fprintf(fid, 'v %.5f %.5f 0.0\n', vertices(i,1), vertices(i,2));
end
for i = 1:size(lines,1)
    fprintf(fid, 'l %d %d\n', lines(i,1), lines(i,2));
end
fclose(fid);

%% Plot
figure; hold on; axis equal;
for i = 1:size(lines,1)
    p1 = vertices(lines(i,1), :);
    p2 = vertices(lines(i,2), :);
    plot([p1(1), p2(1)], [p1(2), p2(2)], 'g-', 'LineWidth', 1.5);
end
title('Nested Asymmetric Diamond (Top and Bottom Triangles)');
xlabel('X'); ylabel('Y');
grid on;
