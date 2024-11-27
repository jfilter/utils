#!/bin/bash
# scripts/px-to-rem.sh

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if path parameter is provided
if [ $# -ne 1 ]; then
    echo -e "${RED}Error: Please provide a path to the folder${NC}"
    echo "Usage: $0 <folder_path>"
    exit 1
fi

FOLDER_PATH="$1"

# Validate path exists and is a directory
if [ ! -d "$FOLDER_PATH" ]; then
    echo -e "${RED}Error: '$FOLDER_PATH' is not a valid directory${NC}"
    exit 1
fi

px_to_rem() {
    local px=$1
    # Remove any non-numeric characters, but keep minus sign
    px=$(echo "$px" | tr -cd '-0-9.')
    echo "$px" | awk '{printf "%.4frem", $1/16}'
}

echo "Starting px to rem conversion in $FOLDER_PATH..."

# Find all relevant files
find "$FOLDER_PATH" -type f \( -name "*.tsx" -o -name "*.jsx" -o -name "*.css" -o -name "*.scss" \) | while read -r file; do
    if [ -f "$file" ]; then
        echo "Processing: $file"
        cp "$file" "${file}.bak"

        # Handle px values inside calc()
        perl -pe 's/calc\((.*?)([-]?\d+(?:\.\d+)?)px(.*?)\)/sprintf("calc(%s%.4frem%s)", $1, $2\/16, $3)/ge' "$file" >"${file}.tmp"

        # Handle bracketed px values with calc()
        perl -pe 's/\[calc\((.*?)([-]?\d+(?:\.\d+)?)px(.*?)\)\]/sprintf("[calc(%s%.4frem%s)]", $1, $2\/16, $3)/ge' "${file}.tmp" >"${file}.tmp2"

        # Handle regular bracketed px values
        perl -pe 's/\[([-]?\d+(?:\.\d+)?)px\]/sprintf("[%.4frem]", $1\/16)/ge' "${file}.tmp2" >"${file}.tmp3"

        # Handle regular px values
        sed -E 's/([0-9]+(\.[0-9]+)?)px/'"$(px_to_rem '\1')"'/g' "${file}.tmp3" >"$file"

        rm "${file}.tmp" "${file}.tmp2" "${file}.tmp3"

        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Transformed${NC}: $file"
            rm "${file}.bak"
        else
            echo -e "${RED}✗ Failed${NC}: $file"
            mv "${file}.bak" "$file"
        fi
    fi
done

echo "Conversion complete!"
