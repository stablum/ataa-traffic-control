TMP = tmp/
BIN = bin/
AORTA_DIR = aorta/
SBT_LAUNCH_URL = http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.1/sbt-launch.jar
AORTA_REPO_URL = https://code.google.com/p/road-rage

all: install-scala-for-aorta

install-scala-for-aorta: $(TMP)sbt-launch.jar $(AORTA_DIR)
	cd $(AORTA_DIR) && ../$(BIN)/sbt.sh compile && ../$(BIN)/sbt.sh pack

$(TMP):
	mkdir -p $(TMP)

$(TMP)sbt-launch.jar: $(TMP)
	cd $(TMP) && wget $(SBT_LAUNCH_URL)

$(AORTA_DIR):
	git clone $(AORTA_REPO_URL) $(AORTA_DIR)

clean:
	rm -Rvf $(TMP) $(AORTA_DIR)

.PHONY: install-scala-for-aorta

