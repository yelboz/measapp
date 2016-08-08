function t=LockinTimeConst(number)
    % returns the lockin time constant from setting value
    
    switch number
        case 0
            t=10*10^-6;
        case 1
            t=30*10^-6;
        case 2
            t=100*10^-6;
        case 3
            t=300*10^-6;
        case 4
            t=1*10^-3;
        case 5
            t=3*10^-3;
        case 6
            t=10*10^-3;
        case 7
            t=30*10^-3;
        case 8
            t=100*10^-3;
        case 9
            t=300*10^-3;
        case 10
            t=1;
        case 11
            t=3;
        case 12
            t=10;
        case 13
            t=30;
        case 14
            t=100;
        case 15
            t=300;
        case 16
            t=1*10^3;
        case 17
            t=3*10^3;
        case 18
            t=10*10^3;
        case 19
            t=30*10^3;
    end
end