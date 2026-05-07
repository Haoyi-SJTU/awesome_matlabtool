close all; clc;

%%%%%%%%%%%函数使用示范%%%%%%%%%%%%%%

% 测试数据
fs = 50;
dt = 1 / fs;      
t = (0:dt:5)';  % 生成5秒的数据
data_angles = generateSineWaves(t, 12);
data_vel = zeros(size(data_angles));
for i = 1:size(data_angles, 2)
    velocity_i = gradient(data_angles(:, i), dt);  
    data_vel(:, i) = velocity_i;     
end


labels = {'alpha_7', 'beta_7', 'alpha_8', 'beta_8', ...
          'alpha_9', 'beta_9', 'alpha_10', 'beta_10', ...
          'alpha_11', 'beta_11', 'alpha_12', 'beta_12'};

plotInteractiveData(t, data_angles, data_vel, labels);



