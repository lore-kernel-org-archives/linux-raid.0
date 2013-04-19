From: Andrei Banu <andrei.banu@redhost.ro>
Subject: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840 PRO
Date: Sat, 20 Apr 2013 01:58:01 +0300
Message-ID: <5171CBF9.9020701@redhost.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I come to you with a difficult problem. We have a server otherwise 
snappy fitted with mdraid-1 made of Samsung 840 PRO SSDs. If we copy a 
larger file to the server (from the same server, from net doesn't 
matter) the server load will increase from roughly 0.7 to over 100 (for 
several GB files). Apparently the reason is that the raid can't write well.

Few examples:

root [~]# dd if=testfile.tar.gz of=test20 oflag=sync bs=4M
130+1 records in
130+1 records out
547682517 bytes (548 MB) copied, 7.99664 s, 68.5 MB/s

And 10-20 seconds later I try the very same test:

root [~]# dd if=testfile.tar.gz of=test21 oflag=sync bs=4M
130+1 records in / 130+1 records out
547682517 bytes (548 MB) copied, 52.1958 s, 10.5 MB/s

A different test with 'bs=1G'
root [~]# w
  12:08:34 up 1 day, 13:09,  1 user,  load average: 0.37, 0.60, 0.72

root [~]# dd if=testfile.tar.gz of=test oflag=sync bs=1G
0+1 records in / 0+1 records out
547682517 bytes (548 MB) copied, 75.3476 s, 7.3 MB/s

root [~]# w
  12:09:56 up 1 day, 13:11,  1 user,  load average: 39.29, 12.67, 4.93

It needed 75 seconds to copy a half GB file and the server load 
increased 100 times.

And a final test:

root@ [~]# dd if=/dev/zero of=test24 bs=64k count=16k conv=fdatasync
16384+0 records in / 16384+0 records out
1073741824 bytes (1.1 GB) copied, 61.8796 s, 17.4 MB/s

This time the load spiked to only ~ 20.

A few other peculiarities:

root@ [~]# hdparm -t /dev/sda
Timing buffered disk reads:  654 MB in  3.01 seconds = 217.55 MB/sec
root@ [~]# hdparm -t /dev/sdb
Timing buffered disk reads:  272 MB in  3.01 seconds =  90.44 MB/sec

The read speed is very different between the 2 devices (the margin is 
140%) but look what happens when I run it with --direct:

root@ [~]# hdparm --direct -t /dev/sda
Timing O_DIRECT disk reads:  788 MB in  3.00 seconds = 262.23 MB/sec
root@ [~]# hdparm --direct -t /dev/sdb
Timing O_DIRECT disk reads:  554 MB in  3.00 seconds = 184.53 MB/sec

So the hardware seems to sustain speeds of about 200MB/s  on both 
devices but it differs greatly.
The measurement of sda increased 20% but sdb doubled. Maybe there's a 
problem with the page cache?

BACKGROUND INFORMATION
Server type: general shared hosting server (3 weeks new)
O/S: CentOS 6.4 / 64 bit (2.6.32-358.2.1.el6.x86_64)
Hardware: SuperMicro 5017C-MTRF, E3-1270v2, 16GB RAM, 2 x Samsung 840 
PRO 512GB
Partitioning: ~ 100GB left for over-provisioning, ext 4:

I believe it is aligned:

root [~]# fdisk -lu

Disk /dev/sda: 512.1 GB, 512110190592 bytes
255 heads, 63 sectors/track, 62260 cylinders, total 1000215216 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00026d59

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048     4196351     2097152   fd  Linux raid 
autodetect
Partition 1 does not end on cylinder boundary.
/dev/sda2   *     4196352     4605951      204800   fd  Linux raid 
autodetect
Partition 2 does not end on cylinder boundary.
/dev/sda3         4605952   814106623   404750336   fd  Linux raid 
autodetect

Disk /dev/sdb: 512.1 GB, 512110190592 bytes
255 heads, 63 sectors/track, 62260 cylinders, total 1000215216 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0003dede

    Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     4196351     2097152   fd  Linux raid 
autodetect
Partition 1 does not end on cylinder boundary.
/dev/sdb2   *     4196352     4605951      204800   fd  Linux raid 
autodetect
Partition 2 does not end on cylinder boundary.
/dev/sdb3         4605952   814106623   404750336   fd  Linux raid 
autodetect

The matrix is NOT degraded:

root@ [~]# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdb2[1] sda2[0]
       204736 blocks super 1.0 [2/2] [UU]
md2 : active raid1 sdb3[1] sda3[0]
       404750144 blocks super 1.0 [2/2] [UU]
md1 : active raid1 sdb1[1] sda1[0]
       2096064 blocks super 1.1 [2/2] [UU]
unused devices: <none>

Write cache is on:

root@ [~]# hdparm -W /dev/sda
write-caching =  1 (on)
root@ [~]# hdparm -W /dev/sdb
write-caching =  1 (on)

SMART seems to be OK:
SMART overall-health self-assessment test result: PASSED (for both devices)

I have tried changing IO scheduler with NOOP and deadline but I couldn't 
see improvements.

I have tried running fstrim but it errors out:

root [~]# fstrim -v /
fstrim: /: FITRIM ioctl failed: Operation not supported

So I have changed /etc/fstab to contain noatime and discard and rebooted 
the server but to no avail.

I no longer know what to do. And I need to come up with some sort of a 
solution (it's not reasonable nor acceptable to get at 3 digits loads 
from copying several GBs worth of file). If anyone can help me, please do!

Thanks in advance!
Andy
