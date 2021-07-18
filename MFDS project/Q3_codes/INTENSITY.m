%Calculating the intensity of spreading of corona virus for each state

%Import data for calculating data for the number of cases
covid_19_india = readtable("/MATLAB Drive/Term project 2020/Term project 2020/Dataset_Question3/covid_19_india.csv");

%Importing data for the population density
population_india_census2011 = readtable("/MATLAB Drive/Term project 2020/Term project 2020/Dataset_Question3/population_india_census2011.csv");


%%Convert to output type(covid_19_india)

StateUnionTerritory = covid_19_india.State_UnionTerritory;
StateUnionTerritory = categorical(StateUnionTerritory);
states =categorical(string(unique(StateUnionTerritory)));
Confirmed = covid_19_india.Confirmed;
l=length(StateUnionTerritory);
w=length(states);
%Removing unassigned cases from states

for i=1:w
    if(states(i)=="Unassigned")
        for j=1:w-i
            states(i)=states(i+1);
            i=i+1;
        end
        states(i)="Not from any state";
    end
end

%Calculating the total number of active case for each state

positivecases(1:w,1)=0;

for i=1:w
    for j=1:l
        if(states(i)==StateUnionTerritory(j))
            positivecases(i) = Confirmed(j);
        end
    end
end


%%Convert to output type(population_india_census2011)

SUTP = population_india_census2011.State_UnionTerritory;
SUTP = categorical(SUTP);
PD = string(population_india_census2011.Density);

%Assigning population densities with its states

lp=length(PD);
p_d(1:lp,1)=0;

for i=1:lp
   p_d(i) = str2double(strtok(PD(i),'/'));
end

pop_density(1:w,1)=0;
for i=1:w
    for j=1:lp
        if(states(i)==SUTP(j))
            pop_density(i)=p_d(j);
        end
    end
end


%%Calculating intensity
intensity(1:w,1)=0;
for i=1:w
    if(states(i)~="Not from any state")
        intensity(i)=(positivecases(i))/(pop_density(i));
    end
end

%figure;
stem(states,intensity);

% Create ylabel
ylabel('  Intensity');
 
% Create xlabel
xlabel('  States');
 
% Create title
title('  Intensities for each state');

%Printing the table
Datatable=table(states,intensity)
