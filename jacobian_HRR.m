clc;
clear all;
close all;

L = 0.146;%臂筒长度
h1 = 0.025;%万向铰高度
h2 = 0.025;%万向铰高度

q_data = [0 ... % motor
    0 0	...
    0.36 0 ...
    0.36	0  ...
    0.36 0 ...
    -0.36   0 ...
    -0.36	0 ...
    -0.36	0 ...
    0	0 ...
    0	0  ...
    0	0  ...
    0	0  ...
    0 0];

t_data = zeros(6);%末端6方向位置
T_i = zeros(4,4,25);%T^0_i
T_e = zeros(4, 4);% 末端变换阵T^0_e
J_i = zeros(6, 25);%Jacobian

T = [1 0 0 0.003; 0 1 0 0; 0 0 1 0; 0 0 0 1];%第一个平移关节的变换矩阵
T_i(:,:,1) = T;%第一个平移关节的变换矩阵
for j = 1:2:23
    Ti = forward_kinematics_alpha(q_data(j), q_data(j+1), L, h1, h2);
    T = T * Ti;
    T_i(:,:,j+1) = T;
    Ti = forward_kinematics_beta(q_data(j), q_data(j+1), L, h1, h2);
    T = T * Ti;
    T_i(:,:,j+2) = T;
end
T_e = T;

J1 = Jacobian_translation(T_i(:,:,1), T_e);%平移关节Jacobian
J_i(:, 1) = J1;
%旋转关节Jacobian
for j = 2:25
    J_ij = Jacobian_rotate(T_i(:,:,j), T_e);
    J_i(:, j) = J_ij;
end



%计算平移关节的Jacobian
function J_i = Jacobian_translation(T_0_i, T_0_e)
z_i1 = T_0_i(1:3,3);
p_e = T_0_e(1:3,4);
p_i = T_0_i(1:3,4);
J_i = [z_i1;[0;0;0];];
end

%计算旋转关节的Jacobian
function J_i = Jacobian_rotate(T_0_i, T_0_e)
z_i1 = T_0_i(1:3,3);
p_e = T_0_e(1:3,4);
p_i = T_0_i(1:3,4);
J_i = [cross(z_i1, p_e-p_i); z_i1];
end

%计算关节α的变换矩阵T (平移h1+旋转α)
function T_i = forward_kinematics_alpha(alpha, beta, L, h1, h2)
T_i = [cos(alpha), 0, sin(alpha), 0;
    sin(alpha), 0, -cos(alpha), 0;
    0, 1, 0, 0;
    0, 0, 0, 1];
end

%计算关节β的变换矩阵T (旋转β+平移h2+平移L)
function T_i = forward_kinematics_beta(alpha, beta, L, h1, h2)
T_i = [cos(beta), 0, -sin(beta), (L+h1+h2)*cos(beta);
    sin(beta), 0, cos(beta), (L+h1+h2)*sin(beta);
    0, -1, 0, 0;
    0, 0, 0, 1];
end

