%%Apply pattern expression to new data with mask
clear
fPath = '/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/weight_map/';

%%%% try to apply Luke's weight map to the four rating images
%   pattern_mask = fmri_data([fPath 'SVM_ingroup_guilt_withoutmask.nii']);
%   pattern_mask = fmri_data([fPath 'YHB_SXPOvsSXPX_map_mask.img']); %YHB_SXPOvsSXPX_map_wholebrain  SVM_personalguilt57_responsibility
  pattern_mask = fmri_data([fPath 'SVM_personalguilt57_responsibility_mask.nii']);
%mask = '/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/out3_out7.img';
%mask = '/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/out1_out5(mask).img';
   f3 = filenames('/data3/LiZhiai/MVPA/6_SXPO/*con*.img');%fristlevel contrast: flexible factorial
   f4 = filenames('/data3/LiZhiai/MVPA/7_SXPX/*con*.img');
%   f3 = filenames('/data3/LiZhiai/beijing_fmri/CCG_SPM/second_level/Model_forresponsibility/3_outcome3/*con*.img');%Model_forresponsibility
%   f4 = filenames('/data3/LiZhiai/beijing_fmri/CCG_SPM/second_level/Model_forresponsibility/7_outcome7/*con*.img');%Model_forresponsibility


data3 = fmri_data(f3);
data4 = fmri_data(f4);
% pexp1 = apply_mask(data1,pattern_mask,'pattern_expression','ignore_missing') ; %testing slope + intercept
% pexp2 = apply_mask(data2,pattern_mask,'pattern_expression','ignore_missing') ; %testing slope + intercept
pexp3 = apply_mask(data3,pattern_mask,'pattern_expression','ignore_missing') ; %testing slope + intercept
pexp4 = apply_mask(data4,pattern_mask,'pattern_expression','ignore_missing') ; %testing slope + intercept

pexp = [];
pexp =[pexp3,pexp4];
%pexp =[pexp1,pexp2,pexp3,pexp4];
save('/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/weight_map/pexp3.mat','pexp3');
save('/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/weight_map/pexp4.mat','pexp4');

