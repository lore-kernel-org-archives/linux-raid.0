From: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Subject: SuperBlock recovery ...
Date: Sun, 18 Oct 2009 20:15:58 +0200
Message-ID: <b7b14cbb0910181115w74c14d5cj21add1b4dac871bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings ...

 I'm hoping somebody can help me, because I am stomped and it seems
that the RAID gods, just don't like me ...

 I'm running CentOS 5.3, with 4 1TB Seagate SATA drive running off a
slow 4xSATA PCI adapter in RAID5 ... I dought any of that is of
interest, but I'm putting it in with the rest of the info ...

 About a month before, one of my HDD's in the NAS died, dead! Replaced
that drive and resynced without a problem, but all these drives were
purchased at the same time, so I'm wondering if this might be a
problem with the drives ... Seems all my old drives are SD15, which
seems like that could be my problem ...

 My history ... Okay, I was running into some odd problems with my
raid, so I faulted one of my drives, that I thought was giving me
problems, not to long after that another drive failed and jump out of
the raid.  So I stopped the raid so that I could test the drives for
fault and see where my problem was.  Started with cables, power
supply, PCI card and even motherboard.

 Ran some S.M.A.R.T. test, and thought I saw bad blocks on my poor
HDD's, so I took them out of my make shift NAS and popped them into
another PC with onboard SATA, so that I could run the SeaGate SeaTools
for DOS version 1.10 ...

 Ran the SeaGate SMART long tests on all drives, twice to be sure,
which correct or re-allocated bad blocks, my first problem would be
that I would like to re-assemble the RAID, but I would believe there
are some, new blocks, that have replaced the bad blocks, but without
data and I would like to verify the best blocks out of all the
functioning data ... So I was wondering what would be the best
practice when assembling the RAID and verifing the data?

 But now, I have run into an even bigger problem ... When I put the
drives back into my NAS, it seems all my MD superblocks are missing
... I have been doing much research, but I'm not yet able to come up
with a test plan, that could have me not loose my data ...

 So, I would like to try and find the MD superblocks, which currently
are version 0.90 on all devices ... I did a test on a smaller RAID ...

[root@zeus temp]# mdadm -E /dev/hda1
/dev/hda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 669ec117:67b9cc0f:d048dd42:c19638a4
  Creation Time : Sat Mar 28 18:03:06 2009
     Raid Level : raid1
  Used Dev Size : 264960 (258.79 MiB 271.32 MB)
     Array Size : 264960 (258.79 MiB 271.32 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Sun Oct 18 12:15:47 2009
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 9e1033cb - correct
         Events : 0.14


      Number   Major   Minor   RaidDevice State
this     0       3        1        0      active sync   /dev/hda1

   0     0       3        1        0      active sync   /dev/hda1
   1     1      22        1        1      active sync   /dev/hdc1

dd if=/dev/hda1 of=test.img

I then searched test.img for 0x0A92B4EFC ... But I'm not able to find
this patten in the image ... What am I missing?

 I'm thinking that I should make sure that I understand the RAID on
disk format, before messing around with trying to fix my bigger RAID
...

Thanks for the help.

Mailed
LeeT
