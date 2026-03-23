function RowLocation =  FindTextRows(I, row_add)
% Find the location(rows) of a text in the images.
% I - Is RGB or Gray image
% row_add - an double number that determine the extra empty rows that will
% include in text rows. 
%
% Syntax:
% RL = FindTextRows(I,0);

    arguments
        I
        row_add double = 0
    end
    if mod(row_add,1) ~= 0
        RowLocation = 0;
        fprintf("[ERROR] Check row_add!!")
        return;
    end
% find the relevant infromation
    sumBW = sum(~I,2);                                          % sum rows
    Zeros_idx = find(sumBW==0);                                 % find empty rows       
    [r,~] = find(abs(Zeros_idx(1:end-1)-Zeros_idx(2:end))>2);   % find full rows
    idx_rows(:,1) = Zeros_idx(r)-row_add;                       % start row
    idx_rows(:,2) = Zeros_idx(r+1)+row_add;                     % end row
    RowLocation = array2table(idx_rows,"VariableNames", ...     % table
        ["start_idx", "end_idx"]);
end