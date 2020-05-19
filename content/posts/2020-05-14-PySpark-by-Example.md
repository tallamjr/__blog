---
draft: false
title: "PySpark by Example"
author: "Tarek Allam Jr"
date: 2020-05-14
categories: [tutorials]
tags: [reproducibility, programming]
---

Here are my worked examples from the very useful LinkedIn Learning course: PySpark by Example by
Jonathan Fernandes : https://www.linkedin.com/learning/apache-pyspark-by-example

<!--more-->

# Learning PySpark by Example

Over the past 12 months or so I have been learning and playing with Apache Spark. I went through the
brilliant book by Bill Chambers and Matei Zaharia, *Spark: The Definitive Guide*, that covers Spark
in depth and gives plenty of code snippets one can try out in the `spark-shell`. Whilst the book is
indeed very detailed and provides great examples, the datasets that are included for you to get your
hands on are on the order of `Mb`'s (with the exception of the `activity-data` dataset used for the
Streaming examples).

```bash
$ du -sh data/* | sort -rh
1.2G    data/activity-data
90M     data/retail-data
71M     data/deep-learning-images
42M     data/bike-data
208K    data/flight-data
104K    data/sample_libsvm_data.txt
32K     data/sample_movielens_ratings.txt
32K     data/regression
32K     data/multiclass-classification
32K     data/clustering
32K     data/binary-classification
12K     data/simple-ml-integers
12K     data/flight-data-hive
8.0K    data/simple-ml
4.0K    data/simple-ml-scaling
4.0K    data/README.md

```

For this reason, I wanted to try out **PySpark by Example** that plays
with the City of Chicago's `reported-crimes.csv` dataset which is around `1.6Gb`.

Another reason for why that course and the related dataset was appealing, was I could use it as an
excuse to explore the plotting capabilities of [Ploty](https://plotly.com/python/), an interactive
library for plotting data. This dataset had location data combined with distributions of data.

## The Data

As mentioned, in the course, the City of Chicago, reported crimes data was used.

```bash
$ wget https://data.cityofchicago.org/api/views/ijzp-q8t2/rows.csv?accessType=DOWNLOAD
$ mv rows.csv\?accessType\=DOWNLOAD data/reported-crimes.csv
```

```python
%time
from pyspark.sql.functions import to_timestamp,col,lit
rc = spark.read.csv('data/reported-crimes.csv',header=True).withColumn('Date',to_timestamp(col('Date'),'MM/dd/yyyy hh:mm:ss a')).filter(col('Date') <= lit('2018-11-11'))
rc.show(5)
```

```less
CPU times: user 2 µs, sys: 0 ns, total: 2 µs
Wall time: 5.01 µs
+--------+-----------+-------------------+--------------------+----+-------------------+--------------------+--------------------+------+--------+----+--------+----+--------------+--------+------------+------------+----+--------------------+--------+---------+--------+
|      ID|Case Number|               Date|               Block|IUCR|       Primary Type|         Description|Location Description|Arrest|Domestic|Beat|District|Ward|Community Area|FBI Code|X Coordinate|Y Coordinate|Year|          Updated On|Latitude|Longitude|Location|
+--------+-----------+-------------------+--------------------+----+-------------------+--------------------+--------------------+------+--------+----+--------+----+--------------+--------+------------+------------+----+--------------------+--------+---------+--------+
|11034701|   JA366925|2001-01-01 11:00:00|     016XX E 86TH PL|1153| DECEPTIVE PRACTICE|FINANCIAL IDENTIT...|           RESIDENCE| false|   false|0412|     004|   8|            45|      11|        null|        null|2001|08/05/2017 03:50:...|    null|     null|    null|
|11227287|   JB147188|2017-10-08 03:00:00|  092XX S RACINE AVE|0281|CRIM SEXUAL ASSAULT|      NON-AGGRAVATED|           RESIDENCE| false|   false|2222|     022|  21|            73|      02|        null|        null|2017|02/11/2018 03:57:...|    null|     null|    null|
|11227583|   JB147595|2017-03-28 14:00:00|     026XX W 79TH ST|0620|           BURGLARY|      UNLAWFUL ENTRY|               OTHER| false|   false|0835|     008|  18|            70|      05|        null|        null|2017|02/11/2018 03:57:...|    null|     null|    null|
|11227293|   JB147230|2017-09-09 20:17:00|060XX S EBERHART AVE|0810|              THEFT|           OVER $500|           RESIDENCE| false|   false|0313|     003|  20|            42|      06|        null|        null|2017|02/11/2018 03:57:...|    null|     null|    null|
|11227634|   JB147599|2017-08-26 10:00:00| 001XX W RANDOLPH ST|0281|CRIM SEXUAL ASSAULT|      NON-AGGRAVATED|         HOTEL/MOTEL| false|   false|0122|     001|  42|            32|      02|        null|        null|2017|02/11/2018 03:57:...|    null|     null|    null|
+--------+-----------+-------------------+--------------------+----+-------------------+--------------------+--------------------+------+--------+----+--------+----+--------------+--------+------------+------------+----+--------------------+--------+---------+--------+
only showing top 5 rows

```
```python
rc.columns
```
```less
['ID',
 'Case Number',
 'Date',
 'Block',
 'IUCR',
 'Primary Type',
 'Description',
 'Location Description',
 'Arrest',
 'Domestic',
 'Beat',
 'District',
 'Ward',
 'Community Area',
 'FBI Code',
 'X Coordinate',
 'Y Coordinate',
 'Year',
 'Updated On',
 'Latitude',
 'Longitude',
 'Location']
```

#### What are the top 10 number of reported crimes by Primary type, in descending order of occurrence?


## *Things-I-Learned* [TIL]

1. A few key _things-I-learned_ during this post was how to embed interactive `plotly` figures into
markdown such that they can be rendered into the blog with ease.

    This can simply be done using the `to_html(..)` function:
    ```python
    import plotly
    plotly.io.to_html(fig, include_plotlyjs=False, full_html=False)
    ```
    This spits out a `<div>` element one can then place into their desired markdown, which will then translate as
    rendered `HTML`.

    To ensure just the `<div>` element is returned, `full_html=False` is required. Another thing to
    remeber is that this will return the element as a string, so the leading and trailing apostophe's
    that make it a string need to be removed. In the process of discovering this, a potential "bug" was
    found in this actual function, resulting in excessive `\n` characters being generated. So, the
    actual function that has been used for this post is:

    ```python
    import importlib.util
    spec = importlib.util.spec_from_file_location("plotly", "/Users/tallamjr/github/forks/plotly.py/packages/python/plotly/plotly/io/_html.py")
    foo = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(foo)
    foo.to_html(fig, include_plotlyjs=False, full_html=False)
    ```

    Which points to a forked version of the `plotly` codebase while I have an outstanding
    [PR](https://github.com/plotly/plotly.py/pull/2469) waiting to be reviewed.

    A final thing to mention, is that in order for all of the plots above to show up at all, even with
    the `<div>` elements, one needs to make sure to include the necessary Javascript tags. Therefore, in
    the `head.html` file for this blog, there exists:

    ```less
    $ sed -n 14,17p layouts/partials/head.html
    <!-- Plotly embeddings
    REF: http://www.kellieottoboni.com/posts/2017/08/plotly-markup/
    ================================================== -->
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    ```

2. Another *thing* I discovered was how to allow for better formatting of the `.show()` command on Spark DataFrames. My approach is explained in this StackOverflow post for [pyspark show dataframe as table with horizontal scroll in ipython notebook](https://stackoverflow.com/a/61867701/4521950) and [Improve PySpark DataFrame.show output to fit Jupyter notebook](https://stackoverflow.com/a/61867761/4521950):

        Adding to the answers given above by @karan-singla and @vijay-jangir, a handy one-liner to comment
        out the `white-space: pre-wrap` styling can be done like so:

        $ awk -i inplace '/pre-wrap/ {$0="/*"$0"*/"}1' $(dirname `python -c "import notebook as nb;print(nb.__file__)"`)/static/style/style.min.css

        This translates as; use `awk` to update _inplace_ lines that contain `pre-wrap` to be surrounded by
        `*/ -- */` i.e. comment out, on the file found in `styles.css` found in your working Python
        environment.

        This, in theory, can then be used as an alias if one uses multiple environments, say with Anaconda.
        - https://stackoverflow.com/a/24884616/4521950
        - https://stackoverflow.com/questions/16529716/save-modifications-in-place-with-awk

3. Finally, this is not necessarily something I learned during this post, but it opened my eyes to
   the possibilities that are available when using `nbconvert` The notebook for this post has been
   rendered [here](/blog/notebooks/PySpark-by-Example.html) using the following command:

   ```bash
    $ jupyter nbconvert --ExecutePreprocessor.kernel_name=python --ExecutePreprocessor.timeout=600 --to html --execute notebooks/*.ipynb --output-dir /Users/tallamjr/www/blog/static/notebooks
   ```

   After look for ways to link point number 1. above and how one can add custom `css`, I discovered
   the numerous customisations one can do. Some example can be found at
   https://github.com/jupyter/nbconvert-examples

## References and Resources

* The notebooks for this post can be found at [here](/blog/notebooks/PySpark-by-Example.html)
