TMP = tmp/
BIN = bin/

$(TMP):
	mkdir -p $(TMP)

$(TMP)sbt-launch.jar: $(TMP)
	cd $(TMP) && wget http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.1/sbt-launch.jar

clean:
	rm -rvf $(TMP)
