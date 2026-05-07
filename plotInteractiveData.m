% plotInteractiveData 创建包含 UI Checkbox 的交互式绘图窗口
    % 输入:
    %   t           - 时间列向量
    %   data_angles - 角度数据矩阵 (N x M)
    %   data_acc    - 角加速度数据矩阵 (N x M)
    %   labels      - 图例标签元胞数组 (1 x M)

function plotInteractiveData(t, data_angles, data_acc, labels)

    
    num_lines = size(data_angles, 2);
    
    % 创建 uifigure
    fig = uifigure('Color', 'w', 'Position', [100, 100, 950, 500], 'Name', 'Interactive Sine Waves Plot');

    main_layout = uigridlayout(fig, [1, 2]);
    main_layout.ColumnWidth = {'1x', 120};
    main_layout.Padding = [5, 5, 5, 5];

    t_layout = tiledlayout(main_layout, 2, 1, 'TileSpacing', 'none', 'Padding', 'compact');
    t_layout.Layout.Row = 1;
    t_layout.Layout.Column = 1;

    colors = lines(num_lines);

    h_lines_angle = gobjects(num_lines, 1);
    h_lines_acc   = gobjects(num_lines, 1);

    ax1 = nexttile(t_layout);
    hold(ax1, 'on');
    for i = 1:num_lines
        h_lines_angle(i) = plot(ax1, t, data_angles(:, i), 'Color', colors(i,:), 'LineWidth', 1);
    end
    ylabel(ax1, 'Angle / rad', 'Interpreter', 'latex',  'FontSize', 12, 'FontWeight', 'bold');
    box(ax1, 'on');
    grid(ax1, 'on');
    ax1.XAxis.TickLabels = {}; 

    ax2 = nexttile(t_layout);
    hold(ax2, 'on');
    for i = 1:num_lines
        h_lines_acc(i) = plot(ax2, t, data_acc(:, i), 'Color', colors(i,:), 'LineWidth', 1);
    end
    ylabel(ax2, 'Angular Acc / $\mathrm{rad \cdot s^{-2}}$', ...
        'Interpreter', 'latex', 'FontSize', 12, 'FontWeight', 'bold');
    box(ax2, 'on');
    grid(ax2, 'on');

    linkaxes([ax1, ax2], 'x'); 
    xlabel(t_layout, 'Time / s', 'Interpreter', 'latex', 'FontSize', 12, 'FontWeight', 'bold');
    xlim(ax1, [0, t(end)]);

    cb_panel = uipanel(main_layout, 'Title', 'Legend', 'BackgroundColor', 'w', 'FontWeight', 'bold');
    cb_panel.Layout.Row = 1;
    cb_panel.Layout.Column = 2;

    cb_grid = uigridlayout(cb_panel, [num_lines, 1]);
    cb_grid.RowHeight = repmat({'1x'}, 1, num_lines); 
    cb_grid.Padding = [5, 5, 5, 5];

    for i = 1:num_lines
        cb = uicheckbox(cb_grid, 'Text', labels{i}, 'Value', 1, ...
                        'FontWeight', 'bold', 'FontColor', colors(i,:));
        cb.ValueChangedFcn = @(src, event) toggleLineVisibility(src, h_lines_angle(i), h_lines_acc(i));
    end
end

function data = generateSineWaves(t, num_signals)

    data = zeros(length(t), num_signals);
    f_wave = 1; 
    
    for i = 1:num_signals
        phase = (i - 1) * (2 * pi / num_signals);
        data(:, i) = sin(2 * pi * f_wave * t + phase);
    end
end

function toggleLineVisibility(src, line_angle, line_acc)
    if src.Value == 1
        line_angle.Visible = 'on';
        line_acc.Visible   = 'on';
    else
        line_angle.Visible = 'off';
        line_acc.Visible   = 'off';
    end
end

function data_centered = removeInitialBias(data, num_points)
    if num_points > size(data, 1)
        warning('指定的校准点数大于数据总长度，将使用全部数据计算均值。');
        num_points = size(data, 1);
    end
    initial_mean = mean(data(1:num_points, :), 1);
    data_centered = data - initial_mean;
end

