var types = {
  BinaryOperation: {
    "eval": function(env) {
      var result = this.head.eval(env);
      this.tail.elements.forEach(function(element)  {
        result = element.operator.apply(result, element.operand.eval(env));
      });
      return result;
    }
  },
  PrimaryNode: {
    "eval": function(env) {
      return this.expression.eval(env);
    }
  },
  NumberNode: {
    "eval": function() {
      return parseFloat(this.text);
    }
  },
  TextNode: {
    "eval": function(env) {
      return env[this.text];
    }
  },
  AdditiveOpNode: {
    "apply": function(left, right) {
      if(this.text == "+") {
        return left + right;
      } else if (this.text == "-") {
        return left - right;
      }
    }
  },
  MultitiveOpNode: {
    "apply": function(left, right) {
      if(this.text == "*") {
        return left * right;
      } else if (this.text == "/") {
        return left / right;
      }
    }
  }
};

var Methic = {
  parse: function(expression) {
    var result = MethicParser.parse(expression, {types: types});
    return result;
  }
};
