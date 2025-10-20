#!/bin/bash

# Student Progress Tracking - Create Student Profile Script
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
PROFILES_DIR="$TRACKING_DIR/profiles"
TEMPLATE_DIR="$PROJECT_ROOT/templates"

# Function to display header
show_header() {
    echo -e "${BLUE}==================================${NC}"
    echo -e "${BLUE}   OA TUTORS - Student Profile${NC}"
    echo -e "${BLUE}         Creation System${NC}"
    echo -e "${BLUE}==================================${NC}"
    echo
}

# Function to get student name
get_student_name() {
    if [ -n "$1" ]; then
        STUDENT_NAME="$1"
    else
        echo -e "${YELLOW}Enter student's first name:${NC}"
        read -p "> " STUDENT_NAME
    fi
    
    # Convert to lowercase for filename
    STUDENT_LOWERCASE=$(echo "$STUDENT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
    PROFILE_FILE="$PROFILES_DIR/${STUDENT_LOWERCASE}_profile.md"
}

# Function to check if profile exists
check_existing_profile() {
    if [ -f "$PROFILE_FILE" ]; then
        echo -e "${YELLOW}⚠️  Profile for $STUDENT_NAME already exists!${NC}"
        echo -e "File: $PROFILE_FILE"
        echo
        echo -e "${YELLOW}Choose an option:${NC}"
        echo "1. View existing profile"
        echo "2. Update existing profile" 
        echo "3. Create new version"
        echo "4. Cancel"
        echo
        read -p "Enter choice (1-4): " choice
        
        case $choice in
            1) 
                echo -e "${GREEN}📄 Viewing existing profile...${NC}"
                cat "$PROFILE_FILE"
                exit 0
                ;;
            2)
                echo -e "${YELLOW}📝 Opening profile for editing...${NC}"
                ${EDITOR:-nano} "$PROFILE_FILE"
                exit 0
                ;;
            3)
                TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
                PROFILE_FILE="$PROFILES_DIR/${STUDENT_LOWERCASE}_profile_${TIMESTAMP}.md"
                echo -e "${GREEN}📄 Creating new version: ${PROFILE_FILE}${NC}"
                ;;
            4)
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

# Function to create directory if it doesn't exist
ensure_directory() {
    if [ ! -d "$TRACKING_DIR" ]; then
        echo -e "${YELLOW}📁 Creating student tracking directory...${NC}"
        mkdir -p "$PROFILES_DIR"
        mkdir -p "$TRACKING_DIR/progress_logs"
        mkdir -p "$TRACKING_DIR/weekly_reports"
        mkdir -p "$TRACKING_DIR/task_assignments"
        echo -e "${GREEN}✅ Directories created${NC}"
    fi
}

# Function to gather student information
gather_student_info() {
    echo -e "${BLUE}📋 Student Information Collection${NC}"
    echo -e "${YELLOW}Please provide the following information (press Enter to skip):${NC}"
    echo
    
    read -p "Student's full name: " FULL_NAME
    read -p "Date of Birth (DD/MM/YYYY): " DOB
    read -p "Current Year Group: " YEAR_GROUP
    read -p "Target Schools (comma separated): " TARGET_SCHOOLS
    read -p "Primary Parent Contact Name: " PARENT_NAME
    read -p "Parent Phone Number: " PARENT_PHONE
    read -p "Parent Email: " PARENT_EMAIL
    read -p "Current School: " CURRENT_SCHOOL
    read -p "Previous 11+ Experience (Yes/No): " PREV_EXPERIENCE
    
    echo
    echo -e "${YELLOW}Learning Style Assessment:${NC}"
    echo "Rate each learning style (High/Medium/Low):"
    read -p "Visual Learning: " VISUAL_LEARNING
    read -p "Auditory Learning: " AUDITORY_LEARNING  
    read -p "Kinesthetic Learning: " KINESTHETIC_LEARNING
    read -p "Reading/Writing Preference: " READING_WRITING
    
    echo
    echo -e "${YELLOW}Session Scheduling:${NC}"
    read -p "Preferred Session Day: " SESSION_DAY
    read -p "Preferred Session Time: " SESSION_TIME
    read -p "Session Duration (e.g., 2 hours): " SESSION_DURATION
    read -p "Session Frequency (e.g., Weekly): " SESSION_FREQUENCY
}

# Function to create profile from template
create_profile() {
    local CURRENT_DATE=$(date +"%B %d, %Y")
    local CURRENT_DATE_SHORT=$(date +"%Y-%m-%d")
    
    echo -e "${BLUE}📄 Creating student profile...${NC}"
    
    # Create profile content
    cat > "$PROFILE_FILE" << EOF
# Student Profile: ${FULL_NAME:-$STUDENT_NAME}

## Personal Information
- **Full Name:** ${FULL_NAME:-$STUDENT_NAME}
- **Date of Birth:** ${DOB:-[To be filled]}
- **Year Group:** ${YEAR_GROUP:-[To be filled]}
- **Target Schools:** ${TARGET_SCHOOLS:-[To be filled]}
- **Start Date:** $CURRENT_DATE
- **Tutor:** [Tutor Name]

## Contact Information
### Student
- **Preferred Communication:** [Email/WhatsApp/In-person]
- **Best Contact Times:** [Time preferences]

### Parents/Guardians
- **Primary Contact:** ${PARENT_NAME:-[Parent Name]}
- **Phone:** ${PARENT_PHONE:-[Phone Number]}
- **Email:** ${PARENT_EMAIL:-[Email Address]}
- **Secondary Contact:** [If applicable]
- **Communication Preference:** [Email/Phone/WhatsApp]
- **Preferred Update Frequency:** [Weekly/Bi-weekly/Monthly]

## Academic Background
### Previous Education
- **Current School:** ${CURRENT_SCHOOL:-[School Name]}
- **Previous Tutoring:** [Yes/No - Details if applicable]
- **11+ Experience:** ${PREV_EXPERIENCE:-First time}

### Initial Assessment Results
*(Complete after first assessment session)*
- **Mathematics:** [Score/Level] - [Date]
- **Non-Verbal Reasoning:** [Score/Level] - [Date]
- **Verbal Reasoning:** [Score/Level] - [Date]
- **English:** [Score/Level] - [Date]
- **Overall Level:** [Beginning/Intermediate/Advanced]

## Learning Profile
### Learning Style
- **Visual Learner:** ${VISUAL_LEARNING:-[High/Medium/Low]}
- **Auditory Learner:** ${AUDITORY_LEARNING:-[High/Medium/Low]}
- **Kinesthetic Learner:** ${KINESTHETIC_LEARNING:-[High/Medium/Low]}
- **Reading/Writing Preference:** ${READING_WRITING:-[High/Medium/Low]}

### Strengths
*(Update regularly based on observations)*
- **Academic Strengths:** 
  - [To be identified during initial sessions]
  - [e.g., Quick mental arithmetic]
  - [e.g., Strong pattern recognition]

- **Personal Strengths:**
  - [To be identified during initial sessions]
  - [e.g., Highly motivated]
  - [e.g., Asks thoughtful questions]

### Areas for Development
*(Update regularly - be constructive and specific)*
- **Academic Areas:**
  - [To be identified during assessment]
  - [e.g., Needs support with complex word problems]
  - [e.g., Speed improvement needed in NVR]

- **Study Skills:**
  - [To be assessed]
  - [e.g., Time management in exams]
  - [e.g., Checking work carefully]

## Goals and Targets
### Long-term Goals (6+ months)
- **Primary Goal:** [e.g., Achieve Level 5 in all subjects]
- **Target Schools:** ${TARGET_SCHOOLS:-[List with entry requirements]}
- **Exam Dates:** [Specific 11+ exam dates]

### Medium-term Goals (1-3 months)
- **Mathematics:** [To be set after assessment]
- **NVR:** [To be set after assessment]
- **VR:** [To be set after assessment]
- **English:** [To be set after assessment]

### Short-term Goals (This Month)
- **Week 1:** Initial assessment and goal setting
- **Week 2:** [To be determined based on assessment results]
- **Week 3:** [To be determined]
- **Week 4:** [To be determined]

## Current Progress Status
### Mathematics
- **Current Unit:** Assessment Phase
- **Completion Status:** Starting curriculum
- **Next Lesson:** Initial Assessment / Lesson 01: Number Operations

### Non-Verbal Reasoning
- **Current Unit:** Assessment Phase
- **Completion Status:** Starting curriculum
- **Next Lesson:** Initial Assessment / Lesson 01: Shape Puzzles

### Verbal Reasoning
- **Current Unit:** Not yet started
- **Planned Start:** After initial assessment
- **First Lesson:** Lesson 01: Alphabet Positions

### English
- **Current Unit:** Not yet started
- **Planned Start:** After initial assessment
- **First Lesson:** Lesson 01: Sentences, Phrases & Clauses

## Assessment History
### Regular Assessments
| Date | Subject | Topic | Score | Level | Notes |
|------|---------|-------|-------|--------|-------|
| $CURRENT_DATE_SHORT | Initial | Assessment Scheduled | - | - | First session |

### Practice Exam Results
| Date | Exam Type | Overall Score | MA | NVR | VR | EN | Notes |
|------|-----------|---------------|----|----|----|----|-------|
| [To be scheduled] | Initial Mock | [%] | [%] | [%] | [%] | [%] | [Notes] |

## Task Management
### Current Assignments
- [ ] **Initial Assessment:** Complete assessment in all subjects - Due: Next session
- [ ] **Profile Information:** Complete remaining personal details - Due: [Date]

### Completed Tasks (Recent)
- [x] **Profile Created:** Student profile established - Completed: $CURRENT_DATE

### Overdue Tasks
*(Monitor and address immediately)*
- None currently

## Parent Communication Log
### Recent Meetings/Calls
| Date | Type | Attendees | Topics Discussed | Action Items |
|------|------|-----------|------------------|--------------|
| $CURRENT_DATE_SHORT | Profile Setup | System Setup | Profile creation, initial planning | Schedule first assessment session |

### Newsletter History
- **Week [Current]:** Newsletter system setup
- **Week [Next]:** Scheduled for first progress newsletter

## Special Notes
### Learning Accommodations
- [Any special requirements or accommodations needed - to be discussed]
- [Learning differences or challenges to consider - to be assessed]
- [Preferred teaching methods that work well - to be discovered]

### Motivational Factors
- **What motivates ${STUDENT_NAME}:** [To be identified during initial sessions]
- **Reward Preferences:** [To be discovered]
- **Communication Style:** [To be assessed and adapted]

### Family Context
- **Siblings:** [Information about siblings, especially if also doing 11+]
- **Home Study Environment:** [Description of study space and family support]
- **Extracurricular Activities:** [Other commitments to consider in scheduling]

## Schedule Information
### Regular Sessions
- **Day:** ${SESSION_DAY:-[To be arranged]}
- **Time:** ${SESSION_TIME:-[To be arranged]}
- **Duration:** ${SESSION_DURATION:-[To be arranged]}
- **Frequency:** ${SESSION_FREQUENCY:-Weekly}

### Holiday/Break Schedule
- **Half-term:** [Dates and any schedule changes]
- **Christmas:** [Dates and schedule]
- **Easter:** [Dates and schedule]

## Progress Tracking
### Monthly Progress Summary
- **$(date +"%B %Y"):** Profile created, initial assessment phase
- **$(date -d "next month" +"%B %Y"):** [To be updated]

### Key Milestones Achieved
- **$CURRENT_DATE:** Profile created and 11+ preparation program initiated

---

## Profile Updates Log
| Date | Updated By | Changes Made | Reason |
|------|------------|--------------|---------|
| $CURRENT_DATE_SHORT | [Tutor] | Profile created | New student onboarding |

---

**Profile Created:** $CURRENT_DATE  
**Last Updated:** $CURRENT_DATE  
**Next Review:** $(date -d "+1 month" +"%B %d, %Y")  
**System Version:** 1.0
EOF

    echo -e "${GREEN}✅ Profile created successfully!${NC}"
    echo -e "📄 File: $PROFILE_FILE"
}

# Function to create initial progress log
create_initial_progress_log() {
    local LOG_DATE=$(date +"%Y-%m-%d")
    local LOG_FILE="$TRACKING_DIR/progress_logs/${STUDENT_LOWERCASE}_${LOG_DATE}.md"
    
    echo -e "${BLUE}📝 Creating initial progress log...${NC}"
    
    cat > "$LOG_FILE" << EOF
# Daily Progress Log: ${STUDENT_NAME}
## Date: $(date +"%B %d, %Y")

---

### Session Information
- **Date:** $(date +"%B %d, %Y")
- **Time:** [Start Time] - [End Time]
- **Duration:** ${SESSION_DURATION:-[Duration]}
- **Session Type:** Initial Assessment / Profile Setup
- **Tutor:** [Tutor Name]

---

### Today's Activities
#### Profile Creation
- **Activity:** Student profile setup and information gathering
- **Duration:** [Time spent]
- **Completion Status:** Profile created, awaiting initial assessment

#### Initial Discussion
- **Topics Covered:**
  - Introduction to 11+ preparation program
  - Discussion of goals and expectations
  - Learning style assessment
  - Schedule planning
  
---

### Next Steps
- [ ] **Schedule Initial Assessment:** Book comprehensive assessment session
- [ ] **Prepare Assessment Materials:** Gather test papers for all subjects
- [ ] **Complete Profile:** Fill in any missing information
- [ ] **Parent Meeting:** Schedule discussion with parents/guardians

---

### Notes
- Profile successfully created for ${STUDENT_NAME}
- Ready to begin 11+ preparation journey
- Initial assessment to be scheduled

---

**Log Created:** $(date +"%B %d, %Y")  
**Next Session:** [To be scheduled]  
**Status:** Profile Setup Complete
EOF

    echo -e "${GREEN}✅ Initial progress log created!${NC}"
    echo -e "📝 File: $LOG_FILE"
}

# Function to show next steps
show_next_steps() {
    echo
    echo -e "${BLUE}🎯 Next Steps for ${STUDENT_NAME}:${NC}"
    echo -e "1. ${YELLOW}Schedule Initial Assessment Session${NC}"
    echo -e "2. ${YELLOW}Complete any missing profile information${NC}"
    echo -e "3. ${YELLOW}Set up parent communication${NC}"
    echo -e "4. ${YELLOW}Prepare assessment materials${NC}"
    echo -e "5. ${YELLOW}Begin lesson planning${NC}"
    echo
    echo -e "${BLUE}📁 Files Created:${NC}"
    echo -e "   Profile: $PROFILE_FILE"
    echo -e "   Progress Log: Available after ./scripts/log_student_progress.sh"
    echo
    echo -e "${BLUE}🔧 Available Commands:${NC}"
    echo -e "   View Profile: ${GREEN}cat '$PROFILE_FILE'${NC}"
    echo -e "   Edit Profile: ${GREEN}\${EDITOR:-nano} '$PROFILE_FILE'${NC}"
    echo -e "   Log Progress: ${GREEN}./scripts/log_student_progress.sh '${STUDENT_NAME}' $(date +%Y-%m-%d)${NC}"
    echo -e "   Generate Report: ${GREEN}./scripts/generate_weekly_report.sh '${STUDENT_NAME}'${NC}"
    echo
}

# Main function
main() {
    show_header
    
    # Ensure directories exist
    ensure_directory
    
    # Get student name
    get_student_name "$1"
    
    # Check for existing profile
    check_existing_profile
    
    # Gather information
    gather_student_info
    
    # Create profile
    create_profile
    
    # Create initial progress log
    create_initial_progress_log
    
    # Show next steps
    show_next_steps
}

# Run main function with all arguments
main "$@"