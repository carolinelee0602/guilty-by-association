clear
%load data
% subjects={'sub101' 'sub102' 'sub103' 'sub104' 'sub105' 'sub106' 'sub107' 'sub109' 'sub110'  'sub112' 'sub113' 'sub114'  'sub115' 'sub116' 'sub117' 'sub119' 'sub120' 'sub121' 'sub122' 'sub123' 'sub124' 'sub125' 'sub126' 'sub127'};

%    f1 = filenames('/data3/LiZhiai/beijing_fmri/CCG_SPM/second_level/Model_forresponsibility/10_ingroup_involve/*con*.img');%fristlevel contrast: flexible factorial
%    f2 = filenames('/data3/LiZhiai/beijing_fmri/CCG_SPM/second_level/Model_forresponsibility/11_outgroup_involve/*con*.img');
    f1 = filenames('/data3/LiZhiai/beijing_fmri/CCG_SPM/second_level/Model_forresponsibility/3_outcome3/*con*.img');
    f2 = filenames('/data3/LiZhiai/beijing_fmri/CCG_SPM/second_level/Model_forresponsibility/7_outcome7/*con*.img');%fristlevel contrast: flexible factorial
  % f2 = filenames('/data3/LiZhiai/beijing_fmri/CCG_SPM/second_level/Model_forMVPA/2_outcome26/*con*.img');
   mask = '/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/LeftOFC_mask.nii';
% mask = '/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/weight_map/conjunctioninvolve_noninvolve.img';
% masks:/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/LeftOFC_mask.nii

 f = vertcat(f1,f2);
%  dat= fmri_data(f); %%%whole brain
%dat = fmri_data(f,ToM_mask);  %%% for mask
 dat = fmri_data(f,mask);
 nsub = length(f1);
% nsub = length(a);
label = [ones(nsub,1);-1*ones(nsub,1)];
% label = [-1*ones(nsub,1);ones(nsub,1)];
sub =  [1:nsub,1:nsub]';
dat.Y = label;
[cverr, stats, optout] = predict(dat, 'algorithm_name', 'cv_svm', 'nfolds', sub, 'error_type', 'mcr');   % run leave-one-subject-out cross-validation
% [cverr, stats, optout] = predict(dat, 'algorithm_name', 'cv_svm', 'nfolds', sub,'multiclass', 'error_type', 'mcr');   % run leave-one-subject-out cross-validation

% dist_from_hyperplane_xval
create_figure('ROC'); ROC = roc_plot(stats.dist_from_hyperplane_xval, stats.Y > 0, 'color', 'r', 'threshold', 0, 'twochoice'); %forced 
% create_figure('ROC'); ROC = roc_plot(to_be_test, label > 0, 'color', 'g', 'threshold', 0, 'twochoice'); %forced based on other's pattern, get ROC


% create_figure('ROC'); ROC = roc_plot(to_be_test, stats.Y > 0, 'color', 'r', 'threshold', 0, 'twochoice'); %forced based on other's pattern, get ROC

% create_figure('ROC'); ROC = roc_plot(stats.other_output{3}, stats.Y > 0, 'color', 'r', 'threshold', 0); %singler interval
% create_figure('ROC'); ROC = roc_plot(predNegVReg, stats.Y > 0, 'color', 'r', 'threshold', 0, 'twochoice'); %forced 


%write out image of pattern;
w = stats.weight_obj;
wname = 'collectiveguilt37_responsibility';
% wname = 'involve1_5_withMask';
w.fullpath = strcat('/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/weight_map/SVM_',wname,'.nii');
% w.fullpath = '/data3/FengWangshu/GPI_fMRI/MVPA/weight_map/SVM_GI_NG2_GPIfws_withSemanticMask.nii';
write(w, 'mni')
save(strcat('/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/dat/SVM_',wname,'_dat.mat'),'dat');
save(strcat('/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/stats/SVM_',wname,'_stats.mat'),'stats');
save(strcat('/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/ROC/SVM_',wname,'_ROC.mat'),'ROC');

% save('/data3/FengWangshu/GPI_fMRI/MVPA/dat/SVM_GI_NG2_GPIfws_withSemanticMask_dat.mat',dat);
% save('/data3/FengWangshu/GPI_fMRI/MVPA/stats/SVM_GI_NG2_GPIfws_withSemanticMask_stats.mat',stats);
% save('/data3/FengWangshu/GPI_fMRI/MVPA/ROC/SVM_GI_NG2_GPIfws_withSemanticMask_ROC.mat',ROC);


%plot arbitrarily thresholded results
w = stats.weight_obj;
% w = stats2.weight_obj;
%w = stats3.weight_obj;
thr = [prctile(w.dat, 1) prctile(w.dat, 99)];
wthr = w;
wthr.dat(wthr.dat > thr(1) & wthr.dat < thr(2)) = 0;

o2 = fmridisplay;
o2 = montage(o2, 'axial', 'slice_range', [0 30], 'onerow', 'spacing', 4);
o2 = montage(o2, 'sagittal', 'slice_range', [-12 12], 'onerow', 'spacing', 6);
o2 = montage(o2, 'coronal', 'slice_range', [-20 26], 'onerow', 'spacing', 6);

% add blobs to first 'appraisal' montage only
wr = region(wthr);
colorrange = [prctile(w.dat, 1) prctile(w.dat, 99)];
o2 = addblobs(o2, wr, 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]}, 'cmaprange', colorrange);