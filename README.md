# PortFolio replication

This is a project for the _Fintech_ course held at Politecnico di Milano in the
academic year 2022-2023.  
Our aim to replicate a blend of different finacial indexes with cheap and
readily available futures.

## Pipeline

### Data exploration and preprocessing (`Machine_Learning_Approach.ipynb`)
First of all we analized the indexes we were given and decide to create a new
index that was a blend of three, in particular we chose to blend the HFRXGL,
MXWO and LEGATRUU indexes.  
Then we also analized the evolution of the futures and found them to be
sufficiently heterogenous to be used in our portfolio. Furthermore, we found
that the future LLL1 was constant after a certain date, meaninin that it was
likely no traded after that date.  
We then plotted the distribution of the returns of the futures to check for
normality and computed their means and standard deviations.  
We used this data and some financial insight to divide the futures into three
groups (see the webapp for more details).  

### Machine Learning (`Machine_Learning_Approach.ipynb`)
We passed on to develop some models to replicate the performances of the chosen
blend of indexes.  
We developed, tested and tuned the hyperparameters for the following models:

- Lasso Regression
- Passive Aggressive Regressor
- Stochastic Gradient Descent Regressor
- Elastic Net Regressor

Each model was trained with a rolling window of 52 weeks and various metrics
were computed to evaluate the performance and chose the best model.  
In particular we looked at the following metrics:

- Mean Squared Error
- TEV (Tracking Error Volatility)
- IR (Information Ratio)
- MAT (Mean Annual Turnover)
- MATC (Mean Annual Turnover Cost)

We also plotted the tracking error and gross exposure for each model.
We found that the best model in terms of MSE was the Elastic Net Regressor,
which also performed rather well in terms of TEV and MATC, with the lowest
cost of all the models.
Finally we used Shapley values to explain the features importance in the Elastic
Net Regressor model. In particular we found that some of the variables were
rather uninmportant and could be removed from the model without affecting its
effieciency.

### Kalman Filter (`Kalman_Filter_VaR.mlx`)
We implemented a Kalman Filter to predict the future values of the target index
using the futures.
We used a rolling window of 52 weeks to train the model, but found it to perform
rather poorly. 
Thus we enhanced the model by adopting an EGARCH(1,1) model to predict the
volatilities of each future. Subsequently we used the predicted volatilities
to recompute the Kalman Filter.  
This greatly improved the performance of the model, which was now able to
track the target much more closely.
We then performed some performance analysis on the model and found that it had a
comparable MSE to the Elastic Net Regressor, but a higher MATC, which would make
it financially undesirable.

### VaR analysis (`Kalman_Filter_VaR.mlx`)
We proceeded to compare the Kalman Filter and our candidate model, the Elastic
Net Regressor, by computing the VaR of each model at a 95% and 99% confidence
level.
We used both a historical estimation method and an EWMA estimation method to
compute the VaR.
Using the historical method at 95% confidence level we found that the Kalman
Filter had a lower VaR than the Elastic Net Regressor, suggesting that it 
yielded a lower risk.
On the other hand using the EWMA method at 99% confidence suggested that the
Elastic Net Regressor had a lower VaR, suggesting that it yielded a lower risk.
This lead us to conclude that the two models have different sensitivities to
recent market dynamics and the weighing schemes used in the VaR estimation.

### Neural Networks (`neuralReplicaton.ipynb`)
We performed some statistical tests on the data and found it to be
non-stationary in nature. Therefore we decided to use the returns (which proved
to be stationary) to train a neural network. We also normalized them using
z-scoring.  
First, we built a simple RNN with 2 hidden layers and a rolling window of 52
weeks, we also used a Lambda layer to perform the dot product between the
estimated weights and the returns of the futures. We performed a manual grid
search to find the best hyperparameters for
the model.  
We also built a custom loss function to penalize differently different kinds
of errors, in order to minimize the number of negative returns.
We then built a LSTM model with 2 hidden layers and 20 neurons each, this 
made it possible for us to not specify a rolling window, as the LSTM layer
is able to learn the patterns in the data by itself.  
For both models we computed the same metrics as before, although we were unable
to extract the portfolio weights and calculate the MAT and MATC.

### [Webapp](https://fintech.streamlit.app)
Finally we used the Elastic Net Regressor, which we previously found to be the
best model, to build a webapp that would allow the user to tinker with different
selections of futures and see the performance of the resulting portfolio.  
This poses an interesting business opportunity if developed correctly, as it
allows any user to play with different futures and strategies without having to
acquire any data science knowledge.
