function [shortestPath, totalCost] = dijkstra_algorithm(netCostMatrix, s, d)
    n = size(netCostMatrix, 1);
    visited = false(1, n);
    distance = inf(1, n);
    parent = zeros(1, n);

    distance(s) = 0;
    
    for i = 1:(n-1)
        temp = inf(1, n);
        for h = 1:n
            if ~visited(h)
                temp(h) = distance(h);
            end
        end
        [~, u] = min(temp);
        visited(u) = true;

        for v = 1:n
            if netCostMatrix(u, v) > 0 && ~visited(v)
                newDist = distance(u) + netCostMatrix(u, v);
                if newDist < distance(v)
                    distance(v) = newDist;
                    parent(v) = u;
                end
            end
        end
    end

    shortestPath = [];
    if parent(d) ~= 0
        t = d;
        shortestPath = d;
        while t ~= s
            t = parent(t);
            shortestPath = [t shortestPath];
        end
    end

    totalCost = distance(d);
end
