# Data
library('tidyverse')

# Import data
survey <- read.csv('NecternalData/Data.csv')

# Remove description row and filter columns to the necessary data
surveyFiltered <- survey[-c(1, 2), -c(1:17)] %>%
  mutate_all(na_if, '') %>%
  drop_na(Q1, Q35, Q36)

# Rename columns for easier identification
surveyFiltered <- surveyFiltered %>%
  rename('Weight' = 'Q36',
         'Name' = 'Q1',
         'Phone' = 'Q2',
         'Email' = 'Q3',
         'Age' = 'Q8',
         'Height' = 'Q35',
         'Gender' = 'Q7',
         'Pregnant' = 'Q9',
         'BirthControl' = 'Q28',
         'Exercise' = 'Q4',
         'ExerciseIntensity' = 'Q5',
         'ActivityLevel' = 'Q6',
         'DietarySupplements' = 'Q10',
         'SupplementNames' = 'Q11',
         'Medication' = 'Q12',
         'MedicationName' = 'Q13',
         'EnergyDrinks' = 'Q19',
         'EnergyDrinkFrequency' = 'Q20',
         'AbstainFromEnergyDrinks' = 'Q29',
         'Tobacco' = 'Q14',
         'IllicitDrugs' = 'Q15',
         'MedicalConditions' = 'Q24',
         'OtherConditions' = 'Q26',
         'DietRank' = 'Q16',
         'DietTrend' = 'Q15.1',
         'EatOutFrequency' = 'Q14.1',
         'CaffeineDrinksFreq' = 'Q33',
         'StudyParticipationPills' = 'Q21',
         'Local' = 'Q34',
         'StudyParticipationBlood' = 'Q22',
         'FurtherStudyInterest' = 'Q30')

substring(surveyFiltered$Height, 2, 2) = '\'' # Some of the heights had a back quote instead of apostrophe
surveyFiltered$Weight <- gsub('[^0-9.-]', '', surveyFiltered$Weight) # Standardize weight
surveyFiltered$Weight <- as.numeric(surveyFiltered$Weight)
surveyFiltered$Age <- as.numeric(surveyFiltered$Age)

# Calculating BMI
surveyFiltered <- surveyFiltered %>%
  separate('Height', c('Feet', 'Inches'), sep = '\'') %>% # Row 69 only put in 5 for height, no inches
  mutate(Feet = as.numeric(Feet) * 12) %>%
  mutate(Inches = gsub('[^0-9.-]', '', Inches)) %>% # Remove single and double quotes at end of number
  mutate(Inches = as.numeric(Inches)) %>%
  mutate(Inches = replace_na(Inches, 0)) %>%
  mutate(Height = Feet + Inches) %>%
  mutate(BMI = round((Weight / Height^2) * 703, 2)) %>%
  select(-c('Feet', 'Inches')) %>%
  relocate(c(Height, BMI), .after = Weight)

# Explode columns: Activity level, Supplement Names, Medication Name, Medical Conditions, Other Conditions, Diet Trend
surveyFiltered <- surveyFiltered %>%
  separate(ActivityLevel, into = c('A'))

# write.csv(surveyFiltered, 'Selection.csv')

# Criteria
# BMI preference:
  # Men: >25
  # Women: >30
# Not pregnant

qualified <- surveyFiltered %>%
  filter((Gender == 'Male' & BMI >= 25) | 
         Gender == 'Female' & BMI >= 30) %>%
  mutate(Pregnant = ifelse(is.na(Pregnant), "No", Pregnant))

# write.csv(qualified, 'FilteredSelection.csv')
