%
%		* ----------------------------------------------------------------------------
%		* "THE BEER-WARE LICENSE" (Revision 42/023):
%		* Ronny Bergmann <mail@rbergmann.info> wrote this file. As long as you retain
%		* this notice you can do whatever you want with this stuff. If we meet some day,
%		* and you think  this stuff is worth it, you can buy me a beer or a coffee in return. 
%		* ----------------------------------------------------------------------------
%
%
% Dokumentklasse für Karteikarten im Format DinA5 bis DinA9
% -- Version 1.8b --
%
% Der Code sollte umfassend kommentiert sein, zur Verwendung, Eläuterung der einzelnen
% Klassenoptionen, siehe manual.pdf
%
% Working on an english manual, should be available soon.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kartei}[2011/12/31 Karteikarten in LaTeX, Version 1.8b2]
\newcommand{\setcardpagelayout}{}

\makeatletter
%
\maxdeadcycles=1000
%
% lokale Variablen und Optionsträger 
%
%Print Version oder nicht ?
\newif\ifcard@useprint%
%Standard: Kein Print
\card@useprintfalse%

% Card Sizes
% 0 = DIN A5
% 1 = DIN A6
% 2 = DIN A7
% 3 = DIN A8
% 4 = DIN A9
\newcount\card@papersize
%Standard: A6 
\card@papersize=1%

% Rotation der Rückseite
% 0 = nicht gedreht
% 1 = 180° gedreht (überkopf)
\newcount\card@Rearsiderotation
%Standard: 0 Degree, nicht überkopf 
\card@Rearsiderotation=0%

%
% Gittermaße
%
% Eigenschaften: Gitter vorne / hinten
\newif\ifcard@useFrontgrid
%Standard -> vorne kein Gitter
\card@useFrontgridfalse%
% Eigenschaften: Gitter vorne / hinten
\newif\ifcard@useReargrid
%Standard -> vorne kein Gitter
\card@useReargridtrue%

%
%-----------------
%
%
% Declare options
%

%Flip Rearsides
\DeclareOption{flip}{%
	\card@Rearsiderotation=1%
}
%Print output
\DeclareOption{print}{%
	\card@useprinttrue
}%
%A6 Cards
\DeclareOption{a5paper}{%
	\card@papersize=0%
	\PassOptionsToPackage{paper=a5,pagesize}{typearea}% 
}
%A6 Cards
\DeclareOption{a6paper}{%
	\card@papersize=1%
	\PassOptionsToPackage{paper=a6,pagesize}{typearea}% 
}
%A7 Cards
\DeclareOption{a7paper}{%
	\card@papersize=2%
	\PassOptionsToPackage{paper=a7,pagesize}{typearea}% 
}%
%A8 Cards
\DeclareOption{a8paper}{
	\card@papersize=3%
	\PassOptionsToPackage{paper=a8,pagesize}{typearea}% 
}%	
%A9 Cards
\DeclareOption{a9paper}{
	\card@papersize=4%
	\PassOptionsToPackage{paper=a9,pagesize}{typearea}% 
}
% Activate both grids
\DeclareOption{grid=both}{%
	\card@useFrontgridtrue%
	\card@useReargridtrue%
}
% Activate front grid only
\DeclareOption{grid=front}{%
	\card@useFrontgridtrue%
	\card@useReargridfalse%
}
% Activate Rearsidegrid only (Standard)
\DeclareOption{grid=rear}{%
	\card@useFrontgridfalse%
	\card@useReargridtrue%
}
% Activate no grid
\DeclareOption{grid=none}{%
	\card@useFrontgridfalse%
	\card@useReargridfalse%
}
%All unknown Options to article
\DeclareOption*{%
\PassOptionsToClass{\CurrentOption}{scrartcl}% 
}
\ProcessOptions\relax
%
% Pakete laden
%
\PassOptionsToClass{twoside}{scrartcl}% 
\PassOptionsToClass{cleardoublepage=plain,DIV=calc}{scrartcl}% 
\LoadClass{scrartcl}
\RequirePackage[headsepline]{scrpage2}
\RequirePackage{xargs}
\RequirePackage[landscape]{geometry}
\RequirePackage{pgfpages,tikz}
\RequirePackage{ifthen}
\RequirePackage{atbegshi}
%
% Defining page style and margins
%
\ifcase \card@papersize% Din A5
		\geometry{left=2em,top=3em,right=2em,bottom=1em,head=1.3\baselineskip, headsep=.7\baselineskip,footskip=1em}%
	\or% DIN A6 because after or we are at 1
		\geometry{left=2em,top=3em,right=2em,bottom=1em,head=1.3\baselineskip, headsep=.7\baselineskip,footskip=1em}%
	\or% DIN A7 because 2
		\geometry{left=1em,top=2.5em,right=1em,bottom=1em,head=1.3\baselineskip, headsep=.7\baselineskip,footskip=1em}%
	\or% %DIN A8 because 3
		\geometry{left=1em,top=2em,right=1em,bottom=1em,head=1.3\baselineskip, headsep=.7\baselineskip,footskip=1em}%
	\or% DIN A9 because 4
		\geometry{left=.5em,top=2em,right=.5em,bottom=1em,head=1.3\baselineskip, headsep=.7\baselineskip,footskip=1em}%
	\fi%
%
%
% grids
%
%
\AtBeginShipout{%
\setbox\AtBeginShipoutBox\hbox{
	\ifthenelse{\isodd{\thepage}}%
	{%
		\begin{tikzpicture}[remember picture,yshift=-3in]%
			\path [use as bounding box] node [inner sep=0pt,outer sep=0pt] (A) {\box\AtBeginShipoutBox};
			\ifcard@useFrontgrid%
				%vertical lines
				\draw[front grid] (-.5in-.5\paperwidth,-.5\paperheight+.5225in) -- (-.5in-.5\paperwidth,.5\paperheight+.5225in);%
				% horizontal lines
				\draw[front grid] (-.5\paperwidth-.5in,-.5\paperheight+.515in) -- (.5\paperwidth-.5in,-.5\paperheight+.515in);%
			\fi%
		\end{tikzpicture}%
	}%
	{%
		\begin{tikzpicture}[remember picture]%
			\path [use as bounding box] node [inner sep=0pt,outer sep=0pt] (A) {\box\AtBeginShipoutBox};
			\ifcard@useReargrid%
				% vertical lines
				\draw[rear grid] (-.5in-.5\paperwidth,-.5\paperheight+.5225in) -- (-.5in-.5\paperwidth,.5\paperheight+.5225in);%
				% horizontal lines
				\draw[rear grid] (-.5\paperwidth-.5in,-.5\paperheight+.5225in) -- (.5\paperwidth-.5in,-.5\paperheight+.5225in);%
			\fi%
		\end{tikzpicture}%
	}%
}}
%
\ifcard@useprint%
	\ifcase \card@papersize%
	%0 is A5
			\ifcase \card@Rearsiderotation% no rotation =0
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA5}[a4paper, border shrink=0mm]}%
			\or %rotate=1
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA5rotation}[a4paper, border shrink=0mm]}%
			\fi
		\or
	%1 is A6
			\ifcase \card@Rearsiderotation% no rotation =0
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA6}[a4paper, landscape, border shrink=0mm]}%
			\or %rotate=1
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA6rotation}[a4paper, landscape, border shrink=0mm]}%
			\fi
		\or
	%DIN A7 because 2
			\ifcase \card@Rearsiderotation% no rotation =0
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA7}[a4paper, border shrink=0mm]}%
			\or %rotate=1
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA7rotation}[a4paper, border shrink=0mm]}%
			\fi
		\or
		%DIN A8 because 3
			\ifcase \card@Rearsiderotation% no rotation =0
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA8}[a4paper, landscape, border shrink=0mm]}%
			\or %rotate=1
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA8rotation}[a4paper, landscape, border shrink=0mm]}%
			\fi
		\or
		%DIN A9 because 4
			\ifcase \card@Rearsiderotation% no rotation =0
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA9}[a4paper, border shrink=0mm]}%
			\or %rotate=1
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA9rotation}[a4paper, border shrink=0mm]}%
			\fi
	\fi
\else%
	\renewcommand{\setcardpagelayout}{} % no print
\fi%
\input{kartei.pageshipout}

\input{kartei.a5printstyle}
\input{kartei.a5printstylerotation}
\input{kartei.a6printstyle}
\input{kartei.a6printstylerotation}
\input{kartei.a7printstyle}
\input{kartei.a7printstylerotation}
\input{kartei.a8printstyle}
\input{kartei.a8printstylerotation}
\input{kartei.a9printstyle}
\input{kartei.a9printstylerotation}

%
% -----------------
% Eigene Felder und Befehler
% -----------------
%

%
% Antwort (Standard Rückseite Mitte
% Answer
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
% CardSubject
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
% Kommentar (Standard vorne rechts)
% Comment
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

%english names
\newcommand{\comment}{}
\let\comment=\kommentar
\newcommand{\thecomment}{}
\let\thecomment=\derkommentar
\newcommand{\commentstyle}{}
\let\commentstyle=\kommentarstil


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
\def\numberedsection#1{%
	\refstepcounter{section}%
	\fach{\thesection.\ #1}%
%	\addcontentsline{toc}{section}{\protect\numberline{\thesubsection}{#1}}}
}%
\def\unnumberedsection#1{%
	\fach{#1}%
%	\addcontentsline{toc}{section}{#1}}%
}%

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
	\renewcommand{\thesubsection}{\arabic{subsection}}%
	\kommentar{#1}%
}%
%
% Pagestyle commands
%
\def\cardtitleheader{}%
\def\cardRearheader{\theCardID\hfill\dieantwort\hfill}%
\def\cardtitlefooter{}%
\def\cardRearfooter{}%

%
%	Karteikartenumgebung:
%	#1 (optional) Kopfzeile vorne Links : Fach
% 	#2 Titel der Vorderseite  	
% 	#3 (optional) Kopfzeile vorne rechts : Kommentar
%
\newenvironmentx{karte}[3][1=\card@fach,3=\card@kommentar]
{% Vor der Umgebung: Vorderseite bauen
 %
\cohead{\theCardID}
\lohead{\dasfach{#1}}
\rohead{\derkommentar{#3}}
\thispagestyle{scrheadings}
~\vfill{~\hfill \parbox[t]{.9\textwidth}{\centering \Large #2}\hfill~}\vfill~
\refstepcounter{CardID}
\newpage%
}% Ende Vor der Umgebung
{% Nach Umgebung: Warnung im Kaop (bis TODO gelöst) 
 % und neue Karteikarte auf ungerader Seite beginnen lassen
 %
\cohead{{\bfseries Achtung:} R\"uckseite von \theCardID\ ist zu voll.}%
\rohead{}%
\lohead{}%
	~\cleardoublepage
}
%
% Init and Endstuff...
%
\AtBeginDocument{
}
\makeatother
%
% finally set the layout, if print was given this sets to the just defined 8on2
%
\antwort{Antwort}
% using pagestyle
\setcardpagelayout
\AtEndDocument{%
%
% TODO Tabelle aller Karten?
%
}
\pagestyle{scrheadings}
\clearscrheadings
\lohead{Kartentitel}
\cohead{\theCardID}
\lehead{\theCardID}
\cehead{\dieantwort}%
\setheadsepline{.4pt}[\color{black}] 

%
% Border Definitions
%
\tikzset{front grid/.style={very thin, gray}}
\tikzset{rear grid/.style={thin, black, loosely dashed}}