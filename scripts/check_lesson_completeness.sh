#!/bin/bash

# OA TUTORS - Lesson Completeness Checker
# Checks if all required files exist for each lesson
# Website: https://oatutors.co.uk/

echo "🔍 OA TUTORS - Lesson Completeness Checker"
echo "=========================================="
echo ""

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
total_lessons=0
complete_lessons=0
incomplete_lessons=0

# Function to check lesson completeness
check_lesson_set() {
    local subject_dir=$1
    local lesson_file=$2
    
    # Extract lesson number and topic from filename
    basename=$(basename "$lesson_file" .tex)
    lesson_num=$(echo "$basename" | grep -o "Lesson[0-9][0-9]" | head -1)
    topic=$(echo "$basename" | sed "s/Lesson[0-9][0-9]_//")
    
    if [ -z "$lesson_num" ]; then
        return # Skip files that don't match lesson pattern
    fi
    
    total_lessons=$((total_lessons + 1))
    
    # Define required files
    student_notes="StudentNotes_${lesson_num}_${topic}.tex"
    homework="Homework_${lesson_num}_${topic}.tex"
    answer_key="Teacher_AnswerKey_${lesson_num}_${topic}.tex"
    extension="ExtensionActivity_${lesson_num}_${topic}.tex"
    
    # Check if all required files exist
    missing_files=()
    
    if [ ! -f "$subject_dir/$student_notes" ]; then
        missing_files+=("StudentNotes")
    fi
    
    if [ ! -f "$subject_dir/$homework" ]; then
        missing_files+=("Homework")
    fi
    
    if [ ! -f "$subject_dir/$answer_key" ]; then
        missing_files+=("Teacher_AnswerKey")
    fi
    
    if [ ! -f "$subject_dir/$extension" ]; then
        missing_files+=("ExtensionActivity")
    fi
    
    # Report status
    if [ ${#missing_files[@]} -eq 0 ]; then
        echo -e "✅ ${GREEN}$lesson_num ($topic)${NC} - Complete set (5 files)"
        complete_lessons=$((complete_lessons + 1))
    else
        echo -e "❌ ${RED}$lesson_num ($topic)${NC} - Missing: ${YELLOW}$(IFS=', '; echo "${missing_files[*]}")${NC}"
        incomplete_lessons=$((incomplete_lessons + 1))
    fi
}

# Main execution
echo "Checking lesson completeness across all subjects..."
echo ""

# Check each subject directory
for subject_dir in MA NVR VR EN; do
    if [ -d "$subject_dir" ]; then
        echo -e "${BLUE}📁 $subject_dir/${NC}"
        echo "----------------------------------------"
        
        # Find all lesson files and check them
        for lesson_file in "$subject_dir"/Lesson*.tex; do
            if [ -f "$lesson_file" ]; then
                check_lesson_set "$subject_dir" "$lesson_file"
            fi
        done
        
        echo ""
    else
        echo -e "${YELLOW}⚠️  Directory $subject_dir not found${NC}"
        echo ""
    fi
done

echo "=========================================="
echo -e "${BLUE}📊 SUMMARY STATISTICS${NC}"
echo "Total Lessons Found: $total_lessons"
echo -e "Complete Lesson Sets: ${GREEN}$complete_lessons${NC}"
echo -e "Incomplete Lesson Sets: ${RED}$incomplete_lessons${NC}"

if [ $total_lessons -gt 0 ]; then
    completion_percentage=$((complete_lessons * 100 / total_lessons))
    echo -e "Completion Rate: ${BLUE}${completion_percentage}%${NC}"
fi

echo ""

# Provide recommendations
if [ $incomplete_lessons -gt 0 ]; then
    echo -e "${YELLOW}🔧 RECOMMENDATIONS:${NC}"
    echo "1. Use templates from /templates/ directory"
    echo "2. Follow naming convention: [DocumentType]_Lesson[XX]_[TopicName].tex"
    echo "3. Run this script regularly to track progress"
    echo "4. Complete lesson sets before moving to new topics"
    echo ""
fi

echo "Script completed at $(date)"