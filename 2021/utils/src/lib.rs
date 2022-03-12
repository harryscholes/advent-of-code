use std::{
    fs::File,
    io::{BufReader, Error},
};

pub fn read_input() -> Result<BufReader<File>, Error> {
    let file = File::open("input.txt")?;
    Ok(BufReader::new(file))
}
