%% Test Course Visualization Script

% --- 1. Straight Line Test Course ---
straight_line = [0, 0; 
                 0, 10];

figure('Name', 'Straight Line Test Course', 'Color', 'w');
plot(straight_line(:,1), straight_line(:,2), '-o', ...
    'LineWidth', 1.5, ...
    'Color', [0.6, 0.6, 0.6], ... % Gray path
    'MarkerEdgeColor', 'b', ...   % Blue waypoints
    'MarkerFaceColor', 'b', ...
    'MarkerSize', 6);

axis equal;
axis off;
grid off;


% --- 2. Radius Curve Test Course ---
radius_curve = [0, 0; 
                0, 20; 
                0.34074, 22.58819; 
                1.33975, 25; 
                2.92893, 27.07107; 
                5, 28.66025; 
                7.41181, 29.65926; 
                10, 30; 
                30, 30];

figure('Name', 'Radius Curve Test Course', 'Color', 'w');
plot(radius_curve(:,1), radius_curve(:,2), '-o', ...
    'LineWidth', 1.5, ...
    'Color', [0.6, 0.6, 0.6], ... 
    'MarkerEdgeColor', 'b', ...   
    'MarkerFaceColor', 'b', ...
    'MarkerSize', 6);
axis equal;
axis off;
grid off;


% --- 3. Sharp Turn Course ---
sharp_turn = [0, 0; 
              0, 10; 
              10, 20];

figure('Name', 'Sharp Turn Course', 'Color', 'w');
plot(sharp_turn(:,1), sharp_turn(:,2), '-o', ...
    'LineWidth', 1.5, ...
    'Color', [0.6, 0.6, 0.6], ... 
    'MarkerEdgeColor', 'b', ...   
    'MarkerFaceColor', 'b', ...
    'MarkerSize', 6);
axis equal;
axis off;
grid off;

% Optional: Adjust aspect ratio so turns don't look distorted
% If you want the scale to be realistic, uncomment the line below:
% set(findobj(0,'type','axes'), 'DataAspectRatio', [1 1 1]);
