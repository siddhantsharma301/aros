#![no_main]
sp1_zkvm::entrypoint!(main);

use hex_literal::hex;
use p256::ecdsa::{signature::Verifier, Signature, VerifyingKey};
use p256::EncodedPoint;

// public key is 04278497923a1ac10241832c111b95604202d1528295a55831e1e900eafd59a0c588e737d24623cc5e195443cccd87133cac5cca523ea19767ed38f6fd9ae6e666
// private key is f9c0f1127d68262fcd532d87637fa8a2cf6e8d5af48380c14ff5c6d0301f6397

fn main() {
    let public_key_hex = hex!("04278497923a1ac10241832c111b95604202d1528295a55831e1e900eafd59a0c588e737d24623cc5e195443cccd87133cac5cca523ea19767ed38f6fd9ae6e666"); // Public key should start with '04' followed by the x and y coordinates
    let signature_hex = hex!("30460221008b7a36a9a9bb5585ec1dea15af12e5c94ce7f0bda9a078c8729e8f8cc53285ec02210087b4582d1c189c9c8a0fc4eae414d63ea50e2f1047cc8465fe3b8e0345d4be0d"); // DER-encoded signature
    let message = b"aaa";

    // Decode the public key
    let verifying_key = VerifyingKey::from_encoded_point(
        &EncodedPoint::from_bytes(&public_key_hex).expect("Invalid public key"),
    )
    .expect("Failed to create verifying key");

    // Decode the signature
    let signature = Signature::from_der(&signature_hex).expect("Invalid signature format");

    // Verify the signature
    verifying_key
        .verify(message, &signature)
        .expect("Signature verification failed");

    println!("Signature verified successfully!");
}
