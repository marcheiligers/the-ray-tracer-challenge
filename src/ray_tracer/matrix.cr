module RayTracer
  class Matrix
    include Tuple
    extend Tuple

    @vals : Array(Array(Float64))

    def self.identity(size)
      data = Array(Array(Float64)).new(size) do |row|
        Array(Float64).new(size) do |col|
          row == col ? 1_f64 : 0_f64
        end
      end
      new(data)
    end

    IDENTITY_4 = identity(4)

    def self.translation(x, y, z)
      temp = [x, y, z, 1]
      data = Array(Array(Float64)).new(4) do |row|
        Array(Float64).new(4) do |col|
          if col == 3
            temp[row].to_f64
          else
            row == col ? 1_f64 : 0_f64
          end
        end
      end
      new(data)
    end

    def self.scaling(x, y, z)
      temp = [x, y, z, 1]
      data = Array(Array(Float64)).new(4) do |row|
        Array(Float64).new(4) do |col|
          row == col ? temp[col].to_f64 : 0_f64
        end
      end
      new(data)
    end

    def self.rotation_x(r)
      new([
        [1_f64, 0_f64, 0_f64, 0_f64],
        [0_f64, Math.cos(r), -Math.sin(r), 0_f64],
        [0_f64, Math.sin(r), Math.cos(r), 0_f64],
        [0_f64, 0_f64, 0_f64, 1_f64],
      ])
    end

    def self.rotation_y(r)
      new([
        [Math.cos(r), 0_f64, Math.sin(r), 0_f64],
        [0_f64, 1_f64, 0_f64, 0_f64],
        [-Math.sin(r), 0_f64, Math.cos(r), 0_f64],
        [0_f64, 0_f64, 0_f64, 1_f64],
      ])
    end

    def self.rotation_z(r)
      new([
        [Math.cos(r), -Math.sin(r), 0_f64, 0_f64],
        [Math.sin(r), Math.cos(r), 0_f64, 0_f64],
        [0_f64, 0_f64, 1_f64, 0_f64],
        [0_f64, 0_f64, 0_f64, 1_f64],
      ])
    end

    def self.shearing(x_y, x_z, y_x, y_z, z_x, z_y)
      new([
        [1_f64, x_y.to_f64, x_z.to_f64, 0_f64],
        [y_x.to_f64, 1_f64, y_z.to_f64, 0_f64],
        [z_x.to_f64, z_y.to_f64, 1_f64, 0_f64],
        [0_f64, 0_f64, 0_f64, 1_f64],
      ])
    end

    def self.view_transform(from : TUPLE, to : TUPLE, up : TUPLE)
      raise "from should be a Point" unless point?(from)
      raise "to should be a Point" unless point?(to)
      raise "up should be a Vector" unless vector?(up)

      forward = normalize(to - from)
      upn = normalize(up)
      left = cross(forward, upn)
      true_up = cross(left, forward)
      orientation = Matrix.new([
        [left.x, left.y, left.z, 0_f64],
        [true_up.x, true_up.y, true_up.z, 0_f64],
        [-forward.x, -forward.y, -forward.z, 0_f64],
        [0_f64, 0_f64, 0_f64, 1_f64],
      ])
      orientation * translation(-from.x, -from.y, -from.z)
    end

    def initialize(vals : Array(Array(Float64) | Array(Int32)))
      raise "Unequal row lengths" unless vals[1..-1].all? { |r| r.size == vals[0].size }

      @vals = vals.map { |r| r.map { |v| v.to_f64 } }
    end

    def initialize(tuple : Tuple::TUPLE, column = true)
      if column
        @vals = tuple.values.map { |v| [v.to_f64] }.to_a
      else
        @vals = [tuple.values.map { |v| v.to_f64 }.to_a]
      end
    end

    def [](row, col)
      @vals[row][col]
    end

    def ==(other)
      @vals.each.with_index do |row, y|
        row.each.with_index do |n, x|
          return false unless n == other[y, x]
        end
      end

      true
    end

    def to_s(io : IO)
      io.print @vals
    end

    def size
      {rows: rows, cols: cols}
    end

    def rows
      @vals.size
    end

    def cols
      @vals[0].size
    end

    def row(num)
      @vals[num]
    end

    def col(num)
      size[:rows].times.map { |c| @vals[c][num] }.to_a
    end

    def *(other : Matrix)
      data = rows.times.map do |r|
        other.cols.times.map do |c|
          row = row(r)
          col = other.col(c)
          row.zip(col).map { |a, b| a * b }.sum
        end.to_a
      end.to_a

      Matrix.new(data)
    end

    def *(tuple : Tuple::TUPLE)
      Tuple.tuple((self * Matrix.new(tuple)).col(0))
    end

    def transpose
      Matrix.new(cols.times.map { |c| col(c) }.to_a)
    end

    def determinant
      det
    end

    def det
      if rows == 2 && cols == 2
        self[0, 0] * self[1, 1] - self[1, 0] * self[0, 1]
      else
        index = -1
        row(0).sum(0_f64) { |val| val * cofactor(0, index += 1) }
      end
    end

    def submatrix(row, col)
      row_nums = (0...rows).to_a.tap { |r| r.delete_at(row) }
      Matrix.new(row_nums.map { |r| row(r).dup.tap { |r| r.delete_at(col) } })
    end

    def minor(row, col)
      submatrix(row, col).det
    end

    def cofactor(row, col)
      d = minor(row, col)
      (row + col).odd? ? -d : d
    end

    def invertable?
      !det.zero?
    end

    def inverse
      d = det
      Matrix.new(
        rows.times.map do |r|
          cols.times.map do |c|
            cofactor(c, r) / d
          end.to_a
        end.to_a
      )
    end

    # Fluent transforms
    def translation(x, y, z)
      self * self.class.translation(x, y, z)
    end

    def scaling(x, y, z)
      self * self.class.scaling(x, y, z)
    end

    def rotation_x(r)
      self * self.class.rotation_x(r)
    end

    def rotation_y(r)
      self * self.class.rotation_y(r)
    end

    def rotation_z(r)
      self * self.class.rotation_z(r)
    end

    def shearing(x_y, x_z, y_x, y_z, z_x, z_y)
      self * self.class.shearing(x_y, x_z, y_x, y_z, z_x, z_y)
    end
  end
end
