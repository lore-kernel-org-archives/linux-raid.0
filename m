From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Reducing the number of devices in a degraded RAID-5
Date: Mon, 22 May 2017 14:53:32 +0200
Message-ID: <20170522125332.GA18406@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

this is not a recovery question, no real data involved. Thanks for helping!

Suppose you have a failing drive in RAID-5 but you wanted to move to 
fewer drives anyway, so one way or another you're going to reduce 
the number of drives in your RAID.

Given a RAID 5 with 5 drives            [UUUUU]
Reducing it by one drive results in     [UUUU] + Spare
Okay.

Given a degraded RAID 5 with 5 drives   [_UUUU]
Reducing it by one drive results in     [_UUU] + Spare
Still okay? Rebuild must be started manually.

It seems reducing a degraded RAID is a bad idea, 
since there is no redundancy for a very long time.

So what you might end up doing is a three step process:

-> [_UUUU] (Degraded)

Step 1: Add another drive (redundancy first)

-> [UUUUU]
    ^ added drive

Step 2: Reduce by one drive

-> [UUUU] + Spare

Step 3: --replace the previously added drive
        (if the spare happened to be one of the drives you wanted to keep)

-> [UUUU]
    ^ former spare

This way the process is redundant but it takes a very long time, 
three separate reshape/rebuilds instead of just one.

Steps to reproduce the [_UUUU] -> [_UUU] + Spare case:
(using linux 4.10, mdadm 4.0)

# truncate -s 100M 1.img 2.img 3.img 4.img
# devices=$(for f in ?.img; do losetup --find --show "$f"; done)
# mdadm --create /dev/md42 --level=5 --raid-devices=5 missing $devices
md42 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1]
      405504 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/4] [_UUUU]
# mdadm --grow /dev/md42 --array-size 304128
# mdadm --grow /dev/md42 --backup-file=md42.backup --raid-devices=4
md42 : active raid5 loop4[4](S) loop3[3] loop2[2] loop1[1]
      304128 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [_UUU]
# not rebuilding until you re-add the spare

Is it possible to do [_UUUU] -> [UUUU] in a single step?
I haven't found a way. Any ideas?

Regards
Andreas Klauer
