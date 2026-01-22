# Querying your MySQL dataset

## Tell me more!

Prompt `give me a summary of the titles in this database.`

Included below is a text version of the output. As you can see this single prompt ran multiple SQL statements and summarized this into report worthy output.

## IMDb Database Summary
This is a massive IMDb database containing 44.5 million titles spanning from 1874 to 2031.

Title Types (11 categories):

- tvEpisode
- movie
- tvSeries
- short
- tvMovie
- video
- videoGame
- tvMiniSeries
- tvSpecial
- tvShort
- tvPilot

## Time Coverage:

- Earliest title: 1874
- Latest title: 2031
- Recent years show significant growth (2024: 1.5M titles, 2023: 1.7M titles)

## Ratings Coverage:

- 6.1 million titles have ratings (about 13.6% of all titles)
- Average rating: 7.0/10
- Rating range: 1.0 to 10.0
- Average votes per rated title: ~1,042

## Runtime:

- Average runtime: 42 minutes
- Range: 0 to 32,767 minutes (the max suggests some data quality issues)

## Genres (28 total):

Top 10 genres by title count:

- Drama - 3.2M titles
- Comedy - 2.2M titles
- Talk-Show - 1.4M titles
- Short - 1.2M titles
- Documentary - 1.1M titles
- News - 1.1M titles
- Romance - 1.1M titles
- Family - 845K titles
- Reality-TV - 641K titles
- Animation - 570K titles

## Content Filtering:

No adult titles in this dataset (is_adult = 0 for all)

This appears to be a comprehensive IMDb dataset, likely from official IMDb data dumps, with extensive coverage of both historical and contemporary media content.

## The SQL

No SQL was required, but what if you wanted to have this SQL in code for a report. You can simply ask for it.

Prompt `Give me the SQL Statements you used to generate this output`

```
-- Overall statistics
SELECT
    COUNT(*) as total_titles,
    COUNT(DISTINCT type) as title_types,
    MIN(start_year) as earliest_year,
    MAX(start_year) as latest_year
FROM title;

-- Get all distinct title types
SELECT DISTINCT type FROM title LIMIT 20;

-- Runtime statistics
SELECT
    AVG(run_time_mins) as avg_runtime,
    MIN(run_time_mins) as min_runtime,
    MAX(run_time_mins) as max_runtime
FROM title
WHERE run_time_mins IS NOT NULL;

-- Adult content count
SELECT COUNT(*) as adult_titles
FROM title
WHERE is_adult = 1;

-- Titles with ratings
SELECT COUNT(*) as titles_with_ratings
FROM title_rating;

-- Rating statistics
SELECT
    AVG(average_rating) as avg_rating,
    MIN(average_rating) as min_rating,
    MAX(average_rating) as max_rating,
    AVG(num_votes) as avg_votes
FROM title_rating;

-- Recent years breakdown
SELECT start_year, COUNT(*) as count
FROM title
WHERE start_year BETWEEN 2020 AND 2025
GROUP BY start_year
ORDER BY start_year DESC;

-- Total unique genres
SELECT COUNT(DISTINCT genre) as total_genres
FROM title_genre;

-- Top 10 genres
SELECT genre, cnt as count
FROM genre
ORDER BY cnt DESC
LIMIT 10;
```

Note: I attempted to run a query with GROUP BY type to get the breakdown of title types, but it timed out due to the large dataset size (44.5M rows). That's why I used SELECT DISTINCT type instead to just get the list of types.

## More Query

Prompt `Give me the most recent movies that Tom Hanks starred in`

Here are Tom Hanks' most recent movies:
2025:

- The Phoenician Scheme

2024:

- Freaky Tales (106 min)
- Here (104 min)
- The Bloody Hundredth (62 min)

2023:

- A Grammy Salute to the Beach Boys (TV Movie, 87 min)
- Asteroid City (105 min)

2022:

- A Man Called Otto (126 min)
- Elvis (159 min)
- Pinocchio (105 min)

2021:

- Finch (115 min)

2020:

- Borat Subsequent Moviefilm (95 min)
- Greyhound (91 min)
- News of the World (118 min)
- Served: Harvey Weinstein (60 min)

2019:

- A Beautiful Day in the Neighborhood (109 min)
- Toy Story 4 (100 min)

2017-2018:

- The Mayo Clinic, Faith, Hope and Science (2018, TV Movie)
- Ken Burns: America's Storyteller (2017, TV Movie)
- The Circle (2017, 110 min)
- The Post (2017, 116 min)

Ok, well I guess I don't know his recent work, but what about his most popular work.

Prompt `What the top rated movies that Tom Hanks have been in`

**Top Rated Tom Hanks Movies**
Here are Tom Hanks' highest-rated movies (with at least 10,000 votes):

**Elite Tier (8.0+):**

- Forrest Gump (1994) - 8.8 ⭐ - 2.4M votes, 142 min
- Saving Private Ryan (1998) - 8.6 ⭐ - 1.6M votes, 169 min
- The Green Mile (1999) - 8.6 ⭐ - 1.5M votes, 189 min
- Toy Story (1995) - 8.3 ⭐ - 1.1M votes, 81 min
- Toy Story 3 (2010) - 8.3 ⭐ - 924K votes, 103 min
- Catch Me If You Can (2002) - 8.1 ⭐ - 1.2M votes, 141 min

**Excellent Tier (7.5-7.9):**

- Toy Story 2 (1999) - 7.9 - 640K votes, 92 min
- Cast Away (2000) - 7.8 - 660K votes, 143 min
- Captain Phillips (2013) - 7.8 - 505K votes, 134 min
- Apollo 13 (1995) - 7.7 - 324K votes, 140 min
- Road to Perdition (2002) - 7.7 - 292K votes, 117 min
- Philadelphia (1993) - 7.7 - 265K votes, 125 min
- Bridge of Spies (2015) - 7.6 - 334K votes, 142 min
- Toy Story 4 (2019) - 7.6 - 294K votes, 100 min
- A Man Called Otto (2022) - 7.5 - 188K votes, 126 min
- Saving Mr. Banks (2013) - 7.5 - 172K votes, 125 min

**Strong Tier (7.3-7.4):**

- The Terminal (2004) - 7.4 - 511K votes, 128 min
- Cloud Atlas (2012) - 7.4 - 380K votes, 172 min
- Sully (2016) - 7.4 - 309K votes, 96 min
- Elvis (2022) - 7.3 - 249K votes, 159 min
- Big (1988) - 7.3 - 249K votes, 104 min
- A League of Their Own (1992) - 7.3 - 125K votes, 128 min

Forrest Gump remains Tom Hanks' highest-rated film, followed closely by two other masterpieces from the late 1990s: Saving Private Ryan and The Green Mile. His versatility shines through with critically acclaimed performances across drama, war films, animation, and biographical pictures.

And finally, some details about a movie that requires querying multiple tables.

Prompt `tell me about the movie cast away and details of the cast and crew`.

## Cast Away (2000)
**Movie Details:**

- Runtime: 143 minutes (2 hours 23 minutes)
- Rating: 7.8/10 (660,375 votes)
- Year: 2000

**Principal Cast:**

- **Tom Hanks** as Chuck Noland
- **Helen Hunt** as Kelly Frears
- **Paul Sanchez** as Ramon
- **Lari White** as Bettina Peterson
- **Leonid Citer** as Fyodor
- **David Allen Brooks** as Dick Peterson
- **Yelena Popovic** as Beautiful Russian Woman
- **Valentina Ananina** as Russian Babushka
- **Semion Sudarikov** as Nicolai
- **Peter Von Berg** as Yuri

## Key Crew:
**Director:**

- Robert Zemeckis

**Writer:**

- William Broyles Jr.

**Producers:**

- Tom Hanks (also starred in the film)
- Jack Rapke
- Steve Starkey
- Robert Zemeckis (also directed)

**Music:**

- Alan Silvestri (Composer)

**Cinematography:**

- Don Burgess (Director of Photography)

**Editing:**

- Arthur Schmidt

**Other Key Crew:**

- Victoria Burrows (Casting Director)
- Rick Carter (Production Designer)

This iconic survival drama features Tom Hanks in one of his most memorable performances, directed by the legendary Robert Zemeckis (Back to the Future, Forrest Gump). The film is known for Hanks' largely solo performance as a FedEx executive stranded on a deserted island.
