# Aros
Aros is an iOS app that allows you to verify that an image is real and not AI-generated. It does this by cryptographically proving that you clicked an image on your iPhone, which means that the image is real. Aros is also the reverse of [Sora](https://openai.com/sora), which is what inspired this project!

## Inspiration
With the rise of AI-generated content and DeepFakes, it's hard for people to identify what's real and what's fake. This leads to fake news and abuse. After seeing the launch of OpenAI's Sora model this week, we decided to build a solution to verify whether an image is real or AI-generated.

## What it does
Aros is an iOS app that allows you to verify that an image is real and not AI-generated. It does this by cryptographically proving that you clicked an image on your iPhone, which means that the image is real.

This is how it works:
1. When you click a photo using the Aros camera app, Aros uses your iPhone's Secure Enclave to cryptographically sign this image.  
2. This signature is posted to the online Aros registry.  
3. Anyone can use this signature and your public key to verify that the photo was clicked on your iPhone, and not generated using AI.  
We also built a zero-knowledge prover that verifies the signature on your image within a ZK circuit. This allows any blockchain to easily verify that an image is real.

## How we built it
This is a system architecture diagram for Aros:

### Secure Enclave
We create a cryptographic key pair in your iPhone's Secure Enclave to rely on hardware security and ensure that your private keys are never leaked outside your iPhone. Aros uses these keys to sign your photos to prove and verify that you clicked them on your iPhone.

### Zero-Knowledge
To easily verify the image signatures on a blockchain, we decided to build a ZK verifier for this. We used state-of-the-art cryptographic systems like the SP1 RISC-V prover from Succinct Labs to verify the image signatures within a Plonky3 circuit.

### iOS App and Web Registry
We built the iOS app using Swift.

The Aros registry is used to store each image's hash and signature, along with users' public keys. It doesn't store the raw image data so we can protect privacy. We built the Aros registry using Next.js, Typescript, and Tailwind CSS. We deployed the registry dashboard and registry API using Vercel.

## Challenges we ran into
- The Secure Enclave in the iPhone uses the P-256 elliptic curve but we found it hard to find a verifier ZK circuit for this curve within Circom or Halo2. So, we decided to use the SP1 RISC-V prover from Succinct Labs to verify the image signatures and generate a Plonky3 circuit.  
- We faced challenges with base64 encoding and decoding the public key. However, we realized that we could use the base64EncodedString function in Swift to help with this.

## Accomplishments that we're proud of
- It was our first time developing on iOS and using Swift, so there was a pretty steep learning curve on the first day. We're really happy that we were able to learn Swift and iOS development over the weekend and successfully build this project.  
- It was a stretch goal for us to build a zero-knowledge verifier of the P256 signature verification. We're proud that we were able to build this, and now anyone can efficiently verify that an image is real on any blockchain as well.  

## What we learned
- In terms of technologies, we learned iOS development, Swift, and SwiftUI, and we also learned how to work with RISC-V ZK proving systems like the SP1 prover.  
- We learned about hardware security, specifically how to protect private keys using the Secure Enclave on iPhones.  

## What's next for Aros
- We want to extend this technology beyond just images, to prove that audio and video is real and not AI-generated. We have some ideas for this and we are excited to try these out soon!  
- We plan to deploy a verifier smart contract for the ZK circuit on Ethereum.  
- We hope to work with social media platforms to try to integrate our system since we think fake news and images are most prevalent on social media, and Aros can help reduce misinformation online.

## Built With
- cryptography  
- ios  
- mongodb  
- next  
- rust  
- swift  
- typescript  
- zero-knowledge  
