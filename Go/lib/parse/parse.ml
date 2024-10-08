(** Copyright 2024, Karim Shakirov, Alexei Dmitrievtsev *)

(** SPDX-License-Identifier: MIT *)

open! Base
open Ast
open Angstrom

let is_keyword = function
  (* https://go.dev/ref/spec#Keywords *)
  | "break"
  | "case"
  | "chan"
  | "const"
  | "defer"
  | "else"
  | "for"
  | "func"
  | "go"
  | "if"
  | "import"
  | "interface"
  | "map"
  | "range"
  | "return"
  | "type"
  | "var" ->
      true
  | _ ->
      false
  ;;


let is_emptyspace = function ' ' | '\t' | '\n' | '\r' -> true | _ -> false

let is_digit = function '0' .. '9' -> true | _ -> false

let is_char = function
  | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' ->
      true
  | _ ->
      false

let parse_str parser str =
  Angstrom.parse_string ~consume:Angstrom.Consume.All parser str
  |> Result.ok_or_failwith

let parse_identifier =

  let is_first_char_valid = function
    | 'a' .. 'z' | 'A' .. 'Z' | '_' ->
        true
    | _ ->
        false
  in
  let* first_char = peek_char in
  match first_char with
  | Some chr when is_first_char_valid chr ->
      let* ident = take_while is_char in
      if is_keyword ident then fail "This is a keyword" else return ident
  | _ ->
      fail "Invalid identifier name"

let parse_type t =
    match t with
    | "int" ->
        return Type_int
    | "string" ->
        return Type_string
    | "bool" ->
        return Type_bool
    | _ ->
        fail @@ "Invalid type"
