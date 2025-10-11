# OA TUTORS - 11+ CURRICULUM FILE MANAGEMENT SYSTEM

## Suggested Naming Convention

### Directory Structure
```
11+/
├── MA/          (Mathematics)
├── NVR/         (Non-Verbal Reasoning)  
├── VR/          (Verbal Reasoning)
├── ENG/         (English)
└── docs/        (Documentation & Resources)
```

### File Naming Convention

**Format:** `[DocumentType]_Lesson[XX]_[TopicName].[ext]`

Where:
- `[DocumentType]` = Lesson | StudentNotes | Homework | Teacher_AnswerKey | ExtensionActivity
- `[XX]` = Two-digit lesson number (01, 02, 03...)
- `[TopicName]` = Descriptive topic name in PascalCase
- `[ext]` = File extension (.tex, .pdf, .md, etc.)

### Examples by Document Type

#### 1. LESSON PLANS
- `Lesson01_NumberOperations.tex`
- `Lesson02_PlaceValue.tex`
- `Lesson01_ShapePuzzles.tex` (NVR)
- `Lesson01_Synonyms.tex` (VR)

#### 2. STUDENT NOTES
- `StudentNotes_Lesson01_NumberOperations.tex`
- `StudentNotes_Lesson02_PlaceValue.tex`
- `StudentNotes_Lesson01_ShapePuzzles.tex` (NVR)

#### 3. HOMEWORK EXERCISES
- `Homework_Lesson01_NumberOperations.tex`
- `Homework_Lesson02_PlaceValue.tex`
- `Homework_Lesson01_ShapePuzzles.tex` (NVR)

#### 4. TEACHER ANSWER KEYS
- `Teacher_AnswerKey_Lesson01_NumberOperations.tex`
- `Teacher_AnswerKey_Lesson02_PlaceValue.tex`
- `Teacher_AnswerKey_Lesson01_ShapePuzzles.tex` (NVR)

#### 5. EXTENSION ACTIVITIES
- `ExtensionActivity_Lesson01_NumberOperations.tex`
- `ExtensionActivity_Lesson02_PlaceValue.tex`
- `ExtensionActivity_Lesson01_ShapePuzzles.tex` (NVR)

### Subject-Specific Numbering

#### MATHEMATICS (MA/)
**Unit 1: Numbers (Lessons 01-12)**
- Lesson01_NumberOperations
- Lesson02_PlaceValue
- Lesson03_NumberProperties
- Lesson04_NumberPatterns
- Lesson05_RomanNumerals
- Lesson06_Rounding
- Lesson07_WordProblems
- Lesson08_FractionsDecimalsPercentages
- Lesson09_FactorsMultiples
- Lesson10_Indices
- Lesson11_NumberLines
- Lesson12_UnitaryMethods

**Unit 2: Algebra (Lessons 13-21)**
- Lesson13_SimplifyingExpressions
- Lesson14_Equations
- Lesson15_SimultaneousEquations
- Lesson16_Substitution
- Lesson17_InverseOperations
- Lesson18_Sequences
- Lesson19_FunctionMachines
- Lesson20_BIDMAS
- Lesson21_AlgebraWordProblems

**Unit 3: Measurement (Lessons 22-25)**
- Lesson22_LengthAreaPerimeter
- Lesson23_VolumeCapacity
- Lesson24_UnitConversions
- Lesson25_SpeedDistanceTime

**Unit 4: Geometry (Lessons 26-37)**
- Lesson26_Angles
- Lesson27_Shapes
- Lesson28_Symmetry
- Lesson29_Lines
- Lesson30_Polygons
- Lesson31_Nets
- Lesson32_Transformations
- Lesson33_Pythagoras
- Lesson34_Bearings
- Lesson35_Circles
- Lesson36_Triangles
- Lesson37_Coordinates

**Unit 5: Statistics (Lessons 38-43)**
- Lesson38_DataCollection
- Lesson39_GraphTypes
- Lesson40_VennDiagrams
- Lesson41_CentralTendency
- Lesson42_TallyMarks
- Lesson43_DistanceTimeTables

**Unit 6: Ratio/Proportion/Probability (Lessons 44-46)**
- Lesson44_RatiosProportions
- Lesson45_BasicProbability
- Lesson46_PermutationsCombinations

#### NON-VERBAL REASONING (NVR/)
- Lesson01_ShapePuzzles
- Lesson02_PatternCompletion
- Lesson03_SeriesCompletion
- Lesson04_Analogies
- Lesson05_Classification
- Lesson06_Matrices
- Lesson07_Rotations
- Lesson08_Reflections
- Lesson09_Codes
- Lesson10_3DShapes

#### VERBAL REASONING (VR/)
- Lesson01_Synonyms
- Lesson02_Antonyms
- Lesson03_Analogies
- Lesson04_WordClassification
- Lesson05_CodeBreaking
- Lesson06_LogicalDeduction
- Lesson07_ComprehensionSkills
- Lesson08_VocabularyBuilding

#### ENGLISH (ENG/)
- Lesson01_CreativeWriting
- Lesson02_Comprehension
- Lesson03_Grammar
- Lesson04_Punctuation
- Lesson05_Vocabulary
- Lesson06_Poetry
- Lesson07_EssayWriting
- Lesson08_ProofReading

### Support Files

#### Planning Documents
- `README.md` - Master curriculum overview
- `plan.txt` - Detailed syllabus breakdown
- `progress.md` - Completion tracking

#### Resources
- `oatutors_logo.png` - Brand logo for documents
- `templates/` - Document templates
- `images/` - Educational graphics and diagrams

### Version Control Best Practices

#### File Status Indicators
Add suffixes for development status:
- `_DRAFT.tex` - Work in progress
- `_REVIEW.tex` - Ready for review
- `_FINAL.tex` - Approved version
- `_ARCHIVE.tex` - Outdated versions

#### Backup Strategy
- Keep compiled PDFs separate from source files
- Regular backups of entire curriculum structure
- Version control using Git recommended

### Quality Standards

#### Every Complete Lesson Must Have:
1. `Lesson[XX]_[TopicName].tex` - Main lesson plan
2. `StudentNotes_Lesson[XX]_[TopicName].tex` - Student reference
3. `Homework_Lesson[XX]_[TopicName].tex` - Practice exercises  
4. `Teacher_AnswerKey_Lesson[XX]_[TopicName].tex` - Solutions & guidance
5. `ExtensionActivity_Lesson[XX]_[TopicName].tex` - Activities for early finishers

#### Branding Requirements:
- OA Tutors logo and watermark
- Consistent headers and footers
- Professional color scheme
- Website reference: https://oatutors.co.uk/

### Current Status (Updated: October 11, 2025)

#### COMPLETED LESSONS:
**Mathematics (MA/):**
✅ Lesson01_NumberOperations - Complete set (4 files)
✅ Lesson02_PlaceValue - Complete set (4 files)  
✅ Lesson03_NumberProperties - Complete set (4 files)
✅ Lesson04_NumberPatterns - Complete set (4 files)

**Non-Verbal Reasoning (NVR/):**
✅ Lesson01_ShapePuzzles - Complete set (4 files)

#### IN PROGRESS:
- Mathematics Unit 1: 4/12 lessons completed
- Remaining 42 mathematics lessons pending
- 9 additional NVR lessons pending
- VR and ENG units not started

### File Management Tools

#### Useful Commands:
```bash
# List all lesson files in order
ls -la Lesson*.tex | sort

# Find all incomplete lessons (missing student notes)
find . -name "Lesson*.tex" | while read lesson; do
  base=$(basename "$lesson" .tex)
  if [ ! -f "StudentNotes_${base}.tex" ]; then
    echo "Missing StudentNotes for: $base"
  fi
done

# Count completed lesson sets
find . -name "Lesson*.tex" | wc -l
```

### Recommended Next Steps:
1. Complete remaining Numbers unit lessons (Lessons 05-12)
2. Develop additional NVR lessons (Lessons 02-10)
3. Begin Algebra unit development
4. Create master index documents for easy navigation
5. Implement automated quality checks for completeness

---

**Document Version:** 1.0  
**Last Updated:** October 11, 2025  
**Maintained By:** OA Tutors Curriculum Team  
**Website:** https://oatutors.co.uk/