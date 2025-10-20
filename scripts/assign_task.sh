#!/bin/bash

# Student Progress Tracking - Task Assignment Manager
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
TASKS_DIR="$TRACKING_DIR/task_assignments"
PROFILES_DIR="$TRACKING_DIR/profiles"

# Function to display header
show_header() {
    echo -e "${BLUE}==================================${NC}"
    echo -e "${BLUE}   OA TUTORS - Task Manager${NC}"
    echo -e "${BLUE}     Assignment Tracking${NC}"
    echo -e "${BLUE}==================================${NC}"
    echo
}

# Function to get parameters
get_task_info() {
    if [ -n "$1" ]; then
        STUDENT_NAME="$1"
    else
        echo -e "${YELLOW}Enter student's name:${NC}"
        read -p "> " STUDENT_NAME
    fi
    
    if [ -n "$2" ]; then
        TASK_DESCRIPTION="$2"
    else
        echo -e "${YELLOW}Enter task description:${NC}"
        read -p "> " TASK_DESCRIPTION
    fi
    
    if [ -n "$3" ]; then
        DUE_DATE="$3"
    else
        echo -e "${YELLOW}Enter due date (YYYY-MM-DD):${NC}"
        read -p "> " DUE_DATE
    fi
    
    # Additional task information
    echo -e "${YELLOW}Task priority (High/Medium/Low):${NC}"
    read -p "> " PRIORITY
    
    echo -e "${YELLOW}Estimated time (e.g., 30 minutes):${NC}"
    read -p "> " ESTIMATED_TIME
    
    echo -e "${YELLOW}Subject (MA/NVR/VR/EN/General):${NC}"
    read -p "> " SUBJECT
    
    # Convert to lowercase for filename
    STUDENT_LOWERCASE=$(echo "$STUDENT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
    TASK_FILE="$TASKS_DIR/${STUDENT_LOWERCASE}_tasks.md"
    PROFILE_FILE="$PROFILES_DIR/${STUDENT_LOWERCASE}_profile.md"
}

# Function to check if directories exist
ensure_directories() {
    if [ ! -d "$TASKS_DIR" ]; then
        mkdir -p "$TASKS_DIR"
        echo -e "${GREEN}📁 Created task assignments directory${NC}"
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

# Function to create task file if it doesn't exist
create_task_file_if_needed() {
    if [ ! -f "$TASK_FILE" ]; then
        echo -e "${BLUE}📋 Creating task file for $STUDENT_NAME...${NC}"
        cat > "$TASK_FILE" << EOF
# Task Management: $STUDENT_NAME

## Current Tasks
*(Tasks currently assigned and in progress)*

## Completed Tasks
*(Recently completed tasks)*

## Overdue Tasks  
*(Tasks that are past their due date)*

---

### Task Status Legend
- 🔴 **Overdue** - Past due date, needs immediate attention
- 🟡 **Due Soon** - Due within 2 days
- 🟢 **On Track** - Due date is more than 2 days away
- ✅ **Completed** - Task finished successfully
- ❌ **Cancelled** - Task cancelled or no longer needed

### Priority Levels
- 🔥 **High** - Critical for progress, must be completed
- ⭐ **Medium** - Important for development, should be completed
- 💡 **Low** - Additional practice, complete if time allows

---

**File Created:** $(date +"%B %d, %Y")  
**Last Updated:** $(date +"%B %d, %Y")
EOF
        echo -e "${GREEN}✅ Task file created${NC}"
    fi
}

# Function to get priority emoji
get_priority_emoji() {
    case "$1" in
        "High"|"high"|"HIGH") echo "🔥" ;;
        "Medium"|"medium"|"MEDIUM") echo "⭐" ;;
        "Low"|"low"|"LOW") echo "💡" ;;
        *) echo "⭐" ;;
    esac
}

# Function to get subject emoji
get_subject_emoji() {
    case "$1" in
        "MA"|"ma"|"Mathematics"|"mathematics") echo "🔢" ;;
        "NVR"|"nvr"|"Non-Verbal"|"non-verbal") echo "🧩" ;;
        "VR"|"vr"|"Verbal"|"verbal") echo "🗣️" ;;
        "EN"|"en"|"English"|"english") echo "📚" ;;
        *) echo "📋" ;;
    esac
}

# Function to add task
add_task() {
    local TASK_ID="TASK_$(date +%Y%m%d_%H%M%S)"
    local PRIORITY_EMOJI=$(get_priority_emoji "$PRIORITY")
    local SUBJECT_EMOJI=$(get_subject_emoji "$SUBJECT")
    local ASSIGNED_DATE=$(date +"%Y-%m-%d")
    local DUE_DATE_FORMATTED=$(date -j -f "%Y-%m-%d" "$DUE_DATE" +"%B %d, %Y" 2>/dev/null || echo "$DUE_DATE")
    
    echo -e "${BLUE}➕ Adding task for $STUDENT_NAME...${NC}"
    
    # Read current file content
    local TEMP_FILE="/tmp/tasks_temp_$$"
    cp "$TASK_FILE" "$TEMP_FILE"
    
    # Find the "Current Tasks" section and add the new task
    awk -v task_id="$TASK_ID" \
        -v description="$TASK_DESCRIPTION" \
        -v due_date="$DUE_DATE" \
        -v due_formatted="$DUE_DATE_FORMATTED" \
        -v priority="$PRIORITY" \
        -v priority_emoji="$PRIORITY_EMOJI" \
        -v subject="$SUBJECT" \
        -v subject_emoji="$SUBJECT_EMOJI" \
        -v estimated_time="$ESTIMATED_TIME" \
        -v assigned_date="$ASSIGNED_DATE" \
        -v current_date="$(date +"%Y-%m-%d")" \
        '
        /^## Current Tasks/ {
            print $0
            print "*(Tasks currently assigned and in progress)*"
            print ""
            print "### " task_id " - " priority_emoji " " subject_emoji " " description
            print "- **Subject:** " subject
            print "- **Priority:** " priority
            print "- **Due Date:** " due_formatted " (" due_date ")"
            print "- **Estimated Time:** " estimated_time
            print "- **Assigned:** " assigned_date
            print "- **Status:** 🟢 On Track"
            print "- **Progress:** Not started"
            print "- **Notes:** [Add progress notes here]"
            print ""
            next
        }
        /^\*\(Tasks currently assigned and in progress\)\*/ { next }
        { print }
        ' "$TEMP_FILE" > "$TASK_FILE"
    
    rm "$TEMP_FILE"
    
    # Update the last modified date
    sed -i '' "s/\*\*Last Updated:\*\*.*/\*\*Last Updated:\*\* $(date +"%B %d, %Y")/g" "$TASK_FILE"
    
    echo -e "${GREEN}✅ Task added successfully!${NC}"
    echo -e "📋 Task ID: $TASK_ID"
    echo -e "📄 File: $TASK_FILE"
}

# Function to show task menu
show_task_menu() {
    echo -e "${BLUE}🎯 Task Management Options:${NC}"
    echo "1. Add new task"
    echo "2. View current tasks"
    echo "3. Mark task as completed"
    echo "4. Update task progress"
    echo "5. Mark task as overdue"
    echo "6. Cancel task"
    echo "7. View all tasks"
    echo "8. Exit"
    echo
    read -p "Choose option (1-8): " menu_choice
    
    case $menu_choice in
        1) add_task ;;
        2) view_current_tasks ;;
        3) complete_task ;;
        4) update_task_progress ;;
        5) mark_overdue ;;
        6) cancel_task ;;
        7) view_all_tasks ;;
        8) exit 0 ;;
        *) echo -e "${RED}❌ Invalid choice${NC}"; show_task_menu ;;
    esac
}

# Function to view current tasks
view_current_tasks() {
    echo -e "${BLUE}📋 Current Tasks for $STUDENT_NAME:${NC}"
    if [ -f "$TASK_FILE" ]; then
        awk '/^## Current Tasks/,/^## /{if(/^###/) print}' "$TASK_FILE" | head -20
        if [ ${PIPESTATUS[0]} -eq 0 ]; then
            echo -e "${GREEN}✅ Current tasks displayed above${NC}"
        else
            echo -e "${YELLOW}📭 No current tasks found${NC}"
        fi
    else
        echo -e "${YELLOW}📭 No task file exists yet${NC}"
    fi
    echo
    show_task_menu
}

# Function to view all tasks
view_all_tasks() {
    echo -e "${BLUE}📊 All Tasks for $STUDENT_NAME:${NC}"
    if [ -f "$TASK_FILE" ]; then
        cat "$TASK_FILE"
    else
        echo -e "${YELLOW}📭 No task file exists yet${NC}"
    fi
    echo
}

# Function to complete task
complete_task() {
    echo -e "${BLUE}✅ Mark Task as Completed${NC}"
    if [ ! -f "$TASK_FILE" ]; then
        echo -e "${YELLOW}📭 No tasks found for $STUDENT_NAME${NC}"
        return
    fi
    
    echo -e "${YELLOW}Available tasks:${NC}"
    grep "^### TASK_" "$TASK_FILE" | nl
    echo
    read -p "Enter task number to complete: " task_num
    
    local TASK_LINE=$(grep "^### TASK_" "$TASK_FILE" | sed -n "${task_num}p")
    if [ -z "$TASK_LINE" ]; then
        echo -e "${RED}❌ Invalid task number${NC}"
        return
    fi
    
    local TASK_ID=$(echo "$TASK_LINE" | cut -d' ' -f2)
    echo -e "${GREEN}✅ Marking task $TASK_ID as completed${NC}"
    
    read -p "Enter completion notes (optional): " completion_notes
    read -p "Enter final score/grade (optional): " final_score
    
    # Move task to completed section (this is a simplified approach)
    echo -e "${YELLOW}💡 Task marked as completed. Update manually in file:${NC}"
    echo -e "   ${GREEN}\${EDITOR:-nano} '$TASK_FILE'${NC}"
    echo -e "   Look for task: $TASK_ID"
}

# Function to show summary
show_summary() {
    echo
    echo -e "${BLUE}📊 Task Management Summary${NC}"
    echo -e "Student: $STUDENT_NAME"
    if [ -f "$TASK_FILE" ]; then
        local current_count=$(grep -c "^### TASK_" "$TASK_FILE" 2>/dev/null || echo "0")
        echo -e "Total tasks: $current_count"
        echo -e "Task file: $TASK_FILE"
    else
        echo -e "Task file: Not created yet"
    fi
    echo
    echo -e "${BLUE}🔧 Quick Commands:${NC}"
    echo -e "   View tasks: ${GREEN}cat '$TASK_FILE'${NC}"
    echo -e "   Edit tasks: ${GREEN}\${EDITOR:-nano} '$TASK_FILE'${NC}"
    echo -e "   Add task: ${GREEN}./scripts/assign_task.sh '$STUDENT_NAME' 'Task Description' 'YYYY-MM-DD'${NC}"
    echo
}

# Main function
main() {
    show_header
    
    # If called with parameters, add task directly
    if [ $# -ge 3 ]; then
        get_task_info "$1" "$2" "$3"
        ensure_directories
        check_student_exists
        create_task_file_if_needed
        add_task
        show_summary
    else
        # Interactive mode
        get_task_info "$1" "$2" "$3"
        ensure_directories
        check_student_exists
        create_task_file_if_needed
        
        if [ -n "$TASK_DESCRIPTION" ]; then
            add_task
        fi
        
        show_task_menu
    fi
}

# Run main function with arguments
main "$@"