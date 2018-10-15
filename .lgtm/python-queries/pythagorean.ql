/**
 * @name Pythagorean calculation with sub-optimal numerics
 * @description Calculating the length of the hypotenuse using the standard formula may lead to overflow.
 * @kind problem
 * @tags accuracy
 * @problem.severity warning
 * @sub-severity low
 * @precision high
 * @id py/pythagorean
 */
import python

predicate squarePow(BinaryExpr e) {
  e.getOp() instanceof Pow and e.getRight().(IntegerLiteral).getN() = "2"
}

predicate squareMul(BinaryExpr e) {
  e.getOp() instanceof Mult and e.getRight().(Name).getId() = e.getLeft().(Name).getId()
}

/** The expression calculates the square of a sub expression */
predicate square(Expr e) {
  squarePow(e) or squareMul(e)
}

from Call c, BinaryExpr s
where
  c.getFunc().toString() = "sqrt" and
  c.getArg(0) = s and
  s.getOp() instanceof Add and
  square(s.getLeft()) and square(s.getRight())
select
  c, "Pythagorean calculation with sub-optimal numerics, hypot() should be used instead"