function progress(totalSteps, currentStep, progressBar, progressText)
    if currentStep > totalSteps
        currentStep = totalSteps;
    elseif currentStep < 0
        currentStep = 0;
    end
    progressRatio = currentStep / totalSteps;
    set(progressBar, 'Position', [0, 0, progressRatio, 1]);
    set(progressText, 'String', sprintf('Step %d of %d', currentStep, totalSteps));
    drawnow;
end