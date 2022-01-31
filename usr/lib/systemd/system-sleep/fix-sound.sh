#!/bin/bash

set -xeuo pipefail

# For reasons I cannot explain, piping lsmod to grep -q here randomly fails sometimes. Some kind of output buffering bug
# in lsmod?
lsmod=$(lsmod)

if grep -q snd_soc_acp5x_mach <<< "$lsmod"; then
  ## EV2 with acp5x driver
  if [[ ${1-} = "pre" ]]; then
    modprobe -r snd_pci_acp5x
  elif [[ ${1-} = "post" ]]; then
    modprobe snd_pci_acp5x
  fi
else
  ## EV1 or without acp5x driver, fixup registers manually
  if [ "${1-}" == "post" ]; then
    for i in /sys/kernel/debug/regmap/spi-VLV*; do
      /usr/lib/hwsupport/cirrus-fixup.sh $i
    done
  fi
fi
