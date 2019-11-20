# -HRVmass
HRVmass is a Matlab program designed for computing HRV from EKG signals in batch processing mode
The input file can be either EKG or R time.
If the input is EKG, the file must be in EDF format
You may change R peak detection algorithm by changing the file name RpeakDetectionAlgoFile.m. Otherwise, the build in R peak detection method is based on wavelet

If the input is R time, the file must be in txt format of column or row of R time (time where R peaks are detected)
The default HRV indices are meanRR, STD, CV, Poincare, Periodogram

You may add more index by modifying the file processfile.m 

The output is a mat file contain all setting and hrv results as well as R time and RR interval 
The results can be used for further study (for example, HRV vs a diseases)




