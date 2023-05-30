SELECT word, COUNT(*) AS count
FROM (
    SELECT EXPLODE(SPLIT(LOWER(OriginalTweet), ' ')) AS word
    FROM tweet
) t
GROUP BY word
ORDER BY count DESC
LIMIT 20;