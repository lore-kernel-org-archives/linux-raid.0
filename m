From: "Grzegorz Nosek" <grzegorz.nosek@gmail.com>
Subject: Resizing RAID1 on top of LVM2 LVs
Date: Wed, 11 Jul 2007 20:38:55 +0200
Message-ID: <121a28810707111138y67b0c746o66ebb11e4417c795@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I'm trying to make an online-resizeable RAID1 array on a pair of
hot-swap disks. My achievements :) so far include:

 - creating two VGs (one per disk) with one LV on each. I have created
both LVs a little smaller than the VG size (1.1G out of 1.9G)
 - creating a RAID1 array via mdadm (2.5.6) from the two LVs
 - creating an XFS filesystem and torturing it with bonnie

Now, the problem arises when I try to resize the array. I can resize
the LVs to cover the entire VG area (and blockdev --getsize64 confirms
this), however, I cannot get mdadm to notice the size change. mdadm -G
-z max /dev/md2 seems to do nothing and giving the size explicitely
(mdadm -G -z <size> /dev/md2), both with size being 1990656 (expr
`blockdev --getsize /dev/vg1/lv1` / 2), and with a smaller size
(1990000, to leave some room for the superblock).

I failed and removed one LV and wanted to hot-add it but mdadm won't let me:

# mdadm --force -av /dev/md2 /dev/vg2/lv2
mdadm: cannot find valid superblock in this array - HELP

I also tried to zero the /dev/vg2/lv2 device completely but it still
fails with the exact same message.

Possibly relevant version numbers:
 - base system: Debian etch 4.0 (pure vanilla install)
 - lvm2 tools:
  LVM version:     2.02.07 (2006-07-17)
  Library version: 1.02.08 (2006-07-17)
  Driver version:  4.7.0
 - mdadm: 2.5.6-9 (Debian)
 - kernel: 2.6.18-4 (Debian)

Any suggestions? Am I doing something wrong? I'd like to do it this
way (instead of googled lvm-linear over a bunch of /dev/mdX) as it
seems "cleaner".

Please CC me on any answers as I'm not subscribed to the list.
Best regards,
 Grzegorz Nosek
