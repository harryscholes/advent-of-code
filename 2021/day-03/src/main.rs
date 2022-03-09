use std::{
    collections::HashMap,
    fs::File,
    io::{self, BufRead, BufReader},
    num,
};

use thiserror::Error;

fn read_input() -> Result<Vec<String>, Error> {
    let file = File::open("input.txt")?;
    let buf = BufReader::new(file);
    buf.lines().map(|l| Ok(l?)).collect()
}

#[derive(Debug, PartialEq)]
struct Input {
    numbers: Vec<String>,
    ones: HashMap<usize, usize>,
    bits: usize,
}

fn parse_input(lines: &[String]) -> Input {
    let mut ones = HashMap::new();

    for line in lines.iter() {
        for (i, c) in line.chars().enumerate() {
            if c == '1' {
                let v = ones.entry(i).or_insert(0);
                *v += 1;
            }
        }
    }

    Input {
        numbers: lines.to_vec(),
        ones,
        bits: lines[0].chars().count(),
    }
}

fn gamma_rate(input: &Input) -> usize {
    let mut gamma = 0;

    for bit in 0..input.bits {
        let bit_count = *input.ones.get(&bit).unwrap();

        if bit_count > input.numbers.len() - bit_count {
            gamma = set_bit(gamma, input.bits - bit - 1);
        }
    }

    gamma
}

fn epsilon_rate(input: &Input) -> usize {
    let mut epsilon = 0;

    for bit in 0..input.bits {
        let bit_count = *input.ones.get(&bit).unwrap();

        if bit_count < input.numbers.len() - bit_count {
            epsilon = set_bit(epsilon, input.bits - bit - 1);
        }
    }

    epsilon
}

fn set_bit(x: usize, bit: usize) -> usize {
    x | 1 << bit
}

fn oxygen_generator_rating(input: &Input) -> usize {
    let mut numbers = input.numbers.clone();

    for bit in 0..input.bits {
        let input = parse_input(&numbers);

        let bit_count = *input.ones.get(&bit).unwrap();

        let bit_value = if bit_count < input.numbers.len() - bit_count {
            '0'
        } else {
            '1'
        };

        numbers = numbers
            .into_iter()
            .filter(|x| x.chars().collect::<Vec<_>>()[bit] == bit_value)
            .collect();

        if numbers.len() == 1 {
            break;
        }
    }

    usize::from_str_radix(&numbers[0], 2).unwrap()
}

fn co2_scrubber_rating(input: &Input) -> usize {
    let mut numbers = input.numbers.clone();

    for bit in 0..input.bits {
        let input = parse_input(&numbers);

        let bit_count = *input.ones.get(&bit).unwrap();

        let bit_value = if bit_count < input.numbers.len() - bit_count {
            '1'
        } else {
            '0'
        };

        numbers = numbers
            .into_iter()
            .filter(|x| x.chars().collect::<Vec<_>>()[bit] == bit_value)
            .collect();

        if numbers.len() == 1 {
            break;
        }
    }

    usize::from_str_radix(&numbers[0], 2).unwrap()
}

fn part_one(input: &Input) -> usize {
    let gamma = gamma_rate(&input);
    let epsilon = epsilon_rate(&input);

    gamma * epsilon
}

fn part_two(input: &Input) -> usize {
    let oxygen = oxygen_generator_rating(&input);
    let co2 = co2_scrubber_rating(&input);

    oxygen * co2
}

#[derive(Error, Debug)]
enum Error {
    #[error(transparent)]
    ParseInt(#[from] num::ParseIntError),
    #[error(transparent)]
    Io(#[from] io::Error),
}

fn main() {
    let input = parse_input(&read_input().unwrap());
    dbg!(part_one(&input));
    dbg!(part_two(&input));
}

#[cfg(test)]
mod tests {
    use std::collections::HashMap;

    use crate::{
        co2_scrubber_rating, epsilon_rate, gamma_rate, oxygen_generator_rating, parse_input, Input,
    };

    const TEST_INPUT: &str =
        "00100\n11110\n10110\n10111\n10101\n01111\n00111\n11100\n10000\n11001\n00010\n01010";

    #[test]
    fn test_parse() {
        let parsed = parse_input(&test_input());

        let mut m = HashMap::new();
        m.insert(0, 7);
        m.insert(1, 5);
        m.insert(2, 8);
        m.insert(3, 7);
        m.insert(4, 5);

        let expected = Input {
            numbers: TEST_INPUT.split("\n").map(|s| s.to_string()).collect(),
            ones: m,
            bits: 5,
        };

        assert_eq!(parsed, expected);
    }

    #[test]
    fn test_part_one() {
        let input = parse_input(&test_input());
        assert_eq!(gamma_rate(&input), 22);
        assert_eq!(epsilon_rate(&input), 9);
    }

    #[test]
    fn test_part_two() {
        let input = parse_input(&test_input());
        assert_eq!(oxygen_generator_rating(&input), 23);
        assert_eq!(co2_scrubber_rating(&input), 10);
    }

    fn test_input() -> Vec<String> {
        TEST_INPUT
            .split("\n")
            .map(|s| s.to_string())
            .collect::<Vec<_>>()
    }
}
