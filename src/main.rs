use warp::Filter;
use std::process::Command;
use std::str;

#[tokio::main]
async fn main() {
    // Define the `temporal` endpoint
    let temporal = warp::path!("temporal" / u32)
        .map(|length: u32| {
            // Calculate the number of hex digits
            let num_digits = length * 2;
            
            // Call the binary executable
            let output = Command::new("temporal")
                .arg("hexdump")
                .arg("0")
                .arg(num_digits.to_string())
                .output()
                .expect("Failed to execute process");

            // Convert the output to a string
            let hex_string = str::from_utf8(&output.stdout)
                .unwrap_or("Error converting output")
                .trim()
                .to_string();
            
            // Return the result as a JSON string
            warp::reply::json(&hex_string)
        });

    // Start the warp server
    warp::serve(temporal)
        .run(([0, 0, 0, 0], 3333))
        .await;
}