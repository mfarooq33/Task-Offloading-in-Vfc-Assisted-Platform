function[p,Tslot] = satu_iteration_platoon(N,W,m)

% %测试参数
% clear;
% N=4;
% a = 1;
% W = 3;
% m = 1;

%*****************迭代*****************
tao=0.0001;
for i =1:10000
    p = 1-(1-tao)^(N-1);%——外部碰撞概率
    tao1 = 2*(1-2*p)/((1-2*p)*(W+1)+p*W*(1-(2*p)^m)); %传输发送概率
    conv = abs(tao1-tao);
    if conv<10^(-12)
        break;
    else
        tao=tao1;
    end
end
%**************************************

Pidle = (1-tao)^N;  %空闲概率
Ps =  N*tao*(1-tao)^(N-1);   %成功概率
Pc = 1-Ps-Pidle;    %冲突概率

%DCF参数
Rate=11;
slot=20;
DIFS=50;
SIFS=10;
delta=2;
Header=(272+128)/Rate;   %——————272 + 128 = MACh + PHYh  ??为什么要除以rate
L=64*30/Rate;   %----- ?? 为什么要除以rate

EP=L;

ACK=(112+128)/Rate;%128--192
Ts=Header+EP+SIFS+ACK+DIFS+2*delta;
Tc=Ts;

Tslot = Pidle*slot+Pc*Tc+Ps*Ts;      %-----Tslot平均时隙时间；slot为一个时隙的时间；
