TARGET = $(wildcard src/Api*.elm)
SOURCE = $(wildcard src/*.elm)

output/elm.js: $(SOURCE) Makefile
	elm make --optimize $(TARGET) --output $@

clean:
	rm -f output/elm.js

.PHONY: clean