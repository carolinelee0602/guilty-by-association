% Feel free to run multiple copies of matlab to distribute this across the workstations.  Just don't use more than 25-30gb of ram on each one at any given time.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run Bootstrapping for Gianaros Data Rating Prediction
% -----------------------------------------------------
%
% Will take approximately 10 days and 34gb of memory to run 5000 samples on
% one computer.  Parallel Computing toolbox can't handle this job on one
% computer due to memory limitations.
%
% This is a script to be run on different computers to break up the job.
% 180s per sample for 500 samples should take approximately 25 hours.  Can
% be run multiple times on the same computer.  Takes approx 10g of RAM for
% each instance
%
% Will run off of dropbox:
% -1:3 7:8 on Claustrum
% -4:6 9:10 on Calor
% -8:10 on Pilab
 
addpath(genpath('/data1/public/Software/CANLab/local_depositorywc/trunk'))
addpath(genpath('/data1/public/Software/CANLab/spider'))
addpath(genpath('/data1/public/Software/CANLab/lasso'))
% addpath(genpath('Volumes/RAID/Resources/spm8'))
 
fPath = '/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/dat';
bPath = '/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/bootstrap';
load([fPath filesep 'SVM_personalguilt57_responsibility_dat.mat'])
% clear test
 
[cverr1, stats1, optout1] = predict(dat, 'algorithm_name', 'cv_svm', 'nfolds', 1, 'bootweights','bootsamples',2500, 'savebootweights', 'error_type', 'mcr');  
save([bPath filesep 'SVM_personalguilt57_responsibility_dat_boot2500_1.mat'],'cverr1','stats1','optout1','-v7.3')
 
% [cverr2, stats2, optout2] = predict(dat, 'algorithm_name', 'cv_svm', 'nfolds', 1, 'bootweights','bootsamples',2500, 'savebootweights', 'error_type', 'mcr');  
% save([bPath filesep 'SVM_personalguilt57_responsibility_dat_boot2500_2.mat'],'cverr2','stats2','optout2','-v7.3')
% %  


%% Combine weights
% clear 
% fPath = '/home/yuhongbo/Yu_fMRI_data/lihui_bootstrap';
% bPath = '/home/yuhongbo/Yu_fMRI_data/lihui_bootstrap/H1_L1';

% fPath = '/home/yuhongbo/Yu_fMRI_data/guilt_prediction/bootstrap';
 bPath = '/data3/LiZhiai/beijing_fmri/CCG_SPM/MVPA/bootstrap';
 w=[];
for i = 1:2
    eval(['load([''' bPath filesep 'SVM_personalguilt57_responsibility_dat_boot2500_' num2str(i) '.mat''])'])
    eval(['w = [w; stats' num2str(i) '.WTS.w];'])
    eval(['clear stats' num2str(i) ' optout' num2str(i)])
end
% if you have already run the circulation for...end,don't run the two
% sentence below
% load([bPath filesep 'SVM_personal_guilt_withoutmask_dat_boot2500_1.mat'])
% dat = stats1.weight_obj;
%     
wste = nanstd(w);
wmean = nanmean(w);
wste(wste == 0) = Inf;  % in case unstable regression returns all zeros
wZ = wmean ./ wste;  % tor changed from wmean; otherwise bootstrap variance in mean inc in error; Luke renamed to avoid confusion
wP = 2 * (1 - normcdf(abs(wZ)));
%  
% % fdr 05
out = statistic_image();
out.dat = wZ';
out.p = wP';
out.volInfo = dat.volInfo;
thr = threshold(out, .05,'fdr','k',3);
t = replace_empty(thr);
th = dat;
th.dat = wZ';
th.dat(~logical(t.sig)) = 0;
th.fullpath = [bPath filesep 'SVM_personalguilt57_responsibility_dat_boot5000_c_k3.nii'];
write(th,'mni')
%  
% % 001 uncorrected
out = statistic_image();
out.dat = wZ';
out.p = wP';
out.volInfo = dat.volInfo;
thr = threshold(out, .001, 'unc','k',10);
t = replace_empty(thr);
th = dat;
th.dat = wZ';
th.dat(~logical(t.sig)) = 0;
th.fullpath = [bPath filesep 'SVM_personalguilt57_responsibility_dat_boot5000_unc_k10.nii'];
write(th,'mni')
%  
% % 005 uncorrected
out = statistic_image();
out.dat = wZ';
out.p = wP';
out.volInfo = dat.volInfo;
thr = threshold(out, .005, 'unc','k',30);
t = replace_empty(thr);
th = dat;
th.dat = wZ';
th.dat(~logical(t.sig)) = 0;
th.fullpath = [bPath filesep 'SVM_personalguilt57_responsibility_dat_boot5000_unc_k30.nii'];
write(th,'mni')


%  
% % untresholded
out = statistic_image();
out.dat = wZ';
out.p = wP';
out.volInfo = dat.volInfo;
thr = threshold(out, 1, 'unc','k',1);
t = replace_empty(thr);
th = dat;
th.dat = wZ';
th.dat(~logical(t.sig)) = 0;
th.fullpath = [bPath filesep 'SVM_personalguilt57_responsibility_dat_boot5000_untresholded.nii'];
write(th,'mni')

% w = stats.weight_obj;
% % w = stats2.weight_obj;
% %w = stats3.weight_obj;
% thr = [prctile(w.dat, 1) prctile(w.dat, 99)];
% wthr = w;
% wthr.dat(wthr.dat > thr(1) & wthr.dat < thr(2)) = 0;

o2 = fmridisplay;
o2 = montage(o2, 'axial', 'slice_range', [0 30], 'onerow', 'spacing', 4);
o2 = montage(o2, 'sagittal', 'slice_range', [-12 12], 'onerow', 'spacing', 3);
o2 = montage(o2, 'coronal', 'slice_range', [-20 26], 'onerow', 'spacing', 6);

% add blobs to first 'appraisal' montage only
wr = region(th);
colorrange = [prctile(out.dat, 1) prctile(out.dat, 99)];
o2 = addblobs(o2, wr, 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]}, 'cmaprange', colorrange);
