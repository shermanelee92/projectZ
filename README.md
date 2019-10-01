# Project Z 
This project contains Hadoop, Spark and Hive

# Setup
Build all docker images in the database, master and slave folder
(It will take awhile ...)

Build hive sql image
```
cd database
docker build -t mysql-db-img .
```
Build Hadoop master image (contains spark too)
```
cd master
docker build -t hadoop-master-img .
```

Build Hadoop slave image
```
cd slave
docker build -t hadoop-slave-img .
```

After building all images, run in root project folder
```
docker-compose up
```

Then run 
```
./setup.sh
```

The script will ask where to store the rsa thingy, just enter all the way
If there are any yes/no questions answer yes. Password is root.

Please refer to the scripts (database/master folders) on what it does as I am too lazy to write out.

# How do I know if I setup correctly?

Go to http://localhost:8088, you will be able to see the hadoop web page with 2 active nodes!

Try running a spark submit command, go to localhost:8080 and you can see the active jobs!
```
docker exec -it hadoop-master /bin/bash
cd spark
./bin/spark-submit --class org.apache.spark.examples.SparkPi \
    --master yarn \
    --deploy-mode cluster \
    --driver-memory 4g \
    --executor-memory 2g \
    --executor-cores 1 \
    examples/jars/spark-examples*.jar \
    10

```

Check if you can access the hive table

```
docker exec -it hadoop-master /bin/bash
spark/bin/spark-shell
val sqlContext = new org.apache.spark.sql.hive.HiveContext(sc)
sqlContext.sql("show databases").show()
```

Yay!
