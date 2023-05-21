-- Load the train dataset from HDFS
train_data = LOAD '/covid_twitter/train_tweet.csv' USING PigStorage(',') AS (
    UserName: int,
    ScreenName: int,
    Location: chararray,
    TweetAt: chararray,
    OriginalTweet: chararray,
    Sentiment: chararray
);

DESCRIBE train_data;

-- Tokenize the train tweets to extract individual words
train_words = FOREACH train_data GENERATE FLATTEN(TOKENIZE(OriginalTweet)) AS word;

-- Filter out common stop words (if necessary)
stop_words = LOAD '/covid_twitter/stopwords.txt' USING TextLoader AS (stop: chararray);

-- Remove any stop words using a Left Outer Join for train tweets
train_words = JOIN train_words BY word LEFT OUTER, stop_words BY stop;
train_words = FILTER train_words BY stop_words::stop IS NULL;

-- Group the train data by word and calculate the counts
grouped_train_words = GROUP train_words BY word;
train_word_counts = FOREACH grouped_train_words GENERATE group AS word, COUNT(train_words) AS count;

-- Sort the train word counts in descending order
sorted_train_word_counts = ORDER train_word_counts BY count DESC;

-- Get the top 20 most frequent words in train tweets
top_20_train_words = LIMIT sorted_train_word_counts 20;

-- Print the result for train tweets
DUMP top_20_train_words;

-- Store the top 20 train words into a file
STORE top_20_train_words INTO '/pig/top_20_train_words.csv' USING PigStorage(',');

-- Load the test dataset from HDFS
test_data = LOAD '/covid_twitter/test_tweet.csv' USING PigStorage(',') AS (
    UserName: int,
    ScreenName: int,
    Location: chararray,
    TweetAt: chararray,
    OriginalTweet: chararray,
    Sentiment: chararray
);

DESCRIBE test_data;

-- Tokenize the test tweets to extract individual words
test_words = FOREACH test_data GENERATE FLATTEN(TOKENIZE(OriginalTweet)) AS word;

-- Remove any stop words using a Left Outer Join for test tweets
test_words = JOIN test_words BY word LEFT OUTER, stop_words BY stop;
test_words = FILTER test_words BY stop_words::stop IS NULL;

-- Group the test data by word and calculate the counts
grouped_test_words = GROUP test_words BY word;
test_word_counts = FOREACH grouped_test_words GENERATE group AS word, COUNT(test_words) AS count;

-- Sort the test word counts in descending order
sorted_test_word_counts = ORDER test_word_counts BY count DESC;

-- Get the top 20 most frequent words in test tweets
top_20_test_words = LIMIT sorted_test_word_counts 20;

-- Print the result for test tweets
DUMP top_20_test_words;

-- Store the top 20 test words into a file
STORE top_20_test_words INTO '/pig/top_20_test_words.csv' USING PigStorage(',');
