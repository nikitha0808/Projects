%% To find the no. of new labs that would be needed
%%for testing the new cases

% Import data for the count of cases statewise
covid = readtable('/MATLAB Drive/covid_19_india.csv');
Date = datetime(covid.Date,"InputFormat",'dd/MM/uuuu');
Confirmed = covid.Confirmed;
state = covid.State_UnionTerritory;

% Import data for counting the labs available statewise
labs = readtable('/MATLAB DriveTerm project 2020/Dataset_Question3/ICMRTestingLabs.csv');
lab_state = labs.state;
state2 = findgroups(lab_state);
[Lab_count,Lab_state] = splitapply(@My_func2,lab_state,state2) ;
Test_capacity = 100*Lab_count;

% finding confirmed cases
formatIn = 'dd/mm/yyyy';
low = 1;
for j = 1:length(Date)
    if datenum(string(Date(j)),formatIn)> datenum('10/04/0020',formatIn)
       break
    end
end
up = j-1;

state1 = findgroups(state(1:up,1));
T = array2table([Confirmed(1:up,1),string(state(1:up,1))]);
[net_confirmed1,state_list] = splitapply(@My_func,T,state1 ...
    (1:up,1));

% Array of confirmed cases predicted to be on 20/04/2020 statewise
for i =1:10
    net_confirmed1 = 1.1 * net_confirmed1;
end
net_confirmed1 = floor(net_confirmed1);

%finding the no. of labs each state would need on 20/04/2020
labs_needed = zeros(length(state_list),1);
for i = 1:length(state_list)
    for j = 1:length(Lab_state)
        if state_list(i) == Lab_state(j) && (net_confirmed1(i)>Test_capacity(j))
            labs_needed(i,1) = (net_confirmed1(i)-Test_capacity(j))/100;
        end
    end
end
labs_needed = ceil(labs_needed);

%% Result
TABLE = [state_list,labs_needed];
fprintf("===Labs needed in each state===");
disp(TABLE);

function [a,b] = My_func2(lab_state)
    b = lab_state(1);
    [a,~] = size(lab_state);
end
function [net_confirmed1,statelist] = My_func(Confirmed1,state1)
    statelist = state1(1);
    net_confirmed1 = sum(double(Confirmed1));
end
