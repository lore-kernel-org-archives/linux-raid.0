From: Thomas Andrews <tandrews@grok.co.za>
Subject: One partition degraded after every reboot
Date: Fri, 26 Mar 2004 17:41:25 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040326154125.GN1950@gaspode.nextlink.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I've set up RAID-1 on a pair of disks recently. When I reboot I get this
in syslog, even though the partition was perfect & not degraded before:

kernel:  /dev/ide/host2/bus0/target0/lun0: p1 < p5 p6 p7 p8 > p2 p3
kernel:  /dev/ide/host2/bus1/target0/lun0: p1 < p5 p6 p7 p8 > p2 p3
kernel:  [events: 0000001c]
kernel: md: bind<ide/host2/bus1/target0/lun0/part5,1>
kernel: md: ide/host2/bus1/target0/lun0/part5's event counter: 0000001c
kernel: md1: former device ide/host2/bus0/target0/lun0/part5 is unavailable, removing from array!

More specifically, of the 4 RAID-1 partitions, md1 (my root partition)
is in degraded mode. Here's a snippet of /proc/mdstat:

md1 : active raid1 ide/host2/bus1/target0/lun0/part5[0]
      38957440 blocks [2/1] [U_]

All the RAID partitions are of type FD on both disks, and the disks are
brand new. I swapped out the 'offending' disk with another brand new
disk, but it made no difference.

This is a stock Debian/testing pc running a stock 2.4.24-1-686 kernel.
I use mdadm. Initially I thought that it was grub messing things up, but
I'm booting from a floppy now, and I haven't bothered to intall grub on
the newer disk.

To recommission partition on the previous disk, I used 
mdadm --zero-superblock /dev/hde5
mdadm /dev/md1 -a /dev/hde5
This set things right, and there were no problems until the next reboot.
The process is totally repeatable.

What am I missing here ?

Why does it say "device ide/host2/bus0/target0/lun0/part5 is unavailable"
in the log ??

