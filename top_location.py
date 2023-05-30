from pyspark.sql import SparkSession
from pyspark.sql.functions import desc

# Create a SparkSession
spark = SparkSession.builder.appName("TopLocations").config("spark.driver.memory", "4g").config("spark.executor.memory", "4g").config("spark.eventLog.enabled", "true").getOrCreate()

# Read the data from a CSV file
data = spark.read.csv("/covid_twitter/tweet_data.csv", header=True, inferSchema=True)

# Register the DataFrame as a temporary view
data.createOrReplaceTempView("tweet")

# Perform the SQL query
top_10_locations = spark.sql("SELECT Location, COUNT(*) AS TweetCount FROM tweet GROUP BY Location ORDER BY TweetCount DESC LIMIT 10")

# Show the result
top_10_locations.show()
