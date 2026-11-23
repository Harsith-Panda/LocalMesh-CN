# Requires tectonic (brew install tectonic) or pdflatex + latexmk
.PHONY: all report phase2 architecture clean

all: report phase2 architecture

report: phase1-report.pdf
architecture: architecture-phase1.pdf

phase2: phase2-report.pdf

phase2-report.pdf: phase2-report.tex
	tectonic phase2-report.tex

phase1-report.pdf: phase1-report.tex diagrams.tex
	tectonic phase1-report.tex

architecture-phase1.pdf: architecture-phase1.tex diagrams.tex
	tectonic architecture-phase1.tex

clean:
	rm -f *.aux *.log *.out *.toc *.synctex.gz
