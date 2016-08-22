From: Ben Kamen <benjammin2068@gmail.com>
Subject: Need Help with crashed RAID5 (that was rebuilding and then had SATA
 error on another drive)
Date: Mon, 22 Aug 2016 16:51:13 -0500
Message-ID: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey all. I'm looking at the RAID Wiki and need some help.

First Info:

I have a RAID5 with 4 members /dev/sd[cdef]1 where last night, sdc1
reported a smart error recommended drive replacement (after watching
sector errors pile up for about a week.)

no problem. shut down the drive, pulled it, replace it with a cold
spare. Started the rebuild (around midnight CDT).

At 5:43am, I got this message:

This is an automatically generated mail message from mdadm
running on quantum

A Fail event had been detected on md device /dev/md127.

It could be related to component device /dev/sde1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid1] [raid6] [raid5] [raid4]
md0 : active raid1 sda2[0] sdb2[2]
      511988 blocks super 1.0 [2/2] [UU]

md127 : active raid5 sdc1[4] sdf1[6] sde1[1](F) sdd1[5]
      2930276352 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/2] [U_U_]
      [===========>.........]  recovery = 55.9% (546131076/976758784)
finish=381.6min speed=18805K/sec
      bitmap: 4/8 pages [16KB], 65536KB chunk

md1 : active raid1 sda3[0] sdb3[2]
      239489916 blocks super 1.1 [2/2] [UU]
      bitmap: 2/2 pages [8KB], 65536KB chunk

md10 : active raid1 sda1[0] sdb1[2]
      4193272 blocks super 1.1 [2/2] [UU]

unused devices: <none>

/dev/md127  is the one with issues.

It looks like the SATA controller had issues. I couldn't see sde - so
I rebooted. (scold me later.)

All the drives are available. SMARTCTL tells me /dev/sde is happy as
can be (has a few bad sectors and is slated for replacement next, but
smart says drive is healthy).

I looked at the raid Wiki - and saved the mdadm --examine info. Of the
active members, the event count is off by 25 for happy vs unhappy
members.

But forcing the assembly claims

mdadm --assemble --force /dev/md127 /dev/sd[cdef]1
mdadm: /dev/sdc1 is busy - skipping
mdadm: /dev/sdd1 is busy - skipping
mdadm: /dev/sdf1 is busy - skipping
mdadm: Found some drive for an array that is already active: /dev/md/:BigRAID
mdadm: giving up.

So before I mess up ANYTHING else...

What should I be doing?

(should I be stopping the RAID as right now it's seems like it's running)

Thanks,

   -Ben
