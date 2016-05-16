function [  ] = atg(name )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if(nargin==0)
    name='elise';
end
filename=sprintf('%s\\%s.wav',name,name);
T=16;Pitch_Range=440*5*2;Sampling_Rate=44100;%Time Seperation
wav=wavread(filename);
[Length,Channel]=size(wav);
wav_I=zeros(Length,1);
Bar_Length=floor(Sampling_Rate/T);Pitch_L=1;Pitch_H=floor(Pitch_Range*2/T);%Bar_Length;
Time=floor(Length/Bar_Length);
DCT=zeros(Time,Pitch_H-Pitch_L+1);
AMP=zeros(Time,1);
bar_head=1;
for t=1:Time
     bar=wav(bar_head:(bar_head+Bar_Length-1));
     amp=mean(sum(bar.^2));
     AMP(t)=amp;
     dctall=dct(bar);
    % dctpart=zeros(1,Bar_Length);
    % dctpart(Pitch_L:Pitch_H)=dctall(Pitch_L:Pitch_H);
    % wav_I(bar_head:(bar_head+Bar_Length-1))=idct(dctpart);
     DCT(t,1:Pitch_H-Pitch_L+1)=dctall(Pitch_L:Pitch_H);
     wav_I(bar_head:(bar_head+Bar_Length-1))=idct(dctall);
     bar_head=bar_head+Bar_Length;
end
AMP=AMP/max(AMP);
MAX=max(max(DCT));MIN=min(min(DCT));
DCT=(DCT-MIN)/(MAX-MIN);
%cmap=jet(Pitch_H-Pitch_L+1);
%imshow(DCT,cmap,'InitialMagnification','fit');
dct_out=sprintf('%s\\%s_dct.dat',name,name);
amp_out=sprintf('%s\\%s_amp.dat',name,name);
save( dct_out, 'DCT','-ascii', '-tabs');
save( amp_out, 'AMP','-ascii', '-tabs');

wav_I=wav_I*100;
wavwrite(wav_I,Bar_Length,sprintf('%s\\%s_idct.wav',name,name));
% fclose(amp_out);fclose(dct_out);
end

