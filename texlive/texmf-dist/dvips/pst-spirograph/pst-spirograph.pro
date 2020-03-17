%% $Id: pst-spirograph.pro 80 2014-08-23 05:50:14Z herbert $
%%
% PostScript prologue for pst-spirograph.tex.
%
% Version 0.41, 2014/08/23 
%
/tx@spirographDict 50 dict def 
tx@spirographDict begin
/coorPen {
  1 dict begin
    /t exch def
    r2 qi t cos mul ki qi t mul 60 ni mul sub cos mul add mul cm
    r2 qi t sin mul ki qi t mul 60 ni mul sub sin mul sub mul cm
  end
} def
/coorPen2 {
  1 dict begin
    /t exch def
    r2 qi2 t cos mul ki qi2 t mul 60 ni mul neg 180 Z2 div sub sub cos mul sub mul cm
    r2 qi2 t sin mul ki qi2 t mul 60 ni mul neg 180 Z2 div sub sub sin mul sub mul cm
  end
} def
/Datas1 {
  /Z@ exch def
  /m@ exch def
  /R@ { m@ Z@ mul 2 div } bind def % cercle primitif
  /Rb { R@ ap cos mul } bind def % cercle de base
  /Rp { R@ 2 mul 2.5 m@ mul sub 2 div } bind def % cercle de pied
  /Rt { R@ 2 mul 2 m@ mul add 2 div } bind def % cercle de tète
} def
/Datas2 {
  /Z@ exch def
  /m@ exch def
  /R@ { m@ Z@ mul 2 div } bind def % cercle primitif
  /Rb { R@ ap cos mul } bind def % cercle de base
  /Rp { R@ 2 mul 2 m@ mul sub 2 div } bind def % cercle de pied
  /Rt { R@ 2 mul 2.5 m@ mul add 2 div } bind def % cercle de tète
} def
/Calculs { % les valeurs suivantes sont en radians
  /ThetaP {R@ Rb div dup mul 1 sub sqrt } bind def % intersection avec cercle primitif
  /ThetaT {Rt Rb div dup mul 1 sub sqrt } bind def % intersection avec cercle de tete
  % Les valeurs suivantes ont en degrés
  /ThetaTdeg {Rt Rb div dup mul 1 sub sqrt RadtoDeg } bind def %
  /ThetaPdeg {R@ Rb div dup mul 1 sub sqrt RadtoDeg } bind def
  /DeltaP {ThetaPdeg sin ThetaP ThetaPdeg cos mul sub
           ThetaPdeg cos ThetaP ThetaPdeg sin mul add atan } bind def
  /DeltaT {ThetaTdeg sin ThetaT ThetaTdeg cos mul sub
           ThetaTdeg cos ThetaT ThetaTdeg sin mul add atan } bind def
  /DeltaS {Pi 2 div Z@ div } bind def
  /DeltaSdeg {90 Z@ div } bind def
  /AngleDent {360 Z@ div} bind def
  /Alpha {DeltaSdeg DeltaP add DeltaT sub } bind def
  /2Beta {DeltaSdeg DeltaP add 2 mul } bind def
  /Beta_  {DeltaSdeg DeltaP add neg} bind def
  /ptA { Rp cm 0} bind def
  /ptB { Rb cm 0} bind def
  /ptC { Rp cm DeltaSdeg 2 mul neg 2Beta 2 div add cos mul
         Rp cm DeltaSdeg 2 mul neg 2Beta 2 div add sin mul} bind def
  /ptA'{ Rp cm DeltaP DeltaSdeg add 2 mul cos mul
         Rp cm DeltaP DeltaSdeg add 2 mul sin mul} bind def
  /ptB'{ Rb cm DeltaP DeltaSdeg add 2 mul cos mul
         Rb cm DeltaP DeltaSdeg add 2 mul sin mul} bind def
  /ptC'{ Rp cm DeltaSdeg 3 mul DeltaP add cos mul
         Rp cm DeltaSdeg 3 mul DeltaP add sin mul} bind def
  /Raxe { Rp 4 div } bind def
  /A@0 14.5 def % position et largeur de la clavette
  % rayon de raccordement sur le cercle de pied
  /Rarct {Rp Pi mul Z@ div 12 div cm} bind def
} def
% Le symetrique P' de P par rapport a la l'axe de la dent
% Delta(axe de la dent) y=x*tan(Beta)
% x'=y*sin(2*Beta)+x*cos(2*Beta)
% y'=x*sin(2*Beta)-y*cos(2*Beta)
% x y symAxe -> x' y'
/symAxe {
 2 dict begin
  /y exch def
  /x exch def
  y 2Beta sin mul x 2Beta cos mul add % x'
  x 2Beta sin mul y 2Beta cos mul sub % y'
 end
} def
 %
% Rotation pour amener l'axe de la dent horizontal
%
/RotDent {
  2 dict begin
    /y exch def
    /x exch def
    i@ cos x mul i@ sin y mul sub
    i@ sin x mul i@ cos y mul add
  end
} def
% developpante du cercle de base
%
/Circles {
  gsave
  setlinedash
  newpath
  0 0 R@ cm 0 360 arc
  closepath
  circlescolor
  stroke
  % on ne dessine pas le cercle de base
  %newpath
  %0 0 Rb cm 0 360 arc
  %closepath
  %stroke
  grestore
} def
%
% trace des cercles
/devCercle {
  1 dict begin
  /t exch def % en degres
  Rb t cos t DegtoRad t sin mul add mul cm % x
  Rb t sin t DegtoRad t cos mul sub mul cm % y
 end
} def
%%
%%%% definition de la roue dentee %%%%%%
/Roue {
  % arc de développante
  /tabArcDev [ 0 1 ThetaTdeg { /i@ exch def [i@ devCercle] } for ] def
  /n@ tabArcDev length def
% l'arc de developpante initial
  /tabDent [ tabArcDev aload pop
% l'arc ce cercle de tete
     DeltaT 0.1 2Beta DeltaT sub {/i@ exch def
     [Rt cm i@ cos mul Rt cm i@ sin mul] } for
% le symetrique de l'arc de developpante par rapport a l'axe de la dent
  n@ 1 sub -1 0 { /compteur exch def [tabArcDev compteur get aload pop symAxe] } for ] def
% trace de la dent
  /n2@ tabDent length def
  newpath
  ptC moveto
  0 1 Z@ 1 sub {
    /i@ exch AngleDent mul def
    ifinner {
      wheel 2 eq { ptA RotDent ptB RotDent Rarct arct ptB RotDent lineto }
                 { ptA RotDent lineto ptB RotDent lineto } ifelse
    }{
      Rp Rb eq { ptA RotDent lineto ptB RotDent lineto }
               { ptA RotDent ptB RotDent Rarct arct ptB RotDent lineto } ifelse
    } ifelse
    0 1 n2@ 1 sub {
      /compteur exch def
      tabDent compteur get aload pop
      RotDent lineto 
    } for
    ifinner {
      wheel 2 eq {
       Rp Rb eq 
         { ptA' RotDent lineto ptC' RotDent lineto }
         { ptA' RotDent ptC' RotDent Rarct arct ptC' RotDent lineto } ifelse
      }{ ptA' RotDent lineto ptC' RotDent lineto } ifelse
    }{
      Rp Rb eq 
        { ptA' RotDent lineto ptC' RotDent lineto }
        { ptA' RotDent ptC' RotDent Rarct arct ptC' RotDent lineto } ifelse
    } ifelse
  } for
} def
%
% pour l'engrenage interieur
/COURONNE { 0 0 Rt 1.1 mul cm 360 0 arcn } def
%
/trous {
  1 dict begin
    /a@ { R@ cm 3 div Pi div } bind def
    gsave
    positionAngular rotate
    0 60 540 {
      /THETA exch def
      untrou
      1 setgray iffill { Fill } if
      untrou
      linecolor
      stroke
    } for
    grestore
  end
} def
%
/untrou {
  newpath
  a@ THETA DegtoRad mul THETA cos mul neg
  a@ THETA DegtoRad mul THETA sin mul
  0.05 cm 0 360 arc
  closepath
} def
%
%%%%%%%%%% Roue No 1 %%%%%%%%%%%%%%%%%
/Roue1 {
  1 dict begin
  /wheel 1 def
  gsave
  t@@x t@@y translate
  m1 Z1
  ifinner {
    Datas2
    Calculs
    Beta_ rotate
    Roue
    COURONNE
    closepath
    iffill { color1 Fill } if
    Roue
    closepath
    linecolor
    stroke
    COURONNE
    closepath
    linecolor
    stroke
    ifcircles { Circles } if
  }{
    Datas1
    Calculs
    Beta_ rotate
    Roue
    closepath
    iffill { color1 Fill } if
    Roue
    closepath
    linecolor
    stroke
    ifcircles { Circles } if
  } ifelse
  grestore
  % dessin de l'hypocycloide ou de l'epicycloide
  gsave
  t@@x t@@y translate
  ifinner {
    tabSpirograph 0 get aload pop moveto
    1 1 nPts {
      /nP exch def
      tabSpirograph nP get aload pop lineto
    } for
  }{
    tabSpirograph2 0 get aload pop moveto
    1 1 nPts2 {
      /nP exch def
      tabSpirograph2 nP get aload pop lineto
    } for
  } ifelse 
  curvecolor
  SetCurveWidth
  stroke
  grestore
  end
} def
%%%%%%%%%% Roue No 2 %%%%%%%%%%%%%%%%%
/Roue2 {
  5 dict begin
  /wheel 2 def
  gsave
  m2 Z2 Datas1
  Calculs
  /a@ex m2 Z1 Z2 add mul 2 div cm def % entraxe engrenage exterieur
  /a@in m2 Z1 Z2 sub mul 2 div cm def % entraxe engrenage interieur
  /a@ {R@ cm 3 div 3.14159 div} bind def
  ifinner{
    a@in polarAngle cos mul t@@x add a@in polarAngle sin mul t@@y add translate
    Beta_ polarAngle Z1 Z2 sub Z2 div mul sub rotate
    /positionAngular 2Beta 2 div def
  }{
    a@ex polarAngle cos mul t@@x add a@ex polarAngle sin mul t@@y add translate
    DeltaSdeg DeltaP add neg 180 Z2 div add 180 add polarAngle Z1 Z2 add Z2 div mul add rotate
    /positionAngular Beta_ neg def
  } ifelse
  Roue
  closepath
  iffill { color2 Fill } if
  Roue
  closepath
  linecolor
  stroke
  trous
  ifcircles { Circles } if
  grestore
  gsave
  newpath
  ifinner {
    a@in polarAngle cos mul t@@x add a@in polarAngle sin mul t@@y add translate
    Beta_ polarAngle Z1 Z2 sub Z2 div mul sub rotate
    /THETA 540 ni 60 mul sub def
    positionAngular rotate
    a@ THETA DegtoRad mul THETA cos mul neg
    a@ THETA DegtoRad mul THETA sin mul
    0.06 cm 0 360 arc
  }{
     a@ex polarAngle cos mul t@@x add a@ex polarAngle sin mul t@@y add translate
    DeltaSdeg DeltaP add neg 180 Z2 div add 180 add polarAngle Z1 Z2 add Z2 div mul add rotate
    /a@ {R@ cm 3 div 3.14159 div} bind def
    /THETA 540 ni 60 mul sub def
    positionAngular rotate
    a@ THETA DegtoRad mul THETA cos mul neg
    a@ THETA DegtoRad mul THETA sin mul
    0.06 cm 0 360 arc
  } ifelse
  closepath
  curvecolor
  fill
  grestore
  end
} def
end
%%