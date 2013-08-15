From: <Matthias.Blaesing@persona.de>
Subject: Recovery of RAID1 fails (added disks stays as spare)
Date: Thu, 15 Aug 2013 09:09:40 +0000
Message-ID: <FC7EE784B0E13748AA4FF80E6D4CD67212E27E@w8kmail2.konzern.intern>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm currently fighting a server problem and have the feeling, that I'm =
running into walls.

Summary: On one of our servers we suffered from a hard disk error, that=
 lead to a degraded array.
The hardware was replaced and the array was rebuild. On one of the RAID=
-Sets the newly added
disk is not activated but stays as spare.

System: SUSE Linux Enterprise Server 11 (x86_64) 11.2

The current state:

# cat /proc/mdstat

Personalities : [raid1] [raid0] [raid10] [raid6] [raid5] [raid4]
md3 : active raid1 sda3[2](S) sdb3[0]
      970888192 blocks [2/1] [U_]

md1 : active raid1 sda1[0] sdb1[1]
      3911680 blocks [2/2] [UU]

unused devices: <none>

# mdadm --detail /dev/md3

/dev/md3:
        Version : 0.90
  Creation Time : Fri Feb  4 11:47:04 2011
     Raid Level : raid1
     Array Size : 970888192 (925.91 GiB 994.19 GB)
  Used Dev Size : 970888192 (925.91 GiB 994.19 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Thu Aug 15 10:22:07 2013
          State : clean, degraded
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1

           UUID : e9d9c5f5:615c789e:3fb6082e:e5593158
         Events : 0.18857541

    Number   Major   Minor   RaidDevice State
       0       8       19        0      active sync   /dev/sdb3
       1       0        0        1      removed

       2       8        3        -      spare   /dev/sda3

I would expect the raid system to move /dev/sda3 to number 1 and mark i=
t as active.

Versions:

# uname -a
Linux 3.0.58-0.6.6-default #1 SMP Tue Feb 19 11:07:00 UTC 2013 (1576ecd=
) x86_64 x86_64 x86_64 GNU/Linux
# mdadm -V
mdadm - v3.2.2 - 17th June 2011

I tried:

* removing /dev/sda3 from the array and add it back
* removing /dev/sda3 from the array, zero the root block and add it bac=
k (--zero-superblock)
* removing /dev/sda3 from the array, reduce raid devices to one, add /d=
ev/sda3 back
* removing /dev/sda3 from the array, zero the first part of the disk (w=
ith dd) and add it back

I would really appreciate ideas how to fix this (preferably while runni=
ng the system).


Mit freundlichen Gr=FC=DFen

Matthias Bl=E4sing
Abt IT
KompetenzCenter

Tel.: 02351 950-344
=46ax.: 02351 950-222
mailto: matthias.blaesing@persona.de
www.persona.de

persona service Verwaltungs AG & Co. KG=20
=46reisenbergstra=DFe 31 =95 58513 L=FCdenscheid =20
Tel.: (02351) 950-0 =95 Fax: (02351) 950-222=20
Sitz L=FCdenscheid =95 Registergericht Iserlohn, HRA Nr. 2930

pers=F6nlich haftende Gesellschafterin: persona service AG
Gartenstra=DFe 93 =95 CH-4002 Basel
Handelsregister Basel, Nr. CH-270.3.012.836-8
diese vertreten durch den Verwaltungsrat:
Georg Breucker (Pr=E4sident) und Dr. Sebastian Burckhardt
www.persona.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
