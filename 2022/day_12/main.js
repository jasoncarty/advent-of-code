const fs = require('fs');

const chars = [...Array(26)].map((_, i) => String.fromCharCode('a'.charCodeAt(0) + i));
const heightMap = {
  S: 1,
  E: 26,
};
chars.forEach((char, idx) => { heightMap[char] = idx + 1; });

const getNeigbors = (current, map) => [[0, 1], [0, -1], [1, 0], [-1, 0]].map((pos) => {
  let result = null;
  const [neighborsXdiff, neighborsYdiff] = pos;
  const currentHeight = heightMap[current.letter];

  if (
    map[current.x + neighborsXdiff]
    && map[current.x + neighborsXdiff][current.y + neighborsYdiff]
  ) {
    const neighbor = map[current.x + neighborsXdiff][current.y + neighborsYdiff];
    const neighborHeight = heightMap[neighbor];
    if (neighborHeight < currentHeight + 2) {
      result = {
        x: current.x + neighborsXdiff,
        y: current.y + neighborsYdiff,
        g: current.g + 1,
        letter: neighbor,
      };
    }
  }

  return result;
}).filter((x) => x);

const input = fs.readFileSync('real_input.txt', 'utf-8');

const getMatrix = () => {
  const map = input.split('\n').map((line) => line.split(''));
  map.pop();
  return map;
};

const getStartAndEnd = (matrix, start) => {
  const THE_END = 'E';
  const THE_START = 'S';
  let endPosition = null;
  let startPosition = start;

  matrix.forEach((row, x) => row.forEach((letter, y) => {
    if (!start && letter === THE_START) {
      startPosition = {
        letter, x, y, g: 0,
      };
    }
    if (letter === THE_END) {
      endPosition = {
        letter, x, y, g: 0,
      };
    }
  }));
  return [startPosition, endPosition];
};

const getPathSteps = (matrix, startPosition, endPosition) => {
  const queue = [];
  const explored = [];
  let steps = 0;

  queue.push(startPosition);

  while (queue.length > 0) {
    const current = queue.shift();
    if (current.x === endPosition.x && current.y === endPosition.y) {
      steps = current.g;
      break;
    }

    const neighbors = getNeigbors(current, matrix);
    neighbors.forEach((neighbor) => {
      let containsObject = false;

      explored.forEach((item) => {
        if (item.x === neighbor.x && item.y === neighbor.y) {
          containsObject = true;
        }
      });
      if (!containsObject) {
        explored.push(neighbor);
        queue.push(neighbor);
      }
    });
  }
  return steps;
};

const part1 = () => {
  const matrix = getMatrix();
  const [startPosition, endPosition] = getStartAndEnd(matrix);
  return getPathSteps(matrix, startPosition, endPosition);
};

const part2 = () => {
  const matrix = getMatrix();
  const positionsWithA = [];
  matrix.forEach((row, x) => row.forEach((col, y) => {
    if (col === 'a') {
      positionsWithA.push([x, y]);
    }
  }));
  return positionsWithA.map((item) => {
    const [startPosition, endPosition] = getStartAndEnd(matrix, {
      x: item[0], y: item[1], g: 0, letter: 'a',
    });
    return getPathSteps(matrix, startPosition, endPosition);
  }).filter((item) => item).sort((a, b) => a - b)[0];
};

console.log(`The answer to part 1 is: ${part1()}`); // The answer to part 1 is: 472
console.log(`The answer to part 2 is: ${part2()}`); // The answer to part 2 is: 465
