From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 15:02:01 +0200
Message-ID: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List.
I want to set up a new server. Data should be redundant that is why I 
want to use RAID level 1 using 2 HDs, each having 1TB. Like suggested in 
the wiki, I want to have the RAID running on a partition which has 
TOTAL_SIZE - 100M allocated for smoother replacement of an array-disk in 
case of failure.

The firmware is UEFI, Partitioning will be made using GPT/gdisk.

Boot manager should be GRUB (not legacy).

To be safe on system updates I want to use LVM snapshots. I like to make 
a LVM-based snapshot when the system comes up, do the system updates, 
perform the test and dicide either to go with the updates made or revert 
to the original state.

I have read that - when using UEFI - the EFI-System-Partition (ESP) has 
to reside in a own native partition, not in a RAID nor LVM block device.

Also I read a recommendation to put SWAP in a seperate native partition 
and raid it in case you want to avoid a software crash when 1 disk fails.

I wonder, how I should build up this construct. I thought I could build 
one partition with TOTAL_SIZE - 100M, Type FD00, on each device, take 
these two (sda1 + sdb1) and build a RAID 1 array named md0. Next make 
md0 the physical volume of my LVM (pvcreate /dev/md0) and after that add 
a volume group in which I put my logical volumes:
- swap - type EF00
- /boot - with filesystem fat32 for uefi
- /home - ext4
- /tmp - ext4
- / - ext4
- /var/lib/mysql - ext4 with special mount options
- /var/lib/vmimages - ext4 with special mount options

Is this doable or is it not working since UEFI will not find my 
bootimage, because in this config it is sitting not in an own native 
partition?

If it is not doable, do you see any suitable setup to archive my goals? 
I do not want to use btrfs.

Thanks,
Steffi
