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
% lokale Variablen und Optionsträger 
%
%Print Version oder nicht ?
\newif\ifcard@useprint%
%Standard: Kein Print
\card@useprintfalse%

% Card Sizes
% 0 = DIN A6
% 1 = DIN A7
% 2 = DIN A8
% 3 = DIN A9
\newcount\card@papersize
%Standard: A6 
\card@papersize=0%

% Rotation der Rückseite
% 0 = nicht gedreht
% 1 = 180° gedreht (überkopf)
\newcount\card@Rearsiderotation
%Standard: 0 Degree, nicht überkopf 
\card@Rearsiderotation=0%

%
% Gittermaße
%
\newlength\card@gridx
\newlength\card@gridy
% Eigenschaften: Gitter vorne / hinten
\newif\ifcard@usefrontgrid
%Standard -> vorne kein Gitter
\card@usefrontgridfalse%
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
\DeclareOption{a6paper}{%
	\card@papersize=0%
}
%A7 Cards
\DeclareOption{a7paper}{%
	\card@papersize=1%
}%
%A8 Cards
\DeclareOption{a8paper}{
	\card@papersize=2%
}%	
%A9 Cards
\DeclareOption{a9paper}{
\card@papersize=3%
}
% Activate both grids
\DeclareOption{grid=both}{%
	\card@usefrontgridtrue%
	\card@useReargridtrue%
}
% Activate front grid only
\DeclareOption{grid=front}{%
	\card@usefrontgridtrue%
	\card@useReargridfalse%
}
% Activate Rearsidegrid only (Standard)
\DeclareOption{grid=rear}{%
	\card@usefrontgridfalse%
	\card@useReargridtrue%
}
% Activate both grids
\DeclareOption{grid=none}{%
	\card@usefrontgridfalse%
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
\LoadClass[twoside]{scrartcl}
\RequirePackage[headsepline,footsepline]{scrpage2}
\RequirePackage{xargs}
\RequirePackage{vmargin}
\RequirePackage{pgfpages,tikz}
\RequirePackage{eso-pic}

%
% Seitenformate durchdefinieren
%
\ifcase \card@papersize%
			\setpapersize[landscape]{A6}% 
			\setmarginsrb{7mm}{2mm}{7mm}{4mm}{1.3em}{1em}{0mm}{1em}%
			\setlength{\card@gridx}{\paperwidth}%
			\setlength{\card@gridy}{\paperheight}%			
		\or%
		%DIN A7 because 1
			\setpapersize[landscape]{A7}% 
			\setmarginsrb{5mm}{2mm}{5mm}{3mm}{1.3em}{.7em}{0mm}{1em}%
			\setlength{\card@gridx}{\paperwidth}% 
			\setlength{\card@gridy}{\paperheight}%
		\or%
		%DIN A8 because 2
			\setpapersize[landscape]{A8}% 
			\setmarginsrb{3mm}{2mm}{3mm}{2mm}{1.3em}{.3em}{0mm}{1em}%
			\setlength{\card@gridx}{\paperwidth}%
			\setlength{\card@gridy}{\paperheight}%
		\or%
		%DIN A9 because 3
			\setpapersize[landscape]{A9}% 
			\setmarginsrb{1mm}{2mm}{1mm}{1mm}{1.3em}{.3em}{0mm}{1em}%
			\setlength{\card@gridx}{\paperwidth}
			\setlength{\card@gridy}{\paperheight}%
	\fi%
%
\ifcard@useprint%
	\ifcase \card@papersize%
	%0 is A6
			\setpapersize[landscape]{A4}%
			\ifcase \card@Rearsiderotation% no rotation =0
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA6}[a4paper, landscape, border shrink=0mm]}%
			\or %rotate=1
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA6rotation}[a4paper, landscape, border shrink=0mm]}%
			\fi
		\or
		%DIN A7 because 1
			\setpapersize[portrait]{A4}%
			\ifcase \card@Rearsiderotation% no rotation =0
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA7}[a4paper, border shrink=0mm]}%
			\or %rotate=1
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA7rotation}[a4paper, border shrink=0mm]}%
			\fi
		\or
		%DIN A8 because 2
			\setpapersize[landscape]{A4}%
			\ifcase \card@Rearsiderotation% no rotation =0
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA8}[a4paper, landscape, border shrink=0mm]}%
			\or %rotate=1
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA8rotation}[a4paper, landscape, border shrink=0mm]}%
			\fi
		\or
		%DIN A9 because 3
			\setpapersize[portrait]{A4}%
			\ifcase \card@Rearsiderotation% no rotation =0
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA9}[a4paper, border shrink=0mm]}%
			\or %rotate=1
				\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA9rotation}[a4paper, border shrink=0mm]}%
			\fi
	\fi
	% Border Styles
	\newcommand\card@RearGridPic{%
		\put(72.364672364672365,-72.364672364672365){%
			\parbox[b][\paperheight]{\paperwidth}{%
				\begin{tikzpicture}
					\draw[rear grid] (1pt,1pt) grid [xstep=\the\card@gridx,ystep=\the\card@gridy] (\paperwidth-1pt,\paperheight-1pt);%
				\end{tikzpicture}
			}%
		}%
	}%
	\newcommand\card@FrontGridPic{%
		\put(72.364672364672365,-72.364672364672365){%
			\parbox[b][\paperheight]{\paperwidth}{%
				\begin{tikzpicture}
				\draw[front grid] (1pt,1pt) grid [xstep=\the\card@gridx,ystep=\the\card@gridy] (\paperwidth-1pt,\paperheight-1pt);%
				\end{tikzpicture}
			}%
		}%
	}%
\else
	\renewcommand{\setcardpagelayout}{} % no print
\fi
\input{kartei.pageshipout.tex}

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
%	\addcontentsline{toc}{subsection}{\protect\numberline{\thesubsection}{#1}}}
\def\unnumberedsubsection#1{%
	\renewcommand{\thesubsection}{\arabic{subsection}}%
%	\addcontentsline{toc}{subsection}{#1}}%
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
	\def\cardtitleheader{\dasfach{#1}\hfill\theCardID\hfill\derkommentar{#3}}%
	\def\cardRearheader{\theCardID\hfill\dieantwort\hfill}%
	\thispagestyle{cardpagestyle}
 %
~\vfill{~\hfill \parbox[t]{.9\textwidth}{\centering \Large #2}\hfill~}\vfill~
\refstepcounter{CardID}
\newpage%
}% Ende Vor der Umgebung
{% Nach Umgebung: Warnung im Kaop (bis TODO gelöst) 
 % und neue Karteikarte auf ungerader Seite beginnen lassen
 %
%	\def\cardRearheader{\emph{Achtung:} Rückseite ist zu voll!}%
	\newpage
}
\makeatother
%
% Init and Endstuff...
%
\AtBeginDocument{%
\defpagestyle{cardpagestyle}%
	{(0pt, 0pt)%
		{\cardRearheader}{\cardtitleheader}{\cardtitleheader}}%
	{(0pt, 0pt)%
		{\cardRearfooter}{\cardtitlefooter}{\cardtitlefooter}}%
\pagestyle{cardpagestyle}
}
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
%
% Border Definitions
%
\tikzset{front grid/.style={very thin, gray, loosely dashed}}
\tikzset{rear grid/.style={thin, black, loosely dashed}}
