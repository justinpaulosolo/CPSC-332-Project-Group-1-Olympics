-- 1.Rise and Fall of Athletic Superpowers

-- This section introduces the major Olympic powers and shows how the leaderboard changed between the beginning and end of our dataset.

-- Question 1: Which countries won the most medals in 1984?

-- Purpose: Establish the starting point of the story.

SELECT c.Name AS country_name,
       COUNT(*) AS medal_count
FROM Medal m
JOIN Olympics o ON m.OlympicID = o.OlympicID
JOIN Country c ON m.CountryCode = c.Code
WHERE o.Year = 1984
GROUP BY c.Name
ORDER BY medal_count DESC
LIMIT 10;

-- Question 2: Which countries won the most medals in 2020?

-- Purpose: Compare the modern Olympic power structure to 1984.

SELECT c.Name AS country_name,
       COUNT(*) AS medal_count
FROM Medal m
JOIN Olympics o ON m.OlympicID = o.OlympicID
JOIN Country c ON m.CountryCode = c.Code
WHERE o.Year = 2020
GROUP BY c.Name
ORDER BY medal_count DESC
LIMIT 10;

-- Question 3: Which country if any medaled in every single games from 1984-2020? (consistent champs)

-- Purpose: Identify consistent Olympic powers across all 10 Games.

SELECT
    c.Name AS country_name,
    m.CountryCode,
    COUNT(DISTINCT o.OlympicID) AS games_medaled
FROM Medal m
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
JOIN Country c
    ON m.CountryCode = c.Code
WHERE o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY c.Name, m.CountryCode
HAVING COUNT(DISTINCT o.OlympicID) = (
    SELECT COUNT(*)
    FROM Olympics
    WHERE Year BETWEEN 1984 AND 2020
      AND Season = 'Summer'
)
ORDER BY c.Name;

-- From 1984 to 2020, 28 countries medaled in every Summer Olympics in the dataset. These countries demonstrate consistent Olympic success across all ten Games studied.

-- Question 4: Which countries improved the most from 1984 to 2020?

-- Purpose: Show rising Olympic nations and shifting dominance.

SELECT
    c.Name AS country_name,
    c.Code AS country_code,
    SUM(CASE WHEN o.Year = 1984 THEN 1 ELSE 0 END) AS medals_1984,
    SUM(CASE WHEN o.Year = 2020 THEN 1 ELSE 0 END) AS medals_2020,
    SUM(CASE WHEN o.Year = 2020 THEN 1 ELSE 0 END)
      - SUM(CASE WHEN o.Year = 1984 THEN 1 ELSE 0 END) AS medal_growth
FROM Country c
JOIN Medal m
    ON c.Code = m.CountryCode
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE o.Year IN (1984, 2020)
  AND o.Season = 'Summer'
GROUP BY c.Name, c.Code
HAVING medals_1984 > 0
   AND medals_2020 > 0
ORDER BY medal_growth DESC
LIMIT 10;

-- 2. Rethinking Medal Counts

-- Question 5: How do athlete medal rows compare to official-style medal counts?

-- Purpose: Explain the difference between raw database medal rows and deduplicated country-event medals.

SELECT
    c.Name AS country_name,
    c.Code AS country_code,
    COUNT(*) AS athlete_medal_rows,
    (
        SELECT COUNT(*)
        FROM (
            SELECT DISTINCT
                m2.OlympicID,
                m2.CountryCode,
                m2.SportID,
                m2.EventName,
                m2.MedalType
            FROM Medal m2
        ) official_medals
        WHERE official_medals.CountryCode = c.Code
    ) AS official_style_medals
FROM Medal m
JOIN Country c
    ON m.CountryCode = c.Code
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY c.Name, c.Code
ORDER BY athlete_medal_rows DESC
LIMIT 10;

-- Question 6: Which countries benefit most from team-event medal rows?

-- Purpose: Show how team sports can inflate medal totals and affect interpretation.

SELECT
    c.Name AS country_name,
    c.Code AS country_code,
    COUNT(*) AS total_medal_rows,
    SUM(CASE WHEN m.IsTeamEvent = TRUE THEN 1 ELSE 0 END) AS team_event_rows,
    ROUND(
        SUM(CASE WHEN m.IsTeamEvent = TRUE THEN 1 ELSE 0 END) / COUNT(*) * 100,
        2
    ) AS team_event_percentage
FROM Medal m
JOIN Country c
    ON m.CountryCode = c.Code
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY c.Name, c.Code
HAVING COUNT(*) >= 25
ORDER BY team_event_percentage DESC
LIMIT 15;

-- 3. Host Country Advantage

-- Hosting the Olympics can affect performance through home-field advantage, larger teams, crowd support, and national investment.

--  Question 7: Do host countries win more medals when they host?

-- Purpose: Compare each host country’s medal count in its host year against its average in non-host years.

SELECT
    c.Name AS host_country,
    o.Year AS host_year,
    o.HostCity,
    COUNT(m.MedalID) AS host_year_medals,
    (
        SELECT ROUND(AVG(non_host.medal_count), 2)
        FROM (
            SELECT
                o2.Year,
                COUNT(m2.MedalID) AS medal_count
            FROM Olympics o2
            LEFT JOIN Medal m2
                ON o2.OlympicID = m2.OlympicID
               AND m2.CountryCode = o.HostCountryCode
            WHERE o2.Season = 'Summer'
              AND o2.Year BETWEEN 1984 AND 2020
              AND o2.Year <> o.Year
            GROUP BY o2.Year
        ) non_host
    ) AS avg_non_host_medals
FROM Olympics o
JOIN Country c
    ON o.HostCountryCode = c.Code
LEFT JOIN Medal m
    ON o.OlympicID = m.OlympicID
   AND m.CountryCode = o.HostCountryCode
WHERE o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY c.Name, o.Year, o.HostCity, o.HostCountryCode
ORDER BY o.Year;

-- 4. Global Expansion of Olympic Success

-- This section moves beyond the top medal countries and asks whether Olympic success became more globally distributed.

-- Question 8: How many countries won their first medal in each Olympic year?

-- Purpose: Identify new countries entering the medal table over time.

SELECT
    first_medal_year,
    COUNT(*) AS first_time_medal_countries
FROM (
    SELECT
        m.CountryCode,
        MIN(o.Year) AS first_medal_year
    FROM Medal m
    JOIN Olympics o
        ON m.OlympicID = o.OlympicID
    WHERE o.Season = 'Summer'
      AND o.Year BETWEEN 1984 AND 2020
    GROUP BY m.CountryCode
) first_medals
WHERE first_medal_year > 1984
GROUP BY first_medal_year
ORDER BY first_medal_year;


-- Question 9: How did medal share by continent change from 1984 to 2020?

-- Purpose: Show whether Olympic success shifted geographically.

SELECT
    c.Continent,
    SUM(CASE WHEN o.Year = 1984 THEN 1 ELSE 0 END) AS medals_1984,
    ROUND(
        SUM(CASE WHEN o.Year = 1984 THEN 1 ELSE 0 END) /
        (
            SELECT COUNT(*)
            FROM Medal m2
            JOIN Olympics o2
                ON m2.OlympicID = o2.OlympicID
            WHERE o2.Year = 1984
              AND o2.Season = 'Summer'
        ) * 100,
        2
    ) AS share_1984,
    SUM(CASE WHEN o.Year = 2020 THEN 1 ELSE 0 END) AS medals_2020,
    ROUND(
        SUM(CASE WHEN o.Year = 2020 THEN 1 ELSE 0 END) /
        (
            SELECT COUNT(*)
            FROM Medal m3
            JOIN Olympics o3
                ON m3.OlympicID = o3.OlympicID
            WHERE o3.Year = 2020
              AND o3.Season = 'Summer'
        ) * 100,
        2
    ) AS share_2020
FROM Medal m
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
JOIN Country c
    ON m.CountryCode = c.Code
WHERE o.Year IN (1984, 2020)
  AND o.Season = 'Summer'
GROUP BY c.Continent
ORDER BY medals_2020 DESC;

-- 5. Wealth, Population, and Olympic Performance

-- Because the base World database includes country population, GNP, continent, life expectancy, and other national data, we can connect Olympic performance to real-world country characteristics.

-- Question 10: Which countries won the most medals per million people?

-- Purpose: Highlight smaller countries that overperform relative to population.

SELECT
    c.Name AS country_name,
    c.Code AS country_code,
    c.Population,
    COUNT(*) AS total_medals,
    ROUND(COUNT(*) / (c.Population / 1000000), 2) AS medals_per_million
FROM Medal m
JOIN Country c
    ON m.CountryCode = c.Code
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE c.Population IS NOT NULL
  AND c.Population > 0
  AND o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY c.Name, c.Code, c.Population
HAVING COUNT(*) >= 10
ORDER BY medals_per_million DESC
LIMIT 15;

-- Question 11: Which countries won the most medals relative to GNP?

-- Purpose: Identify countries that achieved Olympic success despite smaller economies.

SELECT
    c.Name AS country_name,
    c.Code AS country_code,
    c.GNP,
    COUNT(*) AS total_medals,
    ROUND(COUNT(*) / c.GNP * 1000, 2) AS medals_per_1000_gnp
FROM Medal m
JOIN Country c
    ON m.CountryCode = c.Code
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE c.GNP IS NOT NULL
  AND c.GNP > 0
  AND o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY c.Name, c.Code, c.GNP
HAVING COUNT(*) >= 10
ORDER BY medals_per_1000_gnp DESC
LIMIT 15;

-- Question 12: Do countries with above-average GNP win more medals?

-- Purpose: Test whether wealthier countries tend to dominate Olympic results.

SELECT
    CASE
        WHEN c.GNP >= (
            SELECT AVG(GNP)
            FROM Country
            WHERE GNP IS NOT NULL
              AND GNP > 0
        )
        THEN 'Above Average GNP'
        ELSE 'Below Average GNP'
    END AS gnp_group,
    COUNT(DISTINCT c.Code) AS countries_with_medals,
    COUNT(*) AS medal_rows,
    ROUND(COUNT(*) / COUNT(DISTINCT c.Code), 2) AS medals_per_country
FROM Medal m
JOIN Country c
    ON m.CountryCode = c.Code
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE c.GNP IS NOT NULL
  AND c.GNP > 0
  AND o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY gnp_group;

--  6. The Gender Revolution

-- Women’s Olympic participation and success expanded significantly across the modern Olympic period. This section explores how female medal success changed from 1984 to 2020.

-- Question 13: What is the overall male-to-female medalist ratio?

-- Purpose: Measure gender balance across all medal rows in the dataset.

SELECT
    SUM(CASE WHEN a.Gender = 'M' THEN 1 ELSE 0 END) AS male_medalists,
    SUM(CASE WHEN a.Gender = 'F' THEN 1 ELSE 0 END) AS female_medalists,
    ROUND(
        SUM(CASE WHEN a.Gender = 'M' THEN 1 ELSE 0 END) /
        SUM(CASE WHEN a.Gender = 'F' THEN 1 ELSE 0 END),
        2
    ) AS male_to_female_ratio
FROM Medal m
JOIN Athlete a
    ON m.AthleteID = a.AthleteID
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer';

-- Question 14: Which countries won the most female medals?

-- Purpose: Identify countries leading in women’s Olympic success.

SELECT
    c.Name AS country_name,
    c.Code AS country_code,
    COUNT(*) AS female_medals
FROM Medal m
JOIN Athlete a
    ON m.AthleteID = a.AthleteID
JOIN Country c
    ON m.CountryCode = c.Code
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE a.Gender = 'F'
  AND o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY c.Name, c.Code
ORDER BY female_medals DESC
LIMIT 10;

-- Question 15: Which countries had more female medalists than male medalists?

-- Purpose: Show countries where women drove Olympic success.

SELECT
    c.Name AS country_name,
    c.Code AS country_code,
    SUM(CASE WHEN a.Gender = 'F' THEN 1 ELSE 0 END) AS female_medals,
    SUM(CASE WHEN a.Gender = 'M' THEN 1 ELSE 0 END) AS male_medals,
    SUM(CASE WHEN a.Gender = 'F' THEN 1 ELSE 0 END)
      - SUM(CASE WHEN a.Gender = 'M' THEN 1 ELSE 0 END) AS female_medal_advantage
FROM Medal m
JOIN Athlete a
    ON m.AthleteID = a.AthleteID
JOIN Country c
    ON m.CountryCode = c.Code
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY c.Name, c.Code
HAVING female_medals > male_medals
ORDER BY female_medal_advantage DESC;

-- Question 16: In what year did each country win its first female medal in our dataset?

-- Purpose: Track the spread of women’s medal success across countries over time.

SELECT
    c.Name AS country_name,
    c.Code AS country_code,
    MIN(o.Year) AS first_female_medal_year,
    COUNT(*) AS total_female_medals
FROM Medal m
JOIN Athlete a
    ON m.AthleteID = a.AthleteID
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
JOIN Country c
    ON m.CountryCode = c.Code
WHERE a.Gender = 'F'
  AND o.Season = 'Summer'
  AND o.Year BETWEEN 1984 AND 2020
GROUP BY c.Name, c.Code
ORDER BY first_female_medal_year, total_female_medals DESC;

-- 7. New Sports and New Opportunities

-- The Olympic program changed between 1984 and 2020. New sports created new paths for countries to win medals and sometimes allowed different nations to become dominant.

-- Question 17: Which sports were added after 1984?

-- Purpose: Identify how the Olympic program expanded.

SELECT
    SportName,
    FirstYear
FROM Sport
WHERE FirstYear > 1984
ORDER BY FirstYear, SportName;

-- Question 18: Which countries won the most medals in newly added sports?

-- Purpose: Show which countries benefited most from new Olympic opportunities.

SELECT
    c.Name AS country_name,
    c.Code AS country_code,
    COUNT(*) AS medals_in_new_sports
FROM Medal m
JOIN Sport s
    ON m.SportID = s.SportID
JOIN Country c
    ON m.CountryCode = c.Code
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE s.FirstYear > 1984
  AND o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY c.Name, c.Code
ORDER BY medals_in_new_sports DESC
LIMIT 10;

-- Question 19: Which country dominated each newly added sport?

-- Purpose: Connect each new sport to its strongest medal-winning country.

SELECT
    ranked.SportName,
    ranked.FirstYear,
    ranked.country_name,
    ranked.country_code,
    ranked.medal_count
FROM (
    SELECT
        s.SportName,
        s.FirstYear,
        c.Name AS country_name,
        c.Code AS country_code,
        COUNT(*) AS medal_count,
        RANK() OVER (
            PARTITION BY s.SportID
            ORDER BY COUNT(*) DESC
        ) AS sport_rank
    FROM Medal m
    JOIN Sport s
        ON m.SportID = s.SportID
    JOIN Country c
        ON m.CountryCode = c.Code
    JOIN Olympics o
        ON m.OlympicID = o.OlympicID
    WHERE s.FirstYear > 1984
      AND o.Year BETWEEN 1984 AND 2020
      AND o.Season = 'Summer'
    GROUP BY s.SportID, s.SportName, s.FirstYear, c.Name, c.Code
) ranked
WHERE ranked.sport_rank = 1
ORDER BY ranked.FirstYear, ranked.SportName;

-- 8. Country Specialization

-- Some countries succeed broadly across many sports, while others dominate a smaller number of events. This section shows whether Olympic success comes from depth or specialization.

-- Question 20: Which countries are most specialized in one sport?

-- Purpose: Identify countries whose Olympic identity is strongly tied to one sport.

SELECT
    country_name,
    country_code,
    top_sport,
    top_sport_medals,
    total_medals,
    ROUND(top_sport_medals / total_medals * 100, 2) AS specialization_percentage
FROM (
    SELECT
        c.Name AS country_name,
        c.Code AS country_code,
        s.SportName AS top_sport,
        COUNT(*) AS top_sport_medals,
        (
            SELECT COUNT(*)
            FROM Medal m2
            JOIN Olympics o2
                ON m2.OlympicID = o2.OlympicID
            WHERE m2.CountryCode = c.Code
              AND o2.Year BETWEEN 1984 AND 2020
              AND o2.Season = 'Summer'
        ) AS total_medals,
        RANK() OVER (
            PARTITION BY c.Code
            ORDER BY COUNT(*) DESC
        ) AS sport_rank
    FROM Medal m
    JOIN Country c
        ON m.CountryCode = c.Code
    JOIN Sport s
        ON m.SportID = s.SportID
    JOIN Olympics o
        ON m.OlympicID = o.OlympicID
    WHERE o.Year BETWEEN 1984 AND 2020
      AND o.Season = 'Summer'
    GROUP BY c.Name, c.Code, s.SportName
) ranked
WHERE sport_rank = 1
  AND total_medals >= 20
ORDER BY specialization_percentage DESC
LIMIT 15;