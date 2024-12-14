import random

#8
# Агент копирует последний ход опонента, если ход первый, выбирает случайно
def copy_opponent_agent(observation, configuration):
    if observation.step > 0:
        return observation.lastOpponentAction
    else:
        return random.randrange(0, configuration.signs)
