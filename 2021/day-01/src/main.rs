use std::{
    fs::File,
    io::{self, BufRead, BufReader},
};

fn read_input() -> Result<Vec<i32>, io::Error> {
    let file = File::open("input.txt")?;
    let buf = BufReader::new(file);
    let depths: Result<Vec<i32>, io::Error> = buf
        .lines()
        .map(|l| Ok(l?.parse::<i32>().unwrap()))
        .collect();
    depths
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
