'''
data_merger_grammar.py
A very simple script that merges multiple grammar lists into one
'''
import csv

base_feature = "Feature ID"
base_description = "Description"
data_directory_path = "../data/"
data_dict = {
  "Bislama": ["bislama_grammar.csv"],
  "Pijin": ["pijin_grammar.csv"],
  "Tok Pisin": ["tok_pisin_grammar.csv"],
  "Torres Creole": ["torres_creole_grammar.csv"]
}
min_entries_for_inclusion = 4

total_features = []
total_descriptions = []

#Identifying all unique features in the input files
for language in data_dict:
    for data_file in data_dict[language]:
        with open(data_directory_path + data_file, encoding = 'cp850') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                current_feature = row[0].lower()
                if current_feature not in total_features:
                    total_features.append(current_feature)
                    total_descriptions.append(row[1].replace(",", ""))

merged_list = []

#Adding a header for the csv file
merged_list.append(base_feature + "," + base_description + "," + ",".join(data_dict.keys()))

#Grouping the features by language and adding them to the merged data
for i, feature in enumerate(total_features):
    all_entries = []
    entry_counter = 0
    for language in data_dict:
        local_entries = []
        for data_file in data_dict[language]:
            with open(data_directory_path + data_file, encoding = 'cp850') as csv_file:
                csv_reader = csv.reader(csv_file, delimiter=',')
                line_count = 0
                for row in csv_reader:
                    if row[0].lower() == feature:
                        if row[2].lower() not in local_entries and row[2].lower() in ["0", "1"]:
                            local_entries.append(row[2].lower())
        if local_entries == []:
            all_entries.append("")
        else:
            entry_counter += 1
            all_entries.append("/".join(local_entries))
    if entry_counter >= min_entries_for_inclusion:
        merged_list.append(feature + "," + total_descriptions[i] + "," + ",".join(all_entries))

# Sort the list alphabetically
merged_list = sorted(merged_list)              
print(merged_list)

# Writing the merged data to a csv file
with open(data_directory_path + 'merged_grammar_4.csv', 'w', encoding = 'cp850') as f:
    for line in merged_list:
        f.write(f"{line}\n")