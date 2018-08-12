CXX = g++

all: cskep1.py cskep2.py cskep1 cskep2 \
	osszeg1.py osszeg2.py osszeg \
  victor1.py victor2.py victor\
	caravan.py caravan

# Csoportkép 4/1 ############################################
cskep1.py: csoportkep.nw
	tangle2 -R $@ $< > $@

cskep2.py: csoportkep.nw
	tangle2 -R $@ $< > $@

cskep1.cpp: csoportkep.nw
	tangle2 -R $@ $< > $@

cskep2.cpp: csoportkep.nw
	tangle2 -R $@ $< > $@

cskep1: cskep1.cpp
	$(CXX) -std=c++11 -Wall -o $@ $<

cskep2: cskep2.cpp
	$(CXX) -std=c++11 -Wall -o $@ $<

# Karavánok 4/2 #########################################
caravan: caravan.cpp
	$(CXX) -std=c++11 -Wall -o $@ $^

# Osszeg 4/3 ############################################
osszeg1.py: osszeg.nw
	tangle2 -R $@ $< > $@
	
osszeg2.py: osszeg.nw
	tangle2 -R $@ $< > $@

osszeg: osszeg.cpp
	$(CXX) -std=c++11 -Wall -o $@ $^

# Legyőző 4/4 ###########################################
victor1.py: victor.nw
	tangle2 -R $@ $< > $@

victor2.py: victor.nw
	tangle2 -R $@ $< > $@

victor: victor.cpp
	$(CXX) -std=c++11 -Wall -o $@ $^

#############################################
%.py: %.nw
	tangle2 -R $@ $< > $@

%.cpp: %.nw
	tangle2 -R $@ $< > $@

%.md: %.nw
	nw2md < $< > $@

%.html: %.md
	pandoc -f markdown -s --toc -o $@ $<

%.pdf: %.md
	pandoc -f markdown -s --toc -o $@ $<

clean:
	rm -f *.cpp *py *.md

