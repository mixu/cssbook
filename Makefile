
book: concat
	generate-md \
	--layout ./layout \
	--input ./input \
	--highlight-problem ./layout/highlighters/problem.js \
	--highlight-snippet ./layout/highlighters/snippet.js \
	--highlight-inline-snippet ./layout/highlighters/inline-snippet.js \
	--highlight-snippet-matrix ./layout/highlighters/snippet-matrix.js \
	--highlight-spoiler ./layout/highlighters/spoiler.js

.PHONY: book

concat:
	mkdir -p ./output-single || true
	rm -rf ./tmp || true
	mkdir ./tmp
	cat input/index.md > ./tmp/single-page.md
	cat input/1-positioning.md | bin/remove-meta.js >> ./tmp/single-page.md
	cat input/2-box-model.md | bin/remove-meta.js>> ./tmp/single-page.md
	cat input/3-additional.md | bin/remove-meta.js >> ./tmp/single-page.md
	cat input/4-flexbox.md | bin/remove-meta.js >> ./tmp/single-page.md
	cat input/5-tricks.md | bin/remove-meta.js >> ./tmp/single-page.md
	cat input/reference.md | bin/remove-meta.js >> ./tmp/single-page.md
	generate-md \
	--input ./tmp/single-page.md \
	--layout ./layout \
	--output ./output \
	--highlight-problem ./layout/highlighters/problem.js \
	--highlight-snippet ./layout/highlighters/snippet.js \
	--highlight-inline-snippet ./layout/highlighters/inline-snippet.js \
	--highlight-snippet-matrix ./layout/highlighters/snippet-matrix.js \
	--highlight-spoiler ./layout/highlighters/spoiler.js

.PHONY: concat

upload:
	aws s3 sync ./output/ s3://book.mixu.net/css/ \
	--region us-west-1 \
	--delete \
	--exclude "node_modules/*" \
	--exclude ".git"

.PHONY: upload
