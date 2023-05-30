-- Load the tweet data from HDFS
tweet_data = LOAD '/covid_twitter/tweet_data.csv' USING PigStorage(',') AS (
    UserName: int,
    ScreenName: int,
    Location: chararray,
    TweetAt: chararray,
    OriginalTweet: chararray,
    Sentiment: chararray
);

-- Tokenize the OriginalTweet field to extract individual words
tokenized_data = FOREACH tweet_data GENERATE FLATTEN(TOKENIZE(OriginalTweet)) AS word;

-- Group the words and calculate the counts
grouped_words = GROUP tokenized_data BY word;
word_counts = FOREACH grouped_words GENERATE group AS word, COUNT(tokenized_data) AS count;

-- Sort the word counts in descending order
sorted_word_counts = ORDER word_counts BY count DESC;

-- Get the top 20 most frequent words
top_20_words = LIMIT sorted_word_counts 20;

-- Print the result for top 20 words
DUMP top_20_words;

-- Store the top 20 words into a file
-- STORE top_20_words INTO '/pig/top_words.csv' USING PigStorage(',');
