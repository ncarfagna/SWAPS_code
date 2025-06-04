function applyDataTip(scatterHandle, curveName)
    scatterHandle.DataTipTemplate.DataTipRows(1).Label = 'X:';
    scatterHandle.DataTipTemplate.DataTipRows(2).Label = 'Y:';
    

    row = dataTipTextRow('Info', @(~,~) curveName);
    scatterHandle.DataTipTemplate.DataTipRows(end+1) = row;
end
