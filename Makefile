SRC = $(wildcard src/Api*.elm)

output/elm.js: $(SRC)
	elm make --optimize $^ --output $@

clean:
	rm -f output/elm.js

.PHONY: clean