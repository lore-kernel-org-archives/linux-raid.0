From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 15:54:47 +0100
Message-ID: <4B853DB7.1060406@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sorry for maybe FAQing, I am in emergency mode:

customer server, RAID5 + hotspare, 4 drives ...

gentoo Linux version 2.6.25-gentoo-r7

mdadm 2.6.4-r1 here

-

one of the 4 drives showed massive errors in dmesg, /dev/sdc
SMART-errors etc.
bought new drive and wanted to swap today.

# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md1 : active raid1 sdb1[1] sda1[0]
      104320 blocks [2/2] [UU]

md3 : active raid5 sdb3[1] sda3[0]
      19550976 blocks level 5, 64k chunk, algorithm 2 [3/2] [UU_]

md4 : inactive sdb4[1](S) sdd4[3](S) sdc4[2](S) sda4[0](S)
      583641088 blocks



-


I did:

mdadm /dev/md3 --fail /dev/sdc3

went OK

mdadm /dev/md4 --remove /dev/sdc3

OK as well, raid md3 rebuilt

-

With md4 I was too aggressive maybe:

mdadm /dev/md4 --fail /dev/sdc4 --remove /dev/sdc4

this rendered md4 unusable, even after a reboot it can't be reassambled.

This is bad, to say the least.

md4 : inactive sdb4[1](S) sdd4[3](S) sdc4[2](S) sda4[0](S)
      583641088 blocks


What to try?

This is a crucial server and I feel a lot of pressure.
Rebuilding that raid would mean a lot of restore-work etc.
So I would really appreciate a goo advice here.

THANKS!

Stefan


