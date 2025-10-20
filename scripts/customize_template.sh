#!/bin/bash

# OA TUTORS - Template Customization Script
# Quickly create customized lesson files from templates
# Usage: ./customize_template.sh [template_type] [subject] [lesson_num] [topic]

if [ $# -ne 4 ]; then
    echo "Usage: $0 [template_type] [subject] [lesson_num] [topic]"
    echo "Template types: lesson, student_notes, homework, teacher_answer_key, extension_activity"
    echo "Subjects: MA, NVR, VR, EN"
    echo "Example: $0 teacher_answer_key MA 01 NumberOperations"
    exit 1
fi

TEMPLATE_TYPE=$1
SUBJECT=$2
LESSON_NUM=$3
TOPIC=$4

# Map subject codes to full names
case $SUBJECT in
    "MA") SUBJECT_NAME="Mathematics" ;;
    "NVR") SUBJECT_NAME="Non-Verbal Reasoning" ;;
    "VR") SUBJECT_NAME="Verbal Reasoning" ;;
    "EN") SUBJECT_NAME="English" ;;
    *) echo "Invalid subject: $SUBJECT"; exit 1 ;;
esac

# Define template and output filenames
case $TEMPLATE_TYPE in
    "lesson")
        TEMPLATE_FILE="templates/lesson_template.tex"
        OUTPUT_FILE="${SUBJECT}/Lesson${LESSON_NUM}_${TOPIC}.tex"
        ;;
    "student_notes")
        TEMPLATE_FILE="templates/student_notes_template.tex"
        OUTPUT_FILE="${SUBJECT}/StudentNotes_Lesson${LESSON_NUM}_${TOPIC}.tex"
        ;;
    "homework")
        TEMPLATE_FILE="templates/homework_template.tex"
        OUTPUT_FILE="${SUBJECT}/Homework_Lesson${LESSON_NUM}_${TOPIC}.tex"
        ;;
    "teacher_answer_key")
        TEMPLATE_FILE="templates/teacher_answer_key_template.tex"
        OUTPUT_FILE="${SUBJECT}/Teacher_AnswerKey_Lesson${LESSON_NUM}_${TOPIC}.tex"
        ;;
    "extension_activity")
        TEMPLATE_FILE="templates/extension_activity_template.tex"
        OUTPUT_FILE="${SUBJECT}/ExtensionActivity_Lesson${LESSON_NUM}_${TOPIC}.tex"
        ;;
    *)
        echo "Invalid template type: $TEMPLATE_TYPE"
        exit 1
        ;;
esac

# Check if template exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    echo "Error: Template file $TEMPLATE_FILE not found"
    exit 1
fi

# Check if output file already exists
if [ -f "$OUTPUT_FILE" ]; then
    echo "Warning: Output file $OUTPUT_FILE already exists"
    read -p "Overwrite? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

# Copy template and customize placeholders
echo "Creating $OUTPUT_FILE..."

cp "$TEMPLATE_FILE" "$OUTPUT_FILE"

# Replace basic placeholders
sed -i '' "s/\[SUBJECT\]/$SUBJECT_NAME/g" "$OUTPUT_FILE"
sed -i '' "s/\[XX\]/$LESSON_NUM/g" "$OUTPUT_FILE"
sed -i '' "s/\[LESSON_TITLE\]/$TOPIC/g" "$OUTPUT_FILE"

echo "✅ Created: $OUTPUT_FILE"
echo "📝 Next steps:"
echo "   1. Edit $OUTPUT_FILE to add specific content"
echo "   2. Replace remaining placeholders with actual content"
echo "   3. Test LaTeX compilation"
echo "   4. Run ./scripts/check_lesson_completeness.sh to verify"