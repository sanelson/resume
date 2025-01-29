SHELL := /bin/bash
ENVFILE = .env
# Set the job name to customize the resume and skills. Default is 'resume'.
# eg: make JOB=meta
JOB ?= resume

all: pdf

pdf: resume.tex $(ENVFILE) $(SKILLS)
	docker run -i --rm --name latex \
	-u `id -u`:`id -g` \
	--env-file $(ENVFILE) \
	-v "${PWD}":/usr/src/app \
	-w /usr/src/app \
	registry.gitlab.com/islandoftex/images/texlive:latest \
	pdflatex --jobname "$(JOB)" resume.tex \
	&& rm -f $(JOB).{aux,log,out} \
	&& if [[ "$(JOB)" != "resume" ]]; then mv $(JOB).pdf $(JOB)_resume.pdf; fi

public-pdf: resume.tex $(ENVFILE) $(SKILLS)
	docker run -i --rm --name latex \
	-u `id -u`:`id -g` \
	--env-file $(ENVFILE) \
	-e MYPHONE="123-456-7890" \
	-e MYEMAIL="spam@alot.py" \
	-v "${PWD}":/usr/src/app \
	-w /usr/src/app \
	registry.gitlab.com/islandoftex/images/texlive:latest \
	pdflatex --jobname "$(JOB)" resume.tex \
	&& rm -f $(JOB).{aux,log,out}

png: pdf
	convert -density 150 -background white -flatten resume.pdf resume.png

public-png: public-pdf
	convert -density 150 -background white -flatten resume.pdf resume.png

clean:
	rm -f resume.pdf resume.aux resume.log resume.out
