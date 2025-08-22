function [shortestPaths, totalCosts] = YenskShortestPath(netMatrix, source, destination, k_paths)
    if source > size(netMatrix,1) || destination > size(netMatrix,1)
        warning('The source or destination node are not part of netCostMatrix');
        shortestPaths = [];
        totalCosts = [];
    else
        k = 1;
        [path, cost] = dijkstra_algorithm(netMatrix, source, destination);
        if isempty(path)
            shortestPaths = [];
            totalCosts = [];
        else
            path_number = 1; 
            P{path_number,1} = path; P{path_number,2} = cost; 
            current_P = path_number;
            size_X = 1;  
            X{size_X} = {path_number; path; cost};
            S(path_number) = path(1);
            shortestPaths{k} = path;
            totalCosts(k) = cost;

            while (k < k_paths && size_X ~= 0)
                for i = 1:length(X)
                    if X{i}{1} == current_P
                        size_X = size_X - 1;
                        X(i) = [];
                        break;
                    end
                end

                P_ = P{current_P,1};
                w = S(current_P);
                for i = 1:length(P_)
                    if w == P_(i)
                        w_index_in_path = i;
                    end
                end

                for index_dev_vertex = w_index_in_path:length(P_) - 1
                    temp_netCostMatrix = netMatrix;
                    for i = 1:index_dev_vertex-1
                        v = P_(i);
                        temp_netCostMatrix(v,:) = inf;
                        temp_netCostMatrix(:,v) = inf;
                    end

                    SP_sameSubPath = [];
                    index = 1;
                    SP_sameSubPath{index} = P_;
                    for i = 1:length(shortestPaths)
                        if length(shortestPaths{i}) >= index_dev_vertex
                            if isequal(P_(1:index_dev_vertex), shortestPaths{i}(1:index_dev_vertex))
                                index = index + 1;
                                SP_sameSubPath{index} = shortestPaths{i};
                            end
                        end            
                    end       
                    v_ = P_(index_dev_vertex);
                    for j = 1:length(SP_sameSubPath)
                        next = SP_sameSubPath{j}(index_dev_vertex+1);
                        temp_netCostMatrix(v_, next) = inf;   
                    end

                    sub_P = P_(1:index_dev_vertex);
                    cost_sub_P = 0;
                    for i = 1:length(sub_P)-1
                        cost_sub_P = cost_sub_P + netMatrix(sub_P(i), sub_P(i+1));
                    end

                    [dev_p, c] = dijkstra_algorithm(temp_netCostMatrix, P_(index_dev_vertex), destination);
                    if ~isempty(dev_p)
                        path_number = path_number + 1;
                        P{path_number,1} = [sub_P(1:end-1) dev_p];
                        P{path_number,2} = cost_sub_P + c;
                        S(path_number) = P_(index_dev_vertex);
                        size_X = size_X + 1; 
                        X{size_X} = {path_number; P{path_number,1}; P{path_number,2}};
                    end      
                end

                if size_X > 0
                    shortestXCost = X{1}{3};
                    shortestX = X{1}{1};
                    for i = 2:size_X
                        if X{i}{3} < shortestXCost
                            shortestX = X{i}{1};
                            shortestXCost = X{i}{3};
                        end
                    end
                    current_P = shortestX;
                    k = k + 1;
                    shortestPaths{k} = P{current_P,1};
                    totalCosts(k) = P{current_P,2};
                end
            end
        end
    end
end