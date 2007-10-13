From: Alberto Alonso <alberto@ggsys.net>
Subject: Kicking the right drive out
Date: Sat, 13 Oct 2007 13:00:16 -0500
Message-ID: <1192298416.16416.246.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a need to kick a disk out of a RAID 5 array.

I can do a fdisk on 2 out of the 3 devices that form part
of the array, so I suspect I know which one is bad.

The problem is that mdstat shows the array as follows:

md3 : active raid5 sda6[0] sdc6[2] sdb6[1]
      960863488 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
      [>....................]  resync =  0.7% (3444348/480431744)
finish=582280.4min speed=1K/sec


Doesn't this mean that all three disks are active and in use?

mdadm -D /dev/md3 shows:

    Number   Major   Minor   RaidDevice State
       0       8        6        0      active sync   /dev/sda6
       1       8       22        1      active sync   /dev/sdb6
       2       8       38        2      active sync   /dev/sdc6

So, my question is as follows: can I remove sdc6 and be sure the
array will not stop?

To make things worse, I see no disk failures in any log file. So
I am not sure how sdc is actually failing.

Thanks,

Alberto


