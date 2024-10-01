(** Copyright 2024, Karim Shakirov, Alexei Dmitrievtsev *)

(** SPDX-License-Identifier: MIT *)

(** Data types *)
type type' =
  | Type_int (** Integer type: [int] *)
  | Type_string (** String type: [string] *)
  | Type_bool (** Boolean type: [bool] *)
  | Type_array of type' * size (** Array types such as [int[6]], [string[0]] *)
  | Type_func of type' list option * type' list option
  (** Function types such as [func()], [func(string) (bool, int)] *)
  | Type_chan of type' (** Channel type [chan int] *)
[@@deriving show { with_path = false }]

and size = int [@@deriving show { with_path = false }]

(** Constants, a.k.a. literals *)
type const =
  | Const_int of int (** Integer constants such as [0], [123] *)
  | Const_string of string (** Constant strings such as ["my_string"] *)
  | Const_bool of bool (** Boolean constants: [true] and [false] *)
[@@deriving show { with_path = false }]

(** identificator for a variable or a function *)
type ident = string [@@deriving show { with_path = false }]

(** Expressions that can be assigned to a variable or put in "if" statement *)
type expr =
  | Expr_nil (** A value of an unitialized channel or function: [nil] *)
  | Expr_const of const (** Constants such as [5], ["hi"], [false] *)
  | Expr_ident of ident (** An identificator for a variable such as [x] *)
  | Expr_index of expr * expr
  (** An access to an array element by its index such as: [my_array[i]], [get_array(1)[0]]*)
  | Expr_bin_oper of bin_oper * expr * expr
  (** Binary operations such as [a + b], [x || y] *)
  | Expr_un_oper of unary_oper * expr (** Unary operations such as [!z], [-f] *)
  | Expr_anon_func of (ident * type' option) list option * type' list option * stmt
  (** An anonymous function such as [func() {}], [func(a int, b int) int { return a + b }] *)
  | Expr_call of func_modifier option * expr * expr list option
  (** function calls such as:
      [my_func(arg1, arg2)],
      [c()()()],
      [func() { println("hello") }()] *)
[@@deriving show { with_path = false }]

(** Expr_call modifiers *)
and func_modifier =
  | Mod_defer (** Defer modifier: [defer func()] *)
  | Mod_go (** Goroutine modifier: [go func(ch chan<- bool)] *)

(** Binary operations *)
and bin_oper =
  | Bin_sum (** Binary sum: [1 + 1] *)
  | Bin_multiply (** Binary multiplication: [a * 5] *)
  | Bin_subtract (** Binary subtraction: [func1(x) - func2(y)] *)
  | Bin_divide (** Binary divison: [7 / 3] *)
  | Bin_modulus (** Binary division by modulus: [123 % 10] *)
  | Bin_equal (** Binary check for equality: [result == 25] *)
  | Bin_not_equal (** Binary check for inequlity: [i != n] *)
  | Bin_greater (** Binary "greater than": [sum > minimum] *)
  | Bin_greater_equal (** Binary "greater than or equal": [b >= a] *)
  | Bin_less (** Binary "less than": [sum < maximum] *)
  | Bin_less_equal (** Binary "less than or equal": [a <= b] *)
  | Bin_and (** Binary "and": [ok && flag] *)
  | Bin_or (** Binary "or": [is_online || is_friend] *)
[@@deriving show { with_path = false }]

(** Unary operations *)
and unary_oper =
  | Unary_not (** Unary negation: [!x] *)
  | Unary_plus (** Unary plus: [+a] *)
  | Unary_minus (** Unary minus: [-a]*)
[@@deriving show { with_path = false }]

(** Statement, a syntactic unit of imperative programming *)
and stmt =
  | Stmt_empty (** Empty statement, i. e. empty function body *)
  | Stmt_var_decl of ident list * type' option * expr list option
  (** Declaration of a variable inside of a function such as:
      [var array []int],
      [flag := true],
      [var a int = 5] *)
  | Stmt_assign of ident list * expr list
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
  | Stmt_range of ident * ident option * ident * stmt
  (** For with range statement such as:
      [for i, elem := range array {
          check(elem)
      }] *)
  | Stmt_break (** Break statemnet: [break] *)
  | Stmt_continue (** Continue statement: [continue] *)
  | Stmt_return of expr option
  (** Return statement such as [return some_expr] or [return] *)
  | Stmt_block of stmt list (** Block of statements in curly braces *)
  | Stmt_call of func_modifier option * expr * expr list option
  (** The same as Expr_call in expr type *)
  | Stmt_channel_send of ident * expr (** Channel send operation [c <- true] *)
  | Stmt_channel_recieve of ident * expr (** Channel recieve operation [z := <-c] *)
[@@deriving show { with_path = false }]

(** Top-level declarations *)
type top_decl =
  | Decl_var of var_decl
  | Decl_func of func_decl
[@@deriving show { with_path = false }]

(** Variable declarations outside of a function such as:
    [var my_int int = 5],
    [var my_func = func() {}],
    [var my_array = [3]int{1, 2, 3}] *)
and var_decl =
  { var_name : ident (** variable name *)
  ; var_type : type' option (** variable data type *)
  ; init : expr option (** variable initializer, optional *)
  }
[@@deriving show { with_path = false }]

(** Function declarations such as:
    [func sum_and_diff(a, b int) (sum, diff int) {
      sum = a + b
      diff = a - b
      return
    }] *)
and func_decl =
  { func_name : ident (** function name *)
  ; args : (ident * type' option) list option (** arguments *)
  ; return_types : (ident option * type' option) list option
  (** return types, optional var names *)
  ; body : stmt (** function body *)
  }
[@@deriving show { with_path = false }]

(** The whole interpreted file, the root of the abstract syntax tree *)
type file = top_decl list [@@deriving show { with_path = false }]
