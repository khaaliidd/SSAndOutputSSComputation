function [shpath, out_12] = out_findshortestpath(ns,S, LastStates, o_graph,Inew,Onew,s_r, s_i, s_j)
% Tha function that finds modified version
% This function computes the shortest paths in the auxiliary graph from node (s_i, s_j) to node (s_r, s_r).
% Initialize the outputs
shpath = [];
STATES=(1:size(Inew,1));


% Initialize hit flag
hit = 0;
% Extract all the couples of unordered states from the graph
couples = cell2mat(o_graph(:, 1));

% Initialize path matrix and other variables
path = zeros(10, 3);
path(1, :) = [1, s_i, s_j];
label = 1;
% Maximum length for a shortest path fixed equal to the cardinality of the Auxiliary Graph
nMAX = ns * (ns + 1) / 2;
% Initialize count variable
count = 0;

% Check if the initial and final states are the same
if s_i == s_r && s_j == s_r
    shpath = [];
    return;
end

% Find the line associated with the initial state couple
line1 = findcouple(s_i, s_j, couples);
line1_si=s_i;
line1_sj=s_j;
line2 = findcouple(line1_si, line1_sj, couples);

while hit ~= 1
    count = count + 1;
    countextraarc = 0;

    % Find saved paths, i.e., paths whose index is equal to 1
    paths = find(path(:, 1) == 1);
    [sizep, ~] = size(paths);

    % For all the paths found, search the shortest one to (s_r, s_r)
    for i = 1:sizep
        s_i = path(i, 2);
        s_j = path(i, 3);

        % Find the GxG's line associated with this node
        line = findcouple(s_i, s_j, couples);
        % Cardinality of outgoing arcs
        Narc = o_graph{line, 2};

        % For all the outgoing arcs, save the explored paths
        for j = 1:Narc
            spij = cell2mat(o_graph{line, 2 + j}(1));
            sp_i = spij(1);
            sp_j = spij(2);
            transition = spij(3);

            if j == 1
                % Update the couple of states, overwriting it
                path(i, :) = [1, sp_i, sp_j];
                % Append the new fired transition
                label(i, 1 + count) = transition;
            else
                countextraarc = countextraarc + 1;
                path(sizep + countextraarc, :) = [1, sp_i, sp_j];
                label(sizep + countextraarc, :) = [label(i, 1:end-1), transition];
            end
        end

        % Check if the auxiliary graph doesn't satisfy the reachability condition
        if count > nMAX
            shpath = -10;
            return;
        end
    end

    % Verify if a short path to (s_r, s_r) has been found
    temp1 = find(path(:, 2) == s_r);
    temp2 = find(path(:, 3) == s_r);
    sol = intersect(temp1, temp2);
    if numel(sol) > 0
        shpath = label(sol, 2:end);
        hit = 1;
    end
end





% % Assuming shpath is a numeric vector where each number corresponds to a label index (1, 2, 3, ...)
% events = {'e_1', 'e_2', 'e_3'}; % Add more labels as needed
%
% % Replace numbers with labels in shpath
% labels_shpath = cell(size(shpath(1,:),2));
% for i = 1:numel(shpath(1,:))
%     if shpath(1,i) >= 1 && shpath(1,i) <= numel(events )
%         labels_shpath{i} = events {shpath(1,i)};
%     else
%         labels_shpath{1,i} = ''; % Handle out-of-range indices by leaving the cell empty
%     end
% end
%
% % Display the result in a table
% tableData_shpath = array2table(labels_shpath');%, 'VariableNames', {'Synchronizing_Sequence'}); % Modify column name
% disp(tableData_shpath);


% Initialize out_1 and out_2

number=0;
[sizeInew,lenghtInew]=size(Inew);

[sizeS,lenghtS]=size(S);
[sizesp,lenghtsp]=size(shpath);

out_12=cell(sizeS,lenghtsp+2);

%out_12=cell(sizeInew,lenghtsp+2);

%LastStates = (1:size(Inew,1));
for states = S
    %out_12{states,1}=states;
    s_end=states;
    % Loop through each input of shpath

    for i = 1:lenghtsp
        % Get the transition number for the current input
        % transition = shpath(i);



        outInew = cell2matrix(Inew(s_end, :));
        Narc = numel(outInew(:, s_end));
        outOnew = cell2matrix(Onew(s_end, :));


        for j = 1:Narc
            state = find(outInew(j, :) == shpath(1,i), 1);

            if numel(state) > 0

                out_12{states, i+1} = outOnew(j, state);
                s_end = state;

                break
            end

        end

    end
    out_12{states,lenghtsp+2} = [s_end];
    %LastStates(states)=s_end;
end
LastStates=cell2mat(out_12(:,lenghtsp+2))';








end



