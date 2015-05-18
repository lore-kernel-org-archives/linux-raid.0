From: Hans Malissa <hmalissa@me.com>
Subject: RAID1 working correctly, error messages during boot
Date: Mon, 18 May 2015 14:29:23 -0600
Message-ID: <CE885044-F8E8-4286-9CAC-1D17560F1E79@me.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a software-RAID1 that seems to be working correctly:

# cat /proc/mdstat
Personalities : [raid1]=20
md0 : active raid1 sdc1[1] sdb1[0]
      976629568 blocks super 1.2 [2/2] [UU]
     =20
unused devices: <none>

# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sun May 17 15:21:30 2015
     Raid Level : raid1
     Array Size : 976629568 (931.39 GiB 1000.07 GB)
  Used Dev Size : 976629568 (931.39 GiB 1000.07 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Mon May 18 10:28:36 2015
          State : clean=20
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : eprb21:0  (local to host eprb21)
           UUID : 0901fe50:444a29b6:d3caff14:e45ef9cc
         Events : 19

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1

But, on the other hand, when the system boots, I briefly see the follow=
ing messages:

doing fast boot
Creating device nodes with udev
udevd[174]: failed to execute =91/sbin/mdadm=92 =91/sbin/mdadm --increm=
ental /dev/sdb1

udevd[175]: failed to execute =91/sbin/mdadm=92 =91/sbin/mdadm --increm=
ental /dev/sdc1 --offroot=92: No such file or directory

But otherwise the system appears to run normally. After booting, /dev/m=
d0 seems to be working correctly.
What does it mean, and should I worry about it? What can I do about it?=
 My system is openSUSE 12.2.
Thanks a lot,

Hans Malissa--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
