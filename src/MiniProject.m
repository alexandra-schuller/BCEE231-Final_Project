clc
clear
load data_sectionM.mat
data=[SECTION_M(1,4:end);
   SECTION_M(2,4:end);
   SECTION_M(3,4:end);
   SECTION_M(51,4:end)];

%{
%Making sure data is good, adding extra decimals for more data.
column=5;
year=data(1,column);
month=data(2,column);
day=data(3,column);
temperature=data(4,column);
fprintf('year=%d month=%d day=%d temperature=%.8f\n,',year,month,day,temperature)
%}

%means
%{
current_month=1 ;
temperatures=[];
mean_monthly_temperatures=[];
for i=1:length(data)
    year=data(1,i);
    month=data(2,i);
    day=data(3,i);
    if month~=current_month
       len=length(mean_monthly_temperatures);
       mean_monthly_temperatures(len+1)=mean(temperatures);
       temperatures=[];
    end
    temperatures(day)=data(4,i);
    current_month=month;
end
len=length(mean_monthly_temperatures);
mean_monthly_temperatures(len+1)=mean(temperatures);
%disp (mean_monthly_temperatures)

datestamps=(datetime(1975,1,1):calmonths(1):datetime(2016,12,31))
datestamps.Format='MMM-yyyy';
plot(datestamps,mean_monthly_temperatures,'k-')
xlabel('Months between Jan-1975 and Dec-2016')
ylabel('Temperature(C°)')
title('Mean Monthly Temperature at Longitude -176.875, Latitude 83.625')
%}

current_month=1 ;
temperatures=[];
max_monthly_temperatures=[];
for i=1:length(data)
    year=data(1,i);
    month=data(2,i);
    day=data(3,i);
    if month~=current_month
       len=length(max_monthly_temperatures);
       max_monthly_temperatures(len+1)=max(temperatures);
       temperatures=[];
    end
    temperatures(day)=data(4,i);
    current_month=month;
end
len=length(max_monthly_temperatures);
max_monthly_temperatures(len+1)=max(temperatures);
disp (max_monthly_temperatures)























