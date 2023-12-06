const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const part1 = () => input
  .split('\n')
  .filter((item) => item !== '')
  .map((card) => {
    // eslint-disable-next-line no-unused-vars
    const [_, numbers] = card.split(':');
    const [winners, mine] = numbers.split('|');
    const winningNumbers = Array.from(winners.matchAll(/\d+/g), (match) => Number(match[0]));
    const myNumbers = Array.from(mine.matchAll(/\d+/g), (match) => Number(match[0]));
    const worthPoints = myNumbers.filter((num) => winningNumbers.includes(num));
    return worthPoints.length ? worthPoints.reduce((a, b, index) => {
      if (index === 0) {
        return 1;
      }
      return a * 2;
    }, 1) : 0;
  });

/* const processCards = (cards) => {
  console.log('--------starting loop-----');
  console.log({ lengthOfCards: cards.length });
  cardsSize += cards.length;
  cards.forEach((card) => {
    const cardId = card.id;
    console.log({ card, cardId });
    // eslint-disable-next-line no-unused-vars
    const [winners, mine] = card.content.split('|');
    const winningNumbers = Array.from(winners.matchAll(/\d+/g), (match) => Number(match[0]));
    const myNumbers = Array.from(mine.matchAll(/\d+/g), (match) => Number(match[0]));
    const worthPoints = myNumbers.filter((num) => winningNumbers.includes(num));

    // process copies if any
    if (worthPoints.length) {
      const copies = cards.filter((theCard) => {
        const ids = getRange(cardId + 1, cardId + worthPoints.length, 1);
        if (ids.includes(theCard.id)) {
          return true;
        }
        return false;
      });

      if (copies.length) {
        console.log({ copies });

        processCards(copies);
      }
    }
  });
}; */

/* const processCards = (cards, cardsMap) => {
  cards.forEach((card) => {
    if (cardsMap.has(card.id)) {
      cardsMap.set(card.id, cardsMap.get(card.id) + 1);
    } else {
      cardsMap.set(card.id, 1);
    }
    console.log({ card });
    // eslint-disable-next-line no-unused-vars
    const [winners, mine] = card.content.split('|');
    const winningNumbers = Array.from(winners.matchAll(/\d+/g), (match) => Number(match[0]));
    const myNumbers = Array.from(mine.matchAll(/\d+/g), (match) => Number(match[0]));
    const worthPoints = myNumbers.filter((num) => winningNumbers.includes(num));
    const ids = getRange(card.id + 1, card.id + worthPoints.length, 1);

    console.log({ range: ids });

    // process copies if any
    if (worthPoints.length) {
      const copies = cards.filter((theCard) => ids.includes(theCard.id));

      if (copies.length) {
        // console.log({ copies });
        processCards(copies, cardsMap);
      }
    }
  });
  return cardsMap;
}; */

/* const part2 = () => {
  const cards = input
    .split('\n')
    .filter((item) => item !== '')
    .map((card) => ({
      id: Number(card.split(':')[0].match(/\d+/).join('')),
      content: card.split(':')[1],
    }));

  const cardsMap = new Map();
  const result = processCards(cards, cardsMap);

  console.log({ result });
  // console.log({ size: cardsSize });
  return cardsSize;
}; */

const firstAnswer = part1();
console.log('The answer to part 1 is: ', firstAnswer);

/** Did not solve part 2 */
/* const secondAnswer = part2();
console.log('The answer to part 2 is: ', secondAnswer); */
