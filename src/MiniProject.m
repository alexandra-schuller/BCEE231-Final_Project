clc
clear
%loading data and selecting date rows and data row
load data_sectionM.mat
data=[SECTION_M(1,4:end);
   SECTION_M(2,4:end);
   SECTION_M(3,4:end);
   SECTION_M(51,4:end)];

%{
%Making sure data is good, adding extra decimals to check if more data.
column=5;
year=data(1,column);
month=data(2,column);
day=data(3,column);
temperature=data(4,column);
fprintf('year=%d month=%d day=%d temperature=%.8f\n,',year,month,day,temperature)
%}

%extracting monthly mean, maximum, and minimum temperatures from the data. This
%will create three row vectors with 504 items in each because there are 504
%months in 42 years of data.
%means
%max
%mins

%prepare for loop
%set empty vectors
current_month=1 ;
temperatures=[];
mean_monthly_temperatures=[];
max_monthly_temperatures=[];
min_monthly_temperatures=[];
%set loop for finding the hottest and coldest temperature along with when
%they occured
hottest.temp=-1000;
coldest.temp=1000;
%run through data
for i=1:length(data)
    year=data(1,i);
    month=data(2,i);
    day=data(3,i);
    temp=data(4,i);
    %within loop, append to vectors
    if month~=current_month
       len=length(mean_monthly_temperatures);
       mean_monthly_temperatures(len+1)=mean(temperatures);
       max_monthly_temperatures(len+1)=max(temperatures);
       min_monthly_temperatures(len+1)=min(temperatures);
       temperatures=[];
    end
    temperatures(day)=temp;
    %locate when hottest or coldest temperature happened
    if hottest.temp < temp
        hottest=struct('temp',temp,'year',year,'month',month,'day',day);
    end
     if coldest.temp > temp
         coldest=struct('temp',temp,'year',year,'month',month,'day',day);
    end
    current_month=month;
end
len=length(mean_monthly_temperatures);
%disp for assignment clarity so leaving out semicolon
mean_monthly_temperatures(len+1)=mean(temperatures)
max_monthly_temperatures(len+1)=max(temperatures)
min_monthly_temperatures(len+1)=min(temperatures)
disp(hottest)
disp(coldest)
        
%making x-axis for graph
datestamps=(datetime(1975,1,1):calmonths(1):datetime(2016,12,31));
datestamps.Format='MMM-yyyy';

%plot the three graphs in one figure 
figure(1)
subplot(3,1,1) 
plot(datestamps,mean_monthly_temperatures,'k-')
xlabel('Months between Jan-1975 and Dec-2016')
ylabel('Temperature(C°)')
title('Mean Monthly Temperature at Longitude -176.875, Latitude 83.625')

subplot(3,1,2) 
plot(datestamps,max_monthly_temperatures,'k-')
xlabel('Months between Jan-1975 and Dec-2016')
ylabel('Temperature(C°)')
title('Maximum Monthly Temperature at Longitude -176.875, Latitude 83.625')

subplot(3,1,3) 
plot(datestamps,min_monthly_temperatures,'k-')
xlabel('Months between Jan-1975 and Dec-2016')
ylabel('Temperature(C°)')
title('Mininum Monthly Temperature at Longitude -176.875, Latitude 83.625')

%need to extract all months together
% alljans=mean_monthly_temperatures(1:12:504);
%allfebs=mean_monthly_temperatures(2:12:504);
%allmars=mean_monthly_temperatures(3:12:504);
%above is too lengthy so prepare for a loop to create a matrix

allmeans = zeros(12,42);
allmax = zeros(12,42);
allmin = zeros(12,42);
for i=1:12 
  allmeans(i,:)=mean_monthly_temperatures(i:12:504);
  allmax(i,:)=max_monthly_temperatures(i:12:504);
  allmin(i,:)=min_monthly_temperatures(i:12:504);
end
%combine matrices and display
allmonths=cat(1,allmeans,allmax,allmin)


juliantable=zeros(36,6);
for i=1:36
    juliantable(i,1)=min(allmonths(i,:));
    juliantable(i,2)=mean(allmonths(i,:));
    juliantable(i,3)=median(allmonths(i,:));
    juliantable(i,4)=mode(allmonths(i,:));
    juliantable(i,5)=max(allmonths(i,:));
    juliantable(i,6)=std(allmonths(i,:));
end
%create labelled table
description={'min','mean','median','mode','max','std'};
months={'Jan(Mean)','Feb(Mean)','Mar(Mean)','Apr(Mean)','May(Mean)','Jun(Mean)','Jul(Mean)','Aug(Mean)','Sep(Mean)','Oct(Mean)','Nov(Mean)','Dec(Mean)','Jan(ExtMax)','Feb(ExtMax)','Mar(ExtMax)','Apr(ExtMax)','May(ExtMax)','Jun(ExtMax)','Jul(ExtMax)','Aug(ExtMax)','Sep(ExtMax)','Oct(ExtMax)','Nov(ExtMax)','Dec(ExtMax)','Jan(ExtMin)','Feb(ExtMin)','Mar(ExtMin)','Apr(ExtMin)','May(ExtMin)','Jun(ExtMin)','Jul(ExtMin)','Aug(ExtMin)','Sep(ExtMin)','Oct(ExtMin)','Nov(ExtMin)','Dec(ExtMin)'};
juliantablelabelled=array2table(juliantable,'VariableNames',description,'RowNames',months);
writetable(juliantablelabelled,'juliantable.xls','WriteRowNames',true)
disp(juliantablelabelled)

%write a function to polyfit, subplot, and return slopes
slopesmean=showpolyfittemp(2,allmeans,'Mean Temp(C°)')';
slopesmax=showpolyfittemp(3,allmax,'Max Temp(C°)')';
slopesmin=showpolyfittemp(4,allmin,'Min Temp(C°)')';

%create a table with the slopes
description={'Months','Mean T','ExtMax T','ExtMin T'};
months={'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'}';
SlopeTable=table(months,slopesmean,slopesmax,slopesmin,'VariableNames',description);
disp(SlopeTable)
writetable(SlopeTable,'slopetable.xls')