::
::::  /hoon/action/sole/mar
  ::
/?    310
/-    sole
/+    old-zuse
::
::::
  ::
=,  sole
=,  old-zuse
|_  sole-action
::
++  grab                                                ::  convert from
  |%
  ++  json
    |=  jon/^json  ^-  sole-action
    %.  jon
    =>  [dejs:format ..sole-action:sole]
    |^  (fo %ret (of det+change ~))
    ++  fo
      |*  {a/term b/fist}
      |=  c/json
      ?:  =([%s a] c)  [a ~]
      (b c)
    ::
    ++  ra
      |*  {a/{term fist} b/fist}
      |=  c/json  %.  c
      ?.(=(%a -.c) b (pe -.a (ar +.a)))
    ::
    ++  ke                                              ::  callbacks
      |*  {gar/* sef/(trap fist)}
      |=  jon/json  ^-  (unit _gar)
      =-  ~!  gar  ~!  (need -)  -
      ((sef) jon)
    ::
    ++  change  (ot ler+(at ni ni ~) ted+(pe 0v0 edit) ~)
    ++  char  (cu turf so)
    ++  edit
      %+  ke  *sole-edit  |.  ~+
      %+  fo  %nop
      %+  ra  mor+edit
      (of del+ni set+(cu tuba sa) ins+(ot at+ni cha+char ~) ~)
    --
  ::
  ++  noun  sole-action                                   ::  clam from %noun
  --
--
