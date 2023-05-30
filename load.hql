DROP TABLE IF EXISTS tweet;

-- Create a table to store the CSV data
CREATE TABLE tweet (
  UserName INT,
  ScreenName INT,
  Location STRING,
  TweetAt STRING,
  OriginalTweet STRING,
  Sentiment STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ',';

-- Load the data from the CSV file into the table
LOAD DATA INPATH '/covid_twitter/tweet_data.csv' INTO TABLE tweet;