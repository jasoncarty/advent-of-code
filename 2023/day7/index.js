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

const cardToPointsMap2 = {
  A: 14,
  K: 13,
  Q: 12,
  T: 11,
  9: 10,
  8: 9,
  7: 8,
  6: 7,
  5: 6,
  4: 5,
  3: 4,
  2: 3,
  J: 2,
};

const countDuplicates = (string) => {
  const counts = {};
  string.split('').forEach((x) => { counts[x] = (counts[x] || 0) + 1; });
  return counts;
};

const convertCardsToPoints = (cards, jokerIsHighest = false) => {
  const duplicates = countDuplicates(cards);
  const counts = Object.values(duplicates);
  const keys = Object.keys(duplicates);
  if (jokerIsHighest && keys.includes('J')) {
    let replaced = cards.replaceAll('J', '');
    if (replaced === '') {
      replaced = 'AAAAA';
    }

    const newDuplicates = countDuplicates(replaced);
    const highestCard = Object.entries(newDuplicates)
      .sort((a, b) => b[1] - a[1])[0][0];
    return convertCardsToPoints(cards.replaceAll('J', highestCard));
  }
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

const compareHighestCard = (a, b, jokerIsHighest = false) => {
  let map = cardToPointsMap;
  if (jokerIsHighest) {
    map = cardToPointsMap2;
  }
  const splitA = a.split('');
  let result = 0;
  for (let i = 0; i < splitA.length; i += 1) {
    const aPoints = map[splitA[i]];
    const bPoints = map[b[i]];
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

const sortByRank = (a, b, jokerIsHighest = false) => {
  const [cardsA] = a;
  const [cardsB] = b;
  const pointsA = convertCardsToPoints(cardsA, jokerIsHighest);
  const pointsB = convertCardsToPoints(cardsB, jokerIsHighest);
  if (pointsA > pointsB) {
    return 1;
  }
  if (pointsA < pointsB) {
    return -1;
  }
  if (pointsA === pointsB) {
    return compareHighestCard(cardsA, cardsB, jokerIsHighest);
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

const part2 = () => input
  .split('\n')
  .filter((item) => item !== '')
  .map((item) => {
    const [cards, bid] = item.split(' ');
    return [cards, Number(bid)];
  }).sort((a, b) => sortByRank(a, b, true))
  .map((hand, index) => hand[1] * (index + 1))
  .reduce((a, b) => a + b);

const firstAnswer = part1(); // 248422077
console.log('The answer to part 1 is: ', firstAnswer);

const secondAnswer = part2(); // 249817836
console.log('The answer to part 2 is: ', secondAnswer);
