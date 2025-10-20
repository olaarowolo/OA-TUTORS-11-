#!/bin/bash

# OA TUTORS - File Organization Script
# Ensures consistent file naming and directory structure
# Website: https://oatutors.co.uk/

echo "🗂️  OA TUTORS - File Organization"
echo "================================="
echo ""

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check and create directory structure
echo -e "${BLUE}📁 Checking Directory Structure${NC}"
echo ""

required_dirs=("MA" "NVR" "VR" "EN" "docs" "templates" "scripts")

for dir in "${required_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo -e "✅ ${GREEN}$dir/${NC} exists"
    else
        echo -e "❌ ${RED}$dir/${NC} missing - creating..."
        mkdir -p "$dir"
        echo -e "✅ ${GREEN}Created $dir/${NC}"
    fi
done

echo ""

# Check for naming convention violations
echo -e "${BLUE}📝 Checking File Naming Conventions${NC}"
echo ""

naming_issues=0

for subject_dir in MA NVR VR EN; do
    if [ -d "$subject_dir" ]; then
        echo "Checking $subject_dir/..."
        
        # Check for files that don't follow naming convention
        for file in "$subject_dir"/*.tex; do
            if [ -f "$file" ]; then
                filename=$(basename "$file")
                
                # Check if it matches expected patterns
                if ! [[ $filename =~ ^(Lesson[0-9][0-9]|StudentNotes_Lesson[0-9][0-9]|Homework_Lesson[0-9][0-9]|Teacher_AnswerKey_Lesson[0-9][0-9]|ExtensionActivity_Lesson[0-9][0-9])_[A-Za-z0-9]+\.tex$ ]]; then
                    echo -e "  ⚠️  ${YELLOW}$filename${NC} - Non-standard naming"
                    naming_issues=$((naming_issues + 1))
                fi
            fi
        done
    fi
done

if [ $naming_issues -eq 0 ]; then
    echo -e "✅ ${GREEN}All files follow naming convention${NC}"
else
    echo -e "⚠️  ${YELLOW}$naming_issues files have naming issues${NC}"
fi

echo ""

# Check for missing core files
echo -e "${BLUE}📋 Checking Core Files${NC}"
echo ""

core_files=("README.md" "docs/FileManagement_System.md")

for file in "${core_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "✅ ${GREEN}$file${NC} exists"
    else
        echo -e "❌ ${RED}$file${NC} missing"
    fi
done

echo ""

# Generate directory summary
echo -e "${BLUE}📊 Directory Summary${NC}"
echo ""

total_tex_files=0
total_other_files=0

for dir in MA NVR VR EN; do
    if [ -d "$dir" ]; then
        tex_count=$(find "$dir" -name "*.tex" -type f | wc -l)
        other_count=$(find "$dir" -type f ! -name "*.tex" | wc -l)
        
        total_tex_files=$((total_tex_files + tex_count))
        total_other_files=$((total_other_files + other_count))
        
        echo -e "$dir/: ${BLUE}$tex_count${NC} .tex files, ${YELLOW}$other_count${NC} other files"
    fi
done

echo ""
echo -e "Total: ${BLUE}$total_tex_files${NC} .tex files, ${YELLOW}$total_other_files${NC} other files"

echo ""

# Check for duplicate files
echo -e "${BLUE}🔍 Checking for Duplicate Files${NC}"
echo ""

duplicates_found=0

for subject_dir in MA NVR VR EN; do
    if [ -d "$subject_dir" ]; then
        # Find potential duplicates (same lesson number, different topics)
        find "$subject_dir" -name "Lesson*.tex" | while read file; do
            lesson_num=$(basename "$file" | grep -o "Lesson[0-9][0-9]")
            if [ ! -z "$lesson_num" ]; then
                count=$(find "$subject_dir" -name "${lesson_num}_*.tex" | wc -l)
                if [ $count -gt 1 ]; then
                    echo -e "⚠️  Multiple files for $lesson_num in $subject_dir"
                    duplicates_found=$((duplicates_found + 1))
                fi
            fi
        done
    fi
done

if [ $duplicates_found -eq 0 ]; then
    echo -e "✅ ${GREEN}No duplicate lesson numbers found${NC}"
fi

echo ""

# Organization recommendations
echo -e "${BLUE}💡 Organization Recommendations${NC}"
echo ""

if [ $naming_issues -gt 0 ]; then
    echo "1. Review files with non-standard naming"
    echo "2. Use templates from /templates/ directory for new files"
fi

echo "3. Run './scripts/check_lesson_completeness.sh' to identify missing files"
echo "4. Consider creating backup directory for old/draft files"
echo "5. Use './scripts/progress_tracker.sh' to monitor development progress"

echo ""
echo "Organization check completed at $(date)"