#!/bin/bash

# Student Progress Tracking - Daily Progress Logger
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
PROGRESS_DIR="$TRACKING_DIR/progress_logs"
PROFILES_DIR="$TRACKING_DIR/profiles"

# Function to display header
show_header() {
    echo -e "${BLUE}==================================${NC}"
    echo -e "${BLUE}   OA TUTORS - Progress Logger${NC}"
    echo -e "${BLUE}      Daily Session Tracking${NC}"
    echo -e "${BLUE}==================================${NC}"
    echo
}

# Function to get student name and date
get_session_info() {
    if [ -n "$1" ]; then
        STUDENT_NAME="$1"
    else
        echo -e "${YELLOW}Enter student's first name:${NC}"
        read -p "> " STUDENT_NAME
    fi
    
    if [ -n "$2" ]; then
        SESSION_DATE="$2"
    else
        echo -e "${YELLOW}Enter session date (YYYY-MM-DD) or press Enter for today:${NC}"
        read -p "> " SESSION_DATE
        if [ -z "$SESSION_DATE" ]; then
            SESSION_DATE=$(date +"%Y-%m-%d")
        fi
    fi
    
    # Convert to lowercase for filename
    STUDENT_LOWERCASE=$(echo "$STUDENT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
    LOG_FILE="$PROGRESS_DIR/${STUDENT_LOWERCASE}_${SESSION_DATE}.md"
    PROFILE_FILE="$PROFILES_DIR/${STUDENT_LOWERCASE}_profile.md"
}

# Function to check if student profile exists
check_profile_exists() {
    if [ ! -f "$PROFILE_FILE" ]; then
        echo -e "${RED}❌ Error: No profile found for $STUDENT_NAME${NC}"
        echo -e "Expected profile: $PROFILE_FILE"
        echo -e "${YELLOW}💡 Create a profile first using:${NC}"
        echo -e "   ./scripts/create_student_profile.sh \"$STUDENT_NAME\""
        echo
        read -p "Would you like to create the profile now? (y/n): " create_profile
        if [ "$create_profile" = "y" ] || [ "$create_profile" = "Y" ]; then
            ./scripts/create_student_profile.sh "$STUDENT_NAME"
            exit 0
        else
            exit 1
        fi
    fi
}

# Function to check if log already exists
check_existing_log() {
    if [ -f "$LOG_FILE" ]; then
        echo -e "${YELLOW}📝 Progress log already exists for $STUDENT_NAME on $SESSION_DATE${NC}"
        echo -e "File: $LOG_FILE"
        echo
        echo -e "${YELLOW}Choose an option:${NC}"
        echo "1. View existing log"
        echo "2. Edit existing log"
        echo "3. Append to existing log"
        echo "4. Create new version"
        echo "5. Cancel"
        echo
        read -p "Enter choice (1-5): " choice
        
        case $choice in
            1) 
                echo -e "${GREEN}📄 Viewing existing log...${NC}"
                cat "$LOG_FILE"
                exit 0
                ;;
            2)
                echo -e "${YELLOW}📝 Opening log for editing...${NC}"
                ${EDITOR:-nano} "$LOG_FILE"
                exit 0
                ;;
            3)
                APPEND_MODE=true
                ;;
            4)
                TIMESTAMP=$(date +"%H%M%S")
                LOG_FILE="$PROGRESS_DIR/${STUDENT_LOWERCASE}_${SESSION_DATE}_${TIMESTAMP}.md"
                echo -e "${GREEN}📄 Creating new version: ${LOG_FILE}${NC}"
                ;;
            5)
                echo -e "${RED}❌ Cancelled${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Invalid choice. Exiting.${NC}"
                exit 1
                ;;
        esac
    fi
}

# Function to gather session information
gather_session_info() {
    echo -e "${BLUE}📋 Session Information${NC}"
    echo -e "${YELLOW}Enter session details:${NC}"
    
    # Session basics
    read -p "Session start time (e.g., 10:00 AM): " START_TIME
    read -p "Session end time (e.g., 12:00 PM): " END_TIME
    read -p "Session duration (e.g., 2 hours): " DURATION
    
    echo
    echo -e "${YELLOW}Session type:${NC}"
    echo "1. Regular Lesson"
    echo "2. Assessment"
    echo "3. Review Session"
    echo "4. Mock Exam"
    echo "5. Makeup Session"
    read -p "Select session type (1-5): " session_type
    
    case $session_type in
        1) SESSION_TYPE="Regular Lesson" ;;
        2) SESSION_TYPE="Assessment" ;;
        3) SESSION_TYPE="Review Session" ;;
        4) SESSION_TYPE="Mock Exam" ;;
        5) SESSION_TYPE="Makeup Session" ;;
        *) SESSION_TYPE="Regular Lesson" ;;
    esac
    
    read -p "Tutor name: " TUTOR_NAME
}

# Function to gather subject activities
gather_subject_activities() {
    echo -e "${BLUE}📚 Subject Activities${NC}"
    
    # Mathematics
    echo -e "${YELLOW}Mathematics:${NC}"
    read -p "Topic covered: " MA_TOPIC
    read -p "Materials used: " MA_MATERIALS
    read -p "Content covered (brief description): " MA_CONTENT
    read -p "Duration (minutes): " MA_DURATION
    
    # Non-Verbal Reasoning
    echo -e "${YELLOW}Non-Verbal Reasoning:${NC}"
    read -p "Topic covered: " NVR_TOPIC
    read -p "Materials used: " NVR_MATERIALS
    read -p "Content covered (brief description): " NVR_CONTENT
    read -p "Duration (minutes): " NVR_DURATION
    
    # Verbal Reasoning
    echo -e "${YELLOW}Verbal Reasoning:${NC}"
    read -p "Topic covered: " VR_TOPIC
    read -p "Materials used: " VR_MATERIALS
    read -p "Content covered (brief description): " VR_CONTENT
    read -p "Duration (minutes): " VR_DURATION
    
    # English
    echo -e "${YELLOW}English:${NC}"
    read -p "Topic covered: " EN_TOPIC
    read -p "Materials used: " EN_MATERIALS
    read -p "Content covered (brief description): " EN_CONTENT
    read -p "Duration (minutes): " EN_DURATION
}

# Function to gather assessment results
gather_assessments() {
    echo -e "${BLUE}📊 Assessment Results${NC}"
    echo -e "${YELLOW}Enter scores/observations (press Enter to skip):${NC}"
    
    read -p "Mathematics score (%): " MA_SCORE
    read -p "Mathematics level: " MA_LEVEL
    read -p "Mathematics notes: " MA_NOTES
    
    read -p "NVR score (%): " NVR_SCORE
    read -p "NVR level: " NVR_LEVEL
    read -p "NVR notes: " NVR_NOTES
    
    read -p "VR score (%): " VR_SCORE
    read -p "VR level: " VR_LEVEL
    read -p "VR notes: " VR_NOTES
    
    read -p "English score (%): " EN_SCORE
    read -p "English level: " EN_LEVEL
    read -p "English notes: " EN_NOTES
}

# Function to gather observations
gather_observations() {
    echo -e "${BLUE}🔍 Observations and Notes${NC}"
    
    echo -e "${YELLOW}Academic strengths observed:${NC}"
    read -p "Strength 1: " STRENGTH_1
    read -p "Strength 2: " STRENGTH_2
    read -p "Strength 3: " STRENGTH_3
    
    echo -e "${YELLOW}Areas needing support:${NC}"
    read -p "Area 1: " SUPPORT_1
    read -p "Area 2: " SUPPORT_2
    read -p "Area 3: " SUPPORT_3
    
    echo -e "${YELLOW}Engagement and Behavior:${NC}"
    echo "Rate engagement level (1-10):"
    read -p "Engagement: " ENGAGEMENT_LEVEL
    echo "Rate confidence level (1-10):"
    read -p "Confidence: " CONFIDENCE_LEVEL
    
    read -p "Additional observations: " ADDITIONAL_NOTES
}

# Function to gather task assignments
gather_task_assignments() {
    echo -e "${BLUE}📋 Task Assignments${NC}"
    echo -e "${YELLOW}Homework and practice assignments:${NC}"
    
    read -p "Mathematics homework: " MA_HOMEWORK
    read -p "MA homework due date: " MA_DUE_DATE
    
    read -p "NVR practice assignment: " NVR_HOMEWORK
    read -p "NVR due date: " NVR_DUE_DATE
    
    read -p "VR assignment: " VR_HOMEWORK
    read -p "VR due date: " VR_DUE_DATE
    
    read -p "English assignment: " EN_HOMEWORK
    read -p "English due date: " EN_DUE_DATE
    
    read -p "General study recommendations: " STUDY_RECOMMENDATIONS
}

# Function to create progress log
create_progress_log() {
    local DISPLAY_DATE=$(date -j -f "%Y-%m-%d" "$SESSION_DATE" +"%B %d, %Y" 2>/dev/null || date -d "$SESSION_DATE" +"%B %d, %Y" 2>/dev/null || echo "$SESSION_DATE")
    
    echo -e "${BLUE}📄 Creating progress log...${NC}"
    
    if [ "$APPEND_MODE" = true ]; then
        echo -e "\n---\n### Additional Session Entry - $(date +"%H:%M")" >> "$LOG_FILE"
        echo -e "*(Appended to existing log)*\n" >> "$LOG_FILE"
    fi
    
    cat >> "$LOG_FILE" << EOF
# Daily Progress Log: $STUDENT_NAME
## Date: $DISPLAY_DATE

---

### Session Information
- **Date:** $DISPLAY_DATE
- **Time:** ${START_TIME:-[Start Time]} - ${END_TIME:-[End Time]}
- **Duration:** ${DURATION:-[Duration]}
- **Session Type:** $SESSION_TYPE
- **Tutor:** ${TUTOR_NAME:-[Tutor Name]}

---

### Today's Lessons/Activities
#### Mathematics
- **Topic:** ${MA_TOPIC:-[Topic not specified]}
- **Materials Used:** ${MA_MATERIALS:-[Materials not specified]}
- **Content Covered:**
  - ${MA_CONTENT:-[Content not specified]}
- **Duration:** ${MA_DURATION:-[Duration not specified]} minutes

#### Non-Verbal Reasoning
- **Topic:** ${NVR_TOPIC:-[Topic not specified]}
- **Materials Used:** ${NVR_MATERIALS:-[Materials not specified]}
- **Content Covered:**
  - ${NVR_CONTENT:-[Content not specified]}
- **Duration:** ${NVR_DURATION:-[Duration not specified]} minutes

#### Verbal Reasoning
- **Topic:** ${VR_TOPIC:-[Topic not specified]}
- **Materials Used:** ${VR_MATERIALS:-[Materials not specified]}
- **Content Covered:**
  - ${VR_CONTENT:-[Content not specified]}
- **Duration:** ${VR_DURATION:-[Duration not specified]} minutes

#### English
- **Topic:** ${EN_TOPIC:-[Topic not specified]}
- **Materials Used:** ${EN_MATERIALS:-[Materials not specified]}
- **Content Covered:**
  - ${EN_CONTENT:-[Content not specified]}
- **Duration:** ${EN_DURATION:-[Duration not specified]} minutes

---

### Assessment Results
| Subject | Topic/Area | Score | Level | Comments |
|---------|------------|-------|--------|----------|
| Mathematics | ${MA_TOPIC:-Various} | ${MA_SCORE:-N/A}% | ${MA_LEVEL:-[Level]} | ${MA_NOTES:-[Notes]} |
| NVR | ${NVR_TOPIC:-Various} | ${NVR_SCORE:-N/A}% | ${NVR_LEVEL:-[Level]} | ${NVR_NOTES:-[Notes]} |
| VR | ${VR_TOPIC:-Various} | ${VR_SCORE:-N/A}% | ${VR_LEVEL:-[Level]} | ${VR_NOTES:-[Notes]} |
| English | ${EN_TOPIC:-Various} | ${EN_SCORE:-N/A}% | ${EN_LEVEL:-[Level]} | ${EN_NOTES:-[Notes]} |

---

### Observations and Notes
#### Academic Performance
**Strengths Observed:**
- ${STRENGTH_1:-[To be noted]}
- ${STRENGTH_2:-[To be noted]}
- ${STRENGTH_3:-[To be noted]}

**Areas Needing Support:**
- ${SUPPORT_1:-[To be identified]}
- ${SUPPORT_2:-[To be identified]}
- ${SUPPORT_3:-[To be identified]}

**Additional Notes:**
${ADDITIONAL_NOTES:-[No additional notes]}

#### Engagement and Behavior
**Engagement Level:** ${ENGAGEMENT_LEVEL:-[Not rated]}/10
**Confidence Level:** ${CONFIDENCE_LEVEL:-[Not rated]}/10

---

### Tasks Assigned for Next Session
#### Homework/Practice
- [ ] **Mathematics:** ${MA_HOMEWORK:-[No assignment]}
  - **Due Date:** ${MA_DUE_DATE:-[No due date]}

- [ ] **NVR:** ${NVR_HOMEWORK:-[No assignment]}
  - **Due Date:** ${NVR_DUE_DATE:-[No due date]}

- [ ] **VR:** ${VR_HOMEWORK:-[No assignment]}
  - **Due Date:** ${VR_DUE_DATE:-[No due date]}

- [ ] **English:** ${EN_HOMEWORK:-[No assignment]}
  - **Due Date:** ${EN_DUE_DATE:-[No due date]}

#### Study Recommendations
${STUDY_RECOMMENDATIONS:-[No specific recommendations]}

---

### Summary
**Overall Session Rating:** [To be assessed]

**Key Takeaways:**
1. [To be noted by tutor]
2. [To be noted by tutor]
3. [To be noted by tutor]

**Priority Focus for Next Week:**
- [To be determined based on today's observations]

---

**Log Created:** $(date +"%B %d, %Y")  
**Next Session:** [To be scheduled]  
**Follow-up Required:** [Y/N - specify if yes]
EOF

    if [ "$APPEND_MODE" != true ]; then
        echo -e "${GREEN}✅ Progress log created successfully!${NC}"
    else
        echo -e "${GREEN}✅ Progress log updated successfully!${NC}"
    fi
    echo -e "📄 File: $LOG_FILE"
}

# Function to show summary and next steps
show_summary() {
    echo
    echo -e "${BLUE}📊 Session Summary for $STUDENT_NAME${NC}"
    echo -e "Date: $SESSION_DATE"
    echo -e "Session Type: $SESSION_TYPE"
    echo -e "Duration: ${DURATION:-[Not specified]}"
    echo
    echo -e "${BLUE}🎯 Quick Actions:${NC}"
    echo -e "   View Log: ${GREEN}cat '$LOG_FILE'${NC}"
    echo -e "   Edit Log: ${GREEN}\${EDITOR:-nano} '$LOG_FILE'${NC}"
    echo -e "   View Profile: ${GREEN}cat '$PROFILE_FILE'${NC}"
    echo -e "   Generate Report: ${GREEN}./scripts/generate_weekly_report.sh '$STUDENT_NAME'${NC}"
    echo
    echo -e "${YELLOW}💡 Don't forget to:${NC}"
    echo -e "   • Update student profile if needed"
    echo -e "   • Prepare materials for next session"
    echo -e "   • Follow up on any concerns noted"
    echo -e "   • Generate weekly newsletter if due"
    echo
}

# Main function
main() {
    show_header
    
    # Get session info
    get_session_info "$1" "$2"
    
    # Check if profile exists
    check_profile_exists
    
    # Check for existing log
    check_existing_log
    
    # Gather all information
    gather_session_info
    gather_subject_activities
    gather_assessments
    gather_observations
    gather_task_assignments
    
    # Create the log
    create_progress_log
    
    # Show summary
    show_summary
}

# Run main function with arguments
main "$@"