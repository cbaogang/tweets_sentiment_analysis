SELECT Location, COUNT(*) AS TweetCount
FROM tweet
GROUP BY Location
ORDER BY TweetCount DESC
LIMIT 10;