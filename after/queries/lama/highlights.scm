; highlights.scm

[
  "var"
  "fun"
  "public"
  "infix"
  "infixl"
  "infixr"
] @keyword.storage.type

[
  "at"
  "before"
  "after"
] @keyword.storage.modifier

[
  "while"
  "for"
  "do"
  "od"
] @keyword.control.repeat

[
  "if"
  "elif"
  "else"
  "fi"
] @keyword.control.conditional

[
  "skip"
] @keyword.control.return

[
  "case"
  "of"
  "esac"
] @keyword.control

[
  "import"
] @keyword.control.import

[
  "="
  "-"
  "|"
  ":"
  "@"
  "#"
  "->"
] @punctuation

[
  ";"
] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  "box"
  "val"
  "str"
  "array"
  "sexp"
  "true"
  "false"
] @constant.language

(COMMENT) @comment.block

(wildcardPattern) @variable.language

(DECIMAL) @constant.numeric.integer
(STRING) @string
(CHAR) @constant.char

((LIDENT) @function (#is-not? local))
((INFIX) @keyword.operator (#is-not? local))

(variableDefinitionItem (LIDENT) @variable)

(functionArguments (LIDENT) @variable.parameter)

(functionDefinition (LIDENT) @function)
(infixHead (INFIX) @keyword.operator)
