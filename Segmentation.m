clear all
close all
clc
image=imread('L4_GR81.jpg');% cargar imagen

%% PREPROCESAMIENTO
gray=rgb2gray(image);
Imgegray=mat2gray(gray); %Escalar valores entre 0 y 1
Minvar=graythresh(Imgegray);  %Calcula el umbral para minimizar la varianza
Imbin=imbinarize(Imgegray,Minvar); %Binariza con el parametro anterior
comp = imcomplement(Imbin); %calcula el complemento de la imagen 0->1, 1->0

%% ELIMINAR RUIDO
estr=strel('disk',8,8);%crea una elemento estructurante que serà la 
% referencia con un tamaño especificado radio (menor al mas pequeño de las celulas) 
% y elementos de estructuraciòn la cantidad de elementos de estructuraciòn

%figure; imshow(estr.Neighborhood) % visualizar elemento estructuraciòn

Imfilt=imopen(comp,estr); %se abre la imagen de acuerdo a los elementos de 
% estructuraciòn eliminando el ruido de particulas mas pequeñas que nuestro 
% elemento de estructuraciòn

%% APLICAR MASCARA
mask=Imgegray.*double(Imfilt); %multiplicaciòn escalar 1 a 1 entre matrices
% para borrar lo que no nos interesa

%% ALGORITMO CONTEO CELULAS
[tag,totcell]=bwlabel(Imfilt);
fprintf('El total de celulas es: %d\n',totcell);
[row,col]=size(mask);
newIm=ones(row,col); %crea matriz equivalente para explorar imagen

for j=1:row
    for i=1:col
        if (mask(j,i)<=0.44)&&(mask(j,i)>=0.11)  %    if (or_gray(j,i)>=0.11) && (or_gray(j,i)<=0.44)
            newIm(j,i)=0;
        else
            newIm(j,i)=1;
        end
    end
end
newIm=imcomplement(newIm);

figure
subplot(2,1,1);
imshow(Imgegray);
subplot(2,1,2);
imshow(newIm);
babesiosis=strel('disk',4,8); %se crea el elemento estructurados para reconocer parasitos en las celulas
SegmIm=imopen(newIm,babesiosis); %Imagen segmentada final

[tag,ncell]=bwlabel(SegmIm); %elementos conectados
fprintf('Las celulas infectadas por el parasito son: %d\n',ncell);

