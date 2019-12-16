from random import shuffle, choice
import csv

def create_table(table_name, block_length):
    condition_list = []

    condition_name = []
    id = []
    congruency = []
    correct_response = []
    stimulus = []
    smiley = []

    current_id = 0


    for i in range(4):
        # 51 for trial block, 6 for practice block
        for j in range(block_length/4):
            condition_list.append(i)


    shuffle(condition_list)

    for i in condition_list:
        if i == 0:
            condition = "co_left"
            current_congruency = 1
            correct = 'k'
            current_stimulus = "< < < < <"
        elif i == 1:
            condition = "co_right"
            current_congruency = 1
            correct = 'l'
            current_stimulus = "> > > > >"
        elif i == 2:
            condition = "inco_left"
            current_congruency = 0
            correct = 'k'
            current_stimulus = "> > < > >"
        else:
            condition = "inco_right"
            current_congruency = 0
            correct = 'l'
            current_stimulus = "< < > < <"
        current_id += 1
        emotion = choice(['sad.jpg','happy.jpg','neutral.jpg'])
        id.append(current_id)
        condition_name.append(condition)
        congruency.append(current_congruency)
        correct_response.append(correct)
        stimulus.append(current_stimulus)
        smiley.append(emotion)

    columns = zip(id,condition_name,congruency,correct_response,stimulus,smiley)
    with open('blocks/{}.csv'.format(table_name), 'wb') as f:
        writer = csv.writer(f)
        for column in columns:
            writer.writerow(column)

create_table('firstBlock', 204)
create_table('secondBlock', 204)
create_table('thirdBlock', 204)
create_table('practiceBlock', 24)