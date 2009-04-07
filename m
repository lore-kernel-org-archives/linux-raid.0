From: =?iso-8859-1?Q?=22J=F6rg_Habenicht=22?= <j.habenicht@gmx.de>
Subject: how to restore a raid5 with 1 disk destroyed and 1 kicked out?
Date: Tue, 07 Apr 2009 16:02:25 +0200
Message-ID: <20090407140225.140400@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list, hello Neil,

I hope you may help me with this one:

During a RAID5 synchronisation with one faulty disk my server crashed a=
nd left my RAID in an unsynced state. I'd like to get the content from =
the array back to freshen my last backup (4 months ago) and then build =
the array anew.

The array consists of 6 disks, right now 1 is dead (hw failure) and one=
 is "out of sync". I assume the latter is just marked out of sync witho=
ut being so.(*)


In http://www.mail-archive.com/linux-raid@vger.kernel.org/msg08909.html=
 and http://www.mail-archive.com/linux-raid@vger.kernel.org/msg06332.ht=
ml you suggested to recreate the array with --assume-clean.
In http://www.mail-archive.com/linux-raid@vger.kernel.org/msg08162.html=
 you advised not to use --assume-clean for RAID5, it may very well brea=
k.
Is it ok to use --assume-clean on a degraded array (5 out of 6, RAID5)?


Would it be better to recreate the array without --assume-clean? (E.g. =
like "mdadm --create /dev/md0 disk1 disk2 disk3 missing disk5 disk6")

Just out of interest: What is the difference between the two commands?

I think /deb/sdb1 is marked "out of sync" without being so. Is "--assum=
e-clean" used exactly for this case?


Thank you in advance for any advice or help
cu
J=F6rg



(*)
/dev/sdd1 dropped dead
/dev/sdb1 is marked 'out of sync', but I think the content on the disk =
is in sync with the array


 Now the dirty details:

~ # mdadm -S /dev/md0
mdadm: stopped /dev/md0

~ # mdadm --assemble --force /dev/md0  --run --verbose  /dev/sdb1 /dev/=
hda1 /dev/sdc1  /dev/sde1  /dev/sdf1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 6.
mdadm: /dev/hda1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 5.
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: added /dev/sdc1 to /dev/md0 as 2
mdadm: added /dev/sde1 to /dev/md0 as 3
mdadm: no uptodate device for slot 4 of /dev/md0
mdadm: added /dev/sdf1 to /dev/md0 as 5
mdadm: added /dev/sdb1 to /dev/md0 as 6
mdadm: added /dev/hda1 to /dev/md0 as 1
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
mdadm: Not enough devices to start the array.

~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1]
md0 : inactive hda1[1] sdf1[5] sde1[3] sdc1[2]
      976791680 blocks

~ # mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Mon Apr  3 12:35:48 2006
     Raid Level : raid5
  Used Dev Size : 244195904 (232.88 GiB 250.06 GB)
   Raid Devices : 6
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Tue Apr  7 12:02:58 2009
          State : active, degraded, Not Started
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : b72d31b8:f6bbac3d:c1c586ef:bb458af6
         Events : 0.3088065

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       3        1        1      active sync   /dev/hda1
       2       8       33        2      active sync   /dev/sdc1
       3       8       65        3      active sync   /dev/sde1
       4       0        0        4      removed
       5       8       81        5      active sync   /dev/sdf1

~ # mdadm -IR /dev/sdb1
mdadm: /dev/sdb1 attached to /dev/md0, not enough to start (4).

~ # cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1]
md0 : inactive sdb1[0] hda1[1] sdf1[5] sde1[3] sdc1[2]
      1220987584 blocks

~ # mdadm -D /dev/md0
(.....)
    Number   Major   Minor   RaidDevice State
       0       8       17        0      spare rebuilding   /dev/sdb1
       1       3        1        1      active sync   /dev/hda1
       2       8       33        2      active sync   /dev/sdc1
       3       8       65        3      active sync   /dev/sde1
       4       0        0        4      removed
       5       8       81        5      active sync   /dev/sdf1



I already tried
- "mdadm --assemble /dev/md0 /dev/sdb1 /dev/hda1 /dev/sdc1 /dev/sde1  /=
dev/sdf1"
- "mdadm --assemble --force /dev/md0 /dev/sdb1 /dev/hda1 /dev/sdc1  /de=
v/sde1  /dev/sdf1"



--=20
cu,
Joerg

--
THE full automatic planets host
:-)                            http://planets.unix-ag.uni-hannover.de



Neu: GMX FreeDSL Komplettanschluss mit DSL 6.000 Flatrate + Telefonansc=
hluss f=FCr nur 17,95 Euro/mtl.!* http://dslspecial.gmx.de/freedsl-surf=
flat/?ac=3DOM.AD.PD003K11308T4569a
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
