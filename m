From: Nicolae Mihalache <mache@abcpages.com>
Subject: slow sequential read on partitioned raid6
Date: Tue, 16 Mar 2010 20:05:45 +0100
Message-ID: <4B9FD689.8060700@abcpages.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have created a partitioned raid6 array over 6x1TB SATA disks using the
command (from memory): mdadm --create --auto=mdp --level=6
--raid-devices /dev/md_d1 /dev/sd[b-g].

When I run a sequential read test using
dd if=/dev/md_d1p1 of=/dev/null bs=1M
I get low read speeds of around 80MB/s but only when the partition is
mounted.

If I unmount, the speed is around 350MB/s. The filesystems I tried are
ext3 and xfs.
 
The partitions have been created with gparted, the partition table being
of type GPT.

If I create normal /dev/sdx1 partitions on each disk and then make a
/dev/md1 raid6 array over them, the read speed is ok.

I played with different read ahead settings and while they changed the
read speed, it's only marginally around the values reported above.

Can somebody explain what is the difference when accessing a raw disk
when it is mounted or not? Also when playing with those read ahead
settings it was not clear how/if the read ahead of the individual disks
are taken into account.

When setting big values of read ahead, I could see with iostat that tps
for the individual disks is double when accessing the mounted disk as
opposed to when accessing it unmounted (despite the speed being three
times lower).
It's like when accessing the mounted partition, it reads some other
parts of the disks. I could not find a way to print the blocks read from
the individual disks. The sysctl vm.block_dump=1 makes the kernel print
the block numbers on the md array but not on the components of the array.

The system is debian 5 with kernel 2.6.26-2-686.

Thanks for any hint on how to further debug the problem.

nicolae
