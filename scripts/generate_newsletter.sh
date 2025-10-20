#!/bin/bash

# OA TUTORS - Weekly Newsletter Generator
# Creates personalized newsletters for parents and students
# Usage: ./generate_newsletter.sh [week_number] [student_name] [audience]

if [ $# -ne 3 ]; then
    echo "Usage: $0 [week_number] [student_name] [audience]"
    echo "Audience: parents | students | both"
    echo "Example: $0 15 'Emma Johnson' both"
    exit 1
fi

WEEK_NUMBER=$1
STUDENT_NAME="$2"
AUDIENCE=$3

# Get current date information (macOS compatible)
CURRENT_DATE=$(date +"%B %d, %Y")
WEEK_START=$(date -v-monday +"%B %d")
WEEK_END=$(date -v+sunday +"%B %d, %Y")
DATE_RANGE="$WEEK_START - $WEEK_END"
SCHOOL_YEAR="2024-25"

# Create safe filename from student name
SAFE_NAME=$(echo "$STUDENT_NAME" | tr ' ' '_' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_]//g')

echo "🌟 OA TUTORS Newsletter Generator"
echo "=================================="
echo ""
echo "Generating newsletter for:"
echo "📅 Week: $WEEK_NUMBER ($DATE_RANGE)"
echo "👤 Student: $STUDENT_NAME"
echo "📧 Audience: $AUDIENCE"
echo ""

# Function to generate parent newsletter
generate_parent_newsletter() {
    local output_file="newsletters/parents/week_${WEEK_NUMBER}_${SAFE_NAME}_parents.md"
    
    echo "📋 Generating parent newsletter..."
    
    # Copy template and replace basic placeholders
    cp "newsletters/parents/weekly_newsletter_template_parents.md" "$output_file"
    
    # Replace basic information
    sed -i '' "s/\[WEEK_NUMBER\]/$WEEK_NUMBER/g" "$output_file"
    sed -i '' "s/\[DATE_RANGE\]/$DATE_RANGE/g" "$output_file"
    sed -i '' "s/\[SCHOOL_YEAR\]/$SCHOOL_YEAR/g" "$output_file"
    sed -i '' "s/\[STUDENT_NAME\]/$STUDENT_NAME/g" "$output_file"
    sed -i '' "s/\[GENERATION_DATE\]/$CURRENT_DATE/g" "$output_file"
    
    echo "✅ Parent newsletter created: $output_file"
    echo "📝 Next step: Edit the file to add specific content for this week"
}

# Function to generate student newsletter
generate_student_newsletter() {
    local output_file="newsletters/students/week_${WEEK_NUMBER}_${SAFE_NAME}_students.md"
    
    echo "📋 Generating student newsletter..."
    
    # Copy template and replace basic placeholders
    cp "newsletters/students/weekly_newsletter_template_students.md" "$output_file"
    
    # Replace basic information
    sed -i '' "s/\[WEEK_NUMBER\]/$WEEK_NUMBER/g" "$output_file"
    sed -i '' "s/\[DATE_RANGE\]/$DATE_RANGE/g" "$output_file"
    sed -i '' "s/\[STUDENT_NAME\]/$STUDENT_NAME/g" "$output_file"
    sed -i '' "s/\[GENERATION_DATE\]/$CURRENT_DATE/g" "$output_file"
    
    echo "✅ Student newsletter created: $output_file"
    echo "📝 Next step: Edit the file to add specific content for this week"
}

# Generate newsletters based on audience
case $AUDIENCE in
    "parents")
        generate_parent_newsletter
        ;;
    "students")
        generate_student_newsletter
        ;;
    "both")
        generate_parent_newsletter
        generate_student_newsletter
        ;;
    *)
        echo "❌ Invalid audience: $AUDIENCE"
        echo "Use: parents | students | both"
        exit 1
        ;;
esac

echo ""
echo "🎯 Newsletter Generation Complete!"
echo ""
echo "📝 Next Steps:"
echo "1. Open the generated newsletter file(s)"
echo "2. Replace placeholder content with actual information:"
echo "   - Subject topics and concepts"
echo "   - Assessment scores and feedback"
echo "   - Personal achievements and goals"
echo "   - Upcoming topics and preparation tips"
echo "3. Review for accuracy and personalization"
echo "4. Send to parents/students via email or print"
echo ""
echo "💡 Tips:"
echo "   - Keep content positive and encouraging"
echo "   - Include specific examples of student progress"
echo "   - Provide actionable advice for home support"
echo "   - Celebrate achievements, however small"
echo ""
echo "📧 For help with newsletter content, contact: support@oatutors.co.uk"