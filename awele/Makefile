# for building Awele strategies
SRC= general.lisp strategy.lisp player.lisp house-number.lisp house.lisp houses.lisp stat.lisp strategy-player.lisp strategies.lisp game.lisp standalone.lisp

GUI = package.lisp $(SRC) gui-awele-package.lisp gui-awele.lisp
STRATEGIES-DIRECTORY = Strategies
OBJECTS-DIRECTORY = $(STRATEGIES-DIRECTORY)/Objects

RANDOM= $(SRC) random-strategy.lisp
SMALLEST= $(SRC) smallest-strategy.lisp
HEAVIEST= $(SRC) heaviest-strategy.lisp
MINMAX= $(SRC) gain.lisp minmax.lisp minmax-strategy.lisp

all: $(STRATEGIES-DIRECTORY)/random.lisp $(STRATEGIES-DIRECTORY)/smallest.lisp $(STRATEGIES-DIRECTORY)/heaviest.lisp  $(STRATEGIES-DIRECTORY)/minmax.lisp

$(STRATEGIES-DIRECTORY)/random.lisp: $(RANDOM)
	strip.sh $(RANDOM) > $@

$(STRATEGIES-DIRECTORY)/smallest.lisp: $(SMALLEST)
	strip.sh $(SMALLEST) > $@

$(STRATEGIES-DIRECTORY)/heaviest.lisp: $(HEAVIEST)
	strip.sh $(HEAVIEST) > $@

$(STRATEGIES-DIRECTORY)/minmax.lisp: $(MINMAX)
	strip.sh $(MINMAX) > $@

.PHONY: clean

clean:
	rm -f *.fasl *~
	rm -f $(OBJECTS-DIRECTORY)/*.fasl
	rm $(STRATEGIES-DIRECTORY)/*.lisp
