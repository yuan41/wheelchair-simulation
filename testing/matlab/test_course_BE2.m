% --- 4. C Course ---
c_course = [
    0, 2;
    0, 25;
    0.26795, 26;    % Circle point
    1, 26.73205;    % Circle point
    2, 27;
    27, 27;
    28, 26.73205;   % Circle point
    28.73205, 26;   % Circle point
    29, 25;
    29, 20;
    28.73205, 19;   % Circle point
    28, 18.26795;   % Circle point
    27, 18;
    7, 18;
    6, 17.73205;    % Circle point
    5.26795, 17;    % Circle point
    5, 16;
    5, 11;
    5.26795, 10;    % Circle point
    6, 9.26795;     % Circle point
    7, 9;
    27, 9;
    28, 8.73205;    % Circle point
    28.73205, 8;    % Circle point
    29, 7;
    29, 2;
    28.73205, 1;    % Circle point
    28, 0.26795;   % Circle point
    27, 0;
    2, 0;
    1, 0.26795;     % Circle point (Final turn)
    0.26795, 1      % Circle point (Final turn)
];

figure('Name', 'C Course', 'Color', 'w');
plot(c_course(:,1), c_course(:,2), '-o', ...
    'LineWidth', 1.5, 'Color', [0.6, 0.6, 0.6], ...
    'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', 6);
axis equal;
axis off;
grid off;