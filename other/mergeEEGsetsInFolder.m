% Author: Seydanur Tikir (seydanurtikir@gmail.com)

function EEGmerged = mergeEEGsetsInFolder(load_folder_path)
    temp_set=[]; 
       files=dir([load_folder_path,'\*.set']);
       for k=1:length(files)
           EEG = pop_loadset(files(k).name,load_folder_path);         
            if k==1 
                temp_set= EEG;
            else 
                session_set = EEG;
                temp_set = pop_mergeset( temp_set,session_set,1);
            end
        end
        EEGmerged=temp_set; 
end