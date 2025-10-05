# Survey-to-Operational Metrics Regression Playbook

Quick reference guide for analyzing relationships between customer survey responses and operational metrics.

## Contents

1. [Data Preparation](#1-data-preparation)
2. [Simple Linear Regression (Baseline)](#2-simple-linear-regression-baseline)
3. [Multiple Linear Regression](#3-multiple-linear-regression)
4. [Non-Linearity](#4-non-linearity)
5. [Segmentation](#5-segmentation)
6. [Train/Test Split & Validation](#6-traintest-split--validation)
7. [Advanced Considerations](#7-advanced-considerations)
8. [Model Evaluation](#8-model-evaluation)
9. [Time-Series Considerations](#9-time-series-considerations)
10. [Common Pitfalls Checklist](#common-pitfalls-checklist)
11. [Key Talking Points](#key-talking-points)

## 1. Data Preparation

**Define Time Windows**
- Survey date = anchor point
- Operational data = lookback window (30/60/90 days before survey)
- Join survey responses to operational metrics by customer ID + time window

**Data Quality Checks**
- Scale/range validation (scores within expected bounds)
- Duplicate responses (same customer, multiple surveys)
- Missing data patterns (random vs. systematic)
- Outlier detection (extreme values in ops metrics)
- Response rate analysis (sample bias check)

**Exploratory Analysis**
- Distribution plots (histograms, box plots)
- Correlation matrix heatmap
- Scatterplots for key relationships

## 2. Simple Linear Regression (Baseline)

**Single Predictor Model**
```python
model = sm.OLS(y, sm.add_constant(X)).fit()
```

**Check Metrics & Assumptions**
- R² (variance explained), p-value (significance)
- Coefficient (direction/magnitude)
- Residual plots (random scatter = good, patterns = problem)
- Homoscedasticity (constant variance) - plot residuals vs. fitted
- Normality of residuals - Q-Q plot or histogram
- Independence (no autocorrelation in time-series data)

## 3. Multiple Linear Regression

**Add Multiple Predictors**
- Include all relevant operational metrics
- **Standardize features first** (required for regularization, helps interpretation)

```python
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)
```

**Multicollinearity Check**
- Calculate VIF (Variance Inflation Factor)
- VIF > 5-10 indicates concern (variables too correlated)
- Solution: Remove variables or use regularization

```python
from statsmodels.stats.outliers_influence import variance_inflation_factor
vif = pd.DataFrame({'feature': X.columns,
                    'VIF': [variance_inflation_factor(X.values, i) for i in range(len(X.columns))]})
```

**Regularization (if VIF high)**
- Ridge: Shrinks coefficients, keeps all features
- Lasso: Can zero out features, does selection
- Use cross-validation to choose alpha parameter

## 4. Non-Linearity

**Check for Curved Relationships**
- Scatterplots
- Polynomial features (squared terms, interactions)
- GAM (Generalized Additive Models) for smooth curves

**Add if Needed**
```python
# Polynomial
poly = PolynomialFeatures(degree=2)
X_poly = poly.fit_transform(X)

# GAM
gam = LinearGAM(s(0) + s(1) + s(2))
```

## 5. Segmentation

**Categorical Variables**
- One-hot encode (customer tier, product type, region)
- Use `drop_first=True` to avoid dummy variable trap

**Interaction Effects**
- Do relationships vary by segment?
- Add interaction terms: `feature_A * feature_B`
- Or fit separate models per segment

## 6. Train/Test Split & Validation

**Avoid Overfitting**
```python
from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
```

**Cross-Validation**
- K-fold CV (k=5 or 10) for robust performance estimates
- Avoid data leakage: scale/transform only on training folds

```python
from sklearn.model_selection import cross_val_score
scores = cross_val_score(model, X, y, cv=5, scoring='r2')
```

## 7. Advanced Considerations

**Ordinal Regression**
- Use when Likert scale has few categories (3-point scales)
- For 5+ point scales, treating as continuous is typically fine
- Ordered logit/probit models preserve ordinality

**Missing Data**
- Drop if <5% missing
- Impute with median/mean for numerical, mode for categorical
- Check if missingness is informative (MCAR vs. MAR vs. MNAR)

**Causal vs. Correlation**
- Be explicit about what you can/can't claim
- Use lagged variables or natural experiments if possible
- Operational data *before* survey strengthens causal claims

## 8. Model Evaluation

**Compare Models**
- R² (higher = better)
- RMSE (lower = better)
- Cross-validation scores

**Feature Importance**
- Standardized coefficients (apples-to-apples comparison)
- Visualize with bar charts

**Business Translation**
- Convert coefficients to real impacts
- "Reducing wait time 1 min → +X satisfaction points"
- Focus on effect sizes, not just p-values

## 9. Time-Series Considerations

**For Monthly Aggregated Analysis**
- Check for autocorrelation (current month influenced by previous)
- Seasonal patterns (Q4 holiday effects, summer travel)
- Trend analysis (improving/declining over time)

```python
from statsmodels.graphics.tsaplots import plot_acf
plot_acf(residuals)  # Check for autocorrelation in residuals
```

**Time-Series Regression**
- Include lagged variables if autocorrelation present
- Add seasonal dummy variables (month indicators)
- Consider ARIMA models for strong temporal patterns

## Common Pitfalls Checklist

- [ ] Time alignment (ops data before survey date)
- [ ] Train/test split (avoid overfitting)
- [ ] Feature standardization (required for regularization)
- [ ] Multicollinearity (check VIF > 5-10)
- [ ] Outliers (handle extreme values)
- [ ] Non-linearity (plot relationships first)
- [ ] Sample bias (respondents vs. non-respondents)
- [ ] Segment differences (don't aggregate blindly)
- [ ] Autocorrelation (time-series data)
- [ ] Data leakage (scale on training only)
- [ ] Causality claims (correlation ≠ causation)
- [ ] Practical vs. statistical significance

## Key Talking Points

1. Start with exploration, not modeling - understand data first
2. Standardize features before regularization or comparing coefficients
3. Check VIF (>5-10) - operational metrics often correlate
4. Don't assume linearity - visualize relationships first
5. Use train/test split and cross-validation to avoid overfitting
6. Segment analysis reveals hidden patterns
7. Time-series data requires autocorrelation checks
8. Translate stats to business impact - focus on effect sizes