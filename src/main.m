%% This is the main code for the assignment:
clc;clear;
start = 1;
bar = '=========================================================';
barbar = '---------------------------------------------------------';

while start
%  Part 1: Reading the image, query from the user

    disp(bar); disp(barbar);
    fprintf('This is the coinsy counter!\nYour current work directory is: \n\t');
    disp(pwd); disp(barbar);
    fprintf('To END: enter cltr + c\n');
    prompt_start = 'To START: enter your image file (rel/abs dir) below:\n';
    
    filename = input(prompt_start, 's'); 
    if isempty(filename)
        disp('Using trial image: practice/simpler/05.jpg');
        filename = '../practice/simpler/05.jpg';
    end
   
    % load the image into original_image
    original_image = imread(filename);
    
    disp(barbar); disp(bar); fprintf('\n\n')
    
%%  Part 2: Image segmentation.... ?
    
    disp(bar); disp(barbar);
    disp('NOW: Segmenting the images...');
    
    disp(barbar); disp(bar); fprintf('\n\n');
    
%% Part 3: Classification ...?

    disp(bar); disp(barbar);
    disp('NOW: Classifying the objects...');
    
    disp(barbar); disp(bar); fprintf('\n\n');
    
%% Part 4: Coinsy Counter:
    
    disp(bar); disp(barbar);
    disp('NOW: Initialising the counter...');
    % counter starts at 0
    counter = 0;
  
    
    disp(barbar); disp(bar); fprintf('\n\n');

%%  Part 5: Summary Statistics:
    disp(bar); disp(barbar);
    disp('SUMMARY STATISTICS');

% Expect something like:
% two_pound = 
% one_pound = 
% sevenfive_pence = 
% fifty_pence = 
% twofive_pence =
% twenty_pence = 
% five_pence = 
% two_pence = 
% battery = 
% nut =
% unclass = 
% Total value =
% Confidence = 
    
    disp(barbar); disp(bar); fprintf('\n\n');

%% Next image?
    % single loop for now:
    prompt_end = ('Do you want to load another image? [y/n]');
    x = input(prompt_end, 's');
    switch x
        case 'y'
            start = 1;
        case 'n'
            start = 0;
        case 'Y'
            start = 1;
        case 'N'
            start = 0;
        otherwise
            start = 1;
    end
end
