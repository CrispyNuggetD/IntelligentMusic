#
# TransFig makefile (modified by Bob and added to CVS)
#

all: insert_internal.eps insert_internal.pdf object-design.eps object-design.pdf

# translation into eps and pdf

object-design.eps: object-design.dia Makefile
	dia -e object-design.eps object-design.dia

object-design.pdf: object-design.eps Makefile
	epstopdf object-design.eps

insert_internal.eps: insert_internal.fig Makefile
	fig2dev -L eps insert_internal.fig > insert_internal.eps

insert_internal.pdf: insert_internal.eps Makefile
	epstopdf insert_internal.eps

clean::
	rm -f insert_internal.eps insert_internal.pdf object-design.eps object-design.pdf

