clean:
   
	find . | grep a.out | xargs rm -f
	find . | grep dump.vcd | xargs rm -f
	find . | grep pyc | xargs rm -f
	find . | grep wrapper.v | xargs rm -f
test:

	iverilog all.v
