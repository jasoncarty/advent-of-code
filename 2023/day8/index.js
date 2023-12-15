/* eslint-disable no-eval */
/* eslint-disable no-param-reassign */
/* eslint-disable prefer-destructuring */
const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const getNextLine = (item, direction, map) => {
  const side = item[direction];
  return map.filter((m) => m.line.startsWith(side))[0];
};

const getLines = () => input
  .split('\n\n')[1]
  .split('\n')
  .filter((item) => item !== '')
  .map((line, index) => ({
    line,
    name: line.split(' = ')[0],
    L: line.trim().split(' = ')[1].split(',')[0].substring(1, 4),
    R: line.trim().split(' = ')[1].split(',')[1].substring(1, 4),
    index,
  }));

const gcd = (a, b) => (a ? gcd(b % a, a) : b);

const lcm = (a, b) => (a * b) / gcd(a, b);

const part1 = () => {
  const directions = input.split('\n\n')[0].split('');
  const lines = getLines();

  let steps = 0;
  let [currentLine] = lines.filter((item) => item.line.startsWith('AAA'));
  for (let i = 0; i < directions.length; i += 1) {
    if (currentLine.line.startsWith('ZZZ')) {
      break;
    }
    steps += 1;
    currentLine = getNextLine(currentLine, directions[i], lines);
    if (i === directions.length - 1) {
      i = -1;
    }
  }
  return steps;
};

const part2 = () => {
  const directions = input.split('\n\n')[0].split('');
  const lines = getLines();

  let steps = 0;
  const spaceBetweenZs = [];
  let currentLines = lines.filter(
    (item) => item.name.endsWith('A'),
  );
  for (let i = 0; i < directions.length; i += 1) {
    if (i === 0) {
      console.log('---starting again-----', { steps });
    }
    // console.log({ currentLines, currentLineslength: currentLines.length, steps });
    // console.log(`---steps: ${steps}`);
    // console.log({ currentLines });
    if (currentLines.every(({ name }) => name.endsWith('Z'))) {
      break;
    }
    steps += 1;
    if (currentLines.some(({ name }) => name.endsWith('Z'))) {
      spaceBetweenZs.push(steps);
    }
    if (spaceBetweenZs.length === 8) {
      break;
    }
    /* const nextLines = [];
    for (let x = 0; x < currentLines.length; x += 1) {
      nextLines.push(getNextLine(currentLines[x].line, directions[i], lines));
      console.log(`---steps: ${steps}`);
    } */
    currentLines = currentLines.map(
      (item) => getNextLine(item, directions[i], lines),
    );
    if (i === directions.length - 1) {
      i = -1;
    }
  }
  const reversed = spaceBetweenZs.slice().reverse();
  const values = reversed.map((item, index) => {
    console.log({
      item,
      'reversed[index + 1]': reversed[index + 1],
    });
    return reversed[index + 1] ? item - reversed[index + 1] : item;
  });
  console.log({
    spaceBetweenZs,
    values,
    lcm: spaceBetweenZs.reduce(lcm),
  });

  return steps;
};

/* const firstAnswer = part1(); // 16409
console.log('The answer to part 1 is: ', firstAnswer);
 */
const secondAnswer = part2();
console.log('The answer to part 2 is: ', secondAnswer);
