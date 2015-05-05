From: Hans Malissa <hmalissa@me.com>
Subject: Removed disk vs. failed disk?
Date: Tue, 05 May 2015 10:42:29 -0600
Message-ID: <DD68D119-D646-4D8E-8E14-498F996D8CCA@me.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I=92m somewhat new to using RAID, but I may be looking at a broken hard=
 drive already. I=92ve been looking at the documentation of mdadm and L=
inux software RAID, but I=92m not sure if I understand everything corre=
ctly. So I apologize if some of the questions have already been answere=
d elsewhere, but I need to get this thing running again as soon as poss=
ible.
I cannot mount the RAID (/dev/md0) anymore. /proc/mdstat looks like thi=
s:

# cat /proc/mdstat
Personalities : [raid1]=20
md0 : active raid1 sdb1[0]
      976760640 blocks super 1.0 [2/1] [U_]
      bitmap: 3/8 pages [12KB], 65536KB chunk

unused devices: <none>

and mdadm =97detail looks like this:

# mdadm =97detail /dev/md0
/dev/md0:
        Version : 1.0
  Creation Time : Sun Dec 15 16:03:28 2013
     Raid Level : raid1
     Array Size : 976760640 (931.51 GiB 1000.20 GB)
  Used Dev Size : 976760640 (931.51 GiB 1000.20 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue May  5 10:17:03 2015
          State : active, degraded=20
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : eprb21:0  (local to host eprb21)
           UUID : 34d12cbd:eef71d8d:14dcf224:dfe6c013
         Events : 3509

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       0        0        1      removed

So it looks like there is a problem with the second disc in the array h=
as some problem. First, I=92m not sure what the difference between =91r=
emoved=92 and =91failed=92 is, because the disk is physically still pre=
sent. How does mdadm differentiate between both states?
I understand that the next step would be to put in a new hard drive and=
 rebuild the array. Is there a way to figure out right away if the data=
 on the intact disk is uncompromised?
Best regards, and thanks for your help,

Hans Malissa--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
