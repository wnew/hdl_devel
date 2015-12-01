MODULE=sw_reg_wr

GENDIR=./gen

TB_OBJ=$(GENDIR)/$(MODULE).o
TB_SRC=$(MODULE)_tb.v
OBJ=$(GENDIR)/$(MODULE).o
SRC=$(MODULE).v
LOG_FILE=$(GENDIR)/log.txt


VCC=iverilog
#INCLUDE=-I
FLAGS=-Wall

VSIM=vpp

sim: $(LOG_FILE)

$(LOG_FILE): $(TB_OBJ)
	$(VSIM) $(TB_OBJ) > $@
	@!(cat $@ | grep FAILED && rm -rf $^)
	@(cat $@ | grep PASSED)


$(TB_OBJ): $(TB_SRC) $(SRC)
   #$(VCC) $(INCLUDE) $(FLAGS) $(DEFINES) -o $@ $^
	$(VCC) $(FLAGS) -o $@ $^

clean:
	rm -Rf ./$(GENDIR)/*
