export RTE_SDK=/home/os/chy/dpdk-git
export RTE_TARGET=x86_64-native-linuxapp-gcc
sudo echo 1024 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
sudo modprobe uio_pci_generic
# FOR dune, run dune/run.sh	
# FOR opendp
export RTE_ANS=/home/os/chy/dpdk-ans

