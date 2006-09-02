From: Bodo Thiesen <bothie@gmx.de>
Subject: RAID6 Problem (in conjunction with nested LVM and encryption)
Date: Sun, 3 Sep 2006 01:21:18 +0200
Message-ID: <20060903012118.3e0b7485@30_bodo.rupinet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello GABELN

I have a really really big problem. In fact, the problem is the output of 
mdadm --examine as shown on http://nomorepasting.com/paste.php?pasteID=68021

I have no idea wether

-> it's being save to just use this setup (I don't trust it).
-> it's save to just mdadm --create the arrays using exact the same command 
   line as before.

But even very important:

-> how to PREVENT this from happening again.

BTW: We were using kernel 2.6.16.18

Regards, Bodo

PS: Please keep me on CC until I tell otherwise, as I tried to subscribe the 
    mailing list, but I don't know, if that worked, the response was 
    somewhat "nothing-saying"

(The following of this post only describes the initial setup of the raid, 
and the steps made in preparation to replace the failed disk. 
Theoretically, this shouldn't be neccessary for the problem, but it *may* 
help understanding the structure)

Initial creation of the LVM-AES-RAID6-LVM construction
======================================================

Initial condition was: We have three disks of different sizes and three 
disks of same size. We did experience data loss by failing disks in the 
past and wanted to prevent this from happening again. And we wanted to 
waste as less space as possible. And last but not least, we wanted to be 
able to extend the system later without the need to buy enough disks to 
create a completely new raid array. The solution: make partitions, take the 
partitions as raid components build up more than one raid and put all raids 
as PVs (physical volumes) in a VG (volume group). Just for some little 
security concerns, we decided to encrypt the stuff in the process. 
Additionally, we decided to make the partitioning of the physical disks by 
using lvm. That was because we are now completely independend from the 
names, the kernels assigns to ours disks (e.g. logical volume bob will 
remain being logical volume bob wether the disk is connected hda, or hdb or 
hdc ...).

The disks
=========

The system disks (hda, ~100GB) contains our root, which remained on that 
disk [~40GB] the rest [~60GB] was used for the raid things as well. In the 
rest of this post, hda refers to that ~60GB partition only, and not to the 
entire disk.

pdn |  ldn  | pds | csr1 csr2 csr3 csr4
hdc | raida | 180 | 90.4  75   --   --
hdd | raidb | 160 | 90.4  --   57   --
sdb | raidc | 300 | 90.4  75   57   57
sdc | raidd | 300 | 90.4  75   57   57
sda | raide | 300 | 90.4  75   57   57
hda | raidf | 100 |                 57
hdb | raidg | 200 |       75   57   57

This table shows: The physical name (pdn) at the time of creation of the 
setup, the assigned logical name (ldn), the size (pds) and the sizes of the 
parts later used for the raids (csr<y>).

The process of creating the setup
=================================

The following description assumes, that no data needs to be rescued. In 
fact it was a little bit more complicated, as we had to copy our data to 
the newly created raids in the process. And of course, we worked with 
degraded Arrays at that time, e.g. the start was to create the first 90.4GB 
component size raid with only three disks (the sd* disks were new brought 
at that time). Only later in the process, we added one disk after the 
other to the arrays until we ended up in the current setup (5 disks each 
array).

# for each disk: pvcreate -M2 $disk
# for each disk: vgcreate -s32k raid<x>
  * any <x> was used only for one $disk, so each raid<x> is unique.
# for each component: lvcreate -L|-l ... -n raid<x><y> raid<x>
  * <y> is the raid number (later leading to md<y> the component was 
    allocated for.)
# for each component: \
	cryptsetup using key "<x><y>:$userkey" raid<x><y> -> craid<x><y>
# for each raid: \
	mdadm --create /dev/md<y> --chunk=32 --spare-devices=0 --level=6 \
	--raid-devices=5 /dev/mapper/craid*<y>
# for each raid: pvcreate -M2 /dev/md<y>
# vgcreate -s32k platz /dev/md1
  * "Platz" is German for "space" ;)
# for each raid except 1: vgextend platz /dev/md<y>
# for each desired filesystem: lvcreate -l ... platz -n <filesystem> \
	&& mke2fs -j /dev/platz/<filesystem> -m 0 -E tride=8 -N ...

-- 
VGER BF report: U 0.500476
