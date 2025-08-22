try
    netMatrix = [inf 400 100 200 inf inf; 
                 400 inf 200 inf inf 200; 
                 100 200 inf 300 inf 600; 
                 200 inf 300 inf 400 inf; 
                 inf inf inf 400 inf 500; 
                 inf 200 600 inf 500 inf];

    k = 3;

    % Initialize variables
    maxSlots = 30;
    numNodes = size(netMatrix, 1);
    spectralSlots = ones(numNodes * numNodes, maxSlots); % Initialize to ones
    blockedConnections = [];
    pathNumbersUsed = [];

    % Set slots to zero for non-existing connections
    for i = 1:numNodes
        for j = 1:numNodes
            if netMatrix(i, j) == 0 || isinf(netMatrix(i, j))
                spectralSlots((i-1) * numNodes + j, :) = 0;
            end
        end
    end

    % Number of connections
    numConnections = numNodes * (numNodes - 1);
    isBlocked = false(numConnections, 1);
    connectionIdx = 1;

    % Loop through all possible source-destination pairs
    for source = 1:numNodes
        for destination = 1:numNodes
            if source ~= destination
                fprintf('Trying source-destination pair: %d -> %d\n', source, destination);
                [shortestPaths, totalDistance] = YenskShortestPath(netMatrix, source, destination, k);

                if isempty(shortestPaths)
                    fprintf('No path available between nodes %d and %d\n\n', source, destination);
                    blockedConnections = [blockedConnections; source, destination];
                    isBlocked(connectionIdx) = true;
                else
                    fprintf('The path request is from source node %d to destination node %d, with K = %d \n', source, destination, k);

                    for i = 1:length(shortestPaths)
                        fprintf('Path # %d:\n', i);
                        disp(shortestPaths{i})
                        fprintf('Cost of path %d is %5.2f\n\n', i, totalDistance(i));
                    end

                    if k > length(shortestPaths)
                        fprintf('No more path combinations are possible for this source-destination pair.\n');
                    end

                    pathAllocated = false; % Flag to check if path is allocated

                    for chosenPath = 1:min(k, length(shortestPaths))
                        fprintf('Trying path #%d:\n', chosenPath);
                        disp(shortestPaths{chosenPath})
                        fprintf('The cost of path #%d is %5.2f\n', chosenPath, totalDistance(chosenPath));

                        % Generate a random number of spectral slots needed for the chosen path (1-10)
                        numSlotsNeeded = randi([1, 10]);
                        fprintf('Random number of spectral slots needed for the chosen path: %d\n', numSlotsNeeded);

                        % First-fit allocation of spectral slots for each connection in the chosen path
                        path = shortestPaths{chosenPath};
                        sufficientSlots = true;

                        for j = 1:length(path) - 1
                            node1 = path(j);
                            node2 = path(j + 1);

                            % Find first fit slots
                            slotStart = 0;
                            connectionIndex = (node1-1) * numNodes + node2;
                            for slot = 1:maxSlots - numSlotsNeeded + 1
                                if all(spectralSlots(connectionIndex, slot:slot + numSlotsNeeded - 1) == 1)
                                    slotStart = slot;
                                    break;
                                end
                            end

                            if slotStart > 0
                                spectralSlots(connectionIndex, slotStart:slotStart + numSlotsNeeded - 1) = 0;
                                fprintf('Allocated %d slots starting at slot %d for connection %d-%d\n', numSlotsNeeded, slotStart, node1, node2);
                            else
                                sufficientSlots = false;
                                fprintf('No sufficient contiguous slots available for connection %d-%d\n', node1, node2);
                                break;
                            end
                        end

                        if sufficientSlots
                            pathAllocated = true;
                            fprintf('Successfully allocated spectral slots for path #%d\n', chosenPath);
                            pathNumbersUsed = [pathNumbersUsed; source, destination, chosenPath];
                            break;
                        else
                            fprintf('Path #%d blocked due to insufficient slots.\n', chosenPath);
                        end
                    end

                    if ~pathAllocated
                        fprintf('Connection is blocked. No sufficient slots available in any of the paths for nodes %d-%d.\n', source, destination);
                        blockedConnections = [blockedConnections; source, destination];
                        isBlocked(connectionIdx) = true;
                    else
                        fprintf('Updated spectral slot allocation:\n');
                        for i = 1:numNodes
                            for j = 1:numNodes
                                fprintf('Connection %d-%d: ', i, j);
                                fprintf('%s\n', num2str(spectralSlots((i-1) * numNodes + j, :)));
                            end
                        end
                    end
                end
                connectionIdx = connectionIdx + 1;
            end
        end
    end

    % Display blocked connections and path numbers used
    fprintf('Blocked Connections:\n');
    disp(blockedConnections);

    fprintf('Path Numbers Used for Spectral Allocation:\n');
    disp(pathNumbersUsed);

    % ✅ Correct Blocking Probability Calculation
    blockingProbability = cumsum(isBlocked) ./ (1:numConnections)';

    % Plot the graph of probability of blocking vs. number of connections
    figure;
    plot(1:numConnections, blockingProbability, '-o');
    xlabel('Number of Connections');
    ylabel('Probability of Blocking');
    title('Probability of Blocking vs. Number of Connections');
    grid on;

catch ME
    fprintf('Error: %s\n', ME.message);
end
