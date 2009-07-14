From: Ben Beuchler <insyte@gmail.com>
Subject: migrate single disk to RAID 1?
Date: Tue, 14 Jul 2009 02:16:40 -0500
Message-ID: <479b70ed0907140016u5ec6b3d7x6320147dbdcbd17f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'd like to convert an existing partition to RAID 1 using a portion of
a new, blank drive.  All of the examples I've seen involve creating
the RAID device with the *empty* partition (sda4), copying the data
from the old partition to the new RAID, then adding the old partition
to the RAID set.

From my modest understanding of how linux software RAID works, it
seems I should be able to take an existing partition containing data
(in this case sdb4 mounted as /mail) and build a RAID 1 array with
something similar to this:

umount /dev/sdb4
mdadm --build /dev/md0 --level=1 -n2 /dev/sdb4 missing
mount /dev/md0 /mail
mdadm --add /dev/md0 /dev/sda4

Will that work?  Or am I misunderstanding something fundamental?

Thanks!

-Ben
