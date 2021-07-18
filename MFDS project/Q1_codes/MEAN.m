%%PROGRAM TO FIND MEAN IMAGE

%CLEAR WORKSPACE
clc
clear all

%FOR EACH OF THE FIFTEEN SUBJECTS
for i=1:15
    %READING AND STORING ALL TEN IMAGES AS A DATA MATRIX
    data = zeros(4096,10)
    sum = zeros(4096,1)
    for j=1:10
        file_name = [num2str(i),'/',num2str(j),'.pgm']
        image = double(imread(file_name))
        image_column = image(:)
        sum = sum + image_column
        data(:,j) = image_column
    end
    %FINDING MEAN OF DATA MATRIX
    mean = sum/10
    for j=1:10
        data(:,j) = data(:,j) - mean
    end
    %COVARIANCE OF DATA MATRIX
    %C = (data)*(data)'
    %PERFORMING SVD ON THE DATA MATRIX
    %[U,S,V] = svd (C)
    %TAKING ONLY THE FIRST EIGENVECTOR (PRINCIPAL COMPONENT)
    principal_component = mean
    %CONVERTING TO IMAGE AND SAVING
    rep_img = reshape (principal_component, 64, 64)
    repname = ['M',num2str(i),'.pgm']
    imshow(mat2gray(rep_img))
    imwrite(mat2gray(rep_img),repname)
end