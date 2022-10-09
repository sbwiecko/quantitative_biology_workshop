# %%
# analysis of the fecal blood data using python

import numpy as np
import pandas as pd
from scipy.io import loadmat
import matplotlib.pyplot as plt

# %%
# load matlab data to dataframe
# see also https://stackoverflow.com/questions/38197449/matlab-data-file-to-pandas-dataframe

data_set = loadmat("./FecalBloodData_for_matlab_ROC.mat")
print(data_set.keys())

# load FecalBloodData_for_matlab_ROC.mat % contains test results and case status for 914 test cases
# % The columns in FecalBloodData.mat are
#     % 1. Fecal blood level (<<<ordered decereasingly>>>)
#     % 2. indicator of case bowel cancer (1 positive, 0 negative)
#     % 3. indicator of noncase bowel cancer

data = pd.DataFrame(
    data = data_set['ada'],
    columns=['fecal_blood_level', 'case', 'non_case'],
)

data.head()
data.info()


# %%
# histogram the 914 test values

plt.hist(
    data['fecal_blood_level'],
    bins=50,
)
plt.xlabel("test value")
plt.ylabel("number of tests")
plt.title("histogram of the 914 level values");


# %%
# Calculate number of true positive and false positive test results 
# thresholds corresponding to each observed test value.

cumul_true_pos_calls  = data['case'].cumsum() # sum positive indicators from patients with bowel cancer
cumul_false_pos_calls = data['non_case'].cumsum() # sum positive indicators from patients without bowel cancer


# Calculate the number of positive and negative cases
num_pos_cases = data['case'].sum()
num_neg_cases = data['non_case'].sum()

# Find the threshold such that the test has has 90% sensitivity
print("Find the threshold such that the test has has 90% sensitivity")
# Find the indices of array elements that are non-zero, grouped by element
index = np.where(cumul_true_pos_calls == round(num_pos_cases*0.90)) # ENTER your desired sensitivity here
index = np.min(index)
threshold_value = data.loc[index, 'fecal_blood_level']

# %%
# Generate a 2x2 results table for the chosen threshold value
print('Generate a 2x2 results table for the chosen threshold value')

tp = cumul_true_pos_calls[index]
fp = cumul_false_pos_calls[index]
fn = data.loc[index+1:, 'case'].sum()
tn = data.loc[index+1:, 'non_case'].sum()

contingency_table = np.array([
    [tp,fp],
    [fn,tn],
])

print(contingency_table)


# %%
# Calculate the specificity at your chosen threshold value
print('Calculate the specificity at your chosen threshold value')

sensitivity = tp / (tp + fn) # equals 731/(731+81)
specificity = tn / (tn + fp) # equals 80/(80+22)

print("sensitivity= ", round(sensitivity, 3))
print("specificity= ", round(specificity, 3))


# %%
# plot the ROC curve
print('plot the ROC curve')

num_pos_cases = cumul_true_pos_calls.iloc[-1]  # sum negative indicators from patients without bowel cancer
num_neg_cases = cumul_false_pos_calls.iloc[-1] # sum negative indicators from patients with bowel cancer
sensitivity_all = cumul_true_pos_calls/num_pos_cases # sensitivity at the threshold

one_minus_specificity = cumul_false_pos_calls/num_neg_cases # 1-specificity at the threshold

# ROC is a plot of sensitivity against (1-specificity)
plt.plot(
    one_minus_specificity,
    sensitivity_all,
    label='ROC for fecal blood test',
    lw=2,
    color='darkorange',
)

plt.xlabel('1 - specificity (1 - TNR, or FPR)')
plt.ylabel('sensitivity (recall, or TPR)')

 # plot the line of no discrimination
plt.axline(
    (1,1),
    slope=1,
    ls='--',
    color='lightgrey',
    label='line of no discrimination',
)


plt.legend(loc="lower right");


# %%
# same while using sklearn
from sklearn.metrics import roc_curve, roc_auc_score

predictions = data['fecal_blood_level'].values
label = data['case']

def plot_roc_curve(fpr, tpr, label=None):
    plt.plot(fpr, tpr, linewidth=2, label=label)
    plt.plot([0, 1], [0, 1], 'k--') # dashed diagonal
    plt.axis([0, 1, 0, 1])
    plt.xlabel('False Positive Rate (Fall-Out)', fontsize=16)
    plt.ylabel('True Positive Rate (Recall)', fontsize=16)
    plt.grid(True)


fpr,tpr,thresholds = roc_curve(label, predictions)
roc_auc = roc_auc_score(label, predictions)

plt.figure(figsize=(8, 6))
plot_roc_curve(fpr, tpr)
plt.plot([1-specificity, 1-specificity], [0., sensitivity], "r:")
plt.plot([0.0, 1-specificity], [sensitivity, sensitivity], "r:")
plt.plot([1-specificity], [sensitivity], "ro");
#save_fig("roc_curve_plot")
#plt.show()


# %%
# Calculate the AUC between the non-discriminant and discriminant lines

area_under_curve = sum(
    (
        one_minus_specificity[1:].values
        -
        one_minus_specificity[:-1].values
    )
    *
    (
        sensitivity[1:].values
        +
        sensitivity[:-1].values
    )
    /2
)

print('area under the ROC curve:', area_under_curve)
print('= 1.0 for a perfect test')
print('= 0.5 for a test with no predictive value')


# %%
# now modify the code and re-run to find the threshold 
# value that give equal sensitivity and specificity

# sensitivity = tp / (tp + fn)
# specificity = tn / (tn + fp)
#
# tp / (tp + fn) = tn / (tn + fp)
# tp * (tn + fp) = tn * (tp + fn)
# tp*tn + tp*fp = tn*tp + tn*fn
# tp*fp = tn*fn

index = np.where(cumul_true_pos_calls == round(num_pos_cases*0.825)) # ENTER your desired sensitivity here
index = np.min(index)
threshold_value = data.loc[index, 'fecal_blood_level']

tp = cumul_true_pos_calls[index]
fp = cumul_false_pos_calls[index]
fn = data.loc[index+1:, 'case'].sum()
tn = data.loc[index+1:, 'non_case'].sum()

contingency_table = np.array([
    [tp,fp],
    [fn,tn],
])

print(contingency_table)

sensitivity = tp / (tp + fn) # equals 731/(731+81)
specificity = tn / (tn + fp) # equals 80/(80+22)

print("sensitivity= ", round(sensitivity, 3))
print("specificity= ", round(specificity, 3))

# %%
