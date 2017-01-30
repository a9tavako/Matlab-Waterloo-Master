function [roundi,roundj] = roundToAGridPoint(i,j,xRes,yRes)

roundi = floor(i/xRes)*xRes;
roundj = floor(j/yRes)*yRes;

end