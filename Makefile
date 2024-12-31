TOP_DIR := $(shell pwd)

ARCH := aarch64


DOCKER_PLATFORM=linux/$(ARCH)

PKG_DIR := $(TOP_DIR)/archives
BLD_DIR := $(TOP_DIR)/build
PAT_DIR := $(TOP_DIR)/patches
DEB_DIR := $(TOP_DIR)/debs


LSB_PKG := linuxsampler
LSB_PKG_VER := 2.3.1
LSB_PKG_ARC = $(PKG_DIR)/$(LSB_PKG)-$(LSB_PKG_VER).tar.bz2
LSB_BLD_DIR = $(BLD_DIR)/$(LSB_PKG)-$(LSB_PKG_VER)


GIG_PKG := libgig
GIG_PKG_VER := 4.4.1
GIG_PKG_ARC := $(PKG_DIR)/$(GIG_PKG)-$(GIG_PKG_VER).tar.bz2
GIG_BLD_DIR := $(BLD_DIR)/$(GIG_PKG)-$(GIG_PKG_VER)


LSCP_PKG := liblscp
LSCP_PKG_VER := 1.0.0
LSCP_PKG_ARC := $(PKG_DIR)/$(LSCP_PKG)-$(LSCP_PKG_VER).tar.gz
LSCP_BLD_DIR := $(BLD_DIR)/$(LSCP_PKG)-$(LSCP_PKG_VER)/build


GIGE_PKG := gigedit
GIGE_PKG_VER := 1.2.1
GIGE_PKG_ARC := $(PKG_DIR)/$(GIGE_PKG)-$(GIGE_PKG_VER).tar.bz2
GIGE_BLD_DIR := $(BLD_DIR)/$(GIGE_PKG)-$(GIGE_PKG_VER)


QJAC_PKG := qjackctl
QJAC_PKG_VER := 1.0.3
QJAC_PKG_ARC := $(PKG_DIR)/$(QJAC_PKG)-$(QJAC_PKG_VER).tar.gz
QJAC_BLD_DIR := $(BLD_DIR)/$(QJAC_PKG)-$(QJAC_PKG_VER)
QJAC_PKG_DEB := $(PKG_DIR)/$(QJAC_PKG)_$(QJAC_PKG_VER)-1.debian.tar.xz


QSAM_PKG := qsampler
QSAM_PKG_VER := 1.0.0
QSAM_PKG_ARC := $(PKG_DIR)/$(QSAM_PKG)-$(QSAM_PKG_VER).tar.gz
QSAM_BLD_DIR := $(BLD_DIR)/$(QSAM_PKG)-$(QSAM_PKG_VER)
QSAM_PKG_DEB := $(PKG_DIR)/$(QSAM_PKG)_$(QSAM_PKG_VER)-1.debian.tar.xz


all: $(GIG_PKG) $(LSB_PKG) $(QJAC_PKG) $(QSAM_PKG)
	mv $(BLD_DIR)/*.deb $(DEB_DIR)
	mv $(BLD_DIR)/*.changes $(DEB_DIR)
	mv $(BLD_DIR)/*.buildinfo $(DEB_DIR)



prepare:
	apt install build-essential libsndfile-dev libgtk2.0-dev libgtkmm-2.4-dev \
		cmake libqt6svg6-dev qt6-base-dev qt6-tools-dev qt6-tools-dev-tools libx11-dev \
		liblscp-dev

## libgig
$(GIG_BLD_DIR):
	tar -xvjpf $(GIG_PKG_ARC) -C $(BLD_DIR)

$(GIG_PKG).deb: $(GIG_BLD_DIR)
	cd $(GIG_BLD_DIR) && dpkg-buildpackage -rfakeroot -b --no-sign

$(GIG_PKG): $(GIG_PKG).deb


## Linux Sampler
$(LSB_BLD_DIR):
	tar -xvpf $(LSB_PKG_ARC) -C $(BLD_DIR)
ifeq ($(ARCH),aarch64)
	cd $(LSB_BLD_DIR) && patch -p0 < $(PAT_DIR)/linuxsampler-aarch64.patch
endif


$(LSB_PKG).deb: $(LSB_BLD_DIR)
	cd $(LSB_BLD_DIR) && dpkg-buildpackage -rfakeroot -b --no-sign

$(LSB_PKG):$(LSB_PKG).deb


## liblscp
$(LSCP_BLD_DIR):
	tar -xvzpf $(LSCP_PKG_ARC) -C $(BLD_DIR)

$(LSCP_PKG).deb: $(LSCP_BLD_DR)
	cd $(LSCP_BLD_DIR) && dpkg-buildpackage -rfakeroot -b --no-sign -nc

$(LSCP_PKG): $(LSCP_PKG).deb


## gigiedit
$(GIGE_BLD_DIR):
	tar -xvjpf $(GIGE_PKG_ARC) -C $(BLD_DIR)

$(GIGE_PKG).deb: $(GIGE_BLD_DIR)
	cd $(GIGE_BLD_DIR) && dpkg-buildpackage -rfakeroot -b --no-sign -nc

$(GIGE_PKG): $(GIGE_PKG).deb


## qjackctl
$(QJAC_BLD_DIR):
	tar -xvzpf $(QJAC_PKG_ARC) -C $(BLD_DIR)
	tar -xvJpf $(QJAC_PKG_DEB) -C $(QJAC_BLD_DIR)

$(QJAC_PKG).deb: $(QJAC_BLD_DIR)
	cd $(QJAC_BLD_DIR) && dpkg-buildpackage -rfakeroot -b --no-sign -nc

$(QJAC_PKG): $(QJAC_PKG).deb


## qsampler
$(QSAM_BLD_DIR):
	tar -xvzpf $(QSAM_PKG_ARC) -C $(BLD_DIR)
	tar -xvJpf $(QSAM_PKG_DEB) -C $(QSAM_BLD_DIR)

$(QSAM_PKG).deb: $(QSAM_BLD_DIR)
	cd $(QSAM_BLD_DIR) && dpkg-buildpackage -rfakeroot -b --no-sign -nc

$(QSAM_PKG): $(QSAM_PKG).deb



## Docker
docker.build:
	docker run -v $(TOP_DIR):/build ls-build make

docker.image:
	docker build $(DOCKER_PLATFORM) -t ls-build .

docker.exec:
	docker run $(DOKER_PLATFORM) -it -v $(TOP_DIR):/build ls-build bash


dist-clean: 
	rm -rf $(BLD_DIR)/*
