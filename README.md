# CPSC 332 - Spring 2026 Project

## Group 1 - Olympics & World Database

### Team Members
- Justin Alvarez
- Ian Hernandez
- Avery Miclea
- Vince Saldana
- Justin Solo

## Data Source

The data for this project is sourced from [Olympic Historical Dataset from Olympedia.org](https://www.kaggle.com/datasets/josephcheng123456/olympic-historical-dataset-from-olympediaorg) on Kaggle.

## Diagram and Whiteboard

[Excalidraw Diagram](https://excalidraw.com/#room=a80da5f3e1d8f795ee98,WHxZB9AY7j0H88N3n3TaNA)

## Notes

### What story are we trying to tell?

**The Evolution of the Summer Olympics(1984-2020)**

From Los Angeles 1984 to Tokyo 2020, the Summer Olympics changed in size, geography, gender balance, and competitive power. Our database lets us investigate how Olympic success shifted across countries, continents, economies, genders, and sports over 10 consecutive Summer Games.

> How has global athletic competition changed from 1984 to 2020, and which countries benefited most from those changes?

---

## 1.Rise and Fall of Athletic Superpowers

This section introduces the major Olympic powers and shows how the leaderboard changed between the beginning and end of our dataset.

### Question 1: Which countries won the most medals in 1984?

Purpose: Establish the starting point of the story.

```sql
SELECT c.Name AS country_name,
       COUNT(*) AS medal_count
FROM Medal m
JOIN Olympics o ON m.OlympicID = o.OlympicID
JOIN Country c ON m.CountryCode = c.Code
WHERE o.Year = 1984
GROUP BY c.Name
ORDER BY medal_count DESC
LIMIT 10;
```

| country\_name | medal\_count |
| :--- | :--- |
| United States | 359 |
| Germany | 163 |
| Romania | 106 |
| Canada | 90 |
| Yugoslavia | 88 |
| China | 78 |
| United Kingdom | 76 |
| France | 68 |
| Italy | 64 |
| Australia | 55 |

### Question 2: Which countries won the most medals in 2020?

Purpose: Compare the modern Olympic power structure to 1984.

```sql
SELECT c.Name AS country_name,
       COUNT(*) AS medal_count
FROM Medal m
JOIN Olympics o ON m.OlympicID = o.OlympicID
JOIN Country c ON m.CountryCode = c.Code
WHERE o.Year = 2020
GROUP BY c.Name
ORDER BY medal_count DESC
LIMIT 10;
```

| country\_name | medal\_count |
| :--- | :--- |
| United States | 297 |
| Russian Federation | 148 |
| China | 145 |
| France | 138 |
| United Kingdom | 132 |
| Japan | 131 |
| Australia | 130 |
| Canada | 85 |
| Germany | 79 |
| Italy | 76 |

### Question 3: Which country if any medaled in every single games from 1984-2020? (consistent champs)

Purpose: Identify consistent Olympic powers across all 10 Games.

```sql
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

```
| country\_name | CountryCode | games\_medaled |
| :--- | :--- | :--- |
| Australia | AUS | 10 |
| Belgium | BEL | 10 |
| Brazil | BRA | 10 |
| Canada | CAN | 10 |
| China | CHN | 10 |
| Denmark | DNK | 10 |
| Finland | FIN | 10 |
| France | FRA | 10 |
| Germany | DEU | 10 |
| Greece | GRC | 10 |
| Italy | ITA | 10 |
| Jamaica | JAM | 10 |
| Japan | JPN | 10 |
| Kenya | KEN | 10 |
| Mexico | MEX | 10 |
| Morocco | MAR | 10 |
| Netherlands | NLD | 10 |
| New Zealand | NZL | 10 |
| Norway | NOR | 10 |
| Romania | ROM | 10 |
| South Korea | KOR | 10 |
| Spain | ESP | 10 |
| Sweden | SWE | 10 |
| Switzerland | CHE | 10 |
| Thailand | THA | 10 |
| Turkey | TUR | 10 |
| United Kingdom | GBR | 10 |
| United States | USA | 10 |

> From 1984 to 2020, 28 countries medaled in every Summer Olympics in the dataset. These countries demonstrate consistent Olympic success across all ten Games studied.

### Question 4: Which countries improved the most from 1984 to 2020?

Purpose: Show rising Olympic nations and shifting dominance.

```sql
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
```
| country\_name | country\_code | medals\_1984 | medals\_2020 | medal\_growth |
| :--- | :--- | :--- | :--- | :--- |
| Japan | JPN | 49 | 131 | 82 |
| Australia | AUS | 55 | 130 | 75 |
| France | FRA | 68 | 138 | 70 |
| China | CHN | 78 | 145 | 67 |
| United Kingdom | GBR | 76 | 132 | 56 |
| Spain | ESP | 19 | 70 | 51 |
| New Zealand | NZL | 23 | 65 | 42 |
| Netherlands | NLD | 41 | 72 | 31 |
| Dominican Republic | DOM | 1 | 32 | 31 |
| Belgium | BEL | 5 | 27 | 22 |

> Because some **historical countries** changed names, split apart, or competed under different Olympic identities, this query only includes countries that medaled in both 1984 and 2020.
>
> This prevents countries with no direct 1984 comparison from being ranked as “most improved.” Using this method, **Japan** had the largest growth, increasing from **49 medal rows in 1984** to **131 medal rows in 2020**.

---

## 2. Rethinking Medal Counts

Before drawing conclusions, we need to explain how our database counts medals. Since team events give one medal row per athlete, some countries may look stronger when counting athlete medal rows instead of official country medals.

### Question 5: How do athlete medal rows compare to official-style medal counts?

Purpose: Explain the difference between raw database medal rows and deduplicated country-event medals.

```sql
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
```

| country\_name | country\_code | athlete\_medal\_rows | official\_style\_medals |
| :--- | :--- | :--- | :--- |
| United States | USA | 2721 | 1118 |
| Russian Federation | RUS | 1539 | 737 |
| Germany | DEU | 1515 | 617 |
| Australia | AUS | 1099 | 370 |
| China | CHN | 1072 | 635 |
| United Kingdom | GBR | 819 | 401 |
| France | FRA | 723 | 334 |
| Italy | ITA | 643 | 289 |
| Japan | JPN | 633 | 298 |
| Netherlands | NLD | 606 | 194 |


### Question 6: Which countries benefit most from team-event medal rows?

Purpose: Show how team sports can inflate medal totals and affect interpretation.

```sql
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
```

| country\_name | country\_code | total\_medal\_rows | team\_event\_rows | team\_event\_percentage |
| :--- | :--- | :--- | :--- | :--- |
| Fiji Islands | FJI | 39 | 39 | 100.00 |
| Pakistan | PAK | 33 | 32 | 96.97 |
| Argentina | ARG | 255 | 244 | 95.69 |
| Yugoslavia | YUG | 352 | 319 | 90.63 |
| Nigeria | NGA | 118 | 104 | 88.14 |
| Chile | CHL | 28 | 24 | 85.71 |
| Brazil | BRA | 496 | 424 | 85.48 |
| Croatia | HRV | 150 | 126 | 84.00 |
| Denmark | DNK | 220 | 183 | 83.18 |
| Spain | ESP | 499 | 403 | 80.76 |
| Australia | AUS | 1099 | 884 | 80.44 |
| Norway | NOR | 215 | 172 | 80.00 |
| Bahamas | BHS | 38 | 30 | 78.95 |
| Netherlands | NLD | 606 | 478 | 78.88 |
| Dominican Republic | DOM | 39 | 29 | 74.36 |

---

## 3. Host Country Advantage

Hosting the Olympics can affect performance through home-field advantage, larger teams, crowd support, and national investment.

### Question 7: Do host countries win more medals when they host?

Purpose: Compare each host country’s medal count in its host year against its average in non-host years.

```sql
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
```

| host\_country | host\_year | HostCity | host\_year\_medals | avg\_non\_host\_medals |
| :--- | :--- | :--- | :--- | :--- |
| United States | 1984 | Los Angeles | 359 | 262.44 |
| South Korea | 1988 | Seoul | 82 | 55.22 |
| Spain | 1992 | Barcelona | 74 | 47.22 |
| United States | 1996 | Atlanta | 263 | 273.11 |
| Australia | 2000 | Sydney | 183 | 101.78 |
| Greece | 2004 | Athina | 31 | 7.00 |
| China | 2008 | Beijing | 186 | 98.44 |
| United Kingdom | 2012 | London | 128 | 76.78 |
| Brazil | 2016 | Rio de Janeiro | 56 | 48.89 |
| Japan | 2020 | Tokyo | 131 | 55.78 |

---

## 4. Global Expansion of Olympic Success

This section moves beyond the top medal countries and asks whether Olympic success became more globally distributed.

### Question 8: How many countries won their first medal in each Olympic year?

Purpose: Identify new countries entering the medal table over time.

```sql
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
```

| first\_medal\_year | first\_time\_medal\_countries |
| :--- | :--- |
| 1988 | 17 |
| 1992 | 15 |
| 1996 | 18 |
| 2000 | 8 |
| 2004 | 4 |
| 2008 | 8 |
| 2012 | 6 |
| 2016 | 3 |
| 2020 | 4 |

### Question 9: How did medal share by continent change from 1984 to 2020?

Purpose: Show whether Olympic success shifted geographically.

```sql
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
```

| Continent | medals\_1984 | share\_1984 | medals\_2020 | share\_2020 |
| :--- | :--- | :--- | :--- | :--- |
| Europe | 717 | 47.36 | 1116 | 45.89 |
| North America | 467 | 30.85 | 483 | 19.86 |
| Asia | 193 | 12.75 | 461 | 18.96 |
| Oceania | 78 | 5.15 | 221 | 9.09 |
| South America | 42 | 2.77 | 110 | 4.52 |
| Africa | 17 | 1.12 | 41 | 1.69 |

---

## 5. Wealth, Population, and Olympic Performance

Because the base World database includes country population, GNP, continent, life expectancy, and other national data, we can connect Olympic performance to real-world country characteristics.

### Question 10: Which countries won the most medals per million people?

Purpose: Highlight smaller countries that overperform relative to population.

```sql
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
```

| country\_name | country\_code | Population | total\_medals | medals\_per\_million |
| :--- | :--- | :--- | :--- | :--- |
| Bahamas | BHS | 307000 | 38 | 123.78 |
| Jamaica | JAM | 2583000 | 169 | 65.43 |
| Australia | AUS | 18886000 | 1099 | 58.19 |
| New Zealand | NZL | 3862000 | 224 | 58.00 |
| Iceland | ISL | 279000 | 16 | 57.35 |
| Norway | NOR | 4478500 | 215 | 48.01 |
| Fiji Islands | FJI | 817000 | 39 | 47.74 |
| Denmark | DNK | 5330000 | 220 | 41.28 |
| Netherlands | NLD | 15864000 | 606 | 38.20 |
| Hungary | HUN | 10043200 | 351 | 34.95 |
| Croatia | HRV | 4473000 | 150 | 33.53 |
| Yugoslavia | YUG | 10640000 | 352 | 33.08 |
| Cuba | CUB | 11201000 | 354 | 31.60 |
| Sweden | SWE | 8861400 | 257 | 29.00 |
| Germany | DEU | 82164700 | 1515 | 18.44 |


### Question 11: Which countries won the most medals relative to GNP?

Purpose: Identify countries that achieved Olympic success despite smaller economies.

```sql
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
```

| country\_name | country\_code | GNP | total\_medals | medals\_per\_1000\_gnp |
| :--- | :--- | :--- | :--- | :--- |
| Fiji Islands | FJI | 1536 | 39 | 25.39 |
| Jamaica | JAM | 6871 | 169 | 24.6 |
| Yugoslavia | YUG | 17000 | 352 | 20.71 |
| Cuba | CUB | 17843 | 354 | 19.84 |
| Mongolia | MNG | 1043 | 20 | 19.18 |
| Azerbaijan | AZE | 4127 | 49 | 11.87 |
| Bulgaria | BGR | 12178 | 134 | 11 |
| Bahamas | BHS | 3527 | 38 | 10.77 |
| Romania | ROM | 38158 | 402 | 10.54 |
| Kenya | KEN | 9217 | 94 | 10.2 |
| Armenia | ARM | 1813 | 18 | 9.93 |
| Belarus | BLR | 13714 | 128 | 9.33 |
| North Korea | PRK | 5332 | 44 | 8.25 |
| Ethiopia | ETH | 6353 | 48 | 7.56 |
| Croatia | HRV | 20208 | 150 | 7.42 |

### Question 12: Do countries with above-average GNP win more medals?

Purpose: Test whether wealthier countries tend to dominate Olympic results.

```sql
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
```

| gnp\_group | countries\_with\_medals | medal\_rows | medals\_per\_country |
| :--- | :--- | :--- | :--- |
| Above Average GNP | 29 | 15148 | 522.34 |
| Below Average GNP | 100 | 4245 | 42.45 |


### Question 12a: Which medal-winning countries have the largest capital cities?
```sql
SELECT
    c.Name AS country_name,
    cap.Name AS capital_city,
    cap.Population AS capital_population,
    COUNT(*) AS medal_count
FROM Medal m
JOIN Country c
    ON m.CountryCode = c.Code
JOIN City cap
    ON c.Capital = cap.ID
JOIN Olympics o
    ON m.OlympicID = o.OlympicID
WHERE o.Year BETWEEN 1984 AND 2020
  AND o.Season = 'Summer'
GROUP BY c.Name, cap.Name, cap.Population
ORDER BY medal_count DESC
LIMIT 15;
```
| country\_name | capital\_city | capital\_population | medal\_count |
| :--- | :--- | :--- | :--- |
| United States | Washington | 572059 | 2721 |
| Russian Federation | Moscow | 8389200 | 1539 |
| Germany | Berlin | 3386667 | 1515 |
| Australia | Canberra | 322723 | 1099 |
| China | Peking | 7472000 | 1072 |
| United Kingdom | London | 7285000 | 819 |
| France | Paris | 2125246 | 723 |
| Italy | Roma | 2643581 | 643 |
| Japan | Tokyo | 7980230 | 633 |
| Netherlands | Amsterdam | 731200 | 606 |
| South Korea | Seoul | 9981619 | 579 |
| Canada | Ottawa | 335277 | 508 |
| Spain | Madrid | 2879052 | 499 |
| Brazil | Brasília | 1969868 | 496 |
| Romania | Bucuresti | 2016131 | 402 |

### Question 12b: Do countries with more recorded languages win more Olympic medals?
```sql
SELECT
    c.Name AS country_name,
    c.Code AS country_code,
    COUNT(DISTINCT cl.Language) AS language_count,
    COUNT(m.MedalID) AS medal_count
FROM Country c
JOIN CountryLanguage cl
    ON c.Code = cl.CountryCode
LEFT JOIN Medal m
    ON c.Code = m.CountryCode
LEFT JOIN Olympics o
    ON m.OlympicID = o.OlympicID
   AND o.Year BETWEEN 1984 AND 2020
   AND o.Season = 'Summer'
GROUP BY c.Name, c.Code
HAVING medal_count > 0
ORDER BY language_count DESC, medal_count DESC
LIMIT 15;
```

| country\_name | country\_code | language\_count | medal\_count |
| :--- | :--- | :--- | :--- |
| United States | USA | 12 | 32652 |
| Russian Federation | RUS | 12 | 18468 |
| China | CHN | 12 | 12864 |
| Canada | CAN | 12 | 6096 |
| India | IND | 12 | 456 |
| South Africa | ZAF | 11 | 649 |
| Nigeria | NGA | 10 | 1180 |
| Kenya | KEN | 10 | 940 |
| Iran | IRN | 10 | 470 |
| Philippines | PHL | 10 | 80 |
| Uganda | UGA | 10 | 60 |
| Mozambique | MOZ | 10 | 20 |
| Sudan | SDN | 10 | 10 |
| Indonesia | IDN | 9 | 441 |
| Vietnam | VNM | 9 | 45 |

---

## 6. The Gender Revolution

Women’s Olympic participation and success expanded significantly across the modern Olympic period. This section explores how female medal success changed from 1984 to 2020.

### Question 13: What is the overall male-to-female medalist ratio?

Purpose: Measure gender balance across all medal rows in the dataset.

```sql
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
```

| male\_medalists | female\_medalists | male\_to\_female\_ratio |
| :--- | :--- | :--- |
| 11019 | 8375 | 1.32 |

### Question 14: Which countries won the most female medals?

Purpose: Identify countries leading in women’s Olympic success.

```sql
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
```
| country\_name | country\_code | female\_medals |
| :--- | :--- | :--- |
| United States | USA | 1407 |
| China | CHN | 705 |
| Russian Federation | RUS | 684 |
| Germany | DEU | 627 |
| Australia | AUS | 508 |
| Netherlands | NLD | 371 |
| Canada | CAN | 319 |
| United Kingdom | GBR | 306 |
| Japan | JPN | 304 |
| Romania | ROM | 274 |

### Question 15: Which countries had more female medalists than male medalists?

Purpose: Show countries where women drove Olympic success.

```sql
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
```

| country\_name | country\_code | female\_medals | male\_medals | female\_medal\_advantage |
| :--- | :--- | :--- | :--- | :--- |
| China | CHN | 705 | 367 | 338 |
| Romania | ROM | 274 | 128 | 146 |
| Netherlands | NLD | 371 | 235 | 136 |
| Canada | CAN | 319 | 189 | 130 |
| Norway | NOR | 156 | 59 | 97 |
| United States | USA | 1407 | 1314 | 93 |
| Jamaica | JAM | 111 | 58 | 53 |
| Ukraine | UKR | 117 | 97 | 20 |
| Belarus | BLR | 72 | 56 | 16 |
| Peru | PER | 12 | 2 | 10 |
| Zimbabwe | ZWE | 7 | 0 | 7 |
| Hong Kong | HKG | 9 | 3 | 6 |
| Singapore | SGP | 7 | 1 | 6 |
| Thailand | THA | 19 | 15 | 4 |
| Costa Rica | CRI | 4 | 0 | 4 |
| Bulgaria | BGR | 69 | 65 | 4 |
| Ethiopia | ETH | 26 | 22 | 4 |
| Bahrain | BHR | 4 | 0 | 4 |
| Colombia | COL | 17 | 14 | 3 |
| Mozambique | MOZ | 2 | 0 | 2 |
| Samoa | WSM | 1 | 0 | 1 |
| Sri Lanka | LKA | 1 | 0 | 1 |
| Bermuda | BMU | 1 | 0 | 1 |
| Turkmenistan | TKM | 1 | 0 | 1 |

### Question 16: In what year did each country win its first female medal in our dataset?

Purpose: Track the spread of women’s medal success across countries over time.

```sql
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
```

| country\_name | country\_code | first\_female\_medal\_year | total\_female\_medals |
| :--- | :--- | :--- | :--- |
| United States | USA | 1984 | 1407 |
| China | CHN | 1984 | 705 |
| Germany | DEU | 1984 | 627 |
| Australia | AUS | 1984 | 508 |
| Netherlands | NLD | 1984 | 371 |
| Canada | CAN | 1984 | 319 |
| United Kingdom | GBR | 1984 | 306 |
| Japan | JPN | 1984 | 304 |
| Romania | ROM | 1984 | 274 |
| South Korea | KOR | 1984 | 268 |
| France | FRA | 1984 | 211 |
| Norway | NOR | 1984 | 156 |
| Italy | ITA | 1984 | 152 |
| Jamaica | JAM | 1984 | 111 |
| Sweden | SWE | 1984 | 96 |
| Yugoslavia | YUG | 1984 | 93 |
| Denmark | DNK | 1984 | 85 |
| Switzerland | CHE | 1984 | 38 |
| Belgium | BEL | 1984 | 26 |
| Finland | FIN | 1984 | 11 |
| Portugal | PRT | 1984 | 7 |
| Morocco | MAR | 1984 | 4 |
| Russian Federation | RUS | 1988 | 684 |
| Hungary | HUN | 1988 | 133 |
| Argentina | ARG | 1988 | 94 |
| New Zealand | NZL | 1988 | 86 |
| Poland | POL | 1988 | 76 |
| Bulgaria | BGR | 1988 | 69 |
| Czech Republic | CZE | 1988 | 29 |
| Indonesia | IDN | 1988 | 20 |
| Peru | PER | 1988 | 12 |
| Costa Rica | CRI | 1988 | 4 |
| Spain | ESP | 1992 | 158 |
| Cuba | CUB | 1992 | 95 |
| Greece | GRC | 1992 | 41 |
| Ethiopia | ETH | 1992 | 26 |
| Nigeria | NGA | 1992 | 22 |
| North Korea | PRK | 1992 | 21 |
| Colombia | COL | 1992 | 17 |
| South Africa | ZAF | 1992 | 14 |
| Turkey | TUR | 1992 | 11 |
| Israel | ISR | 1992 | 9 |
| Estonia | EST | 1992 | 6 |
| Mongolia | MNG | 1992 | 6 |
| Algeria | DZA | 1992 | 3 |
| Brazil | BRA | 1996 | 164 |
| Ukraine | UKR | 1996 | 117 |
| Belarus | BLR | 1996 | 72 |
| Kenya | KEN | 1996 | 29 |
| Taiwan | TWN | 1996 | 25 |
| Bahamas | BHS | 1996 | 15 |
| Ireland | IRL | 1996 | 12 |
| Austria | AUT | 1996 | 11 |
| Slovenia | SVN | 1996 | 10 |
| Hong Kong | HKG | 1996 | 9 |
| Mozambique | MOZ | 1996 | 2 |
| Syria | SYR | 1996 | 1 |
| Mexico | MEX | 2000 | 21 |
| Thailand | THA | 2000 | 19 |
| Kazakstan | KAZ | 2000 | 18 |
| Azerbaijan | AZE | 2000 | 13 |
| Lithuania | LTU | 2000 | 12 |
| India | IND | 2000 | 8 |
| Slovakia | SVK | 2000 | 8 |
| Iceland | ISL | 2000 | 1 |
| Sri Lanka | LKA | 2000 | 1 |
| Vietnam | VNM | 2000 | 1 |
| Zimbabwe | ZWE | 2004 | 7 |
| Venezuela | VEN | 2004 | 5 |
| Cameroon | CMR | 2004 | 3 |
| Latvia | LVA | 2004 | 1 |
| Croatia | HRV | 2008 | 10 |
| Singapore | SGP | 2008 | 7 |
| Egypt | EGY | 2008 | 7 |
| Samoa | WSM | 2008 | 1 |
| Georgia | GEO | 2008 | 1 |
| Uzbekistan | UZB | 2008 | 1 |
| Bahrain | BHR | 2012 | 4 |
| Malaysia | MYS | 2012 | 4 |
| Tunisia | TUN | 2012 | 3 |
| Tajikistan | TJK | 2012 | 1 |
| Philippines | PHL | 2016 | 3 |
| Côte d’Ivoire | CIV | 2016 | 2 |
| Puerto Rico | PRI | 2016 | 2 |
| Burundi | BDI | 2016 | 1 |
| Iran | IRN | 2016 | 1 |
| Fiji Islands | FJI | 2020 | 13 |
| Dominican Republic | DOM | 2020 | 4 |
| Ecuador | ECU | 2020 | 2 |
| Kyrgyzstan | KGZ | 2020 | 2 |
| San Marino | SMR | 2020 | 2 |
| Bermuda | BMU | 2020 | 1 |
| Namibia | NAM | 2020 | 1 |
| Turkmenistan | TKM | 2020 | 1 |
| Uganda | UGA | 2020 | 1 |

---

## 7. New Sports and New Opportunities

The Olympic program changed between 1984 and 2020. New sports created new paths for countries to win medals and sometimes allowed different nations to become dominant.

### Question 17: Which sports were added after 1984?

Purpose: Identify how the Olympic program expanded.
```sql
SELECT
    SportName,
    FirstYear
FROM Sport
WHERE FirstYear > 1984
ORDER BY FirstYear, SportName;
```

| SportName | FirstYear |
| :--- | :--- |
| Table Tennis | 1988 |
| Tennis | 1988 |
| Badminton | 1992 |
| Baseball | 1992 |
| Canoe Slalom | 1992 |
| Beach Volleyball | 1996 |
| Cycling Mountain Bike | 1996 |
| Softball | 1996 |
| Taekwondo | 2000 |
| Trampolining | 2000 |
| Triathlon | 2000 |
| Cycling BMX Racing | 2008 |
| Marathon Swimming | 2008 |
| Golf | 2016 |
| Rugby Sevens | 2016 |
| 3x3 Basketball | 2020 |
| Cycling BMX Freestyle | 2020 |
| Karate | 2020 |
| Skateboarding | 2020 |
| Sport Climbing | 2020 |
| Surfing | 2020 |

### Question 18: Which countries won the most medals in newly added sports?

Purpose: Show which countries benefited most from new Olympic opportunities.

```sql
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
```

| country\_name | country\_code | medals\_in\_new\_sports |
| :--- | :--- | :--- |
| United States | USA | 269 |
| China | CHN | 222 |
| Japan | JPN | 190 |
| South Korea | KOR | 141 |
| Australia | AUS | 133 |
| Cuba | CUB | 118 |
| United Kingdom | GBR | 69 |
| Germany | DEU | 68 |
| France | FRA | 64 |
| New Zealand | NZL | 49 |

### Question 19: Which country dominated each newly added sport?

Purpose: Connect each new sport to its strongest medal-winning country.

```sql
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
```

| SportName | FirstYear | country\_name | country\_code | medal\_count |
| :--- | :--- | :--- | :--- | :--- |
| Table Tennis | 1988 | China | CHN | 93 |
| Tennis | 1988 | United States | USA | 37 |
| Badminton | 1992 | China | CHN | 74 |
| Baseball | 1992 | Cuba | CUB | 112 |
| Canoe Slalom | 1992 | France | FRA | 20 |
| Canoe Slalom | 1992 | Slovakia | SVK | 20 |
| Beach Volleyball | 1996 | Brazil | BRA | 26 |
| Cycling Mountain Bike | 1996 | Switzerland | CHE | 10 |
| Softball | 1996 | United States | USA | 75 |
| Taekwondo | 2000 | South Korea | KOR | 22 |
| Trampolining | 2000 | China | CHN | 14 |
| Triathlon | 2000 | United Kingdom | GBR | 11 |
| Cycling BMX Racing | 2008 | Colombia | COL | 6 |
| Marathon Swimming | 2008 | Netherlands | NLD | 4 |
| Golf | 2016 | United States | USA | 3 |
| Rugby Sevens | 2016 | Fiji Islands | FJI | 39 |
| 3x3 Basketball | 2020 | Russian Federation | RUS | 8 |
| Cycling BMX Freestyle | 2020 | United Kingdom | GBR | 2 |
| Karate | 2020 | Turkey | TUR | 4 |
| Skateboarding | 2020 | Japan | JPN | 5 |
| Sport Climbing | 2020 | Japan | JPN | 2 |
| Surfing | 2020 | Japan | JPN | 2 |

---

## 8. Country Specialization

Some countries succeed broadly across many sports, while others dominate a smaller number of events. This section shows whether Olympic success comes from depth or specialization.

### Question 20: Which countries are most specialized in one sport?

Purpose: Identify countries whose Olympic identity is strongly tied to one sport.

```sql
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
```

| country\_name | country\_code | top\_sport | top\_sport\_medals | total\_medals | specialization\_percentage |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Ethiopia | ETH | Athletics | 48 | 48 | 100.00 |
| Bahamas | BHS | Athletics | 38 | 38 | 100.00 |
| Paraguay | PRY | Football | 22 | 22 | 100.00 |
| Fiji Islands | FJI | Rugby Sevens | 39 | 39 | 100.00 |
| Jamaica | JAM | Athletics | 169 | 169 | 100.00 |
| Pakistan | PAK | Hockey | 32 | 33 | 96.97 |
| Kenya | KEN | Athletics | 91 | 94 | 96.81 |
| Trinidad and Tobago | TTO | Athletics | 21 | 22 | 95.45 |
| Ghana | GHA | Football | 20 | 21 | 95.24 |
| Cameroon | CMR | Football | 19 | 23 | 82.61 |
| Morocco | MAR | Athletics | 19 | 23 | 82.61 |
| Chile | CHL | Football | 22 | 28 | 78.57 |
| Israel | ISR | Judo | 16 | 23 | 69.57 |
| Indonesia | IDN | Badminton | 31 | 49 | 63.27 |
| Dominican Republic | DOM | Baseball | 24 | 39 | 61.54 |

---

## Key Design Decisions
- IOC to ISO country code mapping
    - Our olympics dataset uses IOC codes, the given world db uses ISO codes
- Historical teams has been mapped to modern successors. Soviet Union -> Russia

## Database Scope

### Games covered (10 Summer Olympics)
1984 Los Angeles, 1988 Seoul, 1992 Barcelona, 1996 Atlanta, 2000 Sydney,
2004 Athens, 2008 Beijing, 2012 London, 2016 Rio, 2020 Tokyo

### TODOS:

#### Part A – ER Diagram & Schema (25 pts)
- [x] Load world database (3 base tables)
- [x] Design 4 additional tables (Olympics, Sport, Athlete, Medal)
- [x] Add real data to additional tables (~19K medal rows from Olympedia)
- [x] Define primary keys on all tables
- [x] Define foreign keys (added missing FKs on City, CountryLanguage)
- [x] Define integrity constraints (CHECK, NOT NULL, UNIQUE, etc.)
- [x] ER Diagram (Excalidraw)
- [ ] Physical Diagram
- [ ] Export both diagrams as images for the report

#### Part B – Queries (25 pts)
- [x] Write 5+ queries using joins from multiple tables
- [x] Write 10+ queries using subqueries from multiple tables
- [x] Write remaining queries (20 total)
- [x] Test each query, verify results are sensible
- [x] Capture screenshots / output of each for the report

#### Part B – Final Report (Word doc, APA, 12pt Times New Roman, double-spaced, 4+ pages)
- [ ] Title page (team name, class, date, members)
- [ ] Introduction
  - [ ] Describe data in the database
  - [ ] Reference UN website or external sources on country data
  - [ ] Explain why this database matters (GNP, life expectancy, etc.)
- [ ] Database Development Process
  - [ ] Insert ER diagram
  - [ ] Explain thought process behind the ER design
  - [ ] Insert database schema with PKs and FKs identified
  - [ ] Insert logical and physical relational models
- [ ] Database Investigation
  - [ ] All 20 queries written in production SQL syntax
  - [ ] Purpose and value explained for each
- [ ] Summary (pitfalls, revelations, lessons learned)
- [ ] Reference page

#### Presentation (~15 minutes)
- [x] Build slide deck
- [ ] Decide who presents which section
- [ ] Designate one person to bring laptop for live database demo
- [ ] Rehearse

#### Submission logistics
- [ ] Group leader submits on Canvas (PPT + report + SQL file)
- [ ] Each member submits peer review with contribution percentages

#### Nice-to-haves (not strictly required)
- [ ] Save incremental backups of SQL file as we iterate
- [ ] Keep a running list of "interesting findings" from queries for the Summary section