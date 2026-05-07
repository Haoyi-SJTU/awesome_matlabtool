# MATLAB Tool Functions

![MATLAB Version](https://img.shields.io/badge/MATLAB-R2023a%2B-orange)
![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)

本项目存放MATLAB工具函数。

## MailMe
向指定邮箱发送指定内容和标题的邮件。方便监测程序运行的结果
输入：
   mailtitle 邮件题目 
   mailcontent 邮件内容


## matrixplot
  根据实值矩阵绘制色块图，用丰富的颜色和形状形象的展示矩阵元素值的大小。
用成对出现的参数名/参数值控制色块的各项属性。参数名/参数值如下：
         

'FigShape' --- 设定色块的形状，其参数值为：
         
  - 'Square'  --- 方形（默认）
  - 'Ellipse' --- 椭圆形
               
 'FigSize' --- 设定色块的大小，其参数值为：
         
  - 'Full'    --- 最大色块（默认）
  - 'Auto'    --- 根据矩阵元素值自动确定色块大小

 'FillStyle' --- 设定色块填充样式，其参数值为：
 
  - 'Fill'    --- 填充色块内部（默认）
  - 'NoFill'  --- 不填充色块内部

'DisplayOpt' --- 设定是否在色块中显示矩阵元素值，其参数值为：
  - 'On'      --- 显示矩阵元素值（默认）
  - 'Off'     --- 不显示矩阵元素值
 
'TextColor' --- 设定文字的颜色，其参数值为：表示单色的字符（'r','g','b','y','m','c','w','k'）,默认为黑色。1行3列的红、绿、蓝三元色灰度值向量（[r,g,b]）。
  - 'Auto'    --- 根据矩阵元素值自动确定文字颜色

'ColorBar' --- 设定是否显示颜色条，其参数值为：
 - 'On'      --- 显示颜色条
 -  'Off'     --- 不显示颜色条（默认）

 'Grid' --- 设定是否显示网格线，其参数值为：
    
- 'On'      --- 显示网格线（默认）
- 'Off'     --- 不显示网格线

## IntFcn

频域积分与时域积分的封装。

频域积分是在指定的频段上对信号做积分，可以理解为先对信号做带通滤波再积分。（实际不是这么实现的）

调用到函数`IntFcn_Time`（时域积分实现），`iomega`（频域积分实现）

## Jacobi

计算雅克比矩阵的函数表达式。

输出：
 - 输出1：符号表达式
 - 输出2：句柄函数
 - 输出3：函数 f 的变量(以元胞数组(cell)形式存放中，n × 1维)
 - 输出4：若输入点x0, 输出带入点后的值


## Jacobian_HRR

计算12节绳驱超冗余机器人的Jacobian矩阵，代码里把DH矩阵推导、雅克比矩阵推导封装成函数，并包含一个调用这些函数的例子

## test_relasense

通过MATLAB启动realsense相机（T2565相机），取出RGB图像和深度图。

## test_t265

读取在ROS环境中录制的realsense数据（T265相机）：解包，提取RGB图像、深度图、IMU，存储。用于录制数据包的是官方的realsense的ROS节点。


