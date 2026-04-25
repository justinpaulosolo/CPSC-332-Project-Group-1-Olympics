-- Top 10 medal-winning counties in 1984 and 2020; how does it campare to 1984 and 2020?
-- 1984
SELECT c.Name AS country_name,
       COUNT(*) AS medal_count
FROM Medal m
JOIN Olympics o ON m.OlympicID = o.OlympicID
JOIN Country c ON m.CountryCode = c.Code
WHERE o.Year = 1984
GROUP BY c.Name
ORDER BY medal_count DESC
LIMIT 10;

-- 2020
SELECT c.Name AS country_name,
       COUNT(*) AS medal_count
FROM Medal m
JOIN Olympics o ON m.OlympicID = o.OlympicID
JOIN Country c ON m.CountryCode = c.Code
WHERE o.Year = 2020
GROUP BY c.Name
ORDER BY medal_count DESC
LIMIT 10;

-- Which country if any medaled in every single games from 1984-2020? (consistent champs)
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

-- Most improved country? (Growth in medal count)
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

-- Male to female medalist ratio?
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

-- Which country won the most female medals?
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

-- Are there country where females athletes won more medals than male athletes?
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

-- Which sports were added after 1984?
SELECT
    SportName,
    FirstYear
FROM Sport
WHERE FirstYear > 1984
ORDER BY FirstYear, SportName;

-- Which country has won the most medal in the new added sports? (Who dominated each of the new sports?)
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

-- Which country medaled in the largest number of different sports?
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