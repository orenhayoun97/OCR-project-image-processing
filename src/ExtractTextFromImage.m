function ExtractTextFromImage(img,cap,sma,write2file)
% This function extract text from an image
% img - image text
% cap - cell array of capital letters
% sma - cell array of small letters
% wirte2file - bool variable - True for wirte to file
% Syntax:
%   ExtractTextFromImage(img,cap,sma)
    
    arguments
        img
        cap
        sma
        write2file boolean = false;
    end
    input = rgb2gray(img);
    T = graythresh(input);
    input = input > T*255;
    rl = FindTextRows(input,0);


    r = size(rl,1); % rows
    for i=1:r
        BW = input(rl.start_idx(i):rl.end_idx(i),:);
        [row{i},num_letter(i)] = bwlabel(~BW);
    end

    % info
    capital_letter_array = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    small_letter_array = 'abcdefghijklmnopqrstuvwxyz';


    % find all the letters in the sentnce
    % initial contitions
    delta_space = 10;
    row_ratio = 2.5;
    % Write to file
    if write2file
        fileID = fopen('output.txt','w');
    end
    for i=1:length(row) % cheking each row
        curr_row = row{i};
        str = '';
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
            letter = curr_row(min(r):max(r),min(c):max(c));
            r_prev = r;
            
            % Correlation check
            % init condition
            idx_capital = 0;
            idx_small = 0;
            max_corr_capital = 0;
            max_corr_small  = 0;
            for m=1:length(cap) % checking each capital letter
                [r,c] = size(cap{m});
                letter_re = imresize(letter,[r,c]);
                res_corr = corr2(letter_re,cap{m});
                if res_corr > max_corr_capital
                    max_corr_capital = res_corr;
                    idx_capital = m;
                end
            end
            for m=1:length(sma) % checking each small letter 
                [r,c] = size(sma{m});
                letter_re = imresize(letter,[r,c]);
                res_corr = corr2(letter_re,sma{m});
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
        if write2file
            fprintf(fileID,'%s\n' ,str);
        end
        disp(str)
    end
    if write2file
        printf(fileID,'%s\n' ,str);
    end
end