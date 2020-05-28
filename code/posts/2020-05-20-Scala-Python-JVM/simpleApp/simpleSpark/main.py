from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .master("local[*]") \
    .appName("simpleSpark") \
    .getOrCreate()

sc = spark.sparkContext
# sc.setLogLevel("ERROR")


def logLevel(sc):
    # REF: https://stackoverflow.com/questions/25193488/how-to-turn-off-info-logging-in-spark
    log4jLogger = sc._jvm.org.apache.log4j
    log4jLogger.Logger.getLogger("org").setLevel(log4jLogger.Level.ERROR)
    log = log4jLogger.LogManager.getLogger(__name__)
    log.warn("Custom WARN message")


logLevel(sc)


print(spark.range(5000).where("id > 500").selectExpr("sum(id)").collect())

sc._jvm.simple.SimpleApp.hello()
