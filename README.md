# Smart Contracts for Supply Chains

## Inspiration
We increasingly demand more of our supply chains: is the down feathers use in my winter jacket ethically sourced; are these coffee beans "Fair Trade"; is this iPhone being manufactured using recycled materials and renewable energy?
There are so many questions just looking at our day-to-day retail products.
Yet in the very globalized era, the traceability and transparency of products is far from transparent.
As products change hands

## What it does
For this project, I scoped it to focus solely on the smart contract: no fancy website or UI/UX.
Using the [Clarity language](https://docs.blockstack.org/write-smart-contracts/overview) designed by Blockstack, I use "decidable smart contract language...to encode essential business logic on a blockchain".

## How I built it
Eventually, I followed the [vanilla tutorial](https://docs.blockstack.org/write-smart-contracts/hello-world-tutorial) and modified it for my needs.
The community and Joe Bender pointed me to great resources and existing contracts that I could modify / use as inspiration to build for my needs.
I incrementally developed functionality and tested by using the TS APIs using Node and Mocha.

## Challenges I ran into
I started out trying build and testing using a test network or ["testnet"](https://www.blockstack.org/testnet), however mid-Saturday I realized that this was no longer the best supported / recommended approach (again, thanks goes out to the Blockstack support team and Joe Bender).
I then pivoted to using the [Clarity.Tools](https://clarity.tools/) online REPL to test Clarity syntax and started to realize that there were some red-herrings and fully transitioned to local development.

## Accomplishments that I'm proud of
I now feel much more comfortable with smart contracts as a concept.
Relearned LISP-like syntax and functional programming paradigms, which it seems is what Clarity is based on.
Worked quite closely with members of the Clarity community, learning more about their APIs and infrastructure.
Built a smart contract to simulate supply chains! 

## What I learned

### Technical
Clarity is a really interesting approach / take on smart contracts and learned a lot about the Clarity language, tools that are offered, and how to debug errors and incrementally build features
Fungible and non-fungible tokens and how smart contracts can be written to model real-world problems

### Non-technical
Not being afraid to give up on an approach and try something new
Asking for help and reaching out to really awesome, really experienced people in the community

## What's next for Smart Contracts for Supply Chains
Building out the test suite and fixing bugs in order to prove the viability of the Clarity contract.

