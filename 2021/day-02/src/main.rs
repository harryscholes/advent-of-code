use std::{
    io::{self, BufRead},
    num,
    str::FromStr,
};
use thiserror::Error;
use utils::read_input;

#[derive(Debug, PartialEq, Eq)]
struct Instruction {
    direction: Direction,
    amount: i32,
}

#[derive(Debug, PartialEq, Eq)]
enum Direction {
    Up,
    Down,
    Forward,
}

impl FromStr for Direction {
    type Err = Error;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "up" => Ok(Direction::Up),
            "down" => Ok(Direction::Down),
            "forward" => Ok(Direction::Forward),
            _ => Err(Error::ParseDirectionError(s.to_string())),
        }
    }
}

fn parse_input(buf: &mut dyn BufRead) -> Result<Vec<Instruction>, Error> {
    buf.lines()
        .map(|s| {
            let s = s?;
            let strs = s.split(" ").collect::<Vec<_>>();
            Ok(Instruction {
                direction: strs[0].parse()?,
                amount: strs[1].parse()?,
            })
        })
        .collect()
}

fn part_one(instructions: &[Instruction]) -> i32 {
    let mut horizontal_position = 0;
    let mut depth = 0;

    for instruction in instructions.iter() {
        match instruction.direction {
            Direction::Down => depth += instruction.amount,
            Direction::Up => depth -= instruction.amount,
            Direction::Forward => horizontal_position += instruction.amount,
        }
    }

    horizontal_position * depth
}

fn part_two(instructions: &[Instruction]) -> i32 {
    let mut horizontal_position = 0;
    let mut depth = 0;
    let mut aim = 0;

    for instruction in instructions.iter() {
        match instruction.direction {
            Direction::Down => aim += instruction.amount,
            Direction::Up => aim -= instruction.amount,
            Direction::Forward => {
                horizontal_position += instruction.amount;
                depth += aim * instruction.amount;
            }
        }
    }

    horizontal_position * depth
}

#[derive(Error, Debug)]
enum Error {
    #[error("could not parse `{0}` into `Direction`")]
    ParseDirectionError(String),
    #[error(transparent)]
    ParseInt(#[from] num::ParseIntError),
    #[error(transparent)]
    Io(#[from] io::Error),
}

fn run() -> Result<(), Error> {
    let instuctions = parse_input(&mut read_input()?)?;
    dbg!(part_one(&instuctions));
    dbg!(part_two(&instuctions));
    Ok(())
}

fn main() {
    run().unwrap();
}

#[cfg(test)]
mod tests {
    use crate::{parse_input, part_one, part_two, Direction, Instruction};

    const TEST_INPUT: &str = "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2";

    #[test]
    fn test_parse() {
        let parsed = parse_input(&mut TEST_INPUT.as_bytes()).unwrap();
        assert_eq!(
            parsed,
            vec![
                Instruction {
                    direction: Direction::Forward {},
                    amount: 5
                },
                Instruction {
                    direction: Direction::Down {},
                    amount: 5
                },
                Instruction {
                    direction: Direction::Forward {},
                    amount: 8
                },
                Instruction {
                    direction: Direction::Up {},
                    amount: 3
                },
                Instruction {
                    direction: Direction::Down {},
                    amount: 8
                },
                Instruction {
                    direction: Direction::Forward {},
                    amount: 2
                }
            ]
        )
    }

    #[test]
    fn test_part_one() {
        let instructions = parse_input(&mut TEST_INPUT.as_bytes()).unwrap();
        assert_eq!(part_one(&instructions), 150);
    }

    #[test]
    fn test_part_two() {
        let instructions = parse_input(&mut TEST_INPUT.as_bytes()).unwrap();
        assert_eq!(part_two(&instructions), 900);
    }
}
