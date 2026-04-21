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

## Notes
### What story are we trying to tell?
The Evolution of the Summer Olympics(1984-2020)
How has the global athletic competition changed accross 10 consecutive Summer Games?

### Rise and Fall of Athletic Superpowers
Top 10 medal-winning counties in 1984 and 2020; how does it campare to 1984 and 2020?

Which country if any medaled in every single games from 1984-2020? (consistent champs)

Most improved country? (Growth in medal count)

### Gender Revolution (How women participation and success transformed since 1984)
Male to female medalist ratio?

Which country won the most female medals?

Are there country where females athletes won more medals than male athletes?

### Sports Evolution (Has the sports played expanted and which countries benefited the most)
Which sport were added after 1984?

Which country has won the most medal in the new added sports? (Who dominated each of the new sports?)

Which country medaled in the largest number of different sports?


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