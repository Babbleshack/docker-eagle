#!/bin/bash
SMALL=big
/eagle-scheduler/eagle-spark/bin/spark-run -Dspark.driver.host=eagle-master \
        -Dspark.driver.port=60501 \
        -Dspark.scheduler=eagle \
        -Deagle.app.name=spark_eagle-master \
        -Dspark.serializer=org.apache.spark.serializer.KryoSerializer \
        -Dspark.broadcast.port=33644 \
        org.apache.spark.examples.JavaSleep "eagle@$SCHEDULER:20503" 5 3 eagle-master $SMALL /trace
