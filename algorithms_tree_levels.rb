TreeNode = Struct.new(:value, :left, :right)
tree = TreeNode.new(0,
                      TreeNode.new(1, nil, 
                                          TreeNode.new(2, nil, nil) 
                                   ),
                      TreeNode.new(3, 
                                    TreeNode.new(4, nil, nil),
                                    TreeNode.new(5,
                                                    TreeNode.new(6, nil, nil), nil 
                                                ) 
                                    ) 
                    )

def tree_levels(tree, current_result=[], level=0)
    
    current_result[level] = [] unless current_result[level]
    
    current_result[level] << tree.value if tree.value
    
    tree_levels(tree.left, current_result, level+1) if tree.left
    tree_levels(tree.right, current_result, level+1) if tree.right
    
    return current_result
end

puts tree_levels(tree).inspect