use std::{
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

fn parse_input(lines: &[String]) -> Result<Vec<i32>, Error> {
    lines.iter().map(|l| Ok(l.parse()?)).collect()
}

fn part_one(depths: &[i32]) -> usize {
    depths.windows(2).filter(|v| v[1] > v[0]).count()
}

fn part_two(depths: &[i32]) -> usize {
    let triplets = depths
        .windows(3)
        .map(|v| v.iter().sum())
        .collect::<Vec<_>>();

    part_one(&triplets)
}

#[derive(Error, Debug)]
pub enum Error {
    #[error(transparent)]
    ParseInt(#[from] num::ParseIntError),
    #[error(transparent)]
    Io(#[from] io::Error),
}

fn main() {
    let input = read_input().unwrap();
    let depths = parse_input(&input).unwrap();
    // part 1
    dbg!(part_one(&depths));
    // part 2
    dbg!(part_two(&depths));
}

#[cfg(test)]
mod tests {
    use crate::{part_one, part_two};

    const TEST_INPUT: [i32; 10] = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263];

    #[test]
    fn test_part_one() {
        assert_eq!(part_one(&TEST_INPUT), 7);
    }

    #[test]
    fn test_part_two() {
        assert_eq!(part_two(&TEST_INPUT), 5);
    }
}
