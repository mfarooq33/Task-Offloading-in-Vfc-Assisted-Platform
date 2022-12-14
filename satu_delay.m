
% function [lambda_t,T_save,D_access,D_process]=satu_delay(N,a,u_t)

function [lambda_t,T_save,D_access,D_process]=satu_delay(s_current,a,u_t)

% % 根据N求冲突概率
% s_current = {10,[2,1,1],'A'};
% a = 0;
% u_t = 30;

W = 3; %Wmin————
m = 1; % 重传次数
N =s_current{1,1}; %当前状态车辆个数

[p,Tslot] = satu_iteration(N,W,m,a);%p——碰撞概率；Tslot——平均时隙时间

EN1=(1-(m+1)*p^m+m*p^(m+1))/(2*(1-p)) + ((1-p)*(1-(2*p)^m)*W)/(1-2*p) - (1-p^m)*W/2;
EN2=0.5*(p^m)*(m+(2^m-1)*W + (2^m*W+1)/(1-p));
EN = (EN1 + EN2);
ED = EN*Tslot/1000000;    %单位s------传输一个子任务消耗的时延（学长用的）

%% 文中公式
% EN1=(1-(m+2)*p^(m+1)+(m+1)*p^(m+2))/(2*(1-p)) + ((1-p)*(1-(2*p)^(m+1))*W)/(1-2*p) - (1-p^(m+1))*W/2;
% EN2=0.5*(p^(m+1))*( m+1 + ( (2^(m+1)) - 1 )*W + ( (((2^m)*W) + 1)*(2-p) )/(1-p) );
% EN = (EN1 + EN2);
% ED = EN*Tslot/1000000;    %单位s------传输一个子任务消耗的时延


% 本地执行时间
T_local =0.1;   %单位s

% 求到达率和节省时延
if a <= 0       %动作a=0/-1    %根据动作计算平均到达率
    a_total=s_current{1,2}(1)+s_current{1,2}(2)+s_current{1,2}(3);
    if a_total==0
        p1=1/3;
        p2=1/3; %————一个任务分配给两个资源单元处理的概率
        p3=1/3;
%         pt1=0;
%         pt2=0;
%         pt3=0;
    else
        p1=s_current{1,2}(1)/a_total;
        p2=s_current{1,2}(2)/a_total;%————一个任务分配给两个资源单元处理的概率
        p3=s_current{1,2}(3)/a_total;
%         pt1=s_current{1,2}(1)/a_total;
%         pt2=s_current{1,2}(2)/a_total;
%         pt3=s_current{1,2}(3)/a_total;
    end
%     u_t1 = 1*f0/c;
%     u_t2 = 2*f0/c;
%     u_t3 = 3*f0/c;
%     u_t = pt1*u_t1+pt2*u_t2+pt3*u_t3;
    
    lam1 = 1/(ED);
    lam2 = 1/(2*ED);
    lam3 = 1/(3*ED);
    lambda_t = p1*lam1+p2*lam2+p3*lam3;
    D_process = 0;
    D_access = 0;
    T_save = 0;
else    %动作a=1/2/3
    D_process = 1/(a*u_t);

    D_access = a*ED;  %单位s
    lambda_t = 1/D_access;   %每s到达的请求个数%
    T_save = T_local-D_access-D_process;    %s
end
T_save = T_save*1000;  %ms
% D_access
% D_process
 lambda_t= lambda_t/30;



