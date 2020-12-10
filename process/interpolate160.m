function EEG = interpolate160(EEG,path_Matlab)
    EEG160 = pop_loadset('EEG160-do-not-delete.set', path_Matlab);
    % EEG160.chanlocs = pop_chanedit(EEG160.chanlocs, 'load',{ path_sfp_160, 'filetype', 'autodetect'});
    EEG.allchan160 = EEG160.chanlocs;
    EEG = pop_interp(EEG, EEG.allchan160, 'spherical');
end