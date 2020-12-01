function [P T] = clusterPlot(p_val,t_val,alpha,numconsec,time,labels,epochLen,numChans,figname)

T= zeros(size(p_val));
P= alpha*1.3*ones(size(t_val));

T_temp= zeros(size(p_val));
P_temp= alpha*1.3*ones(size(t_val));

    
%modify T_temp based on t_val and numconsec
%modify P_temp based on p_val and numconsec
for k=1:size(p_val,2)
    for i=1:size(p_val,1)
    if k>floor(numconsec/2) & k+(numconsec/2)<=size(p_val,2)
        if p_val(i,k-floor(numconsec/2)+[1:numconsec]) < alpha 
            T_temp(i,k-floor(numconsec/2)+[1:numconsec])=t_val(i,k-floor(numconsec/2)+[1:numconsec]);
            P_temp(i,k-floor(numconsec/2)+[1:numconsec])=p_val(i,k-floor(numconsec/2)+[1:numconsec]);
        end
    end
    end
end

% we do it if length(consec_ch) >3
%modify T based on t_val and numconsec
%modify P based on p_val and numconsec
for k=1:size(p_val,2)
    consec_ch=find(P_temp(1:numChans,k) < alpha);
    disp([num2str(k) '...' num2str(length(consec_ch)) ])
    for i=1:size(p_val,1)
        if k>floor(numconsec/2) & k+(numconsec/2)<=size(p_val,2) &  length(consec_ch) >3
        if P_temp(i,k-floor(numconsec/2)+[1:numconsec]) < alpha 
        T(i,k-floor(numconsec/2)+[1:numconsec])=t_val(i,k-floor(numconsec/2)+[1:numconsec]);
        P(i,k-floor(numconsec/2)+[1:numconsec])=p_val(i,k-floor(numconsec/2)+[1:numconsec]);
        end
        end
    end
end

re_order=[1:numChans];

%plot P using surf function (plots the colored parametric surface)
f=surf(time,[1:numChans],P(re_order,1:epochLen));
set(gcf,'Name',figname);
set(f,'EdgeColor','none'); %Remove black edges
set(gcf,'Renderer','zbuffer');
view(2)
axis tight  
grid off
box on
colorbar;
colormap(flipud(parula));%flipud(jet)
ylabel('channels'); xlabel('ms');


