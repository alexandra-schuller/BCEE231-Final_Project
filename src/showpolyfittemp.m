function lines=showpolyfittemp(figurenum,data,ylabelname)
%SHOWPOLYFITTEMP graphs with subplot 
% and returns slope of polyfit line
figure(figurenum)
for i = 1:12
num=i;
x = 1975:2016;
y = data(i,:);
subplot(3,4,i)
line=polyfit(x,y,1);
lines(i)=line(1);
curve=polyval(line,x);
plot(x,y,'k-')
axis([1975 2016 min(y)-1 max(y)+1]);
hold on
plot(x,curve)
hold off
xlabel('Year')
ylabel(ylabelname)
title(sprintf('Month %.d',num))
end
end