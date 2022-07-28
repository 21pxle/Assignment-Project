"Assessment Answers:
  Part 1:
  a.	Some Insights:
  (i)     Most patients have only taken a few anxiety tests at most, but there are some who took several tests to
          gauge their mental health.
  (ii)	There is a small negative correlation (-0.10) between the number of tests taken and the GAD-7 score.
  (iii)   The mean reduction in the GAD-7 score is about 0.54 points, but the change in score can vary widely, as
          shown on the next point. In addition, the median change in the anxiety score is 0.
  (iv)	The standard deviation of the change in anxiety score (from the first test to the most recent test) is
        around 3.62. In other words, the 95% confidence interval of the change in score ranges from -7.78 to 6.70.
  (v)		More tests are taken over time until there was a peak of the number of tests in April 2020.
  (vi)    Only 17% of tests indicated that a further clinical evaluation is required.
  (vii)   Out of the tests that required further clinical evaluation, about 36% of them are severe.

b.	Some fields that would be important to collect are:
  (i) Recent traumas or events, if any, that would cause the patient to score high on the GAD-7 assessment.
    - There may be some connection between recent traumas or events and the countermeasures provided that
      could reduce the GAD-7 score. If there is such a connection, the responses would give an idea about which
      problem to prioritize, and which countermeasures would improve their mental health.
  (ii) Comorbidities relating to the GAD-7 assessments, such as PTSD.
    - GAD-7 assessments do not only assess general anxiety disorder, but it may also reveal factors of other
    comorbidities such as PTSD, bipolar disorder, and ASD.
  (iii) Exercises or countermeasures that were implemented before the test was taken, if any.
    - Without that information, it would be difficult to gauge progress on whether therapy would work.
c.	Assumptions:
  (i) The change in GAD-7 score reflects progress between the first and the most recent test, and
      does not necessarily take into account tests in between.
  (ii) It also doesn't take into account the individual situations that may occur between the
      first and the most recent test.
"

tests <- read.csv("phq_all_final.csv")
patients <- unique(tests$patient_id)
num_tests <- sapply(patients, function(id) {
  length(tests$score[tests$patient_id == id])
})
change_in_scores <- sapply(patients, function(id) {
  scores = tests$score[tests$patient_id == id]
  scores[length(scores)] - scores[1]
})

data <- data.frame(Tests = num_tests, Score_Difference = change_in_scores)
plot(data$Tests, data$Score_Difference, main = "Number of Tests vs. Change in GAD-7 Score",
     xlab = "Number of Tests", ylab = "Change in GAD-7 Score")

model <- change_in_scores ~ num_tests
points(data$Tests, data$Score_Difference, pch = 16)

hist(change_in_scores, main="Distribution of Change in Scores", xlab="Change in Scores",
     ylab="Number of Users", breaks=seq(-22,22,2), xaxp=c(-22,22,22), col='red')
