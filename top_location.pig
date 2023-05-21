-- Load the train dataset from HDFS
train_data = LOAD '/covid_twitter/train_tweet.csv' USING PigStorage(',') AS (
    UserName: int,
    ScreenName: int,
    Location: chararray,
    TweetAt: chararray,
    OriginalTweet: chararray,
    Sentiment: chararray
);

-- Group the train data by location and calculate the counts
grouped_train_locations = GROUP train_data BY Location;
train_location_counts = FOREACH grouped_train_locations GENERATE group AS location, COUNT(train_data) AS count;

-- Sort the train location counts in descending order
sorted_train_location_counts = ORDER train_location_counts BY count DESC;

-- Get the top 10 most frequent locations in train data
top_10_train_locations = LIMIT sorted_train_location_counts 10;

-- Print the result for train locations
DUMP top_10_train_locations;

-- Store the top 10 train locations into a file
STORE top_10_train_locations INTO '/pig/top_10_train_locations.csv' USING PigStorage(',');


-- Load the test dataset from HDFS
test_data = LOAD '/covid_twitter/test_tweet.csv' USING PigStorage(',') AS (
    UserName: int,
    ScreenName: int,
    Location: chararray,
    TweetAt: chararray,
    OriginalTweet: chararray,
    Sentiment: chararray
);

-- Group the test data by location and calculate the counts
grouped_test_locations = GROUP test_data BY Location;
test_location_counts = FOREACH grouped_test_locations GENERATE group AS location, COUNT(test_data) AS count;

-- Sort the test location counts in descending order
sorted_test_location_counts = ORDER test_location_counts BY count DESC;

-- Get the top 10 most frequent locations in test data
top_10_test_locations = LIMIT sorted_test_location_counts 10;

-- Print the result for test locations
DUMP top_10_test_locations;

-- Store the top 10 test locations into a file
STORE top_10_test_locations INTO '/pig/top_10_test_locations.csv' USING PigStorage(',');