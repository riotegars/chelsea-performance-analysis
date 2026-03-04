/* =====================================================
   CHELSEA PERFORMANCE ANALYSIS
   Database: PostgreSQL
   Description: Performance analysis using match data
   ===================================================== */

--------------------------------------------------------
-- 1. DATA CLEANING
--------------------------------------------------------

ALTER TABLE chelsea_matches
ALTER COLUMN match_date TYPE DATE USING match_date::date;

ALTER TABLE chelsea_matches
ALTER COLUMN goals TYPE INTEGER USING goals::integer;

ALTER TABLE chelsea_matches
ALTER COLUMN opponent_goals TYPE INTEGER USING opponent_goals::integer;

ALTER TABLE chelsea_matches
ALTER COLUMN result TYPE INTEGER USING result::integer;

--------------------------------------------------------
-- 2. OVERALL PERFORMANCE
--------------------------------------------------------

SELECT 
    COUNT(*) AS total_matches,
    COUNT(*) FILTER (WHERE result = 1) AS total_wins,
    COUNT(*) FILTER (WHERE result = 0) AS total_draws,
    COUNT(*) FILTER (WHERE result = -1) AS total_losses
FROM chelsea_matches;

--------------------------------------------------------
-- 3. PERFORMANCE BY SEASON
--------------------------------------------------------

SELECT 
    season,
    COUNT(*) AS total_matches,
    COUNT(*) FILTER (WHERE result = 1) AS wins,
    ROUND(
        COUNT(*) FILTER (WHERE result = 1)::numeric 
        / COUNT(*) * 100, 2
    ) AS win_rate_percent
FROM chelsea_matches
GROUP BY season
ORDER BY season;

--------------------------------------------------------
-- 4. Home Advantage Analysis
--------------------------------------------------------

SELECT 
    is_home,
    COUNT(*) AS total_matches,
    ROUND(AVG(goals),2) AS avg_goals_scored,
    ROUND(
        COUNT(*) FILTER (WHERE result = 1)::numeric 
        / COUNT(*) * 100, 2
    ) AS win_rate_percent
FROM chelsea_analysis
GROUP BY is_home;

--------------------------------------------------------
-- 5. Possession vs Winning Probability
--------------------------------------------------------

SELECT 
    CASE 
        WHEN possession >= 60 THEN 'High Possession'
        WHEN possession >= 50 THEN 'Medium Possession'
        ELSE 'Low Possession'
    END AS possession_category,
    COUNT(*) AS total_matches,
    ROUND(
        COUNT(*) FILTER (WHERE result = 1)::numeric 
        / COUNT(*) * 100, 2
    ) AS win_rate_percent
FROM chelsea_analysis
GROUP BY possession_category
ORDER BY win_rate_percent DESC;