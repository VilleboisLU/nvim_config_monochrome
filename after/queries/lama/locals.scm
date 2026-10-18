; locals.scm

(functionDefinition) @local.scope
(scopeExpression) @local.scope

(variableDefinitionItem (LIDENT) @local.definition)
(functionArguments) @local.definition
(functionDefinition (LIDENT) @local.definition)
(infixHead (INFIX) @local.definition)

(LIDENT) @local.reference
(INFIX) @local.reference
