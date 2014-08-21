function [ DA, DA_LeftRight ] = getDARightLeft(DA_LL, DA_RR, straightIndex, leftIndex, rightIndex)
leftEnd=1;
rightEnd=1;
straightEnd=1;
maxSize=min([length(DA_LL) length(DA_RR)]);
for i=1:length(leftIndex)
    if (leftIndex(i) > maxSize) && leftEnd
        leftIndex=leftIndex(1:i-1);
        leftEnd=0;
        break;
    end
end
for i=1:length(rightIndex)
    if (rightIndex(i)>maxSize) && rightEnd
        rightIndex=rightIndex(1:i-1);
        rightEnd=0;
        break;
    end
end
for i=1:length(straightIndex)
    if (straightIndex(i) > maxSize) && straightEnd
        straightIndex=straightIndex(1:i-1);
        straightEnd=0;
        break;
    end
end
DA(leftIndex)=DA_LL(leftIndex);
DA(rightIndex)=DA_RR(rightIndex);

for i=1:length(straightIndex)
    if mod(i,2)
        if (i>1) && (DA(straightIndex(i)-1)<DA_LL(straightIndex(i)))
            DA(straightIndex(i))=DA(straightIndex(i)-1)+0.1;
        else
            DA(straightIndex(i))=DA_LL(straightIndex(i));
        end

    else
        if (i>1) && (DA(straightIndex(i)-1)<DA_RR(straightIndex(i)))
            DA(straightIndex(i))=DA(straightIndex(i)-1)+0.1;
        else
            DA(straightIndex(i))=DA_RR(straightIndex(i));
        end        
    end
end

DA_LeftRight=zeros(1,maxSize);
for i=1:maxSize
    if mod(i,2)
        if (i>1) && (DA_LeftRight(i-1)<DA_LL(i))
            DA_LeftRight(i)=DA_LeftRight(i-1)+0.1;
        else
            DA_LeftRight(i)=DA_LL(i);
        end

    else
        if (i>1) && (DA_LeftRight(i-1)<DA_RR(i))
            DA_LeftRight(i)=DA_LeftRight(i-1)+0.1;
        else
            DA_LeftRight(i)=DA_RR(i);
        end        
    end
end
end

