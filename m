From: Philipp Gortan <gortan@chello.at>
Subject: Re: One partition degraded after every reboot
Date: Thu, 01 Apr 2004 13:45:39 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <406C00E3.4030205@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas Andrews wrote:

> I've set up RAID-1 on a pair of disks recently. When I reboot I get this
> in syslog, even though the partition was perfect & not degraded before:
> 
...
> kernel: md1: former device ide/host2/bus0/target0/lun0/part5 is unavailable, removing from array!
> 
> More specifically, of the 4 RAID-1 partitions, md1 (my root partition)
> is in degraded mode. Here's a snippet of /proc/mdstat:
> 
> md1 : active raid1 ide/host2/bus1/target0/lun0/part5[0]
>       38957440 blocks [2/1] [U_]
> 
> All the RAID partitions are of type FD on both disks, and the disks are
> brand new
...
> This is a stock Debian/testing pc running a stock 2.4.24-1-686 kernel.

Hi Andrew,
I had the same problem today, with debian/testing and both 2.4 and 2.6 
kernels.
My root filesystem, a raid 1 device would come up degraded at every 
reboot, even if it was clean on shutdown.

I solved the problem by creating a new initrd and fiddling with the lilo 
configuration:
for me,
after re-adding the always-failing drive to the raid
# mdadm -a /dev/md0 /dev/hda1
i updated my lilo.conf to:

...
boot=/dev/md0
raid-extra-boot=/dev/hda,/dev/hdc
root=/dev/md0
...


and created a new initrd
# mkinitrd -k -r /dev/md0 -o /boot/initrd.img-2.6.3-1-k7

and ran lilo again
# lilo

since that reboot, the raid comes up complete.

hope that helps,

cu, philipp

-- 
When in doubt, use brute force.

                                -- Ken Thompson
