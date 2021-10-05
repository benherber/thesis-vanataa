classdef vanatta_interactive < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        WavelengthEditField          matlab.ui.control.NumericEditField
        WavelengthEditFieldLabel     matlab.ui.control.Label
        CurrSpacingEditField         matlab.ui.control.NumericEditField
        CurrSpacingEditFieldLabel    matlab.ui.control.Label
        CurrAngleEditField           matlab.ui.control.NumericEditField
        CurrAngleEditFieldLabel      matlab.ui.control.Label
        CurrElementsEditField        matlab.ui.control.NumericEditField
        CurrElementsEditFieldLabel   matlab.ui.control.Label
        ElementSpacingnlambdaSlider  matlab.ui.control.Slider
        ElementSpacingnlambdaSliderLabel  matlab.ui.control.Label
        ImpingingAngleSlider         matlab.ui.control.Slider
        ImpingingAngleLabel          matlab.ui.control.Label
        NumberofElementsSlider       matlab.ui.control.Slider
        NumberofElementsSliderLabel  matlab.ui.control.Label
        ReflectedRadiationPanel      matlab.ui.container.Panel
        ContextMenu                  matlab.ui.container.ContextMenu
        Menu                         matlab.ui.container.Menu
        Menu2                        matlab.ui.container.Menu
    end

    
    properties (Access = private)
        pax;
        elem_spacing;
        num_elements;
        theta_imping;
        lambda;
    end
    
    methods (Access = private)
        
        function resE = find_reflectedE(app, incoming_E, theta_obs)
            tmp = 0;
            for idx = 1:app.num_elements
                tmp = tmp + exp(sqrt(-1)*((2.0*pi)/app.lambda)*app.elem_spacing*(idx-1)*(cos(theta_obs)-cos(app.theta_imping)));
            end
        
            resE = incoming_E*tmp;
        end
        
        function plot(app)
                array_factor = zeros(1,360);
                angles = zeros(1,360);
        
            for theta_obs = 1:360
                angles(theta_obs) = deg2rad(theta_obs);
                array_factor(theta_obs) = app.find_reflectedE(1, deg2rad(theta_obs));
                array_factor(theta_obs) = abs(array_factor(theta_obs));
            end
            
            polarplot(app.pax, angles, array_factor);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
                app.pax = polaraxes(app.ReflectedRadiationPanel);
                vanatta;
                app.elem_spacing = 0.5;
                app.num_elements = 2;
                app.theta_imping = 90;
                app.lambda = 2.4E9;
        end

        % Value changed function: ElementSpacingnlambdaSlider, 
        % ImpingingAngleSlider, NumberofElementsSlider, WavelengthEditField
        function NumberofElementsSliderValueChanged(app, event)
            app.lambda = app.WavelengthEditField.Value;

            app.num_elements = floor(app.NumberofElementsSlider.Value);
            app.CurrElementsEditField.Value = app.num_elements;
            
            app.theta_imping = deg2rad(app.ImpingingAngleSlider.Value);
            app.CurrAngleEditField.Value = app.ImpingingAngleSlider.Value;

            app.elem_spacing = app.ElementSpacingnlambdaSlider.Value * app.lambda;
            app.CurrSpacingEditField.Value = app.ElementSpacingnlambdaSlider.Value;

            app.plot();
        end

        % Callback function
        function ImpingingAngleSliderValueChanged(app, event)

        end

        % Callback function
        function ElementSpacingnlambdaSliderValueChanged(app, event)

        end

        % Callback function
        function WavelengthEditFieldValueChanged(app, event)

        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 731 477];
            app.UIFigure.Name = 'MATLAB App';

            % Create ReflectedRadiationPanel
            app.ReflectedRadiationPanel = uipanel(app.UIFigure);
            app.ReflectedRadiationPanel.Title = 'ReflectedRadiation';
            app.ReflectedRadiationPanel.Position = [30 26 428 439];

            % Create NumberofElementsSliderLabel
            app.NumberofElementsSliderLabel = uilabel(app.UIFigure);
            app.NumberofElementsSliderLabel.HorizontalAlignment = 'right';
            app.NumberofElementsSliderLabel.Position = [468 420 55 42];
            app.NumberofElementsSliderLabel.Text = {'Number'; 'of'; 'Elements'; ''};

            % Create NumberofElementsSlider
            app.NumberofElementsSlider = uislider(app.UIFigure);
            app.NumberofElementsSlider.Limits = [2 32];
            app.NumberofElementsSlider.ValueChangedFcn = createCallbackFcn(app, @NumberofElementsSliderValueChanged, true);
            app.NumberofElementsSlider.Position = [544 449 150 3];
            app.NumberofElementsSlider.Value = 2;

            % Create ImpingingAngleLabel
            app.ImpingingAngleLabel = uilabel(app.UIFigure);
            app.ImpingingAngleLabel.HorizontalAlignment = 'right';
            app.ImpingingAngleLabel.Position = [466 365 58 28];
            app.ImpingingAngleLabel.Text = {'Impinging'; 'Angle'};

            % Create ImpingingAngleSlider
            app.ImpingingAngleSlider = uislider(app.UIFigure);
            app.ImpingingAngleSlider.Limits = [0 180];
            app.ImpingingAngleSlider.ValueChangedFcn = createCallbackFcn(app, @NumberofElementsSliderValueChanged, true);
            app.ImpingingAngleSlider.Position = [545 380 150 3];
            app.ImpingingAngleSlider.Value = 90;

            % Create ElementSpacingnlambdaSliderLabel
            app.ElementSpacingnlambdaSliderLabel = uilabel(app.UIFigure);
            app.ElementSpacingnlambdaSliderLabel.HorizontalAlignment = 'right';
            app.ElementSpacingnlambdaSliderLabel.Position = [458 283 67 42];
            app.ElementSpacingnlambdaSliderLabel.Text = {'Element'; 'Spacing'; '(n*\lambda)'};

            % Create ElementSpacingnlambdaSlider
            app.ElementSpacingnlambdaSlider = uislider(app.UIFigure);
            app.ElementSpacingnlambdaSlider.Limits = [0 8];
            app.ElementSpacingnlambdaSlider.ValueChangedFcn = createCallbackFcn(app, @NumberofElementsSliderValueChanged, true);
            app.ElementSpacingnlambdaSlider.Position = [546 312 150 3];
            app.ElementSpacingnlambdaSlider.Value = 0.5;

            % Create CurrElementsEditFieldLabel
            app.CurrElementsEditFieldLabel = uilabel(app.UIFigure);
            app.CurrElementsEditFieldLabel.HorizontalAlignment = 'right';
            app.CurrElementsEditFieldLabel.Position = [482 114 82 22];
            app.CurrElementsEditFieldLabel.Text = 'Curr Elements';

            % Create CurrElementsEditField
            app.CurrElementsEditField = uieditfield(app.UIFigure, 'numeric');
            app.CurrElementsEditField.Editable = 'off';
            app.CurrElementsEditField.Position = [579 114 100 22];
            app.CurrElementsEditField.Value = 2;

            % Create CurrAngleEditFieldLabel
            app.CurrAngleEditFieldLabel = uilabel(app.UIFigure);
            app.CurrAngleEditFieldLabel.HorizontalAlignment = 'right';
            app.CurrAngleEditFieldLabel.Position = [502 73 63 22];
            app.CurrAngleEditFieldLabel.Text = 'Curr Angle';

            % Create CurrAngleEditField
            app.CurrAngleEditField = uieditfield(app.UIFigure, 'numeric');
            app.CurrAngleEditField.Editable = 'off';
            app.CurrAngleEditField.Position = [580 73 100 22];
            app.CurrAngleEditField.Value = 90;

            % Create CurrSpacingEditFieldLabel
            app.CurrSpacingEditFieldLabel = uilabel(app.UIFigure);
            app.CurrSpacingEditFieldLabel.HorizontalAlignment = 'right';
            app.CurrSpacingEditFieldLabel.Position = [489 32 76 22];
            app.CurrSpacingEditFieldLabel.Text = 'Curr Spacing';

            % Create CurrSpacingEditField
            app.CurrSpacingEditField = uieditfield(app.UIFigure, 'numeric');
            app.CurrSpacingEditField.Limits = [0 Inf];
            app.CurrSpacingEditField.Editable = 'off';
            app.CurrSpacingEditField.Position = [580 32 100 22];
            app.CurrSpacingEditField.Value = 0.5;

            % Create WavelengthEditFieldLabel
            app.WavelengthEditFieldLabel = uilabel(app.UIFigure);
            app.WavelengthEditFieldLabel.HorizontalAlignment = 'right';
            app.WavelengthEditFieldLabel.Position = [496 234 68 22];
            app.WavelengthEditFieldLabel.Text = 'Wavelength';

            % Create WavelengthEditField
            app.WavelengthEditField = uieditfield(app.UIFigure, 'numeric');
            app.WavelengthEditField.Limits = [0 Inf];
            app.WavelengthEditField.ValueChangedFcn = createCallbackFcn(app, @NumberofElementsSliderValueChanged, true);
            app.WavelengthEditField.Position = [579 234 100 22];
            app.WavelengthEditField.Value = 2400000000;

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.UIFigure);

            % Create Menu
            app.Menu = uimenu(app.ContextMenu);
            app.Menu.Text = 'Menu';

            % Create Menu2
            app.Menu2 = uimenu(app.ContextMenu);
            app.Menu2.Text = 'Menu2';
            
            % Assign app.ContextMenu
            app.ReflectedRadiationPanel.ContextMenu = app.ContextMenu;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = vanatta_interactive

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end