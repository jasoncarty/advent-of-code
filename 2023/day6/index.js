const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const part1 = () => {
  const [timeLine, distanceLine] = input.split('\n')
    .filter((line) => line !== '');
  const times = Array.from(timeLine.matchAll(/\d+/g), (match) => Number(match[0]));
  const distances = Array.from(distanceLine.matchAll(/\d+/g), (match) => Number(match[0]));
  let winners = 0;

  times.forEach((time, timeIndex) => {
    let options = 0;
    for (let i = 0; i <= time; i += 1) {
      if ((i * (time - i)) > distances[timeIndex]) {
        options += 1;
      }
    }
    winners = winners === 0 ? winners = options : winners *= options;
  });
  return winners;
};

const part2 = () => {
  const [timeLine, distanceLine] = input.split('\n')
    .filter((line) => line !== '');

  const time = Number(Array.from(
    timeLine.matchAll(/\d+/g),
    (match) => match[0],
  ).join(''));

  const distance = Number(Array.from(
    distanceLine.matchAll(/\d+/g),
    (match) => match[0],
  ).join(''));

  let winners = 0;
  let options = 0;
  for (let i = 0; i <= time; i += 1) {
    if ((i * (time - i)) > distance) {
      options += 1;
    }
  }
  winners = winners === 0 ? winners = options : winners *= options;
  return winners;
};

/* const firstAnswer = part1(); // 2612736
console.log('The answer to part 1 is: ', firstAnswer); */

const secondAnswer = part2(); // 29891250
console.log('The answer to part 2 is: ', secondAnswer);
