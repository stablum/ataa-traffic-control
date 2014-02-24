# vim: set noexpandtab :
TMP = tmp/
SA=$(TMP).install-scala-for-aorta.done
BIN = bin/
AORTA_DIR = aorta/
AORTA_CLONE_DONE=$(AORTA_DIR).done
RELATIVE_MAPS_DIR = maps/
MAPS_DIR = $(AORTA_DIR)$(RELATIVE_MAPS_DIR)
RELATIVE_OSM_DIR = osm/
OSM_DIR = $(AORTA_DIR)$(RELATIVE_OSM_DIR)

DIRS = $(TMP) $(BIN) $(MAPS_DIR) $(OSM_DIR)

SBT_LAUNCH_URL = http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.1/sbt-launch.jar
AORTA_REPO_URL = https://code.google.com/p/road-rage
RM = rm -Rvf

all: $(SA)

foobar:
	touch foobar

$(SA): $(TMP)sbt-launch.jar $(AORTA_CLONE_DONE)
	if test -z "$?"; \
	then \
		echo "$(SA) requirements were already fulfilled"; \
	else \
		( cd $(AORTA_DIR) && ../$(BIN)/sbt.sh compile && ../$(BIN)/sbt.sh pack ; ) ; \
		touch $(SA) ; \
		echo done with $(SA) ; \
	fi

dirs: $(DIRS)

$(DIRS):
	mkdir -p $@

$(TMP)sbt-launch.jar:
	mkdir -p $(TMP)
	cd $(TMP) && wget $(SBT_LAUNCH_URL)
	touch $@

$(AORTA_CLONE_DONE):
	git clone $(AORTA_REPO_URL) $(AORTA_DIR)
	touch $(AORTA_CLONE_DONE)

print-dirs:
	echo $(DIRS)

clean:
	$(RM) $(TMP) $(MAPS_DIR) $(AORTA_DIR) $(SA) $(MAPS_DIR)science_park.map

$(OSM_DIR)science_park.osm: $(OSM_DIR)
	curl "http://api.openstreetmap.org/api/0.6/map?bbox=4.95109,52.35284,4.96105,52.35745" > $@

$(OSM_DIR)amsterdam.osm: $(OSM_DIR)
	curl "http://api.openstreetmap.org/api/0.6/map?bbox=4.84,52.3428,4.9993,52.3875" > $@

$(OSM_DIR)small_synthetic_1lane.osm: $(OSM_DIR)
	cp small_synthetic_1lane.osm $(OSM_DIR)

$(MAPS_DIR)science_park.map: $(OSM_DIR)science_park.osm $(SA)
	( cd $(AORTA_DIR) ; pwd ; bash ./build_map $(RELATIVE_OSM_DIR)science_park.osm )

$(MAPS_DIR)small_synthetic_1lane.map: $(OSM_DIR)small_synthetic_1lane.osm $(SA)
	( cd $(AORTA_DIR) ; pwd ; bash ./build_map $(RELATIVE_OSM_DIR)small_synthetic_1lane.osm )

simulate-br: $(SA)
	( cd $(AORTA_DIR) ; ./simulate $(RELATIVE_MAPS_DIR)baton_rouge.map )

simulate-sp: $(MAPS_DIR)science_park.map $(SA)
	( cd $(AORTA_DIR) ; ./simulate $(RELATIVE_MAPS_DIR)science_park.map )

simulate-ss1l: $(MAPS_DIR)small_synthetic_1lane.map $(SA)
	( cd $(AORTA_DIR) ; ./simulate $(RELATIVE_MAPS_DIR)small_synthetic_1lane.map )

.PHONY: test_baton_rouge clean print-dirs dirs
