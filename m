From: "Richard Bollinger" <rabollinger@gmail.com>
Subject: old raid tools dangerous with 2.6.18?
Date: Thu, 28 Sep 2006 14:20:34 -0400
Message-ID: <7744a2840609281120g5a4308d5id79ea8d487e7ae2b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It appears that raidhotadd doesn't always trigger a resync under 2.6.18.

Starting with a broken raid1 mirror:

root@LS10:~# mdadm --misc --query --detail /dev/md1
/dev/md1:
        Version : 00.90.03
  Creation Time : Thu Apr  6 13:39:04 2006
     Raid Level : raid1
     Array Size : 4112576 (3.92 GiB 4.21 GB)
    Device Size : 4112576 (3.92 GiB 4.21 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Thu Sep 28 13:52:41 2006
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : 3061bb72:5fc9adb4:9468c10f:cf1d0085
         Events : 0.48

    Number   Major   Minor   RaidDevice State
       0       3        2        0      active sync   /dev/hda2
       1       0        0        1      removed
root@LS10:~# dd bs=32256 </dev/zero >/dev/hdc2
root@LS10:~# raidhotadd /dev/md1 /dev/hdc2
root@LS10:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md1 : active raid1 hdc2[1] hda2[0]
      4112576 blocks [2/2] [UU]

unused devices: <none>

Notice that the status immediately changed to up without any
indication of recync activity.

root@LS10:~# raidsetfaulty /dev/md1 /dev/hdc2
root@LS10:~# raidhotremove /dev/md1 /dev/hdc2

Now, we add the device using mdadm and see that the sync is in progress:

root@LS10:~# mdadm /dev/md1 -a /dev/hdc2
mdadm: re-added /dev/hdc2
root@LS10:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md1 : active raid1 hdc2[1] hda2[0]
      4112576 blocks [2/1] [U_]
      [=>...................]  recovery =  6.4% (266624/4112576)
finish=0.9min speed=66656K/sec

unused devices: <none>
root@LS10:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md1 : active raid1 hdc2[1] hda2[0]
      4112576 blocks [2/1] [U_]
      [==>..................]  recovery = 11.5% (476352/4112576)
finish=1.0min speed=59544K/sec

unused devices: <none>

... and in a minute it finished syncing.

It doesn't work that way on 2.6.17.13; where either raidhotadd or
mdadm -a trigger a resync.
