%PROGRAM TO FIND NUMBER OF CORRECT RECOGNITIONS
clc
clear all
total_correct = 0
%MATRIX OF REP IMAGES
for i=1:15
    file_name = ['R',num2str(i),'.pgm']
    image = im2double(imread(file_name))
    image_column = image(:)
    data(:,i) = image_column
end

%COMPARING EACH IMAGE WITH EACH OF THE REP IMAGES
for i=1:15
    for j=1:10
        file_name = [num2str(i),'/',num2str(j),'.pgm']
        image = im2double(imread(file_name))
        image_column = image(:)
        for k=1:15
            n(k) = norm(data(:,k) - image_column)
        end
        [M,I]= min(n)
        output(i,j) = I
    end
end

%CALCULATING NUMBER OF CORRECT
for i=1:15
    for j=1:10
        if output(i,j) == i 
            correct(i,j) = 1
            total_correct = total_correct + 1
        end
    end
end