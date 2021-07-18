%% to find the the state with maximum increase and decrease of hotspots from 20/03/20202 to 10/04/2020
%using the function from the previous question

[states1,Count1] = hotspot_count('20/03/2020');
[states2,Count2] = hotspot_count('27/03/2020');
[states3,Count3] = hotspot_count('03/04/2020');
[states4,Count4] = hotspot_count('10/04/2020');

C = [Count1, Count2, Count3, Count4];

for h = 1:3
   fprintf("\n\n"+"Week"),disp(h);
   diff = (C(:,h+1))-(C(:,h));
   figure;
   bar(diff);
   set(gca,'XTick',[1:30],'XTickLabel',states1,'XTickLabelRotation',90);
   str = ['Week ',num2str(h)];
   title(str);
   xlabel('States');
   ylabel('Change in number of hotspots');
   [max_count,idx] = max(diff);
   fprintf("state with the maximum increase: ");
   disp(states1(idx));
   [min_count,idx2] = min(diff);
   if min_count >= 0
      fprintf("There's no state with decrease in hotspots");
   else 
      fprintf("state with the maximum decrease:");
      disp(states1(idx2));
   end
end

function [states,Count] = hotspot_count(Date)

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 12);

% Specify range and delimiter
opts.DataLines = [1, Inf];
opts.Delimiter = ",";

opts.PreserveVariableNames = true;
opts.VariableNames = ["Var1","Var2", "DiagnosedDate", "Var4", "Var5", "Var6", "DetectedDistrict", "DetectedState", "Var9", "CurrentStatus", "Var11", "Var12"];
opts.SelectedVariableNames = ["DiagnosedDate", "DetectedDistrict", "DetectedState", "CurrentStatus"];
opts.VariableTypes = ["string", "string", "datetime", "string", "string", "string", "string","string","string","categorical", "string", "string"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1","Var2", "Var4", "Var5", "Var6", "DetectedDistrict", "DetectedState", "Var9", "Var11", "Var12"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1","Var2", "Var4", "Var5", "Var6", "DetectedDistrict", "DetectedState", "Var9", "Var11", "Var12"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "DiagnosedDate", "InputFormat", "dd/MM/yyyy");

raw_data = readtable("/MATLAB Drive/IndividualDetails.csv",opts);

%% Convert to output type
DiagnosedDate = raw_data.DiagnosedDate;
DetectedDistrict = raw_data.DetectedDistrict;
DetectedState = raw_data.DetectedState;
CurrentStatus = raw_data.CurrentStatus;

%% Clear temporary variables
clear opts raw_data

%%*finding the areas with more than 10 cases:*

%excluding cells with insufficient data(empty cells basically)
len = length(DetectedDistrict);
j=1;
for i = 2:len
    if DetectedDistrict(i) ~= ""
        detected_city1(j,1) = DetectedDistrict(i);
        start_date1(j,1) = DiagnosedDate(i);
        current_status1(j,1) = CurrentStatus(i);
        detected_state1(j,1) = DetectedState(i);
        j=j+1;
    end
end

%grouping according to district and finding the no. of diagnosed in each
%district
T = array2table([string(start_date1), string(current_status1),string(detected_state1)]);

diff_district = findgroups(detected_city1);
[net_diagnosed,state_list] = splitapply(@totalcases,T,diff_district);


districts = unique(detected_city1);
states = unique(detected_state1);

[m,~] = size(districts);
p=1;
for i = 1:m
    if net_diagnosed(i) >= 10
       hotspots(p,1) = districts(i);
       hotspot_state(p,1) = state_list(i);
       p=p+1;
    end
end

%counting and plotting states with their no.of hotspots
num = length(states);
Count = zeros(num,1);
for x = 1:num
    for y = 1:length(hotspot_state)
        if hotspot_state(y) == states(x)
            Count(x)= Count(x)+1;
        end
    end
end

function [total,state_list] = totalcases(X,current_status1,detected_state1)
    state_list = detected_state1(1);
    [a,b] = size(X);
    j=0;
    formatIn ='dd/mm/yyyy';
    for k = 1: a
        if datenum(X(k,1:b),formatIn) <= datenum(Date,formatIn) & current_status1(k) == 'Hospitalized'
           j=j+1;
        end
    end
    total = j;
end
end
