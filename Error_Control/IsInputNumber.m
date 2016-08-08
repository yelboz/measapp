function num=IsInputNumber(src,~)
    % checks if input is a number

    var=get(src,'string');
    var=str2double(var);
    if isnan(var)
        warndlg('only number input!','Error!')
        set(src,'string','1');
        num=false;
    else
        num=true;
    end
end