const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const part1 = () => {
  const max = {
    red: 12,
    green: 13,
    blue: 14,
  };

  return input.split('\n')
    .filter((item) => item !== '')
    .map((game) => {
      const [gameName, sets] = game.split(':');
      const gameId = parseInt(gameName.match(/\d/g).join(''), 10);

      const rounds = sets.split(';').map((subset) => {
        const counts = {
          red: 0,
          green: 0,
          blue: 0,
        };
        subset.split(',').forEach((cube) => {
          const amount = parseInt(cube.match(/\d/g).join(''), 10);
          const cubeType = cube.match(/(red|blue|green)/g);
          counts[cubeType] += amount;
        });
        return Object.keys(counts).every((key) => counts[key] <= max[key]);
      });
      return {
        id: gameId,
        possible: rounds.every((round) => round === true),
      };
    }).filter((game) => game.possible)
    .map(({ id }) => id)
    .reduce((a, b) => a + b);
};

const part2 = () => input.split('\n')
  .filter((item) => item !== '')
  .map((game) => {
    const [_, sets] = game.split(':');
    const gameCount = {
      red: 0,
      green: 0,
      blue: 0,
    };

    sets.split(';').forEach((subset) => {
      const subsetCounts = { ...gameCount };
      subset.split(',').forEach((cube) => {
        const amount = parseInt(cube.match(/\d/g).join(''), 10);
        const cubeType = cube.match(/(red|blue|green)/g);
        subsetCounts[cubeType] += amount;
        if (gameCount[cubeType] < amount) {
          gameCount[cubeType] = amount;
        }
      });
    });
    return Object.values(gameCount).reduce((a, b) => a * b);
  }).reduce((a, b) => a + b);

const firstAnswer = part1(); // 2406
console.log(`The answer to part 1 is: ${firstAnswer}`);

const secondAnswer = part2(); // 78375
console.log(`The answer to part 1 is: ${secondAnswer}`);
