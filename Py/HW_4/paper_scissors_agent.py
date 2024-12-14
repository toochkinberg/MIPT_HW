import random

#5
# Агент выбирает либо ножницы, любо бумагу
def paper_scissors_agent(observation, configuration):
    return random.randint(1,2)
