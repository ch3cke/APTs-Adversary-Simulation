# Static Kitten APT Adversary Simulation

This is a simulation of attack by (Static Kitten) APT group targeting multiple sectors across the Middle East, including diplomatic, maritime, financial, and telecom entities. The campaign uses icon spoofing and malicious Word documents to deliver "RustyWater," a Rust-based implant representing a significant upgrade to their traditional toolkit, the attack campaign was active early as January 2026. The attackers has relied on PowerShell and VBS loaders for initial access and post-compromise operations. The introduction of Rust-based implants represents a notable tooling evolution toward more structured, modular, and low noise RAT capabilities. I relied on cloudsek to figure out the details to make this simulation: https://www.cloudsek.com/blog/reborn-in-rust-muddywater-evolves-tooling-with-rustywater-implant

![imageedit_3_7338603847](https://github.com/user-attachments/assets/3248f058-273c-423d-b323-f94099898668)


Throughout, the macro itself is heavily obfuscated to dodge static detection, and the overall chain emphasizes low-noise execution with strong anti-analysis tricks built into the Rust binary. This progression — phishing email → malicious doc → obfuscated macro dropper → RustyWater implant — shows Static Kitten's shift toward more resilient modular tooling in recent campaigns targeting Middle East sectors.

![695fae75028332920172b552_54c74b00](https://github.com/user-attachments/assets/eb4ed208-5e65-425d-9723-51639870c813)

1. Delivery Technique: Create a document file named Cybersecurity.doc, which is used in the next stage to embed and execute a VBA macro loader that extracts and drops the subsequent payload.

2. Malicious VBA macro: The malicious VBA macro embedded in the document is heavily obfuscated using string concatenation, hex-encoded payloads hidden in UserForm controls, multiple Replace() calls to strip whitespace and line breaks.

3. RustyWater implant: The final payload dropped by the obfuscated VBA macro loader is a Rust-compiled executable (disguised as reddit.exe with a fake Cloudflare icon), known as RustyWater (or linked to Archer RAT/RUSTRIC), featuring strong AV/EDR evasion through process injection, registry based persistence.

4. C2 infrastructure: relies on HTTP protocol for all communications, leveraging the Rust reqwest library with configurable timeouts, connection pooling, and retry mechanisms for reliability. Data payloads are structured as JSON, then encoded in Base64, followed by a final XOR encryption layer to obfuscate traffic and complicate analysis.

## The first stage (delivery technique)

The attack kicks off with a spear-phishing email sent from the compromised info@tmcell address a legitimate domain tied to TMCell (Altyn Asyr CJSC), Turkmenistan's main mobile telecom provider. The subject line reads "Cybersecurity Guidelines" making it look like an official advisory from a trusted source.

<img width="1600" height="354" alt="695fae75028332920172b555_a74569f3" src="https://github.com/user-attachments/assets/7be7c2f0-76d2-4271-8fb8-b10201859a29" />

The email carries an attachment named Cybersecurity.doc, which acts as the initial payload. When the recipient opens the document and enables macros (as prompted), an obfuscated VBA macro runs. This macro extracts a hex-encoded blob hidden in the document's structure (often within UserForm elements), cleans it up by stripping spaces and line breaks, converts it to binary, and drops it as CertificationKit.ini in the ProgramData folder.

<img width="584" height="585" alt="imageedit_8_8478180398" src="https://github.com/user-attachments/assets/64db8bb4-e6cb-4ae8-be91-fbd81f7bd6f2" />

## The second stage (Malicious VBA macro)




