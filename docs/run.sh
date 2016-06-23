在os1中
export ODP_PLATFORM_PARAMS="-c 7 " 用3个core, "-c 7 --dune "  用3个core且是dune模式

odp_l2fwd -i 0,1 用0,1两个网卡




在os2中设置环境
os@os-2 ~/ix (vfio*) $ more setup_nic.sh 
#!/bin/bash

sudo modprobe -r ixgbe
sudo modprobe ixgbe
sleep 3
sudo ip addr add 192.168.12.2/24 dev enp4s0f0
sudo arp -s 192.168.12.1 00:16:31:ff:a6:b6

sudo tcpdump -i enp4s0f1 监听第二个端口



然后在tcpdump的输出中就可以看到输出了
