FROM openjdk:7

RUN apt update \
        && apt install -y git maven

RUN mkdir -v /eagle-scheduler 

WORKDIR /eagle-scheduler

RUN mkdir -v eagle eagle-spark \
        && git clone https://github.com/epfl-labos/eagle.git eagle \
        && git clone https://github.com/epfl-labos/spark.git eagle-spark

RUN cd eagle \
        && mvn install -DskipTests

RUN cd eagle-spark \
        && ./build/sbt assembly








