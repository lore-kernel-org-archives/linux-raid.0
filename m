From: Phillip Susi <phill@thesusis.net>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 14:14:21 -0400
Message-ID: <875ze23pfm.fsf@vps.thesusis.net>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Stefanie Leisestreichler writes:

> To be safe on system updates I want to use LVM snapshots. I like to make 
> a LVM-based snapshot when the system comes up, do the system updates, 
> perform the test and dicide either to go with the updates made or revert 
> to the original state.

Tradditional LVM snapshots were not suitable for keeping multiple, long
lived snapshots around.  They were really only for temporary use, such
as taking a snapshot to do a dump of without having to shut down
services.  I seem to remember they were developing a new multi snapshot
dm backend that would address some of these shortcomings, but I can't
find anything about that now in the google machine.

> I have read that - when using UEFI - the EFI-System-Partition (ESP) has 
> to reside in a own native partition, not in a RAID nor LVM block device.

Correct.

> I wonder, how I should build up this construct. I thought I could build 
> one partition with TOTAL_SIZE - 100M, Type FD00, on each device, take 
> these two (sda1 + sdb1) and build a RAID 1 array named md0. Next make 
> md0 the physical volume of my LVM (pvcreate /dev/md0) and after that add 
> a volume group in which I put my logical volumes:
> - swap - type EF00

EF00 is a GPT partition type.  Since this is a logical volume rather
than a GPT partition, there is no EF00.

> - /boot - with filesystem fat32 for uefi

Like you mentioned above, this needs to be a native partition, not a
logical volume.  Actually you only need /boot/EFI in a native fat32
partition, not all of /boot.
