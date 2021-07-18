clc;
clear all;
opts = delimitedTextImportOptions("NumVariables", 4);
opts.DataLines = 2;
opts.Delimiter = ",";
opts.VariableNames = ["SNo", "AgeGroup", "TotalCases", "Percentage"];
opts.VariableTypes = ["int8", "categorical", "int8", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, [1,2,3], "EmptyFieldRule", "auto");
opts = setvaropts(opts, 4, "TrimNonNumeric", true);
opts = setvaropts(opts, 4, "ThousandsSeparator", ",");
opts = setvaropts(opts, 4, "Suffixes", "%");
AgeGroupDetails = readtable("TermProject2020/Dataset_Question3/AgeGroupDetails.csv", opts);

opts2 = delimitedTextImportOptions("NumVariables", 12);
opts2.DataLines = 2;
opts2.Delimiter = ",";
opts2.ExtraColumnsRule = "ignore";
opts2.EmptyLineRule = "read";
opts2.VariableNames = ["Var1", "Var2","Var3","age","Var5","Var6","Var7","Var8","Var9","status","Var11", "Var12"];
opts2.VariableTypes = ["string","string","string","int8","string","string","string","string","string","string","string","string"];
IndividualDetails = readtable("TermProject2020/Dataset_Question3/IndividualDetails.csv",opts2);

AgeGroup = AgeGroupDetails.AgeGroup;
Percentage = AgeGroupDetails.Percentage;
B=sort(Percentage);

Age = IndividualDetails.age;
Status = IndividualDetails.status;

Agestr = cellstr(AgeGroup);
for i=1:10
AgeGrp(i,:)=strsplit(char(Agestr(i)),"-");
end


l = height(IndividualDetails);
l2 = height(AgeGroupDetails);

data = zeros(l2,6);
for i=1:l2
    data(i,1)=str2double(AgeGrp(i,1));
    data(i,2)=str2double(AgeGrp(i,2));
end
data(l2-1,1)=data(l2-2,2)+1;
data(l2-1,2)=inf;

for i=1:l
    if (Age(i)==0)
        if Status(i)=="Recovered"
            data(l2,3) = data(l2,3)+1;
        elseif Status(i)=="Deceased"
            data(l2,4) = data(l2,4)+1;
        elseif Status(i)=="Hospitalized"
            data(l2,5) = data(l2,5)+1;
        end
    else
        for j=1:l2
            if (Age(i)>=data(j,1))&&(Age(i)<=data(j,2))
                if Status(i)=="Recovered"
                data(j,3) = data(j,3)+1;
                elseif Status(i)=="Deceased"
                data(j,4) = data(j,4)+1;
                elseif Status(i)=="Hospitalized"
                data(j,5) = data(j,5)+1;
                end
            end
        end
    end
end

for i=1:l2
    data(i,6)= data(i,4)/(data(i,3));
end
[newdata,order]= sortrows(data,[6,5]);

b = bar(AgeGroup,Percentage,0.4,'FaceColor','flat');
for i =1:length(AgeGroup)
    for j=1:l2
    if i==order(j)
        b.CData(i,:) = [1-(j/10),1-(j/10),1-(j/10)];
    end
    end
end
hold on;
ylabel('Percentage');
xlabel('Age Group');
title('Age Group Details');
ylim([0 30]);
[Y_max, index] = max(Percentage);
X_max = AgeGroup(index);
txt = ' Highest: ('+string(X_max)+','+string(Y_max)+')';
text(X_max,Y_max+1,txt);
