set -o errexit

# Generate reference information
echo "Retrieving and processing reference metadata"
(cd build && python references.py)

# pandoc settings
CSL_PATH=references/nonequilibrium.csl
BIBLIOGRAPHY_PATH=references/generated/bibliography.json
INPUT_PATH=references/generated/all-sections.md

# Make output directory
mkdir -p output

# Create HTML outpout
# http://pandoc.org/MANUAL.html
echo "Exporting HTML manuscript"
pandoc --verbose \
  --from=markdown --to=html5 \
  --filter pandoc-fignos \
  --bibliography=$BIBLIOGRAPHY_PATH \
  --metadata link-citations=true \
  --css=github-pandoc.css \
  --katex \
  --output=output/index.html \
  $INPUT_PATH

# Create PDF outpout
echo "Exporting PDF manuscript"
pandoc --verbose \
  --from=markdown --to=html5 \
  --filter pandoc-fignos \
  --bibliography=$BIBLIOGRAPHY_PATH \
  --csl=$CSL_PATH \
  --metadata link-citations=true \
  --css=github-pandoc.css \
  --katex \
  --output=output/nonequilibrium-literature-review.pdf \
  $INPUT_PATH

# Move images to output directory
echo "Copying images"
cp -R sections/images output/images