PROJECT_DIR=$(shell pwd)
HLS_PROJECT_DIR=$(PROJECT_DIR)/vitis_hls/getphasemap2
IP_REPO=$(PROJECT_DIR)/vitis_hls/ip_repo
VIVADO_PROJECT_DIR=$(PROJECT_DIR)/vivado/cabin2_v2
XSA_DIR=$(PROJECT_DIR)/vivado/xsa
PLNX_PROJECT_DIR=$(PROJECT_DIR)/plnx/cabin2_petalinux
QT_PROJECT_DIR=$(PROJECT_DIR)/qt/SonyTOF_client

HLS_GIT=git@github.com:Deep-In-Sight/getphasemap2.git
HLS_REV=67a3e764c3a6dc82a04358436b2a46a3fbdabf27
VIVADO_GIT=git@github.com:Deep-In-Sight/cabin2_v2.git
VIVADO_REV=f95f6caa5e929ce8bfe49a8d4e5cbd1925fada2a
PLNX_GIT=git@github.com:Deep-In-Sight/cabin2_petalinux.git
PLNX_REV=73d43b5d3ffc847175effd63a56df3edd3ed4f24
QT_CLIENT_GIT=git@github.com:Deep-In-Sight/SonyTOF_client.git
QT_CLIENT_REV=477f7a160b2c6588586494a8dfa2bf3aeeaab7a1

.PHONY: all ip xsa plnx qt_client

all: ip xsa plnx qt_client
	@echo "All targets built"

clean: clean_xsa clean_plnx clean_qt_client
	@echo "All artifacts cleaned"

help:
	@echo "make all 		: build everything"
	@echo "make clean 		: clean everything"
	@echo "make xsa 		: create vivado project and generate bitstream, then export hardware platform definition"
	@echo "make plnx		: create petalinux project and compile, export sdk and sysroot"
	@echo "make qt_client	: compile GUI application"

plnx: 
	@echo "#########################################"
	@echo "#      Building petalinux and apps      #"
	@echo "#########################################"
	git clone $(PLNX_GIT) $(PLNX_PROJECT_DIR)
	cd $(PLNX_PROJECT_DIR) && git checkout $(PLNX_REV)
	cp $(XSA_DIR)/cabin2_v2.xsa $(PLNX_PROJECT_DIR)/
	$(MAKE) -C $(PLNX_PROJECT_DIR) all

xsa: 
	@echo "#########################################"
	@echo "#      Building hardware platform       #"
	@echo "#########################################"
	git clone $(VIVADO_GIT) $(VIVADO_PROJECT_DIR)
	cd $(VIVADO_PROJECT_DIR) && git checkout $(VIVADO_REV)
	$(MAKE) -C $(VIVADO_PROJECT_DIR) all

clean_xsa:
	-rm -rf vitis_hls/getPhaseMap2/solution1
	-rm -rf vitis_hls/ip_repo/getPhaseMap2

ip: 
	@echo "#########################################"
	@echo "#         Generating TOF IP             #"
	@echo "#########################################"
	git clone $(HLS_GIT) $(HLS_PROJECT_DIR)
	cd $(HLS_PROJECT_DIR) && git checkout $(HLS_REV)
	$(MAKE) -C $(HLS_PROJECT_DIR) all
	unzip $(IP_REPO)/getPhaseMap2.zip -d $(IP_REPO)/getPhaseMap2

qt_client:
	@echo "#########################################"
	@echo "#         Building QT client app        #"
	@echo "#########################################"
	git clone $(QT_CLIENT_GIT) $(QT_PROJECT_DIR)
	cd $(QT_PROJECT_DIR) && git checkout $(QT_CLIENT_REV)
	$(MAKE) -C $(QT_PROJECT_DIR) all

make_dirs:
	-mkdir vitis_hls
	-mkdir vivado
	-mkdir plnx
	-mkdir qt
