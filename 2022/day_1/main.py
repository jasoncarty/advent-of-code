def get_elves() -> map[int]:
    with open("real_input.txt") as f:
        input: str = f.read()
        return map(sum, map(
            lambda item: map(
                int,
                item.strip().split("\n")
            ), input.split("\n\n")
        ))


part1: int = max(list(get_elves()))
part2: int = sum(
    list(
        reversed(sorted(list(get_elves())))
    )[0:3]
)

print(f"The answer to part 1 is: {part1}")  # The answer is: 71506
print(f"The answer to part 2 is: {part2}")  # The answer is: 209603
