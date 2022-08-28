% ��ͬ���ȼ�����Ĵ���ʱ�ӣ�ƽ��MACʱ�ӣ�
% ���������Ӳ��ɷֲ�
function [Ts0,Ts1] = mean_delay(Ncs,daodalv_0,daodalv_1)
% Ncs = 8;
% daodalv_0=2;
% daodalv_1=3;% 5pks/s %AC1



slot_time=13*(10^(-6));%ʱ϶��С��ת������

PHYh=48;MACh=112;Pl=1920*8;%ȫ����bitsΪ��λ
%Rd=6*10^6;
Rd=3*10^6;%����3����ֵ�Ƚϴ�
Rb=10^6;tran_time=10^(-6);
Ttr=(PHYh/Rb)+((MACh+Pl)/Rd)+2*tran_time;%����ʱ��㶨

Pa0=1-exp(-daodalv_0*slot_time); %AC0�������
Pa1=1-exp(-daodalv_1*slot_time); %AC1�������

cove = 1e-6;    %�������

%**********************802.11p���ܲ���************%
W0_0=4;%AC0��ʼ�������ڴ�С
W1_0=8;W1_1=2*W1_0;       %������ɶ������

M1=1;%AC1�ɷ�����������

L_limit=1;              % �������������ʱ����
L1=L_limit+M1;  % �����ش�����

AIFSN0=2;
AIFSN1=3;

SIFS=32*(10^(-6)); 
AIFS0=SIFS+AIFSN0*slot_time;
AIFS1=SIFS+AIFSN1*slot_time;

A0=0;
A1=AIFSN1-AIFSN0;
%{
pv0=0;
pv1=0;

w0=0;
w1=0;

tao0=0;
tao1=0;
tao=0;

PK=0;

pb01=0;%pb���ֵ
pb11=0;

b0_0=0;
b1_0_0=0;

g1_1=0;
g1_2=0;
g1_3=0;
g1_4=0;
g1_5=0;

p01=0;%luo0����ֵ
p11=0;

Ts0=0;
Ds0=0;

Ts1=0;
Ds1=0;
%}
 syms z;
 %*********************************************************** ���õ����������ֵ������
 %***********************************************************
 %��luo��ֵ
  p0=1-exp(-daodalv_0*slot_time);%luo����ʼֵ
  p1=1-exp(-daodalv_1*slot_time);

  pb0=0.2;%���ֵ���������ʡ�
  pb1=0.3;

for u=1:100;
for j=1:100;
b0_0=(0.5*(W0_0+1)/(1-pb0)+(1-p0)/Pa0)^(-1); 
w0=b0_0;  %AC0�ڲ��������

pv0=0;     %AC0�ڲ���ײ����
pv1=w0;   % AC1�ڲ���ײ̫��

g1_1=(1-(pv1)^(L1+1))/(1-pv1);
g1_2=(W1_0-1)/(2*(1-pb1));
g1_3=(W1_0*pv1*(1-(2*pv1)^M1))/((1-pb1)*(1-2*pv1));
g1_4=((2^(M1-1))*W1_0*(1-(pv1)^(L1-M1))*(pv1)^(M1+1))/((1-pb1)*(1-pv1));
g1_5=(1-p1)/Pa1;
b1_0_0=(g1_1+g1_2+g1_3+g1_4+g1_5)^(-1);
w1=g1_1*b1_0_0;

tao0=w0;
tao1=w1*(1-pv1);
tao=tao0+tao1;

%   �µ���������ֵ
PK=(1-tao)^(Ncs-1);
pb01=1-(PK*(1-w1))^(A0+1);
pb11=1-(PK*(1-w0))^(A1+1);   %13-1

%   �¾���������֮���ƫ��
piancha1=abs(pb01-pb0);%pb����������
piancha2=abs(pb11-pb1);

    if(piancha1 > cove && piancha2 > cove )  % �����󣬼���ѭ��
         pb0=pb01;
         pb1=pb11;
    else
        break;
    end
end
TR=z^Ttr; %ʽ18

% % % %**********************������������AC0������������������������************%
 H0=(1-pb0)*(z^slot_time)+pb0*(z^(Ttr+AIFS0));%ʽ19,ÿһ��״̬��ƽ��ʱ��
 B0_0=0;
 %��B0,0(Z)
  for i=0:W0_0-1;
      B0_0=B0_0+(1/W0_0)*(H0)^i;         %ʽ20
  end
  PTs0=TR*B0_0;                          %ʽ21����PTs0
  diff0_0=diff(PTs0);   %һ�׵�  
  diff0_1=diff(PTs0,2);%���׵�           %���ֵ������          %ʽ22,��ֵ
  
  Ts0=subs(diff0_0,z,1);      %AC0ʱ�Ӿ�ֵ����λ����
  Ds0=subs(diff0_1,z,1)+Ts0-(Ts0)^2; %����
  
  %     �µķ����������ʣ�luo
  p01=daodalv_0*Ts0;%���luo��������ĳ��AC0ʱ��
  
  piancha3=abs(p01-p0);
 %������������������������������������AC1��������������������������������%
  H1=(1-pb1)*(z^slot_time)+pb1*(z^(Ttr+AIFS1));
  guodu_jia10=0;guodu_jia11=0;

  for i=0:W1_0-1
      guodu_jia10=guodu_jia10+(H1)^i;%��ߴ�W1_0-1
  end
  
 for i=0:W1_1-1
     guodu_jia11=guodu_jia11+(H1)^i;%��ߴ�W1_1-1
 end


%  ��B1,0(z)
    B1_0=(1/W1_0)*guodu_jia10;         
%   ��B1,1(z)
    B1_1=(1/W1_1)*guodu_jia11;         
%   ��B1,2(z)
    B1_2=B1_1;   
    
% %   ��B1,3(z)
%     B1_3=B1_1; 
% %   ��B1,4(z)
%     B1_4=B1_1; 
   
  % L = 1 + 3��
 % L = 1 + 1;
   PTs1=(1-pv1)*TR*(B1_0+pv1*B1_0*B1_1+((pv1)^2)*B1_0*B1_1*B1_2)+((pv1)^(L1+1))*B1_0*B1_1*B1_2;
  % PTs1=(1-pv1)*TR*(B1_0+pv1*B1_0*B1_1+((pv1)^2)*B1_0*B1_1*B1_2+((pv1)^3)*B1_0*B1_1*B1_2*B1_3+((pv1)^4)*B1_0*B1_1*B1_2*B1_3*B1_4)+((pv1)^(L1+1))*B1_0*B1_1*B1_2*B1_3*B1_4;
   diff1_0=diff(PTs1);   %һ�׵�  
   diff1_1=diff(PTs1,2);%���׵�           %���ֵ������          %ʽ22,��ֵ
   
   Ts1=subs(diff1_0,z,1);      %AC0ʱ�Ӿ�ֵ
   Ds1=subs(diff1_1,z,1)+Ts1-(Ts1)^2; %����   
   
   p11=daodalv_1*Ts1;%���luo1
   piancha4=abs(p11-p1);
   
   if(piancha3 < cove && piancha4 < cove)
        break;
   else     
         p0=p01; %p0������ʼluo
         p1=p11; 
   end   

end

