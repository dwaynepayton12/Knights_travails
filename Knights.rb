
class Board
    attr_reader :knight, :positions

    def initialize(knight_position)
        @rows = [1, 2, 3, 4, 5, 6, 7, 8]
        @columns = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
        @positions = []
        @rows.each{ |row| @columns.each{ |column| @positions << (position = (row.to_s << column.to_s)) }}
        @knight = Knight.new(knight_position)
    end

    def print_board
        column = 0
        @positions.reduce do |row, position|
            if row.class != Array
                row = [row]
            end
            if row.length == 1
                puts '  -------------------------------------'
            end
            if row.length == 7
                if position == self.knight.position
                    row.push("  ")
                else
                    row.push(position)
                end
                puts "  " + row.join(" | ")
                row = []
            else
                if position == self.knight.position
                    row.push("  ")
                else
                    row.push(position)
                end
    
            end
        end
        puts '  -------------------------------------'
    end

    def build_tree_and_find_path(start_node=Node.new(self.knight.position), queue=[], depth=0, end_position)
        
        start_node.children = find_children_and_discard(start_node)
        children_positions = start_node.children.map { |child| arr_to_position(child) }
        children_positions.each{ |child| queue << Node.new(child, start_node, depth+1)}
        if start_node.value == end_position
            puts "Found it: #{start_node.value}, depth: #{start_node.depth}"
            puts "Path is: "
            node = start_node
            path = []
            until node.parent == nil
                path.unshift(node.parent.value)
                node = node.parent
            end
            path
        else
            while queue.any?
                n = queue.shift
                return build_tree_and_find_path(n, queue, n.depth, end_position)
                
            end
        end
    end

    def position_to_arr(position)
        arr = []
        @rows.each do |row|
            if position[0] == row.to_s
                arr[0] = row.to_i
            end
        end
        @columns.each_with_index do |column, i|
            if position[1] == column.to_s
                arr[1] = i + 1
            end
        end
        arr
    end
    
    def arr_to_position(arr)
        position = ''
        @rows.each do |row|
            if arr[0] == row.to_i
                position[0] = row.to_s
            end
        end
        @columns.each_with_index do |column, i|
            if arr[1] == i + 1
                position[1] = column.to_s
            end
        end
        position
    end

                

    

    def find_children_and_discard(position=@knight.position)
        
        if position.class == Node
            position = position.value
        end
        start_array = position_to_arr(position)
        one=[1,2]
        two=[2,1]
        four=[-1,2]
        five=[-2,1]
        seven=[-1,-2]
        eight=[-2,-1]
        ten=[-2,1]
        eleven=[-1,2]
        knight_moves = [one, two, four, five, seven, eight, ten, eleven]
        children = []
        knight_moves.each_with_index do |move, i|
            new_arr = move.map.with_index{ |v, i| v + start_array[i]}
            unless new_arr.any?{ |arr| arr > 8 || arr < 1 }
                children << new_arr
            end
            
        end
        children 
    end
end

class Knight

    attr_accessor :position

    def initialize(position)
        @position = position
    end
    

end

class Node

    attr_accessor :value, :children, :parent, :depth

    def initialize(value, parent=nil, depth=0)
        @value = value
        @depth = depth
        @parent = parent
    end
end


board = Board.new("3a")
puts board.build_tree_and_find_path("7e")
puts "7e"
