%function to get color codes
%two inputs: color name and index
%one output: [R,G,B]
%usage:getColors('orange4shades',3)
%e.g. figure; hold on; for c=1:4; plot([c c+1],'color',getColors('orange4shades',c)); end

function colorCodes = getColors(colorName,ind)

    turq4shades = [1 66 66; 32 107 107; 103 167 167 ; 167 204 204]/255;
    turq8shades = [1 66 66;   28 107 107;   32 107 107;  56 131 131;  80 149 149;  103 167 167;  143 189 189; 167 204 204]/255;
    turq8shadesTwice= [turq8shades; turq8shades] ; 
    red4shades = [88 0 0; 136 0 0; 192 0 0; 255 0 0]/255;
    black4shades = [0 0 0; 56 56 56; 105 105 105; 184 184 184]/255;
    blue4shades = [0 76 153; 0 102 204; 0 128 255; 51 153 255]/255;
    purple4shades = [102 0 204; 127 0 255; 153 51 255; 178 102 255]/255;
    orange4shades = [255 128 0; 255 153 51; 255 178 102; 255 204 153]/255;
    turq6shades = [0 76 153; 0 128 255; 102 0 204; 153 51 255;255 128 0; 255 178 102;]/255; 
    turq3shades = [0 76 153; 102 0 204; 255 128 0]/255;
    blueRed = [0 0 128; 128 0 0]/255; 
    bluePink=[0 102 204;255 0 255]/255;  
    bluePinkOrange=[0 102 204;255 0 255;255,192,203]/255; 
    posterPink = [157 0 72];
    bluePurpleOrgOrg = [0 76 153; 102 0 204; 255 128 0; 255 204 153]/255; 
    threeCol4shades = [0 76 153; 0 102 204; 0 128 255; 51 153 255; 102 0 204; 127 0 255; 153 51 255; 178 102 255;255 128 0; 255 153 51; 255 178 102; 255 204 153]/255; 

    if strcmp(colorName,'threeCol4shades'); colorCodes = threeCol4shades; end 
    if strcmp(colorName,'turq8shades'); colorCodes = turq8shades; end 
    if strcmp(colorName,'turq8shadesTwice'); colorCodes = turq8shadesTwice; end 
    if strcmp(colorName,'bluePurpleOrgOrg'); colorCodes = bluePurpleOrgOrg; end 
    if strcmp(colorName,'turq4shades');  colorCodes = turq4shades; end
    if strcmp(colorName,'red4shades');   colorCodes = red4shades; end
    if strcmp(colorName,'blue4shades'); colorCodes =   blue4shades; end
    if strcmp(colorName,'purple4shades');  colorCodes = purple4shades; end
    if strcmp(colorName,'orange4shades');  colorCodes =  orange4shades; end
    if strcmp(colorName,'turq6shades');  colorCodes =  turq6shades; end
    if strcmp(colorName,'turq3shades');  colorCodes = turq3shades; end
    if strcmp(colorName,'black4shades');  colorCodes =   black4shades; end
    if strcmp(colorName,'blueRed');  colorCodes =  blueRed; end
    if strcmp(colorName,'bluePink');  colorCodes =  bluePink; end
    if strcmp(colorName,'bluePinkOrange');  colorCodes =  bluePinkOrange; end
    if strcmp(colorName,'posterPink');  colorCodes =  posterPink; end
    try
        if ind~=0
        colorCodes=colorCodes(ind,:);
        end
    end
end