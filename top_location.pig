-- Load the train dataset from HDFS
tweet_data = LOAD '/covid_twitter/tweet_data.csv' USING PigStorage(',') AS (
    UserName: int,
    ScreenName: int,
    Location: chararray,
    TweetAt: chararray,
    OriginalTweet: chararray,
    Sentiment: chararray
);

-- Group the train data by location and calculate the counts
grouped_tweet_locations = GROUP tweet_data BY Location;
tweet_location_counts = FOREACH grouped_tweet_locations GENERATE group AS location, COUNT(tweet_data) AS count;

-- Sort the train location counts in descending order
sorted_tweet_location_counts = ORDER tweet_location_counts BY count DESC;

-- Get the top 10 most frequent locations in train data
top_10_locations = LIMIT sorted_tweet_location_counts 10;

-- Print the result for train locations
DUMP top_10_locations;

-- Store the top 10 train locations into a file
-- STORE top_10_locations INTO '/pig/top_locations.csv' USING PigStorage(',');
