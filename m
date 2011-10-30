From: Michael Busby <michael.a.busby@gmail.com>
Subject: Unable to restart reshape
Date: Sun, 30 Oct 2011 14:57:39 +0000
Message-ID: <CAFsPQ_-EdKXHjwodOnqt3TSJFS73Wgv0EXXe81nriBFJU5DV2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a system the was doing a reshape from RAID5 to 6, the system
had to be powered off this morning and moved, upon restarting the
server i issued the following command to continue the reshape

 mdadm -A /dev/md0 --backup-file=/home/md.backup

i get back to following error

mdadm: Failed to restore critical section for reshape, sorry.

any idea why?

before shutting down cat /proc/mdstat showed

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid6 sdf[0] sdb[6](S) sda[4] sdc[3] sde[2] sdd[1]
     7814055936 blocks super 1.0 level 6, 512k chunk, algorithm 18
[6/5] [UUUUU_]
     [==============>......]  reshape = 70.8% (1384415232/1953513984)
finish=3658.6min speed=2592K/sec

but now it shows

Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sdc[3] sdb[6](S) sde[2] sdd[1] sdf[0]
      9767572240 blocks super 1.0

i am totally confused, it seems to have lost a drive from the raid,
and the number of blocks is incorrect
