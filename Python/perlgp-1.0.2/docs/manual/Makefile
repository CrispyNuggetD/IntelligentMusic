#
# make all the different manual formats from the source
#

all: manual.dvi manual.ps manual_save_trees.ps html manual.pdf 

figs:
	cd figures && $(MAKE)

manual.dvi: manual.tex figs Makefile
	rm -f manual.{aux,toc} ; latex manual ; latex manual ; latex manual

manual.ps: manual.dvi Makefile
	dvips -o manual.ps manual

manual_save_trees.ps: manual.ps Makefile
	mpage -2 -t -T -o manual.ps > manual_save_trees.ps

manual.pdf: manual.tex figs Makefile
	rm -f manual.{aux,toc} ; pdflatex manual ; pdflatex manual ; pdflatex manual

html: manual/index.html

manual/index.html: manual.tex manual.dvi Makefile
	latex2html -local_icons -split +2 manual

tidy:
	rm -f manual.aux manual.log manual.toc manual.out

clean: tidy
	rm -rf manual/ manual.ps manual.dvi manual.pdf manual_save_trees.ps 

