% --- User-defined mesh parameters ---
lengthX = 10;      % Length in x-direction (units)
widthY  = 40;      % Width in y-direction (units)
heightZ = 3;       % Distance between meshes (z-axis)
numX    = lengthX*1;      % Number of points along x-axis
numY    = widthY*1;      % Number of points along y-axis

z1 = 0;            % z-value of bottom mesh
z2 = heightZ;      % z-value of top mesh

% --- Define multiple diamond regions ---
diamond_centers = [5, 30; 5, 20; 5, 10];  % Each row is [xc, p]
diamond_axes = [3, 2; 3, 2; 3, 2];          % Each row is [a, b]

% --- Colors for each diamond (RGB rows) ---
color_list = [1 0.5 0; 1 0 0; 0.8 0.2 1];   % orange, red, purple

% --- Generate mesh grid ---
x_vals = linspace(0, lengthX, numX);
y_vals = linspace(0, widthY, numY);
[x, y] = meshgrid(x_vals, y_vals);

z_bottom = z1 * ones(size(x));
z_top = z2 * ones(size(x));

% --- Plot setup ---
figure;
hold on;
grid on;
axis equal;
axis vis3d;
xlabel('X'); ylabel('Y'); zlabel('Z');
title('Sealed Mesh with Multiple Diamond Regions');

% --- Plot top and bottom surfaces ---
surf(x, y, z_bottom, 'FaceAlpha', 0.3, 'EdgeColor', 'k');
surf(x, y, z_top, 'FaceAlpha', 0.3, 'EdgeColor', 'r');

% --- Connect points vertically: borders + diamonds ---
for i = 1:numY
    for j = 1:numX
        x_ij = x(i,j);
        y_ij = y(i,j);

        % Border condition
        isBorder = (i == 1 || i == numY || j == 1 || j == numX);
        isDiamond = false;
        diamond_id = 0;

        % Check against all diamonds
        for d = 1:size(diamond_centers, 1)
            xc_d = diamond_centers(d, 1);
            p_d = diamond_centers(d, 2);
            a_d = diamond_axes(d, 1);
            b_d = diamond_axes(d, 2);

            if abs(x_ij - xc_d) * b_d + abs(y_ij - p_d) * a_d <= a_d * b_d
                isDiamond = true;
                diamond_id = d;
                break;
            end
        end

        % Draw vertical lines
        if isBorder
            plot3([x_ij, x_ij], [y_ij, y_ij], [z_bottom(i,j), z_top(i,j)], ...
                'g-', 'LineWidth', 1.2);
        elseif isDiamond
            c = color_list(mod(diamond_id-1, size(color_list,1)) + 1, :);
            plot3([x_ij, x_ij], [y_ij, y_ij], [z_bottom(i,j), z_top(i,j)], ...
                '-', 'Color', c, 'LineWidth', 1.5);
        end
    end
end

% --- Seal edges (bottom and top) ---
for i = [1, numY]
    for j = 1:numX-1
        plot3([x(i,j), x(i,j+1)], [y(i,j), y(i,j+1)], [z_bottom(i,j), z_bottom(i,j+1)], 'b-');
        plot3([x(i,j), x(i,j+1)], [y(i,j), y(i,j+1)], [z_top(i,j), z_top(i,j+1)], 'b-');
    end
    plot3([x(i,end), x(i,1)], [y(i,end), y(i,1)], [z_bottom(i,end), z_bottom(i,1)], 'b-');
    plot3([x(i,end), x(i,1)], [y(i,end), y(i,1)], [z_top(i,end), z_top(i,1)], 'b-');
end

for j = [1, numX]
    for i = 1:numY-1
        plot3([x(i,j), x(i+1,j)], [y(i,j), y(i+1,j)], [z_bottom(i,j), z_bottom(i+1,j)], 'b-');
        plot3([x(i,j), x(i+1,j)], [y(i,j), y(i+1,j)], [z_top(i,j), z_top(i+1,j)], 'b-');
    end
    plot3([x(end,j), x(1,j)], [y(end,j), y(1,j)], [z_bottom(end,j), z_bottom(1,j)], 'b-');
    plot3([x(end,j), x(1,j)], [y(end,j), y(1,j)], [z_top(end,j), z_top(1,j)], 'b-');
end

% --- Highlight each diamond outline ---
for d = 1:size(diamond_centers, 1)
    xc_d = diamond_centers(d, 1);
    p_d = diamond_centers(d, 2);
    a_d = diamond_axes(d, 1);
    b_d = diamond_axes(d, 2);

    % Diamond corners
    dx = [xc_d, xc_d + a_d, xc_d, xc_d - a_d, xc_d];
    dy = [p_d + b_d, p_d, p_d - b_d, p_d, p_d + b_d];
    c = color_list(mod(d-1, size(color_list,1)) + 1, :);

    % Plot on bottom and top
    plot3(dx, dy, z1 * ones(size(dx)), '--', 'Color', c, 'LineWidth', 2);
    plot3(dx, dy, z2 * ones(size(dx)), '--', 'Color', c, 'LineWidth', 2);
end
% --- Add interpolated vertical lines along diamond edges ---
numInterp = 30;  % Number of interpolated segments per edge

for d = 1:size(diamond_centers, 1)
    xc_d = diamond_centers(d, 1);
    p_d = diamond_centers(d, 2);
    a_d = diamond_axes(d, 1);
    b_d = diamond_axes(d, 2);
    c = color_list(mod(d-1, size(color_list,1)) + 1, :);

    % Define diamond corners
    corners_x = [xc_d, xc_d + a_d, xc_d, xc_d - a_d];
    corners_y = [p_d + b_d, p_d, p_d - b_d, p_d];

    % Connect edges: (1→2), (2→3), (3→4), (4→1)
    for k = 1:4
        x1 = corners_x(k);
        y1 = corners_y(k);
        x2 = corners_x(mod(k,4)+1);
        y2 = corners_y(mod(k,4)+1);

        % Interpolate between (x1,y1) and (x2,y2)
        x_edge = linspace(x1, x2, numInterp);
        y_edge = linspace(y1, y2, numInterp);

        for n = 1:numInterp
            plot3([x_edge(n), x_edge(n)], [y_edge(n), y_edge(n)], [z1, z2], ...
                  '-', 'Color', c, 'LineWidth', 1);
        end
    end
end


% --- Final view setup ---
view(3);

% === GENERATE EDGESETTOPOLOGYCONTAINER STRINGS ===
points = {};
edges = [];
index_map = nan(size(x,1), size(x,2), 2); % [bottom, top]
index = 0;

for i = 1:numY
    for j = 1:numX
        x_ij = x(i,j);
        y_ij = y(i,j);

        % Border condition
        isBorder = (i == 1 || i == numY || j == 1 || j == numX);
        isDiamond = false;

        for d = 1:size(diamond_centers, 1)
            xc_d = diamond_centers(d, 1);
            yc_d = diamond_centers(d, 2);
            a_d = diamond_axes(d, 1);
            b_d = diamond_axes(d, 2);

            if abs(x_ij - xc_d) * b_d + abs(y_ij - yc_d) * a_d <= a_d * b_d
                isDiamond = true;
                break;
            end
        end

        if isBorder || isDiamond
            % Bottom point
            points{end+1} = sprintf('%.2f %.2f %.2f', x_ij, y_ij, z_bottom(i,j));
            index_map(i,j,1) = index;
            bottom_idx = index;
            index = index + 1;

            % Top point
            points{end+1} = sprintf('%.2f %.2f %.2f', x_ij, y_ij, z_top(i,j));
            index_map(i,j,2) = index;
            top_idx = index;
            index = index + 1;

            % Vertical edge
            edges(end+1,:) = [bottom_idx, top_idx];
        end
    end
end

% Horizontal & vertical connections on top and bottom
for i = 1:numY
    for j = 1:numX
        for k = 1:2
            idx = index_map(i,j,k);
            if isnan(idx), continue; end
            if j < numX && ~isnan(index_map(i,j+1,k))
                edges(end+1,:) = [idx, index_map(i,j+1,k)];
            end
            if i < numY && ~isnan(index_map(i+1,j,k))
                edges(end+1,:) = [idx, index_map(i+1,j,k)];
            end
        end
    end
end

% === PRINT TO CONSOLE ===
fprintf('\n<EdgeSetTopologyContainer name="Container_points" points="\n');
for i = 1:length(points)
    fprintf('    %s\n', points{i});
end
fprintf('"/>\n');

fprintf('\n<EdgeSetTopologyContainer name="Container_full_web" points="@Container_points.points" edges="\n');
for i = 1:size(edges,1)
    fprintf('    %d %d\n', edges(i,1), edges(i,2));
end
fprintf('"/>\n');

% === Save points/edges in single-line format to .txt ===
flat_points = strjoin(points, ' ');
edge_strs = arrayfun(@(i) sprintf('%d %d', edges(i,1), edges(i,2)), 1:size(edges,1), 'UniformOutput', false);
flat_edges = strjoin(edge_strs, ' ');

% Write to file
fileID = fopen('matlab_sofa_output.txt', 'w');
fprintf(fileID, '<?xml version="1.0"?>\n');
fprintf(fileID, '<Node name="Root" gravity="0.0 0.0 0.0">\n');
fprintf(fileID, '  <Node name="web">\n');
fprintf(fileID, '    <EdgeSetTopologyContainer name="Container_points" points="%s"/>\n', flat_points);
fprintf(fileID, '    <EdgeSetTopologyContainer name="Container_full_web" points="@Container_points.points" edges="%s"/>\n', flat_edges);
fprintf(fileID, '  </Node>\n');
fprintf(fileID, '</Node>\n');
fclose(fileID);

disp('📝 Output written to matlab_sofa_output.txt (compact XML)');
