const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const getIndexOfVirtualRange = (search, start, end) => {
  if (search < start || search > end) {
    return -1;
  }
  return search - start;
};

const divideArrayIntoChunks = (array, chunkSize) => {
  const newArray = [];
  for (let i = 0; i < array.length; i += chunkSize) {
    newArray.push(array.slice(i, i + chunkSize));
  }
  return newArray;
};

const findIndentifier = (identifier, maps, mapName) => {
  let nextIdentifier;
  for (let index = 0; index < maps[mapName].length; index += 1) {
    const [destination, source, rangeLength] = maps[mapName][index];
    const sourceIndex = getIndexOfVirtualRange(identifier, source, source + rangeLength);
    if (sourceIndex !== -1) {
      nextIdentifier = destination + sourceIndex;
      break;
    }
  }

  const nextIndex = Object.keys(maps).indexOf(mapName) + 1;
  if (!nextIdentifier) {
    nextIdentifier = identifier;
  }

  console.log({ identifier, nextIdentifier, mapName });
  if (!Object.keys(maps)[nextIndex]) {
    return nextIdentifier;
  }
  return findIndentifier(nextIdentifier, maps, Object.keys(maps)[nextIndex]);
};

const getData = (calcSeedsAsRange = false) => {
  const data = { maps: {} };
  input.split('\n\n').forEach((section, index) => {
    const [key, content] = section.split(':');
    const splitContent = content.split('\n')
      .filter((item) => item !== '')
      .map((item) => Array.from(item.matchAll(/\d+/g), (match) => Number(match[0])));

    if (index > 0) {
      data.maps[key] = splitContent;
    } else if (calcSeedsAsRange) {
      data.seeds = divideArrayIntoChunks(
        Array.from(
          content.matchAll(/\d+/g),
          (match) => Number(match[0]),
        ),
        2,
      );
    } else {
      data.seeds = Array.from(content.matchAll(/\d+/g), (match) => Number(match[0]));
    }
  });
  return data;
};

const part1 = () => {
  const data = getData();
  return data.seeds
    .map((seed) => findIndentifier(seed, data.maps, 'seed-to-soil map'))
    .sort((a, b) => a - b)[0];
};

const part2 = () => {
  const data = getData(true);
  let lowest = null;
  data.seeds
    .forEach(([start, rangeLength]) => {
      let index = start;
      while (index < (start + rangeLength)) {
        const location = findIndentifier(index, data.maps, 'seed-to-soil map');
        if (lowest === null || location < lowest) {
          lowest = location;
        }
        index += 1;
      }
    });
  return lowest;
};

const firstAnswer = part1(); // 662197086
console.log('The answer to part 1 is: ', firstAnswer);

/** Did not solve part 2 */
/* const secondAnswer = part2();
console.log('The answer to part 2 is: ', secondAnswer); */
