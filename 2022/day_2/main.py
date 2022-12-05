move_dict: dict = {
    "A": {
        "name": "rock",
        "score": 1,
        "beats": "scissors",
        "draws": "rock",
        "loses": "paper",
        "equals": "X"
    },
    "B": {
        "name": "paper",
        "score": 2,
        "beats": "rock",
        "draws": "paper",
        "loses": "scissors",
        "equals": "Y"
    },
    "C": {
        "name": "scissors",
        "score": 3,
        "beats": "paper",
        "draws": "scissors",
        "loses": "rock",
        "equals": "Z"
    }
}

strategy_dict = {"X": "loses", "Y": "draws", "Z": "beats"}


def calculate_score(my_move: dict, opponents_move: dict) -> int:
    if my_move == opponents_move:
        return my_move["score"] + 3
    elif my_move["beats"] == opponents_move["name"]:
        return my_move["score"] + 6
    else:
        return my_move["score"]


def get_games() -> list[list[str]]:
    with open("real_input.txt") as f:
        return list(map(lambda item: item.split(" "),
                        list(filter(None, f.read().split("\n")))
                        ))


def get_part1(move: list[str]):
    them, me = move
    opponents_move = move_dict[them]
    my_move = {key: value for (
        key, value) in move_dict.items() if value["equals"] == me}
    return calculate_score(list(my_move.values())[0], opponents_move)


def get_part2(move: list[str]):
    them, me = move
    opponents_move = move_dict[them]
    my_strategy = strategy_dict[me]
    my_move = {key: value for (
        key, value) in move_dict.items() if value[my_strategy] == opponents_move["name"]}
    return calculate_score(list(my_move.values())[0], opponents_move)


part1 = list(map(get_part1, get_games()))
part2 = list(map(get_part2, get_games()))

# The answer to part 1 is: 14531
print(f"The answer to part 1 is: {sum(part1)}")
# The answer to part 2 is: 11258
print(f"The answer to part 2 is: {sum(part2)}")
