clc;
clear all;

TestDetails = readtable("MATLAB Drive/ICMRTestingDetails.csv");
lab_date=datetime(TestDetails.DateTime,"InputFormat",'dd/MM/uuuu');
tested = TestDetails.TotalSamplesTested;
positive = TestDetails.TotalPositiveCases;

for i = 1:length(lab_date)
    [y,m,d] = ymd(lab_date(i));
    if (y==20)&&(m==4)&&(d==11)
        test_11 = tested(i);
        positive_11 = positive(i);
    end
end

for i = 1:length(lab_date)
    frac_pos(i,1)=positive(i)/tested(i);
end

% Since frac_pos is increasing over time, it is safe to assume that around
% 20/04/2020, the frac_pos will be around 0.06.
fraction = 0.06;
start_count = positive_11;
end_count = start_count;
for i=1:10
    end_count=1.1*end_count;
end
end_count = floor(end_count);

labs_available = test_11/100;
labs_needed = end_count/(100*fraction);
Additional_labs_needed = ceil(labs_needed-labs_available);
disp(Additional_labs_needed);