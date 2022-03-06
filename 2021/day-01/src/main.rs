use std::{
    fmt,
    fs::File,
    io::{self, BufRead, BufReader},
    num,
};

#[derive(Debug)]
enum Error {
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

fn read_input() -> Result<Vec<i32>, Error> {
    let file = File::open("input.txt")?;
    let buf = BufReader::new(file);
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

fn main() {
    let depths = read_input().unwrap();
    dbg!(part_one(&depths));
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
