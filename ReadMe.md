# NYU AMBA

The Advanced Microcontroller Bus Architecture (AMBA) is an open-source standard
engineered by ARM. It provides specifications for on-chip interconnection and
management of various functional blocks on the SoC. 

This repo implements the portions of the AMBA used by the NYU Processor design
team, specifically AHB, APB, and an APB Bridge device, following the AMBA 5
specification

## Advanced High-performance Bus (AHB)
The AHB acts as the backbone of the chip, allowing efficient, fast connections 
on the chip. It supports multiple bus managers, but we only implement one for
now. 

### Components

#### Manager
- Initiates read and write operations
- Provides address and control information

#### Subordinate
- Responds to the read/write operation from the manager within a given 
  address space
- Signals back to the master for success, failure, or data transfer await

#### MUX
- Routes the read data and response signals to from the subordinates 
  to the master

#### Decoder
- Decodes the address of each transfer
- Provides a select signal for the subordinate involved in a transaction
- The decoder is a centralised component

## Advanced Peripheral Bus (APB)
The APB is for low-power peripherals, facilitating low-bandwidth access 
control. It acts as the secondary bus to the AHB, providing interface 
for peripherals

## APB Bridge
- APB interfaces with the AHB using the APB Bridge, which handles the handshake
  and control signal remitting
- APB implementations contain a single bridge which converts AHB transfers into
  a suitable format for peripherals on the APB.

## Further Reading
Rishyak's notes about each component are in the [docs directory](https://github.com/NYU-Processor-Design/nyu-amba/tree/main/docs).

However, if you prefer to read from source[^note]:
- [Official AMBA AHB specification](https://developer.arm.com/documentation/ihi0011/a/AMBA-AHB)
- [Official AMBA APB specification](https://developer.arm.com/documentation/ihi0011/a/AMBA-APB)
- [Official ARM documentation page](https://developer.arm.com/documentation)

<!-- Footnotes -->

[^note]: There are some mistakes in the documentation, such as misinterpreting
the size of a "word" or switching out similar words, so use your best 
judgement when reading them. <sub>It seems like the person got increasingly
tired, because these mistakes get worse the further you read.</sub>