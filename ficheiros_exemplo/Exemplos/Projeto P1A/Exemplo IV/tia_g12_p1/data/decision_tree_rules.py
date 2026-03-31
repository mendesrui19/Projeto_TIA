import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeClassifier, plot_tree
import matplotlib.pyplot as plt

# Load the dataset
data = pd.read_csv('manchester_triage_dataset.csv')

# Split features and target
X = data.drop('target', axis=1)
y = data['target']

# Train decision tree
dt = DecisionTreeClassifier(max_depth=4, random_state=42)
dt.fit(X, y)

# Function to extract rules
def get_rules(tree, feature_names, class_names):
    tree_ = tree.tree_
    feature_name = [
        feature_names[i] if i != -2
        else "undefined!"
        for i in tree_.feature
    ]

    paths = []
    path = []
    
    def recurse(node, path, paths):
        if tree_.feature[node] != -2:
            name = feature_name[node]
            threshold = tree_.threshold[node]
            
            # Left path (<=)
            path_left = path + [[name, "<=", threshold]]
            recurse(tree_.children_left[node], path_left, paths)
            
            # Right path (>)
            path_right = path + [[name, ">", threshold]]
            recurse(tree_.children_right[node], path_right, paths)
        else:
            path_end = path + [[class_names[np.argmax(tree_.value[node][0])], "prediction", np.max(tree_.value[node][0])/sum(tree_.value[node][0])]]
            paths.append(path_end)
            
    recurse(0, path, paths)
    
    # Format rules
    rules = []
    for path in paths:
        rule = "IF "
        for i, condition in enumerate(path[:-1]):
            if i > 0:
                rule += " AND "
            if condition[1] == "<=":
                rule += f"{condition[0]} = FALSE"
            else:
                rule += f"{condition[0]} = TRUE"
        rule += f" THEN {path[-1][0]}"
        rules.append(rule)
    
    return rules

# Extract and print rules
rules = get_rules(dt, X.columns, y.unique())
print("\nDecision Rules:")
for rule in rules:
    print(rule)

# Visualize the tree with better resolution and readability
plt.figure(figsize=(30,15))  # Increased figure size
plt.rcParams['font.size'] = 12  # Base font size
plot_tree(dt, feature_names = X.columns, class_names = y.unique(), filled = True, rounded = True, fontsize = 10, precision = 2)

# Reduce decimal places for cleaner look
plt.savefig('decision_tree_visualization.png', 
            dpi=300,  # Increased DPI for better resolution
            bbox_inches='tight',  # Tight layout
            pad_inches=0.1)  # Small padding
plt.close()

# Print feature importances
importances = pd.DataFrame({
    'feature': X.columns,
    'importance': dt.feature_importances_
}).sort_values('importance', ascending = False)

print("\nFeature Importances:")
print(importances)