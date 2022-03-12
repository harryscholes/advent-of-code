use std::{
    io::{self, BufRead},
    num,
};
use thiserror::Error;
use utils::read_input;

fn parse_input(buf: &mut dyn BufRead) -> Result<Vec<i32>, Error> {
    buf.lines().map(|l| Ok(l?.parse()?)).collect()
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

fn run() -> Result<(), Error> {
    let depths = parse_input(&mut read_input()?)?;
    dbg!(part_one(&depths));
    dbg!(part_two(&depths));
    Ok(())
}

fn main() {
    run().unwrap();
}

#[cfg(test)]
mod tests {
    use crate::{parse_input, part_one, part_two};

    const TEST_INPUT: &str = r#"199
200
208
210
200
207
240
269
260
263"#;

    #[test]
    fn test_part_one() {
        let input = parse_input(&mut TEST_INPUT.as_bytes()).unwrap();
        assert_eq!(part_one(&input), 7);
    }

    #[test]
    fn test_part_two() {
        let input = parse_input(&mut TEST_INPUT.as_bytes()).unwrap();
        assert_eq!(part_two(&input), 5);
    }
}
