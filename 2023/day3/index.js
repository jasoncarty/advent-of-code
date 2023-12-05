const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const getRange = (start, stop, step) => Array.from(
  { length: (stop - start) / step + 1 },
  (value, index) => start + index * step,
);

const part1 = () => {
  const parts = [];
  const lines = input
    .split('\n')
    .filter((item) => item !== '');
  lines
    .forEach((line, lineIndex) => {
      Array.from(
        line.matchAll(/\d+/g),
        (match) => ({ match: match[0], index: match.index }),
      ).forEach((digit) => {
        const { match, index: startIndex } = digit;
        const endIndex = startIndex + (match.length - 1);
        const adjacentHorizontalIndices = getRange(startIndex - 1, endIndex + 1, 1);
        const adjacentVerticalIndices = getRange(lineIndex - 1, lineIndex + 1, 1);

        adjacentVerticalIndices.forEach((vertIndex) => {
          adjacentHorizontalIndices.forEach((horIndex) => {
            if (lines[vertIndex]) {
              const symbolIndices = Array.from(lines[vertIndex].matchAll(/[^a-zA-Z0-9.]+/g), ({ index }) => index);
              if (lines[vertIndex][horIndex] && symbolIndices.includes(horIndex)) {
                parts.push(parseInt(match, 10));
              }
            }
          });
        });
      });
    });

  return Array.from(parts)
    .reduce((a, b) => a + b);
};

const part2 = () => {
  const gears = [];
  const lines = input
    .split('\n')
    .filter((item) => item !== '');

  lines
    .forEach((line, lineIndex) => {
      Array.from(
        line.matchAll(/\*/g),
        (match) => ({ match: match[0], index: match.index }),
      ).forEach((star) => {
        const parts = [];
        const { index: startIndex } = star;
        const endIndex = startIndex + 1;
        const adjacentHorizontalIndices = getRange(startIndex - 1, endIndex, 1);
        const adjacentVerticalIndices = getRange(lineIndex - 1, lineIndex + 1, 1);

        adjacentVerticalIndices.forEach((vertIndex) => {
          const usedIndices = [];
          adjacentHorizontalIndices.forEach((horIndex) => {
            if (lines[vertIndex]) {
              const digitIndices = Array.from(
                lines[vertIndex].matchAll(/\d+/g),
                (found) => ({
                  number: parseInt(found[0], 10),
                  indices: getRange(found.index, found.index + (found[0].length - 1), 1),
                }),
              );

              if (lines[vertIndex][horIndex] && lines[vertIndex][horIndex].match(/\d/)) {
                digitIndices.forEach(({ number, indices }) => {
                  if (indices.includes(horIndex)
                    && !indices.some((item) => usedIndices.includes(item))
                  ) {
                    parts.push(number);
                    usedIndices.push(...indices);
                  }
                });
              }
            }
          });
        });
        if (parts.length === 2) {
          gears.push(parts.reduce((a, b) => a * b));
        }
      });
    });
  return gears.reduce((a, b) => a + b);
};

const firstAnswer = part1(); // 512794
console.log('The answer to part 1 is: ', firstAnswer);
const secondAnswer = part2(); // 67779080
console.log('The answer to part 2 is: ', secondAnswer);
