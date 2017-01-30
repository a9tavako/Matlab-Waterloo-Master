function boundaryIndexes  = getBoundaryIndexes (e)
 %Finding indices of boundary points
    counter = 1;
    indexes = zeros(1,2*size(e,2)); %preallocating, 2*size(e,2) is upper bound
    for i=1:size(e,2)
        if e(6,i) == 0 || e(7,i) == 0   % checking if an edge in e is on the border. 0 is the code for the outside region
            indexes(counter) = e(1,i);  % if yes, record the index of the two end points of the edge. 
            indexes(counter+1) = e(2,i);
            counter = counter + 2;
        end
    end
    indexes = unique(indexes);  %removing repetitions
    indexes(indexes==0) = [];   %removing zeros that were allocated at the beginning but where not filled.
    boundaryIndexes = sort(indexes);
 end