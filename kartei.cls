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
% -- Version 1.7 --
%
% Erklärungen und Ähnliches, siehe manual.pdf

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kartei}[2008/08/30 ver 1.6]
\LoadClass[a4paper,twoside, 10pt, landscape]{article}
\RequirePackage{fancyhdr}
\RequirePackage{vmargin}
\RequirePackage{xargs}
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
\newcount\card@papersize
%Standard: A6 
\card@papersize=0%
\setpapersize[landscape]{A6}% 
\setmarginsrb{7mm}{2mm}{7mm}{4mm}{1.3em}{1em}{0mm}{1em}

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
\newcommand{\subject}{}
\let\subject=\fach
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

%english names
\newcommand{\comment}{}
\let\comment=\kommentar
\newcommand{\thecomment}{}
\let\thecomment=\derkommentar
\newcommand{\commentstyle}{}
\let\commentstyle=\kommentarstil

\DeclareOption{print}{%
\card@useprinttrue
}%

\DeclareOption{a6paper}{
\setpapersize[landscape]{A6}% 
\setmarginsrb{7mm}{2mm}{7mm}{4mm}{1.3em}{1em}{0mm}{1em}
\card@papersize=0%
}

\DeclareOption{a7paper}{
\setpapersize[landscape]{A7}% 
\setmarginsrb{5mm}{2mm}{5mm}{3mm}{1.3em}{.7em}{0mm}{1em}%
\card@papersize=1%
}%

\DeclareOption{a8paper}{
\setpapersize[landscape]{A8}% 
\setmarginsrb{3mm}{2mm}{3mm}{2mm}{1.3em}{.3em}{0mm}{1em}%
\card@papersize=2%
}%	

\ProcessOptions
\ifcard@useprint%
	\ifcase \card@papersize%
			\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA6noborder}[a4paper, landscape, border shrink=0mm]}%
		\or
		%DIN A7 because 1
			\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA7noborder}[a4paper, border shrink=0mm]}%
		\or
		%DIN A8 because 2
			\renewcommand{\setcardpagelayout}{\pgfpagesuselayout{cardprintA8noborder}[a4paper, landscape, border shrink=0mm]}%
	\fi
\else
	\renewcommand{\setcardpagelayout}{} % no print
\fi	

\RequirePackage{pgfpages,tikz}
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
        \pgfpathmoveto{\pgfpoint{1in}{-1in}}%h4ckz0rt for vmargin
        \pgfpathlineto{\pgfpoint{\wd0+1in}{-1in}}% because it uses 1 inch border 
        \pgfpathlineto{\pgfpoint{\wd0+1in}{\ht0-1in}}% and to compensate we have to
        \pgfpathlineto{\pgfpoint{1in}{\ht0-1in}}% hack sis
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

\def\pgfpages@buildshipoutevenbox{% (fold)
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
          \pgfpathmoveto{\pgfpoint{1in}{-1in}}%h4ckz0rt for vmargin
          \pgfpathlineto{\pgfpoint{\wd0+1in}{-1in}}% because it uses 1 inch border 
          \pgfpathlineto{\pgfpoint{\wd0+1in}{\ht0-1in}}% and to compensate we have to
          \pgfpathlineto{\pgfpoint{1in}{\ht0-1in}}% hack sis
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
}% 

\makeatother
\pgfpagesdeclarelayout{cardprintA6noborder}
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
    resized width=.5\pgfphysicalwidth,%
    resized height=.5\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.75\pgfphysicalheight},%
  }%
  \pgfpageslogicalpageoptions{3} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.5\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.75\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{5} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.5\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.25\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{7} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.5\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.25\pgfphysicalheight}%
  }%

  \pgfpageslogicalpageoptions{2} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.5\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.75\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{4} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.5\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.75\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
	}%
  \pgfpageslogicalpageoptions{6} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.5\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.25\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{8} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.5\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.25\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
}%
%
%A7 Stuff
%
\pgfpagesdeclarelayout{cardprintA7noborder}
{
 \edef\pgfpageoptionheight{\the\paperheight} 
  \edef\pgfpageoptionwidth{\the\paperwidth}
  \edef\pgfpageoptionborder{1pt}
}
{
  \pgfpagesphysicalpageoptions
  {%
    logical pages=16,%
    physical height=\pgfpageoptionheight,%
    physical width=\pgfpageoptionwidth,%
  }
  \pgfpageslogicalpageoptions{1} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.875\pgfphysicalheight},%
  }%
  \pgfpageslogicalpageoptions{3} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.875\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{5} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.625\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{7} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.625\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{9} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.375\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{11} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.375\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{13} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.125\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{15} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.125\pgfphysicalheight}%
  }%

  \pgfpageslogicalpageoptions{2} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.875\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{4} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.875\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
	}%
  \pgfpageslogicalpageoptions{6} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.625\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{8} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.625\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{10} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.375\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{12} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.375\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{14} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.75\pgfphysicalwidth}{.125\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{16} % 1
  {%
    resized width=.5\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.25\pgfphysicalwidth}{.125\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
}%
%
%A8 Stuff
%
\pgfpagesdeclarelayout{cardprintA8noborder}
{
 \edef\pgfpageoptionheight{\the\paperheight} 
  \edef\pgfpageoptionwidth{\the\paperwidth}
  \edef\pgfpageoptionborder{1pt}
}
{
  \pgfpagesphysicalpageoptions
  {%
    logical pages=32,%
    physical height=\pgfpageoptionheight,%
    physical width=\pgfpageoptionwidth,%
  }
  \pgfpageslogicalpageoptions{1} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.125\pgfphysicalwidth}{.875\pgfphysicalheight},%
  }%
  \pgfpageslogicalpageoptions{3} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.375\pgfphysicalwidth}{.875\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{5} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.625\pgfphysicalwidth}{.875\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{7} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.875\pgfphysicalwidth}{.875\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{9} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.125\pgfphysicalwidth}{.375\pgfphysicalheight},%
  }%
  \pgfpageslogicalpageoptions{11} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.375\pgfphysicalwidth}{.375\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{13} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.625\pgfphysicalwidth}{.375\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{15} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.875\pgfphysicalwidth}{.375\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{17} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.125\pgfphysicalwidth}{.625\pgfphysicalheight},%
  }%
  \pgfpageslogicalpageoptions{19} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.375\pgfphysicalwidth}{.625\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{21} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.625\pgfphysicalwidth}{.625\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{23} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.875\pgfphysicalwidth}{.625\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{25} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.125\pgfphysicalwidth}{.125\pgfphysicalheight},%
  }%
  \pgfpageslogicalpageoptions{27} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.375\pgfphysicalwidth}{.125\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{29} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.625\pgfphysicalwidth}{.125\pgfphysicalheight}%
  }%
  \pgfpageslogicalpageoptions{31} % 1
  {%
    border shrink=\pgfpageoptionborder,%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.875\pgfphysicalwidth}{.125\pgfphysicalheight}%
  }%




  \pgfpageslogicalpageoptions{2} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.875\pgfphysicalwidth}{.875\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{4} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.625\pgfphysicalwidth}{.875\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
	}%
  \pgfpageslogicalpageoptions{6} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.375\pgfphysicalwidth}{.875\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{8} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.125\pgfphysicalwidth}{.875\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{10} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.875\pgfphysicalwidth}{.625\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{12} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.625\pgfphysicalwidth}{.625\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
	}%
  \pgfpageslogicalpageoptions{14} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.375\pgfphysicalwidth}{.625\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{16} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.125\pgfphysicalwidth}{.625\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%

  \pgfpageslogicalpageoptions{18} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.875\pgfphysicalwidth}{.375\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{20} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.625\pgfphysicalwidth}{.375\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
	}%
  \pgfpageslogicalpageoptions{22} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.375\pgfphysicalwidth}{.375\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{24} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.125\pgfphysicalwidth}{.375\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%

  \pgfpageslogicalpageoptions{26} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.875\pgfphysicalwidth}{.125\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{28} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.625\pgfphysicalwidth}{.125\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
	}%
  \pgfpageslogicalpageoptions{30} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.375\pgfphysicalwidth}{.125\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%
  \pgfpageslogicalpageoptions{32} % 1
  {%
    resized width=.25\pgfphysicalwidth,%
    resized height=.25\pgfphysicalheight,%
    center=\pgfpoint{.125\pgfphysicalwidth}{.125\pgfphysicalheight},%
	border code=\pgfsetlinewidth{.5pt}\pgfstroke
  }%

}%

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
%	Karteikartenumgebung:
%	#1 (optional) Kopfzeile vorne Links : Fach
% 	#2 Titel der Vorderseite  	
% 	#3 (optional) Kopfzeile vorne rechts : Kommentar
%
\newenvironmentx{karte}[3][1=\card@fach,3=\card@kommentar]
{% Vor der Umgebung: Vorderseite bauen
 %
	\pagestyle{fancy}
	{
		\fancyhead[LO]{\dasfach{#1}} %\emph{#1}} %Fach
		\fancyhead[RO]{\derkommentar{#3}} %Kommentar
	}
	\pagestyle{fancy}{% 
	}%
~\vfill{~\hfill \parbox[t]{.9\textwidth}{\centering \Large #2}\hfill~}\vfill~
\refstepcounter{CardID}
\newpage%
}%
{% Nach Umgebung: Warnung im Kaop (bis TODO gelöst) 
 % und neue Karteikarte auf ungerader Seite beginnen lassen
 %
	\fancyhead[LO]{\emph{\textbf{Achtung:} Rückseite der Karte ist zu voll}}
	\cleardoublepage
}
\makeatother
%
% Standard-Layout: 	Kopf:  Kartennummer vorne mittig & hinten links (also bei y0), hinten mitte „Antwort“
% 					Fußzeile: leer
%
\renewcommand{\headrulewidth}{0.2pt}
\renewcommand{\footrulewidth}{0.0pt} 
\pagestyle{fancy}{% 
	\fancyhf{}%
	\fancyhead[CO,LE]{\theCardID}}%	
	\fancyhead[RE]{}%
	\fancyhead[CE]{\dieantwort}%
}

%
% finally set the layout, if print was given this sets to the just defined 8on2
%
\antwort{Antwort}
\setcardpagelayout
