# Transfers
AMBA allows a series of transfers. We will be implementing most of them. 

This exists as a summary of the different transfers our bus can perform.

There are two types of transfers, conceptually:
  - Basic
  - Burst

<!-- TODO decide on split transfers -->

---

- [Basic Transfers](#basic-transfers)
  - [Simple Transfer](#simple-transfer)
- [Burst Transfers](#burst-transfers)
  - [Incrementing Bursts](#incrementing-bursts)
  - [Wrapping Bursts](#wrapping-bursts)
- [Idle Transfers](#idle-transfers)
- [Busy Transfer](#busy-transfer)
- [Non-Sequential Transfer](#non-sequential-transfer)
- [Sequential Transfer](#sequential-transfer)

---

## Basic Transfers
The most basic type of transfer possible: request and send.

### Simple Transfer
In a simple transfer with no wait states:
- The manager drives the address and control signals onto the bus after the 
  rising edge of the clock

- The subordinate samples the address and control information on the next
  rising edge

- After that, the subordinate will start to drive the response which is sampled
  by the manager on the third rising edge of the clock

## Burst Transfers
- Burst transfers happen when you move data repeatedly using the same state as 
  the initial transfer

- Bursts happen in "beats", which is AMBA for "number of transfers". Beats of 
  4, 8, or 16 are defined by AHB

- For bursts, the transfer size is the total number of bytes in the transfer,
  which is the product of size and beats

- AHB also defines undefined-length bursts and single transfers
  - Single transfers are treated as bursts of one

- AMBA AHB allows two different burst transfers:
  - Incrementing bursts, which do not wrap at boundaries
  - Wrapping bursts, which wrap at particular address boundaries

- Burst information is provided by `burst[2:0]`, with 8 possible values

  | burst[2:0] | Type           |
  | :--------: | -------------- |
  |   0b000    | Single         |
  |   0b001    | Undefined Incr |
  |   0b010    | Wrap 4         |
  |   0b011    | Incr 4         |
  |   0b100    | Wrap 8         |
  |   0b101    | Incr 8         |
  |   0b110    | Wrap 16        |
  |   0b111    | Incr 16        |

- Bursts must not cross a 1kB (kilobyte) boundary

### Incrementing Bursts
- Access sequential locations and the address of each transfer in the burst is
  just an increment of the previous address

### Wrapping Bursts
- If the start address of the transfer is not aligned to the total size of the
  burst, then the address of the transfers in the burst will wrap when the
  boundary is reached
  - A four beat wrapping burst of word accesses will wrap at 8-byte boundaries
  - Total size of the transfer = 4 beats * word = 4 * 2 = 8
  - If the starting address of the transfer is 0x34 then, the burst consists
    of four transfers:
    - 0x34 -> 0x37
    - 0x38 -> 0x3b
    - 0x3c -> 0x3f
    - 0x40 -> 0x43

---

The two fundamental transfers can further be divided to make a total of four
main types of transfers, which the `trans` signal expresses: idle, busy,
non-sequential, sequential. 

For each of these, manager and subordinate behaviour is enumerated.

---

## Idle Transfers 
- `trans = 2'b00`

#### Manager
- No transfer of data
- Used when a bus is granted access to the bus, but doesn't want to perform data
  transfers

#### Subordinate
- Subordinates must provide a zero-wait-state okay response to these
- Subordinates must ignore these transfers

## Busy Transfer
- `trans = 2'b01`
- Allows the manager to insert Idle cycles in the middle of bursts of transfers

#### Manager
- Indicates that the bus is continuing with a burst of transfers, but the next
  transfer cannot happen immediately
- The address and control signals must reflect the next transfer in the burst

#### Subordinate
- Subordinates must provide a zero-wait-state okay response to these
- Subordinate must ignore these transfers

## Non-Sequential Transfer
- `trans = 2'b10`
- Indicates the *first* transfer of a burst or single transfer
- Single transfers are treated as bursts of one, therefore the transfer type is 
  "non-sequential"

#### Manager
- Address and control signals are unrelated to the previous transfer

#### Subordinate
- Subordinate provides appropriate responses to these
- Subordinate doesn't ignore these

## Sequential Transfer
- `trans = 2'b11`
- Indicates the *remaining* transfers in a burst
- In case of wrapping bursts, the address of the transfer wraps at the address 
  boundary equal to the size (in bytes) multiplied by the number of beats in
  the transfer (4, 8, or 16)

#### Manager
- Control information is identical to previous transfers
- Address is equal to the address of the previous transfer + size of previous
  transfer; for example:
  - Previous address: 0xF12
  - Previous size: 4 bytes
  - Address = 0xF16

#### Subordinate
- Subordinate provides appropriate responses to these
- Subordinate doesn't ignore these