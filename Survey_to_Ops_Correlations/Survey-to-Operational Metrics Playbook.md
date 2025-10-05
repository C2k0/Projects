# Survey-to-Operational Metrics Regression Playbook

## 1. Data Preparation

**Define Time Windows**
- Survey date = anchor point
- Operational data = lookback window (30/60/90 days before survey)
- Join survey responses to operational metrics by customer ID + time window

**Initial Checks**
- Distribution plots (histograms, box plots)
- Correlation matrix heatmap
- Scatterplots for key relationships
- Check for outliers and missing data

## 2. Simple Linear Regression (Baseline)

**Single Predictor Model**
```python
model = sm.OLS(y, sm.add_constant(X)).fit()
```

**Check**
- R² (variance explained)
- Coefficient (direction/magnitude)
- p-value (significance)
- Residual plots (random scatter = good, patterns = problem)

## 3. Multiple Linear Regression

**Add Multiple Predictors**
- Include all relevant operational metrics

**Multicollinearity Check**
- Calculate VIF (Variance Inflation Factor)
- VIF > 10 = problem (variables too correlated)
- Solution: Remove variables or use regularization

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

## 6. Advanced Considerations

**Ordinal Regression**
- For Likert scales (1-5), treat as ordered categories

**Missing Data**
- Drop if <5% missing
- Impute with median/mean
- Check if missingness is informative

**Causal vs. Correlation**
- Be explicit about what you can/can't claim
- Use lagged variables or natural experiments if possible

## 7. Model Evaluation

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

## Common Pitfalls Checklist

- [ ] Time alignment (ops data before survey date)
- [ ] Multicollinearity (check VIF)
- [ ] Outliers (handle extreme values)
- [ ] Non-linearity (plot relationships first)
- [ ] Sample bias (respondents vs. non-respondents)
- [ ] Segment differences (don't aggregate blindly)
- [ ] Causality claims (correlation ≠ causation)
- [ ] Practical vs. statistical significance

## Key Talking Points

1. Start with exploration, not modeling
2. Check VIF - operational metrics correlate
3. Don't assume linearity - visualize first
4. Segment analysis reveals hidden patterns
5. Translate stats to business impact