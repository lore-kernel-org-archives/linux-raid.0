From: Al Grant <bigal.nz@gmail.com>
Subject: RAID1 to 10 (Synology NAS)
Date: Sun, 7 Apr 2013 09:54:20 +1200
Message-ID: <CAODtcdcVkLDS6UvA8MubGdo7Oe_Vzp_X45u83rfJKQeDjdT_=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a Synology NAS with two 3Tb disks in RAID1 (sda+sdb).

The output of /proc/mdstat is:

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md2 : active raid1 sda3[0] sdb3[1]
      2925544256 blocks super 1.2 [2/2] [UU]

md1 : active raid1 sdb2[1] sda2[0]
      2097088 blocks [10/2] [UU________]

md0 : active raid1 sdb1[1] sda1[0]
      2490176 blocks [10/2] [UU________]

unused devices: <none>

I have added another two 3Tb disks (sdc and sdd).

I would like if possible to convert the raid1 to raid10.

I have seen guides on google on how to do this either by:

Creating a RAID10 with the two new disks and specifying two disks as
missing. Remove one old disk, sync and then add the fourth and final
disk; OR

Another method outlined here:
http://www.linuxquestions.org/questions/linux-server-73/convert-raid-1-system-into-raid-1-0-a-557471/

My issue is that I actually have md0 md1 and md2 (presumably because
there are partitions which hold the OS for the NAS).

Can I still do this grow operation?

Is anyone able to help me through this please?

Thanks in advance


--
"Beat it punk!"
- Clint Eastwood
