From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Pushing desktop boards to the MAX: Intel 10GbE AT2 Server
 Adapters!
Date: Thu, 25 Feb 2010 16:33:09 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002251610060.8769@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-net-owner@vger.kernel.org>
Sender: linux-net-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-net@vger.kernel.org
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Hello,

Both are running 2.6.33 x86_64:

I have two desktop motheboards:
1. Intel DP55KG
2. A Gigabyte P35-DS4

I have two 10GbE AT2 server adapters, configuration:
1. Intel DP55KG (15 Drive RAID-6) w/3ware 9650SE-16PML
2. Gigabyte P35-DS4 (softare RAID-5 across 8 disks)

When I use iperf, I get ~9-10Gbps:

Device eth3 [10.0.0.253] (1/1):
================================================================================
Incoming:                               Outgoing:
Curr: 1.10 MByte/s                      Curr: 1120.57 MByte/s
Avg: 0.07 MByte/s                       Avg: 66.20 MByte/s
Min: 0.66 MByte/s                       Min: 666.95 MByte/s
Max: 1.10 MByte/s                       Max: 1120.57 MByte/s
Ttl: 4.40 MByte                         Ttl: 4474.84 MByte

p34:~# iperf -c 10.0.0.254
------------------------------------------------------------
Client connecting to 10.0.0.254, TCP port 5001
TCP window size: 27.4 KByte (default)
------------------------------------------------------------
[  3] local 10.0.0.253 port 52791 connected with 10.0.0.254 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0-10.0 sec  10.9 GBytes  9.39 Gbits/sec
p34:~#

When I copy a large file over NFS from Gigabyte (SW) raid to the Intel
motherboard, I get what the SW raid can read at, approximately: 560MiB/s.

Here is the file: (49GB)
-rw-r--r-- 1 abc users 52046502432 2010-02-25 16:01 data.bkf

From Gigabyte/SW RAID-5 => Intel/HW RAID-6 (9650SE-16PML):
$ /usr/bin/time cp /nfs/data.bkf .
0.04user 45.51system 1:47.07elapsed 42%CPU (0avgtext+0avgdata 7008maxresident)k
0inputs+0outputs (1major+489minor)pagefaults 0swaps
=> Downloading 49000MB for 1.47 minutes is: 568889KB/s.

However, from Intel/HW RAID-6 (9650SE-16PML) => Gigabyte/SW RAID-5
$ /usr/bin/time cp data.bkf /nfs
0.02user 31.54system 4:33.29elapsed 11%CPU (0avgtext+0avgdata 7008maxresident)k
0inputs+0outputs (0major+490minor)pagefaults 0swaps
=> Downloading 49000MB for 4.33 minutes is: 193133KB/s.

When running top, I could see md raid 5 and pdflush at or near 100% CPU.
Is the problem scaling with mdadm/raid-5 on the Gigabyte motherboard?

Gigabyte: 8GB Memory & Q6600
Intel DP55KG: 8GB Memory & Core i7 870

From the kernel:
[   80.291618] ixgbe: eth3 NIC Link is Up 10 Gbps, Flow Control: RX/TX

With XFS, it used to get > 400MiB/s for writes.
With EXT4, only 200-300MiB/s:

(On Gigabyte board)
$ dd if=/dev/zero of=bigfile bs=1M count=10240
10240+0 records in
10240+0 records out
10737418240 bytes (11 GB) copied, 38.6415 s, 278 MB/s

Some more benchmarks (Gigabyte->Intel)

---- Connecting data socket to (10.0.0.254) port 51421
---- Data connection established
---> RETR CentOS-5.1-x86_64-bin-DVD.iso
<--- 150-Accepted data connection
<--- 150 4338530.0 kbytes to download
---- Got EOF on data connection
---- Closing data socket
4442654720 bytes transferred in 8 seconds (502.77M/s)
lftp abc@10.0.0.254:/r/1/iso>

CentOS DVD image in 8 seconds!

rsync is much slower:
$ rsync -avu --stats --progress /nfs/CentOS-5.1-x86_64-bin-DVD.iso  .
sending incremental file list
CentOS-5.1-x86_64-bin-DVD.iso
   4442654720 100%  234.90MB/s    0:00:18 (xfer#1, to-check=0/1)

I am using nobarrier, guess some more tweaking is required on the Gigabyte
motherboard with software raid.

For the future if anyone is wondering, the only tweak for the network 
configuration is setting the MTU to 9000 (jumbo frames, here is my entry 
for /etc/network/interfaces)

# Intel 10GbE (PCI-e)
auto eth3
iface eth3 inet static
address 10.0.0.253
network 10.0.0.0
netmask 255.255.255.0
mtu 9000

Congrats Intel for making a nice 10GbE CAT6a card without a fan!

Thank you!

Justin.

