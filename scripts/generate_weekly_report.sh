#!/bin/bash

# Student Progress Tracking - Weekly Report Generator
# OA Tutors 11+ Preparation System

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TRACKING_DIR="$PROJECT_ROOT/student_tracking"
REPORTS_DIR="$TRACKING_DIR/weekly_reports"
PROGRESS_DIR="$TRACKING_DIR/progress_logs"
PROFILES_DIR="$TRACKING_DIR/profiles"
TASKS_DIR="$TRACKING_DIR/task_assignments"

# Function to display header
show_header() {
    echo -e "${BLUE}==================================${NC}"
    echo -e "${BLUE}   OA TUTORS - Report Generator${NC}"
    echo -e "${BLUE}      Weekly Progress Reports${NC}"
    echo -e "${BLUE}==================================${NC}"
    echo
}

# Function to get report parameters
get_report_info() {
    if [ -n "$1" ]; then
        STUDENT_NAME="$1"
    else
        echo -e "${YELLOW}Enter student's name:${NC}"
        read -p "> " STUDENT_NAME
    fi
    
    if [ -n "$2" ]; then
        WEEK_NUMBER="$2"
    else
        # Calculate current week number
        WEEK_NUMBER=$(date +%U)
        echo -e "${YELLOW}Enter week number (current week: $WEEK_NUMBER):${NC}"
        read -p "> " input_week
        if [ -n "$input_week" ]; then
            WEEK_NUMBER="$input_week"
        fi
    fi
    
    # Get year
    YEAR=$(date +%Y)
    if [ -n "$3" ]; then
        YEAR="$3"
    fi
    
    # Convert to lowercase for filename
    STUDENT_LOWERCASE=$(echo "$STUDENT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
    REPORT_FILE="$REPORTS_DIR/${STUDENT_LOWERCASE}_week_${WEEK_NUMBER}_${YEAR}.md"
    PROFILE_FILE="$PROFILES_DIR/${STUDENT_LOWERCASE}_profile.md"
    TASK_FILE="$TASKS_DIR/${STUDENT_LOWERCASE}_tasks.md"
}

# Function to ensure directories exist
ensure_directories() {
    if [ ! -d "$REPORTS_DIR" ]; then
        mkdir -p "$REPORTS_DIR"
        echo -e "${GREEN}📁 Created weekly reports directory${NC}"
    fi
}

# Function to check if student exists
check_student_exists() {
    if [ ! -f "$PROFILE_FILE" ]; then
        echo -e "${RED}❌ Error: No profile found for $STUDENT_NAME${NC}"
        echo -e "Expected profile: $PROFILE_FILE"
        echo -e "${YELLOW}💡 Create a profile first using:${NC}"
        echo -e "   ./scripts/create_student_profile.sh \"$STUDENT_NAME\""
        exit 1
    fi
}

# Function to get week date range
get_week_dates() {
    # Calculate the start of the week (Monday) for the given week number
    local year="$1"
    local week="$2"
    
    # Get the first day of the year
    local first_day=$(date -j -f "%Y-%m-%d" "$year-01-01" +"%u" 2>/dev/null || date -d "$year-01-01" +"%u" 2>/dev/null || echo "1")
    
    # Calculate days to add to get to the Monday of the specified week
    local days_to_add=$(( (week - 1) * 7 - first_day + 1 ))
    
    # Get Monday and Friday of the week (simplified approach)
    if command -v gdate >/dev/null 2>&1; then
        # Use GNU date if available (installed via brew install coreutils)
        WEEK_START=$(gdate -d "$year-01-01 +$days_to_add days" +"%Y-%m-%d" 2>/dev/null)
        WEEK_END=$(gdate -d "$WEEK_START +4 days" +"%Y-%m-%d" 2>/dev/null)
    else
        # Fallback for macOS date
        WEEK_START=$(date -j -v+"${days_to_add}d" -f "%Y-%m-%d" "$year-01-01" +"%Y-%m-%d" 2>/dev/null || echo "$(date +%Y-%m-%d)")
        WEEK_END=$(date -j -v+4d -f "%Y-%m-%d" "$WEEK_START" +"%Y-%m-%d" 2>/dev/null || echo "$(date +%Y-%m-%d)")
    fi
    
    # Format for display
    WEEK_START_DISPLAY=$(date -j -f "%Y-%m-%d" "$WEEK_START" +"%B %d" 2>/dev/null || echo "$WEEK_START")
    WEEK_END_DISPLAY=$(date -j -f "%Y-%m-%d" "$WEEK_END" +"%B %d, %Y" 2>/dev/null || echo "$WEEK_END")
}

# Function to collect progress logs for the week
collect_week_logs() {
    echo -e "${BLUE}📊 Collecting progress logs for week $WEEK_NUMBER...${NC}"
    
    # Find all progress logs for the student in the date range
    WEEK_LOGS=()
    for log_file in "$PROGRESS_DIR"/${STUDENT_LOWERCASE}_*.md; do
        if [ -f "$log_file" ]; then
            # Extract date from filename
            local log_date=$(basename "$log_file" | grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}')
            if [ -n "$log_date" ]; then
                # Check if date falls within the week (simplified check)
                WEEK_LOGS+=("$log_file")
            fi
        fi
    done
    
    echo -e "${GREEN}Found ${#WEEK_LOGS[@]} progress logs${NC}"
}

# Function to extract key information from profile
extract_profile_info() {
    if [ -f "$PROFILE_FILE" ]; then
        CURRENT_LEVEL=$(grep -A 1 "Overall Level:" "$PROFILE_FILE" | tail -1 | sed 's/.*: //' || echo "[Not assessed]")
        TARGET_SCHOOLS=$(grep "Target Schools:" "$PROFILE_FILE" | sed 's/.*: //' || echo "[Not specified]")
        SESSION_FREQUENCY=$(grep -A 10 "Schedule Information" "$PROFILE_FILE" | grep "Frequency:" | sed 's/.*: //' || echo "Weekly")
    else
        CURRENT_LEVEL="[Profile not found]"
        TARGET_SCHOOLS="[Profile not found]"
        SESSION_FREQUENCY="[Profile not found]"
    fi
}

# Function to extract current tasks
extract_current_tasks() {
    CURRENT_TASKS=""
    COMPLETED_TASKS=""
    OVERDUE_TASKS=""
    
    if [ -f "$TASK_FILE" ]; then
        # Extract current tasks
        CURRENT_TASKS=$(awk '/^## Current Tasks/,/^## /{if(/^###/) print "- " $0}' "$TASK_FILE" | head -10 || echo "- No current tasks")
        
        # Extract completed tasks  
        COMPLETED_TASKS=$(awk '/^## Completed Tasks/,/^## /{if(/^###/) print "- " $0}' "$TASK_FILE" | head -5 || echo "- No completed tasks this week")
        
        # Extract overdue tasks
        OVERDUE_TASKS=$(awk '/^## Overdue Tasks/,/^## /{if(/^###/) print "- " $0}' "$TASK_FILE" | head -5 || echo "- No overdue tasks")
    else
        CURRENT_TASKS="- No task tracking file found"
        COMPLETED_TASKS="- No task tracking file found"
        OVERDUE_TASKS="- No overdue tasks"
    fi
}

# Function to calculate lesson completion stats
calculate_lesson_stats() {
    # This would ideally scan the curriculum files to determine completion
    # For now, provide placeholders that can be manually updated
    
    MA_LESSONS_COMPLETED="[To be updated - check MA folder]"
    MA_TOTAL_LESSONS="46"
    MA_COMPLETION_PERCENT="[Calculate: completed/total * 100]"
    
    NVR_LESSONS_COMPLETED="[To be updated - check NVR folder]"
    NVR_TOTAL_LESSONS="18"
    NVR_COMPLETION_PERCENT="[Calculate: completed/total * 100]"
    
    VR_LESSONS_COMPLETED="[To be updated - check VR folder]"
    VR_TOTAL_LESSONS="42"
    VR_COMPLETION_PERCENT="[Calculate: completed/total * 100]"
    
    EN_LESSONS_COMPLETED="[To be updated - check EN folder]"
    EN_TOTAL_LESSONS="44"
    EN_COMPLETION_PERCENT="[Calculate: completed/total * 100]"
}

# Function to generate report
generate_report() {
    echo -e "${BLUE}📄 Generating weekly report...${NC}"
    
    # Get week dates
    get_week_dates "$YEAR" "$WEEK_NUMBER"
    
    # Collect information
    collect_week_logs
    extract_profile_info
    extract_current_tasks
    calculate_lesson_stats
    
    # Generate the report
    cat > "$REPORT_FILE" << EOF
# Weekly Progress Report: $STUDENT_NAME
## Week $WEEK_NUMBER | $WEEK_START_DISPLAY - $WEEK_END_DISPLAY

---

### 📊 **Executive Summary**

**Student:** $STUDENT_NAME  
**Report Period:** Week $WEEK_NUMBER ($WEEK_START_DISPLAY - $WEEK_END_DISPLAY)  
**Current Level:** $CURRENT_LEVEL  
**Target Schools:** $TARGET_SCHOOLS  
**Session Frequency:** $SESSION_FREQUENCY

**Overall Assessment:** [Tutor to complete - Excellent/Good/Satisfactory/Needs Attention]

---

### 🎯 **Learning Objectives Status**

#### Mathematics
- **Current Unit:** [Unit name and lesson number]
- **Lessons Completed This Week:** [Number of lessons]
- **Total Progress:** $MA_LESSONS_COMPLETED/$MA_TOTAL_LESSONS lessons ($MA_COMPLETION_PERCENT%)
- **Key Topics Covered:**
  - [Topic 1]
  - [Topic 2]
  - [Topic 3]
- **Assessment Scores:** [List recent scores]
- **Next Week Focus:** [Upcoming topics]

#### Non-Verbal Reasoning (NVR)
- **Current Unit:** [Unit name and lesson number]
- **Lessons Completed This Week:** [Number of lessons]
- **Total Progress:** $NVR_LESSONS_COMPLETED/$NVR_TOTAL_LESSONS lessons ($NVR_COMPLETION_PERCENT%)
- **Key Topics Covered:**
  - [Topic 1]
  - [Topic 2]
- **Assessment Scores:** [List recent scores]
- **Next Week Focus:** [Upcoming topics]

#### Verbal Reasoning (VR)
- **Current Unit:** [Unit name and lesson number]
- **Lessons Completed This Week:** [Number of lessons]
- **Total Progress:** $VR_LESSONS_COMPLETED/$VR_TOTAL_LESSONS lessons ($VR_COMPLETION_PERCENT%)
- **Key Topics Covered:**
  - [Topic 1]
  - [Topic 2]
- **Assessment Scores:** [List recent scores]
- **Next Week Focus:** [Upcoming topics]

#### English
- **Current Unit:** [Unit name and lesson number]
- **Lessons Completed This Week:** [Number of lessons]
- **Total Progress:** $EN_LESSONS_COMPLETED/$EN_TOTAL_LESSONS lessons ($EN_COMPLETION_PERCENT%)
- **Key Topics Covered:**
  - [Topic 1]
  - [Topic 2]
- **Assessment Scores:** [List recent scores]
- **Next Week Focus:** [Upcoming topics]

---

### 📈 **Performance Analysis**

#### Strengths Demonstrated This Week
- [Strength 1 - specific examples]
- [Strength 2 - specific examples]  
- [Strength 3 - specific examples]

#### Areas Requiring Additional Support
- [Area 1 - with specific action plan]
- [Area 2 - with specific action plan]
- [Area 3 - with specific action plan]

#### Learning Behaviors Observed
- **Engagement Level:** [High/Medium/Low] - [Specific observations]
- **Concentration:** [Excellent/Good/Fair/Needs Work] - [Notes]
- **Question Asking:** [Frequency and quality of questions]
- **Independence:** [Level of self-directed learning]
- **Confidence:** [Changes in confidence levels]

---

### ✅ **Task Completion Status**

#### Tasks Completed This Week
$COMPLETED_TASKS

#### Current Ongoing Tasks
$CURRENT_TASKS

#### Overdue Items Requiring Attention
$OVERDUE_TASKS

#### Task Completion Rate
**This Week:** [X out of Y tasks completed] ([percentage]%)  
**Overall Trend:** [Improving/Consistent/Needs Support]

---

### 🎯 **Goals and Targets Review**

#### Short-term Goals (This Month)
- **Goal 1:** [Status: On Track/Behind/Ahead]
- **Goal 2:** [Status: On Track/Behind/Ahead]
- **Goal 3:** [Status: On Track/Behind/Ahead]

#### Medium-term Goals (Next 3 Months)
- **Mathematics:** [Progress toward goal]
- **NVR:** [Progress toward goal]
- **VR:** [Progress toward goal]
- **English:** [Progress toward goal]

#### Adjustments to Goals
[Any modifications to goals based on this week's progress]

---

### 📚 **Curriculum Progress**

#### Weekly Lesson Summary
| Subject | Lessons This Week | Topics Covered | Assessment Avg | Notes |
|---------|-------------------|----------------|----------------|--------|
| Mathematics | [#] | [Topics] | [%] | [Notes] |
| NVR | [#] | [Topics] | [%] | [Notes] |
| VR | [#] | [Topics] | [%] | [Notes] |
| English | [#] | [Topics] | [%] | [Notes] |

#### Overall Curriculum Completion
```
Progress Bar: [■■■□□□□□□□] [XX]% Complete

Mathematics:  [■■■■□□□□□□] [XX]% ($MA_LESSONS_COMPLETED/$MA_TOTAL_LESSONS)
NVR:         [■■□□□□□□□□] [XX]% ($NVR_LESSONS_COMPLETED/$NVR_TOTAL_LESSONS)
VR:          [□□□□□□□□□□] [XX]% ($VR_LESSONS_COMPLETED/$VR_TOTAL_LESSONS)
English:     [□□□□□□□□□□] [XX]% ($EN_LESSONS_COMPLETED/$EN_TOTAL_LESSONS)
```

---

### 🏆 **Achievements and Milestones**

#### This Week's Achievements
- [Achievement 1 - specific accomplishment]
- [Achievement 2 - breakthrough moment]
- [Achievement 3 - skill mastery]

#### Skills Developed
- [New skill 1]
- [New skill 2]
- [Improved skill 3]

#### Confidence Builders
- [Moment that built confidence]
- [Success that motivated student]
- [Positive feedback received]

---

### 📋 **Assignments for Next Week**

#### Mathematics
- [ ] **Homework:** [Specific assignment]
  - **Due:** [Date]
  - **Estimated Time:** [Duration]
- [ ] **Practice:** [Additional practice work]
  - **Due:** [Date]

#### NVR
- [ ] **Practice Set:** [Specific exercises]
  - **Due:** [Date]
  - **Focus:** [Skill being developed]

#### VR  
- [ ] **Vocabulary:** [Word list or exercise]
  - **Due:** [Date]
- [ ] **Logic Practice:** [Specific problems]
  - **Due:** [Date]

#### English
- [ ] **Reading:** [Book/chapter assignment]
  - **Due:** [Date]
- [ ] **Writing:** [Essay or exercise]
  - **Due:** [Date]

#### General Study
- [ ] **Review:** [Topics to review]
- [ ] **Practice Exam:** [If scheduled]
- [ ] **Research:** [If applicable]

---

### 👨‍👩‍👧‍👦 **Parent Communication Summary**

#### Key Points to Discuss with Parents
1. [Important development or concern]
2. [Academic progress highlight]
3. [Recommendation for home support]
4. [Schedule or approach adjustments]

#### Home Study Recommendations
- **Daily Practice:** [Specific recommendations]
- **Reading Schedule:** [Suggested routine]
- **Review Schedule:** [How to reinforce learning]
- **Environment:** [Study space suggestions]

#### Support Strategies for Parents
- [Specific way parents can help]
- [Resources parents can provide]
- [Encouragement techniques]

---

### 🔍 **Detailed Session Notes**

#### Session Summaries
$(
if [ ${#WEEK_LOGS[@]} -gt 0 ]; then
    for log_file in "${WEEK_LOGS[@]}"; do
        echo "##### Session: $(basename "$log_file" | grep -o '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}')"
        echo "- **Duration:** [Extract from log]"
        echo "- **Topics:** [Extract key topics]"  
        echo "- **Observations:** [Extract key observations]"
        echo "- **Homework Set:** [Extract assignments]"
        echo ""
    done
else
    echo "No detailed session logs found for this week."
    echo "Recommendation: Use ./scripts/log_student_progress.sh to track daily progress."
fi
)

---

### 📊 **Assessment Data**

#### Weekly Assessment Summary
| Date | Subject | Topic | Score | Level | Trend | Notes |
|------|---------|-------|-------|--------|--------|-------|
| [Date] | [Subject] | [Topic] | [%] | [Level] | [↑/↓/→] | [Notes] |

#### Performance Trends
- **Mathematics:** [Trend analysis]
- **NVR:** [Trend analysis]  
- **VR:** [Trend analysis]
- **English:** [Trend analysis]

#### Areas for Immediate Focus
1. **Priority 1:** [Most important area needing attention]
2. **Priority 2:** [Second priority area]
3. **Priority 3:** [Third priority area]

---

### 🎯 **Next Week Planning**

#### Learning Objectives for Week $(($WEEK_NUMBER + 1))
- **Mathematics:** [Specific objectives]
- **NVR:** [Specific objectives]
- **VR:** [Specific objectives]
- **English:** [Specific objectives]

#### Session Schedule
- **Date:** [Next session date]
- **Duration:** [Session length]
- **Special Focus:** [Any particular emphasis]
- **Materials Needed:** [Preparation required]

#### Preparation Required
- [ ] **Materials:** [Specific materials to prepare]
- [ ] **Assessment:** [Any assessments to prepare]
- [ ] **Resources:** [Additional resources needed]
- [ ] **Communication:** [Parent updates required]

---

### 💡 **Tutor Recommendations**

#### Academic Recommendations
1. [Specific academic recommendation]
2. [Learning strategy suggestion]
3. [Skill development focus]

#### Study Habit Recommendations
1. [Study routine suggestion]
2. [Time management advice]
3. [Motivation strategy]

#### Long-term Development
1. [Strategic development area]
2. [Skill building priority]
3. [Confidence building approach]

---

### 🔄 **System Notes**

#### Progress Tracking
- **Newsletter Generated:** [Y/N]
- **Parent Communication:** [Date and method]
- **Profile Updated:** [Y/N - date if updated]
- **Task File Updated:** [Y/N - date if updated]

#### Follow-up Required
- [ ] **Parent Meeting:** [If needed]
- [ ] **Additional Assessment:** [If recommended]
- [ ] **Resource Acquisition:** [If materials needed]
- [ ] **Schedule Adjustment:** [If timing needs changing]

---

**Report Generated:** $(date +"%B %d, %Y at %H:%M")  
**Next Report Due:** $(date -v+1w +"%B %d, %Y" 2>/dev/null || date -d "+1 week" +"%B %d, %Y")  
**Tutor:** [Tutor Name]  
**System Version:** 1.0

---

*This report integrates data from student profile, progress logs, task assignments, and curriculum tracking. For detailed daily notes, refer to individual progress log files.*
EOF

    echo -e "${GREEN}✅ Weekly report generated successfully!${NC}"
    echo -e "📄 File: $REPORT_FILE"
}

# Function to show summary and options
show_report_summary() {
    echo
    echo -e "${BLUE}📊 Weekly Report Summary${NC}"
    echo -e "Student: $STUDENT_NAME"
    echo -e "Week: $WEEK_NUMBER ($YEAR)"
    echo -e "Period: $WEEK_START_DISPLAY - $WEEK_END_DISPLAY"
    echo -e "Report File: $REPORT_FILE"
    echo
    echo -e "${BLUE}🔧 Next Steps:${NC}"
    echo -e "1. ${YELLOW}Review and complete the report sections marked [To be updated]${NC}"
    echo -e "2. ${YELLOW}Add specific scores and observations${NC}"  
    echo -e "3. ${YELLOW}Generate newsletter from this report${NC}"
    echo -e "4. ${YELLOW}Share with parents if appropriate${NC}"
    echo
    echo -e "${BLUE}🎯 Quick Commands:${NC}"
    echo -e "   Edit Report: ${GREEN}\${EDITOR:-nano} '$REPORT_FILE'${NC}"
    echo -e "   View Report: ${GREEN}cat '$REPORT_FILE'${NC}"
    echo -e "   Generate Newsletter: ${GREEN}./scripts/generate_newsletter.sh '$STUDENT_NAME' $WEEK_NUMBER${NC}"
    echo
}

# Main function
main() {
    show_header
    
    # Get report parameters
    get_report_info "$1" "$2" "$3"
    
    # Ensure directories
    ensure_directories
    
    # Check if student exists
    check_student_exists
    
    # Generate the report
    generate_report
    
    # Show summary
    show_report_summary
}

# Run main function
main "$@"