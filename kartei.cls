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
% -- Version 1.5 --
%
% == Dokumentoptionen ==
% 
%  ohne OPtionen werden Din A6 Karteikarten generiert
% 	mögliche Optionen sind
%  	- print: Erzeugt Duplex-Druck geeignetes Format 4on1, also zunächst 4 Vorder- dann 4 Rückseiten
% 
% 
% == Kartenumgebung ==
% 
% - Karteikartenumgebung mit automatischer Durchnummerierung (Referenzen verweisen auf die Karteikarten # Nummer)
% - Für eine Karte kann
% 	* Kopf oben rechts und rechts (wird jeweils kursiv gesetzt)
% 	* Ein Titel für die Vorderseite angegeben werden
% 
% - Karteikartenumgebung karte die wie folgt verwendet wird
% 
%	\begin{karte}{KopfRechts}{KopfLinks}{Karteikartentitel}
%		Rückseite
%	\end{karte}
%
%
%
\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{kartei}[2008/08/30 ver 1.2]

\newcommand{\setcardpagelayout}{}

\DeclareOption{print}{%
\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprint}[a4paper, landscape, border shrink=0mm]}}%

\DeclareOption{border}{}

\ProcessOptions
\LoadClass[a4paper, twoside, 10pt, landscape]{article}
\RequirePackage{fancyhdr}
\RequirePackage{geometry}
%
% Definieren des A6-Blattes mit entsprechenden Schriftgrößen
%
\geometry{	a6paper, landscape,%
			tmargin=1cm, bmargin=.5cm,% 
			lmargin=.5cm, rmargin=.5cm,% 
			headheight=1.3em, headsep=1em,% 
			footskip=.25cm} 

%
% Standard-Layout: 	Kopf:  Kartennummer vorne mittig, hinten links (also bei y0), hinten mitte „Antwort“
% 					Fußzeile: leer
%
\renewcommand{\headrulewidth}{0.2pt}
\renewcommand{\footrulewidth}{0.0pt} 
\pagestyle{fancy}{% 
	\fancyhf{}%
	\fancyhead[CO,LE]{\emph{\theCardID}}%	
	\fancyhead[RE]{}%
	\fancyhead[CE]{\emph{Antwort}}%
}

%
% Karteikartenzähler & Ausgabe des Counters in Form „# Nummer“ bei Referenzen und in der Kopfzeile
%
\newcounter{CardID}
\renewcommand{\theCardID}{\# \arabic{CardID}}

%
%	Karteikartenumgebung:
%	#1 Kopfzeile vorne Links
% 	#2 Kopfzeile vorne rechts
% 	#3 Titel der Vorderseite  	
%
\newenvironment{karte}[3]
{% Vor der Umgebung: Vorderseite bauen
 %
	\pagestyle{fancy}{% 
		\fancyhead[LO]{\emph{#1}} %Fach
		\fancyhead[RO]{\emph{#2}} %Kommentar
	}%
~\vfill{~\hfill \parbox[t]{.9\textwidth}{\centering \Large #3}\hfill~}\vfill~
\refstepcounter{CardID}
\newpage%
}%
{% Nach Umgebung: Warnung im Kaop (bis TODO gelöst) 
 % und neue Karteikarte auf ungerader Seite beginnen lassen
 %
	\fancyhead[LO]{\emph{TODO - ab und an Karteikarte zuviel generiert,}}
	\fancyhead[RO]{\emph{wenn Rückseite recht voll}}
	\cleardoublepage
}
\RequirePackage{pgfpages,tikz}
\makeatletter
%
% redefine page output, so that 4 odd are on first, 4 even on second, adapted from pgfpages
%
\renewcommand\pgfshipoutphysicalpage{%
  \ifnum\pgf@logicalpages>0\relax%
    \pgfpages@buildshipoutoddbox%
    \pgfpages@shipoutshipoutbox%
    \pgfpages@performoddcopying%
  \fi%
  \ifnum\pgf@logicalpages>0\relax% 
    \pgfpages@buildshipoutevenbox%
    \pgfpages@shipoutshipoutbox%
    \pgfpages@performevencopying%
    \global\pgfphysicalpageemptytrue%
    \global\pgf@holdingphysicalpagefalse%  
  \fi%
}

\newbox\pgfpages@shipoutbox

\def\pgfpages@buildshipoutoddbox{%
  \setbox\pgfpages@shipoutbox=\vbox{{%
    \set@typeset@protect%
    \offinterlineskip%
    \pgfsys@beginpicture%
    \pgf@cpn=1\relax%
	\advance \pgf@logicalpages by -1\relax%
    \loop%
      \setbox0=\hbox to \csname pgfpages@p@\the\pgf@cpn @width\endcsname{%
        \hskip1in%
        \vbox to \csname pgfpages@p@\the\pgf@cpn @height\endcsname%
          {\vskip1in\offinterlineskip\expandafter\copy\csname
            pgfpages@box@\the\pgf@cpn\endcsname\vss}\hss}%
      \pgfsys@beginscope%
        % Translate lower left corner
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @center\endcsname\relax%
        \else%
          \pgflowlevel{\pgftransformshift{\csname pgfpages@p@\the\pgf@cpn @center\endcsname}}%
        \fi%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @scale\endcsname\relax%
        \else%
          \pgflowlevel{\pgftransformscale{\csname pgfpages@p@\the\pgf@cpn @scale\endcsname}}%
        \fi%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @xscale\endcsname\relax%
        \else%
          \pgflowlevel{\pgftransformxscale{\csname pgfpages@p@\the\pgf@cpn @xscale\endcsname}{1}}%
        \fi%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @yscale\endcsname\relax%
        \else%
          \pgflowlevel{\pgftransformyscale{\csname pgfpages@p@\the\pgf@cpn @yscale\endcsname}}%
        \fi%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @rotation\endcsname\relax%
          \pgfscope%
        \else%
          \pgflowlevel{\pgftransformrotate{\csname pgfpages@p@\the\pgf@cpn @rotation\endcsname}}%
        \fi%
        \@tempdima=\csname pgfpages@p@\the\pgf@cpn @width\endcsname\relax%
        \@tempdimb=\csname pgfpages@p@\the\pgf@cpn @height\endcsname\relax%
        \pgflowlevel{\pgftransformshift{\pgfpoint{-.5\@tempdima}{-.5\@tempdimb}}}%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @bordercode\endcsname\relax%
        \else%
          \pgfpathmoveto{\pgfpointorigin}%
          \pgfpathlineto{\pgfpoint{\wd0}{0pt}}%
          \pgfpathlineto{\pgfpoint{\wd0}{\ht0}}%
          \pgfpathlineto{\pgfpoint{0pt}{\ht0}}%
          \pgfpathclose%
          {\csname pgfpages@p@\the\pgf@cpn @bordercode\endcsname}%
        \fi%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @cornerwidth\endcsname\relax%
        \else%
          {
            \expandafter\@tempdima\csname pgfpages@p@\the\pgf@cpn @cornerwidth\endcsname\relax%
            \color{black}
            \pgfpathrectangle{\pgfpointorigin}{\pgfpoint{\@tempdima}{\@tempdima}}%
            \pgfpathrectangle{\pgfpoint{0pt}{\ht0-\@tempdima}}{\pgfpoint{\@tempdima}{\@tempdima}}%
            \pgfpathrectangle{\pgfpoint{\wd0-\@tempdima}{0pt}}{\pgfpoint{\@tempdima}{\@tempdima}}%
            \pgfpathrectangle{\pgfpoint{\wd0-\@tempdima}{\ht0-\@tempdima}}{\pgfpoint{\@tempdima}{\@tempdima}}%
            \pgfusepath{fill}%
            \pgfpathmoveto{\pgfpoint{0pt}{\@tempdima}}
            \pgfpathcurveto{\pgfpoint{0pt}{0.555\@tempdima}}{\pgfpoint{.555\@tempdima}{0pt}}{\pgfpoint{\@tempdima}{0pt}}
            \pgfpathlineto{\pgfpoint{\wd0-\@tempdima}{0pt}}
            \pgfpathcurveto{\pgfpoint{\wd0-.555\@tempdima}{0pt}}{\pgfpoint{\wd0}{.555\@tempdima}}{\pgfpoint{\wd0}{\@tempdima}}
            \pgfpathlineto{\pgfpoint{\wd0}{\ht0-\@tempdima}}
            \pgfpathcurveto{\pgfpoint{\wd0}{\ht0-.555\@tempdima}}{\pgfpoint{\wd0-.555\@tempdima}{\ht0}}{\pgfpoint{\wd0-\@tempdima}{\ht0}}
            \pgfpathlineto{\pgfpoint{\@tempdima}{\ht0}}
            \pgfpathcurveto{\pgfpoint{.555\@tempdima}{\ht0}}{\pgfpoint{0pt}{\ht0-.555\@tempdima}}{\pgfpoint{0pt}{\ht0-\@tempdima}}
            \pgfpathclose
            \pgfusepath{clip}
            \color{white}
            \pgfpathrectangle{\pgfpointorigin}{\pgfpoint{\wd0}{\ht0}}
            \pgfusepath{fill}
          }
        \fi%
        \ht0=0pt%
        \wd0=0pt%
        \dp0=0pt%
        \pgfsys@hbox0%
        \endpgfscope%
      \pgfsys@endscope%
    \ifnum\pgf@cpn<\pgf@logicalpages%
      \advance \pgf@cpn by 2\relax%  
    \repeat%
	\advance \pgf@logicalpages by 1\relax%
    \pgfsys@endpicture%
    }}%
}

\newbox\pgfpages@shipoutbox

\def\pgfpages@buildshipoutevenbox{%
  \setbox\pgfpages@shipoutbox=\vbox{{%
    \set@typeset@protect%
    \offinterlineskip%
    \pgfsys@beginpicture%
    \pgf@cpn=2\relax%
    \loop%
      \setbox0=\hbox to \csname pgfpages@p@\the\pgf@cpn @width\endcsname{%
        \hskip1in%
        \vbox to \csname pgfpages@p@\the\pgf@cpn @height\endcsname%
          {\vskip1in\offinterlineskip\expandafter\copy\csname
            pgfpages@box@\the\pgf@cpn\endcsname\vss}\hss}%
      \pgfsys@beginscope%
        % Translate lower left corner
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @center\endcsname\relax%
        \else%
          \pgflowlevel{\pgftransformshift{\csname pgfpages@p@\the\pgf@cpn @center\endcsname}}%
        \fi%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @scale\endcsname\relax%
        \else%
          \pgflowlevel{\pgftransformscale{\csname pgfpages@p@\the\pgf@cpn @scale\endcsname}}%
        \fi%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @xscale\endcsname\relax%
        \else%
          \pgflowlevel{\pgftransformxscale{\csname pgfpages@p@\the\pgf@cpn @xscale\endcsname}{1}}%
        \fi%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @yscale\endcsname\relax%
        \else%
          \pgflowlevel{\pgftransformyscale{\csname pgfpages@p@\the\pgf@cpn @yscale\endcsname}}%
        \fi%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @rotation\endcsname\relax%
          \pgfscope%
        \else%
          \pgflowlevel{\pgftransformrotate{\csname pgfpages@p@\the\pgf@cpn @rotation\endcsname}}%
        \fi%
        \@tempdima=\csname pgfpages@p@\the\pgf@cpn @width\endcsname\relax%
        \@tempdimb=\csname pgfpages@p@\the\pgf@cpn @height\endcsname\relax%
        \pgflowlevel{\pgftransformshift{\pgfpoint{-.5\@tempdima}{-.5\@tempdimb}}}%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @bordercode\endcsname\relax%
        \else%
          \pgfpathmoveto{\pgfpointorigin}%
          \pgfpathlineto{\pgfpoint{\wd0}{0pt}}%
          \pgfpathlineto{\pgfpoint{\wd0}{\ht0}}%
          \pgfpathlineto{\pgfpoint{0pt}{\ht0}}%
          \pgfpathclose%
          {\csname pgfpages@p@\the\pgf@cpn @bordercode\endcsname}%
        \fi%
        \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @cornerwidth\endcsname\relax%
        \else%
          {
            \expandafter\@tempdima\csname pgfpages@p@\the\pgf@cpn @cornerwidth\endcsname\relax%
            \color{black}
            \pgfpathrectangle{\pgfpointorigin}{\pgfpoint{\@tempdima}{\@tempdima}}%
            \pgfpathrectangle{\pgfpoint{0pt}{\ht0-\@tempdima}}{\pgfpoint{\@tempdima}{\@tempdima}}%
            \pgfpathrectangle{\pgfpoint{\wd0-\@tempdima}{0pt}}{\pgfpoint{\@tempdima}{\@tempdima}}%
            \pgfpathrectangle{\pgfpoint{\wd0-\@tempdima}{\ht0-\@tempdima}}{\pgfpoint{\@tempdima}{\@tempdima}}%
            \pgfusepath{fill}%
            \pgfpathmoveto{\pgfpoint{0pt}{\@tempdima}}
            \pgfpathcurveto{\pgfpoint{0pt}{0.555\@tempdima}}{\pgfpoint{.555\@tempdima}{0pt}}{\pgfpoint{\@tempdima}{0pt}}
            \pgfpathlineto{\pgfpoint{\wd0-\@tempdima}{0pt}}
            \pgfpathcurveto{\pgfpoint{\wd0-.555\@tempdima}{0pt}}{\pgfpoint{\wd0}{.555\@tempdima}}{\pgfpoint{\wd0}{\@tempdima}}
            \pgfpathlineto{\pgfpoint{\wd0}{\ht0-\@tempdima}}
            \pgfpathcurveto{\pgfpoint{\wd0}{\ht0-.555\@tempdima}}{\pgfpoint{\wd0-.555\@tempdima}{\ht0}}{\pgfpoint{\wd0-\@tempdima}{\ht0}}
            \pgfpathlineto{\pgfpoint{\@tempdima}{\ht0}}
            \pgfpathcurveto{\pgfpoint{.555\@tempdima}{\ht0}}{\pgfpoint{0pt}{\ht0-.555\@tempdima}}{\pgfpoint{0pt}{\ht0-\@tempdima}}
            \pgfpathclose
            \pgfusepath{clip}
            \color{white}
            \pgfpathrectangle{\pgfpointorigin}{\pgfpoint{\wd0}{\ht0}}
            \pgfusepath{fill}
          }
        \fi%
        \ht0=0pt%
        \wd0=0pt%
        \dp0=0pt%
        \pgfsys@hbox0%
        \endpgfscope%
      \pgfsys@endscope%
    \ifnum\pgf@cpn<\pgf@logicalpages%
      \advance \pgf@cpn by 2\relax%  
    \repeat%
    \pgfsys@endpicture%
    }}%
}
\def\pgfpages@performoddcopying{
  \pgf@cpn=1\relax% copy first
	\advance \pgf@logicalpages by -1\relax%
  \loop%
    \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @copy\endcsname\relax
    \else%
      \edef\pgf@temp{\noexpand\global\noexpand\setbox\csname pgfpages@box@%
        \the\pgf@cpn\endcsname=\noexpand\copy\csname pgfpages@box@\csname
        pgfpages@p@\the\pgf@cpn @copy\endcsname\endcsname}%
      \pgf@temp%
    \fi%
  \ifnum\pgf@cpn<\pgf@logicalpages%
    \advance \pgf@cpn by 2\relax%  
  \repeat%
  \pgf@cpn=1\relax% then void
  \loop%
    \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @copy\endcsname\relax
      \expandafter\global\expandafter\setbox\csname pgfpages@box@\the\pgf@cpn\endcsname=\box\voidb@x%
    \else%
    \fi%
  \ifnum\pgf@cpn<\pgf@logicalpages%
    \advance \pgf@cpn by 2\relax%  
  \repeat%
	\advance \pgf@logicalpages by 1\relax%
}
\def\pgfpages@performevencopying{
  \pgf@cpn=2\relax% copy first
  \loop%
    \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @copy\endcsname\relax
    \else%
      \edef\pgf@temp{\noexpand\global\noexpand\setbox\csname pgfpages@box@%
        \the\pgf@cpn\endcsname=\noexpand\copy\csname pgfpages@box@\csname
        pgfpages@p@\the\pgf@cpn @copy\endcsname\endcsname}%
      \pgf@temp%
    \fi%
  \ifnum\pgf@cpn<\pgf@logicalpages%
    \advance \pgf@cpn by 2\relax%  
  \repeat%
  \pgf@cpn=2\relax% then void
  \loop%
    \expandafter\ifx\csname pgfpages@p@\the\pgf@cpn @copy\endcsname\relax
      \expandafter\global\expandafter\setbox\csname pgfpages@box@\the\pgf@cpn\endcsname=\box\voidb@x%
    \else%
    \fi%
  \ifnum\pgf@cpn<\pgf@logicalpages%
    \advance \pgf@cpn by 2\relax%  
  \repeat%
}

%
% Define a Layout 8on2	
%
\makeatother
\pgfpagesdeclarelayout{cardprint}
{
  \edef\pgfpageoptionheight{\the\paperheight} 
  \edef\pgfpageoptionwidth{\the\paperwidth}
  \edef\pgfpageoptionborder{1pt}
}
{
  \pgfpagesphysicalpageoptions
  {%
    logical pages=8,%
    physical height=\pgfpageoptionheight,%
    physical width=\pgfpageoptionwidth,%
  }
  \pgfpageslogicalpageoptions{1} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.46\pgfphysicalwidth,%
    resized height=.46\pgfphysicalheight,%
    center=\pgfpoint{.27\pgfphysicalwidth}{.73\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{3} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.46\pgfphysicalwidth,%
    resized height=.46\pgfphysicalheight,%
    center=\pgfpoint{.73\pgfphysicalwidth}{.73\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{5} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.46\pgfphysicalwidth,%
    resized height=.46\pgfphysicalheight,%
    center=\pgfpoint{.27\pgfphysicalwidth}{.27\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{7} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.46\pgfphysicalwidth,%
    resized height=.46\pgfphysicalheight,%
    center=\pgfpoint{.73\pgfphysicalwidth}{.27\pgfphysicalheight}%
  }%

  \pgfpageslogicalpageoptions{2} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.46\pgfphysicalwidth,%
    resized height=.46\pgfphysicalheight,%
    center=\pgfpoint{.73\pgfphysicalwidth}{.73\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{4} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.46\pgfphysicalwidth,%
    resized height=.46\pgfphysicalheight,%
    center=\pgfpoint{.27\pgfphysicalwidth}{.73\pgfphysicalheight},%
  	border code=\pgfsetlinewidth{.5pt}\pgfstroke
	}%
  \pgfpageslogicalpageoptions{6} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.46\pgfphysicalwidth,%
    resized height=.46\pgfphysicalheight,%
    center=\pgfpoint{.27\pgfphysicalwidth}{.27\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{8} % 1
  {%
    %border shrink=\pgfpageoptionborder,%
    resized width=.46\pgfphysicalwidth,%
    resized height=.46\pgfphysicalheight,%
    center=\pgfpoint{.73\pgfphysicalwidth}{.27\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
}
\makeatletter
%
% finally set the layout, if print was given this sets to the just defined 8on2
%
\setcardpagelayout