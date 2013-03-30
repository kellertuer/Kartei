%
%    * ----------------------------------------------------------------
%    * "THE BEER-WARE LICENSE" (Revision 42/023):
%    * Ronny Bergmann <mail@rbergmann.info> wrote this file. As long as
%    * you retain this notice you can do whatever you want with this
%    * stuff. If we meet some day and you think this stuff is worth it,
%    * you can buy me a beer or a coffee in return.
%    * ----------------------------------------------------------------
%
%
% Kartei Source Code of A5 page style definition without rotation
%
%   -- Version 1.9 --
%
% Last Change: Kartei 1.9, 2012/01/04
%
% An english manual will be available soon, up to that, at least all
% comments are in english
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kartei}[2012/01/04 Karteikarten in LaTeX, Version 1.9]
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

%TOC Version oder nicht ?
\newif\ifcard@useTOC%
%Standard: Kein Print
\card@useTOCfalse%

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
% Offsets
\newlength{\card@hoffset}
\newlength{\card@voffset}
\setlength{\card@hoffset}{0pt}
\setlength{\card@voffset}{0pt}
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
%TOC output
\DeclareOption{toc}{%
	\card@useTOCtrue
}%
%A6 Cards
\DeclareOption{a5paper}{%
	\card@papersize=0%
	\PassOptionsToPackage{paper=a5,pagesize}{typearea}%
	\setlength{\card@hoffset}{-28pt}\setlength{\card@voffset}{55pt}%
}
%A6 Cards
\DeclareOption{a6paper}{%
	\card@papersize=1%
	\PassOptionsToPackage{paper=a6,pagesize}{typearea}%
	\setlength{\card@hoffset}{-28pt}\setlength{\card@voffset}{37.5pt}%
}
%A7 Cards
\DeclareOption{a7paper}{%
	\card@papersize=2%
	\PassOptionsToPackage{paper=a7,pagesize}{typearea}%
	\setlength{\card@hoffset}{-33.75pt}\setlength{\card@voffset}{37pt}%
}%
%A8 Cards
\DeclareOption{a8paper}{
	\card@papersize=3%
	\PassOptionsToPackage{paper=a8,pagesize}{typearea}%
	\setlength{\card@hoffset}{-33.75pt}\setlength{\card@voffset}{37pt}%
}%	
%A9 Cards
\DeclareOption{a9paper}{
	\card@papersize=4%
	\PassOptionsToPackage{paper=a9,pagesize}{typearea}%
	\setlength{\card@hoffset}{-36pt}\setlength{\card@voffset}{36.5pt}%
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
%
% Packages rewquired for the print option
%
\RequirePackage{pgfpages,tikz}
\RequirePackage{ifthen}
\RequirePackage{atbegshi}
%
% Packages required for the TOC option
%
\RequirePackage{longtable}
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{calc}
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
% Load toc Commands
%
\ifcard@useTOC
  \input{kartei.tableofcontents}
\fi
%
% Load print Commands
\ifcard@useprint%
  \input{kartei.print}
\fi%
%
% -----------------
% Main Commands 
% -----------------
%
\makeatletter
%
% Antwort
% Answer
\newcommand{\dieantwort}{%
\antwortstil{\card@antwort}\relax%
}
\newcommand{\antwort}[1]{\def\card@antwort{#1}}%
\newcommand{\antwortstil}{}
\global\let\card@antwort\@empty

%english names
\newcommand{\answer}{}
\let\answer=\antwort
\newcommand{\theanswer}{}
\let\theanswer=\dieantwort
\newcommand{\answerstyle}{}
\let\answerstyle=\antwortstil

%
% Fach
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
\global\let\card@fach\@empty

%english names
\newcommand{\cardsubject}{}
\let\cardsubject=\fach
\newcommand{\thesubject}{}
\let\thesubject=\dasfach
\newcommand{\subjectstyle}{}
\let\subjectstyle=\fachstil

%
% Kommentar
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
\global\let\card@kommentar\@empty

%english names
\newcommand{\comment}{}
\let\comment=\kommentar
\newcommand{\thecomment}{}
\let\thecomment=\derkommentar
\newcommand{\commentstyle}{}
\let\commentstyle=\kommentarstil

% Card Counter
\newcounter{CardID}
\renewcommand{\theCardID}{\emph{\# \arabic{CardID}}}

\makeatletter
% redefine section
\newcommand{\origsection}{}
\let\origsection=\section
\def\section{\@ifstar\card@unnumberedsection\card@numberedsection}
\def\card@unnumberedsection#1{%
	\fach{#1}%
  \ifcard@useTOC% only include these if toc is active
	\card@addsec{}{#1}
  \fi%
}%
\def\card@numberedsection#1{%
	\refstepcounter{section}%
	\fach{\thesection.\ #1}%
  \ifcard@useTOC% only include these if toc is active
	\card@addsec{\thesection.}{#1}
  \fi%
}%
\def\unnumberedsection#1{%
	\fach{#1}%
	\card@addsec{}{#1}
}%

% redefine subsectiom
\newcommand{\origsubsection}{}
\let\origsubsection=\subsection
%
\def\subsection{\@ifstar\card@unnumberedsubsection\card@numberedsubsection}
\def\card@numberedsubsection#1{%
  \renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
  \refstepcounter{subsection}%
  \kommentar{\thesubsection. #1}
  \ifcard@useTOC% only include these if toc is active
    \card@addsubsec{\thesubsection.}{#1}
  \fi%
}%
\def\card@unnumberedsubsection#1{%
  \renewcommand{\thesubsection}{\arabic{subsection}}%
  \kommentar{#1}%
  \ifcard@useTOC% only include these if toc is active
    \card@addsubsec{#1}
  \fi%
}
%    Karteikartenumgebung:
%  #1 (optional) Kopfzeile vorne Links : Fach
%  #2 Titel der Vorderseite
%  #3 (optional) Kopfzeile vorne rechts : Kommentar
%
\newenvironmentx{karte}[3][1=\card@fach,3=\card@kommentar]
{%
\refstepcounter{CardID}
  % Add a TOC-line if active
  \ifcard@useTOC% only include these if toc is active
    \card@add{\arabic{CardID}}{#2}%
  \fi%
  % Build Cover page before starting environment
  %
\cohead{\theCardID}
\lohead{\dasfach{#1}}
\rohead{\derkommentar{#3}}
\thispagestyle{scrheadings}
~\vfill{~\hfill \parbox[t]{.9\textwidth}{\centering \Large #2}\hfill~}\vfill~
\newpage%
}% Start os usual content block
{% Build a warning if the page is too full (forcing a pagebreak)
 % assure the next card starts on an odd page by doublepagebreak
\cohead{{\bfseries Achtung:} R\"uckseite von \theCardID\ ist zu voll.}%
\rohead{}%
\lohead{}%
	~\cleardoublepage
}
\newcommand{\card@printTOC}{
\ifcard@useTOC % only include these if toc is active
  \ifcard@useprint
%    \pgfshipoutphysicalpage
    \pgfpagesuselayout{resize to}[a4paper]
	\newpage
    \KOMAoptions{paper=a4,DIV=13}
	\setlength{\pdfpagewidth}{21cm}
	\setlength{\textwidth}{17.5cm}
	\setlength{\pdfpageheight}{29.7cm}
  \else
    \KOMAoptions{paper=a4,DIV=13}
  \fi
  \thispagestyle{empty}
  \card@makeTOC
\fi
}

%
% Init and Endstuff...
%
\AtBeginDocument{\setcardpagelayout}
%
% finally set the layout, if print was given this sets to the just defined 8on2
%
\AtEndDocument{\card@printTOC}
\makeatother
%
%
% Init
\antwort{Antwort}
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
%
\setcardpagelayout