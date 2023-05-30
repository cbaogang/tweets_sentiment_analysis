from pyspark.sql import SparkSession
from pyspark.sql.functions import explode, split, lower, desc

# Create a SparkSession
spark = SparkSession.builder.appName("TopWords").config("spark.driver.memory", "4g").config("spark.executor.memory", "4g").config("spark.eventLog.enabled", "true").getOrCreate()

# Read the data from a CSV file
data = spark.read.csv("/covid_twitter/tweet_data.csv", header=True, inferSchema=True)

# Select and explode the words from the OriginalTweet column
word_df = data.select(explode(split(lower(data["OriginalTweet"]), " ")).alias("word"))

# Group by word and count the occurrences
word_counts = word_df.groupBy("word").count()

# Sort the words in descending order of count
sorted_words = word_counts.sort(desc("count"))

# Take the top 20 words
top_20_words = sorted_words.limit(20)

# Show the result
top_20_words.show()
