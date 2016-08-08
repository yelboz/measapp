function Prog_Help( ~, ~ )
    % opens help text file
    
    help_name=fullfile(pwd,'Help.txt');
    winopen(help_name);
end