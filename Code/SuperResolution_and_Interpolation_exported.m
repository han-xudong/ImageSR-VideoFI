classdef SuperResolution_and_Interpolation_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        SuperresolutionandInterpolationLabel  matlab.ui.control.Label
        TabGroup                    matlab.ui.container.TabGroup
        ImageSuperresolutionTab     matlab.ui.container.Tab
        Image_1                     matlab.ui.control.Image
        StartButton_1               matlab.ui.control.Button
        ModelDropDown_3Label        matlab.ui.control.Label
        ModelDropDown_1             matlab.ui.control.DropDown
        PresetDropDown_2Label       matlab.ui.control.Label
        PresetDropDown_1            matlab.ui.control.DropDown
        OpenImageButton             matlab.ui.control.Button
        ResetButton_1               matlab.ui.control.Button
        InformationTextAreaLabel    matlab.ui.control.Label
        InformationTextArea_1       matlab.ui.control.TextArea
        VideoSuperresolutionTab     matlab.ui.container.Tab
        Image_2                     matlab.ui.control.Image
        ModelDropDown_2Label        matlab.ui.control.Label
        ModelDropDown_2             matlab.ui.control.DropDown
        StartButton_2               matlab.ui.control.Button
        PresetDropDownLabel         matlab.ui.control.Label
        PresetDropDown_2            matlab.ui.control.DropDown
        OpenVideoButton_1           matlab.ui.control.Button
        ResetButton_2               matlab.ui.control.Button
        InformationTextArea_2Label  matlab.ui.control.Label
        InformationTextArea_2       matlab.ui.control.TextArea
        VideoInterpolationTab       matlab.ui.container.Tab
        Image_3                     matlab.ui.control.Image
        OpenVideoButton_2           matlab.ui.control.Button
        ResetButton_3               matlab.ui.control.Button
        StartButton_3               matlab.ui.control.Button
        ModelDropDown_4Label        matlab.ui.control.Label
        ModelDropDown_3             matlab.ui.control.DropDown
        FrameRateDropDownLabel      matlab.ui.control.Label
        FrameRateDropDown           matlab.ui.control.DropDown
        InformationTextArea_3Label  matlab.ui.control.Label
        InformationTextArea_3       matlab.ui.control.TextArea
    end

    
    properties (Access = private)
        filePath % Path of file
        frameNumber % Number of video frame
        frameRate % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: OpenImageButton
        function OpenImageButtonPushed(app, event)
            [filename, pathname] = uigetfile({'*.jpg; *.png'}, 'Select an image');
            if filename ~= 0
                app.filePath = fullfile(pathname, filename);
                app.InformationTextArea_1.Value = app.filePath;
                app.Image_1.ImageSource = app.filePath;
            end
        end

        % Button pushed function: OpenVideoButton_1
        function OpenVideoButton_1Pushed(app, event)
            [filename, pathname] = uigetfile({'*.avi; *.mp4; *.mpg; *.mov;'}, 'Select an image');
            if filename ~= 0
                app.filePath = fullfile(pathname, filename);
                app.InformationTextArea_2.Value = {app.filePath; 'Loading'};
                v = VideoReader(app.filePath);
                app.frameRate = v.FrameRate;
                count = 0;
                while hasFrame(v)
                    count = count + 1;
                    frame = readFrame(v);
                    imwrite(frame, num2str(count, 'Temp\\frame%d.png'), 'png');
                end
                app.Image_2.ImageSource = 'Temp\frame1.png';
                app.frameNumber = count;
                app.InformationTextArea_2.Value = {app.filePath; 'Loading completed'};
            end
        end

        % Button pushed function: OpenVideoButton_2
        function OpenVideoButton_2Pushed(app, event)
            [filename, pathname] = uigetfile({'*.avi; *.mp4; *.mpg; *.mov;'}, 'Select an image');
            if filename ~= 0
                app.filePath = fullfile(pathname, filename);
                app.InformationTextArea_3.Value = {app.filePath; 'Loading'};
                v = VideoReader(app.filePath);
                app.frameRate = v.FrameRate;
                count = 0;
                while hasFrame(v)
                    count = count + 1;
                    frame = readFrame(v);
                    imwrite(frame, num2str(count, 'Temp\\frame%d.png'), 'png');
                end
                app.Image_3.ImageSource = 'Temp\frame1.png';
                app.frameNumber = count;
                app.InformationTextArea_3.Value = {app.filePath; 'Loading completed'};
            end
        end

        % Button pushed function: ResetButton_1
        function ResetButton_1Pushed(app, event)
            app.Image_1.ImageSource = '';
            app.InformationTextArea_1.Value = {''};
            app.ModelDropDown_1.Value = 'SRCNN';
            app.PresetDropDown_1.Value = '200%';
        end

        % Button pushed function: ResetButton_2
        function ResetButton_2Pushed(app, event)
            app.Image_2.ImageSource = '';
            app.InformationTextArea_2.Value = {''};
            app.ModelDropDown_2.Value = 'SRCNN';
            app.PresetDropDown_2.Value = '200%';
            delete('Temp\*.png');
        end

        % Button pushed function: ResetButton_3
        function ResetButton_3Pushed(app, event)
            app.Image_3.ImageSource = '';
            app.InformationTextArea_3.Value = {''};
            app.ModelDropDown_3.Value = 'PBVI';
            app.FrameRateDropDown.Value = '2x';
            delete('Temp\*.png');
        end

        % Button pushed function: StartButton_1
        function StartButton_1Pushed(app, event)
            model = app.ModelDropDown_1.Value;
            preset = app.PresetDropDown_1.Value;
            [filename, pathname] = uiputfile({'*.jpg'; '*.png'}, 'Select a file to write');
            if filename ~= 0
                targetPath = fullfile(pathname, filename);
                psnr_im = ImageSR(app.filePath, targetPath, model, preset);
                app.InformationTextArea_1.Value = {'Success!'; num2str(psnr_im, 'PSNR = %.4f')};
                app.Image_1.ImageSource = targetPath;
            end
        end

        % Button pushed function: StartButton_2
        function StartButton_2Pushed(app, event)
            model = app.ModelDropDown_2.Value;
            preset = app.PresetDropDown_2.Value;
            [filename, pathname] = uiputfile({'*.avi'; '*.mp4'}, 'Select a file to write');
            if filename ~= 0
                app.InformationTextArea_2.Value = 'Processing...';
                if strcmpi(filename((length(filename) - 2) : length(filename)), 'mp4')
                    profile = 'MPEG-4';
                else
                    profile = 'Motion JPEG AVI';
                end
                targetPath = fullfile(pathname, filename);
                psnrData = zeros(app.frameNumber, 1);
                vw = VideoWriter(targetPath, profile);
                vw.FrameRate = app.frameRate;
                open(vw);
                for i = 1 : app.frameNumber
                    psnrData(i, 1) = ImageSR(num2str(i, 'Temp\\frame%d.png'), num2str(i, 'Temp\\frame%d_x.png'), model, preset);
                    app.InformationTextArea_2.Value = 'Processing...';
                    app.Image_2.ImageSource = num2str(i, 'Temp\\frame%d_x.png');
                    frame = im2frame(imread(num2str(i, 'Temp\\frame%d_x.png')));
                    writeVideo(vw,frame);
                end
                close(vw);
                delete('Temp\*.png');
                psnr_vd = sum(psnrData) / app.frameNumber;
                app.InformationTextArea_2.Value = {'Success!'; num2str(psnr_vd, 'PSNR = %.4f')};
            end
        end

        % Button pushed function: StartButton_3
        function StartButton_3Pushed(app, event)
            model = app.ModelDropDown_2.Value;
            up_rate = app.FrameRateDropDown.Value;
            [filename, pathname] = uiputfile({'*.avi'; '*.mp4'}, 'Select a file to write');
            if filename ~= 0
                app.InformationTextArea_3.Value = 'Processing...';
                if strcmpi(filename((length(filename) - 2) : length(filename)), 'mp4')
                    profile = 'MPEG-4';
                else
                    profile = 'Motion JPEG AVI';
                end
                targetPath = fullfile(pathname, filename);
                for i = 1 : (app.frameNumber - 1)
                    VideoIP(num2str(i, 'Temp\\frame%d.png'), num2str((i + 1), 'Temp\\frame%d.png'), model, up_rate)
                    app.Image_3.ImageSource = num2str((i + 1), 'Temp\\frame%d.png');
                end
                imwrite(imread(num2str(app.frameNumber, 'Temp\\frame%d.png')), num2str((str2num(erase(up_rate, 'x')) * (app.frameNumber - 1) + 1), 'Temp\\newframe%d.png'));
                vw = VideoWriter(targetPath, profile);
                vw.FrameRate = app.frameRate * str2num(erase(up_rate, 'x'));
                open(vw);
                for i = 1 : (str2num(erase(up_rate, 'x')) * (app.frameNumber - 1) + 1)
                    frame = im2frame(imread(num2str(i, 'Temp\\newframe%d.png')));
                    writeVideo(vw, frame);
                end
                close(vw);
                delete('Temp\*.png');
                app.InformationTextArea_3.Value = 'Success!';
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create SuperresolutionandInterpolationLabel
            app.SuperresolutionandInterpolationLabel = uilabel(app.UIFigure);
            app.SuperresolutionandInterpolationLabel.FontSize = 20;
            app.SuperresolutionandInterpolationLabel.Position = [166 449 310 24];
            app.SuperresolutionandInterpolationLabel.Text = 'Super-resolution and Interpolation';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 640 441];

            % Create ImageSuperresolutionTab
            app.ImageSuperresolutionTab = uitab(app.TabGroup);
            app.ImageSuperresolutionTab.Title = 'Image Super-resolution';

            % Create Image_1
            app.Image_1 = uiimage(app.ImageSuperresolutionTab);
            app.Image_1.Position = [80 124 480 270];

            % Create StartButton_1
            app.StartButton_1 = uibutton(app.ImageSuperresolutionTab, 'push');
            app.StartButton_1.ButtonPushedFcn = createCallbackFcn(app, @StartButton_1Pushed, true);
            app.StartButton_1.Position = [407 15 153 22];
            app.StartButton_1.Text = 'Start';

            % Create ModelDropDown_3Label
            app.ModelDropDown_3Label = uilabel(app.ImageSuperresolutionTab);
            app.ModelDropDown_3Label.Position = [407 77 38 22];
            app.ModelDropDown_3Label.Text = 'Model';

            % Create ModelDropDown_1
            app.ModelDropDown_1 = uidropdown(app.ImageSuperresolutionTab);
            app.ModelDropDown_1.Items = {'SRCNN', 'Bicubic'};
            app.ModelDropDown_1.Position = [460 77 100 22];
            app.ModelDropDown_1.Value = 'SRCNN';

            % Create PresetDropDown_2Label
            app.PresetDropDown_2Label = uilabel(app.ImageSuperresolutionTab);
            app.PresetDropDown_2Label.Position = [407 45 40 22];
            app.PresetDropDown_2Label.Text = 'Preset';

            % Create PresetDropDown_1
            app.PresetDropDown_1 = uidropdown(app.ImageSuperresolutionTab);
            app.PresetDropDown_1.Items = {'200%', '300%', '400%'};
            app.PresetDropDown_1.Position = [460 45 100 22];
            app.PresetDropDown_1.Value = '200%';

            % Create OpenImageButton
            app.OpenImageButton = uibutton(app.ImageSuperresolutionTab, 'push');
            app.OpenImageButton.ButtonPushedFcn = createCallbackFcn(app, @OpenImageButtonPushed, true);
            app.OpenImageButton.Position = [80 15 153 22];
            app.OpenImageButton.Text = 'Open Image';

            % Create ResetButton_1
            app.ResetButton_1 = uibutton(app.ImageSuperresolutionTab, 'push');
            app.ResetButton_1.ButtonPushedFcn = createCallbackFcn(app, @ResetButton_1Pushed, true);
            app.ResetButton_1.Position = [243 15 153 22];
            app.ResetButton_1.Text = 'Reset';

            % Create InformationTextAreaLabel
            app.InformationTextAreaLabel = uilabel(app.ImageSuperresolutionTab);
            app.InformationTextAreaLabel.Position = [80 75 66 22];
            app.InformationTextAreaLabel.Text = 'Information';

            % Create InformationTextArea_1
            app.InformationTextArea_1 = uitextarea(app.ImageSuperresolutionTab);
            app.InformationTextArea_1.Editable = 'off';
            app.InformationTextArea_1.Position = [145 45 251 54];

            % Create VideoSuperresolutionTab
            app.VideoSuperresolutionTab = uitab(app.TabGroup);
            app.VideoSuperresolutionTab.Title = 'Video Super-resolution';

            % Create Image_2
            app.Image_2 = uiimage(app.VideoSuperresolutionTab);
            app.Image_2.Position = [80 124 480 270];

            % Create ModelDropDown_2Label
            app.ModelDropDown_2Label = uilabel(app.VideoSuperresolutionTab);
            app.ModelDropDown_2Label.Position = [407 77 38 22];
            app.ModelDropDown_2Label.Text = 'Model';

            % Create ModelDropDown_2
            app.ModelDropDown_2 = uidropdown(app.VideoSuperresolutionTab);
            app.ModelDropDown_2.Items = {'SRCNN', 'Bicubic'};
            app.ModelDropDown_2.Position = [460 77 100 22];
            app.ModelDropDown_2.Value = 'SRCNN';

            % Create StartButton_2
            app.StartButton_2 = uibutton(app.VideoSuperresolutionTab, 'push');
            app.StartButton_2.ButtonPushedFcn = createCallbackFcn(app, @StartButton_2Pushed, true);
            app.StartButton_2.Position = [407 15 153 22];
            app.StartButton_2.Text = 'Start';

            % Create PresetDropDownLabel
            app.PresetDropDownLabel = uilabel(app.VideoSuperresolutionTab);
            app.PresetDropDownLabel.Position = [407 45 40 22];
            app.PresetDropDownLabel.Text = 'Preset';

            % Create PresetDropDown_2
            app.PresetDropDown_2 = uidropdown(app.VideoSuperresolutionTab);
            app.PresetDropDown_2.Items = {'200%', '300%', '400%'};
            app.PresetDropDown_2.Position = [460 45 100 22];
            app.PresetDropDown_2.Value = '200%';

            % Create OpenVideoButton_1
            app.OpenVideoButton_1 = uibutton(app.VideoSuperresolutionTab, 'push');
            app.OpenVideoButton_1.ButtonPushedFcn = createCallbackFcn(app, @OpenVideoButton_1Pushed, true);
            app.OpenVideoButton_1.Position = [80 15 153 22];
            app.OpenVideoButton_1.Text = 'Open Video';

            % Create ResetButton_2
            app.ResetButton_2 = uibutton(app.VideoSuperresolutionTab, 'push');
            app.ResetButton_2.ButtonPushedFcn = createCallbackFcn(app, @ResetButton_2Pushed, true);
            app.ResetButton_2.Position = [243 15 153 22];
            app.ResetButton_2.Text = 'Reset';

            % Create InformationTextArea_2Label
            app.InformationTextArea_2Label = uilabel(app.VideoSuperresolutionTab);
            app.InformationTextArea_2Label.Position = [80 75 66 22];
            app.InformationTextArea_2Label.Text = 'Information';

            % Create InformationTextArea_2
            app.InformationTextArea_2 = uitextarea(app.VideoSuperresolutionTab);
            app.InformationTextArea_2.Editable = 'off';
            app.InformationTextArea_2.Position = [145 45 251 54];

            % Create VideoInterpolationTab
            app.VideoInterpolationTab = uitab(app.TabGroup);
            app.VideoInterpolationTab.Title = 'Video Interpolation';

            % Create Image_3
            app.Image_3 = uiimage(app.VideoInterpolationTab);
            app.Image_3.Position = [80 124 480 270];

            % Create OpenVideoButton_2
            app.OpenVideoButton_2 = uibutton(app.VideoInterpolationTab, 'push');
            app.OpenVideoButton_2.ButtonPushedFcn = createCallbackFcn(app, @OpenVideoButton_2Pushed, true);
            app.OpenVideoButton_2.Position = [80 15 153 22];
            app.OpenVideoButton_2.Text = 'Open Video';

            % Create ResetButton_3
            app.ResetButton_3 = uibutton(app.VideoInterpolationTab, 'push');
            app.ResetButton_3.ButtonPushedFcn = createCallbackFcn(app, @ResetButton_3Pushed, true);
            app.ResetButton_3.Position = [243 15 153 22];
            app.ResetButton_3.Text = 'Reset';

            % Create StartButton_3
            app.StartButton_3 = uibutton(app.VideoInterpolationTab, 'push');
            app.StartButton_3.ButtonPushedFcn = createCallbackFcn(app, @StartButton_3Pushed, true);
            app.StartButton_3.Position = [407 15 153 22];
            app.StartButton_3.Text = 'Start';

            % Create ModelDropDown_4Label
            app.ModelDropDown_4Label = uilabel(app.VideoInterpolationTab);
            app.ModelDropDown_4Label.Position = [407 77 38 22];
            app.ModelDropDown_4Label.Text = 'Model';

            % Create ModelDropDown_3
            app.ModelDropDown_3 = uidropdown(app.VideoInterpolationTab);
            app.ModelDropDown_3.Items = {'PBVI'};
            app.ModelDropDown_3.Position = [475 77 85 22];
            app.ModelDropDown_3.Value = 'PBVI';

            % Create FrameRateDropDownLabel
            app.FrameRateDropDownLabel = uilabel(app.VideoInterpolationTab);
            app.FrameRateDropDownLabel.Position = [407 45 69 22];
            app.FrameRateDropDownLabel.Text = 'Frame Rate';

            % Create FrameRateDropDown
            app.FrameRateDropDown = uidropdown(app.VideoInterpolationTab);
            app.FrameRateDropDown.Items = {'2x', '3x', '4x'};
            app.FrameRateDropDown.Position = [475 45 85 22];
            app.FrameRateDropDown.Value = '2x';

            % Create InformationTextArea_3Label
            app.InformationTextArea_3Label = uilabel(app.VideoInterpolationTab);
            app.InformationTextArea_3Label.Position = [80 75 66 22];
            app.InformationTextArea_3Label.Text = 'Information';

            % Create InformationTextArea_3
            app.InformationTextArea_3 = uitextarea(app.VideoInterpolationTab);
            app.InformationTextArea_3.Editable = 'off';
            app.InformationTextArea_3.Position = [145 45 251 54];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SuperResolution_and_Interpolation_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

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