# Gaussian Process Regression and Classification

[**GPR in Python**](GRP.ipynb)
[or in matlab](GPR.m)

[**GPC in Python**](GRC.ipynb)
[or in matlab](GPC.m)

## Regression with Gaussian Processes
We have noisy sensor readings (indicated by errorbars).
first we will do a point prediction:

![alt tag](\images\GRP_single.png)

Next we will predict 100 points

![alt tag](\images\GPR-multi.png)

And we finally use MAP estimate of the hyperparameters:

![alt tag](GPR-optim.png)

## Classification with Gaussian Processes
We have generated training points and labels and then tried to compute labels for test points.
The figures shows all the points with the superimposed GPC results in circle:

![alt tag](\images\GRC.png)

If the '+' and 'o' colors coincide then that point is correctly classified.
