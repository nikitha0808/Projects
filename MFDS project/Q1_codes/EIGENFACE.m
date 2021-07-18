%%PROGRAM TO FIND REPRESENTATIVE IMAGE

%CLEARING WORKSPACE
clc;
clear;

%FOR EACH OF THE FIFTEEN SUBJECTS
for i=1:15
    
    %DATA MATRIX FOR EACH SUBJECT
    for k=1:10
        filename{k}=[num2str(i),'/',num2str(k),'.pgm'];
        personface{k}=imread(filename{k});
        image{k}=im2double(personface{k});
    end
    for k=1:10
        image_column{k}=image{k}(:);
    end
    for k=1:10
        data(:,k)=image_column{k}(:);
    end
    
    %FINDING MEAN FOR EACH IMAGE
    mean=image_column{k};
    for k=2:10
        mean=mean+image_column{k};
    end
    mean=mean/10;
    for k=1:10
        data(:,k)=image_column{k}(:)-mean(:);
    end
    
    %FINDING THE PRINCIPAL EIGENVECTOR AND IT'S WEIGHT USING SVD
    covariance=(data)*(data)';
    [u,s,v]=svd(covariance);
    weight{1}=(u(:,1))'*(u(:,1));
    
    %FORMING AND SAVING THE REPRESENTATIVE IMAGE
    img=(weight{1}*(u(:,1)))+ mean ;
    img= reshape(img,64,64);
    representativeimage=mat2gray(img);
    imshow(representativeimage);
    repname=['R',num2str(i),'.pgm'];
    imwrite(representativeimage,repname);
end