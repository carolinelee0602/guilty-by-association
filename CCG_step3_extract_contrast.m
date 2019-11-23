function CreateRFX
clear; % Clean up your workspace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Change your parameters in following section:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cwd = '/data3/LiZhiai/beijing_fmri/CCG_SPM/first_level/Model_forresponsibility';
cwdadd = '/data3/LiZhiai/beijing_fmri/CCG_SPM/second_level/Model_forresponsibility';

if ~exist(cwdadd)
mkdir(cwdadd)
end

folderstruct = dir(fullfile(cwd,'CCG*'));
       subs = {};
       
       for i = 1:length(folderstruct)
           subs{i} = folderstruct(i).name;
       end;
nsub=length(subs);
nsub
% stats = 'stat/fix_separate_noTD_t01';            %The name of dir of stats
% nses = 1;                       %How many sessions per subject?
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%End of your parameters section
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
spm_defaults
global defaults
cd(cwd)   % CHANGE TO YOUR PATH
tic

RFXHOME = cwdadd;
subdir = fullfile(cwd,subs{1});
cd(subdir);
% cd(stats);
load SPM;

ocon=length(SPM.xCon);   %How many contasts are totally in SPM.mat.
ionc=1;
%length(SPM.Sess(1).U)*length(SPM.Sess)+1+1; %The order that user define

%create rfxdir of every contrast defined by users
for xcon= ionc:ocon
    swd=SPM.xCon(xcon).name;
    swd(find(swd == ' ')) = '';
    swd(find(swd == '&')) = '+';
    rfxdir=fullfile(RFXHOME, sprintf('%d_%s',xcon,swd));
    if (exist(rfxdir) ~= 7)
        disp(sprintf('creating %s directory',rfxdir)) 
        switch (spm_platform('filesys'))
            case 'win' 
                eval(sprintf('!md %s', rfxdir));
            case 'unx'
                eval(sprintf('!mkdir %s', rfxdir));
        end
    end
end

for sub = 1:length(subs)
    
    %disp(sprintf('copying sub%d files',subs(sub))) 
    subdir = fullfile(cwd, subs{sub});
    cd(subdir);
%     cd(stats);
    load SPM;
    pwd
    
    for xcon= ionc:ocon
        swd=SPM.xCon(xcon).name;
        swd(find(swd == ' ')) = '';
        swd(find(swd == '&')) = '+';
        rfxdir=fullfile(RFXHOME, sprintf('%d_%s',xcon,swd));
        
        
        surfile=SPM.xCon(xcon).Vcon.fname;
        if xcon < 10
            desfile=fullfile(rfxdir, [subs{sub}, sprintf('_con_000%d.img',xcon)]);
        elseif xcon >= 10
            desfile=fullfile(rfxdir, [subs{sub}, sprintf('_con_00%d.img', xcon)]);
        end
        % desfile=fullfile(rfxdir, sprintf('sub%d_%s', sub, SPM.xCon(xcon).Vcon.fname));
        copyfile(surfile,desfile);
        
        [pth,nam,ext] = fileparts(surfile);
        hdr_surfile=fullfile(pth,[nam '.hdr']);
        if xcon < 10
            hdr_desfile=fullfile(rfxdir, [subs{sub},sprintf('_con_000%d.hdr', xcon)]);
        elseif xcon >= 10
            hdr_desfile=fullfile(rfxdir, [subs{sub},sprintf('_con_00%d.hdr', xcon)]);
        end
        copyfile(hdr_surfile,hdr_desfile);
    end
    
end % for sub
disp(sprintf('.........copying files is over.........')) 
toc