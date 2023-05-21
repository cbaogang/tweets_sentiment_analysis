from pyspark.ml.linalg import Vectors
from pyspark.sql import SparkSession
from pyspark.ml import Pipeline
from pyspark.ml.classification import LogisticRegression, RandomForestClassifier, DecisionTreeClassifier
from pyspark.ml.feature import HashingTF, Tokenizer
from pyspark.sql.functions import expr
from pyspark.ml.evaluation import MulticlassClassificationEvaluator

# Create a SparkSession
spark = SparkSession.builder.appName("ClassificationExample").config("spark.driver.memory", "4g").config("spark.executor.memory", "4g").getOrCreate()

# Prepare training documents from a list of (id, text, label) tuples.
# Read the training data from a CSV file
training = spark.read.csv("/covid_twitter/train_tweet.csv", header=True, inferSchema=True)

# Read the test data from a CSV file
test = spark.read.csv("/covid_twitter/test_tweet.csv", header=True, inferSchema=True)

# Filter out rows with "Neutral" sentiment
training = training.filter(training["Sentiment"] != "Neutral")
test = test.filter(test["Sentiment"] != "Neutral")

# Define the mapping of sentiment labels to numerical values
sentiment_mapping = {
    "Negative": 0,
    "Positive": 1,
    "Extremely Positive": 1,
    "Extremely Negative": 0
}

# Apply the mapping to create a new column
training = training.withColumn("sentiment_numeric", expr("CASE WHEN Sentiment IN ('Negative', 'Extremely Negative') THEN 0 ELSE 1 END"))
test = test.withColumn("sentiment_numeric", expr("CASE WHEN Sentiment IN ('Negative', 'Extremely Negative') THEN 0 ELSE 1 END"))

# Create ML pipelines for different models
tokenizer = Tokenizer(inputCol="OriginalTweet", outputCol="words")
hashingTF = HashingTF(inputCol=tokenizer.getOutputCol(), outputCol="features")

lr = LogisticRegression(featuresCol="features", labelCol="sentiment_numeric")
# rf = RandomForestClassifier(featuresCol="features", labelCol="sentiment_numeric")
# dt = DecisionTreeClassifier(featuresCol="features", labelCol="sentiment_numeric")

pipeline_lr = Pipeline(stages=[tokenizer, hashingTF, lr])
# pipeline_rf = Pipeline(stages=[tokenizer, hashingTF, rf])
# pipeline_dt = Pipeline(stages=[tokenizer, hashingTF, dt])

# Train and evaluate different models
# models = [("Logistic Regression", pipeline_lr), ("Random Forest", pipeline_rf), ("Decision Tree", pipeline_dt)]
models = [("Logistic Regression", pipeline_lr)]

for model_name, pipeline in models:
    model = pipeline.fit(training)
    predictions = model.transform(test)

    # Save predictions to a CSV file
    predictions.select("OriginalTweet", "Sentiment", "sentiment_numeric","prediction").write.csv(f"/covid_twitter/{model_name}_predictions.csv", header=True)
    
    
    evaluator = MulticlassClassificationEvaluator(labelCol="sentiment_numeric", predictionCol="prediction", metricName="accuracy")
    accuracy = evaluator.evaluate(predictions)
    
    print(model_name + " Accuracy:", accuracy)

# Stop the SparkSession
spark.stop()
