From: Moshe Yudkowsky <moshe@pobox.com>
Subject: RAID needs more to survive a power hit, different /boot layout for
 example (was Re: draft howto on making raids for surviving a disk crash)
Date: Sun, 03 Feb 2008 13:15:10 -0600
Message-ID: <47A612BE.5050707@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been reading the draft and checking it against my experience. 
Because of local power fluctuations, I've just accidentally checked my 
system:  My system does *not* survive a power hit. This has happened 
twice already today.

I've got /boot and a few other pieces in a 4-disk RAID 1 (three running, 
one spare). This partition is on /dev/sd[abcd]1.

I've used grub to install grub on all three running disks:

grub --no-floppy <<EOF
root (hd0,1)
setup (hd0)
root (hd1,1)
setup (hd1)
root (hd2,1)
setup (hd2)
EOF

(To those reading this thread to find out how to recover: According to 
grub's "map" option, /dev/sda1 maps to hd0,1.)


After the power hit, I get:

 > Error 16
 > Inconsistent filesystem mounted

I then tried to boot up on hda1,1, hdd2,1 -- none of them worked.

The culprit, in my opinion, is the reiserfs file system. During the 
power hit, the reiserfs file system of /boot was left in an inconsistent 
state; this meant I had up to three bad copies of /boot.

Recommendations:

1. I'm going to try adding a data=journal option to the reiserfs file 
systems, including the /boot. If this does not work, then /boot must be 
ext3 in order to survive a power hit.

2. We discussed what should be on the RAID1 bootable portion of the 
filesystem. True, it's nice to have the ability to boot from just the 
RAID1 portion. But if that RAID1 portion can't survive a power hit, 
there's little sense. It might make a lot more sense to put /boot on its 
own tiny partition.

The Fix:

The way to fix this problem with booting is to get the reiser file 
system back into sync. I did this by booting to my emergency single-disk 
partition ((hd0,0) if you must know) and then mounting the /dev/md/root 
that contains /boot. This forced a resierfs consistency check and 
journal replay, and let me reboot without problems.



-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
"A gun is, in many people's minds, like a magic wand. If you point it at 
people,
they are supposed to do your bidding."
    				-- Edwin E. Moise, _Tonkin Gulf_
