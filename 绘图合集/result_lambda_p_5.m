%============================K变化，图形好看
K = 4   % 【车载云】中，车辆总数【车载云】 (4-10)  
M = 4;  % 车队中车辆总数

lambda_f =9;     %车辆到达率【秒】
u_f = 8;            %车辆离开率【秒】
lambda_p = 5;        %任务到达率【秒】

% 任务离开率  u_p = f/d 单位为s
f0 = 560;  %===============================550不行

f1 = 600;   %分配给头车
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  30;  
%-------------------------------------------------------------------
A1 = [0.7857, 0.4500, 0.3000, 0.2335, 0.2432, 0.2562, 0.2757, ];  % 车载云
A2 = [0.2143, 0.1500, 0.1222, 0.1078, 0.1216, 0.1388, 0.1584, ];
A3 = [0.0000, 0.4000, 0.5778, 0.6587, 0.6351, 0.6050, 0.5660, ];

Case0 = [0.9375, 0.9141, 0.8889, 0.8690, 0.8787, 0.8893, 0.9002, ];  
Case1 = [0.0365, 0.0625, 0.0893, 0.1110, 0.1028, 0.0934, 0.0836, ];
Case2 = [0.0260, 0.0234, 0.0218, 0.0199, 0.0185, 0.0173, 0.0162, ];

% reward of system
rewardSMDP_part = [1.0712e+06, 1.7403e+06, 2.6079e+06, 3.6074e+06, 4.7660e+06, 6.1189e+06,7.6740e+06, ];
GA_bian =         [3.9172e+04, 6.2151e+04, 9.3251e+04, 1.3159e+05, 1.7668e+05, 2.2923e+05, 2.9378e+05, ];
gap=1;
begin = 4; endNum = 10;

figure(2);
y=begin:1:endNum;
plot(y, A1, '-bo','linewidth',2);
hold on
plot(y, A2, '-cd','linewidth',2);   %蓝色
hold on 
plot(y, A3, '-rs','linewidth',2);
set(gca,'xtick',begin:1:endNum);
%ylim([0.08,0.6])
legend('A1','A2','A3');
xlabel('最大车辆数目');
ylabel('车载雾中动作概率'); 


figure(3);
y=begin:1:endNum;
plot(y, Case0, '-bp','linewidth',2);
hold on
plot(y, Case1, '-rd','linewidth',2);   %蓝色
hold on 
plot(y, Case2, '-cs','linewidth',2);
% ylim([0.2,0.85])
% set(gca,'xtick',9:1:13);
set(gca,'xtick',begin:1:endNum);
legend('Case 0','Case 1','Case 2');
xlabel('最大车辆数目');
ylabel('动作概率'); 


% reward--------要做归一化处理，不然图形不好看,图4没做归一化处理，图5做了
figure(4);
y=begin:1:endNum;
plot(y, rewardSMDP_part, '-bp','linewidth',2);
hold on
plot(y, GA_bian, '-cd','linewidth',2);
set(gca,'xtick',begin:1:endNum);
legend('SMDP策略','贪婪策略');
xlabel('最大车辆数目');
ylabel('系统长期收益');

geshu=endNum - begin + 1;      %归一化
for i=1:geshu
     discounted_SMDP(i)=log10(rewardSMDP_part(i));
     GA_unif(i)=log10(GA_bian(i));
end

figure(5);
t=begin:1:endNum;
plot(t,  discounted_SMDP, '-r^','linewidth',2);
hold on
plot(t,  GA_unif, '-bd','linewidth',2);
legend('SMDP策略','贪婪策略');
xlabel('最大车辆数目');
ylabel('系统长期收益');