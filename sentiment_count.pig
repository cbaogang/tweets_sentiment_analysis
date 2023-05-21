-- Load the train dataset from HDFS
train_data = LOAD '/covid_twitter/train_tweet.csv' USING PigStorage(',') AS (
    UserName: int,
    ScreenName: int,
    Location: chararray,
    TweetAt: chararray,
    OriginalTweet: chararray,
    Sentiment: chararray
);

-- Group the data by the "Sentiment" column and calculate the counts for train dataset
grouped_train = GROUP train_data BY Sentiment;
train_sentiments = FOREACH grouped_train GENERATE group AS Sentiment, COUNT(train_data) AS Count;

-- Sort the train counts in descending order
sorted_train_sentiments = ORDER train_sentiments BY Count DESC;

-- Print the result for train sentiments
DUMP sorted_train_sentiments;

-- Store the train sentiment counts into a file
STORE sorted_train_sentiments INTO '/pig/train_sentiment_count.csv' USING PigStorage(',');


-- Load the test dataset from HDFS
test_data = LOAD '/covid_twitter/test_tweet.csv' USING PigStorage(',') AS (
    UserName: int,
    ScreenName: int,
    Location: chararray,
    TweetAt: chararray,
    OriginalTweet: chararray,
    Sentiment: chararray
);

-- Group the data by the "Sentiment" column and calculate the counts for test dataset
grouped_test = GROUP test_data BY Sentiment;
test_sentiments = FOREACH grouped_test GENERATE group AS Sentiment, COUNT(test_data) AS Count;

-- Sort the test counts in descending order
sorted_test_sentiments = ORDER test_sentiments BY Count DESC;

-- Print the result for test sentiments
DUMP sorted_test_sentiments;

-- Store the test sentiment counts into a file
STORE sorted_test_sentiments INTO '/pig/test_sentiment_count.csv' USING PigStorage(',');

