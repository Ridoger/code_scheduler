# Change Logs

## Fix Typo in Instruction document Section4.3:

"max(latency(I0), latency(I1)) + latency(I3) + latency(I4) = max(5, 6) + 3 + 1 = 10"

->

"max(finish_time(I0), finish_time(I1)) + latency(I3) + latency(I4) = max(5, 6) + 3 + 1 = 10"

**2026.3.14**

## Postpone Deadline

2.26 -> 3.31

**2026.3.17**

## Increase time out limit

30s -> 50s, to avoid schedule() take too long leading performance test to fail.

**2026.3.22**