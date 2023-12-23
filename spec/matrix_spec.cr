require "./spec_helper"

describe RayTracer::Matrix do
  # Scenario: Constructing and inspecting a 4x4 matrix
  # Given the following 4x4 matrix M:
  # |1     |2     |3     |4     |
  # | 5.5  | 6.5  | 7.5  | 8.5  |
  # | 9    | 10   | 11   | 12   |
  # | 13.5 | 14.5 | 15.5 | 16.5 |
  # Then M[0,0] = 1
  # And M[0,3] = 4
  # And M[1,0] = 5.5
  # And M[1,2] = 7.5
  # And M[2,2] = 11
  # And M[3,0] = 13.5
  # And M[3,2] = 15.5
  it "creates a matrix" do
    m = RayTracer::Matrix.new([
      [1, 2, 3, 4],
      [5.5, 6.5, 7.5, 8.5],
      [9, 10, 11, 12],
      [13.5, 14.5, 15.5, 16.5],
    ])
    m[0, 0].should eq(1)
    m[0, 3].should eq(4)
    m[1, 0].should eq(5.5)
    m[1, 2].should eq(7.5)
    m[2, 2].should eq(11)
    m[3, 0].should eq(13.5)
    m[3, 2].should eq(15.5)
  end

  # Scenario: A 2x2 matrix ought to be representable
  # Given the following 2x2 matrix M:
  # | -3 | 5 |
  # | 1 | -2 |
  # Then M[0,0] = -3
  # And M[0,1] = 5
  # And M[1,0] = 1
  # And M[1,1] = -2
  it "creates a 2x2 matrix" do
    m = RayTracer::Matrix.new([
      [-3, 5],
      [1, -2],
    ])
    m[0, 0].should eq(-3)
    m[0, 1].should eq(5)
    m[1, 0].should eq(1)
    m[1, 1].should eq(-2)
  end

  # Scenario: A 3x3 matrix ought to be representable
  # Given the following 3x3 matrix M:
  # |-3| 5| 0|
  # | 1|-2|-7|
  # |0|1|1|
  # Then M[0,0] = -3
  # And M[1,1] = -2
  # And M[2,2] = 1
  it "creates a 3x3 matrix" do
    m = RayTracer::Matrix.new([
      [-3, 5, 0],
      [1, -2, -7],
      [0, 1, 1],
    ])
    m[0, 0].should eq(-3)
    m[1, 1].should eq(-2)
    m[2, 2].should eq(1)
  end

  # Scenario: Matrix equality with identical matrices
  # Given the following matrix A:
  # |1|2|3|4|
  # |5|6|7|8|
  # |9|8|7|6|
  # |5|4|3|2|
  # And the following matrix B:
  # |1|2|3|4|
  # |5|6|7|8|
  # |9|8|7|6|
  # |5|4|3|2|
  # Then A = B
  it "does matrix equality" do
    a = RayTracer::Matrix.new([
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 8, 7, 6],
      [5, 4, 3, 2],
    ])
    b = RayTracer::Matrix.new([
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 8, 7, 6],
      [5, 4, 3, 2],
    ])
    (a == b).should be_true
  end

  # Scenario: Matrix equality with different matrices
  # Given the following matrix A:
  # |1|2|3|4|
  # |5|6|7|8|
  # |9|8|7|6|
  # |5|4|3|2|
  # And the following matrix B:
  # |2|3|4|5|
  # |6|7|8|9|
  # |8|7|6|5|
  # |4|3|2|1|
  # Then A != B
  it "does matrix inequality" do
    a = RayTracer::Matrix.new([
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 8, 7, 6],
      [5, 4, 3, 2],
    ])
    b = RayTracer::Matrix.new([
      [2, 3, 4, 5],
      [6, 7, 8, 9],
      [8, 7, 6, 5],
      [4, 3, 2, 1],
    ])
    (a == b).should be_false
    (a != b).should be_true
  end

  it "can return it's size" do
    a = RayTracer::Matrix.new([
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 8, 7, 6],
      [5, 4, 3, 2],
    ])
    a.size.should eq({rows: 4, cols: 4})
    a.rows.should eq(4)
    a.cols.should eq(4)
  end

  it "can return a row or a col" do
    a = RayTracer::Matrix.new([
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 8, 7, 6],
      [5, 4, 3, 2],
    ])
    a.row(1).should eq([5, 6, 7, 8])
    a.col(1).should eq([2, 6, 8, 4])
  end

  # Scenario: Multiplying two matrices
  # Given the following matrix A:
  # |1|2|3|4|
  # |5|6|7|8|
  # |9|8|7|6|
  # |5|4|3|2|
  # And the following matrix B:
  # |-2|1|2| 3|
  # | 3|2|1|-1|
  # | 4|3|6| 5|
  # | 1|2|7| 8|
  # Then A * B is the following 4x4 matrix:
  # |20| 22| 50| 48|
  # |44| 54|114|108|
  # |40| 58|110|102|
  # |16| 26| 46| 42|
  it "does matrix multiplication" do
    a = RayTracer::Matrix.new([
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 8, 7, 6],
      [5, 4, 3, 2],
    ])
    b = RayTracer::Matrix.new([
      [-2, 1, 2, 3],
      [3, 2, 1, -1],
      [4, 3, 6, 5],
      [1, 2, 7, 8],
    ])
    expected = RayTracer::Matrix.new([
      [20, 22, 50, 48],
      [44, 54, 114, 108],
      [40, 58, 110, 102],
      [16, 26, 46, 42],
    ])
    (a * b).should eq(expected)
  end

  it "can turn a tuple into a column matrix" do
    a = RayTracer::Matrix.new(RayTracer::Tuple.tuple(1, 2, 3, 4))
    expected = RayTracer::Matrix.new([
      [1],
      [2],
      [3],
      [4],
    ])
    a.should eq(expected)
  end

  it "can turn a tuple into a row matrix" do
    a = RayTracer::Matrix.new(RayTracer::Tuple.tuple(1, 2, 3, 4), column: false)
    expected = RayTracer::Matrix.new([
      [1, 2, 3, 4],
    ])
    a.should eq(expected)
  end

  # Scenario: A matrix multiplied by a tuple
  # Given the following matrix A:
  # |1|2|3|4|
  # |2|4|4|2|
  # |8|6|4|1|
  # |0|0|0|1|
  # And b ← tuple(1, 2, 3, 1)
  # Then A * b = tuple(18, 24, 33, 1)
  it "mutiples a matrix with a tuple" do
    a = RayTracer::Matrix.new([
      [1, 2, 3, 4],
      [2, 4, 4, 2],
      [8, 6, 4, 1],
      [0, 0, 0, 1],
    ])
    b = RayTracer::Tuple.tuple(1, 2, 3, 1)
    expected = RayTracer::Tuple.tuple(18, 24, 33, 1)
    (a * b).should eq(expected)
  end

  # Scenario: Multiplying a matrix by the identity matrix
  # Given the following matrix A:
  # |0|1| 2| 4|
  # |1|2| 4| 8|
  # |2|4| 8|16|
  # |4|8|16|32|
  # Then A * identity_matrix = A
  it "returns itself when multiplied with the idendity matrix" do
    a = RayTracer::Matrix.new([
      [0, 1, 2, 4],
      [1, 2, 4, 8],
      [2, 4, 8, 16],
      [4, 8, 16, 32],
    ])
    (a * RayTracer::Matrix::IDENTITY_4).should eq(a)
  end

  # Scenario: Multiplying the identity matrix by a tuple
  # Given a ← tuple(1, 2, 3, 4)
  # Then identity_matrix * a = a
  it "returns tupleself when multiplied with the idendity matrix" do
    a = RayTracer::Tuple.tuple(1, 2, 3, 4)
    (RayTracer::Matrix::IDENTITY_4 * a).should eq(a)
  end

  # Scenario: Transposing a matrix
  # Given the following matrix A:
  # |0|9|3|0|
  # |9|8|0|8|
  # |1|8|5|3|
  # |0|0|5|8|
  # Then transpose(A) is the following matrix:
  # |0|9|1|0|
  # |9|8|8|0|
  # |3|0|5|5|
  # |0|8|3|8|
  it "transposes" do
    a = RayTracer::Matrix.new([
      [0, 9, 3, 0],
      [9, 8, 0, 8],
      [1, 8, 5, 3],
      [0, 0, 5, 8],
    ])
    expected = RayTracer::Matrix.new([
      [0, 9, 1, 0],
      [9, 8, 8, 0],
      [3, 0, 5, 5],
      [0, 8, 3, 8],
    ])
    a.transpose.should eq(expected)
  end

  # Scenario: Transposing the identity matrix
  # Given A ← transpose(identity_matrix)
  # Then A = identity_matrix
  it "transposes identity" do
    RayTracer::Matrix::IDENTITY_4.transpose.should eq(RayTracer::Matrix::IDENTITY_4)
  end

  # Scenario: Calculating the determinant of a 2x2 matrix
  # Given the following 2x2 matrix A:
  # | 1|5|
  # |-3|2|
  # Then determinant(A) = 17
  it "calculates the determinant of a 2x2 matrix" do
    a = RayTracer::Matrix.new([
      [1, 5],
      [-3, 2],
    ])
    a.determinant.should eq(17)
  end

  # Scenario: A submatrix of a 3x3 matrix is a 2x2 matrix
  # Given the following 3x3 matrix A:
  # | 1|5| 0|
  # |-3|2| 7|
  # | 0|6|-3|
  # Then submatrix(A, 0, 2) is the following 2x2 matrix:
  # |-3|2|
  # | 0|6|
  it "gets the submatrix of a 3x3 matrix" do
    a = RayTracer::Matrix.new([
      [1, 5, 0],
      [-3, 2, 7],
      [0, 6, -3],
    ])
    expected = RayTracer::Matrix.new([
      [-3, 2],
      [0, 6],
    ])
    a.submatrix(0, 2).should eq(expected)
  end

  # Scenario: A submatrix of a 4x4 matrix is a 3x3 matrix
  # Given the following 4x4 matrix A:
  # |-6| 1| 1| 6|
  # |-8| 5| 8| 6|
  # |-1| 0| 8| 2|
  # |-7| 1|-1| 1|
  # Then submatrix(A, 2, 1) is the following 3x3 matrix:
  # |-6| 1|6|
  # |-8| 8|6|
  # |-7|-1|1|
  it "gets the submatrix of a 4x4 matrix" do
    a = RayTracer::Matrix.new([
      [-6, 1, 1, 6],
      [-8, 5, 8, 6],
      [-1, 0, 8, 2],
      [-7, 1, -1, 1],
    ])
    expected = RayTracer::Matrix.new([
      [-6, 1, 6],
      [-8, 8, 6],
      [-7, -1, 1],
    ])
    a.submatrix(2, 1).should eq(expected)
  end

  # Scenario: Calculating a minor of a 3x3 matrix
  # Given the following 3x3 matrix A:
  # |3| 5| 0|
  # |2|-1|-7|
  # |6|-1| 5|
  # And B ← submatrix(A, 1, 0)
  # Then determinant(B) = 25
  # And minor(A, 1, 0) = 25
  it "gets the determinant and minor of a 3x3 matrix" do
    a = RayTracer::Matrix.new([
      [3, 5, 0],
      [2, -1, -7],
      [6, -1, 5],
    ])
    b = a.submatrix(1, 0)
    b.det.should eq(25)
    a.minor(1, 0).should eq(25)
  end

  # Scenario: Calculating a cofactor of a 3x3 matrix
  # Given the following 3x3 matrix A:
  # | 3| 5| 0|
  # | 2|-1|-7|
  # | 6|-1| 5|
  # Then minor(A, 0, 0) = -12
  # And cofactor(A, 0, 0) = -12
  # And minor(A, 1, 0) = 25
  # And cofactor(A, 1, 0) = -25
  it "gets the minos and cofactors of a 3x3 matrix" do
    a = RayTracer::Matrix.new([
      [3, 5, 0],
      [2, -1, -7],
      [6, -1, 5],
    ])
    a.minor(0, 0).should eq(-12)
    a.cofactor(0, 0).should eq(-12)
    a.minor(1, 0).should eq(25)
    a.cofactor(1, 0).should eq(-25)
  end

  # Scenario: Calculating the determinant of a 3x3 matrix
  # Given the following 3x3 matrix A:
  # | 1|2| 6|
  # |-5|8|-4|
  # | 2|6| 4|
  # Then cofactor(A, 0, 0) = 56
  # And cofactor(A, 0, 1) = 12
  # And cofactor(A, 0, 2) = -46
  # And determinant(A) = -196
  it "calculates the determinant of a 3x3 matrix" do
    a = RayTracer::Matrix.new([
      [1, 2, 6],
      [-5, 8, -4],
      [2, 6, 4],
    ])
    a.cofactor(0, 0).should eq(56)
    a.cofactor(0, 1).should eq(12)
    a.cofactor(0, 2).should eq(-46)
    a.determinant.should eq(-196)
  end

  # Scenario: Calculating the determinant of a 4x4 matrix
  # Given the following 4x4 matrix A:
  # |-2|-8| 3| 5|
  # |-3| 1| 7| 3|
  # | 1| 2|-9| 6|
  # |-6| 7| 7|-9|
  # Then cofactor(A, 0, 0) = 690
  # And cofactor(A, 0, 1) = 447
  # And cofactor(A, 0, 2) = 210
  # And cofactor(A, 0, 3) = 51
  # And determinant(A) = -4071
  it "calculates the determinant of a 4x4 matrix" do
    a = RayTracer::Matrix.new([
      [-2, -8, 3, 5],
      [-3, 1, 7, 3],
      [1, 2, -9, 6],
      [-6, 7, 7, -9],
    ])
    a.cofactor(0, 0).should eq(690)
    a.cofactor(0, 1).should eq(447)
    a.cofactor(0, 2).should eq(210)
    a.cofactor(0, 3).should eq(51)
    a.determinant.should eq(-4071)
  end

  # Scenario: Testing an invertible matrix for invertibility
  # Given the following 4x4 matrix A:
  # | 6| 4| 4| 4|
  # | 5| 5| 7| 6|
  # | 4|-9| 3|-7|
  # | 9| 1| 7|-6|
  # Then determinant(A) = -2120
  # And A is invertible
  it "tests an invertible matrix for invertibility" do
    a = RayTracer::Matrix.new([
      [6, 4, 4, 4],
      [5, 5, 7, 6],
      [4, -9, 3, -7],
      [9, 1, 7, -6],
    ])
    a.determinant.should eq(-2120)
    a.invertable?.should be_true
  end

  # Scenario: Testing a noninvertible matrix for invertibility
  # Given the following 4x4 matrix A:
  # |-4| 2|-2|-3|
  # | 9| 6| 2| 6|
  # | 0|-5| 1|-5|
  # | 0| 0| 0| 0|
  # Then determinant(A) = 0 And
  # A is not invertible
  it "tests an invertible matrix for invertibility" do
    a = RayTracer::Matrix.new([
      [-4, 2, -2, -3],
      [9, 6, 2, 6],
      [0, -5, 1, -5],
      [0, 0, 0, 0],
    ])
    a.determinant.should eq(0)
    a.invertable?.should be_false
  end

  # Scenario: Calculating the inverse of a matrix
  # Given the following 4x4 matrix A:
  # |-5| 2| 6|-8|
  # | 1|-5| 1| 8|
  # | 7| 7|-6|-7|
  # | 1|-3| 7| 4|
  # And B ← inverse(A)
  # Then determinant(A) = 532
  # And cofactor(A, 2, 3) = -160
  # And B[3,2] = -160/532
  # And cofactor(A, 3, 2) = 105
  # And B[2,3] = 105/532
  # And B is the following 4x4 matrix:
  # |  0.21805 |  0.45113 |  0.24060 | -0.04511 |
  # | -0.80827 | -1.45677 | -0.44361 |  0.52068 |
  # | -0.07895 | -0.22368 | -0.05263 |  0.19737 |
  # | -0.52256 | -0.81391 | -0.30075 |  0.30639 |
  it "calculates the inverse of a matrix" do
    a = RayTracer::Matrix.new([
      [-5, 2, 6, -8],
      [1, -5, 1, 8],
      [7, 7, -6, -7],
      [1, -3, 7, 4],
    ])
    b = a.inverse
    a.determinant.should eq(532)
    a.cofactor(2, 3).should eq(-160)
    b[3, 2].should eq(-160/532)
    a.cofactor(3, 2).should eq(105)
    b[2, 3].should eq(105/532)
    expected = RayTracer::Matrix.new([
      [0.21805, 0.45113, 0.24060, -0.04511],
      [-0.80827, -1.45677, -0.44361, 0.52068],
      [-0.07895, -0.22368, -0.05263, 0.19737],
      [-0.52256, -0.81391, -0.30075, 0.30639],
    ])
    b.should be_close(expected, 0.000009)
  end

  # Scenario: Calculating the inverse of another matrix
  # Given the following 4x4 matrix A:
  # | 8|-5| 9| 2|
  # | 7| 5| 6| 1|
  # |-6| 0| 9| 6|
  # |-3| 0|-9|-4|
  # Then inverse(A) is the following 4x4 matrix:
  # | -0.15385 | -0.15385 | -0.28205 | -0.53846 |
  # | -0.07692 |  0.12308 |  0.02564 |  0.03077 |
  # |  0.35897 |  0.35897 |  0.43590 |  0.92308 |
  # | -0.69231 | -0.69231 | -0.76923 | -1.92308 |
  it "calculates the inverse of another matrix" do
    a = RayTracer::Matrix.new([
      [8, -5, 9, 2],
      [7, 5, 6, 1],
      [-6, 0, 9, 6],
      [-3, 0, -9, -4],
    ])
    expected = RayTracer::Matrix.new([
      [-0.15385, -0.15385, -0.28205, -0.53846],
      [-0.07692, 0.12308, 0.02564, 0.03077],
      [0.35897, 0.35897, 0.43590, 0.92308],
      [-0.69231, -0.69231, -0.76923, -1.92308],
    ])
    a.inverse.should be_close(expected, 0.000009)
  end

  # Scenario: Calculating the inverse of a third matrix
  # Given the following 4x4 matrix A:
  # | 9| 3| 0| 9|
  # |-5|-2|-6|-3|
  # |-4| 9| 6| 4|
  # |-7| 6| 6| 2|
  # Then inverse(A) is the following 4x4 matrix:
  # | -0.04074 | -0.07778 |  0.14444 | -0.22222 |
  # | -0.07778 |  0.03333 |  0.36667 | -0.33333 |
  # | -0.02901 | -0.14630 | -0.10926 |  0.12963 |
  # |  0.17778 |  0.06667 | -0.26667 |  0.33333 |
  it "calculates the inverse of a third matrix" do
    a = RayTracer::Matrix.new([
      [9, 3, 0, 9],
      [-5, -2, -6, -3],
      [-4, 9, 6, 4],
      [-7, 6, 6, 2],
    ])
    expected = RayTracer::Matrix.new([
      [-0.04074, -0.07778, 0.14444, -0.22222],
      [-0.07778, 0.03333, 0.36667, -0.33333],
      [-0.02901, -0.14630, -0.10926, 0.12963],
      [0.17778, 0.06667, -0.26667, 0.33333],
    ])
    a.inverse.should be_close(expected, 0.000009)
  end

  # Scenario: Multiplying a product by its inverse
  # Given the following 4x4 matrix A:
  # | 3|-9| 7| 3|
  # | 3|-8| 2|-9|
  # |-4| 4| 4| 1|
  # |-6| 5|-1| 1|
  # And the following 4x4 matrix B:
  # | 8| 2| 2| 2|
  # | 3|-1| 7| 0|
  # | 7| 0| 5| 4|
  # | 6|-2| 0| 5|
  # And C ← A * B
  # Then C * inverse(B) = A
  it "multiplying a product by its inverse" do
    a = RayTracer::Matrix.new([
      [3, -9, 7, 3],
      [3, -8, 2, -9],
      [-4, 4, 4, 1],
      [-6, 5, -1, 1],
    ])
    b = RayTracer::Matrix.new([
      [8, 2, 2, 2],
      [3, -1, 7, 0],
      [7, 0, 5, 4],
      [6, -2, 0, 5],
    ])
    c = a * b
    (c * b.inverse).should be_close(a, 0.000009)
  end

  # 1. What happens when you invert the identity matrix?
  it "invert the identity matrix" do
    RayTracer::Matrix::IDENTITY_4.inverse.should eq(RayTracer::Matrix::IDENTITY_4)
  end

  # 2. What do you get when you multiply a matrix by its inverse?
  it "multiply a matrix by its inverse" do
    a = RayTracer::Matrix.new([
      [3, -9, 7, 3],
      [3, -8, 2, -9],
      [-4, 4, 4, 1],
      [-6, 5, -1, 1],
    ])
    (a * a.inverse).should be_close(RayTracer::Matrix::IDENTITY_4, 0.000009)
  end

  # 3. Is there any difference between the inverse of the transpose of a matrix, and the transpose of the inverse?
  it "multiply a matrix by its inverse" do
    a = RayTracer::Matrix.new([
      [3, -9, 7, 3],
      [3, -8, 2, -9],
      [-4, 4, 4, 1],
      [-6, 5, -1, 1],
    ])
    a.inverse.transpose.should eq(a.transpose.inverse)
  end

  # 4. Remember how multiplying the identity matrix by a tuple gives you the tuple, unchanged?
  # Now, try changing any single element of the identity matrix to a different number, and then
  # multiplying it by a tuple. What happens to the tuple?
  it "returns tupleself when multiplied with the idendity matrix" do
    a = RayTracer::Tuple.tuple(1, 2, 3, 4)
    i = RayTracer::Matrix.new([
      [1, 0, 0, 0],
      [0, 2, 0, 0],
      [0, 0, 1, 0],
      [0, 0, 0, 1],
    ])
    (i * a).should eq(RayTracer::Tuple.tuple(1, 4, 3, 4))
  end
end
