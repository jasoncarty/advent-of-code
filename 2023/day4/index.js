const fs = require('fs');
const path = require('path');

const filePath = path.resolve(`${__dirname}/real_input.txt`);
const input = fs.readFileSync(filePath, { encoding: 'utf-8' });

const getWins = (card) => {
  const numbers = card.split(':')[1];
  const [winningNumbers, myNumbers] = numbers.split('|')
    .map((item) => Array.from(item.matchAll(/\d+/g), (match) => Number(match[0])));
  return myNumbers.filter((num) => winningNumbers.includes(num));
};

const part1 = () => input
  .split('\n')
  .filter((item) => item !== '')
  .map((card) => {
    const worthPoints = getWins(card);
    return worthPoints.length ? worthPoints.reduce((a, b, index) => {
      if (index === 0) {
        return 1;
      }
      return a * 2;
    }, 1) : 0;
  }).reduce((a, b) => a + b);

const part2 = () => {
  const cards = input
    .split('\n')
    .filter((item) => item !== '')
    .map((card) => ({
      wins: getWins(card),
      copies: 1,
    }));

  cards.forEach((card, cardIndex) => {
    for (let i = 1; i < (card.wins.length + 1); i += 1) {
      cards[cardIndex + i].copies += card.copies;
    }
  });

  return cards.map(({ copies }) => copies).reduce((a, b) => a + b);
};

const firstAnswer = part1(); // 25010
console.log('The answer to part 1 is: ', firstAnswer);

const secondAnswer = part2(); // 9924412
console.log('The answer to part 2 is: ', secondAnswer);
