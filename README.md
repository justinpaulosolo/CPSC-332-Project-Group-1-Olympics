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
The Evolution of the Summer Olympics(1984-2020)
How has the global athletic competition changed accross 10 consecutive Summer Games?

### Rise and Fall of Athletic Superpowers
##### Top 10 medal-winning counties in 1984 and 2020; how does it campare to 1984 and 2020?
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

#### 1984
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

#### 2020
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

### Which country if any medaled in every single games from 1984-2020? (consistent champs)

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

### Most improved country? (Growth in medal count)
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

## Gender Revolution (How women participation and success transformed since 1984)
### Male to female medalist ratio?
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

### Which country won the most female medals?
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

### Are there country where females athletes won more medals than male athletes?
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

## Sports Evolution (Has the sports played expanted and which countries benefited the most)
Which sports were added after 1984?
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

### Which country has won the most medal in the new added sports? (Who dominated each of the new sports?)
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

### Which country medaled in the largest number of different sports?
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
- [ ] Write 5+ queries using joins from multiple tables
- [ ] Write 10+ queries using subqueries from multiple tables
- [ ] Write remaining queries (20 total)
- [ ] Test each query, verify results are sensible
- [ ] Capture screenshots / output of each for the report

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
- [ ] Build slide deck
- [ ] Decide who presents which section
- [ ] Designate one person to bring laptop for live database demo
- [ ] Rehearse

#### Submission logistics
- [ ] Group leader submits on Canvas (PPT + report + SQL file)
- [ ] Each member submits peer review with contribution percentages

#### Nice-to-haves (not strictly required)
- [ ] Save incremental backups of SQL file as we iterate
- [ ] Keep a running list of "interesting findings" from queries for the Summary section