(** Copyright 2024, Karim Shakirov, Alexei Dmitrievtsev *)

(** SPDX-License-Identifier: MIT *)

(** Data types *)
type type' =
  | Type_int (** Integer type: [int] *)
  | Type_string (** String type: [string] *)
  | Type_bool (** Boolean type: [bool] *)
  | Type_array of type' * size (** Array types such as [int[6]] *)
  | Type_func of type' list option * type' list option
  (** Function types such as [func()], [func(string) (bool, int)] *)
  | Type_chan (* TODO *)

and size = int

(** Constants, a.k.a. literals *)
type const =
  | Const_int of int (** Integer constants such as [0], [123] *)
  | Const_string of string (** Constant strings such as ["my_string"] *)
  | Const_bool of bool (** Boolean constants: [true] and [false] *)

(** identificator for a variable or a function *)
type ident = string

(** Expressions that can be assigned to a variable or put in "if" statement *)
type expr =
  | Expr_nil (** A value of an unitialized channel or function: [nil] *)
  | Expr_ident of ident (** An identificator for a variable *)
  | Expr_index of ident * expr
  (** An access to an array element by its index: [my_array[i]]*)
  | Expr_oper of oper (** Binary or unary operations such as [x + 5], [!x], [a >= 5] *)
  | Expr_call of ident * expr list (** function call such as [my_func(arg1, arg2)] *)
  | Expr_anon_func of (ident * type') list * type' list * stmt
  (** An anonymous function such as [func(a int, b int) int { return a + b }] *)

(** Binary or unary operations such as [x + 5], [!x], [a >= 5] *)
and oper =
  | Oper_bin of bin_oper (** Binary operations such as [a + b], [x || y] *)
  | Oper_unary of unary_oper (** Unary operations such as [!z], [-f] *)

(** Binary operations *)
and bin_oper =
  | Bin_sum of expr * expr (** Binary sum: [1 + 1] *)
  | Bin_multiply of expr * expr (** Binary multiplication: [a * 5] *)
  | Bin_subtract of expr * expr (** Binary subtraction: [func1(x) - func2(y)] *)
  | Bin_divide of expr * expr (** Binary divison: [7 / 3] *)
  | Bin_modulus of expr * expr (** Binary division by modulus: [123 % 10] *)
  | Bin_equal of expr * expr (** Binary check for equality: [result == 25] *)
  | Bin_not_equal of expr * expr (** Binary check for inequlity: [i != n] *)
  | Bin_greater of expr * expr (** Binary "greater than": [sum > minimum] *)
  | Bin_greater_equal of expr * expr (** Binary "greater than or equal": [b >= a] *)
  | Bin_less of expr * expr (** Binary "less than": [sum < maximum] *)
  | Bin_less_equal of expr * expr (** Binary "less than or equal": [a <= b] *)
  | Bin_and of expr * expr (** Binary "and": [ok && flag] *)
  | Bin_or of expr * expr (** Binary "or": [is_online || is_friend] *)

(** Unary operations *)
and unary_oper =
  | Unary_not of expr (** Unary negation: [!x] *)
  | Unary_plus of expr (** Unary plus: [+a] *)
  | Unary_minus of expr (** Unary minus: [-a]*)

(** Statement, a syntactic unit of imperative programming *)
and stmt =
  | Stmt_empty (** Empty statement, i. e. empty function body *)
  | Stmt_var_decl of ident list * type' option * expr list option
  (** Declaration of a variable inside of a function such as:
      [var array []int],
      [flag := true],
      [var a int = 5] *)
  | Stmt_assign of ident list * type' option * expr list
  (** Assignment to a variable such as [a = 3], [a, b = 4, 5] *)
  | Stmt_incr of ident (** An increment of a variable: [a++] *)
  | Stmt_decr of ident (** A deincrement of a variable: [a--] *)
  | Stmt_if of stmt option * expr * stmt * stmt option
  (** An if statement such as:
      [if a := 5; a >= 4 {
          do()
      } else {
          do_else()
      }] *)
  | Stmt_for of stmt option * expr option * stmt option * stmt
  (** A for statement such as:
      [for i := 0; i < n; i++ {
          do()
      }] *)
  | Stmt_range of expr option * expr option * expr * stmt
  (** For with range statement such as:
      [for i, elem := range array {
          check(elem)
      }] *)
  | Stmt_break (** Break statemnet: [break] *)
  | Stmt_continue (** Continue statement: [continue] *)
  | Stmt_return of expr option
  (** Return statement such as [return some_expr] or [return] *)
  | Stmt_defer of expr (** Defer statement such as [defer close_file()] *)
  | Stmt_block of stmt list (** Block of statements in curly braces *)
  | Stmt_go (* TODO *)

(** Top-level declarations *)
type top_decl =
  | Decl_var of var_decl
  | Decl_func of func_decl

(** Variable declarations outside of a function such as:
    [var my_int int = 5],
    [var my_func func() = func()],
    [var my_array []int = []int{1, 2, 3}] *)
and var_decl = ident * type' * expr option

(** Function declarations such as:
    [func main() {
        println("Hello, world!")
    }] *)
and func_decl = ident * (ident * type' option) list option * type' list option * stmt

(** The whole interpreted file, the root of the abstract syntax tree *)
type file = top_decl list
