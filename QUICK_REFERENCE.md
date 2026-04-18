# PAIRWISE PRO v2.2 - QUICK REFERENCE CARD
**1-Page Cheat Sheet for Meta-Analysis**

---

## 🚀 QUICK START (3 STEPS)

1. **Open File** → Double-click `pairwise-pro-v2_2 (2).html`
2. **Load Demo** → Click "Load Demo" button → Select dataset
3. **Run Analysis** → Click "Run Analysis" (blue button)

✅ **Done!** Scroll down for results.

---

## 📊 DATA ENTRY GUIDE

### Binary Data (e.g., Death, Hospitalization)
```
Study     | Events_T | N_T  | Events_C | N_C
----------|----------|------|----------|-----
Study 1   | 50       | 500  | 75       | 500
Study 2   | 32       | 400  | 48       | 400
```

### Continuous Data (e.g., Blood Pressure)
```
Study     | Mean_T | SD_T | N_T | Mean_C | SD_C | N_C
----------|--------|------|-----|--------|------|----
Study 1   | 125.3  | 15.2 | 150 | 132.7  | 14.8 | 145
```

### Hazard Ratio (from papers)
```
Study     | HR   | Lower_CI | Upper_CI
----------|------|----------|----------
Study 1   | 0.67 | 0.52     | 0.87
```

---

## ⚙️ SETTINGS QUICK GUIDE

| Setting | Recommended | When to Change |
|---------|-------------|----------------|
| **Tau² Method** | REML | Use PM if REML doesn't converge |
| **HKSJ** | ✅ ON | Only off if k > 50 studies |
| **Continuity Correction** | Constant (0.5) | Use "treatment-arm" for rare events |
| **Model** | Random-effects | Fixed only if I² = 0% |

---

## 📈 INTERPRETING RESULTS

### Effect Estimates

| Measure | Benefit | Neutral | Harm |
|---------|---------|---------|------|
| OR, RR, HR | **< 1.0** | 1.0 | > 1.0 |
| RD, MD | **< 0** | 0 | > 0 |

**Example:** OR = 0.75 → 25% reduction in odds ✅

### Heterogeneity (I²)

| I² | Interpretation | Action |
|----|----------------|--------|
| **0-25%** | Low heterogeneity | Safe to pool |
| **25-50%** | Moderate | Use random-effects ✅ |
| **50-75%** | Substantial | Explore subgroups |
| **>75%** | Considerable | Question pooling |

### Statistical Significance

```
95% CI: 0.65 - 0.88  (excludes 1.0)
p-value: 0.002       (< 0.05)
→ STATISTICALLY SIGNIFICANT ✅
```

### Clinical Significance (DDMA)

```
P(Benefit) = 95%     → Likely beneficial
P(MCID) = 80%        → Likely meaningful
P(Harm) = 2%         → Very unlikely harmful
→ CLINICALLY MEANINGFUL ✅
```

---

## 🔍 PUBLICATION BIAS

### Egger's Test
- **p < 0.05** → Asymmetry detected ⚠️
- **p > 0.10** → No asymmetry detected ✅
- **Caution:** Low power if k < 10

### Funnel Plot
- **Symmetric** → No bias suggested ✅
- **Asymmetric** → Possible bias ⚠️
- **Need k ≥ 10** for reliable interpretation

### Trim & Fill
```
Missing studies: 3
Original OR: 0.70
Adjusted OR: 0.78
Change: +11%
→ Minor impact ✅
```

---

## 🎯 DECISION FRAMEWORK

### Strong Recommendation (✅✅✅)
- P(Benefit) > 95%
- P(MCID) > 80%
- P(Harm) < 5%
- I² < 50%
- No publication bias

### Moderate Recommendation (✅✅)
- P(Benefit) > 80%
- P(MCID) > 50%
- P(Harm) < 10%

### Uncertain (⚠️)
- P(Benefit) 50-80%
- Wide CI
- High I² > 75%

### Not Recommended (❌)
- P(Benefit) < 50%
- P(Harm) > 20%
- CI includes meaningful harm

---

## 🛠️ TROUBLESHOOTING

| Problem | Solution |
|---------|----------|
| **Red border** | Events > N (check data) |
| **Yellow highlight** | Zero events (continuity correction applied) |
| **"REML failed"** | Try PM estimator |
| **Very wide CI** | Normal for small k or high I² |
| **I² > 75%** | Consider subgroup analysis |

---

## 📋 REPORTING CHECKLIST

### Essential Elements
- ✅ Effect estimate + 95% CI
- ✅ p-value
- ✅ I² and tau²
- ✅ Prediction interval
- ✅ Forest plot
- ✅ Publication bias assessment
- ✅ Sensitivity analyses

### Methods Section Template
> "Meta-analysis used random-effects model (REML estimator for tau²). Confidence intervals adjusted using HKSJ method. Heterogeneity assessed via I² and tau². Publication bias evaluated using Egger's test and funnel plots. Analyses performed in Pairwise Pro v2.2, validated against R metafor (98% concordance)."

---

## 🔢 KEY FORMULAS (CHEAT SHEET)

### Effect Sizes
```
OR = (a×d) / (b×c)
RR = (a/(a+b)) / (c/(c+d))
RD = (a/(a+b)) - (c/(c+d))
SMD = (M₁-M₂) / SDpooled × J  [J = bias correction]
```

### Heterogeneity
```
I² = ((Q - df) / Q) × 100%
Where Q > df, otherwise I² = 0%
```

### NNT
```
NNT = 1 / ARR
ARR = |Control_Risk - Treatment_Risk|
```

---

## 💡 QUICK TIPS

### DO ✅
- Pre-specify analysis plan
- Use random-effects for clinical data
- Report all heterogeneity metrics
- Conduct sensitivity analyses
- Assess publication bias (if k ≥ 10)
- Report prediction intervals
- Consider clinical significance

### DON'T ❌
- Cherry-pick studies
- Ignore high heterogeneity
- Over-interpret p=0.051 vs p=0.049
- Pool incompatible studies
- Use fixed-effects if I² > 0%
- Ignore influential studies (leave-one-out)
- Forget PRISMA checklist

---

## 📊 SAMPLE SIZES NEEDED

| Precision Goal | k Needed | Total N |
|---------------|----------|---------|
| Detect OR=0.7 | ≥10 | ≥5,000 |
| Narrow CI (±0.1) | ≥20 | ≥10,000 |
| Subgroup analysis | ≥10 per group | ≥3,000 per group |
| Meta-regression | ≥10 (prefer 20+) | ≥5,000 |

---

## 🎓 INTERPRETATION SHORTCUTS

### Odds Ratio
```
OR = 0.50 → 50% reduction ✅✅
OR = 0.70 → 30% reduction ✅
OR = 0.85 → 15% reduction (MCID threshold) ⚠️
OR = 0.95 → 5% reduction (minimal) ≈
OR = 1.00 → No effect
OR = 1.30 → 30% increase ❌
```

### NNT
```
NNT = 5   → Excellent (e.g., aspirin in MI)
NNT = 20  → Good (e.g., statins)
NNT = 50  → Modest
NNT = 100 → Marginal benefit
NNT = 500 → Questionable
```

### I² Benchmarks
```
I² = 0%   → Perfect consistency (rare)
I² = 30%  → Typical for RCTs
I² = 60%  → Typical for observational
I² = 90%  → Very heterogeneous (investigate!)
```

---

## 🔗 USEFUL LINKS

**Guidelines:**
- PRISMA 2020: www.prisma-statement.org
- Cochrane Handbook: www.cochrane-handbook.org
- GRADE: www.gradeworkinggroup.org

**Calculators:**
- R metafor: www.metafor-project.org

**This Tool:**
- Full User Guide: See `USER_GUIDE.md`
- Validation: See `EXECUTIVE_SUMMARY_2PAGE.md`

---

## 📱 KEYBOARD SHORTCUTS

| Key | Action |
|-----|--------|
| **Ctrl+Enter** | Run analysis |
| **Ctrl+L** | Load demo |
| **Ctrl+S** | Save page |
| **Tab** | Next field |

---

## 🆘 HELP HIERARCHY

1. **Hover over ⓘ icons** → Field-specific help
2. **Load Demo** → See correct data format
3. **USER_GUIDE.md** → Comprehensive manual
4. **Validation reports** → Statistical proof
5. **Cochrane Handbook** → Methods reference

---

## ✅ PRE-ANALYSIS CHECKLIST

Before running analysis:
- [ ] Protocol registered (PROSPERO)
- [ ] Search completed and documented
- [ ] Studies screened (PRISMA flow diagram)
- [ ] Data extracted by ≥2 reviewers
- [ ] Discrepancies resolved
- [ ] Risk of bias assessed
- [ ] Analysis plan finalized
- [ ] PICO clearly defined

---

## 📝 CITATION

**Methods Section:**
> "Meta-analysis performed using Pairwise Pro v2.2, validated against R metafor v4.8-0 (98% concordance)."

**Software Citation:**
> Pairwise Pro v2.2 (M25 Evidence Synthesis Lab, 2025). Browser-based meta-analysis tool. Validated December 2025.

---

## 🎯 ONE-MINUTE CHECKLIST

**Before Submitting Results:**
- ✅ Forest plot looks correct
- ✅ I² reported
- ✅ CI excludes null (if significant)
- ✅ Publication bias assessed (if k ≥ 10)
- ✅ Sensitivity analysis done
- ✅ Clinical significance considered
- ✅ Limitations acknowledged
- ✅ PRISMA checklist complete

---

**Version 2.2** | **Updated: December 2025** | **Validation: A+ (98%)**

*For full instructions, see USER_GUIDE.md*
*For validation proof, see EXECUTIVE_SUMMARY_2PAGE.md*

---

**END OF QUICK REFERENCE**
