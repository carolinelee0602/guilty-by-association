clear
SPM=[];
%datapfad='/data3/LiZhiai/beijing_fmri/CCG_SPM/first_level/Model_merge/';% /data3/LiZhiai/beijing_fmri/CCG_SPM/first_level/Model_forresponsibility
datapfad='/data3/LiZhiai/beijing_fmri/CCG_SPM/first_level/Model_forresponsibility/';
% subjects={ 'caiqiang_s101' 'caiqiang_s103' 'caiqiang_s106' 'caiqiang_s107' 'caiqiang_s108' 'caiqiang_s109' 'caiqiang_s110' 'caiqiang_s111' 'caiqiang_s112' 'caiqiang_s113' 'caiqiang_s114' 'caiqiang_s115' 'caiqiang_s116'  'caiqiang_s117' 'caiqiang_s118' 'caiqiang_s119' 'caiqiang_s120' 'caiqiang_s121' 'caiqiang_s122' 'caiqiang_s123' 'caiqiang_s125' 'caiqiang_s127'  'caiqiang_s128' 'caiqiang_s129' 'caiqiang_s130' 'caiqiang_s131' }; 
Beta_outcome1=[];
Beta_outcome3=[];
Beta_outcome5=[];
Beta_outcome7=[];

Betas=zeros(31,4);

SubList = dir(fullfile(datapfad,'CCG*'));
nrsub=length(SubList);

for subnr=1:nrsub

	VP_nr=fullfile(datapfad,SubList(subnr).name);
	datapath= VP_nr
    
    %  cnames={'fix_solo' 'fix_mix' 'fix_dd' 'fix_cc' 'other_consider_whole' 'question_solo' 'question_mix' 'question_dd' 'question_cc' 'recon' }; 

    P1 = fullfile(datapath,'beta_0001.img'); 
    P2 = fullfile(datapath,'beta_0003.img'); 
    P3 = fullfile(datapath,'beta_0005.img'); 
    P4 = fullfile(datapath,'beta_0007.img'); 
    
    P5 = fullfile(datapath,'beta_0023.img'); 
    P6 = fullfile(datapath,'beta_0025.img'); 
    P7 = fullfile(datapath,'beta_0027.img'); 
    P8 = fullfile(datapath,'beta_0029.img'); 
	
    
    if ~(subnr == 1 || subnr == 20)
    
    
    P9 = fullfile(datapath,'beta_0045.img'); 
    P10 = fullfile(datapath,'beta_0047.img'); 
    P11 = fullfile(datapath,'beta_0049.img'); 
    P12 = fullfile(datapath,'beta_0051.img');
    
    
    V9=spm_vol(P9);
	V10=spm_vol(P10);
    V11=spm_vol(P11);
	V12=spm_vol(P12);
    
    end

	V1=spm_vol(P1);
	V2=spm_vol(P2);
	V3=spm_vol(P3);
	V4=spm_vol(P4);	
    V5=spm_vol(P5);
	V6=spm_vol(P6);
	V7=spm_vol(P7);
	V8=spm_vol(P8);	
    

    

%center = [10 2 -2]; % NAcc
% center = [-8 47 3]; %rACC
% center = [0 -28 -10]; %PAG

% center = [-3 20 -11];%vmPFC chosen U inside
%center = [-9 35 31];%ACC
%center = [-30 51 -10];%OFC
%center = [36 26 7];%%aMCC
 center = [56 -50 18];

for x = 1:3
    for y =1:3
        for z = 1:3
    coord = [center(1) + 3* (x-2), center(2) + 3* (y-2),center(3) + 3* (z-2)];

            
    MNI=coord;
	coord = V1(1).mat\[MNI';ones(1,size(MNI',2))];
    
        if subnr == 1 || subnr == 20
   
    Val_outcome1 = (spm_sample_vol(V1(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V5(1),coord(1),coord(2),coord(3),0))/2;%%%merge the two runs together
    
    Val_outcome3 = (spm_sample_vol(V2(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V6(1),coord(1),coord(2),coord(3),0))/2;
    
    Val_outcome5 = (spm_sample_vol(V3(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V7(1),coord(1),coord(2),coord(3),0))/2;
    
    Val_outcome7 = (spm_sample_vol(V4(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V8(1),coord(1),coord(2),coord(3),0))/2;
  
        else
             
    Val_outcome1 = (spm_sample_vol(V1(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V5(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V9(1),coord(1),coord(2),coord(3),0))/3;
    
    Val_outcome3 = (spm_sample_vol(V2(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V6(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V10(1),coord(1),coord(2),coord(3),0))/3;
    
    Val_outcome5 = (spm_sample_vol(V3(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V7(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V11(1),coord(1),coord(2),coord(3),0))/3;
    
    Val_outcome7 = (spm_sample_vol(V4(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V8(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V12(1),coord(1),coord(2),coord(3),0))/3;
    
%     Val_Ra = (spm_sample_vol(V1(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V3(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V5(1),coord(1),coord(2),coord(3),0))/3;
%     
%     Val_Ru = (spm_sample_vol(V2(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V4(1),coord(1),coord(2),coord(3),0)+ spm_sample_vol(V6(1),coord(1),coord(2),coord(3),0))/3;
  
           
        end
        
        


    Betas(subnr,1)=Betas(subnr,1)+ Val_outcome1;
    Betas(subnr,2)=Betas(subnr,2)+ Val_outcome3;
    Betas(subnr,3)=Betas(subnr,3)+ Val_outcome5;
    Betas(subnr,4)=Betas(subnr,4)+ Val_outcome7;
        
        end;
    end
end
end
Betas=Betas/27;

