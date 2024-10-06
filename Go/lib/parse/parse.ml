(** Copyright 2024, Karim Shakirov, Alexei Dmitrievtsev *)

(** SPDX-License-Identifier: MIT *)


let is_keyword = function
  (* https://go.dev/ref/spec#Keywords *)
  | "break"
  | "case"
  | "chan"
  | "const"
  | "continue"
  | "default"
  | "defer"
  | "else"
  | "fallthrough"
  | "for"
  | "func"
  | "go"
  | "goto"
  | "if"
  | "import"
  | "interface"
  | "map"
  | "package"
  | "range"
  | "return"
  | "select"
  | "struct"
  | "switch"
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


