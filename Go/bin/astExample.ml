open Ast

let factorial_ast : func_decl =
  ( "factorial" (* function identificator *)
  , Some [ "n", Some Type_int ] (* arguments *)
  , Some [ Type_int ] (* return type *)
  , Stmt_block
      (* body *)
      [ Stmt_if
          (* if statement *)
          ( None (* initialization *)
          , Expr_oper (Oper_bin (Bin_equal (Expr_ident "n", Expr_const (Const_int 0))))
            (* condition *)
          , Stmt_return (Some (Expr_const (Const_int 1))) (* if body *)
          , Some
              (* else body *)
              (Stmt_return
                 (Some
                    (Expr_oper
                       (Oper_bin
                          (Bin_multiply
                             ( Expr_ident "n"
                             , Expr_call
                                 (* function call *)
                                 ( "factorial" (* function identificator *)
                                 , [ Expr_oper
                                       (* arguments *)
                                       (Oper_bin
                                          (Bin_subtract
                                             (Expr_ident "n", Expr_const (Const_int 1))))
                                   ] ) )))))) )
      ] )
;;
