# Olympics & World Database Presentation Breakdown

Presentation date: Saturday, May 2, 2026  
Recommended length: about 15 minutes  
Main story: From 1984 to 2020, Olympic success changed because of shifting country power, host-country boosts, gender growth, new sports, and the way medals are counted.

## Suggested Speaker Split

| Speaker | Slides | Topic | Time |
| :--- | :--- | :--- | :--- |
| Speaker 1 | 1-3 | Intro, project goal, main story point | 2 min |
| Speaker 2 | 4-7 | database design, relationships, requirements, superpowers, medal-count method | 4 min |
| Speaker 3 | 8-10 | host advantage, global expansion, country/economy context | 4 min |
| Speaker 4 | 11-12 | gender revolution, new sports, specialization | 3 min |
| Speaker 5 | 13-15 | key findings, challenges, conclusion | 2 min |

If only four people present, combine slides 13-15 with Speaker 1 or Speaker 4.

## Slide 1: Title

What to say:

Introduce the project as a database investigation of Olympic performance from the 1984 Los Angeles Games through the 2020 Tokyo Games. Mention that the group connected Olympic medal data with the World database from class, so the project is not only about sports results but also about country context.

Short script:

> Our project looks at how Olympic success evolved across ten Summer Olympics, from Los Angeles 1984 to Tokyo 2020. We combined Olympic medal data with the World database so we could ask not just who won medals, but how country size, economy, gender, hosting, and new sports changed the meaning of Olympic success.

## Slide 2: Project Goal

README match:

- Data source: Olympic Historical Dataset from Olympedia.org on Kaggle.
- Base World DB tables: `Country`, `City`, `CountryLanguage`.
- Custom tables: `Olympics`, `Sport`, `Athlete`, `Medal`.
- Central story from README: "How has global athletic competition changed from 1984 to 2020, and which countries benefited most from those changes?"

What to say:

Explain that the group acted like database consultants. The goal was to design extra tables, load Olympic data, connect it to the country database, then write queries that answer a larger analytical question.

Key point:

The database lets you compare countries in multiple ways:

- Raw medal totals
- Official-style medal counts
- Medal success by host year
- Medal success by population and GNP
- Gender-based medal trends
- New sports and specialization

## Slide 3: Database Design

README match:

- World DB tables: `Country`, `City`, `CountryLanguage`.
- Added tables: `Olympics`, `Sport`, `Athlete`, `Medal`.
- Design decision: IOC Olympic country codes had to be mapped to ISO country codes from the World database.

What to say:

The important table is `Medal`, because it connects one medal result to an athlete, sport, Olympic Games, and country. This makes it possible to ask joined questions like "which countries won medals in new sports?" or "which countries with smaller populations overperformed?"

Suggested explanation:

> The World database already gave us country-level context like population, continent, GNP, capital city, and language data. We added Olympic-specific tables so that each medal row could be connected back to those country attributes.

## Slide 4: Key Relationships

README match:

The main foreign-key relationships are:

| Relationship | Meaning |
| :--- | :--- |
| `Medal.CountryCode -> Country.Code` | Connects medals to country data |
| `Medal.OlympicID -> Olympics.OlympicID` | Connects medals to a specific Games/year |
| `Medal.AthleteID -> Athlete.AthleteID` | Connects medals to athlete gender/name |
| `Medal.SportID -> Sport.SportID` | Connects medals to sport and first Olympic year |

What to say:

This is the technical bridge between the class database and the Olympic dataset. Most of the interesting queries require these joins.

Good transition:

> Once these relationships were in place, we could move from basic medal tables to more meaningful questions about time, geography, gender, and national context.

## Slide 5: Query Requirements

README match:

- 20 total queries completed.
- 5+ join queries.
- 10+ subquery queries.
- Organized into 8 README sections:
  - Rise and Fall of Athletic Superpowers
  - Rethinking Medal Counts
  - Host Country Advantage
  - Global Expansion of Olympic Success
  - Wealth, Population, and Olympic Performance
  - The Gender Revolution
  - New Sports and New Opportunities
  - Country Specialization

What to say:

Explain that the queries are grouped like chapters in a story. The project starts with the obvious question, "who won the most?", then gets more analytical by questioning how medal counts should be interpreted.

## Slide 6: Chapter 1, Olympic Superpowers

README questions:

- Question 1: Which countries won the most medals in 1984?
- Question 2: Which countries won the most medals in 2020?
- Question 3: Which countries medaled in every Games from 1984-2020?
- Question 4: Which countries improved the most from 1984 to 2020?

Data to mention:

| 1984 rank | Country | Medal rows |
| :--- | :--- | :--- |
| 1 | United States | 359 |
| 2 | Germany | 163 |
| 3 | Romania | 106 |
| 4 | Canada | 90 |
| 5 | Yugoslavia | 88 |

| 2020 rank | Country | Medal rows |
| :--- | :--- | :--- |
| 1 | United States | 297 |
| 2 | Russian Federation | 148 |
| 3 | China | 145 |
| 4 | France | 138 |
| 5 | United Kingdom | 132 |

Most improved from 1984 to 2020:

| Country | 1984 | 2020 | Growth |
| :--- | :--- | :--- | :--- |
| Japan | 49 | 131 | +82 |
| Australia | 55 | 130 | +75 |
| France | 68 | 138 | +70 |
| China | 78 | 145 | +67 |
| United Kingdom | 76 | 132 | +56 |

What to say:

The United States stayed at the top in both 1984 and 2020, but the rest of the leaderboard changed. China, Japan, Australia, France, and the UK all grew significantly. This supports the theme that Olympic power shifted, but it did not become completely equal.

Important note:

The slide says "China surged: from 32 -> 88 medals," but the README table using athlete medal rows shows China at 78 in 1984 and 145 in 2020. Use the README numbers when presenting unless the group updates the slide.

## Slide 7: Chapter 2, Medal Counts Can Mislead

README questions:

- Question 5: How do athlete medal rows compare to official-style medal counts?
- Question 6: Which countries benefit most from team-event medal rows?

Data to mention:

| Country | Athlete medal rows | Official-style medals |
| :--- | :--- | :--- |
| United States | 2721 | 1118 |
| Russian Federation | 1539 | 737 |
| Germany | 1515 | 617 |
| Australia | 1099 | 370 |
| China | 1072 | 635 |

Countries most inflated by team-event rows:

| Country | Total rows | Team rows | Team % |
| :--- | :--- | :--- | :--- |
| Fiji Islands | 39 | 39 | 100.00% |
| Pakistan | 33 | 32 | 96.97% |
| Argentina | 255 | 244 | 95.69% |
| Yugoslavia | 352 | 319 | 90.63% |
| Nigeria | 118 | 104 | 88.14% |

What to say:

This is one of the most important methodology slides. In the database, a team-event medal creates one row per athlete. That means a basketball team or rugby team can produce many medal rows even though the country earned one official medal in that event.

Short script:

> Our raw medal count is useful, but it is not the same as the official Olympic medal table. For example, the United States has 2,721 athlete medal rows, but 1,118 official-style medals after deduplicating by country, event, sport, Games, and medal type. This matters because team-heavy countries can look stronger in raw rows.

## Slide 8: Chapter 3, Host Country Advantage

README question:

- Question 7: Do host countries win more medals when they host?

Data to mention:

| Host | Year | Host medals | Average non-host medals |
| :--- | :--- | :--- | :--- |
| United States | 1984 | 359 | 262.44 |
| South Korea | 1988 | 82 | 55.22 |
| Spain | 1992 | 74 | 47.22 |
| Australia | 2000 | 183 | 101.78 |
| Greece | 2004 | 31 | 7.00 |
| China | 2008 | 186 | 98.44 |
| United Kingdom | 2012 | 128 | 76.78 |
| Japan | 2020 | 131 | 55.78 |

What to say:

Host countries generally performed above their non-host average. The biggest examples are Australia in 2000, China in 2008, and Japan in 2020. Greece is also interesting because its 2004 performance was much higher than its usual average.

Important note:

The slide says Japan rose from about 27 average to 58, but the README table says Japan rose from 55.78 average non-host medal rows to 131 host-year medal rows. Present the README numbers.

## Slide 9: Chapter 4, Global Expansion

README questions:

- Question 8: How many countries won their first medal in each Olympic year?
- Question 9: How did medal share by continent change from 1984 to 2020?

First-time medal countries:

| Year | First-time medal countries |
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

Continent medal share:

| Continent | 1984 share | 2020 share |
| :--- | :--- | :--- |
| Europe | 47.36% | 45.89% |
| North America | 30.85% | 19.86% |
| Asia | 12.75% | 18.96% |
| Oceania | 5.15% | 9.09% |
| South America | 2.77% | 4.52% |
| Africa | 1.12% | 1.69% |

What to say:

Olympic success expanded because new countries entered the medal table throughout the period. However, medals remained concentrated in Europe, North America, and Asia. Asia and Oceania gained share, while North America's share dropped.

## Slide 10: Chapter 5, Country Context, Not Just Economy

README questions:

- Question 10: Which countries won the most medals per million people?
- Question 11: Which countries won the most medals relative to GNP?
- Question 12: Do countries with above-average GNP win more medals?
- Question 12a: Which medal-winning countries have the largest capital cities?
- Question 12b: Do countries with more recorded languages win more Olympic medals?

Data to mention for medals per million:

| Country | Population | Total medals | Medals per million |
| :--- | :--- | :--- | :--- |
| Bahamas | 307,000 | 38 | 123.78 |
| Jamaica | 2,583,000 | 169 | 65.43 |
| Australia | 18,886,000 | 1099 | 58.19 |
| New Zealand | 3,862,000 | 224 | 58.00 |
| Iceland | 279,000 | 16 | 57.35 |

Data to mention for GNP:

| GNP group | Countries with medals | Medal rows | Medals per country |
| :--- | :--- | :--- | :--- |
| Above Average GNP | 29 | 15148 | 522.34 |
| Below Average GNP | 100 | 4245 | 42.45 |

What to say:

Wealth matters because above-average GNP countries win far more medals per country. But adjusted statistics reveal smaller countries that overperform. Jamaica, Bahamas, Australia, New Zealand, Fiji, and Iceland look especially strong when medals are adjusted by population.

Good nuance:

> Raw totals favor large and wealthy countries. Per-capita and per-GNP measures help reveal countries that are efficient or specialized, even if they do not lead the total medal table.

## Slide 11: Chapter 6, Gender Revolution

README questions:

- Question 13: What is the overall male-to-female medalist ratio?
- Question 14: Which countries won the most female medals?
- Question 15: Which countries had more female medalists than male medalists?
- Question 16: In what year did each country win its first female medal in our dataset?

Data to mention:

| Male medalists | Female medalists | Male-to-female ratio |
| :--- | :--- | :--- |
| 11019 | 8375 | 1.32 |

Most female medals:

| Country | Female medals |
| :--- | :--- |
| United States | 1407 |
| China | 705 |
| Russian Federation | 684 |
| Germany | 627 |
| Australia | 508 |

Countries where women had more medal rows than men:

| Country | Female | Male | Female advantage |
| :--- | :--- | :--- | :--- |
| China | 705 | 367 | +338 |
| Romania | 274 | 128 | +146 |
| Netherlands | 371 | 235 | +136 |
| Canada | 319 | 189 | +130 |
| Norway | 156 | 59 | +97 |
| United States | 1407 | 1314 | +93 |

What to say:

The gender section shows that women's Olympic success became a defining part of national performance. Even though the overall dataset still has more male medalists than female medalists, several major Olympic countries had more female medal rows than male medal rows.

Important note:

The slide says female medal share rose from about 22% in 1984 to about 48% in 2020, but that exact year-by-year table is not shown in the README. If asked, say the README directly supports the overall ratio and country-level female medal trends.

## Slide 12: Chapter 7, New Sports & Specialization

README questions:

- Question 17: Which sports were added after 1984?
- Question 18: Which countries won the most medals in newly added sports?
- Question 19: Which country dominated each newly added sport?
- Question 20: Which countries are most specialized in one sport?

Sports added after 1984:

| Year | Examples |
| :--- | :--- |
| 1988 | Table Tennis, Tennis |
| 1992 | Badminton, Baseball, Canoe Slalom |
| 1996 | Beach Volleyball, Cycling Mountain Bike, Softball |
| 2000 | Taekwondo, Trampolining, Triathlon |
| 2008 | Cycling BMX Racing, Marathon Swimming |
| 2016 | Golf, Rugby Sevens |
| 2020 | 3x3 Basketball, BMX Freestyle, Karate, Skateboarding, Sport Climbing, Surfing |

Countries with most medals in newly added sports:

| Country | Medals in new sports |
| :--- | :--- |
| United States | 269 |
| China | 222 |
| Japan | 190 |
| South Korea | 141 |
| Australia | 133 |

Dominant countries in selected new sports:

| Sport | Added | Dominant country | Medal count |
| :--- | :--- | :--- | :--- |
| Table Tennis | 1988 | China | 93 |
| Badminton | 1992 | China | 74 |
| Baseball | 1992 | Cuba | 112 |
| Beach Volleyball | 1996 | Brazil | 26 |
| Softball | 1996 | United States | 75 |
| Rugby Sevens | 2016 | Fiji Islands | 39 |
| Skateboarding | 2020 | Japan | 5 |

Most specialized countries:

| Country | Top sport | Top sport medals | Total medals | Specialization |
| :--- | :--- | :--- | :--- | :--- |
| Ethiopia | Athletics | 48 | 48 | 100.00% |
| Bahamas | Athletics | 38 | 38 | 100.00% |
| Paraguay | Football | 22 | 22 | 100.00% |
| Fiji Islands | Rugby Sevens | 39 | 39 | 100.00% |
| Jamaica | Athletics | 169 | 169 | 100.00% |

What to say:

New sports created new medal opportunities, but the benefits were mixed. Large countries like the United States, China, and Japan gained many medals from new sports, but specialized countries like Fiji also found a path to Olympic success through one sport.

## Slide 13: Key Findings

What to say:

Tie the whole presentation together:

1. Olympic power shifted, but the top countries still stayed highly dominant.
2. Medal-counting methodology matters because team events inflate raw medal rows.
3. Hosting usually gives countries a measurable medal boost.
4. Women's medal success changed the story for many countries.
5. New sports created opportunities for both major powers and specialized smaller nations.
6. Adjusted metrics like medals per million reveal overperformers hidden by raw totals.

Best one-sentence summary:

> The biggest lesson is that Olympic success depends on context: how medals are counted, where the Games are hosted, which sports exist, and how countries specialize.

## Slide 14: Challenges & Lessons Learned

README match:

- IOC to ISO country-code mapping was required.
- Historical teams had to be mapped to modern successors, such as Soviet Union to Russia.
- Team-event medal rows can inflate raw medal counts.
- The project required balancing raw totals with adjusted statistics.

What to say:

This slide is where you show database maturity. Do not only say "we had problems cleaning data." Explain why those problems affect conclusions.

Strong point:

> Database design decisions directly affected our analysis. For example, if we did not handle country-code mapping correctly, Olympic medals would not connect to the World database. If we did not explain team-event rows, the medal totals could be misinterpreted.

## Slide 15: Conclusion

What to say:

End with the main answer to the central question.

Short script:

> From 1984 to 2020, Olympic success became broader and more complex. The United States and other traditional powers remained strong, but countries like China, Japan, Australia, and specialized smaller nations gained ground. The database shows that success is not just one medal table. It depends on counting method, host advantage, gender trends, new sports, and country context.

Final closing:

> So our conclusion is that the Olympics became more global, but not fully decentralized. The best way to understand Olympic success is to combine raw medal results with database context.

## Questions Your Professor Might Ask

| Possible question | Good answer |
| :--- | :--- |
| Why are medal counts so high compared to official Olympic tables? | Because the database counts athlete medal rows. A team event creates one row per athlete, so we also created an official-style deduplicated count. |
| Why use 1984 to 2020? | The project focuses on ten consecutive Summer Olympics from Los Angeles 1984 through Tokyo 2020. |
| Why does country-code mapping matter? | Olympic data uses IOC codes, while the World database uses ISO codes. Without mapping, joins between medals and country context would fail or be inaccurate. |
| Did Olympic success become more global? | Yes, first-time medal countries appeared across the dataset and Asia/Oceania gained share, but medals remained concentrated among Europe, North America, and Asia. |
| What was the most surprising result? | Smaller or specialized countries can rank very highly after adjusting for population or sport specialization, such as Jamaica in athletics and Fiji in rugby sevens. |
| What is the strongest database lesson? | Schema design and data-cleaning decisions shape the conclusions that queries can support. |

## Quick Rehearsal Notes

- Do not read every number on the charts. Pick the top 2-3 numbers that prove the point.
- Always say whether a chart uses raw athlete medal rows or official-style medals.
- When talking about country improvement, mention historical country changes like Soviet Union, Russia, and Yugoslavia.
- Use "medal rows" when referring to README raw counts.
- Use "official-style medals" only when referring to the deduplicated Question 5 result.
- Keep transitions simple: "Now that we know who won, we need to ask whether the count itself is fair."

