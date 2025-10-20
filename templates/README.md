# OA TUTORS - Template Usage Guide

## Available Templates

The `/templates/` directory contains standardized LaTeX templates for all lesson materials:

### 1. lesson_template.tex

**Purpose:** Main lesson plan for teachers  
**Use for:** Complete lesson structure with objectives, activities, and timing

**Placeholders to replace:**

- `[SUBJECT]` - Mathematics, Non-Verbal Reasoning, Verbal Reasoning, or English
- `[XX]` - Two-digit lesson number (01, 02, 03...)
- `[LESSON_TITLE]` - Topic name in PascalCase (e.g., NumberOperations)
- `[OBJECTIVE 1/2/3]` - Specific learning objectives
- `[PREREQUISITES]` - Required prior knowledge
- `[MATERIALS]` - Resources needed
- `[INTRODUCTION_CONTENT]` - Lesson opener
- `[TEACHING_CONTENT_1/2]` - Main teaching sections
- `[SECTION_TITLE_1/2]` - Section headings
- `[GUIDED_PRACTICE_ACTIVITY]` - Group activity description
- `[INDEPENDENT_PRACTICE_CONTENT]` - Individual work
- `[ASSESSMENT_POINT_1/2]` - Key assessment criteria

### 2. student_notes_template.tex

**Purpose:** Reference material for students  
**Use for:** Key concepts, methods, and quick reference guides

**Placeholders to replace:**

- All basic placeholders from lesson template plus:
- `[LEARNING_POINT_1/2/3]` - What students will learn
- `[CONCEPT_1/2]` - Main concept headings
- `[KEY_CONCEPT_EXPLANATION_1/2]` - Concept explanations
- `[EXAMPLE_1/2]` - Worked examples
- `[METHOD_NAME]` - Step-by-step method name
- `[STEP_1/2/3]` - Method steps
- `[HELPFUL_TIP_1]` - Student tips
- `[MISTAKE_1/2/3]` - Common errors to avoid
- `[TERM_1/2/3]` - Key vocabulary
- `[DEFINITION_1/2/3]` - Term definitions

### 3. homework_template.tex

**Purpose:** Practice exercises for students  
**Use for:** Homework assignments with varied difficulty levels

**Placeholders to replace:**

- All basic placeholders plus:
- `[MATERIALS]` - What students need
- `[WARM_UP_QUESTION_1/2/3]` - Review questions
- `[PRACTICE_QUESTION_1-5]` - Core practice questions
- `[CHALLENGE_QUESTION_1/2]` - Advanced questions

### 4. teacher_answer_key_template.tex

**Purpose:** Complete solutions and teaching guidance  
**Use for:** Answer keys with pedagogical support

**Placeholders to replace:**

- All homework placeholders plus:
- `[KEY_POINTS]` - Main learning points
- `[DIFFICULTIES]` - Common student struggles
- `[TIME_GUIDE]` - Suggested timing
- `[ASSESSMENT]` - Assessment opportunities
- `[ANSWER_1-10]` - Question answers
- `[EXPLANATION_1-3]` - Answer explanations
- `[STEP_1/2/3]` - Solution steps
- `[ALTERNATIVE_SOLUTIONS]` - Different methods
- `[DETAILED_EXPLANATION_1/2]` - Challenge explanations
- `[COMMON_ERROR_1]` - Typical mistakes
- `[SOLUTION_STRATEGY]` - How to help
- `[EXTENSION_IDEA_1/2/3]` - Extra activities
- `[INTERVENTION_1/2]` - Support strategies

### 5. extension_activity_template.tex

**Purpose:** Advanced activities for early finishers  
**Use for:** Enrichment and deeper exploration

**Placeholders to replace:**

- All basic placeholders plus:
- `[CHALLENGE_TITLE_1/2]` - Challenge names
- `[CHALLENGE_DESCRIPTION_1/2]` - Challenge descriptions
- `[TASK_STEP_1/2/3]` - Task instructions
- `[RESEARCH_QUESTION]` - Investigation focus
- `[INVESTIGATION_POINT_1/2/3]` - What to find out
- `[METHOD_STEP_1/2/3]` - Investigation methods
- `[CREATIVE_OPTION_A/B/C]` - Creative task options
- `[CREATIVE_TASK_A/B/C]` - Creative task descriptions
- `[REAL_WORLD_CONNECTION]` - Practical applications
- `[SCIENCE/HISTORY/ART_LINK]` - Cross-curricular connections

## Quick Start Guide

### Creating a New Lesson Set

1. **Copy templates** to the appropriate subject folder (MA/, NVR/, VR/, EN/)
2. **Rename files** following the naming convention:

   - `Lesson[XX]_[TopicName].tex`
   - `StudentNotes_Lesson[XX]_[TopicName].tex`
   - `Homework_Lesson[XX]_[TopicName].tex`
   - `Teacher_AnswerKey_Lesson[XX]_[TopicName].tex`
   - `ExtensionActivity_Lesson[XX]_[TopicName].tex`

3. **Replace placeholders** with actual content
4. **Compile** LaTeX files to check formatting
5. **Review** for consistency and completeness

### Example Usage

For Mathematics Lesson 05 on Roman Numerals:

```bash
# Copy templates
cp templates/lesson_template.tex MA/Lesson05_RomanNumerals.tex
cp templates/student_notes_template.tex MA/StudentNotes_Lesson05_RomanNumerals.tex
cp templates/homework_template.tex MA/Homework_Lesson05_RomanNumerals.tex
cp templates/teacher_answer_key_template.tex MA/Teacher_AnswerKey_Lesson05_RomanNumerals.tex
cp templates/extension_activity_template.tex MA/ExtensionActivity_Lesson05_RomanNumerals.tex

# Edit placeholders in each file
# [SUBJECT] → Mathematics
# [XX] → 05
# [LESSON_TITLE] → Roman Numerals
# etc.
```

## Quality Standards

Each complete lesson set must include:

- ✅ Lesson plan with clear objectives and timing
- ✅ Student notes with key concepts and examples
- ✅ Homework with varied difficulty levels
- ✅ Teacher answer key with pedagogical guidance
- ✅ Extension activity for advanced students
- ✅ Consistent OA Tutors branding and formatting
- ✅ Professional appearance when compiled to PDF

## Template Maintenance

- **Version Control:** Templates are version controlled with the curriculum
- **Updates:** Template improvements should be applied to all future lessons
- **Feedback:** Report template issues or suggestions for improvements
- **Consistency:** All lessons should use current template versions

---

**Last Updated:** October 11, 2025  
**Maintained By:** OA Tutors Curriculum Team
