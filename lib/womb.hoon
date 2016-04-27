::                                                      ::  ::
::::  /hoon/womb/lib                                    ::  ::
  ::                                                    ::  ::
/?    310                                               ::  version
/+    talk
::                                                      ::  ::
::::                                                    ::  ::
  ::                                                    ::  ::
|%
++  foil                                                ::  ship allocation map
  |*  mold                                              ::  entry mold
  $:  min/@u                                            ::  minimum entry
      ctr/@u                                            ::  next allocated
      und/(set @u)                                      ::  free under counter
      ove/(set @u)                                      ::  alloc over counter
      max/@u                                            ::  maximum entry
      box/(map @u +<)                                   ::  entries
  ==                                                    ::
--                                                      ::
::                                                      ::
::::                                                    ::
  ::                                                    ::
|%                                                      ::
++  managed                                             ::  managed plot
  |*  mold                                              ::  
  %-  unit                                              ::  unsplit
  %+  each  +<                                          ::  subdivided
  mail                                                  ::  delivered
::                                                      ::
++  divided                                             ::  get division state
  |*  (managed)                                         ::
  ?-  +<                                                ::
    $~      ~                                           ::  unsplit
    {$~ $| *}  ~                                        ::  delivered
    {$~ $& *}  (some p.u.+<)                            ::  subdivided
  ==                                                    ::
::                                                      ::
++  moon  (managed _!!)                                 ::  undivided moon
::
++  planet                                              ::  subdivided planet
  (managed (lone (foil moon)))                          ::
::                                                      ::
++  star                                                ::  subdivided star
  (managed (pair (foil moon) (foil planet)))            ::
::                                                      ::
++  galaxy                                              ::  subdivided galaxy
  (managed (trel (foil moon) (foil planet) (foil star)))::
::                                                      ::
++  passcode  @pG                                       ::  64-bit passcode
++  mail  @ta                                           ::  email address
++  balance                                             ::  invitation balance
  $:  planets/@ud                                       ::  planet count
      stars/@ud                                         ::  star count
      owner/mail                                        ::  owner's email
      history/(list mail)                               ::  transfer history
  ==                                                    ::
++  client                                              ::  per email
  $:  sta/@ud                                           ::  unused star refs
      has/(set @p)                                      ::  planets owned
  ==                                                    ::
++  property                                            ::  subdivided plots
  $:  galaxies/(map @p galaxy)                          ::  galaxy
      planets/(map @p planet)                           ::  star
      stars/(map @p star)                               ::  planet
  ==                                                    ::
++  invite                                              ::
  $:  who/mail                                          ::  who to send to
      pla/@ud                                           ::  planets to send
      sta/@ud                                           ::  stars to send
      wel/welcome                                       ::  welcome message
  ==                                                    ::
++  welcome                                             ::  welcome message
  $:  intro/tape                                        ::  in invite email
      hello/tape                                        ::  as talk message
  ==                                                    ::
++  reference                                           ::  affiliate credit
  (unit (each @p mail))                                 ::  ship or email
::                                                      ::
++  reference-rate  2                                   ::  star refs per star
++  stat                                                ::  external info
  $%  {$free $~}                                        ::  unallocated
      {$owned p/mail}                                   ::  granted
      {$split p/(map ship stat)}                        ::  all given ships
  ==                                                    ::
--                                                      ::
::                                                      ::  ::
::::                                                    ::  ::
  ::                                                    ::  ::
|%
++  part  {$womb $0 pith}                               ::  womb state
++  pith                                                ::  womb content
  $:  boss/(unit @p)                                    ::  outside master
      bureau/(map passcode balance)                     ::  active invitations
      office/property                                   ::  properties managed
      hotel/(map (each @p mail) client)                 ::  everyone we know
  ==                                                    ::
--                                                      ::
::                                                      ::  ::
::::                                                    ::  ::
  ::                                                    ::  ::
|%                                                      ::  arvo structures
++  card                                                ::
  $%  {$flog wire flog}                                 ::
      {$info wire @p @tas nori}                         ::  fs write (backup)
      :: {$wait $~}                                        :: delay acknowledgment
      {$diff gilt}                                      :: subscription response
      {$poke wire pear}                                 ::  app RPC
      {$next wire p/ring}                               ::  update private key
      {$tick wire p/@pG q/@p}                           ::  save ticket
      {$knew wire p/ship q/will}                        ::  learn will (old pki)
  ==                                                    ::
++  pear                                                ::
  $?  {{ship $gmail} {$email mail tape}}                :: send email
      {{ship $hood} {$womb-do-claim mail @p}}           ::  issue ship
  ==                                                    ::
++  gilt                                                :: scry result
  $%  {$ships (list ship)}                              ::
      {$womb-balance balance}                           ::
      {$womb-stat stat}                                 ::
      {$womb-stat-all (map ship stat)}                  ::
  ==
++  move  (pair bone card)                              ::  user-level move
--
|%
++  murn-by
  |*  {a/(map) b/$-(* (unit))}
  ^-  ?~(a !! (map _p.n.a _(need (b q.n.a))))
  %-  malt
  %+  murn  (~(tap by a))
  ?~  a  $~
  |=  _c=n.a  ^-  (unit _[p.n.a (need (b q.n.a))])
  =+  d=(b q.c)
  ?~(d ~ (some [p.c u.d]))
::
++  unsplit
  |=  a/(map ship (managed))  ^-  (list {ship *})
  %+  skim  (~(tap by a))
  |=({@ a/(managed)} ?=($~ a))
::
++  issuing
  |*  a/(map ship (managed))
  ^-  (list {ship _(need (divided *~(got by a)))})
  (sort (~(tap by (murn-by a divided))) lor)
::
++  issuing-under
  |*  {a/bloq b/ship c/(map @u (managed))}
  ^-  (list {ship _(need (divided *~(got by c)))})
  %+  turn  (sort (~(tap by (murn-by c divided))) lor)
  |*(d/{@u *} [(rep a b -.d ~) +.d])
::
++  cursor  (pair (unit ship) @u)
++  neis  |=(a/ship ^-(@u (rsh (dec (xeb (dec (xeb a)))) 1 a)))  ::  postfix
::
::  Create new foil of size
++  fo-init
  |=  a/bloq  ::  ^-  (foil *)
  [min=1 ctr=1 und=~ ove=~ max=(dec (bex (bex a))) box=~]
::
++  fo
  |_  (foil $@($~ *))
  ++  nth                                             ::  index
    |=  a/@u  ^-  (pair (unit @u) @u)
    ?:  (lth a ~(wyt in und))
      =+  out=(snag a (sort (~(tap in und)) lth))
      [(some out) 0]
    =.  a  (sub a ~(wyt in und))
    |-  ^-  {(unit @u) @u}
    ?:  =(ctr +(max))  [~ a]
    ?:  =(0 a)  [(some ctr) a]
    $(a (dec a), +<.nth new)
  ::
  +-  fin  +<                                         ::  abet
  ++  new                                             ::  alloc
    ?:  =(ctr +(max))  +<
    =.  ctr  +(ctr)
    ?.  (~(has in ove) ctr)  +<
    new(ove (~(del in ove) ctr))
  ::
  +-  get                                             ::  nullable
    |=  a/@p  ^+  ?~(box ~ q.n.box)
    (fall (~(get by box) (neis a)) ~)
  ::
  +-  put
    |*  {a/@u b/*}  ^+  fin           ::  b/_(~(got by box))
    ~|  put+[a fin]
    ?>  (fit a)
    =;  adj  adj(box (~(put by box) a b))
    ?:  (~(has in box) a)  fin
    ?:  =(ctr a)  new 
    ?:  (lth a ctr)
      ?.  (~(has in und) a)  fin
      fin(und (~(del in und) a))
    ?.  =(a ctr:new)    :: heuristic
      fin(ove (~(put in ove) a))
    =+  n=new(+< new)
    n(und (~(put in und.n) ctr))
  ::
  ++  fit  |=(a/@u &((lte min a) (lte a max)))        ::  in range
  ++  gud                                             ::  invariant
    ?&  (fit(max +(max)) ctr)
        (~(all in und) fit(max ctr))
        (~(all in ove) fit(min ctr))
        (~(all in box) |=({a/@u *} (fit a)))
        |-  ^-  ?
        ?:  =(min max)  &
        =-  &(- $(min +(min)))
        %+  gte  1              ::  at most one of
        ;:  add
          ?:(=(min ctr) 1 0)
          ?:((~(has in und) min) 1 0)
          ?:((~(has in ove) min) 1 0)
          ?:((~(has by box) min) 1 0)
        ==
    ==
  --
--
::                                                    ::  ::
::::                                                  ::  ::
  !:                                                  ::  ::
|=  {bowl part}                                       ::  main womb work
|_  moz/(list move)
++  abet                                              ::  resolve
  ^-  (quip move *part)
  [(flop moz) +>+<+]
::
++  emit  |=(card %_(+> moz [[ost +<] moz]))          ::  return card
++  emil                                              ::  return cards
  |=  (list card) 
  ^+  +>
  ?~(+< +> $(+< t.+<, +> (emit i.+<)))
::
::
++  take-n                                            ::  compute range
  |=  {{index/@u count/@u} get/$-(@u cursor)}
  ^-  (list ship)
  ?~  count  ~
  %+  biff  p:(get index)
  |=  a/ship  ^-  (list ship)
  [a ^$(index +(index), count (dec count))]
::
++  available                                         ::  enumerate free ships
  |=  all/(map ship (managed))  ^-  $-(@u cursor)
  =+  pur=(sort (turn (unsplit all) head) lth)
  =+  len=(lent pur)
  |=(a/@u ?:((gte a len) [~ (sub a len)] [(some (snag a pur)) a]))
::
:: foil cursor to ship cursor, using sized parent
++  prefix
  |=  {a/bloq b/@p {c/(unit @u) d/@u}}  ^-  cursor
  ?~  c  [c d]
  [(some (rep a b u.c ~)) d]
::
++  in-list                                           ::  distribute among options
  |*  {a/(list) b/@u}  ^+  [(snag *@ a) b]
  =+  c=(lent a)
  [(snag (mod b c) a) (div b c)]
::
::
++  shop-galaxies  (available galaxies.office)        ::  unassigned %czar
::
::  Stars can be either whole or children of galaxies
++  shop-stars                                        ::  unassigned %king
  |=  nth/@u  ^-  cursor
  =^  out  nth  %.(nth (available stars.office))
  ?^  out  [out nth]
  (shop-star nth (issuing galaxies.office))
::
++  shop-star                                         ::  star from galaxies
  |=  {nth/@u lax/(list {who/@p * * r/(foil star)})}  ^-  cursor
  ?:  =(~ lax)  [~ nth]
  =^  sel  nth  (in-list lax nth)
  (prefix 3 who.sel (~(nth fo r.sel) nth))
::
++  shop-planets                                      ::  unassigned %duke
  |=  nth/@u  ^-  cursor
  =^  out  nth  %.(nth (available planets.office))
  ?^  out  [out nth]
  =^  out  nth  (shop-planet nth (issuing stars.office))
  ?^  out  [out nth]
  (shop-planet-gal nth (issuing galaxies.office))
::
++  shop-planet                                       ::  planet from stars
  |=  {nth/@u sta/(list {who/@p * q/(foil planet)})}  ^-  cursor
  ?:  =(~ sta)  [~ nth]
  =^  sel  nth  (in-list sta nth)
  (prefix 4 who.sel (~(nth fo q.sel) nth))
::
++  shop-planet-gal                                   ::  planet from galaxies
  |=  {nth/@u lax/(list {who/@p * * r/(foil star)})}  ^-  cursor
  ?:  =(~ lax)  [~ nth]
  =^  sel  nth  (in-list lax nth)
  (shop-planet nth (issuing-under 3 who.sel box.r.sel))
::
++  peek-x-shop                                       ::  available ships
  |=  tyl/path  ^-  (unit (unit {$ships (list @p)}))
  =;  a   ~&  peek-x-shop+[tyl a]  a
  =;  res  (some (some [%ships res]))
  =+  [typ nth]=~|(bad-path+tyl (raid tyl typ=%tas nth=%ud ~))
  :: =.  nth  (mul 3 nth)
  ?+  typ  ~|(bad-type+typ !!)
    $galaxies  (take-n [nth 3] shop-galaxies)
    $planets   (take-n [nth 3] shop-planets)
    $stars     (take-n [nth 3] shop-stars)
  ==
::
++  get-managed-galaxy  ~(got by galaxies.office)     ::  office read
++  mod-managed-galaxy                                ::  office write
  |=  {who/@p mod/$-(galaxy galaxy)}  ^+  +>
  =+  gal=(mod (get-managed-galaxy who))
  +>.$(galaxies.office (~(put by galaxies.office) who gal))
::
++  get-managed-star                                  ::  office read
  |=  who/@p  ^-  star
  =+  (~(get by stars.office) who)
  ?^  -  u
  =+  gal=(get-managed-galaxy (sein who))
  ?.  ?=({$~ $& *} gal)  ~|(unavailable-star+(sein who) !!)
  (fall (~(get by box.r.p.u.gal) (neis who)) ~)
::
++  mod-managed-star                                  ::  office write
  |=  {who/@p mod/$-(star star)}  ^+  +>
  =+  sta=(mod (get-managed-star who))                ::  XX double traverse
  ?:  (~(has by stars.office) who)
    +>.$(stars.office (~(put by stars.office) who sta))
  %+  mod-managed-galaxy  (sein who)
  |=  gal/galaxy  ^-  galaxy
  ?>  ?=({$~ $& *} gal)
  gal(r.p.u (~(put fo r.p.u.gal) (neis who) sta))
::
++  get-managed-planet                                ::  office read
  |=  who/@p  ^-  planet
  =+  (~(get by planets.office) who)
  ?^  -  u
  ?:  (~(has by galaxies.office) (sein who))    
    =+  gal=(get-managed-galaxy (sein who))
    ?.  ?=({$~ $& *} gal)  ~|(unavailable-galaxy+(sein who) !!)
    (~(get fo q.p.u.gal) who)
  =+  sta=(get-managed-star (sein who))
  ?.  ?=({$~ $& *} sta)  ~|(unavailable-star+(sein who) !!)
  (~(get fo q.p.u.sta) who)
::
++  mod-managed-planet                                ::  office write
  |=  {who/@p mod/$-(planet planet)}  ^+  +>
  =+  pla=(mod (get-managed-planet who))              ::  XX double traverse
  ?:  (~(has by planets.office) who)
    +>.$(planets.office (~(put by planets.office) who pla))
  ?:  (~(has by galaxies.office) (sein who))    
    %+  mod-managed-galaxy  (sein who)
    |=  gal/galaxy  ^-  galaxy
    ?>  ?=({$~ $& *} gal)
    gal(q.p.u (~(put fo q.p.u.gal) (neis who) pla))
  %+  mod-managed-star  (sein who)
  |=  sta/star  ^-  star
  ?>  ?=({$~ $& *} sta)
  sta(q.p.u (~(put fo q.p.u.sta) (neis who) pla))
::
++  stat-any  |=(a/(managed _!!) `stat`?~(a [%free ~] [%owned p.u.a]))
++  stat-planet
  |=  {who/@p man/planet}  ^-  stat
  ?.  ?=({$~ $& ^} man)  (stat-any man)
  =+  pla=u:(divided man)
  :-  %split
  %-  malt
  %+  turn  (~(tap by box.p.pla))
  |=({a/@u b/moon} [(rep 5 who a ~) (stat-any b)])
::
++  stat-star
  |=  {who/@p man/star}  ^-  stat
  ?.  ?=({$~ $& ^} man)  (stat-any man)
  =+  sta=u:(divided man)
  :-  %split
  %-  malt
  %+  welp
    %+  turn  (~(tap by box.p.sta))
    |=({a/@u b/moon} [(rep 5 who a ~) (stat-any b)])
  %+  turn  (~(tap by box.q.sta))
  |=({a/@u b/planet} =+((rep 4 who a ~) [- (stat-planet - b)]))
::
++  stat-galaxy
  |=  {who/@p man/galaxy}  ^-  stat
  ?.  ?=({$~ $& ^} man)  (stat-any man)
  =+  gal=u:(divided man)
  :-  %split
  %-  malt
  ;:  welp
    %+  turn  (~(tap by box.p.gal))
    |=({a/@u b/moon} [(rep 5 who a ~) (stat-any b)])
  ::
    %+  turn  (~(tap by box.q.gal))
    |=({a/@u b/planet} =+((rep 4 who a ~) [- (stat-planet - b)]))
  ::
    %+  turn  (~(tap by box.r.gal))
    |=({a/@u b/star} =+((rep 3 who a ~) [- (stat-star - b)]))
  ==
::
++  stats-ship                                        ::  inspect ship
  |=  who/@p  ^-  (unit (unit {$womb-stat stat}))
  ?>  |(=(our src) =([~ src] boss))                   ::  privileged info
  ?-  (clan who)
    $pawn  !!
    $earl  !!
    $duke  ``womb-stat+(stat-planet who (get-managed-planet who))
    $king  ``womb-stat+(stat-star who (get-managed-star who))
    $czar  ``womb-stat+(stat-galaxy who (get-managed-galaxy who))
  ==
::
++  peek-x-stats                                      ::  inspect ship/system
  |=  tyl/path
  ?^  tyl
    (stats-ship ~|(bad-path+tyl (raid tyl who=%p ~)))
  ^-  (unit (unit {$womb-stat-all (map ship stat)}))
  :^  ~  ~  %womb-stat-all
  %-  ~(uni by (~(urn by planets.office) stat-planet))
  %-  ~(uni by (~(urn by stars.office) stat-star))
  (~(urn by galaxies.office) stat-galaxy)
::
++  peek-x-balance                                     ::  inspect invitation
  |=  tyl/path  ^-  (unit (unit {$womb-balance balance}))
  =+  pas=~|(bad-path+tyl (raid tyl pas=%p ~))
  %-  some
  %+  bind  (~(get by bureau) pas)
  |=(bal/balance [%womb-balance bal])
::
++  peer-scry-x
  |=  tyl/path
  =<  abet
  =+  gil=(peek-x tyl)
  ~|  tyl
  ?~  gil  ~|(%block-stub !!)
  ?~  u.gil  ~|(%bad-path !!)
  (emit %diff u.u.gil)
::
++  peek-x
  |=  tyl/path  ^-  (unit (unit gilt))
  ~|  peek+x+tyl
  ?~  tyl  ~
  ?+  -.tyl  ~
  ::  /shop/planets/@ud   (list @p)    up to 3 planets
  ::  /shop/stars/@ud     (list @p)    up to 3 stars
  ::  /shop/galaxies/@ud  (list @p)    up to 3 galaxies 
    $shop  (peek-x-shop +.tyl)
  ::  /stats                          general stats dump
  ::  /stats/@p                       what we know about @p
    $stats  (peek-x-stats +.tyl)
  ::  /balance/passcode                invitation status  
    $balance  (peek-x-balance +.tyl)
  ==
::
++  poke-manage                                       ::  add to property
  |=  a/(list ship)
  =<  abet
  ?>  |(=(our src) =([~ src] boss))                   ::  privileged
  |-
  ?~  a  .
  ?+      (clan i.a)  ~|(bad-size+(clan i.a) !!)
        $duke
    ?.  (~(has by stars.office) i.a)
      $(a t.a, stars.office (~(put by stars.office) i.a ~))
    ~|(already-managing+i.a !!)
  ::
        $king
    ?.  (~(has by planets.office) i.a)
      $(a t.a, planets.office (~(put by planets.office) i.a ~))
    ~|(already-managing+i.a !!)
  ::
        $czar
    ?.  (~(has by galaxies.office) i.a)
      $(a t.a, galaxies.office (~(put by galaxies.office) i.a ~))
    ~|(already-managing+i.a !!)
  ==
::
++  email
  |=  {wir/wire adr/mail msg/tape}  ^+  +>
  (emit %poke [%mail wir] [our %gmail] %email adr msg)
  ::~&([%email-stub adr msg] +>)
::
++  poke-invite                                       ::  create invitation
  |=  {ref/reference inv/invite}
  =<  abet
  =.  hotel
    ?~  ref  hotel
    ?~  sta.inv  hotel
    %+  ~(put by hotel)  u.ref
    =+  cli=(fall (~(get by hotel) u.ref) *client)
    cli(sta +(sta.cli))
  (invite-from ~ inv)
::
++  invite-from                                       ::  traced invitation
  |=  {hiz/(list mail) inv/invite}  ^+  +>
  ?>  |(=(our src) =([~ src] boss))                   ::  priveledged
  =+  pas=`passcode`(shaf %pass eny)
  =.  bureau
    :: ?<  (~(has by bureau) pas)                     :: somewhat unlikely
    (~(put by bureau) pas [pla.inv sta.inv who.inv hiz])
  (email /invite who.inv "{intro.wel.inv}: {<pas>}")
::
:: ++  coup-invite                                      ::  invite sent
::
++  poke-reinvite                                     ::  split invitation
  |=  {aut/passcode inv/invite}                       ::  further invite
  ?>  =(src src)                                      ::
  =<  abet
  =+  ~|(%bad-passcode bal=(~(got by bureau) aut))
  =.  stars.bal  (sub stars.bal sta.inv)
  =.  planets.bal  (sub planets.bal pla.inv)
  =.  bureau  (~(put by bureau) aut bal)
  (invite-from [owner.bal history.bal] inv)
::
++  poke-obey                                         ::  set/reset boss
  |=  who/(unit @p)
  =<  abet
  ?>  =(our src)                                      ::  me only
  .(boss who)
::
++  poke-save                                         ::  write backup
  |=  pax/path
  =<  abet
  (emit %info /backup [our (foal pax [%womb-part !>(`part`+:abet)])]) 
::
++  poke-rekey                                        ::  extend will
  |=  $~
  =<  abet
  ?>  |(=(our src) =([~ src] boss))                   ::  privileged
  ::  (emit /rekey %next sec:ex:(brew 128 (shas %next eny)))
  ~&(rekey-stub+sec:ex:(brew 128 (shas %next eny)) .)
::
++  poke-report                                       ::  report will
  |=  {her/@p wyl/will}                               ::
  =<  abet
  ?>  =(src src)                                      ::  self-authenticated
  (emit %knew /report her wyl)
::
++  use-reference
  |=  a/(each @p mail)  ^-  (unit _+>)
  ?.  (~(has by hotel) a)  ~
  =+  cli=(~(get by hotel) a)
  ?~  cli  ~
  ?.  (gte sta.u.cli reference-rate)  ~
  =.  sta.u.cli  (sub sta.u.cli reference-rate)
  `+>.$(hotel (~(put by hotel) a u.cli))
::
++  poke-do-claim                                     ::  issue child ticket
  |=  {who/mail her/@p}
  =<  abet
  ?>  =(our (sein her))
  ?>  |(=(our src) =([~ src] boss))                   ::  privileged
  =+  tik=.^(@p %a /(scot %p our)/tick/(scot %da now)/(scot %p her))
  :: =.  emit  (emit /tick %tick tik her)
  (email /ticket who "Ticket for {<her>}: {<`@pG`tik>}")
::
++  poke-claim                                        ::  claim plot, req ticket
  |=  {aut/passcode her/@p}
  =<  abet
  ?>  =(src src)
  =+  ~|(%bad-passcode bal=(~(got by bureau) aut))
  =;  claimed
    (emit.claimed %poke /tick [(sein her) %hood] [%womb-do-claim owner.bal her])
  ?+    (clan her)  ~|(bad-size+(clan her) !!)
      $king
    =;  all  (claim-star.all owner.bal her)
    =+  (use-reference &+src)
    ?^  -  u   :: prefer using references
    =+  (use-reference |+owner.bal)
    ?^  -  u
    =.  stars.bal  ~|(%no-stars (dec stars.bal))
    +>.$(bureau (~(put by bureau) aut bal))
  ::
      $duke
    =.  planets.bal  ~|(%no-planets (dec planets.bal))
    =.  bureau  (~(put by bureau) aut bal)
    (claim-planet owner.bal her)
  ==
::
++  claim-star                                        ::  register
  |=  {who/mail her/@p}  ^+  +>
  %+  mod-managed-star  her
  |=  a/star  ^-  star
  ?^  a  ~|(impure-star+[her a] !!)
  (some %| who)
::
++  claim-planet                                      ::  register
  |=  {who/mail her/@p}  ^+  +>
  =.  hotel
    %+  ~(put by hotel)  |+who
    =+  cli=(fall (~(get by hotel) |+who) *client)
    cli(has (~(put in has.cli) her))
  %+  mod-managed-planet  her
  |=  a/planet  ^-  planet
  ?^  a  ~|(impure-planet+[her a] !!)
  (some %| who)
::
++  poke-release                                      ::  release to subdivide
  |=  {gal/@ud sta/@ud}                               ::
  =<  abet  ^+  +>
  ?>  =(our src)                                      ::  privileged
  =.  +>
    ?~  gal  +>
    =+  all=(take-n [0 gal] shop-galaxies)
    ?.  (gth gal (lent all))
      (roll all release-galaxy)
    ~|(too-few-galaxies+[want=gal has=(lent all)] !!)
  ^+  +>
  ?~  sta  +>
  =+  all=(take-n [0 sta] shop-stars)
  ~&  got-stars+all
  ?.  (gth sta (lent all))
    (roll all release-star)
  ~|(too-few-stars+[want=sta has=(lent all)] !!)
::
++  release-galaxy                                    ::  subdivide %czar
  =+  [who=*@p res=.]
  |.  ^+  res
  %+  mod-managed-galaxy:res  who
  |=  gal/galaxy  ^-  galaxy
  ~&  release+who
  ?^  gal  ~|(already-used+who !!)
  (some %& (fo-init 5) (fo-init 4) (fo-init 3))
::
++  release-star                                      ::  subdivide %king
  =+  [who=*@p res=.]
  |.  ^+  res
  %+  mod-managed-star:res  who
  |=  sta/star  ^-  star
  ~&  release+who
  ?^  sta  ~|(already-used+[who u.sta] !!)
  (some %& (fo-init 4) (fo-init 3))
--