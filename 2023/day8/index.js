/* eslint-disable no-eval */
/* eslint-disable no-param-reassign */
/* eslint-disable prefer-destructuring */
const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const getNextSide = (item, direction, map) => {
  let side;
  const [left, right] = item.trim().split(' = ')[1].split(',');
  if (direction === 'L') {
    side = left.substring(1, 4);
  } else {
    side = right.substring(1, 4);
  }
  return map.filter((m) => m.line.startsWith(side))[0];
};

const part1 = () => {
  const directions = input.split('\n\n')[0].split('');
  const lines = input
    .split('\n\n')[1]
    .split('\n')
    .filter((item) => item !== '')
    .map((line, index) => ({
      line,
      name: line.split(' = ')[0],
      index,
    }));
  let steps = 0;
  let [currentLine] = lines.filter((item) => item.line.startsWith('AAA'));
  for (let i = 0; i < directions.length; i += 1) {
    if (currentLine.line.startsWith('ZZZ')) {
      break;
    }
    steps += 1;
    currentLine = getNextSide(currentLine.line, directions[i], lines);
    if (i === directions.length - 1) {
      i = -1;
    }
  }
  return steps;
};

const firstAnswer = part1(); // 16409
console.log('The answer to part 1 is: ', firstAnswer);

/* const secondAnswer = part2();
console.log('The answer to part 2 is: ', secondAnswer); */
