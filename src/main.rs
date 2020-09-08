use actix_web::{App, HttpServer};
use std::net::{SocketAddr};
use std::fs;
use serde::Deserialize;

#[derive(Deserialize)]
struct Config {
    ip: String,
    port: String,
}

#[actix_rt::main]
async fn main() -> std::io::Result<()> {
    let string = fs::read_to_string("config.toml").expect("config.toml is missing");
    let config: Config = toml::from_str(&string).expect("Unable to parse config file");
    let server: SocketAddr = format!("{}:{}", config.ip, config.port).parse().expect("Unable to parse socket address");

    println!("Starting on: {}", server.to_string());

    HttpServer::new(|| {
        App::new().service(actix_files::Files::new("/", "./static").show_files_listing().index_file("index.html"))
    })
    .bind(server)?
    .run()
    .await
}