function btn_continue(mainFig, ~)

receiv = evalin('base','receiv');

if length(receiv) == 2

    if evalin('base', 'exist(''c'', ''var'')') && evalin('base', 'exist(''fr'', ''var'')')
    
        answ = questdlg('Are you sure about the picked phase dispersion curve ?', 'Confirm', 'Yes', 'No', 'No');
  
        if strcmp(answ,'Yes')
            mainFig.UserData.buttonPressed = 'btn_go'; 
            uiresume(mainFig); 
        end
    else
        msgbox('Phase dispersion curve not found, compute manual or automatic picking','Warning','modal');
    end

elseif length(receiv) > 2

    answ = questdlg('Are you sure about the parameters ?', 'Confirm', 'Yes', 'No', 'No');
         
    if strcmp(answ,'Yes')
        mainFig.UserData.buttonPressed = 'btn_go'; 
        uiresume(mainFig); 
    end    

end
