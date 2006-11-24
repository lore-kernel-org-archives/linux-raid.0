From: Pat Fitzpatrick <Pat_Fitzpatrick@pmc-sierra.com>
Subject: Problems with RAID Linear Grow
Date: Thu, 23 Nov 2006 16:33:31 -0800
Message-ID: <2502BD5D296162428745A16512D0B896C69BAF@bby1exm07.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm having issues trying to add a disk to a Linear RAID. I'm using mdadm 2.5.4 and kernel 2.6.18.

I can create a two disk linear RAID as follows:
mdadm -C /dev/md0 --level=linear -n2 /dev/sata1 /dev/sata2
and all is well.

I then attempt to add a third disk:
mdadm --grow /dev/md0 --add /dev/sata3
for example, but only get:
mdadm: Cannot add new disk to this array

The new disk gets a superblock created on it matching the other two disks, but the bind_rdev_to_array call in add_new_disk (in md.c) is returning -ENOSPC. rdev->size is 160836416 (the size of the disk I'm trying to add) and mddev->size is 0.

I'd appreciate any insight into what I'm doing wrong. Thanks.

Pat


