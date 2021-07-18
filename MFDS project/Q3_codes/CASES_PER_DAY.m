clear all;

global confirmed;
global cured;
global deaths;
global states;
global list;
global Bar_x;
global Bar_y;
global Bar_y_cumulative;
global fig;

opts = delimitedTextImportOptions("NumVariables", 9);
opts.DataLines = 2;
opts.VariableNames = ["SNo", "Date","Time","StateUnionTerritory","Confirmed_Indian","Confirmed_Foreign","Cured","Deaths","Confirmed"];
opts.VariableTypes = ["int8", "string","string","string", "double","double","double","double","double"];
covid_19_india = readtable("TermProject2020/Dataset_Question3/covid_19_india.csv",opts);

Date = string(covid_19_india.Date);
Time = string(covid_19_india.Time);
date_time = Date + ' '+ Time;
date_time = datetime(date_time,'InputFormat',"dd/MM/yy hh:mm aa");
covid_19_india = [covid_19_india, table(date_time)];

states = string(unique(covid_19_india.StateUnionTerritory));

len = height(covid_19_india);
numstates = size(states);

daynumber = zeros(len,1);
n = 1;
Comp_date = Date(1);
for i=1:len
    if Date(i)==Comp_date
        daynumber(i)=n;
    else
        n = n+1;
        daynumber(i)=n;
        Comp_date=Date(i);
    end
end
covid_19_india = [covid_19_india, table(daynumber)];

confirmed = zeros(numstates(1)+1,n);
cured = zeros(numstates(1)+1,n);
deaths = zeros(numstates(1)+1,n);

for i=1:len
    for j=1:numstates(1)
        if covid_19_india.StateUnionTerritory(i) == states (j)
            confirmed(j,daynumber(i))=covid_19_india.Confirmed(i);
            cured(j,daynumber(i))=covid_19_india.Cured(i);
            deaths(j,daynumber(i))=covid_19_india.Deaths(i);
        end
    end
end
confirmed(numstates(1)+1,:)=sum(confirmed);
cured(numstates(1)+1,:)=sum(cured);
deaths(numstates(1)+1,:)=sum(deaths);

% confirmed(confirmed == 0) = NaN
% cured(cured == 0) = NaN
% deaths(deaths == 0) = NaN

Date_Time = unique(date_time);
clearvars Comp_date covid_19_india Date date_time daynumber i j len n numstates opts Time;

list = ["All India",(states)'];
Bar_x=Date_Time;
Bar_y_cumulative(:,1)=(confirmed(33,:))';
Bar_y(:,1)=Bar_y_cumulative(:,1);
for i=1:68
    Bar_y(69+1-i,1) = Bar_y(69+1-i,1) - Bar_y(69-i,1);
end
Bar_y_cumulative(:,2)=(cured(33,:))';
Bar_y(:,2)=Bar_y_cumulative(:,2);
for i=1:68
    Bar_y(69+1-i,2) = Bar_y(69+1-i,2) - Bar_y(69-i,2);
end
Bar_y_cumulative(:,3)=(deaths(33,:))';
Bar_y(:,3)=Bar_y_cumulative(:,3);
for i=1:68
    Bar_y(69+1-i,3) = Bar_y(69+1-i,3) - Bar_y(69-i,3);
end

clearvars Date_Time i;

fig = uifigure;
fig.Position = [10 50 1500 780];
dd = uidropdown(fig,'Items',list ,'Value','All India','Position',[550 750 400 20], 'ValueChangedFcn',@(dd,event) selection(dd));
ax = uiaxes('Parent',fig,'Position',[10 10 730 700]);
b = stem(ax, Bar_x,Bar_y,'d','filled','MarkerSize',4);
b(3).Color = [0.4660 0.6740 0.1880];
legend(ax,{'Confirmed','Cured','Deaths'},'Location','northwest');
ax2 = uiaxes('Parent',fig,'Position',[760 10 730 700]);
c = stem(ax2, Bar_x,Bar_y_cumulative,'d','filled','MarkerSize',4);
c(3).Color = [0.4660 0.6740 0.1880];
legend(ax2,{'Confirmed','Cured','Deaths'},'Location','northwest');
ax.Title.String = 'New cases';
ax2.Title.String = 'Cumulative cases';

function selection(dd)
    global confirmed;
    global cured;
    global deaths;
    global states;
    global list;
    global Bar_x;
    global Bar_y;
    global Bar_y_cumulative;
    global fig;
    val = dd.Value;
    if val =="All India"
        Bar_y_cumulative(:,1)=(confirmed(33,:))';
        Bar_y_cumulative(:,2)=(cured(33,:))';
        Bar_y_cumulative(:,3)=(deaths(33,:))';
    else
        for i = 1:32
            if (val==states(i))
                Bar_y_cumulative(:,1)=(confirmed(i,:))';
                Bar_y_cumulative(:,2)=(cured(i,:))';
                Bar_y_cumulative(:,3)=(deaths(i,:))';
            end
        end
    end
    Bar_y(:,1)=Bar_y_cumulative(:,1);
    for i=1:68
        Bar_y(69+1-i,1) = Bar_y(69+1-i,1) - Bar_y(69-i,1);
    end
    Bar_y(:,2)=Bar_y_cumulative(:,2);
    for i=1:68
        Bar_y(69+1-i,2) = Bar_y(69+1-i,2) - Bar_y(69-i,2);
    end
    Bar_y(:,3)=Bar_y_cumulative(:,3);
    for i=1:68
        Bar_y(69+1-i,3) = Bar_y(69+1-i,3) - Bar_y(69-i,3);
    end
    ax = uiaxes('Parent',fig,'Position',[10 10 730 700]);
    b = stem(ax, Bar_x,Bar_y,'d','filled','MarkerSize',4);
    b(3).Color = [0.4660 0.6740 0.1880];
    legend(ax,{'Confirmed','Cured','Deaths'},'Location','northwest');
    ax2 = uiaxes('Parent',fig,'Position',[760 10 730 700]);
    c = stem(ax2, Bar_x,Bar_y_cumulative,'d','filled','MarkerSize',4);
    c(3).Color = [0.4660 0.6740 0.1880];
    legend(ax2,{'Confirmed','Cured','Deaths'},'Location','northwest');
    ax.Title.String = 'New cases';
    ax2.Title.String = 'Cumulative cases';
end