clc;clear;close all
% read data image
tic
I = imread("ABC_consolas_bold.png");
I = rgb2gray(I);
Th = graythresh(I);
I = I > Th;
clear Th;

% find the relevant infromation
row_add = 3;
sumBW = sum(~I,2);
Zeros_idx = find(sumBW==0);
[r,~] = find(abs(Zeros_idx(1:end-1)-Zeros_idx(2:end))>2);
idx_rows(:,1) = Zeros_idx(r)-row_add; % start row
idx_rows(:,2) = Zeros_idx(r+1)+row_add; % end row
clear r sumBW Zeros_idx;

% orginize data
% image of the data
image_small_letters = I(idx_rows(2,1):idx_rows(2,2),:);
image_capital_letters = I(idx_rows(1,1):idx_rows(1,2),:);
% labels of each image
[small_labels,num_small] = bwlabel(~image_small_letters);
[capital_labels,num_capital] = bwlabel(~image_capital_letters);


clear image_small_letters image_capital_letters I




% find capital letters
capital_letters = {};
small_letters = {};
for i=1:num_capital
    [r,c] = find(capital_labels==i);
    capital_letters{i} = capital_labels(1:max(r),min(c):max(c));
end
% find small letters
for i=1:num_small
    [r,c] = find(small_labels==i);
    if i==9
        r_prev = r;
    end
    if i==10
        row_ratio = (max(r_prev)-min(r_prev))/(max(r)-min(r));
    end
    small_letters{i} = small_labels(1:max(r),min(c):max(c));
end
% delete dot objects
small_letters([10,12]) = [];

clear c i idx_rows capital_labels small_labels

%% input image

input = imread("text1.png");
input = rgb2gray(input);
T = graythresh(input);
input = input > T;
clear T;

%% row find

sumBW = sum(~input,2);
Zeros_idx = find(sumBW==0);
[r,~] = find(abs(Zeros_idx(1:end-1)-Zeros_idx(2:end))>2);
idx_rows(:,1) = Zeros_idx(r)-row_add; % start row
idx_rows(:,2) = Zeros_idx(r+1)+row_add; % end row
clear r sumBW Zeros_idx;

%%
[r,~] = size(idx_rows);
for i=1:r
    BW = input(idx_rows(i,1):idx_rows(i,2),:);
    [row{i},num_letter(i)] = bwlabel(~BW);
end
%% info
capital_letter_array = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
small_letter_array = 'abcdefghijklmnopqrstuvwxyz';

%% find all the letters in the sentnce
% initial contitions
delta_space = 10;
row_ratio = 2.5;
% Write to file
fileID = fopen('output.txt','w');
for i=1:length(row) % cheking each row
    curr_row = row{i};
    % s = regionprops(curr_row,'Area');
    % area = cat(1,s.Area); % area each letter
    % Th_dot = min(area) + 10;
    str = '';
    % label_row_ratio(1) = 0;
    for j=1:num_letter(i)
        [r,c] = find(curr_row==j);
        if j~=1
            label_row_ratio(j) = (max(r_prev)-min(r_prev))/(max(r)-min(r));
        end
        max_col(j) = max(c);
        min_col(j) = min(c);
        r_prev=r;
    end
    Th_space = max(min_col(2:end)-max_col(1:end-1)) - delta_space;
    for j=1:num_letter(i) % letter in test row
        [r,c] = find(curr_row==j);
        curr_row_ratio = (max(r_prev)-min(r_prev))/(max(r)-min(r));

        if j~=1 && label_row_ratio(j) > row_ratio
           continue; % find dot in letters: i,j 
        end
        % extreme case #2 - find spacw
        if j>1 && abs(min_col(j)-max_col(j-1)) > Th_space
            str = [str,' '];
        end
        letter = curr_row(1:max(r),min(c):max(c));
        r_prev = r;
        
        % Correlation check
        % init condition
        idx_capital = 0;
        idx_small = 0;
        max_corr_capital = 0;
        max_corr_small  = 0;
        for m=1:length(capital_letters) % checking each capital letter
            [r,c] = size(capital_letters{m});
            letter_re = imresize(letter,[r,c]);
            res_corr = corr2(letter_re,capital_letters{m});
            if res_corr > max_corr_capital
                max_corr_capital = res_corr;
                idx_capital = m;
            end
        end
        for m=1:length(small_letters) % checking each small letter 
            [r,c] = size(small_letters{m});
            letter_re = imresize(letter,[r,c]);
            res_corr = corr2(letter_re,small_letters{m});
            if res_corr > max_corr_small
                max_corr_small = res_corr;
                idx_small = m;
            end
        end
        % no corelation
        if max_corr_capital < 0.4 && max_corr_small <0.4
            continue;
        elseif max_corr_capital > max_corr_small % choose capital
            str = [str,capital_letter_array(idx_capital)];
        else % choose small
            str = [str,small_letter_array(idx_small)];
        end
    end
    fprintf(fileID,'%s\n' ,str);
    disp([str,newline])
end
fclose(fileID);
timer = toc;

%%
