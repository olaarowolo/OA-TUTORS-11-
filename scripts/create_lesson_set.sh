#!/bin/bash

# OA TUTORS - Complete Lesson Set Creator
# Creates all 5 files needed for a complete lesson
# Usage: ./create_lesson_set.sh [subject] [lesson_num] [topic]

if [ $# -ne 3 ]; then
    echo "Usage: $0 [subject] [lesson_num] [topic]"
    echo "Subjects: MA, NVR, VR, EN"
    echo "Example: $0 MA 06 Rounding"
    exit 1
fi

SUBJECT=$1
LESSON_NUM=$2
TOPIC=$3

echo "🚀 Creating complete lesson set: $SUBJECT Lesson $LESSON_NUM - $TOPIC"
echo "============================================================"

# Array of document types
doc_types=("lesson" "student_notes" "homework" "teacher_answer_key" "extension_activity")

# Create each document type
for doc_type in "${doc_types[@]}"; do
    echo "📝 Creating ${doc_type}..."
    ./scripts/customize_template.sh "$doc_type" "$SUBJECT" "$LESSON_NUM" "$TOPIC"
    
    if [ $? -ne 0 ]; then
        echo "❌ Error creating ${doc_type}"
        exit 1
    fi
done

echo ""
echo "✅ Complete lesson set created successfully!"
echo ""
echo "📋 Files created:"

# List the files that were created
case $SUBJECT in
    "MA") subject_name="Mathematics" ;;
    "NVR") subject_name="Non-Verbal Reasoning" ;;
    "VR") subject_name="Verbal Reasoning" ;;
    "EN") subject_name="English" ;;
esac

echo "   • Lesson${LESSON_NUM}_${TOPIC}.tex - Main lesson plan"
echo "   • StudentNotes_Lesson${LESSON_NUM}_${TOPIC}.tex - Student reference"
echo "   • Homework_Lesson${LESSON_NUM}_${TOPIC}.tex - Practice exercises"
echo "   • Teacher_AnswerKey_Lesson${LESSON_NUM}_${TOPIC}.tex - Solutions & guidance"
echo "   • ExtensionActivity_Lesson${LESSON_NUM}_${TOPIC}.tex - Advanced activities"

echo ""
echo "📝 Next steps:"
echo "1. Edit each file to add specific content for $TOPIC"
echo "2. Replace template placeholders with actual lesson content"
echo "3. Test LaTeX compilation: pdflatex [filename].tex"
echo "4. Verify completeness: ./scripts/check_lesson_completeness.sh"
echo "5. Track progress: ./scripts/progress_tracker.sh"

echo ""
echo "💡 Tip: Use the existing Lesson0[1-4] files as reference for content structure"