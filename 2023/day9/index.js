const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const part1 = () => {
  const lines = input.split('\n').filter((item) => item !== '')
    .map((line) => line.split(' ').map((item) => Number(item)));

  return lines.map((line) => {
    const differences = [line];

    while (!differences.at(-1).every((item) => item === 0)) {
      differences.push(differences.at(-1).map((item, index) => {
        if (
          differences.at(-1)[index - 1] !== null
          && differences.at(-1)[index - 1] !== undefined
        ) {
          return item - differences.at(-1)[index - 1];
        }
        return null;
      }).filter((item) => item !== null));
    }

    const differencesFiltered = differences.filter((item) => item && item.length);
    return differencesFiltered
      .map((list) => list.at(-1)).reduce((a, b) => a + b);
  }).reduce((a, b) => a + b);
};

const part2 = () => {
  const lines = input.split('\n').filter((item) => item !== '')
    .map((line) => line.split(' ').map((item) => Number(item)));

  return lines.map((line) => {
    const differences = [line.reverse()];

    while (!differences.at(-1).every((item) => item === 0)) {
      differences.push(differences.at(-1).map((item, index) => {
        if (
          differences.at(-1)[index - 1] !== null
          && differences.at(-1)[index - 1] !== undefined
        ) {
          return item - differences.at(-1)[index - 1];
        }
        return null;
      }).filter((item) => item !== null));
    }

    const differencesFiltered = differences.filter((item) => item && item.length);
    return differencesFiltered
      .map((list) => list.at(-1)).reduce((a, b) => a + b);
  }).reduce((a, b) => a + b);
};

const firstAnswer = part1(); // 1834108701
console.log('The answer to part 1 is: ', firstAnswer);

const secondAnswer = part2(); // 993
console.log('The answer to part 2 is: ', secondAnswer);
