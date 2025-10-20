#!/bin/bash

# OA TUTORS - Progress Tracker
# Tracks curriculum development progress against syllabus goals
# Website: https://oatutors.co.uk/

echo "📈 OA TUTORS - Curriculum Progress Tracker"
echo "=========================================="
echo ""

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Define expected lesson counts per subject (from updated syllabi)
get_expected_lessons() {
    case $1 in
        "MA") echo 46 ;;
        "NVR") echo 18 ;;
        "VR") echo 47 ;;
        "EN") echo 39 ;;
        *) echo 0 ;;
    esac
}

total_expected=150

# Function to count complete lesson sets
count_complete_lessons() {
    local subject_dir=$1
    local count=0
    
    if [ -d "$subject_dir" ]; then
        for lesson_file in "$subject_dir"/Lesson*.tex; do
            if [ -f "$lesson_file" ]; then
                basename=$(basename "$lesson_file" .tex)
                lesson_num=$(echo "$basename" | grep -o "Lesson[0-9][0-9]" | head -1)
                topic=$(echo "$basename" | sed "s/Lesson[0-9][0-9]_//")
                
                if [ ! -z "$lesson_num" ]; then
                    # Check if all required files exist
                    student_notes="StudentNotes_${lesson_num}_${topic}.tex"
                    homework="Homework_${lesson_num}_${topic}.tex"
                    answer_key="Teacher_AnswerKey_${lesson_num}_${topic}.tex"
                    extension="ExtensionActivity_${lesson_num}_${topic}.tex"
                    
                    if [ -f "$subject_dir/$student_notes" ] && \
                       [ -f "$subject_dir/$homework" ] && \
                       [ -f "$subject_dir/$answer_key" ] && \
                       [ -f "$subject_dir/$extension" ]; then
                        count=$((count + 1))
                    fi
                fi
            fi
        done
    fi
    
    echo $count
}

# Function to create progress bar
create_progress_bar() {
    local current=$1
    local total=$2
    local width=30
    local percentage=0
    
    if [ $total -gt 0 ]; then
        percentage=$((current * 100 / total))
    fi
    
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] %3d%% (%d/%d)" $percentage $current $total
}

echo -e "${BLUE}📊 CURRICULUM DEVELOPMENT PROGRESS${NC}"
echo ""

# Track progress for each subject
total_complete=0

for subject in MA NVR VR EN; do
    expected=$(get_expected_lessons "$subject")
    complete=$(count_complete_lessons "$subject")
    total_complete=$((total_complete + complete))
    
    case $subject in
        "MA") subject_name="Mathematics" ;;
        "NVR") subject_name="Non-Verbal Reasoning" ;;
        "VR") subject_name="Verbal Reasoning" ;;
        "EN") subject_name="English" ;;
    esac
    
    echo -e "${PURPLE}$subject_name ($subject/)${NC}"
    echo -n "  Progress: "
    create_progress_bar $complete $expected
    echo ""
    
    # Show status color
    if [ $complete -eq $expected ]; then
        echo -e "  Status: ${GREEN}✅ Complete${NC}"
    elif [ $complete -gt 0 ]; then
        echo -e "  Status: ${YELLOW}🔄 In Progress${NC}"
    else
        echo -e "  Status: ${RED}❌ Not Started${NC}"
    fi
    
    echo ""
done

echo "=========================================="
echo -e "${BLUE}🎯 OVERALL PROGRESS${NC}"
echo ""
echo -n "Total Curriculum: "
create_progress_bar $total_complete $total_expected
echo ""

# Calculate milestones
milestone_25=$((total_expected / 4))
milestone_50=$((total_expected / 2))
milestone_75=$((total_expected * 3 / 4))

echo ""
echo -e "${BLUE}🏆 MILESTONES${NC}"
if [ $total_complete -ge $milestone_75 ]; then
    echo -e "✅ ${GREEN}75% Complete${NC} - Nearly finished!"
elif [ $total_complete -ge $milestone_50 ]; then
    echo -e "✅ ${GREEN}50% Complete${NC} - Halfway there!"
    echo -e "🎯 ${YELLOW}Next: 75% Complete${NC} ($milestone_75 lessons)"
elif [ $total_complete -ge $milestone_25 ]; then
    echo -e "✅ ${GREEN}25% Complete${NC} - Good start!"
    echo -e "🎯 ${YELLOW}Next: 50% Complete${NC} ($milestone_50 lessons)"
else
    echo -e "🎯 ${YELLOW}First Goal: 25% Complete${NC} ($milestone_25 lessons)"
fi

echo ""
echo -e "${BLUE}📅 DEVELOPMENT RECOMMENDATIONS${NC}"

# Provide next steps based on current progress
if [ $total_complete -lt 10 ]; then
    echo "Priority: Focus on template usage and establish workflow"
    echo "Suggested: Complete MA Numbers unit (Lessons 01-12)"
elif [ $total_complete -lt 25 ]; then
    echo "Priority: Complete one full subject area"
    echo "Suggested: Continue with MA or start NVR development"
elif [ $total_complete -lt 50 ]; then
    echo "Priority: Expand to multiple subjects"
    echo "Suggested: Balance development across MA, NVR, VR"
else
    echo "Priority: Complete remaining gaps"
    echo "Suggested: Focus on EN development and quality assurance"
fi

echo ""

# Show most and least developed subjects
most_complete_subject=""
most_complete_count=0
least_complete_subject=""
least_complete_count=999

for subject in MA NVR VR EN; do
    complete=$(count_complete_lessons "$subject")
    expected=$(get_expected_lessons "$subject")
    
    if [ $complete -gt $most_complete_count ]; then
        most_complete_count=$complete
        most_complete_subject=$subject
    fi
    
    if [ $complete -lt $least_complete_count ]; then
        least_complete_count=$complete
        least_complete_subject=$subject
    fi
done

if [ $most_complete_count -gt 0 ]; then
    echo -e "🏅 Most Advanced: ${GREEN}$most_complete_subject${NC} ($most_complete_count lessons)"
fi

expected_least=$(get_expected_lessons "$least_complete_subject")
if [ $least_complete_count -lt $expected_least ]; then
    echo -e "⚠️  Needs Attention: ${RED}$least_complete_subject${NC} ($least_complete_count lessons)"
fi

echo ""
echo "Last updated: $(date)"
echo "Run './check_lesson_completeness.sh' for detailed file analysis"