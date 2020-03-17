%%Copyright: 2018, 2019 Aubrey Jaffer
%%CreationDate: 2019-02-20

% This program can redistributed and/or modified under the terms of
% the LaTeX Project Public License Distributed from CTAN archives in
% directory macros/latex/base/lppl.txt; either version 1.3c of the
% License, or (at your option) any later version.

/plotdict 100 dict def
plotdict begin

/URL (http://people.csail.mit.edu/jaffer/Marbling) def
/pi 3.141592653589793 def
/e 2.718281828459045 def
/e^-1 1 e div def
/m4o3 -4 3.0 div def

% dps define max, if not already defined
systemdict /max known not {
    /max { /arg1 exch def/arg2 exch def
	   arg1 arg2 gt {arg1}{arg2}ifelse
	 } def
    /min { /arg1 exch def/arg2 exch def
	   arg1 arg2 lt {arg1}{arg2}ifelse
	 } def
} if
% dps asin definition from mst-math.pro used here
systemdict /arcsin known not {
    /arcsin {neg dup dup mul neg 1 add sqrt neg atan 180 sub} bind def
} if

/numeric?			% x --> bool
{
    type dup /realtype eq exch /integertype eq or
} bind def

/cos-sin			% th --> sin-th cos-th
{
    dup cos exch sin
} bind def

% negative viscosity for (raster) reverse-marbling
/marble				% nu (viscosity)
{
%    dup /nu exch 1e-6 mul abs def
%    /reverse-rendering? oversample 0 gt def
%    0 setlinewidth
    oversample 0 gt
    {
	matrix currentmatrix aload pop 6 {round 6 1 roll} repeat
	matrix astore setmatrix newpath
    } if
%    clippath pathbbox /hiy exch round cvi def /hix exch round cvi def
%		      /loy exch round cvi def /lox exch round cvi def
%    oversample 0 gt not {background aload pop setrgbcolor fill} if
    /scl hiy loy sub hix lox sub max overscan div def
    /acnt actions length def
    /pcnt spractions length def
% set background field of each /drop
    0 1 acnt -1 add
    {
	/sdx exch def
	actions sdx get aload pop /ct exch def
	ct /drop eq
	{
	    pop pop pop /cy exch def /cx exch def
	    cx cy sdx find-drop-background /bgc exch def
	    actions sdx get 3 bgc put
	}
	{
	    ct /rake eq
	    {pop pop pop pop pop pop}
	    {
		ct /wiggle eq
		{numeric? {pop pop pop} if pop}
		{
		    ct /offset eq
		    {pop pop}
		    {
			ct /vortex eq
			{pop pop pop pop}
			{
			    ct /stir eq
			    {pop pop pop pop pop}
			    {
				ct /stylus eq
				{pop pop pop pop pop pop pop pop pop pop}
				{(unrecognized token) = ct =} ifelse
			    } ifelse
			} ifelse
		    } ifelse
		} ifelse
	    } ifelse
	} ifelse
    } for
    oversample 0 gt
    {
	do-raster
    }
    {
	gsave
	scl dup scale
	do-drops
	grestore
    } ifelse
    % post-actions
    pcnt 0 gt
    {
	gsave
	scl 1000 div dup scale
	0 1 pcnt -1 add
	{
	    /idx exch def
	    spractions idx get aload pop /ct exch def
	    ct /Gaussian-spray eq
	    {Gaussian-spray-do}
	    {
		ct /uniform-spray eq
		{uniform-spray-do}
		{(unrecognized post token) = ct =} ifelse
	    } ifelse
	} for
	grestore
    } if
    overscan 1 gt
    {
	gsave
	1 setlinewidth
	1 overscan div dup scale
	0 setgray
	[ 10 10 ] 0 setdash
	lox loy hix lox sub hiy loy sub rectstroke
	1 setgray
	[ 10 10 ] 10 setdash
	lox loy hix lox sub hiy loy sub rectstroke
	grestore
    } if
} bind def

/ct-dispatch
{
    ct /wiggle eq
    {wiggle-deformation}
    {
	ct /offset eq
	{offset-deformation}
	{
	    ct /rake eq
	    {rake-deformation}
	    {
		ct /vortex eq
		{vortex-deformation}
		{
		    ct /stir eq
		    {stir-deformation}
		    {
			ct /stylus eq
			{stylus-deformation}
			{(unrecognized token) = ct =} ifelse
		    } ifelse
		} ifelse
	    } ifelse
	} ifelse
    } ifelse
} bind def

%% Given x, y coordinates and index of /drop on stack, returns the rgb
%% vector of the drop immediately surrounding that drop.
/find-drop-background
{
    /cdx exch -1 add def
    {
	cdx 0 lt {pop pop background exit} if
	actions cdx get aload pop /ct exch def
	ct /drop eq
	% movement due to drop.
	{	% px py cx cy rad^2 bgc rgb
	    /rgb exch def
	    pop % /bgc exch def
	    /rad^2 exch def
	    /cy exch def /cx exch def
	    /py exch def /px exch def
	    /a^2 px cx sub dup mul py cy sub dup mul add def
	    a^2 1e-10 lt {0} {1 rad^2 a^2 div sub} ifelse
	    /disc exch def
	    disc 0 le
	    {rgb exit}
	    {
		/a disc sqrt def
		px cx sub a mul cx add
		py cy sub a mul cy add
	    } ifelse
	}
	{ct-dispatch} ifelse
	/cdx cdx -1 add def
    } loop
} bind def

/offset-deformation		% px py dx dy --> px py
{
    /dy exch def /dx exch def
    dy add exch
    dx add exch
} bind def

/wiggle-deformation	     % px py dx dy period ofst depth --> px py
{
    dup numeric?
    {
	/depth exch def
	/ofst exch def
	/period exch def
	/dy exch def /dx exch def
	/py exch def /px exch def
	/a py dx mul px dy mul sub period mul ofst add sin depth mul def
    }
    {
	% old-style: px py ang {func} --> px py
	/func exch def /ang exch 90 sub def
	/dy ang cos def /dx ang sin def
	/py exch def /px exch def
	/a py dx mul px dy mul sub 1000 mul func exec
	1e-3 mul oversample 0 gt {neg} if def
    } ifelse
    px dx a mul add py dy a mul add
} bind def

/tines				% cnt spacing ofst
{
    /ofst exch def
    /spacing exch def
    /cnt exch def
    /hint cnt 1 sub -2 div cvi def
    hint
    1
    cnt 1 sub hint add
    { spacing mul ofst add } for
} bind def

/stylus-deformation		% px py bx by ex ey L tU rpts nx ny stpx stpy --> px py
{
    /stpy exch def /stpx exch def
    /ny exch def /nx exch def
    /rpts exch def /tU exch def /L exch def
    /ey exch def /ex exch def
    /by exch def /bx exch def
    /py exch def /px exch def
    /inx 0 def /iny 0 def
    1 1 rpts
    {
	pop
	/dxB bx px sub def /dyB by py sub def
	/dxE ex px sub def /dyE ey py sub def
	/r dxB dup mul dyB dup mul add sqrt def
	/denr r L div def
	denr 6 lt denr 0 gt and
	{
	    /s dxE dup mul dyE dup mul add sqrt def
	    /txB dxB nx mul dyB ny mul add def
	    /txE dxE nx mul dyE ny mul add def
	    /ty dxB ny mul dyB nx mul sub def
	    /denr e   denr  exp r mul L mul 2 mul def
	    /dens e s L div exp s mul L mul 2 mul def
	    /inx r L mul ty dup mul sub tU mul denr div
	         s L mul ty dup mul sub tU mul dens div add def
	    /iny txB ty mul tU mul denr div
		 txE ty mul tU mul dens div add def
	    /px px inx nx mul iny ny mul add add def
	    /py py inx ny mul iny nx mul sub add def
	} if
	/bx ex def /by ey def
	/ex ex stpx add def /ey ey stpy add def
    } for
    px py
} bind def

/rake-deformation		% [ dx dy [ rs ] V tU L^-1 /rake ]
{
    /L^-1 exch def /tU exch def /V exch def
    /rs exch def /dy exch def /dx exch def
    /py exch def /px exch def
    /a 0 def
    rs
    {
	/r exch def
	/bx dy r mul def /by dx r mul neg def
	px bx sub dy mul py by sub dx mul sub abs L^-1 mul
	e^-1 exch exp tU mul a add /a exch def
    } forall
    px dx a mul add py dy a mul add
} bind def

/stir-deformation		% [ cx cy [ rs ] th L^-1 /stir ]
{
    /L^-1 exch def /th exch def /rs exch def
    /cy exch def /cx exch def
    /py exch def /px exch def
    /p-c px cx sub dup mul py cy sub dup mul add sqrt def
    /a 0 def
    1e-6 p-c lt
    {   rs
	{   /r exch def
	    /a p-c r abs sub abs L^-1 r abs div mul e^-1 exch exp th mul
	    r 0 gt {neg} if a add def
	} forall
	oversample 0 gt {/a a neg def} if
	px cx sub py cy sub
	[ a cos-sin 2 copy neg exch cx cy ] transform
    }
    {px py} ifelse
} bind def

% An irrotational vortex.  circ is circulation; t is time in seconds
/vortex-deformation		% px py cx cy circ t --> px py
{
    /tcoef exch def
    /circ exch def
    /cy exch def /cx exch def
    /py exch def /px exch def
    /p-c^2 px cx sub dup mul py cy sub dup mul add def
    p-c^2 1e-6 lt
    { px py }
    {
	/a nuterm p-c^2 tcoef mul .75 exp add m4o3 exp circ mul def
	px cx sub py cy sub
	[ a cos-sin 2 copy neg exch cx cy ] transform
    }
    ifelse
} bind def

%% Functions used for forward rendering:

% movement due to drop.
/spread				% px py cx cy rad^2 --> px py
{
    /rad^2 exch def /cy exch def /cx exch def
    /py exch def /px exch def
    /p-c^2 px cx sub dup mul py cy sub dup mul add def
    % p-c^2 rad^2 4096 mul gt
    % { px py }
    % {
	/a rad^2 p-c^2 div 1 add sqrt def
	py cy sub px cx sub a mul cx add exch a mul cy add
    % }
    % ifelse
} bind def

%% Given x, y coordinates on stack, calculates movement due to
%% subsequent operations.
/composite-map
{
    idx 1 add 1 acnt -1 add
    {
	actions exch get aload pop /ct exch def
	ct /drop eq
	{pop pop spread}	% pop rgb-vectors
	{ct-dispatch} ifelse
    } for
} bind def

% Given x, y coordinates on stack and eps < 2, leaves x, y on stack
% for next point on the circle centered at origin.
/Minsky-circle
{
    dup 3 1 roll eps mul sub dup eps mul 3 2 roll add
} bind def

% Draws and fills circle as distorted by composite-map
/do-drops			% acnt = index of last action + 1
{
    0 1 acnt -1 add
    {
	/idx exch def
	actions idx get aload pop /act exch def
	/drop act eq
	{
	    aload pop setrgbcolor pop
	    /rad exch sqrt def /Cy exch def /Cx exch def
            /eps 0.005 scl sqrt rad mul acnt idx sub 1 add log mul div def

	    rad Cx add Cy composite-map moveto
	    rad 0
	    {
		dup /oy exch def
		Minsky-circle 2 copy
		exch Cx add exch Cy add		% shift center of drop
		composite-map lineto
		dup 0 gt oy 0 lt and {exit} if
	    } loop
	    pop pop
	    closepath Contours
	} if
    } for
} bind def

%% Functions used for reverse-rendering:

/Vmap1				% v1 proc
{
    /proc exch def
    /v1 exch def
    [ v1 {proc exec} forall ]
} bind def

/Vmap2				% v1 v2 proc
{
    /proc exch def
    /v2 exch def
    /idx 0 def
    /res v2 length array def
    {
	res exch idx exch v2 idx get proc exec put
	/idx idx 1 add def
    } forall
    res
} bind def

/shade				% v[3] pwr
{
    /pwr exch def
    {dup 1e-30 lt {} {pwr exp} ifelse} Vmap1
} bind def

/sharpen			% 0<=x<=1
{
    .5 sub dup abs 1e-8 lt {} {dup abs .66 exp div .63 mul} ifelse
    .5 add
} bind def

%% Given x, y coordinates on stack, calculates the rgb vector
%% acnt is index +1 of last operation.
/actions2rgb
{
    /cdx acnt -1 add def
    {
	actions cdx get aload pop /ct exch def
	ct /drop eq
	% movement due to drop.
	{	% px py cx cy rad^2 bgc rgb
	    /rgb exch def
	    /bgc exch def
	    /rad^2 exch def
	    /cy exch def /cx exch def
	    /py exch def /px exch def
	    /a^2 px cx sub dup mul py cy sub dup mul add def
	    /disc a^2 1e-10 lt {0} {1 rad^2 a^2 div sub} ifelse def
	    disc 0 le
	    {
		disc -0.001 le
		{rgb}
		{
		    /a disc neg sqrt sharpen def
		    rgb bgc {1 a sub mul exch a mul add} Vmap2}
		ifelse
		exit
	    }
	    {
		/a disc sqrt def
		px cx sub a mul cx add
		py cy sub a mul cy add
	    } ifelse
	}
	{ct-dispatch} ifelse
	/cdx cdx -1 add def
	cdx 0 lt {pop pop background exit} if
    } loop
} bind def

/do-raster
{
    /sampleover 1 oversample div def
    loy sampleover hiy
    {
	/iy exch def
	/fy iy scl div def
	lox sampleover hix
	{
	    /ix exch def
	    /fx ix scl div def
	    fx fy actions2rgb
	    % color modifications
	    % fy dup mul fx dup mul add sqrt dup
	    % riplim lt
	    % {180. ripple div mul sin abs .75 mul 1 exch sub shade}
	    % {pop}
	    % ifelse
	    % end color modifications
	    aload pop setrgbcolor
	    newpath ix iy moveto sampleover 0 rlineto
	    0 sampleover rlineto sampleover neg 0 rlineto closepath FILL
	} for
    } for
} bind def

% [ cx cy rad^2 [ bgc ] [ rgb ] /drop ]
% [ cx cy [ r ] th L^-1 /stir ]
% [ cx cy circ t /vortex ]
% [ bx by ex ey L tU rpts nx ny stpx stpy /stylus ]
% [ dx dy [ rs ] V tU L^-1 /rake ]
% [ dx dy period ofst depth /wiggle ]
% [ dx dy /offset ]

/concatstrings			% (a) (b) -> (ab)
{ exch dup length
  2 index length add string
  dup dup 4 2 roll copy length
  4 -1 roll putinterval
} bind def

/color-norm			% rgb
{
    /rgb exch def
    rgb type /stringtype eq
    { /rgb (16#) rgb concatstrings cvi def
      /rgb [
	  rgb 65536 idiv 255 div
	  rgb 256 idiv 256 mod 255 div
	  rgb 256 mod 255 div
      ] def
    } if
    rgb {1 gt} forall or or { [ rgb {255 div} forall ] } { rgb } ifelse
} bind def

/color-norm*
{
    /clr* exch def
    clr* 0 get type dup /arraytype ne exch /stringtype ne and { /clr* [ clr* ] def } if
    [ clr* {color-norm} forall ]
} bind def

/drop				% cx cy rad^2 rgb
{
    /rgb exch def
    /rad^2 exch .001 mul dup mul def
    /cy exch .001 mul def
    /cx exch .001 mul def
    [ cx cy rad^2 -1 rgb color-norm /drop ]
} bind def

/vortex				% cx cy circ tcoef
{
    /t exch def
    /circ exch -1e-6 mul 180 pi div mul oversample 0 gt {neg} if def
    /cy exch .001 mul def /cx exch .001 mul def
    /tcoef 2 pi mul t div def
    /nuterm visc 1e-6 mul abs 4 mul .75 exp def
    [ cx cy circ tcoef /vortex ]
} bind def

/stylus				% bx by ex ey V D
{
    /D exch .001 mul def /V exch .001 mul abs def
    oversample 0 gt { 4 2 roll } if	% reverse-rendering?
    /ey exch .001 mul def /ex exch .001 mul def
    /by exch .001 mul def /bx exch .001 mul def
    /L V D dup mul mul visc 1e-6 mul abs div def
    /tU ex bx sub dup mul ey by sub dup mul add sqrt def
    /rpts tU L div ceiling cvi def
    /nx ex bx sub tU div def /ny ey by sub tU div def
    /tU tU rpts div def
    /stpx ex bx sub rpts div def /stpy ey by sub rpts div def
    /ex bx stpx add def /ey by stpy add def
    1e-6 tU le { [ bx by ex ey L tU rpts nx ny stpx stpy /stylus ] } if
} bind def

/stroke {stylus} bind def

/stir				% cx cy [ r ] w th D
{
    /D exch .001 mul def /th exch def /w exch abs def
    /rs exch def
    /cy exch .001 mul def /cx exch .001 mul def
    /L^-1 visc 1e-6 mul abs w pi 180 div mul D dup mul mul div def
    [ cx cy [ rs {.001 mul} forall ] th L^-1 /stir ]
} bind def

/rake				% angle [ r ] V tU D
{
    /D exch .001 mul def /tU exch .001 mul def /V exch .001 mul abs def
    /rs exch def /ang exch def
    [ ang cos-sin exch [ rs {.001 mul} forall ]
      V
      tU oversample 0 gt {neg} if
      visc 1e-6 mul abs V D dup mul mul div	% L^-1
      /rake ]
} bind def

/wiggle				% angle period ofst depth
{
    dup numeric?
    {
	/depth exch def
	/ofst exch def
	/period exch def
	/ang exch 90 sub def
	[ ang cos-sin exch
	  1000 360 div period mul
	  ofst
	  depth 1e-3 mul oversample 0 gt {neg} if /wiggle ] }
    { /wiggle 3 array astore }
    ifelse
} bind def

/shift				% angle r
{
    /r exch .001 mul def
    /th exch def
    /dx th sin r mul oversample 0 gt {neg} if def
    /dy th cos r mul oversample 0 gt {neg} if def
    [ dx dy /offset ]
} bind def

/concentric-rings		% xc yc thick [ color ] count
{
    /cnt exch def
    /clra exch color-norm* def
    /rinc exch def
    /yc exch def
    /xc exch def
    /nclr clra length def
    cnt 1 sub -1 0
    {
	/cnt exch def
	cnt 0 le
	{ xc yc rinc clra 0 get drop }
	{ xc yc cnt 2 mul 1 add sqrt rinc mul clra cnt nclr mod get drop }
	ifelse
    } for
} bind def

/coil-drops		% xc yc r ang-strt arcinc rinc [ rgb ] cnt drad
{
    /drad exch def
    /cnt exch def
    /clra exch color-norm* def
    /rinc exch def
    /arcinc exch def
    /th exch def
    /r exch def
    /yc exch def
    /xc exch def
    /nclr clra length def
    /cdx 0 def
    cnt
    {
	th cos-sin r mul xc add exch r mul yc add drad clra cdx nclr mod get drop
	/th th arcinc r div -1 max 1 min arcsin add def
	/r r rinc add def
	/cdx cdx 1 add def
    } repeat
} bind def

/line-drops		% xc yc ang [ r ] [ rgb ] drad
{
    /drad exch def
    /clra exch color-norm* def
    /rs exch def
    /th exch def
    /yc exch def
    /xc exch def
    /nclr clra length def
    /cdx 0 def
    rs
    {
	/r exch def
	th cos-sin r mul xc add exch r mul yc add drad clra cdx nclr mod get drop
	/cdx cdx 1 add def
    } forall
} bind def

%    Copyright (C) 1996-1998 Geoffrey Keating.
% This file may be freely distributed with or without modifications,
% so long as modified versions are marked as such and copyright
% notices are not removed.

% Modified for PRNG use by Aubrey Jaffer 2019.

% An implementation of an algorithm compatible with the RSA Data Security
% Inc. RC4 stream encryption algorithm.

% <string> rc4setkey <dict>
/rc4setkey
{
    6 dict begin
    /k exch def
    /a 256 string def
    0 1 255 { a exch dup put } for
    /l k length def
    /j 0 def
    0 1 255
    {
	/i exch def
	/j a i get k i l mod get add j add 255 and def
	a i a j get a j a i get put put
    } for
    3 dict dup begin
    /a a def
    /x 0 def
    /y 0 def
    end
    end
} bind def

% <rc4key> <string> rc4 <rc4key> <string>
/rc4
{
    1 index begin
    dup dup length 1 sub 0 exch 1 exch
    {
	/x x 1 add 255 and def
	/y a x get y add 255 and def
	a x a y get a y a x get put put
	% stack: string string index
	2 copy get
	a dup x get a y get add 255 and get
	xor put dup
    } for
    pop
    end
} bind def

% Returns number between 0 and 1
/random:uniform
{
    /str 7 string def
    0 1 str length -1 add { str exch 0 put } for
    seed str rc4 exch pop 0 exch {add 256. div} forall
} bind def

% Returns pair of normally distributed numbers.
/random:normal2
{
    /rnt random:uniform 360 mul def
    /rnr random:uniform ln -2 mul sqrt def
    rnt cos-sin exch rnr mul exch rnr mul
} bind def

/Gaussian-drops		%  xc yc r angle eccentricity [ rgb ] cnt drad
{
    /drad exch def
    /cnt exch def
    /clra exch color-norm* def
    /eccentricity exch sqrt def
    /angle exch neg def
    /r exch 2 sqrt div def
    /yc exch def
    /xc exch def
    /nclr clra length def
    /cdx 0 def
    cnt
    {
	random:normal2 eccentricity div r mul exch eccentricity mul r mul
	[ angle cos-sin 2 copy neg exch xc yc ] transform
	drad clra cdx nclr mod get drop
	/cdx cdx 1 add def
    } repeat
} bind def

/Gaussian-spray		%  xc yc r angle eccentricity [ rgb ] cnt drad
{
    /Gaussian-spray 9 array astore
} bind def

/Gaussian-spray-do	%  xc yc r angle eccentricity [ rgb ] cnt drad
{
    /drad exch def
    /cnt exch def
    /clra exch color-norm* def
    /eccentricity exch sqrt def
    /angle exch neg def
    /r exch 2 sqrt div def
    /yc exch def
    /xc exch def
    /nclr clra length def
    /cdx 0 def
    cnt
    {
	random:normal2 eccentricity div r mul exch eccentricity mul r mul
	[ angle cos-sin 2 copy neg exch xc yc ] transform
	newpath
	clra cdx nclr mod get aload pop setrgbcolor
	e random:normal2 pop drad log 3 mul add 3 div exp 0 360 arc fill
	/cdx cdx 1 add def
    } repeat
} bind def

/uniform-drops		%  xc yc xsid ysid angle [ rgb ] cnt drad
{
    /drad exch def
    /cnt exch def
    /clra exch color-norm* def
    /angle exch neg def
    /ysid exch def
    /xsid exch def
    /yc exch def
    /xc exch def
    /nclr clra length def
    /cdx 0 def
    cnt
    {
	random:uniform 0.5 sub xsid mul
	random:uniform 0.5 sub ysid mul
	[ angle cos-sin 2 copy neg exch xc yc ] transform
	drad clra cdx nclr mod get drop
	/cdx cdx 1 add def
    } repeat
} bind def

/uniform-spray		     %  xc yc xsid ysid angle [ rgb ] cnt drad
{
    /uniform-spray 9 array astore
} bind def

/uniform-spray-do	     %  xc yc xsid ysid angle [ rgb ] cnt drad
{
    /drad exch def
    /cnt exch def
    /clra exch color-norm* def
    /angle exch neg def
    /ysid exch def
    /xsid exch def
    /yc exch def
    /xc exch def
    /nclr clra length def
    /cdx 0 def
    cnt
    {
	random:uniform 0.5 sub xsid mul
	random:uniform 0.5 sub ysid mul
	[ angle cos-sin 2 copy neg exch xc yc ] transform
	newpath
	clra cdx nclr mod get aload pop setrgbcolor
	e random:normal2 pop drad log 3 mul add 3 div exp 0 360 arc fill
	/cdx cdx 1 add def
    } repeat
} bind def

/serpentine-drops		%  xc yc [ xrs ] [ yrs ] th [ rgb ] drad
{
    /drad exch def
    /clra exch color-norm* def
    /th exch neg def
    /yrs exch def
    /xrs exch def
    /yc exch def
    /xc exch def
    /nclr clra length def
    /par 0 def
    /cdx 0 def
    yrs
    {
	/yr exch def
	par 0 eq { 0 1 xrs length 1 sub } { xrs length 1 sub -1 0 } ifelse
	{
	    /xdx exch def
	    /xr xrs xdx get def
	    xr yr [ th cos-sin 2 copy neg exch xc yc ] transform
	    drad clra cdx nclr mod get drop
	    /cdx cdx 1 add def
	} for
	/par 1 par sub def
    } forall
} bind def

end
% Local Variables:
% mode: PS
% End:
