use std::{
    fmt,
    fs::File,
    io::{self, BufRead, BufReader},
    num,
    str::FromStr,
};

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
            _ => Err(Error::ParseDirectionError {}),
        }
    }
}

#[derive(Debug)]
enum Error {
    ParseDirectionError,
    ParseIntError(num::ParseIntError),
    IoError(io::Error),
}

impl std::error::Error for Error {}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.to_string())
    }
}

impl From<num::ParseIntError> for Error {
    fn from(e: num::ParseIntError) -> Self {
        Error::ParseIntError(e)
    }
}

impl From<io::Error> for Error {
    fn from(e: io::Error) -> Self {
        Error::IoError(e)
    }
}

fn read_input() -> Result<Vec<String>, Error> {
    let file = File::open("input.txt")?;
    let buf = BufReader::new(file);
    buf.lines().map(|l| Ok(l?)).collect()
}

fn parse_input(lines: &[String]) -> Result<Vec<Instruction>, Error> {
    lines
        .iter()
        .map(|s| {
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

fn main() {
    let input = read_input().unwrap();
    let instuctions = parse_input(&input).unwrap();
    dbg!(part_one(&instuctions));
    dbg!(part_two(&instuctions));
}

#[cfg(test)]
mod tests {
    use crate::{parse_input, part_one, part_two, Direction, Instruction};

    const TEST_INPUT: &str = "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2";

    #[test]
    fn test_parse() {
        let parsed = parse_input(&test_input()).unwrap();
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
        let instructions = parse_input(&test_input()).unwrap();
        assert_eq!(part_one(&instructions), 150);
    }

    #[test]
    fn test_part_two() {
        let instructions = parse_input(&test_input()).unwrap();
        assert_eq!(part_two(&instructions), 900);
    }

    fn test_input() -> Vec<String> {
        TEST_INPUT
            .split("\n")
            .map(|s| s.to_string())
            .collect::<Vec<_>>()
    }
}