/*

Part 2:

1. Write a single SQL query that breaks up the users based on the month that they signed up (their
 cohort month), and determines the percentage of users that have a completed exercise in their
 first month for each monthly cohort (e.g., the 2018 January cohort has x% of users completing
 an exercise in their first month, 2018 February cohort has x% of users completing an exercise in
 their first month, etc.).
 Steps:
 1. Query all users who have completed at least one exercise in their first month and cohorts.
 2. Then, group them all into cohorts and the number of users that have completed at least one exercise is shown.
 3. Find the number of users in each cohort.
 4. The ratio of the numbers found in step 2 to the numbers found in step 3 will give the proportion of each cohort
    that has completed an exercise within a month of account creation.

 Assumptions:
 A. The query takes exercises taken within one full month of account creation.
 B. The percentages are rounded to the nearest 0.1%.
*/

WITH exercise_counts AS (SELECT user_id, created_at, COUNT(*) AS count FROM exercises RIGHT JOIN users ON
            users.user_id = exercises.user_id WHERE exercise_completion_date < DATE_ADD(created_at, INTERVAL 1 MONTH)
            GROUP BY user_id HAVING count >= 1),
            month_counts AS (SELECT CONCAT(MONTHNAME(created_at), " ", YEAR(created_at)) AS cohort,
									COUNT(*) AS count FROM exercise_counts WHERE count > 0 GROUP BY cohort),
            user_cohorts AS (SELECT CONCAT(MONTHNAME(created_at), " ", YEAR(created_at)) AS cohort, COUNT(*) AS total FROM users GROUP BY cohort)
            SELECT user_cohorts.cohort, (CASE WHEN month_counts.count IS NULL THEN 0.0 ELSE ROUND(100 * month_counts.count / total, 1) END) AS percent
            FROM month_counts RIGHT JOIN user_cohorts ON month_counts.cohort = user_cohorts.cohort;

/*
2. How many users completed a given amount of exercises?

Steps:
1. Correlate each user with a count of exercises.
2. Then, separate each count into buckets.

Assumption: The bins are size 10 for the frequency distribution. This distribution will be like a histogram.
*/

WITH exercise_counts AS (SELECT user_id, count(*) AS count FROM exercises GROUP BY user_id),
     buckets AS (SELECT 10 * floor(count / 10.0) AS bucket_floor, count(user_id) AS count FROM exercise_counts
     GROUP BY bucket_floor ORDER BY bucket_floor ASC))
SELECT CONCAT(bucket_floor, " - ", bucket_floor + 9) AS exercises, count FROM buckets;


/* 3. Which organizations have the most severe patient population?

Assumptions:
A. The provider has a one-to-one relationship with its organization.
B. The scores are rounded to the nearest hundredth.
*/
SELECT organization_name AS organization, ROUND(AVERAGE(score), 2) AS average, COUNT(score) AS Count
FROM Phq9 JOIN Providers ON Providers.provider_id = Phq9.provider_id GROUP BY organization_id
ORDER BY Average DESC LIMIT 5;
