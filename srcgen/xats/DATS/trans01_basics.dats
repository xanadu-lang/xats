(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Xanadu - Unleashing the Potential of Types!
** Copyright (C) 2018 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi
// Start Time: December, 2018
// Authoremail: gmhwxiATgmailDOTcom
//
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
#staload
UN = "prelude/SATS/unsafe.sats"
//
(* ****** ****** *)
//
#staload
"./../../xutl/SATS/mylibc.sats"
//
(* ****** ****** *)
//
#staload "./../SATS/xsymbol.sats"
#staload "./../SATS/lexing0.sats"
//
#staload "./../SATS/trans01.sats"
//
(* ****** ****** *)

local

fun
aux1
(rep: string): int =
auxmain
(10, string2ptr(rep), 0)
and
aux2
( bas: int
, rep: string): int =
auxmain
(bas, string2ptr(rep), 0)
and
auxmain
( b0: int
, p0: ptr
, r0: int): int =
(
let
val c0 =
$UN.ptr0_get<char>(p0)
in(* in-of-let *)
//
if
isdigit(c0)
then
(
  auxmain(b0, p0, r0)
) where
{
  val p0 = ptr_succ<char>(p0)
  val r0 = b0 * r0 + (c0 - '0')
}
else (r0) // end of [if]
//
end
) (* end of [auxmain] *)

in (* in-of-local *)

implement
token2sint(tok) =
(
case-
tok.node() of
//
| T_INT1(rep) => aux1(rep)
| T_INT2(bas, rep) => aux2(bas, rep)
| T_INT3(bas, rep, _) => aux2(bas, rep)
//
) (* end of [token2sint] *)

implement
token2dint(tok) =
(
case-
tok.node() of
//
| T_INT1(rep) => aux1(rep)
| T_INT2(bas, rep) => aux2(bas, rep)
| T_INT3(bas, rep, _) => aux2(bas, rep)
//
) (* end of [token2dint] *)

end // end of [local]

(* ****** ****** *)

implement
token2sbtf(tok) =
(
case-
tok.node() of
|
T_IDENT_alp(rep) =>
(
ifval
(c0 = 't', true, false)
) where
{
val p0 = string2ptr(rep)
val c0 = $UN.ptr0_get<char>(p0)
}
) (* end of [token2sbtf] *)

implement
token2dbtf(tok) = token2sbtf(tok)

(* ****** ****** *)

local

(*
T_CHAR_nil of (string) // ''
T_CHAR_char of (string) // '?'
T_CHAR_slash of (string) // '\...'
*)

in (* in-of-local *)

implement
token2schr(tok) =
(
case-
tok.node() of
|
T_CHAR_nil(rep) =>
(
  int2char0(0)
)
|
T_CHAR_char(rep) =>
(
  xatsopt_chrunq(rep)
)
|
T_CHAR_slash(rep) =>
(
  xatsopt_chrunq(rep)
)
) (* end of [token2schr] *)

implement
token2dchr(tok) = token2schr(tok)

end // end of [local]

(* ****** ****** *)
//
implement
token2sflt(tok) =
(
//
case-
tok.node() of
|
T_FLOAT1(rep) =>
(g0string2float(rep))
//
) (* end of [token2sflt] *)
//
implement
token2dflt(tok) = token2sflt(tok)
//
(* ****** ****** *)

local

(*
//
// utf-8 // for text
//
| T_STRING_quote of (string)
*)

in (* in-of-local *)

implement
token2sstr(tok) =
(
case-
tok.node() of
|
T_STRING_closed
  (rep) => xatsopt_strunq(rep)
)

implement
token2dstr(tok) = token2sstr(tok)

end // end of [local]

(* ****** ****** *)

implement
sortid_sym(tok) =
(
case-
tok.node() of
//
(*
| T_IDENT(nm) => $SYM.symbol_make(nm)
*)
//
| T_IDENT_alp(nm) => $SYM.symbol_make(nm)
| T_IDENT_sym(nm) => $SYM.symbol_make(nm)
//
) (* end of [sortid_sym] *)

(* ****** ****** *)

implement
gexpid_sym(tok) =
(
case-
tok.node() of
//
(*
| T_IDENT(nm) => $SYM.symbol_make(nm)
*)
//
| T_IDENT_alp(nm) => $SYM.symbol_make(nm)
| T_IDENT_sym(nm) => $SYM.symbol_make(nm)
//
) (* end of [gexpid_sym] *)

(* ****** ****** *)

implement
sargid_sym(tok) =
(
case-
tok.node() of
//
(*
| T_IDENT(nm) => $SYM.symbol_make(nm)
*)
//
| T_IDENT_alp(nm) => $SYM.symbol_make(nm)
| T_IDENT_alp(nm) => $SYM.symbol_make(nm)
//
) (* end of [sargid_sym] *)

(* ****** ****** *)

implement
sexpid_sym(tok) = let
//
(*
val () =
println!
("sexpid_sym: tok = ", tok)
*)
//
in
//
case-
tok.node() of
//
| T_IDENT(nm) => $SYM.symbol_make(nm)
//
| T_OP_sym(nm) => $SYM.symbol_make(nm)
//
| T_IDENT_alp(nm) => $SYM.symbol_make(nm)
| T_IDENT_sym(nm) => $SYM.symbol_make(nm)
//
end (* end of [sexpid_sym] *)

(* ****** ****** *)

implement
dexpid_sym(tok) =
(
case-
tok.node() of
//
| T_IDENT(nm) => $SYM.symbol_make(nm)
//
| T_OP_sym(nm) => $SYM.symbol_make(nm)
//
| T_IDENT_alp(nm) => $SYM.symbol_make(nm)
| T_IDENT_sym(nm) => $SYM.symbol_make(nm)
| T_IDENT_srp(nm) => $SYM.symbol_make(nm)
| T_IDENT_dlr(nm) => $SYM.symbol_make(nm)
//
) (* end of [dexpid_sym] *)

(* ****** ****** *)

implement
strnormize(cs) = let
//
vtypedef
charlst = List0_vt(char)
//
fun
isnm
(p0: ptr): bool =
let
val c0 =
$UN.ptr0_get<char>(p0)
in
if
iseqz(c0)
then true
else
(
ifcase
| c0 = '\\' =>
  let
  val p0 =
  ptr_succ<char>(p0)
  val c1 =
  $UN.ptr0_get<char>(p0)
  in
    if
    (
    c1 = '\n'
    )
    then false
    else
    (
    if
    iseqz(c1)
    then true
    else isnm(ptr_succ<char>(p0))
    )
  end
| _ (* else *) => isnm(ptr_succ<char>(p0))
)
end
//
fun
norm
(
cs: string
) : string =
(
strnptr2string
(
string_make_rlist_vt
(
$UN.castvwtp0
{List0_vt(charNZ)}
(loop1(p0, list_vt_nil()))
)
)
) where
{
//
val p0 = string2ptr(cs)
//
fnx
loop1
( p0: ptr
, r0: charlst): charlst =
let
  val c0 = $UN.ptr0_get<char>(p0)
in
if
iseqz(c0)
then (r0)
else
loop2(ptr_succ<char>(p0), c0, r0)
end
and
loop2
( p0: ptr
, c0: char
, r0: charlst): charlst =
(
if
(c0 = '\\')
then
let
val c1 =
$UN.ptr0_get<char>(p0)
in
if
iseqz(c1)
then list_vt_cons(c0, r0)
else
(
  if
  (c1 = '\n')
  then
  (
  loop1(ptr_succ<char>(p0), r0)
  )
  else
  let
  val r0 = list_vt_cons(c0, r0)
  val r0 = list_vt_cons(c1, r0)
  in
  loop1(ptr_succ<char>(p0), r0)
  end
) (* end of [else] *)
end // end of [then]
else
(
  loop1(p0, list_vt_cons(c0, r0))
) (* end of [else] *)
)
} (* end of [norm] *)
//
in
(
if isnm(string2ptr(cs)) then cs else norm(cs)
)
end // end of [string_normlize]

(* ****** ****** *)

(* end of [xats_trans01_basics.dats] *)
