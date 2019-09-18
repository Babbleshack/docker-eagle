FROM openjdk:7

RUN apt update \
        && apt install -y git maven vim

RUN mkdir -v /eagle-scheduler 

WORKDIR /eagle-scheduler

#maven 3.3.9
RUN wget http://apache.mirrors.tds.net/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.zip -O maven.zip \
        && unzip maven.zip \
        && rm -rf /usr/share/maven \
        && mv -v apache-maven-3.3.9 /usr/share/maven/

        #&& git clone https://github.com/epfl-labos/eagle.git eagle \
#Eagle and Eagle Spark plugin
RUN mkdir -pv eagle eagle-spark etc/eagle\
        && git clone https://github.com/ruby-/eagle-mod.git eagle \
        && git clone --single-branch --branch \
            eagle-beta https://github.com/epfl-labos/spark.git eagle-spark

#build eagle
RUN cd eagle \
        && mvn install -DskipTests

#build spark & plugin
RUN cd eagle-spark \
        && ./build/sbt assembly

COPY files/eagle.conf /eagle-scheduler/etc/eagle/eagle.conf
COPY files/run-spark.sh /eagle-scheduler

ENV EAGLE_JAR=/eagle-scheduler/eagle/target/eagle-1.0-PROTOTYPE.jar
ENV EAGLE_CONF=/eagle-scheduler/etc/eagle/eagle.conf
ENV START_BACKEND="java -XX:+UseConcMarkSweepGC  \
    -verbose:gc -XX:+PrintGCTimeStamps -Xmx2046m \
    -XX:+PrintGCDetails -cp \
    $EAGLE_JAR ch.epfl.eagle.daemon.EagleDaemon -c $EAGLE_CONF"
