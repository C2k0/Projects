# Survey to Operational Metrics Analysis

This project demonstrates techniques for correlating customer survey responses with operational metrics using regression analysis and statistical methods.

## Project Structure

```
Survey_to_Ops_Correlations/
├── README.md                                    # This file
├── Survey-to-Operational Metrics Playbook.md   # Analysis methodology guide
├── demo.ipynb                                   # Synthetic data demo notebook
├── data/                                        # Real-world datasets
│   ├── satisfaction.csv                        # Airline passenger satisfaction dataset
│   ├── satisfaction_2015.csv                   # Alternative version with different metrics
│   ├── satisfaction.xlsx                       # Original Excel format
│   └── satisfaction_2015.xlsx                  # Original Excel format
└── .venv/                                       # Python virtual environment
```

## Datasets

### Synthetic Data (demo.ipynb)
- **Purpose:** Demonstrate analysis techniques with controlled, configurable data
- **Size:** ~96,000 records (4 years × 12 months × ~2,000 responses/month)
- **Survey Metrics:** 6 metrics with configurable scales (1-10, 1-15)
- **Operational Metrics:** 4 configurable metrics (calls, logins, feature usage, session duration)
- **Features:** Built-in correlations for realistic analysis patterns

### Real-World Data: Airline Passenger Satisfaction

**Source:** [Kaggle - Airline Passenger Satisfaction](https://www.kaggle.com/datasets/teejmahal20/airline-passenger-satisfaction)

**Dataset Details:**
- **Size:** 129,880 passenger records
- **Format:** CSV (converted from XLSX source)
- **Date:** October 2019

**Two Dataset Versions:**

1. **satisfaction.csv** - Contains "Online support" metric
2. **satisfaction_2015.csv** - Contains "Inflight service" metric instead

Both datasets are identical in size and structure except for this single column difference.

**Columns:**

*Demographics & Travel Info:*
- id (unique identifier)
- Gender
- Customer Type (Loyal/Disloyal)
- Age
- Type of Travel (Business/Personal)
- Class (Business/Eco/Eco Plus)
- Flight Distance

*Survey Satisfaction Ratings (0-5 scale):*
- Inflight wifi service
- Departure/Arrival time convenient
- Ease of Online booking
- Gate location
- Food and drink
- Online boarding
- Seat comfort
- Inflight entertainment
- On-board service
- Leg room service
- Baggage handling
- Checkin service
- Cleanliness
- Online support (satisfaction.csv only)
- Inflight service (satisfaction_2015.csv only)

*Operational Metrics:*
- Departure Delay in Minutes
- Arrival Delay in Minutes

*Target Variable:*
- satisfaction_v2 (satisfied/neutral or dissatisfied)

## Analysis Methodology

See [Survey-to-Operational Metrics Playbook.md](Survey-to-Operational%20Metrics%20Playbook.md) for detailed methodology including:

1. Data preparation and time window alignment
2. Simple and multiple linear regression
3. Handling multicollinearity (VIF)
4. Non-linearity detection
5. Segmentation analysis
6. Model evaluation

## Getting Started

### Setup

```bash
# Create virtual environment
python3 -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# Install dependencies
pip install pandas numpy matplotlib seaborn openpyxl jupyter scikit-learn statsmodels
```

### Run Demo

```bash
jupyter notebook demo.ipynb
```

### Use Real Data

```python
import pandas as pd

# Load airline satisfaction data
df = pd.read_csv('data/satisfaction.csv')

# Or use the 2015 version
df_2015 = pd.read_csv('data/satisfaction_2015.csv')
```

## Key Analysis Techniques

- **Individual-level correlation:** Analyze relationships at the customer response level
- **Aggregated monthly correlation:** Compare time-series patterns using monthly averages
- **Multicollinearity checks:** Use VIF to detect correlated predictors
- **Segmentation:** Analyze patterns by customer type, class, travel purpose
- **Feature importance:** Identify which operational metrics most impact satisfaction

## License & Attribution

**Real Data Source:**
- Original dataset from Kaggle user [teejmahal20](https://www.kaggle.com/datasets/teejmahal20/airline-passenger-satisfaction)
- Please cite the original source if using this data in publications or research

**Synthetic Data:**
- Generated using configurable parameters in demo.ipynb
- Free to use and modify
