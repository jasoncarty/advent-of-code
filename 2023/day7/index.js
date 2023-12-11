const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const cardToPointsMap = {
  A: 14,
  K: 13,
  Q: 12,
  J: 11,
  T: 10,
  9: 9,
  8: 8,
  7: 7,
  6: 6,
  5: 5,
  4: 4,
  3: 3,
  2: 2,
};

const countDuplicates = (string) => {
  const counts = {};
  string.split('').forEach((x) => { counts[x] = (counts[x] || 0) + 1; });
  return counts;
};

const convertCardsToPoints = (cards) => {
  const counts = Object.values(countDuplicates(cards));
  if (counts.includes(5)) {
    return 7;
  }
  if (counts.includes(4)) {
    return 6;
  }
  if (counts.includes(3) && counts.includes(2)) {
    return 5;
  }
  if (counts.includes(3)) {
    return 4;
  }
  if (counts.sort()[1] === 2 && counts.sort()[2] === 2) {
    // 2 pairs
    return 3;
  }
  if (counts.includes(2)) {
    return 2;
  }
  return 1;
};

const compareHighestCard = (a, b) => {
  const splitA = a.split('');
  let result = 0;
  for (let i = 0; i < splitA.length; i += 1) {
    const aPoints = cardToPointsMap[splitA[i]];
    const bPoints = cardToPointsMap[b[i]];
    if (aPoints > bPoints) {
      result = 1;
      break;
    }
    if (aPoints < bPoints) {
      result = -1;
      break;
    }
  }
  return result;
};

const sortByRank = (a, b) => {
  const [cardsA] = a;
  const [cardsB] = b;
  const pointsA = convertCardsToPoints(cardsA);
  const pointsB = convertCardsToPoints(cardsB);
  if (pointsA > pointsB) {
    return 1;
  }
  if (pointsA < pointsB) {
    return -1;
  }
  if (pointsA === pointsB) {
    return compareHighestCard(cardsA, cardsB);
  }
  return 0;
};

const part1 = () => input
  .split('\n')
  .filter((item) => item !== '')
  .map((item) => {
    const [cards, bid] = item.split(' ');
    return [cards, Number(bid)];
  }).sort(sortByRank)
  .map((hand, index) => hand[1] * (index + 1))
  .reduce((a, b) => a + b);

const firstAnswer = part1();
console.log('The answer to part 1 is: ', firstAnswer);

/* const secondAnswer = part2(); // 29891250
console.log('The answer to part 2 is: ', secondAnswer);
 */
