function [sma, cap]= DataPrepare(imgPath)

    I = imread(imgPath);    % load data image
    I = rgb2gray(I);                        % Convert to gray img
    Th = 0.5;                               % determine a threshold
    I = I > Th*255;                        % Convert to BW image
    
    rl = FindTextRows(I,0);
    

    % orginize data
    % image of the data
    img_capital_letters = I(rl.start_idx(1):rl.end_idx(1),:);
    img_small_letters = I(rl.start_idx(2):rl.end_idx(2),:);

    % labels of each image
    [smaLabels,num_small] = bwlabel(~img_small_letters);
    [capLabels,~] = bwlabel(~img_capital_letters);
    
   
    
    % find capital letters
    capital_letters = {};
    small_letters = {};
    for i=1:num_small
        [r,c] = find(smaLabels==i);
        I = smaLabels(min(r):max(r),min(c):max(c));
        small_letters{i} = imresize(I,2);
        [r,c] = find(capLabels==i);
        if isempty(r)
            continue;
        end
        I = capLabels(min(r):max(r),min(c):max(c));
        capital_letters{i} = imresize(I,2);
    end
    % delete dot objects
    small_letters([10,12]) = [];
    
    sma = small_letters;
    cap = capital_letters;
end