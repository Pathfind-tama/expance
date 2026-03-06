# Adversary Leverage Detection in Cryptographic Protocols: A Tamarin-Based Formal Analysis Artifact

This repository contains the complete formal verification artifact accompanying the paper *"Automated Detection of Adversary Leverage in Cryptographic Protocols"*. We systematically model and verify adversary leverage — a class of protocol weaknesses that allows an active adversary to exploit honest participants as oracles — across a large corpus of real-world cryptographic protocols using the [Tamarin prover](https://github.com/tamarin-prover/tamarin-prover).

---

## Overview

Classical security analysis focuses on what an adversary *learns* or *impersonates*. Adversary leverage addresses a complementary and often overlooked threat: situations in which the adversary can *steer* honest protocol participants into performing cryptographic operations on adversary-chosen inputs, effectively turning them into decryption, authentication, or signing oracles.

Our formalism encodes two categories of leverage as reachability and indistinguishability queries in Tamarin:

| Category | Sub-type | Description |
|---|---|---|
| **Explicit Leverage** | Perfect Encryption | Leverage detectable under standard Dolev-Yao assumptions |
| **Explicit Leverage** | Prefix Property Encryption | Leverage detectable under extended algebraic properties (prefix-preserving encryption) |
| **Implicit Leverage** | Algebraic Property-type | Leverage that arises only when combined with specific cryptographic primitive properties |

The analysis covers **129 Tamarin models** spanning **46 protocols** across four major protocol families, plus a dedicated case study on Bluetooth SSP Passkey Entry.

---

## Repository Structure

```
.
├── Bluetooth_ssp_pw_entry/            # Bluetooth SSP Passkey Entry case study
│   ├── BluetoothSSPpwentry.spthy      # Full 20-round parallel guessing attack model
│   ├── blue.png                       # Attack trace visualization
│   └── client_session_key.aes         # Extracted session key (proof of concept)
│
├── Entity_Authentication_Protocols/   # ISO/IEC 9798 family, Woo-Lam, BREVE, BRMAP
│   ├── explicit leverage/
│   │   ├── Perfect Encryption/        # KPA v1/v3 leverage models
│   │   └── Prefix Property Encryption/# CPA v3/v4 leverage models
│   └── implicit leverage/             # Algebraic property-type leverage models
│
├── password-based_auth_and_key_establishment/  # CHAP, EAP-EKE, GLNS family
│   ├── explicit leverage/
│   │   ├── Perfect Encryption/
│   │   └── Prefix Property Encryption/
│   └── implicit leverage/             # Includes GLNS partition attack models
│
├── Server-Based_Key_Establishment_Protocols/  # Kerberos, Needham-Schroeder, Yahalom, etc.
│   ├── explicit leverage/
│   │   ├── Perfect Encryption/
│   │   └── Prefix Property Encryption/
│   └── implicit leverage/
│
├── Server-Less_Key_Establishment_Protocols/   # IKEv2, ISO 11770-2, RPC, Andrew Secure RPC
│   ├── explicit leverage/
│   │   ├── Perfect Encryption/
│   │   └── Prefix Property Encryption/
│   └── implicit leverage/             # IKEv2 prefix-encryption leverage model
│
└── README.md
```

### File Conventions

| File/Directory | Contents |
|---|---|
| `*.spthy` | Tamarin theory files encoding protocol model + leverage detection lemmas |
| `fig/` or `*.png` | Auto-generated attack trace graphs exported from Tamarin |
| `time.log` | Verification command log with wall-clock timing per lemma |
| `*.sh` | Batch verification scripts for multi-lemma experiments |

---

## Protocol Coverage

### Entity Authentication Protocols
ISO/IEC 9798-2 (Mechanisms 1–4), ISO/IEC 9798-4 (Mechanisms 1–3), Woo-Lam, BREVE, BRMAP

### Password-Based Authentication and Key Establishment
CHAPv1, CHAPv2, EAP-EKE, GLNS (compact / nonce-based / public-key / optimal / simplified variants)

### Server-Based Key Establishment Protocols
Needham-Schroeder Symmetric, Otway-Rees (original / Burrows modification / A-N modification), Yahalom (original / Burrows modification), Denning-Sacco, Wide Mouthed Frog, Gong (nonce / timestamp variants), Bellare-Rogaway 3PKD, Janson-Tsudik 3PKDP (original / optimised), Boyd Key Agreement, Kerberos (basic)

### Server-Less Key Establishment Protocols
ISO 11770-2 (Mechanisms 1–6), IKEv2, Revised Andrew Secure RPC, RPC, Janson-Tsudik 2PKDP

### Dedicated Case Study
Bluetooth SSP Passkey Entry (20-round parallel guessing attack)

---

## Requirements

- **Tamarin Prover** version **1.10.0**
  - Installation guide: [Chapter 2 of the Tamarin Manual](https://tamarin-prover.github.io/manual/book/002_installation.html)
- Recommended: a machine with at least **8 CPU threads** and **16 GB RAM** for full batch verification
- OS: Linux or macOS (Windows via WSL2 is supported)

---

## Reproducing the Results

### Automated Batch Verification

To verify all lemmas in a given directory:

```bash
tamarin-prover --prove *.spthy
```

To reproduce results for a specific protocol category (e.g., Server-Based under Perfect Encryption):

```bash
cd "Server-Based_Key_Establishment_Protocols/explicit leverage/Perfect Encryption"
tamarin-prover --prove *.spthy
```

### Interactive Exploration

To inspect attack traces interactively via the Tamarin web interface:

```bash
tamarin-prover interactive *.spthy
```

Then open `http://localhost:3001` in your browser.

### Measuring Verification Time

To benchmark a specific theory file:

```bash
time tamarin-prover --prove <protocol>.spthy
```

To run batch timing across all models in a category (using the provided shell scripts):

```bash
bash run_all.sh
```

Timing results are recorded in the corresponding `time.log` file in each directory.

### Parallel Execution

For full-corpus verification, parallel jobs can be dispatched using:

```bash
find . -name "*.spthy" | xargs -P 8 -I{} tamarin-prover --prove {}
```

This leverages all available cores and substantially reduces total wall-clock time. Reference timing data for each individual lemma is provided in the `time.log` files.

---

## Key Results Summary

| Protocol Family | # Protocols Analyzed | Leverage Found | Leverage Type |
|---|---|---|---|
| Entity Authentication | 11 | 8 | KPA v1, KPA v3, CPA v3 |
| Password-Based Auth & KE | 8 | 7 | KPA v1/v3, CPA v3/v4, Implicit |
| Server-Based KE | 14 | 9 | KPA v1/v3, CPA v3/v4 |
| Server-Less KE | 10 | 6 | KPA v3, CPA v4, Implicit |
| Bluetooth SSP | 1 | 1 | Parallel Guessing (Implicit) |

Notable findings:
- **GLNS public-key variant**: implicit leverage enables a partition attack that recovers the server's public key with a single oracle query, bypassing the password-authenticated channel entirely.
- **Bluetooth SSP Passkey Entry**: the 20-round commit-reveal structure leaks 1 bit of the temporary key (TK) per round; our model discovers a parallel guessing strategy that significantly reduces the number of required interaction rounds.
- **IKEv2**: under prefix-preserving encryption assumptions, the responder's decryption service becomes a KPA v3 oracle, exposing a structural vulnerability relevant when non-random IVs are used.

---

## Extending the Analysis

To analyze a new protocol, create a `.spthy` file following the existing model structure:

1. Define protocol roles as multiset rewrite rules.
2. Add the adversary leverage decision rules (provided as a reusable module in each category's `explicit leverage/` directory).
3. State leverage detection as a reachability lemma (`lemma leverage_kpa_v3`) or an indistinguishability lemma (`lemma leverage_cpa_v3`).
4. Run `tamarin-prover --prove <your_protocol>.spthy`.

Refer to the existing `.spthy` files for concrete examples.

---

## License

See [LICENSE](LICENSE) for details.
