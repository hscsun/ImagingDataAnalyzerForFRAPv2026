function [sree,rii,re,sre]=MoRscan(fig,m,n,positions,cx,cy,rno,poflips,smr,fitting)

fr=imread(fig,1); 
re=[];
sre=[];

[lr,lc]=size(fr);lr=2*lr;lc=2*lc;

    allchannel=m;

    channel=n;


k=1;

for i=positions

        II=imread(fig,allchannel*(i-1)+channel);
        
        if fitting==2
          II=II/poflips(i);  
        else
        II=II*poflips(k);
        end

        if i==7
            dis=1;
        else 
            dis=0;
        end
        re(:,k)=rscan(II,'rlim',rno,'xavg',cx,'yavg',cy,'dispflag',dis);
        control(:,k)=re(:,k);
        re(:,k)=re(:,k)./control(:,1);
        si(:,k)=size(re(:,k))-1;
        ri(:,k)=fliplr(re(:,k)');
        ra(:,k)=ri(1:si,k);
        rii(:,k)=[ra(:,k)' re(:,k)'];
        sree(:,k) = smooth(rii(:,k),smr,'rloess');
        sre(:,k) = smooth(re(:,k));%,0.6,'rloess');
        k=k+1;

%    end
end
