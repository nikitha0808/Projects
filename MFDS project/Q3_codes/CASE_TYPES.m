%Import data
individual_details = readtable("TermProject2020/Dataset_Question3/IndividualDetails.csv");

%convert to output type
notes = string(individual_details.notes);
state = string(individual_details.detected_state);
nationality = string(individual_details.nationality);
state_count = findgroups(state);
[total,state_list] = splitapply(@my_func,state,state_count);

[b,idx] = maxk(total,5);
top_state = state_list(idx);

primary = zeros(5,1);
secondary = zeros(5,1);
tertiary = zeros(5,1);

for k = 1:length(top_state)
    prim_count = 0;
    sec_count = 0;
    tert_count = 0;
    for i = 1:length(state)
        if (state(i) == top_state(k)) && (contains(notes(i),{'P1','P2','P3','P4','P5','P6','P7','P8','P9','Delhi','contact'},'IgnoreCase',true)==true)
            sec_count = sec_count +1;
        elseif (state(i) == top_state(k)) && ((contains(notes(i),{'Travelled from','Travelled to','travel history to','foreign travel history','travel history of','travel history from','internatinal history'},'IgnoreCase',true) == true)|...
        ((nationality(i) ~='India')&& (nationality(i) ~='')&&(nationality(i)~='Indian')))         
            prim_count = prim_count +1;
        elseif (state(i) == top_state(k)) &&(contains(notes(i),{'tourist','doctor','hospital','contracted from','tenant','visited','relative''local transmission'},'IgnoreCase',true)==true)
            sec_count = sec_count +1;
        else
            tert_count = tert_count +1;
        end
    end
    primary(k,1) = prim_count;
    secondary(k,1) = sec_count;
    tertiary(k,1) = tert_count;
end

for i = 1:5
    percent_pri(i,1) = (primary(i)/sum(primary))*100;
    percent_sec(i,1) = (secondary(i)/sum(secondary))*100;
    percent_ter(i,1) = (tertiary(i)/sum(tertiary))*100;
end

top_total(:,1) = primary;
top_total(:,2) = secondary;
top_total(:,3) = tertiary;

figure;
bar(top_total,'stacked');
set(gca,'XTick',[1:5],'XTickLabel',top_state,'XTickLabelRotation',90);
title("Types of cases in top 5 states");
xlabel('States');
ylabel('Number of cases');
legend("Primary Cases","Secondary Cases","Tertiary Cases","Location",'northeastoutside');

figure;
pie(percent_pri);
legend(top_state',"Location",'northeastoutside');
title('---Percentage of primary cases---');
figure;
pie(percent_sec);
legend(top_state',"Location",'northeastoutside');
title('---Percentage of secondary cases---');
figure;
pie(percent_ter);
legend(top_state',"Location",'northeastoutside');
title('---Percentage of tertiary cases---');

function [total,state_list] = my_func(state)
    state_list = state(1);
    [total ,~] = size(state);
end 