From: Michal Soltys <nozo@ziu.info>
Subject: udev events or vgscan on raid partitions right after assembly (delay
 bug?)
Date: Sun, 11 Nov 2007 00:57:32 +0100
Message-ID: <4736456C.4020002@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Originally I've thought, that delayed uevents regarding raid partitions were 
not related to md. To recap: if we assemble some md array as partitionable 
array, add/change uevents regarding its partitions will not happen right 
after assembly, only after next array related operation (mdadm -D, fdisk, 
etc.). Similar thing happen when array is being stopped - remove uevents for 
partitions will happen later. I made a post some time ago about it.


But now I have noticed, that analogus thing happens in the latest LVM 
(2.02.29) - as it got the ability to use sysfs data to choose which devices 
to consider during vgscan.

Now - if we're fresh after assembling some array as partitionable raid, and 
on one of the partitions there is lvm group - vgscan -ay will not find any 
lvm group on that partition.

It will find it during second attempt though, or if there was some array 
related operation, i.e. -

fdisk /dev/md/d0
mdadm -D /dev/md/d0

- were ran after the assembly. Or if using sysfs is explicitely prohibited 
in lvm.conf (sysfs_scan = 0), so it will consider all the nodes under /dev 
as per lvm.conf, without using /sys/block as a hint.

If to peek into /sys/block/md* right after the assembly of the array, 
there're no partition related directories. For example, if mdadm -As 
assembles /dev/md/d0 with (already present) 4 partitions, /sys/block/md_d0 
will have no md_d0p{1,2,3,4} dirs after the command. They will show up after 
next array related command.

Analogously, if we stop the array with mdadm -S /dev/md/d0 , partitions will 
remain until i.e. repeated mdadm -S /dev/md/d0

I'm not sure if this is the proper place to report this kinda of things 
(maybe to kernel list ?), but I believe it to be sort of a bug. Any i.e. 
hotplugged hard drive with partitions won't have those issues, be it udev, 
lvm, etc.

