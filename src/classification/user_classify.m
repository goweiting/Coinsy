function [relevance, class] = user_classify(IMG, SAVE)
%% USER_CLASSIFY(IMG)
%   Given an img, ask the user which class it belongs to

%%
% fprintf('\n\nplease enter the two class for this img\n');
prompt = 'Is this relevant? [0/1]';
relevance = input(prompt); % to count the class or not!

if relevance 
    fprintf('\n====\nWhats the value?\n');
    fprintf('[1] 1 POUND  [2] 2 POUND  [3] 50 P  [4] 20 P  [5] 5 P\n')
    fprintf('[6] 75 P (washer w small hole)  [7] 25 P (washer w large hole)\n');
    fprintf('[8] 2 P (angle bracket)\n[9] AAA battery (no val)  [10] nut (no value)\n');
    fprintf('[0] HELP!! (will display the bigger picture)\n\n');
    prompt = '>>  ';
    class = input(prompt);
        
    % Reject error in class input
    while (class < 0 || class > 10)
        fprintf('Classes ranges from 1 to 11 only\n');
        class = input(prompt);
    end
    
    fprintf('\n===\n')
else
    class = 404;
end


end

