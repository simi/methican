describe('Methic', function(){
  it('number', function() {
    var result = Methic.parse('10').eval({});
    expect(result).toBe(10);
  });

  it('variable', function() {
    var result = Methic.parse('x').eval({x: 10});
    expect(result).toBe(10);

    result = Methic.parse('w1.ryba').eval({"w1.ryba": 10});
    expect(result).toBe(10);
  });
  it('subtraction', function() {
    var result = Methic.parse('10 - 4').eval();
    expect(result).toBe(6);
  });

  it('addition', function() {
    var result = Methic.parse('10 + 4').eval();
    expect(result).toBe(14);
  });

  it('multiplication', function() {
    var result = Methic.parse('10 * 4').eval();
    expect(result).toBe(40);
  });

  it('division', function() {
    var result = Methic.parse('10 / 4').eval();
    expect(result).toBe(2.5);

  });
  it('order of operations', function() {
    var result = Methic.parse('1 + 2 * 3 + 4').eval();
    expect(result).toBe(11);
  });

  it('left to right', function() {
    var result = Methic.parse('5 - 2 - 1').eval();
    expect(result).toBe(2);
  });

  it('replace variables', function() {
    var result = Methic.parse('x + 5 - y').eval({x: 10, y: 20});
    expect(result).toBe(-5);
  });

  it('parenthesses', function() {
    var result = Methic.parse('(x + 5) * (y - 5)').eval({x: 10, y: 20});
    expect(result).toBe(15*15);
  });
});
