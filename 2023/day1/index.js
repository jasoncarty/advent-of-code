const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const part1 = () => input
  .split('\n')
  .filter((item) => item !== '')
  .map((line) => {
    const { length, 0: first, [length - 1]: last } = line.match(/\d/g);
    return parseInt([first, last].join(''), 10);
  }).reduce((a, b) => a + b);

const numbersMap = {
  one: 1,
  two: 2,
  three: 3,
  four: 4,
  five: 5,
  six: 6,
  seven: 7,
  eight: 8,
  nine: 9,
};

const replaceLetters = (str) => {
  const starts = Array.from(
    str.matchAll(/(?=one|two|three|four|five|six|seven|eight|nine|\d)/g),
    ({ index }) => index,
  );
  const ends = Array.from(
    str.matchAll(/(?<=one|two|three|four|five|six|seven|eight|nine|\d)/g),
    ({ index }) => index,
  );

  return starts.map((item, index) => {
    const newItem = str.substring(item, ends[index]);
    if (numbersMap[newItem]) {
      return numbersMap[newItem];
    }
    return newItem;
  });
};

const part2 = () => input
  .split('\n')
  .filter((item) => item !== '')
  .map((line) => {
    const matches = replaceLetters(line).match(/\d/g);
    const { length, 0: first, [length - 1]: last } = matches;
    return parseInt([first, last].join(''), 10);
  }).reduce((a, b) => a + b);

part1(); // -> answer 55108
part2(); // -> answer 56324
