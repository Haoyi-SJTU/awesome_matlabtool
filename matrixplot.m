function matrixplot(data,varargin)
%   根据实值矩阵绘制色块图，用丰富的颜色和形状形象的展示矩阵元素值的大小。
%   matrixplot(data, 'PARAM1',val1, 'PARAM2',val2, ...)
%          用成对出现的参数名/参数值控制色块的各项属性。可用的参数名/参数值如下：
%          'FigShape' --- 设定色块的形状，其参数值为：
%                'Square'  --- 方形（默认）
%                'Ellipse' --- 椭圆形
%          'FigSize' --- 设定色块的大小，其参数值为：
%                'Full'    --- 最大色块（默认）
%                'Auto'    --- 根据矩阵元素值自动确定色块大小
%          'FillStyle' --- 设定色块填充样式，其参数值为：
%                'Fill'    --- 填充色块内部（默认）
%                'NoFill'  --- 不填充色块内部
%          'DisplayOpt' --- 设定是否在色块中显示矩阵元素值，其参数值为：
%                'On'      --- 显示矩阵元素值（默认）
%                'Off'     --- 不显示矩阵元素值
%          'TextColor' --- 设定文字的颜色，其参数值为：
%                表示单色的字符（'r','g','b','y','m','c','w','k'）,默认为黑色
%                1行3列的红、绿、蓝三元色灰度值向量（[r,g,b]）
%                'Auto'    --- 根据矩阵元素值自动确定文字颜色
%          'ColorBar' --- 设定是否显示颜色条，其参数值为：
%                'On'      --- 显示颜色条
%                'Off'     --- 不显示颜色条（默认）
%          'Grid' --- 设定是否显示网格线，其参数值为：
%                'On'      --- 显示网格线（默认）
%                'Off'     --- 不显示网格线
%

% 解析成对出现的参数名/参数值
[FigShape,FigSize,FigStyle,FillStyle,DisplayOpt,TextColor,~, YVarNames,ColorBar,GridOpt] = parseInputs(varargin{:});

% 产生网格数据
[m,n] = size(data);
[x,y] = meshgrid(0:n,0:m);
data = data(:);
maxdata = nanmax(data);
mindata = nanmin(data);
rangedata = maxdata - mindata;
if isnan(rangedata)
    warning('MATLAB:warning1','请检查您输入的矩阵是否合适！');
    return;
end
z = zeros(size(x))+0.2;
sx = x(1:end-1,1:end-1)+0.5;
sy = y(1:end-1,1:end-1)+0.5;

sx = sx(:);
sy = sy(:);
id = isnan(sx) | isnan(data);
sx(id) = [];
sy(id) = [];
data(id) = [];

% 绘图
figure('color','w','units','normalized','pos',[1.38, 0.13, 0.53, 0.37]);
axes('units','normalized');%,'pos',[0.1,0.022,0.89,0.85]);
set(gca, 'Fontname', 'Times New Roman','FontSize',12);

% 参考网格线
if strncmpi(GridOpt,'On',2)
    mesh(x,y,z, 'EdgeColor',[0.7,0.7,0.7], 'FaceAlpha',0, 'LineWidth',0.5);   
end
hold on;

% axis equal;

% view(2);
% 设置X轴和Y轴刻度位置及标签
% set(gca,'Xtick',(1:n)-0.5,...
%     'XtickLabel',XVarNames,...
%     'XAxisLocation','top',...
%     'YDir','reverse',...
%     'Xcolor',[0.7,0.7,0.7],...
%     'TickLength',[0,0]);
set(gca,'Ytick',(1:m)-0.5,...
    'YtickLabel',YVarNames,...
    'YDir','reverse',...%设置y轴反向
    'Ycolor',[0.7,0.7,0.7], 'TickLength',[0,0]);
axis off

% 绘制填充色块
if strncmpi(FillStyle,'Fill',3)
    MyPatch(sx',sy',data',FigShape,FigSize);
end

% 在色块上显示数值
if strncmpi(DisplayOpt,'On',2)
    str = num2str(data,'%4.2f');
    scale = 0.1*max(n/m,1)/(max(m,n)^0.55);
    if strncmpi(TextColor,'Auto',3)
        ColorMat = get(gcf,'ColorMap');
        nc = size(ColorMat,1);
        cid = fix(mapminmax(data',0,1)*nc)+1;
        cid(cid<1) = 1;
        cid(cid>nc) = nc;
        TextColor = ColorMat(cid,:);
        for i = 1:numel(data)
            text(sx(i),sy(i),0.1,str(i,:), 'FontUnits','normalized', 'FontSize',scale,...
                'fontweight','bold','HorizontalAlignment','center', 'Color',TextColor(i,:));
        end
    else
        text(sx,sy,0.1*ones(size(sx)),str, 'FontUnits','normalized', 'FontSize',scale,...
            'fontweight','bold', 'HorizontalAlignment','center', 'Color',TextColor);
    end
end

% 设置X轴和Y轴刻度标签的缩进方式

axes(gca);
xstr = {'0','50','100','150','200','250'}; %X轴字符串
xtick = [0,50,100,150,200,250];
xl = xlim(gca);


ystr = {'q_1-q_2';'q_3-q_4';'q_5-q_6';'q_7-q_8';'q_9-q_{10}';'q_{11}-q_{12}';'q_{13}-q_{14}';'q_{15}-q_{16}';'q_{17}-q_{18}';'q_{19}-q_{20}';'q_{21}-q_{22}';'q_{23}-q_{24}'};
ytick = get(gca,'YTick');
yl = ylim(gca);

set(gca,'XTickLabel',[],'YTickLabel',[]);

x = zeros(size(ytick)) + xl(1) - range(xl)/50;
y = zeros(size(xtick)) + yl(2) + range(yl)/30;
set(gca, 'Fontname', 'Times New Roman','FontSize',12);
text(xtick,y, xstr, 'Interpreter', 'tex',  'FontSize',12, 'Fontname', 'Times New Roman', 'HorizontalAlignment','left');
text(x,ytick, ystr, 'interpreter', 'tex',  'FontSize',12, 'Fontname', 'Times New Roman', 'HorizontalAlignment','right');
text((xtick(3)+xtick(4))/2,y(1)+0.6, 'time series', 'FontSize',12, 'Fontname', 'Times New Roman','HorizontalAlignment','left');

% 添加颜色条
if strncmpi(ColorBar,'On',2)
    c = colorbar('Direction','reverse');%'Location','East',
    c.Position = [0.82,0.105,0.0197,0.82];
    bar_pos = get(c, 'position');
    ylabel(c,'IE''s Area','Rotation',90,'Position',[bar_pos(1)+60*bar_pos(3), bar_pos(1)+40*bar_pos(3)]);
end
end




%  根据散点数据绘制3维色块图子函数
function  MyPatch(x,y,z,FigShape,FigSize)  
%     x,y,z是实值数组，用来指定色块中心点三维坐标。FigShape是字符串变量，用来指定色块形状。
%     xy是色块坐标，z是色块对应值
%     FigSize是字符串变量，用来指定色块大小。
%Example：
%     x = rand(10,1);
%     y = rand(10,1);
%     z = rand(10,1);
%     MyPatch(x,y,z,'s','Auto');

if numel(x) ~= numel(z) || numel(y) ~= numel(z)
    error('坐标应等长');
end

if strncmpi(FigSize,'Auto',3) && ~strncmpi(FigShape,'Ellipse',1)
    id = (z == 0);
    x(id) = [];
    y(id) = [];
    z(id) = [];
end
if isempty(z)
    return;
end

% 求色块顶点坐标
rab1 = ones(size(z));
maxz = max(abs(z));
if maxz == 0
    maxz = 1;
end
rab2 = abs(z)/maxz;
if strncmpi(FigShape,'Square',1)% 方形
    if strncmpi(FigSize,'Full',3)%满填充
        r = rab1;
    else
        r = sqrt(rab2);%按数值填充
    end
    SquareVertices(x,y,z,r);
else
    % 椭圆形
    a = 0.48 + rab2*(0.57-0.48);
    b = (1-rab2).*a;
    EllipseVertices(x,y,z,a,b);
end
end


% 求色块顶点坐标，绘制色块
function SquareVertices(x,y,z,r)
% 方形
hx = r/2;
hy = hx;
Xp = [x-hx;x-hx;x+hx;x+hx;x-hx];%四个角的x坐标
Yp = [y-hy;y+hy;y+hy;y-hy;y-hy];%四个角的y坐标
Zp = repmat(z,[5,1]);
patch(Xp,Yp,Zp,'FaceColor','flat','EdgeColor','flat');
end

% 椭圆形
function EllipseVertices(x,y,z,a,b)
t = linspace(0,2*pi,30)';
m = numel(t);
t0 = -sign(z)*pi/4;
t0 = repmat(t0,[m,1]);
x0 = cos(t)*a;
y0 = sin(t)*b;
Xp = repmat(x,[m,1]) + x0.*cos(t0) - y0.*sin(t0);
Yp = repmat(y,[m,1]) + x0.*sin(t0) + y0.*cos(t0);
Zp = repmat(z,[m,1]);
patch(Xp,Yp,Zp,'FaceColor','flat','EdgeColor','flat');
end

%  解析输入参数子函数1
function [FigShape,FigSize,FigStyle,FillStyle,DisplayOpt,TextColor, XVarNames,YVarNames,ColorBar,GridOpt] = parseInputs(varargin)

if mod(nargin,2)~=0
    error('输入参数个数不对，应为成对出现');
end
pnames = {'FigShape','FigSize','FigStyle','FillStyle','DisplayOpt',...
    'TextColor','XVarNames','YVarNames','ColorBar','Grid'};
dflts =  {'Square','Full','Auto','Fill','On','k','','','Off','On'};
[FigShape,FigSize,FigStyle,FillStyle,DisplayOpt,TextColor,XVarNames,...
    YVarNames,ColorBar,GridOpt] = parseArgs(pnames, dflts, varargin{:});

validateattributes(FigShape,{'char'},{'nonempty'},mfilename,'FigShape');
validateattributes(FigSize,{'char'},{'nonempty'},mfilename,'FigSize');
validateattributes(FigStyle,{'char'},{'nonempty'},mfilename,'FigStyle');
validateattributes(FillStyle,{'char'},{'nonempty'},mfilename,'FillStyle');
validateattributes(DisplayOpt,{'char'},{'nonempty'},mfilename,'DisplayOpt');
validateattributes(TextColor,{'char','numeric'},{'nonempty'},mfilename,'TextColor');
validateattributes(XVarNames,{'char','cell'},{},mfilename,'XVarNames');
validateattributes(YVarNames,{'char','cell'},{},mfilename,'YVarNames');
validateattributes(ColorBar,{'char'},{'nonempty'},mfilename,'ColorBar');
validateattributes(GridOpt,{'char'},{'nonempty'},mfilename,'Grid');
if ~any(strncmpi(FigShape,{'Square','Circle','Ellipse','Hexagon','Dial'},1))
    error('形状参数只能为Square, Circle, Ellipse, Hexagon, Dial 之一');
end
if ~any(strncmpi(FigSize,{'Full','Auto'},3))
    error('图形大小参数只能为Full, Auto 之一');
end
if ~any(strncmpi(FigStyle,{'Auto','Tril','Triu'},4))
    error('图形样式参数只能为Auto, Tril, Triu 之一');
end
if ~any(strncmpi(FillStyle,{'Fill','NoFill'},3))
    error('图形填充样式参数只能为Fill, NoFill 之一');
end
if ~any(strncmpi(DisplayOpt,{'On','Off'},2))
    error('显示数值参数只能为On，Off 之一');
end
if ~any(strncmpi(ColorBar,{'On','Off'},2))
    error('显示颜色条参数只能为On，Off 之一');
end
if ~any(strncmpi(GridOpt,{'On','Off'},2))
    error('显示网格参数只能为On，Off 之一');
end
end

%  解析输入参数子函数2
function [varargout] = parseArgs(pnames,dflts,varargin)
%   $Revision: 1.1.6.2 $  $Date: 2011/05/09 01:27:26 $
% Initialize some variables
nparams = length(pnames);
varargout = dflts;
setflag = false(1,nparams);
unrecog = {};
nargs = length(varargin);

dosetflag = nargout>nparams;
dounrecog = nargout>(nparams+1);

% Must have name/value pairs
if mod(nargs,2)~=0
    m = message('stats:internal:parseArgs:WrongNumberArgs');
    throwAsCaller(MException(m.Identifier, '%s', getString(m)));
end

% Process name/value pairs
for j=1:2:nargs
    pname = varargin{j};
    if ~ischar(pname)
        m = message('stats:internal:parseArgs:IllegalParamName');
        throwAsCaller(MException(m.Identifier, '%s', getString(m)));
    end

    mask = strncmpi(pname,pnames,length(pname)); % look for partial match
    if ~any(mask)
        if dounrecog
            % if they've asked to get back unrecognized names/values, add this
            % one to the list
            unrecog((end+1):(end+2)) = {varargin{j} varargin{j+1}};
            continue
        else
            % otherwise, it's an error
            m = message('stats:internal:parseArgs:BadParamName',pname);
            throwAsCaller(MException(m.Identifier, '%s', getString(m)));
        end
    elseif sum(mask)>1
        mask = strcmpi(pname,pnames); % use exact match to resolve ambiguity
        if sum(mask)~=1
            m = message('stats:internal:parseArgs:AmbiguousParamName',pname);
            throwAsCaller(MException(m.Identifier, '%s', getString(m)));
        end
    end
    varargout{mask} = varargin{j+1};
    setflag(mask) = true;
end

% Return extra stuff if requested
if dosetflag
    varargout{nparams+1} = setflag;
    if dounrecog
        varargout{nparams+2} = unrecog;
    end
end
end

