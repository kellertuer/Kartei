%
%		* ----------------------------------------------------------------------------
%		* "THE BEER-WARE LICENSE" (Revision 42/023):
%		* Ronny Bergmann <mail@darkmoonwolf.de> wrote this file. As long as you retain 
%		* this notice you can do whatever you want with this stuff. If we meet some day,
%		* and you think  this stuff is worth it, you can buy me a beer or a coffee in return. 
%		* ----------------------------------------------------------------------------
%
%
% Dokumentklasse für Din A6 Karteikarten 
% -- Version 1.8 --
%
% Erklärungen und Ähnliches, siehe manual.pdf

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kartei}[2009/12/26 Karteikarten in LaTeX, Version 1.8]
\newcommand{\setcardpagelayout}{}

\makeatletter
%
% lokale Variablen
%
%Print Version oder nicht ?
\newif\ifcard@useprint
%Standard: Kein Print
\card@useprintfalse%

% Border Style
% 0 = DIN A6
% 1 = DIN A7
% 2 = DIN A8
% 3 = DIN A9
\newcount\card@papersize
%Standard: A6 
\card@papersize=0%

%
% Antwort (Standard Rückseite Mitte
% Answer
%
%
\newcommand{\dieantwort}{%
\antwortstil{\card@antwort}\relax%
}
\newcommand{\antwort}[1]{\def\card@antwort{#1}}%
\newcommand{\antwortstil}{}
%Expliziter Standard: leer (Antwort wird am Ende des Dokumentes gesetzt
\global\let\card@antwort\@empty

%english names
\newcommand{\answer}{}
\let\answer=\antwort
\newcommand{\theanswer}{}
\let\theanswer=\dieantwort
\newcommand{\answerstyle}{}
\let\answerstyle=\antwortstil

%
% Fach (Standard vorne links)
% Subject
%
%
\newcommand{\dasfach}[1]{%
\ifx\@empty#1%
\fachstil{\card@fach}\relax%
\else%
\fachstil{#1}%
\fi%
}
\newcommand{\fach}[1]{\def\card@fach{#1}}%
\newcommand{\fachstil}{\emph}
%Expliziter Standard: leer
\global\let\card@fach\@empty

%english names
\newcommand{\cardsubject}{}
\let\cardsubject=\fach
\newcommand{\thesubject}{}
\let\thesubject=\dasfach
\newcommand{\subjectstyle}{}
\let\subjectstyle=\fachstil

%
% Kommentar 2 (Standard vorne rechts)
%
%
\newcommand{\derkommentar}[1]{%
\ifx\@empty#1%
	\kommentarstil\card@kommentar\relax%
\else%
	\kommentarstil{#1}
\fi%
}
\newcommand{\kommentar}[1]{\def\card@kommentar{#1}}%
\newcommand{\kommentarstil}{\emph}
% Expluiziter Standard : leer
\global\let\card@kommentar\@empty

% Rotation
\newcount\card@backsiderotation
%Standard: 0 Degree, nicht überkopf 
\card@backsiderotation=0%

%english names
\newcommand{\comment}{}
\let\comment=\kommentar
\newcommand{\thecomment}{}
\let\thecomment=\derkommentar
\newcommand{\commentstyle}{}
\let\commentstyle=\kommentarstil

%
% Declare options
%

\DeclareOption{flip}
{
\card@backsiderotation=180%
}

\DeclareOption{print}{%
\card@useprinttrue
}%


\DeclareOption{a6paper}{
\card@papersize=0%
}

\DeclareOption{a7paper}{
\card@papersize=1%
}%

\DeclareOption{a8paper}{
\card@papersize=2%
}%	

\DeclareOption{a9paper}{
\card@papersize=3%
}%	

%All unknown Options to article
\DeclareOption*{% 
\PassOptionsToClass{\CurrentOption}{scrartcl}% 
}
\ProcessOptions\relax
\LoadClass[twoside]{scrartcl}
\RequirePackage[headsepline,footsepline]{scrpage2}
\RequirePackage{xargs}
\RequirePackage{vmargin}

	\ifcase \card@papersize%
			\setpapersize[landscape]{A6}% 
			\setmarginsrb{7mm}{2mm}{7mm}{4mm}{1.3em}{1em}{0mm}{1em}%
		\or
		%DIN A7 because 1
			\setpapersize[landscape]{A7}% 
			\setmarginsrb{5mm}{2mm}{5mm}{3mm}{1.3em}{.7em}{0mm}{1em}%
		\or
		%DIN A8 because 2
		\setpapersize[landscape]{A8}% 
		\setmarginsrb{3mm}{2mm}{3mm}{2mm}{1.3em}{.3em}{0mm}{1em}%
		\or
		%DIN A9 because 3
		\setpapersize[landscape]{A9}% 
		\setmarginsrb{1mm}{2mm}{1mm}{1mm}{1.3em}{.3em}{0mm}{1em}%
	\fi

\ifcard@useprint%
\setpapersize[landscape]{A4}% 
	\ifcase \card@papersize%
			\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA6}[a4paper, landscape, border shrink=0mm]}%
		\or
		%DIN A7 because 1
			\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA7}[a4paper, border shrink=0mm]}%
		\or
		%DIN A8 because 2
			\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA8}[a4paper, landscape, border shrink=0mm]}%
		\or
		%DIN A9 because 3
			\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA9}[a4paper, border shrink=0mm]}%
	\fi
\else
	\renewcommand{\setcardpagelayout}{} % no print
\fi	

\RequirePackage{pgfpages,tikz}

\input{kartei.pageshipout.tex}

\makeatother

\input{kartei.a6printstyle}

\input{kartei.a7printstyle}

\input{kartei.a8printstyle}

\input{kartei.a9printstyle}

%
% Karteikartenzähler & Ausgabe des Counters in Form „# Nummer“ bei Referenzen und in der Kopfzeile
%
\newcounter{CardID}
\renewcommand{\theCardID}{\emph{\# \arabic{CardID}}}

\makeatletter
% Section wird nun für Fächer verwendet
% Dazu wird zunächst die alte Section gesichert
\newcommand{\origsection}{}
\let\origsection=\section
%
% Makro nun neu definieren:
\def\section{\@ifstar\unnumberedsection\numberedsection} 
\def\numberedsection#1{\refstepcounter{section}\fach{\thesection.\ #1}}%
\def\unnumberedsection#1{\fach{#1}}%

% Subsection wird nun für das Kommentarfeld verwendet
% Dazu wird zunächst die alte Subsection gesichert
\newcommand{\origsubsection}{}
\let\origsubsection=\subsection
% Zähler nur auf subseciton setzen
%
% Makro nun neu definieren:
\def\subsection{\@ifstar\unnumberedsubsection\numberedsubsection} 
\def\numberedsubsection#1{%
	\renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
	\refstepcounter{subsection}%
	\kommentar{\thesubsection.\ #1}}%
\def\unnumberedsubsection#1{%
\renewcommand{\thesubsection}{\arabic{subsection}}
\kommentar{#1}}%
%
% Pagestyle commands
%
\def\cardtitleheader{}%
\def\cardbackheader{\theCardID\hfill\dieantwort\hfill}%
\def\cardtitlefooter{}%
\def\cardbackfooter{}%

%
%	Karteikartenumgebung:
%	#1 (optional) Kopfzeile vorne Links : Fach
% 	#2 Titel der Vorderseite  	
% 	#3 (optional) Kopfzeile vorne rechts : Kommentar
%
\newenvironmentx{karte}[3][1=\card@fach,3=\card@kommentar]
{% Vor der Umgebung: Vorderseite bauen
 %
	\def\cardtitleheader{\dasfach{#1}\hfill\theCardID\hfill\derkommentar{#3}}%
	\def\cardbackheader{\theCardID\hfill\dieantwort\hfill}%
	\thispagestyle{cardpagestyle}
 %
~\vfill{~\hfill \parbox[t]{.9\textwidth}{\centering \Large #2}\hfill~}\vfill~
\refstepcounter{CardID}
\newpage%
}% Ende Vor der Umgebung
{% Nach Umgebung: Warnung im Kaop (bis TODO gelöst) 
 % und neue Karteikarte auf ungerader Seite beginnen lassen
 %
%	\def\cardbackheader{\emph{Achtung:} Rückseite ist zu voll!}%
	\newpage
}
\makeatother

\AtBeginDocument{%
\defpagestyle{cardpagestyle}%
	{(0pt, 0pt)%
		{\cardbackheader}{\cardtitleheader}{\cardtitleheader}}%
	{(0pt, 0pt)%
		{\cardbackfooter}{\cardtitlefooter}{\cardtitlefooter}}%
\pagestyle{cardpagestyle}
}
%
% finally set the layout, if print was given this sets to the just defined 8on2
%
\antwort{Antwort}
% using pagestyle
\setcardpagelayout