# vim: set noexpandtab :
TMP = tmp/
BIN = bin/
AORTA_DIR = aorta/
MAPS_DIR = $(AORTA_DIR)maps/
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

test-br: $(TMP)install-scala-for-aorta
	cd $(AORTA_DIR) && ./simulate maps/baton_rouge.map

$(MAPS_DIR)science_park.osm:
	curl "http://api.openstreetmap.org/api/0.6/map?bbox=4.95109,52.35284,4.96105,52.35745" > $(MAPS_DIR)science_park.osm

$(MAPS_DIR)amsterdam.osm:
	curl "http://api.openstreetmap.org/api/0.6/map?bbox=4.84,52.3428,4.9993,52.3875" > $(MAPS_DIR)amsterdam.osm

.PHONY: test_baton_rouge $(TMP)sbt-launch.jar install-scala-for-aorta
