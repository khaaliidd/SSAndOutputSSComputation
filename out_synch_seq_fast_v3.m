function [SS, V_SS] = out_synch_seq_fast_v3(s_r, Inew, Onew, o_graph)
    % INPUTS:
    % - s_r: Desired final state.
    % - Inew: Cell matrix containing input information of OutSynPN.
    % - Onew: Cell matrix containing output information of OutSynPN.
    % - o_graph: Auxiliary graph of the LFAI with both information input and output.

    % OUTPUTS:

    % - SS: Vector matrix containing events of synchronizing sequence.
    % - OUTPUT_SEQUENCES: Matrix containing possible output sequences if carring out SS.
    
    tic
    
    % Get the size of the state matrix
    [sizeS, lenghtS] = size(Inew);
    ns = sizeS;
    
    % Get the size of the auxiliary graph
    [sizeAG, lenghtAG] = size(o_graph);

    % Initialize the current state uncertainty
    S = (1:sizeS);
    LastStates=S;
    % Initialize the synchronizing sequence
    SS = [];
    V_SS = {};

    % Check if the desired final state is valid
    if s_r < 0 || s_r > lenghtS
        fprintf('\n ERROR!! The desired final state is not belonging to the\n')
        fprintf(' set of states!')
        fprintf('\n The synchronizing sequences (SS) of LFAI')
        fprintf('\n have not been computed!\n')
        fprintf('\n The output sequences (V_SS) of LFAI')
        fprintf('\n have not been computed!\n')
        return
    end

    % Variable used to terminate the while loop
    if S == s_r
        hit = 1;
        fprintf('The LFAI has only one state, the SS is the trivial empty word.')
        fprintf('The LFAI has only one output sequence, the V_SS is the singleton output corespondins to the embty empty word.')

    else
        hit = 0;
    end

    while hit == 0
        % Randomly select two states from S
        TEMP_states = pick(S, 2, '');
        [TT, TTT] = size(TEMP_states);
        II = ceil(rand(1) * TT);
        s_i = TEMP_states(II, 1);
        s_j = TEMP_states(II, 2);

        % Checking reachability of s_r
        ok = 0;
        A = zeros(size(Inew));
        for i = 1:numel(A(1, :))
            for j = 1:numel(A(1, :))
                if ~isempty(Inew{i, j})
                    A(i, j) = 1;
                end
            end
        end
        a = numel(A(1, :));
        E = zeros(a);
        for i = 1:a
            E = E + A^i;
        end
        a = E(:, s_r);
        a(s_r) = [];
        if all(a)
            % the SM is connected
            ok = 1;
        end

        if ok == 1
            % Find the shortest path from (s_i, s_j) to (s_r, s_r)
            [shpath, out_12] = out_findshortestpath(ns, S, LastStates, o_graph, Inew, Onew, s_r, s_i, s_j);
        else
            shpath = -10;
        end

        if shpath == -10
           
            SS = [];
            V_SS=[];
            S = [];
            if numel(S) == 0
                fprintf('\n ERROR!! Reachability Condition of the Auxiliary Graph not Verified')
                fprintf('\n For The Requested Final State s%d!', s_r)
                fprintf('\n The synchronizing sequences (SS) of OutSynPN')
                fprintf('\n have not been computed!\n')
                SS = [];
                V_SS=[];
                fprintf('\n The output sequences (V_SS) of OutSynPN')
                fprintf('\n have not been computed!\n')
                
                return
            else
                continue
            end
        end
        
        sp = shpath(1, :);
        S_end = [];
      

        % Concatenate the input sequences (shpath) to SS
        if numel(SS) == 0
            SS = sp;
            V_SS = [V_SS, out_12];

        else
            SS = [SS, sp];
            % Concatenate the non-empty out_12 to outputs12, fill empty cells with corresponding content
            for k = 1:numel(out_12)
                if isempty(out_12{k})
                    [l, c] = ind2sub(size(out_12), k);  % Get row and column indices of the empty cell
                    s_arrival = V_SS{l, size(V_SS, 2)};
                    %l = s_arrival;
                    l = s_arrival;
                    %out_12{k} = out_12{l, c};  % Fill empty cell with the content of the corresponding non-empty cell
                    % Check if the source cell is non-empty before assignment
                   
                    out_12{k} = out_12{l, c};
                    
                
                end
            end
            LastStates=cell2mat(V_SS(:, size(V_SS, 2)))';
            out_12bis={};
            ils=1;
            for ls=LastStates
                out_12bis(ils,:)=out_12(ls,:);
                ils=ils+1;
            end
            out_12bis;
            V_SS(:, size(V_SS, 2)) = []; %erase the last column
            %of each outputs12
            V_SS = [V_SS, out_12bis];
            %outputs12 = horzcat(outputs12,out_12);
        end

          % Update the current state uncertainty and append the sequences to SS
        
        for k = 1:numel(S)
            s_start = S(1, k);
            % Compute the final state obtained at the end of evolution given by the sequence shpath
            s_end = s_reached(s_start, Inew, sp);
            % Update the current state uncertainty
            S_end(1, k) = s_end;
        end

        % Update the corresponding old current state uncertainty
        S = unique(S_end(1, :));

        % Check if all updated current state uncertainties are singleton
        if S == s_r
            hit = 1;
        end

        % Check the computation time
        t = toc;
        if t > 3 * 60 %3*60*60
            SS = [];
            return
        end
    end
    V_SS(:, size(V_SS, 2)) = [];
    V_SS = cell2mat(V_SS);

    % Assuming SS is a matrix with numeric values
    events = {'e_1', 'e_2', 'e_3','e_4', 'e_5', 'lamda'}; % Add more labels as needed to the data
    
    % Replace numbers with labels in SS
    SymbolInput = cell(size(SS));
    for i = 1:numel(SS)
        if SS(i) >= 1 && SS(i) <= numel(events)
            SymbolInput{i} = events{SS(i)};
        else
            SymbolInput{i} = ''; % Handle out-of-range indices by leaving the cell empty
        end
    end

    % Reshape labelsSS to match the size of SS
    SymbolInput = reshape(SymbolInput, size(SS));

    % Display the result in a table
    tableDataSS = array2table(SymbolInput);%,'VariableNames', strcat(events, '_input')); % Modify column names
    disp(tableDataSS);



    % Assuming outputs12 is a numeric matrix where each number corresponds to a label index (1, 2, 3, ...)
    % Replace numbers with labels in outputs12
    labels = {'A', 'B', 'C', 'D','E','F'};
    LabelOutput = cell(size(V_SS));
    for i = 1:numel(V_SS)
        if V_SS(i) >= 1 && V_SS(i) <= numel(labels)
            LabelOutput{i} = labels{V_SS(i)};
        else 
            LabelOutput{i} = 'eps'; % Handle out-of-range indices by leaving the cell empty
        end

        if V_SS(i) <  0
            LabelOutput{i} = 'e_forbidden'
        end

    end
    LabelOutput=reshape(LabelOutput, size(V_SS));
    % Display the result in a table
    tableData = array2table(LabelOutput);%, 'VariableNames', labels);
    disp(tableData);


end
