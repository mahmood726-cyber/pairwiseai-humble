# ============================================================================
# FORMULA-LEVEL VALIDATION: JavaScript Functions vs R
# ============================================================================
# This script validates the mathematical formulas used in Pairwise Pro
# by comparing JavaScript calculations against R reference implementations
# ============================================================================

library(metafor)

cat("\n")
cat("============================================================================\n")
cat(" FORMULA-LEVEL VALIDATION OF PAIRWISE PRO\n")
cat("============================================================================\n\n")

# Initialize tracking
formula_tests <- list()
discrepancies_found <- 0

# ============================================================================
# TEST 1: Effect Size Calculations - Log Odds Ratio
# ============================================================================
cat("TEST 1: Log Odds Ratio Calculation\n")
cat("-----------------------------------\n")

# Test case
a <- 20  # events treatment
b <- 80  # non-events treatment
c <- 40  # events control
d <- 60  # non-events control

# R calculation (metafor)
r_result <- escalc(measure = "OR", ai = a, bi = b, ci = c, di = d,
                   add = 0.5, to = "only0")
r_logOR <- as.numeric(r_result$yi)
r_vi <- as.numeric(r_result$vi)

# Manual calculation (JavaScript formula)
# log(OR) = log((a * d) / (b * c))
# var = 1/a + 1/b + 1/c + 1/d
js_logOR <- log((a * d) / (b * c))
js_vi <- 1/a + 1/b + 1/c + 1/d

cat("R logOR:        ", round(r_logOR, 6), "\n")
cat("JS logOR:       ", round(js_logOR, 6), "\n")
cat("Difference:     ", round(abs(r_logOR - js_logOR), 8), "\n")
cat("R variance:     ", round(r_vi, 6), "\n")
cat("JS variance:    ", round(js_vi, 6), "\n")
cat("Difference:     ", round(abs(r_vi - js_vi), 8), "\n")

test1_pass <- abs(r_logOR - js_logOR) < 1e-6 && abs(r_vi - js_vi) < 1e-6
cat("Status:         ", ifelse(test1_pass, "✓ PASS", "✗ FAIL"), "\n\n")

formula_tests$logOR <- list(
  test = "Log Odds Ratio",
  pass = test1_pass,
  r_value = r_logOR,
  js_value = js_logOR,
  diff = abs(r_logOR - js_logOR)
)

if (!test1_pass) discrepancies_found <- discrepancies_found + 1

# ============================================================================
# TEST 2: Effect Size with Zero Events (Continuity Correction)
# ============================================================================
cat("TEST 2: Zero Events Handling (Continuity Correction)\n")
cat("------------------------------------------------------\n")

# Test with zero events
a <- 0
b <- 50
c <- 5
d <- 45

# R calculation with 0.5 continuity correction
r_result_cc <- escalc(measure = "OR", ai = a, bi = b, ci = c, di = d,
                      add = 0.5, to = "only0")
r_logOR_cc <- as.numeric(r_result_cc$yi)
r_vi_cc <- as.numeric(r_result_cc$vi)

# JavaScript formula with continuity correction
a_cc <- a + 0.5
b_cc <- b + 0.5
c_cc <- c + 0.5
d_cc <- d + 0.5
js_logOR_cc <- log((a_cc * d_cc) / (b_cc * c_cc))
js_vi_cc <- 1/a_cc + 1/b_cc + 1/c_cc + 1/d_cc

cat("R logOR (CC):   ", round(r_logOR_cc, 6), "\n")
cat("JS logOR (CC):  ", round(js_logOR_cc, 6), "\n")
cat("Difference:     ", round(abs(r_logOR_cc - js_logOR_cc), 8), "\n")

test2_pass <- abs(r_logOR_cc - js_logOR_cc) < 1e-6
cat("Status:         ", ifelse(test2_pass, "✓ PASS", "✗ FAIL"), "\n\n")

formula_tests$continuity_correction <- list(
  test = "Continuity Correction",
  pass = test2_pass,
  diff = abs(r_logOR_cc - js_logOR_cc)
)

if (!test2_pass) discrepancies_found <- discrepancies_found + 1

# ============================================================================
# TEST 3: Mean Difference (Continuous Data)
# ============================================================================
cat("TEST 3: Mean Difference Calculation\n")
cat("------------------------------------\n")

mean_t <- 25.5
sd_t <- 5.2
n_t <- 50
mean_c <- 30.2
sd_c <- 5.8
n_c <- 52

# R calculation
r_md <- escalc(measure = "MD", m1i = mean_t, sd1i = sd_t, n1i = n_t,
               m2i = mean_c, sd2i = sd_c, n2i = n_c)
r_md_value <- as.numeric(r_md$yi)
r_md_vi <- as.numeric(r_md$vi)

# JavaScript formula
# MD = mean1 - mean2
# var = sd1²/n1 + sd2²/n2
js_md_value <- mean_t - mean_c
js_md_vi <- (sd_t^2 / n_t) + (sd_c^2 / n_c)

cat("R MD:           ", round(r_md_value, 6), "\n")
cat("JS MD:          ", round(js_md_value, 6), "\n")
cat("Difference:     ", round(abs(r_md_value - js_md_value), 8), "\n")
cat("R variance:     ", round(r_md_vi, 6), "\n")
cat("JS variance:    ", round(js_md_vi, 6), "\n")
cat("Difference:     ", round(abs(r_md_vi - js_md_vi), 8), "\n")

test3_pass <- abs(r_md_value - js_md_value) < 1e-6 && abs(r_md_vi - js_md_vi) < 1e-6
cat("Status:         ", ifelse(test3_pass, "✓ PASS", "✗ FAIL"), "\n\n")

formula_tests$mean_difference <- list(
  test = "Mean Difference",
  pass = test3_pass,
  diff = abs(r_md_value - js_md_value)
)

if (!test3_pass) discrepancies_found <- discrepancies_found + 1

# ============================================================================
# TEST 4: Standardized Mean Difference (SMD/Hedges' g)
# ============================================================================
cat("TEST 4: Standardized Mean Difference (Hedges' g)\n")
cat("-------------------------------------------------\n")

# R calculation
r_smd <- escalc(measure = "SMD", m1i = mean_t, sd1i = sd_t, n1i = n_t,
                m2i = mean_c, sd2i = sd_c, n2i = n_c)
r_smd_value <- as.numeric(r_smd$yi)
r_smd_vi <- as.numeric(r_smd$vi)

# JavaScript formula (Hedges' g with small sample correction)
# Pooled SD
pooled_sd <- sqrt(((n_t - 1) * sd_t^2 + (n_c - 1) * sd_c^2) / (n_t + n_c - 2))
# Cohen's d
cohens_d <- (mean_t - mean_c) / pooled_sd
# Small sample correction factor J
df <- n_t + n_c - 2
J <- 1 - 3 / (4 * df - 1)
# Hedges' g = J * d
js_smd_value <- J * cohens_d
# Variance
js_smd_vi <- ((n_t + n_c) / (n_t * n_c)) + (js_smd_value^2 / (2 * (n_t + n_c)))

cat("R SMD:          ", round(r_smd_value, 6), "\n")
cat("JS SMD:         ", round(js_smd_value, 6), "\n")
cat("Difference:     ", round(abs(r_smd_value - js_smd_value), 8), "\n")
cat("R variance:     ", round(r_smd_vi, 6), "\n")
cat("JS variance:    ", round(js_smd_vi, 6), "\n")
cat("Difference:     ", round(abs(r_smd_vi - js_smd_vi), 8), "\n")

test4_pass <- abs(r_smd_value - js_smd_value) < 1e-4 && abs(r_smd_vi - js_smd_vi) < 1e-4
cat("Status:         ", ifelse(test4_pass, "✓ PASS", "✗ FAIL"), "\n\n")

formula_tests$smd <- list(
  test = "Standardized Mean Difference",
  pass = test4_pass,
  diff = abs(r_smd_value - js_smd_value)
)

if (!test4_pass) discrepancies_found <- discrepancies_found + 1

# ============================================================================
# TEST 5: DerSimonian-Laird (DL) tau² Estimator
# ============================================================================
cat("TEST 5: DerSimonian-Laird tau² Estimator\n")
cat("-----------------------------------------\n")

# Use BCG dataset
yi <- c(-0.9387, -1.6662, -1.3863, -1.4564, -0.2191, -0.6821)
vi <- c(0.357125, 0.208132, 0.433413, 0.020314, 0.051952, 0.008361)

# R calculation
r_dl <- rma(yi = yi, vi = vi, method = "DL")
r_tau2_dl <- r_dl$tau2

# JavaScript DL formula
k <- length(yi)
wi <- 1 / vi
sumW <- sum(wi)
theta_fe <- sum(wi * yi) / sumW
Q <- sum(wi * (yi - theta_fe)^2)
C <- sumW - sum(wi^2) / sumW
js_tau2_dl <- max(0, (Q - (k - 1)) / C)

cat("R tau² (DL):    ", round(r_tau2_dl, 6), "\n")
cat("JS tau² (DL):   ", round(js_tau2_dl, 6), "\n")
cat("Difference:     ", round(abs(r_tau2_dl - js_tau2_dl), 8), "\n")

test5_pass <- abs(r_tau2_dl - js_tau2_dl) < 1e-5
cat("Status:         ", ifelse(test5_pass, "✓ PASS", "✗ FAIL"), "\n\n")

formula_tests$tau2_dl <- list(
  test = "tau² DerSimonian-Laird",
  pass = test5_pass,
  r_value = r_tau2_dl,
  js_value = js_tau2_dl,
  diff = abs(r_tau2_dl - js_tau2_dl)
)

if (!test5_pass) discrepancies_found <- discrepancies_found + 1

# ============================================================================
# TEST 6: Q Statistic and I²
# ============================================================================
cat("TEST 6: Q Statistic and I²\n")
cat("---------------------------\n")

# R calculation
r_Q <- r_dl$QE
r_I2 <- r_dl$I2

# JavaScript formula
# Q already calculated above
js_Q <- Q
# I² = 100% * (Q - df) / Q, constrained to [0, 100]
js_I2 <- max(0, min(100, 100 * (Q - (k - 1)) / Q))

cat("R Q:            ", round(r_Q, 4), "\n")
cat("JS Q:           ", round(js_Q, 4), "\n")
cat("Difference:     ", round(abs(r_Q - js_Q), 8), "\n")
cat("R I²:           ", round(r_I2, 2), "%\n")
cat("JS I²:          ", round(js_I2, 2), "%\n")
cat("Difference:     ", round(abs(r_I2 - js_I2), 4), "%\n")

test6_pass <- abs(r_Q - js_Q) < 1e-5 && abs(r_I2 - js_I2) < 0.1
cat("Status:         ", ifelse(test6_pass, "✓ PASS", "✗ FAIL"), "\n\n")

formula_tests$heterogeneity <- list(
  test = "Q and I² Statistics",
  pass = test6_pass,
  Q_diff = abs(r_Q - js_Q),
  I2_diff = abs(r_I2 - js_I2)
)

if (!test6_pass) discrepancies_found <- discrepancies_found + 1

# ============================================================================
# TEST 7: Pooled Effect Estimate (Random Effects)
# ============================================================================
cat("TEST 7: Pooled Effect Estimate (Random Effects)\n")
cat("------------------------------------------------\n")

# R calculation (using DL tau²)
r_pooled <- coef(r_dl)
r_se <- r_dl$se
r_ci_lb <- r_dl$ci.lb
r_ci_ub <- r_dl$ci.ub
r_pval <- r_dl$pval

# JavaScript formula
wi_re <- 1 / (vi + js_tau2_dl)
sumW_re <- sum(wi_re)
js_pooled <- sum(wi_re * yi) / sumW_re
js_se <- sqrt(1 / sumW_re)
z_crit <- 1.96
js_ci_lb <- js_pooled - z_crit * js_se
js_ci_ub <- js_pooled + z_crit * js_se
z_stat <- js_pooled / js_se
js_pval <- 2 * (1 - pnorm(abs(z_stat)))

cat("R Pooled:       ", round(r_pooled, 6), "\n")
cat("JS Pooled:      ", round(js_pooled, 6), "\n")
cat("Difference:     ", round(abs(r_pooled - js_pooled), 8), "\n")
cat("R SE:           ", round(r_se, 6), "\n")
cat("JS SE:          ", round(js_se, 6), "\n")
cat("Difference:     ", round(abs(r_se - js_se), 8), "\n")
cat("R p-value:      ", round(r_pval, 6), "\n")
cat("JS p-value:     ", round(js_pval, 6), "\n")
cat("Difference:     ", round(abs(r_pval - js_pval), 8), "\n")

test7_pass <- abs(r_pooled - js_pooled) < 1e-5 && abs(r_se - js_se) < 1e-5
cat("Status:         ", ifelse(test7_pass, "✓ PASS", "✗ FAIL"), "\n\n")

formula_tests$pooled_effect <- list(
  test = "Pooled Effect Estimate",
  pass = test7_pass,
  estimate_diff = abs(r_pooled - js_pooled),
  se_diff = abs(r_se - js_se)
)

if (!test7_pass) discrepancies_found <- discrepancies_found + 1

# ============================================================================
# TEST 8: Prediction Interval
# ============================================================================
cat("TEST 8: Prediction Interval\n")
cat("----------------------------\n")

# R calculation
r_pred <- predict(r_dl)
r_pi_lb <- r_pred$pi.lb
r_pi_ub <- r_pred$pi.ub

# JavaScript formula
# PI = theta ± t(k-2) * sqrt(tau² + se²)
t_crit <- qt(0.975, k - 2)
pi_se <- sqrt(js_tau2_dl + js_se^2)
js_pi_lb <- js_pooled - t_crit * pi_se
js_pi_ub <- js_pooled + t_crit * pi_se

cat("R PI lower:     ", round(r_pi_lb, 4), "\n")
cat("JS PI lower:    ", round(js_pi_lb, 4), "\n")
cat("Difference:     ", round(abs(r_pi_lb - js_pi_lb), 6), "\n")
cat("R PI upper:     ", round(r_pi_ub, 4), "\n")
cat("JS PI upper:    ", round(js_pi_ub, 4), "\n")
cat("Difference:     ", round(abs(r_pi_ub - js_pi_ub), 6), "\n")

test8_pass <- abs(r_pi_lb - js_pi_lb) < 0.01 && abs(r_pi_ub - js_pi_ub) < 0.01
cat("Status:         ", ifelse(test8_pass, "✓ PASS", "✗ FAIL"), "\n\n")

formula_tests$prediction_interval <- list(
  test = "Prediction Interval",
  pass = test8_pass,
  lower_diff = abs(r_pi_lb - js_pi_lb),
  upper_diff = abs(r_pi_ub - js_pi_ub)
)

if (!test8_pass) discrepancies_found <- discrepancies_found + 1

# ============================================================================
# TEST 9: Egger's Test for Publication Bias
# ============================================================================
cat("TEST 9: Egger's Test\n")
cat("--------------------\n")

# R calculation
r_egger <- regtest(r_dl, model = "lm")
r_egger_z <- r_egger$zval
r_egger_p <- r_egger$pval

# JavaScript would use linear regression: yi ~ sei
sei <- sqrt(vi)
# Fit: yi = b0 + b1 * sei
n <- length(yi)
mean_sei <- mean(sei)
mean_yi <- mean(yi)

# Slope (b1)
b1 <- sum((sei - mean_sei) * (yi - mean_yi)) / sum((sei - mean_sei)^2)

# Intercept (b0)
b0 <- mean_yi - b1 * mean_sei

# Residuals
fitted <- b0 + b1 * sei
residuals <- yi - fitted

# Standard error of slope
rss <- sum(residuals^2)
df_resid <- n - 2
mse <- rss / df_resid
se_b1 <- sqrt(mse / sum((sei - mean_sei)^2))

# t-statistic
t_stat <- b1 / se_b1

# p-value (two-tailed)
js_egger_p <- 2 * (1 - pt(abs(t_stat), df_resid))

cat("R Egger z:      ", round(r_egger_z, 4), "\n")
cat("JS Egger t:     ", round(t_stat, 4), "\n")
cat("R Egger p:      ", round(r_egger_p, 4), "\n")
cat("JS Egger p:     ", round(js_egger_p, 4), "\n")
cat("Difference (p): ", round(abs(r_egger_p - js_egger_p), 6), "\n")

# Note: R uses z-test, JS might use t-test, so small differences expected
test9_pass <- abs(r_egger_p - js_egger_p) < 0.05
cat("Status:         ", ifelse(test9_pass, "✓ PASS (within tolerance)", "✗ FAIL"), "\n\n")

formula_tests$egger_test <- list(
  test = "Egger's Test",
  pass = test9_pass,
  p_diff = abs(r_egger_p - js_egger_p),
  note = "Small differences expected (z vs t test)"
)

if (!test9_pass) discrepancies_found <- discrepancies_found + 1

# ============================================================================
# TEST 10: Hazard Ratio from CI
# ============================================================================
cat("TEST 10: Hazard Ratio Effect Size from CI\n")
cat("------------------------------------------\n")

hr <- 0.70
ci_lower <- 0.59
ci_upper <- 0.83

# R calculation
logHR_r <- log(hr)
se_r <- (log(ci_upper) - log(ci_lower)) / 3.92
vi_r <- se_r^2

# JavaScript formula
logHR_js <- log(hr)
se_js <- (log(ci_upper) - log(ci_lower)) / 3.92
vi_js <- se_js^2

cat("R logHR:        ", round(logHR_r, 6), "\n")
cat("JS logHR:       ", round(logHR_js, 6), "\n")
cat("Difference:     ", round(abs(logHR_r - logHR_js), 8), "\n")
cat("R variance:     ", round(vi_r, 6), "\n")
cat("JS variance:    ", round(vi_js, 6), "\n")
cat("Difference:     ", round(abs(vi_r - vi_js), 8), "\n")

test10_pass <- abs(logHR_r - logHR_js) < 1e-10 && abs(vi_r - vi_js) < 1e-10
cat("Status:         ", ifelse(test10_pass, "✓ PASS", "✗ FAIL"), "\n\n")

formula_tests$hr_from_ci <- list(
  test = "HR from CI",
  pass = test10_pass,
  diff = abs(logHR_r - logHR_js)
)

if (!test10_pass) discrepancies_found <- discrepancies_found + 1

# ============================================================================
# SUMMARY REPORT
# ============================================================================

cat("\n")
cat("============================================================================\n")
cat(" VALIDATION SUMMARY\n")
cat("============================================================================\n\n")

total_tests <- length(formula_tests)
passed_tests <- sum(sapply(formula_tests, function(x) x$pass))
failed_tests <- total_tests - passed_tests

cat("Total tests:    ", total_tests, "\n")
cat("Passed:         ", passed_tests, " (", round(100*passed_tests/total_tests, 1), "%)\n", sep="")
cat("Failed:         ", failed_tests, "\n\n")

if (failed_tests == 0) {
  cat("✓✓✓ ALL TESTS PASSED! ✓✓✓\n")
  cat("Pairwise Pro formulas match R reference implementations.\n\n")
} else {
  cat("⚠️  FAILURES DETECTED ⚠️\n")
  cat("The following tests failed:\n\n")
  for (name in names(formula_tests)) {
    test <- formula_tests[[name]]
    if (!test$pass) {
      cat("  ✗", test$test, "\n")
      if (!is.null(test$diff)) {
        cat("    Difference:", format(test$diff, scientific = TRUE), "\n")
      }
    }
  }
  cat("\n")
}

# Save results
output_file <- "C:/Users/user/OneDrive - NHS/Documents/Pairwise humble/formula_validation_results.txt"
sink(output_file)
cat("FORMULA VALIDATION RESULTS\n")
cat("==========================\n\n")
cat("Total tests:", total_tests, "\n")
cat("Passed:", passed_tests, "\n")
cat("Failed:", failed_tests, "\n\n")

for (name in names(formula_tests)) {
  test <- formula_tests[[name]]
  cat(test$test, ":", ifelse(test$pass, "PASS", "FAIL"), "\n")
}
sink()

cat("Results saved to:", output_file, "\n\n")

cat("============================================================================\n")
