test_num = [25.125, 0.92383284, 0.2, -0.32123];

INT_BITS = 2;
FRAC_BITS = 23;
CORDIC_DEPTH = 16;

data = double_to_fixed(test_num, INT_BITS, FRAC_BITS);
% disp(data);
% disp(bin(data));
% disp(bitshift(data, -1))
% disp(bin(bitshift(data, -1)))

a_cordic_angles_degrees_float = [45.0, 26.56505117707799, 14.036243467926479, 7.125016348901798, 3.576334374997351, 1.7899106082460694, 0.8951737102110744, 0.4476141708605531, 0.22381050036853808, 0.1119056770662069, 0.055952891893803675, 0.027976452617003676, 0.013988227142265016, 0.006994113675352919, 0.003497056850704011, 0.0017485284269804495, 0.0008742642136937803, 0.00043713210687233457, 0.00021856605343934784, 0.00010928302672007149, 5.464151336008544e-05, 2.7320756680048934e-05, 1.3660378340025243e-05, 6.830189170012719e-06, 3.4150945850063712e-06, 1.7075472925031871e-06, 8.537736462515938e-07, 4.2688682312579694e-07, 2.1344341156289847e-07, 1.0672170578144923e-07, 5.336085289072462e-08, 2.668042644536231e-08, 1.3340213222681154e-08, 6.670106611340577e-09, 3.3350533056702886e-09, 1.6675266528351443e-09, 8.337633264175721e-10, 4.1688166320878607e-10, 2.0844083160439303e-10, 1.0422041580219652e-10];
a_cordic_angles_radians_float = deg2rad(a_cordic_angles_degrees_float);



%disp(a_cordic_angles_radians_float);

test = 42.0;
actual = cos(deg2rad(test));

%experimental = CORDIC(deg2rad(test), INT_BITS, FRAC_BITS, CORDIC_DEPTH);
disp(newline);
%disp(actual);
%disp(experimental);
%errorMessage = ["Error: ", string(double(experimental - actual))];
%disp(join(errorMessage, " "));




fpr = fipref;
fpr.NumberDisplay = 'bin';
%d = fi(a_cordic_angles_radians_float,1,22,21);
%disp(d);

disp(fi([5, (5-128), ((5-128) / 128), 128], 1, 24, 14));



disp(fi([10, (10-128), ((10-128) / 128), 128], 1, 24, 14));

%disp(fi((5 - 128)/128, 1, 22, 20));

X=0:5:255;





function out = double_to_fixed(test_num, IB, FB)
  F = fimath('RoundingMethod','Floor', 'OverflowAction','Wrap', "ProductMode", "keepLSB", "SumMode", "keepLSB");
  %fixed_point = fixdt()
  %bin = dec2bin(test_num, 8);
  %test_frac = 125;
  %out = [bin dec2bin(test_frac)]

  %disp(floor(test_num))
  %disp(class(fi(test_num, 1, IB+FB, FB)));
  out = fi(test_num, 1, IB+FB, FB);
end


function out = CORDIC(target_flt, IB, FB, depth)
    F = fimath('RoundingMethod','Floor', 'OverflowAction','Wrap', "ProductMode", "keepLSB", "SumMode", "keepLSB");
    warning off
    cordic_angles_degrees_float = [45.0, 26.56505117707799, 14.036243467926479, 7.125016348901798, 3.576334374997351, 1.7899106082460694, 0.8951737102110744, 0.4476141708605531, 0.22381050036853808, 0.1119056770662069, 0.055952891893803675, 0.027976452617003676, 0.013988227142265016, 0.006994113675352919, 0.003497056850704011, 0.0017485284269804495, 0.0008742642136937803, 0.00043713210687233457, 0.00021856605343934784, 0.00010928302672007149, 5.464151336008544e-05, 2.7320756680048934e-05, 1.3660378340025243e-05, 6.830189170012719e-06, 3.4150945850063712e-06, 1.7075472925031871e-06, 8.537736462515938e-07, 4.2688682312579694e-07, 2.1344341156289847e-07, 1.0672170578144923e-07, 5.336085289072462e-08, 2.668042644536231e-08, 1.3340213222681154e-08, 6.670106611340577e-09, 3.3350533056702886e-09, 1.6675266528351443e-09, 8.337633264175721e-10, 4.1688166320878607e-10, 2.0844083160439303e-10, 1.0422041580219652e-10];
    cordic_angles_radians_float = deg2rad(cordic_angles_degrees_float);
    angles = double_to_fixed(cordic_angles_radians_float, IB, FB);

    target = double_to_fixed(target_flt, IB+FB, FB);
    x = double_to_fixed(1.0 / 1.646760258121, IB+FB, FB);
    y = double_to_fixed(0, FB+IB, FB);
    theta = double_to_fixed(0, FB+IB, FB);
    
    for i=1:depth
        %disp("working with x value:");
        text = ["angle: ", string(rad2deg(double(theta))), " with x value: ", string(double(x))];
        disp(join(text, " "));

        if (target == theta)
            disp("equal");
            out = x;
            break;

        end

        if(target > theta)
                disp("Too Small");
                new_theta = theta + angles(i);
                new_x = x - bitshift(y, -i + 1);
                new_y = y + bitshift(x, -i + 1);
                theta = double_to_fixed(new_theta, IB+FB, FB);
        else
                disp("Too Big");
                new_theta = theta - angles(i);
                new_x = x + bitshift(y, -i + 1);
                new_y = y - bitshift(x, -i + 1);
                theta = double_to_fixed(new_theta, IB+FB, FB);
        end
        x = new_x;
        y = new_y;
        
    end
    final_angle = rad2deg(double(theta));
    disp("Final Angle:");
    disp(final_angle);
    out = x;

end