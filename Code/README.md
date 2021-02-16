# Super-Resolution and Interpolation Program

This is an program that could do image super-resoltuion, video super-resolution and video frame interpolation.

There are three major algorithms used in the program, which are bicubic interpolation method, super-resolution convolutional neural network (SRCNN) and phase-based video frame interpolation (PBVI).

- **SuperResolution_and_Interpolation_exported**: is the main function, and just run it to do everything.
- **ImageSR**: consists of a function used for super-resolution, where exists two algorithms bicubic interpolation and SRCNN.
- **VideoIP**: consists of a function used for video frame interpolation.
- **Bicubic**: consists of several files that combines to be the bicubic interpolation method.
- **SRCNN**: consists of several files that combines to be the SRCNN.
- **PBVI**: consists of several files that combines to be the PBVI.
- **SRCNNmodel**: consists model data of SRCNN.
- **matlabPylTools**: consists a toolbox that used by PBVI.
- **Temp**: is used for containing some images when disposing videos.
