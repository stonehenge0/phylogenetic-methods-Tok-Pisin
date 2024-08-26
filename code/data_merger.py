'''
data_merger.py
A very simple script that merges multiple word lists into one
'''
import csv

base_language = "English"
data_directory_path = "../data/"
data_dict = {
  "Bislama": ["bislama_asjp.csv"],
  "Pijin": ["pijin_asjp.csv"],
  "Tok Pisin": ["tok_pisin_asjp.csv"],
  "Torres Creole": ["torres_creole_asjp.csv"]
}

total_vocabulary = []

#Identifying all unique words in the input files
for language in data_dict:
    for data_file in data_dict[language]:
        with open(data_directory_path + data_file) as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            line_count = 0
            for row in csv_reader:
                current_word = row[0].lower()
                if current_word not in total_vocabulary:
                    total_vocabulary.append(current_word)

merged_list = []

#Adding a header for the csv file
merged_list.append(base_language + "," + ",".join(data_dict.keys()))

#Grouping the translations by language and adding them to the merged data
for word in total_vocabulary:
    all_word_translations = []
    for language in data_dict:
        local_word_translations = []
        for data_file in data_dict[language]:
            with open(data_directory_path + data_file) as csv_file:
                csv_reader = csv.reader(csv_file, delimiter=',')
                line_count = 0
                for row in csv_reader:
                    if row[0].lower() == word:
                        if row[1].lower() not in local_word_translations:
                            local_word_translations.append(row[1].lower())
        if local_word_translations == []:
            all_word_translations.append("")
        else:
            all_word_translations.append("/".join(local_word_translations))
    merged_list.append(word + "," + ",".join(all_word_translations))
                
print(merged_list)

# Writing the merged data to a csv file
with open('merged_data.csv', 'w') as f:
    for line in merged_list:
        f.write(f"{line}\n")