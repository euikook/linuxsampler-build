TOP_DIR := $(shell pwd)

PKG_DIR := $(TOP_DIR)/archives
BLD_DIR := $(TOP_DIR)/build
PAT_DIR := $(TOP_DIR)/patches


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


all: $(LSB_PKG)


## libgig
$(GIG_BLD_DIR):
	tar -xvjpf $(GIG_PKG_ARC) -C $(BLD_DIR)

$(GIG_BLD_DIR)/Makefile:
	echo  $@
	cd $(GIG_BLD_DIR) && ./configure

$(GIG_PKG).config: $(GIG_BLD_DIR)/Makefile


$(GIG_PKG).build: $(GIG_BLD_DIR) $(GIG_PKG).config
	cd $(GIG_BLD_DIR) && make


$(GIG_PKG): $(GIG_PKG).build


$(GIG_PKG).install: $(GIG_PKG)
	cd $(GIG_BLD_DIR) && sudo make install


## Linux Sampler
$(LSB_BLD_DIR):
	tar -xvpf $(LSB_PKG_ARC) -C $(BLD_DIR)
	cd $(LSB_BLD_DIR) && patch -p0 < $(PAT_DIR)/linuxsampler-aarch64.patch


$(LSB_BLD_DIR)/Makefile:
	cd $(LSB_BLD_DIR) && ./configure

$(LSB_PKG).config: $(LSB_BLD_DIR) $(LSB_BLD_DIR)/Makefile


$(LSB_PKG).build: $(LSB_BLD_DIR)
	cd $(LSB_BLD_DIR) && make

$(LSB_PKG).install:
	cd $(LSB_BLD_DIR) && make install


$(LSB_PKG): $(GIG_PKG).install $(LSB_PKG).config $(LSB_PKG).build

## liblscp
$(LSCP_BLD_DIR):
	tar -xvzpf $(LSCP_PKG_ARC) -C $(BLD_DIR)
	mkdir $(LSCP_BLD_DIR)

$(LSCP_BLD_DIR)/Makefile: $(LSCP_BLD_DIR)
	cd $(LSCP_BLD_DIR) && cmake ..

$(LSCP_PKG).config: $(LSCP_BLD_DIR)/Makefile


$(LSCP_PKG).build: $(LSCP_BLD_DIR)
	cd $(LSCP_BLD_DIR) && make

$(LSCP_PKG).install:
	cd $(LSCP_BLD_DIR) && make install


$(LSCP_PKG): $(LSCP_PKG).config $(LSCP_PKG).build


## gigiedit
$(GIGE_BLD_DIR):
	tar -xvjpf $(GIGE_PKG_ARC) -C $(BLD_DIR)

$(GIGE_BLD_DIR)/Makefile:
	echo  $@
	cd $(GIGE_BLD_DIR) && ./configure

$(GIGE_PKG).config: $(GIGE_BLD_DIR)/Makefile


$(GIGE_PKG).build: $(GIGE_BLD_DIR) $(GIGE_PKG).config 
	cd $(GIGE_BLD_DIR) && make

$(GIGE_PKG).install:
	cd $(GIGE_BLD_DIR) && make install


$(GIGE_PKG): $(GIGE_PKG).build


clean: 
	rm -rf $(BLD_DIR)/*


prepare:
	apt install build-essential libsndfile-dev libgtk2.0-dev libgtkmm-2.4-dev
