%============================K�仯��ͼ�κÿ�
K = 4   % �������ơ��У����������������ơ� (4-10)  
M = 4;  % �����г�������

lambda_f =9;     %���������ʡ��롿
u_f = 8;            %�����뿪�ʡ��롿
lambda_p = 15;        %���񵽴��ʡ��롿

% �����뿪��  u_p = f/d ��λΪs
f0 = 560;  %===============================550����

f1 = 600;   %�����ͷ��
f2 = 660;  
f3 = 620; 
f4 = 650;
d =  30;  
%-------------------------------------------------------------------
A1 = [0.4074, 0.3065, 0.2857, 0.2437, 0.2519, 0.2831, 0.3141, ];  % ������
A2 = [0.1852, 0.1452, 0.1071, 0.0964, 0.1090, 0.1231, 0.1597, ];
A3 = [0.4074, 0.5484, 0.6071, 0.6599, 0.6391, 0.5938, 0.5262, ];

Case0 = [0.9036, 0.8797, 0.8671, 0.8491, 0.8583, 0.8747, 0.8902, ];  
Case1 = [0.0703, 0.0969, 0.1111, 0.1310, 0.1231, 0.1080, 0.0936, ];
Case2 = [0.0260, 0.0234, 0.0218, 0.0199, 0.0185, 0.0173, 0.0162, ];

% reward of system
rewardSMDP_part = [7.2218e+05, 1.4997e+06, 2.7769e+06, 4.5717e+06, 6.8112e+06, 9.4196e+06, 1.2166e+07, ];
GA_bian =         [3.8807e+04, 6.1762e+04, 9.2465e+04, 1.2976e+05, 1.7453e+05, 0.1111e+05, 2.9577e+05, ];
gap=1;
begin = 4; endNum = 10;

figure(2);
y=begin:1:endNum;
plot(y, A1, '-bo','linewidth',2);
hold on
plot(y, A2, '-cd','linewidth',2);   %��ɫ
hold on 
plot(y, A3, '-rs','linewidth',2);
set(gca,'xtick',begin:1:endNum);
%ylim([0.08,0.6])
legend('A1','A2','A3');
xlabel('�������Ŀ');
ylabel('�������ж�������'); 


figure(3);
y=begin:1:endNum;
plot(y, Case0, '-bp','linewidth',2);
hold on
plot(y, Case1, '-rd','linewidth',2);   %��ɫ
hold on 
plot(y, Case2, '-cs','linewidth',2);
% ylim([0.2,0.85])
% set(gca,'xtick',9:1:13);
set(gca,'xtick',begin:1:endNum);
legend('Case 0','Case 1','Case 2');
xlabel('�������Ŀ');
ylabel('��������'); 


% reward--------Ҫ����һ��������Ȼͼ�β��ÿ�,ͼ4û����һ������ͼ5����
figure(4);
y=begin:1:endNum;
plot(y, rewardSMDP_part, '-bp','linewidth',2);
hold on
plot(y, GA_bian, '-cd','linewidth',2);
set(gca,'xtick',begin:1:endNum);
legend('SMDP����','̰������');
xlabel('�������Ŀ');
ylabel('ϵͳ��������');

geshu=endNum - begin + 1;      %��һ��
for i=1:geshu
     discounted_SMDP(i)=log10(rewardSMDP_part(i));
     GA_unif(i)=log10(GA_bian(i));
end

figure(5);
t=begin:1:endNum;
plot(t,  discounted_SMDP, '-r^','linewidth',2);
hold on
plot(t,  GA_unif, '-bd','linewidth',2);
legend('SMDP����','̰������');
xlabel('�������Ŀ');
ylabel('ϵͳ��������');