From: tmp <skrald@amossen.dk>
Subject: Questions about software RAID
Date: Mon, 18 Apr 2005 21:50:24 +0200
Message-ID: <1113853825.1483.34.camel@debian>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I read the software RAID-HOWTO, but the below 6 questions is still
unclear. I have asked around on IRC-channels and it seems that I am not
the only one being confused. Maybe the HOWTO could be updated to
clearify the below items?


1) I have a RAID-1 setup with one spare disk. A disk crashes and the
spare disk takes over. Now, when the crashed disk is replaced with a new
one, what is then happening with the role of the spare disk? Is it
reverting to its old role as spare disk?

If it is NOT reverting to it's old role, then the raidtab file will
suddenly be out-of-sync with reality. Is that correct?

Does the answer given here differ in e.g. RAID-5 setups?


2) The new disk has to be manually partitioned before beeing used in the
array. What happens if the new partitions are larger than other
partitions used in the array? What happens if they are smaller?


3) Must all partition types be 0xFD? What happens if they are not?


4) I guess the partitions itself doesn't have to be formated as the
filesystem is on the RAID-level. Is that correct?


5) Removing a disk requires that I do a "mdadm -r" on all the partitions
that is involved in a RAID array. I attempt to by a hot-swap capable
controler, so what happens if I just pull out the disk without this
manual removal command?
Aren't there some more hotswap-friendly setup?


6) I know that the kernel does stripping automatically if more
partitions are given as swap partitions in /etc/fstab. But can it also
handle if one disk crashes? I.e. do I have to let my swap disk be a
RAID-setup too if I wan't it to continue upon disk crash?


Thanks!

