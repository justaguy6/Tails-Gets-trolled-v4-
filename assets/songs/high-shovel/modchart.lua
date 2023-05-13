function postModifierRegister()
    if not disableModcharts then
        queueEaseP(1152, 1152+64, "tipsy", 25, "quartInOut", -1);
		queueEaseP(1152, 1152+64, "drunk", 25, "quartInOut", -1);
    end
end