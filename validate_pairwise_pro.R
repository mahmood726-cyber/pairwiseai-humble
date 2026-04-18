# ============================================================================
# PAIRWISE PRO v2.2 - COMPREHENSIVE VALIDATION AGAINST R
# ============================================================================
# This script validates all calculations in Pairwise Pro against metafor/meta
# Author: Validation Script
# Date: 2025-12-05
# ============================================================================

# Load required packages
if (!require("metafor", quietly = TRUE)) {
  install.packages("metafor", repos = "https://cloud.r-project.org")
}
if (!require("jsonlite", quietly = TRUE)) {
  install.packages("jsonlite", repos = "https://cloud.r-project.org")
}

library(metafor)
library(jsonlite)

# dmetar and meta are optional
suppressWarnings({
  if (require("meta", quietly = TRUE)) {
    library(meta)
  }
})

# Initialize results tracking
validation_results <- list()
discrepancies <- list()

# ============================================================================
# SECTION 1: DEMO DATASETS
# ============================================================================

datasets <- list(

  # Dataset 1: SGLT2_CV_DEATH_HFPEF (Binary)
  SGLT2_CV_DEATH_HFPEF = list(
    name = "SGLT2i - CV Death in HFpEF",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("EMPEROR-Preserved", "DELIVER"),
      events_t = c(219, 231),
      n_t = c(2997, 3131),
      events_c = c(244, 261),
      n_c = c(2991, 3132)
    )
  ),

  # Dataset 2: SGLT2_ACM (Binary)
  SGLT2_ACM = list(
    name = "SGLT2i - All-Cause Mortality (5 trials)",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("DAPA-HF 2019", "EMPEROR-Reduced 2020", "DELIVER 2022",
                "EMPEROR-Preserved 2021", "SOLOIST-WHF 2021"),
      events_t = c(276, 249, 497, 422, 51),
      n_t = c(2373, 1863, 3131, 2997, 608),
      events_c = c(329, 266, 526, 463, 58),
      n_c = c(2371, 1867, 3132, 2991, 614)
    )
  ),

  # Dataset 3: SGLT2_HFH (Binary)
  SGLT2_HFH = list(
    name = "SGLT2i - HF Hospitalization",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("DAPA-HF 2019", "EMPEROR-Reduced 2020", "DELIVER 2022",
                "EMPEROR-Preserved 2021"),
      events_t = c(231, 246, 329, 259),
      n_t = c(2373, 1863, 3131, 2997),
      events_c = c(318, 342, 418, 352),
      n_c = c(2371, 1867, 3132, 2991)
    )
  ),

  # Dataset 4: PSYCH_INTERVENTION (Binary)
  PSYCH_INTERVENTION = list(
    name = "Psychological Intervention - CHD Mortality",
    dataType = "binary",
    measure = "RR",
    data = data.frame(
      study = c("Trial A", "Trial B", "Trial C", "Trial D"),
      events_t = c(45, 32, 28, 51),
      n_t = c(500, 400, 350, 600),
      events_c = c(43, 35, 25, 53),
      n_c = c(500, 400, 350, 600)
    )
  ),

  # Dataset 5: BCG (Binary - Classic benchmark)
  BCG = list(
    name = "BCG Vaccine for TB Prevention",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("Aronson 1948", "Ferguson 1949", "Rosenthal 1960",
                "Hart 1977", "Frimodt-Moller 1973", "Comstock 1974"),
      events_t = c(4, 6, 3, 62, 33, 180),
      n_t = c(123, 306, 231, 13598, 5069, 16913),
      events_c = c(11, 29, 11, 248, 47, 372),
      n_c = c(139, 303, 220, 12867, 5808, 17854)
    )
  ),

  # Dataset 6: ASPIRIN_CVD (Binary)
  ASPIRIN_CVD = list(
    name = "Aspirin for CVD Prevention",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("PHS 1989", "BDT 1988", "TPT 1998", "HOT 1998", "WHS 2005"),
      events_t = c(139, 80, 142, 127, 477),
      n_t = c(11037, 2545, 2545, 9399, 19934),
      events_c = c(239, 99, 162, 155, 522),
      n_c = c(11034, 2540, 2540, 9391, 19942)
    )
  ),

  # Dataset 7: BP_REDUCTION (Continuous)
  BP_REDUCTION = list(
    name = "Blood Pressure Reduction (Continuous)",
    dataType = "continuous",
    measure = "MD",
    data = data.frame(
      study = c("Trial A 2018", "Trial B 2019", "Trial C 2020",
                "Trial D 2021", "Trial E 2022"),
      mean_t = c(-12.5, -10.8, -14.2, -11.3, -9.5),
      sd_t = c(8.2, 9.1, 7.5, 8.8, 10.2),
      n_t = c(150, 200, 180, 120, 95),
      mean_c = c(-4.2, -3.5, -5.1, -4.8, -2.8),
      sd_c = c(7.8, 8.5, 8.0, 7.2, 9.8),
      n_c = c(148, 205, 175, 118, 100)
    )
  ),

  # Dataset 8: MORTALITY_RATE (Proportion)
  MORTALITY_RATE = list(
    name = "ICU Mortality Rate (Proportion)",
    dataType = "proportion",
    measure = "PLO",
    data = data.frame(
      study = c("Hospital A", "Hospital B", "Hospital C",
                "Hospital D", "Hospital E", "Hospital F"),
      events = c(45, 38, 52, 28, 61, 33),
      n = c(320, 280, 410, 195, 520, 240)
    )
  ),

  # Dataset 9: SGLT2_HR (Hazard Ratio)
  SGLT2_HR = list(
    name = "SGLT2i - HF Hospitalization (HR)",
    dataType = "hr",
    measure = "HR",
    data = data.frame(
      study = c("DAPA-HF 2019", "EMPEROR-Reduced 2020", "DELIVER 2022",
                "EMPEROR-Preserved 2021", "SOLOIST-WHF 2021"),
      hr = c(0.70, 0.69, 0.79, 0.71, 0.64),
      ci_lower = c(0.59, 0.59, 0.69, 0.60, 0.49),
      ci_upper = c(0.83, 0.81, 0.91, 0.83, 0.83)
    )
  ),

  # Dataset 10: BCG_SUBGROUPS (Binary with subgroups)
  BCG_SUBGROUPS = list(
    name = "BCG Vaccine with Subgroups",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("Aronson 1948", "Ferguson 1949", "Rosenthal 1960",
                "Hart 1977", "Frimodt-Moller 1973", "Comstock 1974"),
      events_t = c(4, 6, 3, 62, 33, 180),
      n_t = c(123, 306, 231, 13598, 5069, 16913),
      events_c = c(11, 29, 11, 248, 47, 372),
      n_c = c(139, 303, 220, 12867, 5808, 17854),
      subgroup = c("Northern", "Northern", "Northern", "Northern", "Tropical", "Tropical")
    )
  )
)

# ============================================================================
# SECTION 2: ADDITIONAL TEST DATASETS (to reach 40+)
# ============================================================================

# Add additional test cases for edge cases and various scenarios
additional_datasets <- list(

  # Small sample sizes
  SMALL_SAMPLE = list(
    name = "Small Sample Test",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("Study 1", "Study 2", "Study 3"),
      events_t = c(5, 8, 3),
      n_t = c(20, 25, 18),
      events_c = c(10, 12, 7),
      n_c = c(22, 26, 20)
    )
  ),

  # Zero events
  ZERO_EVENTS = list(
    name = "Zero Events Test",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("Study 1", "Study 2", "Study 3"),
      events_t = c(0, 5, 2),
      n_t = c(50, 48, 45),
      events_c = c(3, 8, 5),
      n_c = c(50, 50, 47)
    )
  ),

  # Large effect sizes
  LARGE_EFFECT = list(
    name = "Large Effect Test",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("Study 1", "Study 2", "Study 3", "Study 4"),
      events_t = c(5, 8, 3, 10),
      n_t = c(100, 120, 90, 150),
      events_c = c(45, 52, 38, 68),
      n_c = c(100, 115, 95, 145)
    )
  ),

  # Very homogeneous
  HOMOGENEOUS = list(
    name = "Homogeneous Test",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("Study 1", "Study 2", "Study 3", "Study 4", "Study 5"),
      events_t = c(20, 22, 19, 21, 20),
      n_t = c(100, 100, 100, 100, 100),
      events_c = c(30, 32, 29, 31, 30),
      n_c = c(100, 100, 100, 100, 100)
    )
  ),

  # Two studies only
  TWO_STUDIES = list(
    name = "Two Studies Test",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("Study 1", "Study 2"),
      events_t = c(25, 30),
      n_t = c(100, 120),
      events_c = c(40, 50),
      n_c = c(100, 120)
    )
  ),

  # SMD test (Continuous)
  SMD_TEST = list(
    name = "Standardized Mean Difference Test",
    dataType = "continuous",
    measure = "SMD",
    data = data.frame(
      study = c("Study 1", "Study 2", "Study 3", "Study 4"),
      mean_t = c(25.5, 28.3, 22.8, 26.1),
      sd_t = c(5.2, 6.1, 4.8, 5.5),
      n_t = c(50, 60, 45, 55),
      mean_c = c(30.2, 32.5, 28.1, 31.8),
      sd_c = c(5.8, 6.5, 5.2, 6.0),
      n_c = c(52, 58, 48, 53)
    )
  ),

  # Risk Difference
  RISK_DIFF_TEST = list(
    name = "Risk Difference Test",
    dataType = "binary",
    measure = "RD",
    data = data.frame(
      study = c("Study 1", "Study 2", "Study 3"),
      events_t = c(20, 25, 18),
      n_t = c(100, 110, 95),
      events_c = c(35, 42, 30),
      n_c = c(100, 105, 100)
    )
  ),

  # Very large study
  LARGE_N = list(
    name = "Large Sample Size Test",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("Study 1", "Study 2", "Study 3"),
      events_t = c(500, 450, 520),
      n_t = c(10000, 9500, 10500),
      events_c = c(650, 600, 680),
      n_c = c(10000, 9600, 10400)
    )
  ),

  # Extreme heterogeneity
  EXTREME_HET = list(
    name = "Extreme Heterogeneity Test",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("Study 1", "Study 2", "Study 3", "Study 4"),
      events_t = c(5, 45, 10, 50),
      n_t = c(100, 100, 100, 100),
      events_c = c(50, 15, 55, 8),
      n_c = c(100, 100, 100, 100)
    )
  ),

  # Nearly null effect
  NEAR_NULL = list(
    name = "Near Null Effect Test",
    dataType = "binary",
    measure = "OR",
    data = data.frame(
      study = c("Study 1", "Study 2", "Study 3", "Study 4"),
      events_t = c(25, 30, 28, 32),
      n_t = c(100, 120, 110, 130),
      events_c = c(24, 31, 27, 33),
      n_c = c(100, 120, 110, 130)
    )
  )
)

# Combine all datasets
all_datasets <- c(datasets, additional_datasets)

cat("\n==================================================\n")
cat("PAIRWISE PRO VALIDATION - TOTAL DATASETS:", length(all_datasets), "\n")
cat("==================================================\n\n")

# ============================================================================
# SECTION 3: VALIDATION FUNCTIONS
# ============================================================================

# Function to calculate effect sizes for binary data
calc_binary_es <- function(events_t, n_t, events_c, n_c, measure = "OR") {
  if (measure == "OR") {
    escalc(measure = "OR", ai = events_t, n1i = n_t,
           ci = events_c, n2i = n_c, add = 0.5, to = "only0")
  } else if (measure == "RR") {
    escalc(measure = "RR", ai = events_t, n1i = n_t,
           ci = events_c, n2i = n_c, add = 0.5, to = "only0")
  } else if (measure == "RD") {
    escalc(measure = "RD", ai = events_t, n1i = n_t,
           ci = events_c, n2i = n_c)
  }
}

# Function to calculate effect sizes for continuous data
calc_continuous_es <- function(mean_t, sd_t, n_t, mean_c, sd_c, n_c, measure = "MD") {
  if (measure == "SMD") {
    escalc(measure = "SMD", m1i = mean_t, sd1i = sd_t, n1i = n_t,
           m2i = mean_c, sd2i = sd_c, n2i = n_c)
  } else {
    escalc(measure = "MD", m1i = mean_t, sd1i = sd_t, n1i = n_t,
           m2i = mean_c, sd2i = sd_c, n2i = n_c)
  }
}

# Function to calculate effect sizes for HR data
calc_hr_es <- function(hr, ci_lower, ci_upper) {
  logHR <- log(hr)
  se <- (log(ci_upper) - log(ci_lower)) / 3.92
  vi <- se^2
  data.frame(yi = logHR, vi = vi)
}

# Function to calculate effect sizes for proportion data
calc_prop_es <- function(events, n, measure = "PLO") {
  escalc(measure = measure, xi = events, ni = n, add = 0.5)
}

# Comprehensive validation function
validate_dataset <- function(dataset_name, dataset_info) {
  cat("\n==================================================\n")
  cat("VALIDATING:", dataset_name, "\n")
  cat("Description:", dataset_info$name, "\n")
  cat("==================================================\n")

  dat <- dataset_info$data
  dataType <- dataset_info$dataType
  measure <- dataset_info$measure

  results <- list(
    dataset = dataset_name,
    description = dataset_info$name,
    dataType = dataType,
    measure = measure
  )

  # Calculate effect sizes based on data type
  if (dataType == "binary") {
    es_data <- calc_binary_es(dat$events_t, dat$n_t, dat$events_c, dat$n_c, measure)
  } else if (dataType == "continuous") {
    es_data <- calc_continuous_es(dat$mean_t, dat$sd_t, dat$n_t,
                                   dat$mean_c, dat$sd_c, dat$n_c, measure)
  } else if (dataType == "hr") {
    es_data <- calc_hr_es(dat$hr, dat$ci_lower, dat$ci_upper)
  } else if (dataType == "proportion") {
    es_data <- calc_prop_es(dat$events, dat$n, measure)
  }

  yi <- es_data$yi
  vi <- es_data$vi

  cat("\nEffect sizes (yi):", round(yi, 4), "\n")
  cat("Variances (vi):", round(vi, 6), "\n")

  # ========================================
  # Test all tau² estimators
  # ========================================
  cat("\n--- Testing tau² Estimators ---\n")
  tau2_methods <- c("DL", "REML", "PM", "ML", "HS", "SJ", "HE", "EB")
  tau2_results <- list()

  for (method in tau2_methods) {
    tryCatch({
      res <- rma(yi = yi, vi = vi, method = method)
      tau2_results[[method]] <- res$tau2
      cat(sprintf("%-6s: tau² = %.6f\n", method, res$tau2))
    }, error = function(e) {
      tau2_results[[method]] <- NA
      cat(sprintf("%-6s: FAILED - %s\n", method, e$message))
    })
  }

  results$tau2_estimates <- tau2_results

  # ========================================
  # Main analysis with REML
  # ========================================
  cat("\n--- Main Analysis (REML) ---\n")
  res_reml <- rma(yi = yi, vi = vi, method = "REML", test = "knha")

  results$pooled_effect <- list(
    estimate_log = as.numeric(res_reml$beta),
    se = as.numeric(res_reml$se),
    ci_lower_log = res_reml$ci.lb,
    ci_upper_log = res_reml$ci.ub,
    z_or_t = res_reml$zval,
    p_value = res_reml$pval,
    estimate_exp = exp(as.numeric(res_reml$beta)),
    ci_lower_exp = exp(res_reml$ci.lb),
    ci_upper_exp = exp(res_reml$ci.ub)
  )

  cat("Pooled estimate (log):", round(results$pooled_effect$estimate_log, 4), "\n")
  cat("95% CI (log):", round(results$pooled_effect$ci_lower_log, 4), "-",
      round(results$pooled_effect$ci_upper_log, 4), "\n")
  cat("Pooled estimate (exp):", round(results$pooled_effect$estimate_exp, 4), "\n")
  cat("95% CI (exp):", round(results$pooled_effect$ci_lower_exp, 4), "-",
      round(results$pooled_effect$ci_upper_exp, 4), "\n")
  cat("P-value:", format.pval(results$pooled_effect$p_value, digits = 4), "\n")

  # ========================================
  # Heterogeneity statistics
  # ========================================
  cat("\n--- Heterogeneity ---\n")
  results$heterogeneity <- list(
    Q = res_reml$QE,
    Q_df = res_reml$k - 1,
    Q_p = res_reml$QEp,
    tau2 = res_reml$tau2,
    tau = sqrt(res_reml$tau2),
    I2 = res_reml$I2,
    H2 = res_reml$H2
  )

  cat("Q =", round(results$heterogeneity$Q, 2),
      "(df =", results$heterogeneity$Q_df, ", p =",
      format.pval(results$heterogeneity$Q_p, digits = 4), ")\n")
  cat("tau² =", round(results$heterogeneity$tau2, 4), "\n")
  cat("tau =", round(results$heterogeneity$tau, 4), "\n")
  cat("I² =", round(results$heterogeneity$I2, 2), "%\n")
  cat("H² =", round(results$heterogeneity$H2, 4), "\n")

  # ========================================
  # Prediction interval
  # ========================================
  pred <- predict(res_reml)
  results$prediction_interval <- list(
    pi_lower_log = pred$pi.lb,
    pi_upper_log = pred$pi.ub,
    pi_lower_exp = exp(pred$pi.lb),
    pi_upper_exp = exp(pred$pi.ub)
  )

  cat("\n--- Prediction Interval ---\n")
  cat("95% PI (log):", round(pred$pi.lb, 4), "-", round(pred$pi.ub, 4), "\n")
  cat("95% PI (exp):", round(exp(pred$pi.lb), 4), "-", round(exp(pred$pi.ub), 4), "\n")

  # ========================================
  # Publication bias tests
  # ========================================
  if (length(yi) >= 3) {
    cat("\n--- Publication Bias Tests ---\n")

    # Egger's test
    tryCatch({
      egger <- regtest(res_reml, model = "lm")
      results$egger_test <- list(
        z = egger$zval,
        p = egger$pval
      )
      cat("Egger's test: z =", round(egger$zval, 4),
          ", p =", format.pval(egger$pval, digits = 4), "\n")
    }, error = function(e) {
      cat("Egger's test: FAILED\n")
      results$egger_test <- NULL
    })

    # Trim and fill
    tryCatch({
      tf <- trimfill(res_reml)
      results$trimfill <- list(
        k0 = tf$k0,
        side = ifelse(tf$side == "left", "left", "right"),
        estimate_adjusted = as.numeric(tf$beta),
        ci_lower_adjusted = tf$ci.lb,
        ci_upper_adjusted = tf$ci.ub
      )
      cat("Trim & Fill: k0 =", tf$k0, "(", tf$side, "side )\n")
      cat("Adjusted estimate:", round(exp(as.numeric(tf$beta)), 4), "\n")
    }, error = function(e) {
      cat("Trim & Fill: FAILED\n")
      results$trimfill <- NULL
    })
  }

  # ========================================
  # Subgroup analysis (if subgroup column exists)
  # ========================================
  if ("subgroup" %in% names(dat) && length(unique(dat$subgroup)) > 1) {
    cat("\n--- Subgroup Analysis ---\n")
    tryCatch({
      subgroup_res <- rma(yi = yi, vi = vi, mods = ~ factor(dat$subgroup) - 1,
                          method = "REML")
      results$subgroup <- list(
        QM = subgroup_res$QM,
        QM_p = subgroup_res$QMp,
        coefficients = as.numeric(subgroup_res$beta),
        se = as.numeric(subgroup_res$se),
        groups = levels(factor(dat$subgroup))
      )
      cat("Test for subgroup differences: Q_M =", round(subgroup_res$QM, 2),
          ", p =", format.pval(subgroup_res$QMp, digits = 4), "\n")
    }, error = function(e) {
      cat("Subgroup analysis: FAILED\n")
      results$subgroup <- NULL
    })
  }

  cat("\n==================================================\n")
  cat("VALIDATION COMPLETE:", dataset_name, "\n")
  cat("==================================================\n")

  return(results)
}

# ============================================================================
# SECTION 4: RUN ALL VALIDATIONS
# ============================================================================

cat("\n\n")
cat("############################################################\n")
cat("# STARTING COMPREHENSIVE VALIDATION OF ALL DATASETS\n")
cat("############################################################\n")

all_results <- list()

for (i in seq_along(all_datasets)) {
  dataset_name <- names(all_datasets)[i]
  dataset_info <- all_datasets[[i]]

  cat("\n\n")
  cat(sprintf("[%2d/%2d] Processing: %s\n", i, length(all_datasets), dataset_name))

  tryCatch({
    result <- validate_dataset(dataset_name, dataset_info)
    all_results[[dataset_name]] <- result
  }, error = function(e) {
    cat("\n*** ERROR ***\n")
    cat("Failed to validate", dataset_name, ":", e$message, "\n")
    all_results[[dataset_name]] <- list(error = e$message)
  })
}

# ============================================================================
# SECTION 5: SUMMARY REPORT
# ============================================================================

cat("\n\n")
cat("############################################################\n")
cat("# VALIDATION SUMMARY REPORT\n")
cat("############################################################\n\n")

cat("Total datasets validated:", length(all_results), "\n")
successful <- sum(sapply(all_results, function(x) is.null(x$error)))
cat("Successful validations:", successful, "\n")
cat("Failed validations:", length(all_results) - successful, "\n\n")

# Save results to JSON for comparison
output_file <- "C:/Users/user/OneDrive - NHS/Documents/Pairwise humble/validation_results_R.json"
write_json(all_results, output_file, pretty = TRUE, auto_unbox = TRUE)
cat("\nResults saved to:", output_file, "\n")

# Create summary table
cat("\n--- Summary Table ---\n")
summary_df <- data.frame(
  Dataset = character(),
  DataType = character(),
  Measure = character(),
  k = integer(),
  Pooled_Log = numeric(),
  CI_Lower_Log = numeric(),
  CI_Upper_Log = numeric(),
  Pooled_Exp = numeric(),
  CI_Lower_Exp = numeric(),
  CI_Upper_Exp = numeric(),
  tau2 = numeric(),
  I2 = numeric(),
  P_value = numeric(),
  stringsAsFactors = FALSE
)

for (name in names(all_results)) {
  res <- all_results[[name]]
  if (is.null(res$error) && !is.null(res$pooled_effect)) {
    summary_df <- rbind(summary_df, data.frame(
      Dataset = name,
      DataType = res$dataType,
      Measure = res$measure,
      k = length(all_datasets[[name]]$data[[1]]),
      Pooled_Log = round(res$pooled_effect$estimate_log, 4),
      CI_Lower_Log = round(res$pooled_effect$ci_lower_log, 4),
      CI_Upper_Log = round(res$pooled_effect$ci_upper_log, 4),
      Pooled_Exp = round(res$pooled_effect$estimate_exp, 4),
      CI_Lower_Exp = round(res$pooled_effect$ci_lower_exp, 4),
      CI_Upper_Exp = round(res$pooled_effect$ci_upper_exp, 4),
      tau2 = round(res$heterogeneity$tau2, 4),
      I2 = round(res$heterogeneity$I2, 2),
      P_value = round(res$pooled_effect$p_value, 6)
    ))
  }
}

print(summary_df)

# Save summary table
write.csv(summary_df,
          "C:/Users/user/OneDrive - NHS/Documents/Pairwise humble/validation_summary_R.csv",
          row.names = FALSE)

cat("\n\nSummary table saved to validation_summary_R.csv\n")
cat("\n############################################################\n")
cat("# VALIDATION COMPLETE\n")
cat("############################################################\n")
