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
  if (!Object.keys(maps)[nextIndex]) {
    return nextIdentifier;
  }
  return findIndentifier(nextIdentifier, maps, Object.keys(maps)[nextIndex]);
};

const part1 = () => {
  const data = { maps: {} };
  input.split('\n\n').forEach((section, index) => {
    const [key, content] = section.split(':');
    const splitContent = content.split('\n')
      .filter((item) => item !== '')
      .map((item) => Array.from(item.matchAll(/\d+/g), (match) => Number(match[0])));

    if (index > 0) {
      data.maps[key] = splitContent;
    } else {
      data.seeds = Array.from(content.matchAll(/\d+/g), (match) => Number(match[0]));
    }
  });

  return data.seeds
    .map((seed) => findIndentifier(seed, data.maps, 'seed-to-soil map'))
    .sort((a, b) => a - b)[0];
};

const firstAnswer = part1(); // 662197086
console.log('The answer to part 1 is: ', firstAnswer);

/* const secondAnswer = part2();
console.log('The answer to part 2 is: ', secondAnswer); */
