function [bpgraph] = graphbipartition(graph, alpha, deltaT)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters obtained from the user.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(graph);

N = size(graph,1);

W = graph;
W = W + W' + eye(N);
 

    W = W - alpha;
    bias = N * alpha/2;

    avg_si = rand(N,1)*2-1;
    for T=1:-abs(deltaT):0.1
        disp(round(avg_si*10)');        
        temp = zeros(N,1);
        while(norm(temp-avg_si) ~= 0)
            temp = avg_si;
            avg_si = W * avg_si / T;
            avg_si = tanh(avg_si);
        end
    end

    disp(round(avg_si*10)');        

    ndx1=find(avg_si<0)';
    ndx2=find(avg_si>=0)';
    bpgraph = graph;
    bpgraph(ndx1,ndx2) = 0;
    bpgraph(ndx2,ndx1) = 0;

return;
