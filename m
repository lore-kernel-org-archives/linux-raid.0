From: Arkadiusz Miskiewicz <arekm@pld-linux.org>
Subject: Re: raid5 on 2.4.21 and reconstruction problem
Date: Wed, 13 Aug 2003 12:36:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308131236.44311.arekm@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After patching 2.4.21 kernel md0 resync started as you said but now I h=
ave:

[root@perfo root]# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Tue May  4 09:37:53 1999
     Raid Level : raid5
     Array Size : 9960064 (9.50 GiB 10.20 GB)
    Device Size : 4980032 (4.75 GiB 5.10 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Aug 13 12:24:12 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : -1
 Failed Devices : 4
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 32K

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      faulty   /dev/sdb2
       2       0        0        2      faulty removed
       3       8       34        3      spare   /dev/sdc2
           UUID : c6839323:6d5bd707:731f0c8c:10e7b89b
         Events : 0.161

I've removed sdb2 and readded it as spare. Of course that didn't help.

Now ext3 reports failed IO, after reboot machine doesn't start (.mdadm:=
 /dev/
md0 assembled from 1 drive and 2 spares - not enough to start the array=
).=20

I'm going to try ,,alternative method'' but I want to be sure of one th=
ing -=20
if I recreate array with the same parameters I wont loose any data on i=
t?

ps. I'm not getting your mails directly (no idea why) and read them via=
 google=20
(that's why there is no references or in-reply-to in headers).

--=20
Arkadiusz Mi=B6kiewicz    CS at FoE, Wroclaw University of Technology
arekm@sse.pl   AM2-6BONE, 1024/3DB19BBD, arekm(at)ircnet, PLD/Linux
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
