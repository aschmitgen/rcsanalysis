function MAIN_maintain_database()
%% function to maintain RC+S database in dropbox 
% this function moves files from sycned to unsycned folders 
% and maintains a constantly updated database 

%% move files from synced to unsycned folders 
move_and_delete_folders();
move_and_delete_folders(); % second call is to delete folders that are empty 

%% get stim and sense database 
maintain_stim_sense_database();

%% agregate stim and sense database for easy viewing and query 
agregate_patient_databases()

%% print some basic stats about the database 
print_database_stats();

end