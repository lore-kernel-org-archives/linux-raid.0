From: Danilo Godec <danci@agenda.si>
Subject: mdadm --monitor
Date: Thu, 16 May 2002 10:40:44 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0205161032080.15557-100000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I'm trying out mdadm on a new system I'm building and it seems fine so
far. However, right now I'm tryoung the '--monitor' feature and
unfortunately it seems to do nothing...

[root]# cat /etc/mdadm.conf
DEVICE /dev/hd*[0-9] /dev/sd*[0-9]
ARRAY /dev/md0 level=raid1 num-devices=3 UUID=9338f6b6:ccadf20b:0fd08433:8285e108
ARRAY /dev/md1 level=raid5 num-devices=3 UUID=91bdf2b7:f6e83922:49437c5e:da5d7930
ARRAY /dev/md2 level=raid5 num-devices=3 UUID=5f7f8c33:a492a6a3:4129ff63:ac152b4b
MAILADDR raidalert
PROGRAM /usr/local/sbin/raidalert

[root]# cat /usr/local/sbin/raidalert:

#!/bin/bash
#
#

logger -p kern.crit -t RAID

[root]# cat /proc/mdstat
Personalities : [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid1 hde1[2] hdi1[0] hdg1[1]
      56128 blocks [3/3] [UUU]

md1 : active raid5 hde2[3] hdi2[0] hdg2[1]
      118912896 blocks level 5, 32k chunk, algorithm 2 [3/2] [UU_]
      [===========>.........]  recovery = 55.9% (33294676/59456448) finish=13.9min speed=31157K/sec
md2 : active raid5 hde3[2] hdi3[0] hdg3[1]
      1076224 blocks level 5, 32k chunk, algorithm 2 [3/3] [UUU]

root# mdadm --monitor --scan -d 5

I think it should report at least something to my syslog ('echo "Test" |
/usr/local/sbin/raidalert' does!), but it doesn't...

What am I doing wrong?

 Thanks, D.

