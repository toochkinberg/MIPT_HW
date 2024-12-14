import random

#11
# Агент анализирует статистику ходов опонента
action_histogram = {}
def statistical_agent(observation, configuration):
    global action_histogram
    if observation.step == 0:
        action_histogram = {}
        return random.randint(0, 2)
    
    action = observation.lastOpponentAction
    action_histogram[action] = action_histogram.get(action, 0) + 1

    mode_action = max(action_histogram, key=action_histogram.get)
    return (mode_action + 1) % configuration.signs
