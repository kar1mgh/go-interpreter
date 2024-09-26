(** Copyright 2024, Karim Shakirov, Alexei Dmitrievtsev  *)

(** SPDX-License-Identifier: MIT *)

type type' =
  | Type_int
  | Type_string
  | Type_bool
  | Type_array of type' * size
  | Type_func of type' list option * type' list option
  | Type_chan (* TODO *)

and size = int

type const =
  | Const_int of int (** 356 *)
  | Const_float of float (** -37.65 *)
  | Const_string of string (** "my_string" *)
  | Const_bool of bool (** true or false *)

type ident = string (** identificator for a variable or a function *)

type expr =
  | Expr_nil (** nil *)
  | Expr_ident of ident (** identificator for a variable *)
  | Expr_index of ident * expr (** array[i] *) 
  | Expr_oper of oper 
  | Expr_call of ident * expr list (** function call such as my_func(arg1, arg2) *)

and oper =
  | Op_sum of expr * expr
  | Op_multiply of expr * expr
  | Op_minus of expr * expr
  | Op_divide of expr * expr
  | Op_modulus of expr * expr
  | Op_equal of expr * expr
  | Op_not_equal of expr * expr
  | Op_greater of expr * expr
  | Op_greater_equal of expr * expr
  | Op_less of expr * expr
  | Op_less_equal of expr * expr
  | Op_and of expr * expr
  | Op_or of expr * expr
  | Op_not of expr

type stmt =
  | Stmt_var_decl of type' option * ident list * expr list option
  | Stmt_assign of ident list * type' option * expr list
  | Stmt_incr of ident
  | Stmt_decr of ident
  | Stmt_if of stmt option * expr * stmt * stmt option 
  | Stmt_for of stmt option * expr option * stmt option * stmt
  | Stmt_range of expr option * expr option * expr * stmt
  | Stmt_break
  | Stmt_continue
  | Stmt_return of expr
  | Stmt_defer of expr
  | Stmt_recover
  | Stmt_panic
  | Stmt_block of stmt list


(** пишем комменты как в компиляторе окамля*)
