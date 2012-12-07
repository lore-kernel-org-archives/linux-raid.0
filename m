From: mwilck@arcor.de
Subject: Fixes for DDF with LSI BIOS RAID
Date: Fri,  7 Dec 2012 23:38:58 +0100
Message-ID: <1354919941-12070-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

I have been trying to run MD with a BIOS RAID from LSI (LSI Mega Software RAID).
While md nicely detected the RAID setup (2 RAID-1 volumes) in the first place,
I found a few problems. Most importantly, MD would start an intialization after
every reboot. This is not a systemd issue here, I was working with an old distro
with SysV init (but current mdadm). The problem was that the "init_state" flag
was reset after every boot (more precisely, the BIOS restored a different DDF
structure with the init_state flag cleared, ignoring the value mdadm had set).
The second patch in the series is the one that solves this problem. The other two
are enhancements.

Please review.

Martin

PS: These patches fix RAID1. I noticed that there are more severe problems 
when I create a RAID 10 in the BIOS. I'll try to fix that, too.

[PATCH 1/3] DDF: cleanly save the secondary DDF structure
[PATCH 2/3] DDF: use existing locations for primary and secondary DDF structure
[PATCH 3/3] DDF: increase seq number when writing meta data
