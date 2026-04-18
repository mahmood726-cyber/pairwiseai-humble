# PAIRWISE PRO v2.2 - USER GUIDE
**Complete Guide to Decision-Driven Meta-Analysis**

**Version:** 2.2 | **Updated:** December 2025 | **Validation:** A+ (98% match with R)

---

## TABLE OF CONTENTS

1. [Quick Start](#quick-start)
2. [Getting Started](#getting-started)
3. [Data Entry](#data-entry)
4. [Running Your Analysis](#running-your-analysis)
5. [Understanding Your Results](#understanding-your-results)
6. [Advanced Features](#advanced-features)
7. [Interpretation Guide](#interpretation-guide)
8. [Troubleshooting](#troubleshooting)
9. [Best Practices](#best-practices)
10. [Frequently Asked Questions](#frequently-asked-questions)

---

## QUICK START

### 5-Minute Tutorial

**1. Open the File**
- Double-click `pairwise-pro-v2_2 (2).html` in any modern browser
- No installation needed, no internet required (except for plots)

**2. Load Demo Data**
- Click **"Load Demo"** button
- Select "BCG Vaccine" or "SGLT2 Inhibitors"

**3. Run Analysis**
- Click **"Run Analysis"** button (blue button at top)
- Wait 2-3 seconds

**4. View Results**
- Scroll down to see:
  - Pooled effect estimate (e.g., OR = 0.37)
  - Forest plot
  - Heterogeneity statistics (I², tau²)
  - Publication bias assessment

**✅ Done! You've just performed a meta-analysis.**

---

## GETTING STARTED

### What is Pairwise Pro?

Pairwise Pro is a **browser-based meta-analysis tool** that transforms traditional meta-analysis from "Is it statistically significant?" to "Should we use this treatment?"

**Key Features:**
- ✅ **Validated:** 98% match with R metafor (gold standard)
- ✅ **No coding:** Point-and-click interface
- ✅ **Comprehensive:** Binary, continuous, survival, proportion data
- ✅ **Decision-focused:** Probabilities, thresholds, clinical meaning
- ✅ **Publication-ready:** High-quality forest plots and tables

### System Requirements

**Supported Browsers:**
- Chrome/Edge 90+ (recommended)
- Firefox 88+
- Safari 14+

**No Installation Required:**
- Works offline (except Plotly for plots)
- No software to install
- No account needed
- Privacy-friendly (all data stays on your computer)

---

## DATA ENTRY

### Step 1: Choose Your Data Type

Click the **Data Type** dropdown and select:

| Data Type | When to Use | Example |
|-----------|-------------|---------|
| **Binary** | Events vs. no events | Death, hospitalization, cure |
| **Continuous** | Measured outcomes | Blood pressure, weight, pain score |
| **Hazard Ratio (HR)** | Time-to-event from papers | Survival analysis, HR with CI |
| **Proportion** | Single-arm studies | Prevalence, response rate |
| **Generic** | Pre-calculated effects | When you have effect + SE |

### Step 2: Choose Your Effect Measure

**For Binary Data:**
- **Odds Ratio (OR):** Case-control studies, logistic regression
- **Risk Ratio (RR):** Cohort studies, clinical trials (preferred for interpretation)
- **Risk Difference (RD):** Absolute effect, NNT calculations

**For Continuous Data:**
- **Mean Difference (MD):** Same units across studies (e.g., all in mmHg)
- **Standardized MD (SMD):** Different scales (e.g., depression scales)

**For Survival:**
- **Hazard Ratio (HR):** From published survival curves

### Step 3: Enter Your Data

#### Binary Data Example

```
Study Name          | Events_T | N_T  | Events_C | N_C  |
--------------------|----------|------|----------|------|
DAPA-HF             | 237      | 2373 | 274      | 2371 |
EMPEROR-Reduced     | 361      | 1863 | 462      | 1867 |
DELIVER             | 512      | 3131 | 610      | 3132 |
EMPEROR-Preserved   | 259      | 2997 | 325      | 2991 |
```

**Where:**
- **Events_T:** Number of events in treatment group
- **N_T:** Total participants in treatment group
- **Events_C:** Number of events in control group
- **N_C:** Total participants in control group

#### Continuous Data Example

```
Study Name     | Mean_T | SD_T | N_T | Mean_C | SD_C | N_C |
---------------|--------|------|-----|--------|------|-----|
Smith 2020     | 125.3  | 15.2 | 150 | 132.7  | 14.8 | 145 |
Jones 2021     | 128.1  | 16.5 | 200 | 135.2  | 15.9 | 195 |
```

**Where:**
- **Mean_T/C:** Average value in treatment/control
- **SD_T/C:** Standard deviation in treatment/control
- **N_T/C:** Sample size in treatment/control

#### Hazard Ratio Example

```
Study Name        | HR   | Lower CI | Upper CI |
------------------|------|----------|----------|
CANVAS           | 0.67 | 0.52     | 0.87     |
DECLARE-TIMI 58  | 0.73 | 0.61     | 0.88     |
```

**Where:**
- **HR:** Hazard ratio from paper
- **Lower/Upper CI:** 95% confidence interval bounds

### Step 4: Data Validation

**Automatic Checks:**
- ❌ Red border = Invalid (e.g., events > N)
- ⚠️ Yellow highlight = Warning (e.g., zero events)
- ✅ Green alert = Data ready

**Common Errors:**
1. **Events exceed N:** Check your data entry
2. **Negative SD:** SD must be positive
3. **Missing values:** All cells must be filled

---

## RUNNING YOUR ANALYSIS

### Basic Analysis

**1. Click "Run Analysis"**
- Blue button at top of page
- Takes 2-5 seconds for typical datasets
- Progress indicator shows while running

**2. Choose Your Settings**

**Tau² Method:**
- **REML** (default) - Cochrane 2024 recommendation
- **DL** - Classic method (faster, slightly biased)
- **PM** - Paule-Mandel (robust to outliers)
- Try all 8 methods for sensitivity analysis

**HKSJ Adjustment:**
- ✅ **Enabled** (default) - Recommended by Cochrane
- Provides more conservative confidence intervals
- Especially important for small k (<10 studies)

**Direction:**
- **Lower is better:** Mortality, adverse events, disease
- **Higher is better:** Quality of life, cure rate

### Advanced Settings

**Continuity Correction (Binary Data Only):**
- **Constant (0.5):** Add 0.5 to all cells with zeros
- **Treatment-arm:** Proportional correction
- **Empirical:** Data-driven correction
- **None:** Only if no zero cells

**Bayesian Analysis:**
- Enable for full posterior distributions
- Choose prior: Vague (default), Weakly informative, Informative
- MCMC iterations: 5000 (default), increase for precision

---

## UNDERSTANDING YOUR RESULTS

### Main Results Panel

#### 1. Pooled Effect Estimate

**Example Output:**
```
Pooled Odds Ratio: 0.715 (95% CI: 0.658-0.777)
p-value: <0.001
```

**Interpretation:**
- **OR = 0.715:** Treatment reduces odds by 28.5%
- **95% CI excludes 1.0:** Statistically significant
- **p < 0.001:** Strong evidence against null

**Direction Guide:**
| Effect Measure | Benefit | Harm | Neutral |
|----------------|---------|------|---------|
| OR, RR, HR | <1.0 | >1.0 | =1.0 |
| RD, MD | <0 | >0 | =0 |

#### 2. Heterogeneity Statistics

**Example:**
```
tau² = 0.025
I² = 45.3% (95% CI: 0%-78%)
Q = 9.12, df = 5, p = 0.104
H² = 1.83
```

**What Each Means:**

**I² (Percentage of Variability):**
- **0-25%:** Low heterogeneity (studies are similar)
- **25-50%:** Moderate heterogeneity
- **50-75%:** Substantial heterogeneity
- **>75%:** Considerable heterogeneity

**Interpretation:**
```
I² = 45% → "Moderate heterogeneity present"
```
→ Fixed-effects model inappropriate
→ Random-effects model justified
→ Consider subgroup analysis

**tau² (Between-Study Variance):**
- On log scale for OR/RR/HR
- Larger tau² = more heterogeneity
- Used to calculate prediction intervals

**Q Statistic:**
- p > 0.10 → No significant heterogeneity
- p < 0.10 → Significant heterogeneity detected
- **Note:** Low power when k < 10 studies

#### 3. Prediction Interval

**Example:**
```
95% Prediction Interval: 0.52 - 0.98
```

**What This Means:**
> "If we conducted a new study in a new setting, we predict with 95% confidence that the true effect would fall between OR = 0.52 and 0.98"

**Comparison:**
- **Confidence Interval:** Where the *average* effect is
- **Prediction Interval:** Where *future studies* will be

**Why It Matters:**
- Wider PI = More uncertainty in new settings
- PI crossing 1.0 = Effect may not replicate everywhere
- Important for generalizability

#### 4. Decision-Driven Meta-Analysis (DDMA)

**Example:**
```
P(Benefit) = 99.8%
P(MCID) = 85.3%
P(Harm) = 0.1%

Decision: RECOMMEND
Confidence: HIGH
```

**Interpreting Probabilities:**

**P(Benefit):**
- Probability effect is in beneficial direction
- >95% → Very likely beneficial
- 80-95% → Likely beneficial
- 50-80% → Possibly beneficial
- <50% → Uncertain or harmful

**P(MCID) - Probability of Meaningful Benefit:**
- MCID = Minimum Clinically Important Difference
- Default MCID = 15% relative reduction (HR/OR/RR = 0.85)
- >80% → Likely clinically meaningful
- <50% → May not be clinically meaningful

**P(Harm):**
- Probability effect is harmful
- <5% → Very unlikely to harm
- 5-10% → Low risk of harm
- >10% → Meaningful risk of harm

**Decision Categories:**
- ✅ **RECOMMEND:** High P(benefit), High P(MCID), Low P(harm)
- ⚠️ **CONSIDER:** Moderate evidence, balance needed
- ⚙️ **MORE DATA:** Insufficient evidence
- ❌ **DO NOT RECOMMEND:** High P(harm) or low P(benefit)

---

### Forest Plot

**Reading the Forest Plot:**

```
Study               Effect [95% CI]    Weight
────────────────────────────────────────────────
Study 1     ■──┼──                     25.3%
Study 2        ■──┼──                  18.7%
Study 3     ■──┼──                     22.1%
Study 4        ■──┼──                  19.5%
Study 5     ■─┼─                       14.4%
────────────────────────────────────────────────
◆ Pooled       ◆─┼─                    100%
────────────────────────────────────────────────
        0.5    1.0    2.0
   Favours Rx  │  Favours Control
```

**Elements:**
- **Squares (■):** Individual study effects (size ∝ weight)
- **Horizontal lines:** 95% confidence intervals
- **Diamond (◆):** Pooled effect estimate
- **Vertical line at 1.0:** Line of no effect
- **Weights:** Contribution to pooled estimate

**Interpretation:**
- All squares on same side of 1.0 → Consistent direction
- Overlapping CIs → Studies agree
- Non-overlapping CIs → Heterogeneity present

---

### Publication Bias Assessment

#### Egger's Test

**Example:**
```
Intercept: -1.23 (SE: 0.54)
t = -2.28, p = 0.045
```

**Interpretation:**
- p < 0.05 → **Asymmetry detected**
- May indicate: Publication bias, small-study effects, or heterogeneity
- **Warning:** Low power when k < 10

**Important Caveats:**
> "Egger's test p=0.045 suggests funnel plot asymmetry. This MAY indicate publication bias, but could also reflect true small-study effects or heterogeneity. Examine funnel plot visually and use other methods (trim-and-fill, sensitivity analysis)."

#### Trim and Fill

**Example:**
```
Original k = 10 studies
Estimated missing studies = 3 (right side)
Adjusted pooled OR = 0.82 (was 0.71)
```

**Interpretation:**
- Imputes "missing" studies
- Adjusted effect closer to null → Publication bias may be present
- **Change >20%** → Substantial bias possible

**Use Caution:**
- Method assumes only publication bias (not heterogeneity)
- Can over-correct in presence of heterogeneity
- Use as sensitivity analysis only

#### Funnel Plot

**What to Look For:**
- **Symmetric:** Studies evenly distributed → No bias suggested
- **Asymmetric:** Gap on one side → Possible publication bias
- **Note:** Natural asymmetry possible with <10 studies

---

### Sensitivity Analyses

#### Leave-One-Out Analysis

**Purpose:** Identify influential studies

**Example:**
```
Full analysis: OR = 0.71 (0.66-0.78)

Removing Study 1: OR = 0.69 (0.63-0.75) ✓ Similar
Removing Study 2: OR = 0.73 (0.67-0.81) ✓ Similar
Removing Study 3: OR = 0.85 (0.76-0.96) ⚠️ Different!
```

**Interpretation:**
- Study 3 is influential (removing it changes conclusion)
- Examine Study 3: Is it an outlier? Different population? Error?
- If removing one study changes conclusion → Fragile evidence

#### All Tau² Methods Comparison

**Example:**
```
Method    tau²    I²     Pooled OR [95% CI]
────────────────────────────────────────────
DL        0.025   45%    0.71 [0.66-0.78]
REML      0.032   48%    0.72 [0.66-0.79]
PM        0.028   46%    0.71 [0.65-0.78]
ML        0.029   47%    0.71 [0.66-0.78]
```

**What to Check:**
- Similar results across methods → Robust
- Large differences → Uncertainty in heterogeneity estimation
- Report REML (Cochrane standard) + sensitivity

---

## ADVANCED FEATURES

### Subgroup Analysis

**Purpose:** Explore heterogeneity by study characteristics

**Steps:**
1. Add **Subgroup** column to your data
2. Enter category for each study (e.g., "High dose", "Low dose")
3. Run analysis - subgroup results appear automatically

**Example Output:**
```
Subgroup: High Dose
  k = 5, OR = 0.65 (0.58-0.74)
  I² = 12% (low heterogeneity)

Subgroup: Low Dose
  k = 4, OR = 0.82 (0.71-0.95)
  I² = 58% (substantial heterogeneity)

Test for subgroup differences:
  Q_between = 6.42, df = 1, p = 0.011
```

**Interpretation:**
- **p < 0.10 for Q_between** → Subgroups differ significantly
- High dose more effective than low dose
- Explains some heterogeneity

**Warning:**
⚠️ Subgroup analysis is **exploratory** and prone to false positives. Pre-specify subgroups in protocol.

### Meta-Regression

**Purpose:** Examine continuous moderators (e.g., dose, year, age)

**Available When:**
- ≥5 studies with covariate data
- Default: Uses sample size as covariate

**Example:**
```
Covariate: Publication Year
Slope: -0.05 per year (SE: 0.02)
p = 0.018

Interpretation: Effect increases 5% per year
R² = 34% (heterogeneity explained)
```

**Caution:**
- Observational (correlation ≠ causation)
- Risk of ecological fallacy
- Needs ≥10 studies per covariate

### Bayesian Meta-Analysis

**When to Use:**
- Want full posterior distributions
- Incorporate prior information
- Small number of studies
- Need credible intervals (not confidence intervals)

**Settings:**
1. Enable "Bayesian Analysis"
2. Choose prior:
   - **Vague:** Lets data dominate (default)
   - **Weakly informative:** Mild regularization
   - **Informative:** Use previous evidence
3. Set MCMC iterations: 5000 (default)
4. Run analysis

**Output:**
```
Posterior Mean: OR = 0.72
95% Credible Interval: 0.65-0.80
P(OR < 1.0) = 99.5%
P(OR < 0.85) = 88.3%
```

**Interpretation:**
- **Credible Interval:** "95% probability true effect is in this range"
- Different from frequentist CI
- Allows direct probability statements

### Multi-Outcome Analysis

**Purpose:** Analyze multiple outcomes from same trials

**Features:**
- Trajectory analysis (effect over time)
- Peak effect detection
- Attenuation assessment

**Use Case:**
- SGLT2 inhibitors across CV death, HF hospitalization, kidney outcomes
- Antidepressants across depression, anxiety, quality of life

---

## INTERPRETATION GUIDE

### Clinical Significance vs. Statistical Significance

**Example: Antihypertensive Drug**

```
Pooled MD = -2.5 mmHg (95% CI: -3.1 to -1.9)
p < 0.001
```

**Statistical Interpretation:**
- ✅ Statistically significant (p < 0.001)
- ✅ Confidence interval excludes zero

**Clinical Interpretation:**
- ❓ Is 2.5 mmHg clinically meaningful?
- Guideline threshold: ≥5 mmHg reduction for clinical benefit
- **Verdict:** Statistically significant but **not clinically meaningful**

**DDMA Helps:**
```
P(MD < -5 mmHg) = 8.3%
→ Only 8% chance of clinically meaningful benefit
→ Decision: DO NOT RECOMMEND based on this outcome alone
```

### Number Needed to Treat (NNT)

**Automatic Calculation for Binary Data**

**Example:**
```
Pooled RR = 0.75 (0.68-0.83)
Baseline risk = 10% (control group event rate)

Absolute Risk Reduction = 2.5%
NNT = 40 (95% CI: 30-60)
```

**Interpretation:**
> "You need to treat 40 patients to prevent 1 event"

**Clinical Decision:**
- NNT = 5 → Very effective (e.g., thrombolysis in MI)
- NNT = 20 → Good (e.g., statins for primary prevention)
- NNT = 50 → Modest (e.g., aspirin for primary prevention)
- NNT = 100+ → Marginal benefit

**Note:** NNT depends on baseline risk (varies by population)

### Certainty of Evidence (GRADE)

**Pairwise Pro Provides:**
- ✅ Risk of bias: Assess individually per study
- ✅ Inconsistency: I² and prediction intervals
- ✅ Imprecision: Confidence intervals, optimal information size
- ✅ Publication bias: Egger's, funnel plot, trim-and-fill
- ⚠️ Indirectness: You must assess (PICO matching)

**GRADE Domains:**
1. **Risk of Bias:** Are studies well-conducted?
2. **Inconsistency:** I² < 50% = OK, I² > 75% = downgrade
3. **Indirectness:** Do studies match your PICO?
4. **Imprecision:** CI excludes minimally important effect?
5. **Publication Bias:** Egger's p < 0.05 or funnel asymmetry?

**Overall Certainty:**
- **High:** Very confident in effect estimate
- **Moderate:** Moderately confident
- **Low:** Limited confidence
- **Very Low:** Very uncertain

---

## TROUBLESHOOTING

### Common Errors and Solutions

#### "Events cannot exceed N"
**Problem:** You entered events_t = 150, n_t = 100
**Solution:** Check your data - likely transcription error

#### "Minimum 2 studies required"
**Problem:** Only 1 valid study detected
**Solution:**
- Check all rows have complete data
- Ensure N > 0 for all studies

#### "REML did not converge"
**Warning:** τ² estimation failed
**Solution:**
- Check results - may have fallen back to DL
- Try PM estimator (more robust)
- If k < 5, consider fixed-effects

#### "High heterogeneity (I² = 92%)"
**Warning:** Studies are very different
**Solution:**
- ✅ Use random-effects model (automatic)
- ✅ Examine forest plot for outliers
- ✅ Consider subgroup analysis
- ⚠️ Question: Should these studies be pooled?

#### Funnel Plot Shows Asymmetry
**Finding:** Possible publication bias
**What to Do:**
1. ✅ Run Egger's test (quantitative)
2. ✅ Use trim-and-fill (sensitivity)
3. ✅ Check if k < 10 (may be artifact)
4. ⚠️ Consider: Is pooled estimate reliable?

#### Very Wide Confidence Intervals
**Problem:** Imprecise estimate
**Reasons:**
- Small number of studies
- Small sample sizes
- High heterogeneity
**Solution:**
- Report uncertainty honestly
- GRADE: Downgrade for imprecision
- Consider: Is more data needed?

#### Different Results from R/RevMan
**Difference < 1%:** Rounding or method differences (OK)
**Difference > 5%:**
- Check data entry (most common cause)
- Check settings (tau² method, HKSJ, correction)
- Verify same studies included

---

## BEST PRACTICES

### Pre-Analysis

**1. Protocol First**
- ✅ Pre-specify analysis plan
- ✅ Register protocol (PROSPERO)
- ✅ Define PICO, outcomes, subgroups

**2. Data Extraction**
- ✅ Duplicate extraction (2 reviewers)
- ✅ Resolve discrepancies by consensus
- ✅ Contact authors for missing data

**3. Risk of Bias Assessment**
- ✅ Use Cochrane RoB 2.0 or RoB 1.0
- ✅ Plot risk of bias summary

### Analysis

**4. Choose Appropriate Model**
- ✅ Random-effects (default for clinical data)
- ⚠️ Fixed-effects only if I² = 0% and k < 5

**5. Report Heterogeneity**
- ✅ Always report I² and tau²
- ✅ Include prediction interval
- ✅ Investigate if I² > 50%

**6. Assess Publication Bias**
- ✅ Funnel plot if k ≥ 10
- ✅ Egger's test (but interpret cautiously)
- ⚠️ Don't over-interpret with k < 10

**7. Sensitivity Analyses**
- ✅ Leave-one-out
- ✅ Alternative tau² methods
- ✅ Fixed vs. random effects
- ✅ Exclude high risk of bias studies

### Reporting

**8. Follow Guidelines**
- ✅ PRISMA 2020 for systematic reviews
- ✅ Report all items in PRISMA checklist
- ✅ Include PRISMA flow diagram

**9. Complete Reporting**
- ✅ All studies (don't cherry-pick)
- ✅ All planned outcomes
- ✅ All analyses (including non-significant)
- ✅ Heterogeneity statistics
- ✅ Publication bias assessment

**10. Transparent Limitations**
- ✅ Risk of bias in included studies
- ✅ Heterogeneity and inconsistency
- ✅ Publication bias concerns
- ✅ Certainty of evidence (GRADE)

---

## FREQUENTLY ASKED QUESTIONS

### General

**Q: Is Pairwise Pro as accurate as R?**
A: Yes. Validated at 98% match with R metafor package. See `EXECUTIVE_SUMMARY_2PAGE.md` for full validation.

**Q: Do I need internet connection?**
A: No for analysis. Yes for forest plots (requires Plotly CDN). Save plots before going offline.

**Q: Can I use this for publication?**
A: Yes. Validated for publication-quality analyses. Cite: "Meta-analysis performed using Pairwise Pro v2.2, validated against R metafor v4.8-0."

**Q: How do I save my work?**
A: Browser's Save Page As (Ctrl+S) saves HTML with your data embedded. Or export results as CSV.

### Statistical Methods

**Q: Fixed-effects or random-effects?**
A: **Random-effects** for clinical/epidemiological studies (assumes heterogeneity). Fixed-effects only for laboratory/identical-population studies.

**Q: Which tau² method should I use?**
A: **REML** (default) - Cochrane 2024 recommendation. Less biased than DL. Run all methods for sensitivity.

**Q: Should I use HKSJ adjustment?**
A: **Yes** (default). Provides better type I error control, especially for k < 10. Recommended by Cochrane.

**Q: What if REML doesn't converge?**
A: App automatically falls back to DL. Try **PM (Paule-Mandel)** - more robust for difficult datasets.

**Q: When do I need continuity correction?**
A: When any study has zero events in a cell. Default 0.5 is standard. Try **treatment-arm** for asymmetric corrections.

### Interpretation

**Q: My p-value is 0.051. Is it significant?**
A: Don't dichotomize at 0.05. Report exact p-value. Consider: CI location, clinical significance, DDMA probabilities.

**Q: High heterogeneity (I² = 85%). Should I pool?**
A: Maybe. High I² doesn't prohibit pooling but:
- ✅ Use random-effects
- ✅ Report prediction interval
- ✅ Explore with subgroups/meta-regression
- ⚠️ Consider: Are studies addressing the same question?

**Q: What's a "good" I²?**
A: No universal threshold. Context matters:
- Laboratory studies: Expect I² < 25%
- Clinical trials: I² = 30-60% common
- Observational: I² > 75% common

**Q: Egger's test p=0.03. Does this mean publication bias?**
A: Not necessarily. Could be:
1. Publication bias (yes)
2. True small-study effects (different populations)
3. Heterogeneity
4. Artifact (especially if k < 10)

→ Use visual inspection + trim-and-fill + clinical judgment

**Q: Confidence interval crosses 1.0. What does this mean?**
A: No statistically significant effect at α=0.05. But:
- Check interval width (precision)
- Consider clinical significance of bounds
- DDMA: What's P(benefit)?

### Data Issues

**Q: Studies report different effect measures. Can I combine?**
A: Sometimes:
- ✅ OR and RR: Can convert (need baseline risk)
- ✅ Different continuous scales: Use SMD
- ❌ OR and HR: Cannot convert directly
- ❌ Different outcomes: Don't pool

**Q: What if I only have median and IQR, not mean and SD?**
A: Several options:
1. Contact authors for mean/SD
2. Use Wan et al. (2014) conversion formulas
3. Exclude study (sensitivity: with/without)

**Q: One study is much larger than others. Is this a problem?**
A: Not necessarily, but:
- Large study will dominate pooled estimate
- Check: Is large study similar to small studies?
- Sensitivity: Leave-one-out
- Consider: Quality vs. quantity

**Q: Can I pool RCTs and observational studies?**
A: Technically yes, but:
- ⚠️ Expect high heterogeneity
- ⚠️ Different bias profiles
- ✅ Better: Separate meta-analyses, then compare
- ✅ Alternative: Subgroup by study design

### Advanced

**Q: When should I use Bayesian meta-analysis?**
A:
- Informative prior available (previous meta-analyses)
- Want direct probability statements
- Very small k (k < 5)
- Rare events (better handling of zeros)

**Q: What's the difference between confidence and prediction interval?**
A:
- **CI:** Where average effect is (summary level)
- **PI:** Where future study effects will be (application level)
- **PI always wider than CI**
- **PI more relevant for clinical decisions**

**Q: Should I always do subgroup analysis?**
A: Only if:
- ✅ Pre-specified in protocol
- ✅ Biologically plausible
- ✅ Sufficient studies per subgroup (≥3)
- ❌ Don't data-dredge (multiple post-hoc tests)

**Q: My meta-regression shows significant effect of year. Now what?**
A: Interpret cautiously:
- Could be: Improving treatment, changing populations, reporting bias
- Cannot prove causation (ecological fallacy)
- Consider: Restrict to recent studies?
- Report as exploratory finding

---

## CITATION & VALIDATION

### How to Cite

**In Methods:**
> "Meta-analysis was performed using Pairwise Pro v2.2, a browser-based tool validated against R metafor v4.8-0 (98% concordance). Pooled effect estimates were calculated using random-effects models with restricted maximum likelihood (REML) estimation of between-study variance. Confidence intervals were adjusted using the Hartung-Knapp-Sidik-Jonkman method."

**In Acknowledgments:**
> "Meta-analysis was facilitated by Pairwise Pro v2.2 (M25 Evidence Synthesis Lab)."

### Validation Status

**Version:** 2.2 (December 2025)
**Validation Grade:** A+ (98%)
**Reference Standard:** R metafor v4.8-0

**Tested:**
- ✅ 20 datasets (10 clinical + 10 edge cases)
- ✅ 10 core formulas (8 perfect, 2 valid alternatives)
- ✅ 8 tau² estimators (100% match)
- ✅ All edge cases (zero events, extreme heterogeneity, etc.)

**See Full Reports:**
- `EXECUTIVE_SUMMARY_2PAGE.md` - Quick reference
- `FULL_VALIDATION_REPORT.md` - Complete technical validation
- `STATISTICAL_VALIDATION_REPORT.txt` - For journal reviewers
- `CODE_REVIEW_REPORT.md` - Security and code quality

---

## GETTING HELP

### Built-in Help
- Hover over ⓘ icons for field-specific help
- Demo datasets show proper data format
- Validation messages guide data entry

### Documentation
- This guide: Comprehensive instructions
- Validation reports: Statistical accuracy proof
- Code review: Security and quality assurance

### Troubleshooting
See [Troubleshooting](#troubleshooting) section above

### External Resources

**Meta-Analysis Methods:**
- Cochrane Handbook (2024) - www.cochrane-handbook.org
- R metafor package documentation - www.metafor-project.org

**Reporting Guidelines:**
- PRISMA 2020 - www.prisma-statement.org
- GRADE - www.gradeworkinggroup.org

**Statistical Consultations:**
- For complex analyses, consult a biostatistician
- For study design, consult during protocol stage

---

## APPENDIX: KEYBOARD SHORTCUTS

| Shortcut | Action |
|----------|--------|
| Ctrl+Enter | Run analysis |
| Ctrl+L | Load demo dataset |
| Ctrl+S | Save page |
| Tab | Navigate between fields |
| Ctrl+Z | Undo data entry |

---

## APPENDIX: GLOSSARY

**Cochran's Q:** Test statistic for heterogeneity (chi-square distribution)

**Confidence Interval (CI):** Range likely to contain true average effect (95% = 19 times out of 20)

**Fixed-Effects Model:** Assumes single true effect (all studies estimate same thing)

**Forest Plot:** Graphical display of individual study effects and pooled estimate

**Funnel Plot:** Scatter plot to detect publication bias (effect vs. precision)

**Hedges' g:** Bias-corrected standardized mean difference

**Heterogeneity:** Variability between study effects (beyond chance)

**HKSJ Adjustment:** Conservative CI adjustment for random-effects (Hartung-Knapp-Sidik-Jonkman)

**I² Statistic:** Percentage of variability due to heterogeneity (0-100%)

**MCID:** Minimum Clinically Important Difference

**Meta-Regression:** Regression of effect size on study-level covariates

**NNT:** Number Needed to Treat (1 / ARR)

**Odds Ratio (OR):** Odds of event in treatment / odds in control

**Pooled Estimate:** Weighted average effect across studies

**Prediction Interval:** Range for future study effects (wider than CI)

**Random-Effects Model:** Assumes distribution of true effects across studies

**REML:** Restricted Maximum Likelihood (method for estimating tau²)

**Risk Ratio (RR):** Risk in treatment / risk in control

**Sensitivity Analysis:** Checking robustness of results to assumptions

**Subgroup Analysis:** Comparing effects across study characteristics

**Tau² (τ²):** Between-study variance in random-effects model

**Trim and Fill:** Method to adjust for publication bias by imputing missing studies

---

**END OF USER GUIDE**

**Version:** 2.2 | **Last Updated:** December 5, 2025

For technical validation details, see `EXECUTIVE_SUMMARY_2PAGE.md`

---

*Pairwise Pro: Transforming evidence into decisions*
