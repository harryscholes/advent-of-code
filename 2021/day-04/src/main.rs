use std::{
    io::{self, BufRead},
    num::{self, ParseIntError},
};
use thiserror::Error;
use utils::read_input;

#[derive(Debug, Clone)]
struct Bingo {
    draw: Vec<u64>,
    boards: Vec<Board>,
}

#[derive(Debug, Clone)]
struct Board {
    positions: Vec<Position>,
}

impl Board {
    pub fn new(positions: Vec<Position>) -> Board {
        Board { positions }
    }

    pub fn update(&mut self, x: u64) {
        self.positions
            .iter_mut()
            .filter(|p| p.value == x)
            .for_each(|p| p.marked = true);
    }

    pub fn has_won(&self) -> bool {
        self.has_won_rows() || self.has_won_columns()
    }

    fn has_won_rows(&self) -> bool {
        self.positions
            .chunks(5)
            .any(|ps| ps.iter().map(|p| p.marked).all(|b| b))
    }

    fn has_won_columns(&self) -> bool {
        (0..5)
            .map(|start| {
                self.positions
                    .iter()
                    .skip(start)
                    .step_by(5)
                    .map(|p| p.marked)
                    .all(|b| b)
            })
            .any(|b| b)
    }

    fn sum_unmarked(&self) -> u64 {
        self.positions
            .iter()
            .filter(|p| !p.marked)
            .map(|p| p.value)
            .sum()
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
struct Position {
    value: u64,
    marked: bool,
}

impl Position {
    pub fn new(value: u64) -> Position {
        Position {
            value,
            marked: false,
        }
    }
}

fn parse_input(buf: &mut dyn BufRead) -> Result<Bingo, Error> {
    let mut it = buf.lines();

    let draw = it
        .next()
        .unwrap()
        .unwrap()
        .split(",")
        .map(|c| c.parse())
        .collect::<Result<Vec<u64>, ParseIntError>>()?;

    let mut boards = vec![];
    let mut positions = vec![];

    for line in it {
        let line = line?;

        if line == "" {
            if !positions.is_empty() {
                boards.push(Board::new(positions));
            }
            positions = vec![];
        } else {
            let row = line
                .split_whitespace()
                .map(|c| {
                    let value = c.parse()?;
                    Ok(Position::new(value))
                })
                .collect::<Result<Vec<Position>, ParseIntError>>()?;

            positions.extend(row);
        }
    }

    boards.push(Board::new(positions));

    let bingo = Bingo { draw, boards };
    Ok(bingo)
}

fn part_one(bingo: &mut Bingo) -> Option<u64> {
    for d in &bingo.draw {
        for b in &mut bingo.boards {
            b.update(*d);

            if b.has_won() {
                let s = b.sum_unmarked();

                return Some(s * d);
            }
        }
    }

    None
}

fn part_two(bingo: &mut Bingo) -> Option<u64> {
    let mut winners = bingo.boards.iter().map(|_| false).collect::<Vec<_>>();

    for d in &bingo.draw {
        for (i, b) in bingo.boards.iter_mut().enumerate() {
            b.update(*d);

            if b.has_won() {
                winners[i] = true;

                if winners.iter().all(|b| *b) {
                    let s = b.sum_unmarked();

                    return Some(s * d);
                }
            }
        }
    }

    None
}

#[derive(Error, Debug)]
enum Error {
    #[error(transparent)]
    ParseInt(#[from] num::ParseIntError),
    #[error(transparent)]
    Io(#[from] io::Error),
}

fn run() -> Result<(), Error> {
    let bingo = parse_input(&mut read_input()?)?;
    dbg!(part_one(&mut bingo.clone()).unwrap());
    dbg!(part_two(&mut bingo.clone()).unwrap());
    Ok(())
}

fn main() {
    run().unwrap();
}

#[cfg(test)]
mod tests {
    use crate::{parse_input, part_one, part_two, Board, Position};

    const TEST_INPUT: &str = r#"7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
8  2 23  4 24
21  9 14 16  7
6 10  3 18  5
1 12 20 15 19

3 15  0  2 22
9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
2  0 12  3  7"#;

    #[test]
    fn test_parse() {
        let bingo = parse_input(&mut TEST_INPUT.as_bytes()).unwrap();
        assert_eq!(bingo.draw.len(), 27);
        assert_eq!(bingo.boards.len(), 3);
        bingo
            .boards
            .iter()
            .for_each(|b| assert_eq!(b.positions.len(), 25));
    }

    #[test]
    fn update_board() {
        let mut b = mock_board();
        assert_eq!(b.positions[0], Position::new(1));
        assert_eq!(b.positions[24], Position::new(25));

        vec![1, 25].into_iter().for_each(|p| b.update(p));
        assert_eq!(
            b.positions[0],
            Position {
                value: 1,
                marked: true
            }
        );
        assert_eq!(
            b.positions[24],
            Position {
                value: 25,
                marked: true
            }
        );
    }

    #[test]
    fn has_won_rows() {
        let mut b = mock_board();
        assert!(!b.has_won_rows());

        (21..=24).into_iter().for_each(|p| b.update(p));
        assert!(!b.has_won_rows());

        b.update(25);
        assert!(b.has_won_rows());
    }

    #[test]
    fn has_won_columns() {
        let mut b = mock_board();
        assert!(!b.has_won_columns());

        vec![5, 10, 15, 20].into_iter().for_each(|p| b.update(p));
        assert!(!b.has_won_columns());

        b.update(25);
        assert!(b.has_won_columns());
    }

    #[test]
    fn test_part_one() {
        let mut bingo = parse_input(&mut TEST_INPUT.as_bytes()).unwrap();
        assert_eq!(part_one(&mut bingo).unwrap(), 4512);
    }

    #[test]
    fn test_part_two() {
        let mut bingo = parse_input(&mut TEST_INPUT.as_bytes()).unwrap();
        assert_eq!(part_two(&mut bingo).unwrap(), 1924);
    }

    fn mock_board() -> Board {
        Board::new((1..=25).map(|i| Position::new(i)).collect())
    }
}
