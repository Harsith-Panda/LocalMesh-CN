# Requires tectonic (brew install tectonic) or pdflatex + latexmk
.PHONY: all report architecture clean

all: report architecture

report: phase1-report.pdf
architecture: architecture-phase1.pdf

phase1-report.pdf: phase1-report.tex diagrams.tex
	tectonic phase1-report.tex

architecture-phase1.pdf: architecture-phase1.tex diagrams.tex
	tectonic architecture-phase1.tex

clean:
	rm -f *.aux *.log *.out *.toc *.synctex.gz
