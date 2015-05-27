#
# Extend String class and add splitup method
#
class String
  def splitup(prefix=nil)
    parts = []
    if size <= 4
      parts << [prefix,self].compact * ","
    end
    (1..([size,4].min)).each do |p|
      next if p >= size
      parts << slice(p..-1).splitup([prefix,slice(0,p)].compact * ",")
    end
    parts
  end
end


#
# find_possible_combinations function realization
#
def find_possible_combinations(dictionary, target)
    result = []
    res = target.splitup.flatten.sort_by {|x| [-x.size,x]}
    res.each do |search_value|
        search_keys = search_value.split(",")
        result << search_value if search_keys.all? { |val| dictionary.include?(val) }
    end
    
   return result.map{ |val| val.gsub(",", " ")}.reverse
end

#
# Call our function and get result
#
dictionary = ['a', 'b', 'c', 'ab', 'abc']
target = 'aabcx'
puts find_possible_combinations(dictionary, target).inspect