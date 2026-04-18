/**
 * PAIRWISE PRO RESULTS EXTRACTOR
 * Run this in the browser console when Pairwise Pro HTML is loaded
 * This will extract all analysis results for validation comparison
 */

// List of all demo datasets to test
const datasetsToTest = [
  'SGLT2_CV_DEATH_HFPEF',
  'SGLT2_ACM',
  'SGLT2_HFH',
  'PSYCH_INTERVENTION',
  'BCG',
  'ASPIRIN_CVD',
  'BP_REDUCTION',
  'MORTALITY_RATE',
  'SGLT2_HR',
  'BCG_SUBGROUPS'
];

// Storage for all results
const allPairwiseResults = {};

// Function to load dataset and extract results
async function extractDatasetResults(datasetKey) {
  console.log(`\n========== Extracting: ${datasetKey} ==========`);

  try {
    // Load the demo dataset
    loadDemoDataset(datasetKey);

    // Wait for UI to update
    await new Promise(resolve => setTimeout(resolve, 500));

    // Run the analysis
    runAnalysis();

    // Wait for analysis to complete
    await new Promise(resolve => setTimeout(resolve, 2000));

    // Extract results from AppState
    const results = {
      dataset: datasetKey,
      description: DEMO_DATASETS[datasetKey].name,
      dataType: AppState.settings.dataType,
      measure: AppState.settings.effectMeasure,

      // Effect sizes
      yi: AppState.results.yi,
      vi: AppState.results.vi,
      sei: AppState.results.sei,

      // Tau² estimates
      tau2_estimates: {
        REML: AppState.results.tau2Result?.tau2,
        method_used: AppState.settings.tau2Method,
        all_methods: AppState.results.tau2_all
      },

      // Pooled estimates
      pooled_effect: {
        estimate_log: AppState.results.pooled?.theta,
        se: AppState.results.pooled?.se,
        ci_lower_log: AppState.results.pooled?.ci_lower,
        ci_upper_log: AppState.results.pooled?.ci_upper,
        z_or_t: AppState.results.pooled?.z,
        p_value: AppState.results.pooled?.p_value,
        estimate_exp: Math.exp(AppState.results.pooled?.theta || 0),
        ci_lower_exp: Math.exp(AppState.results.pooled?.ci_lower || 0),
        ci_upper_exp: Math.exp(AppState.results.pooled?.ci_upper || 0)
      },

      // HKSJ adjusted (if enabled)
      hksj: AppState.results.hksj,

      // Heterogeneity
      heterogeneity: {
        Q: AppState.results.het?.Q,
        Q_df: AppState.results.het?.Q_df,
        Q_p: AppState.results.het?.Q_p,
        tau2: AppState.results.het?.tau2,
        tau: AppState.results.het?.tau,
        I2: AppState.results.het?.I2,
        H2: AppState.results.het?.H2
      },

      // Prediction intervals
      prediction_interval: {
        standard: AppState.results.pi_standard,
        noma: AppState.results.pi_noma,
        conformal: AppState.results.pi_conformal
      },

      // DDMA
      ddma: AppState.results.ddma,
      laev: AppState.results.laev,

      // Publication bias
      egger_test: AppState.results.egger,
      peters_test: AppState.results.peters,
      trimfill: AppState.results.trimfill,

      // Sensitivity analyses
      leave_one_out: AppState.results.loo,
      baujat: AppState.results.baujat,

      // Subgroup analysis
      subgroup: AppState.results.subgroups,

      // Meta-regression
      metaregression: AppState.results.metareg
    };

    console.log('Results extracted:', results);
    allPairwiseResults[datasetKey] = results;

    return results;

  } catch (error) {
    console.error(`Error extracting ${datasetKey}:`, error);
    allPairwiseResults[datasetKey] = { error: error.message };
    return null;
  }
}

// Function to run all extractions sequentially
async function extractAllResults() {
  console.log('========================================');
  console.log('STARTING PAIRWISE PRO RESULTS EXTRACTION');
  console.log('========================================\n');

  for (let i = 0; i < datasetsToTest.length; i++) {
    const datasetKey = datasetsToTest[i];
    console.log(`\n[${i+1}/${datasetsToTest.length}] Processing: ${datasetKey}`);
    await extractDatasetResults(datasetKey);

    // Wait between datasets
    await new Promise(resolve => setTimeout(resolve, 1000));
  }

  console.log('\n========================================');
  console.log('EXTRACTION COMPLETE');
  console.log('========================================\n');

  // Display summary
  console.log('Datasets processed:', Object.keys(allPairwiseResults).length);
  console.log('\nResults object:');
  console.log(allPairwiseResults);

  // Convert to JSON for download
  const jsonString = JSON.stringify(allPairwiseResults, null, 2);

  // Create download link
  const blob = new Blob([jsonString], { type: 'application/json' });
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = 'pairwise_pro_results.json';
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);

  console.log('\n✓ Results saved to pairwise_pro_results.json');
  console.log('\nYou can also copy from the console:');
  console.log('Copy this → allPairwiseResults');

  return allPairwiseResults;
}

// Function to compare with R results (if you paste R results into console)
function compareWithR(rResults) {
  console.log('\n========================================');
  console.log('COMPARING PAIRWISE PRO vs R RESULTS');
  console.log('========================================\n');

  const comparisons = [];
  const discrepancies = [];

  for (const dataset in allPairwiseResults) {
    const pw = allPairwiseResults[dataset];
    const r = rResults[dataset];

    if (!r || pw.error || r.error) {
      console.log(`⚠️  ${dataset}: Skipped (error in one or both)`);
      continue;
    }

    // Compare pooled estimate
    const pooledDiff = Math.abs(pw.pooled_effect.estimate_log - r.pooled_effect.estimate_log);
    const tau2Diff = Math.abs(pw.heterogeneity.tau2 - r.heterogeneity.tau2);
    const I2Diff = Math.abs(pw.heterogeneity.I2 - r.heterogeneity.I2);

    const comparison = {
      dataset,
      pooled_estimate: {
        pairwise: pw.pooled_effect.estimate_log?.toFixed(4),
        r: r.pooled_effect.estimate_log?.toFixed(4),
        diff: pooledDiff.toFixed(6),
        match: pooledDiff < 0.001 ? '✓' : '✗'
      },
      tau2: {
        pairwise: pw.heterogeneity.tau2?.toFixed(6),
        r: r.heterogeneity.tau2?.toFixed(6),
        diff: tau2Diff.toFixed(6),
        match: tau2Diff < 0.001 ? '✓' : '✗'
      },
      I2: {
        pairwise: pw.heterogeneity.I2?.toFixed(2),
        r: r.heterogeneity.I2?.toFixed(2),
        diff: I2Diff.toFixed(2),
        match: I2Diff < 1 ? '✓' : '✗'
      }
    };

    comparisons.push(comparison);

    // Log results
    console.log(`\n${dataset}:`);
    console.log(`  Pooled: PW=${comparison.pooled_estimate.pairwise}, R=${comparison.pooled_estimate.r} ${comparison.pooled_estimate.match}`);
    console.log(`  tau²:   PW=${comparison.tau2.pairwise}, R=${comparison.tau2.r} ${comparison.tau2.match}`);
    console.log(`  I²:     PW=${comparison.I2.pairwise}%, R=${comparison.I2.r}% ${comparison.I2.match}`);

    // Track discrepancies
    if (pooledDiff >= 0.001 || tau2Diff >= 0.001 || I2Diff >= 1) {
      discrepancies.push({
        dataset,
        issues: {
          pooled: pooledDiff >= 0.001,
          tau2: tau2Diff >= 0.001,
          I2: I2Diff >= 1
        },
        differences: {
          pooled: pooledDiff,
          tau2: tau2Diff,
          I2: I2Diff
        }
      });
    }
  }

  console.log('\n========================================');
  console.log('COMPARISON SUMMARY');
  console.log('========================================');
  console.log(`Total comparisons: ${comparisons.length}`);
  console.log(`Discrepancies found: ${discrepancies.length}`);

  if (discrepancies.length > 0) {
    console.log('\n⚠️  DISCREPANCIES:');
    discrepancies.forEach(d => {
      console.log(`\n${d.dataset}:`);
      if (d.issues.pooled) console.log(`  - Pooled estimate differs by ${d.differences.pooled.toFixed(6)}`);
      if (d.issues.tau2) console.log(`  - tau² differs by ${d.differences.tau2.toFixed(6)}`);
      if (d.issues.I2) console.log(`  - I² differs by ${d.differences.I2.toFixed(2)}%`);
    });
  } else {
    console.log('\n✓ All validations passed! No significant discrepancies found.');
  }

  return { comparisons, discrepancies };
}

// Export functions to window for console use
window.extractAllResults = extractAllResults;
window.extractDatasetResults = extractDatasetResults;
window.compareWithR = compareWithR;
window.allPairwiseResults = allPairwiseResults;

// Instructions
console.log(`
╔════════════════════════════════════════════════════════════╗
║  PAIRWISE PRO VALIDATION EXTRACTOR                         ║
║  Instructions:                                             ║
║                                                            ║
║  1. Make sure Pairwise Pro HTML is loaded in browser      ║
║  2. Open browser console (F12)                             ║
║  3. Paste this entire script and press Enter               ║
║  4. Run: extractAllResults()                               ║
║  5. Wait for completion (downloads JSON automatically)     ║
║  6. Optionally compare: compareWithR(rResultsObject)       ║
╚════════════════════════════════════════════════════════════╝
`);

console.log('Ready! Run extractAllResults() to begin.');
