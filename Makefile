TMP = tmp/
BIN = bin/
AORTA_DIR = aorta/

all: install-scala-for-aorta

install-scala-for-aorta: $(TMP)sbt-launch.jar $(AORTA_DIR)
	cd $(AORTA_DIR) && ../$(BIN)/sbt.sh compile

$(TMP):
	mkdir -p $(TMP)

$(TMP)sbt-launch.jar: $(TMP)
	cd $(TMP) && wget http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.1/sbt-launch.jar

$(AORTA_DIR):
	git clone https://code.google.com/p/road-rage $(AORTA_DIR)

clean:
	rm -Rvf $(TMP) $(AORTA_DIR)

.PHONY: install-scala-for-aorta

