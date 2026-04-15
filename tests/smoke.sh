#!/usr/bin/env bash
set -euo pipefail

FAIL=0

echo "=== Smoke Tests: Embryo Selection Journey ==="

# --- 1. Check required files exist ---
echo ""
echo "--- Checking required files ---"

REQUIRED_FILES=(
  "index.html"
  "styles/global.css"
  "modules/01-the-problem.html"
  "modules/02-doodle-segmentation.html"
  "modules/03-bonna-architecture.html"
  "modules/04-performance.html"
  "modules/05-confidence.html"
  "modules/06-production-pipeline.html"
  "modules/07-clinical-integration.html"
)

for f in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo "FAIL: Missing required file: $f"
    FAIL=1
  else
    echo "OK:   $f"
  fi
done

# --- 2. Check key assets ---
echo ""
echo "--- Checking key assets ---"

REQUIRED_ASSETS=(
  "assets/embryo-timelapse.gif"
  "assets/doodle-segmentation.gif"
  "assets/auc-comparison-chart.png"
  "assets/roc-curve-vs-embryologists.png"
  "assets/rhea-dashboard.png"
  "assets/oocyte-quality-ui.png"
)

for f in "${REQUIRED_ASSETS[@]}"; do
  if [ ! -f "$f" ]; then
    echo "FAIL: Missing asset: $f"
    FAIL=1
  else
    echo "OK:   $f"
  fi
done

# --- 3. Validate HTML structure of index.html ---
echo ""
echo "--- Validating index.html structure ---"

if ! head -1 index.html | grep -qi '<!DOCTYPE html>'; then
  echo "FAIL: index.html missing <!DOCTYPE html>"
  FAIL=1
else
  echo "OK:   DOCTYPE present"
fi

if ! grep -q '</html>' index.html; then
  echo "FAIL: index.html missing closing </html>"
  FAIL=1
else
  echo "OK:   Closing </html> present"
fi

if ! grep -q 'styles/global.css' index.html; then
  echo "FAIL: index.html does not reference styles/global.css"
  FAIL=1
else
  echo "OK:   Stylesheet reference present"
fi

# --- 4. Check modules reference ../styles/global.css ---
echo ""
echo "--- Checking module stylesheet references ---"

for f in modules/*.html; do
  if ! grep -q '\.\./styles/global\.css' "$f"; then
    echo "FAIL: $f does not reference ../styles/global.css"
    FAIL=1
  else
    echo "OK:   $f references ../styles/global.css"
  fi
done

# --- 5. Verify this script references all 7 modules ---
echo ""
echo "--- Verifying all 7 modules are tested ---"

MODULE_COUNT=$(echo "${REQUIRED_FILES[@]}" | tr ' ' '\n' | grep -c '^modules/')
if [ "$MODULE_COUNT" -ne 7 ]; then
  echo "FAIL: Expected 7 modules in check list, found $MODULE_COUNT"
  FAIL=1
else
  echo "OK:   All 7 modules referenced in smoke tests"
fi

# --- Summary ---
echo ""
if [ $FAIL -ne 0 ]; then
  echo "SMOKE TESTS FAILED"
  exit 1
else
  echo "ALL SMOKE TESTS PASSED"
  exit 0
fi
