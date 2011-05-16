From: Gavin Flower <gavinflower@yahoo.com>
Subject: Best way to create RAID-6 for swap partition - existing one failed
Date: Mon, 16 May 2011 14:41:23 -0700 (PDT)
Message-ID: <595104.28955.qm@web65106.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

Hi,

Motivation, existing RAID-6 swap partition failed.  I am thinking I sho=
uld recreate it in a new format, as currently it is 'Version : 0.90', r=
ather than simply rebuild it.

So 3 questions:

(1) What further diagnostics should I run first, if any (note I am curr=
ently running badblocks on the drive that dropped out), and I have put =
the existing diagnostic info at the end of this email


(2) What is the most appropriate RAID-6 format for a swap partition, ke=
eping same the number of drives and overall capacity.

(3) How to convert the existing /dev/md0 to the new format.


Cheers,
Gavin


# grep md0 /var/log/messages

May 16 04:05:47 saturn kernel: [    3.658644] md: md0 stopped.

May 16 04:05:47 saturn kernel: [    3.933910] md/raid:md0: not clean --=
 starting background reconstruction

May 16 04:05:47 saturn kernel: [    3.937796] md/raid:md0: device sda3 =
operational as raid disk 0

May 16 04:05:47 saturn kernel: [    3.941540] md/raid:md0: device sdb3 =
operational as raid disk 4

May 16 04:05:47 saturn kernel: [    3.945161] md/raid:md0: device sdd3 =
operational as raid disk 3

May 16 04:05:47 saturn kernel: [    3.948706] md/raid:md0: device sdc3 =
operational as raid disk 2

May 16 04:05:47 saturn kernel: [    3.953408] md/raid:md0: allocated 53=
34kB

May 16 04:05:47 saturn kernel: [    3.956939] md/raid:md0: cannot start=
 dirty degraded array.

May 16 04:05:47 saturn kernel: [    3.961082] md/raid:md0: failed to ru=
n raid set.

May 16 04:05:47 saturn kernel: [    3.968237] dracut: mdadm: failed to =
RUN_ARRAY /dev/md0: Input/output error

May 16 04:05:47 saturn kernel: [    4.239948] dracut: mdadm: /dev/md0 i=
s already in use.

May 16 04:05:47 saturn kernel: [    4.340048] dracut: mdadm: /dev/md0 i=
s already in use.

May 16 04:08:28 saturn kernel: [    3.038486] md: md0 stopped.

May 16 04:08:28 saturn kernel: [    3.205219] md/raid:md0: not clean --=
 starting background reconstruction

May 16 04:08:28 saturn kernel: [    3.206711] md/raid:md0: device sda3 =
operational as raid disk 0

May 16 04:08:28 saturn kernel: [    3.208501] md/raid:md0: device sdb3 =
operational as raid disk 4

May 16 04:08:28 saturn kernel: [    3.210254] md/raid:md0: device sdd3 =
operational as raid disk 3

May 16 04:08:28 saturn kernel: [    3.211979] md/raid:md0: device sdc3 =
operational as raid disk 2

May 16 04:08:28 saturn kernel: [    3.214179] md/raid:md0: allocated 53=
34kB

May 16 04:08:28 saturn kernel: [    3.215917] md/raid:md0: cannot start=
 dirty degraded array.

May 16 04:08:28 saturn kernel: [    3.217880] md/raid:md0: failed to ru=
n raid set.

May 16 04:08:28 saturn kernel: [    3.221377] dracut: mdadm: failed to =
RUN_ARRAY /dev/md0: Input/output error

May 16 04:08:28 saturn kernel: [    3.425089] dracut: mdadm: /dev/md0 i=
s already in use.

May 16 04:08:28 saturn kernel: [    4.118667] dracut: mdadm: /dev/md0 i=
s already in use.

May 17 00:58:12 saturn kernel: [    3.006195] md: md0 stopped.

May 17 00:58:12 saturn kernel: [    3.174154] md/raid:md0: not clean --=
 starting background reconstruction

May 17 00:58:12 saturn kernel: [    3.175688] md/raid:md0: device sda3 =
operational as raid disk 0

May 17 00:58:12 saturn kernel: [    3.177218] md/raid:md0: device sdb3 =
operational as raid disk 4

May 17 00:58:12 saturn kernel: [    3.178717] md/raid:md0: device sdd3 =
operational as raid disk 3

May 17 00:58:12 saturn kernel: [    3.180196] md/raid:md0: device sdc3 =
operational as raid disk 2

May 17 00:58:12 saturn kernel: [    3.182161] md/raid:md0: allocated 53=
34kB

May 17 00:58:12 saturn kernel: [    3.183976] md/raid:md0: cannot start=
 dirty degraded array.

May 17 00:58:12 saturn kernel: [    3.186002] md/raid:md0: failed to ru=
n raid set.

May 17 00:58:12 saturn kernel: [    3.189615] dracut: mdadm: failed to =
RUN_ARRAY /dev/md0: Input/output error

May 17 00:58:12 saturn kernel: [    3.540474] dracut: mdadm: /dev/md0 i=
s already in use.

May 17 00:58:12 saturn kernel: [    3.614348] dracut: mdadm: /dev/md0 i=
s already in use.

#=20


# grep md0 /var/log/messages-20110515

[=E2=80=A6]
May 12 03:05:12 saturn kernel: [132994.557873] md: delaying data-check =
of md0 until md1 has finished (they share one or more physical units)

May 12 03:24:41 saturn kernel: [134160.574564] md: data-check of RAID a=
rray md0

May 12 03:25:22 saturn kernel: [134202.299274] md: md0: data-check done=
=2E

May 13 00:15:00 saturn kernel: [    3.046117] md: md0 stopped.

May 13 00:15:00 saturn kernel: [    3.208950] md/raid:md0: device sda3 =
operational as raid disk 0

May 13 00:15:00 saturn kernel: [    3.210743] md/raid:md0: device sdb3 =
operational as raid disk 4

May 13 00:15:00 saturn kernel: [    3.212501] md/raid:md0: device sdd3 =
operational as raid disk 3

May 13 00:15:00 saturn kernel: [    3.214246] md/raid:md0: device sdc3 =
operational as raid disk 2

May 13 00:15:00 saturn kernel: [    3.215974] md/raid:md0: device sde3 =
operational as raid disk 1

May 13 00:15:00 saturn kernel: [    3.218201] md/raid:md0: allocated 53=
34kB

May 13 00:15:00 saturn kernel: [    3.219955] md/raid:md0: raid level 6=
 active with 5 out of 5 devices, algorithm 2

May 13 00:15:00 saturn kernel: [    3.221442] md0: detected capacity ch=
ange from 0 to 11009851392

May 13 00:15:00 saturn kernel: [    3.223285] dracut: mdadm: /dev/md0 h=
as been started with 5 drives.

May 13 00:15:00 saturn kernel: [    3.223971]  md0: unknown partition t=
able

May 13 00:15:00 saturn kernel: [   12.055465] Adding 10751804k swap on =
/dev/md0.  Priority:-1 extents:1 across:10751804k=20


# date ; cat /proc/mdstat=20

Tue May 17 08:52:16 NZST 2011

Personalities : [raid6] [raid5] [raid4]=20

md2 : active raid6 sda4[0] sdc4[6] sdd4[3] sdb4[5] sde4[1]

      1114745856 blocks super 1.1 level 6, 512k chunk, algorithm 2 [5/5=
] [UUUUU]

      bitmap: 2/3 pages [8KB], 65536KB chunk



md1 : active raid6 sda2[0] sdc2[4] sdd2[3] sde2[2] sdb2[1]

      307198464 blocks level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]

     =20

md0 : inactive sda3[0] sdb3[4] sdd3[3] sdc3[2]

      14335744 blocks

      =20

unused devices: <none>


# mdadm --detail /dev/md0

/dev/md0:

        Version : 0.90

  Creation Time : Thu Dec  3 13:05:42 2009

     Raid Level : raid6

  Used Dev Size : 3583936 (3.42 GiB 3.67 GB)

   Raid Devices : 5

  Total Devices : 4

Preferred Minor : 0

    Persistence : Superblock is persistent



    Update Time : Mon May 16 03:56:48 2011

          State : active, degraded, Not Started

 Active Devices : 4

Working Devices : 4

 Failed Devices : 0

  Spare Devices : 0



         Layout : left-symmetric

     Chunk Size : 64K



           UUID : 3b76ac20:8253f696:bfe78010:bc810f04

         Events : 0.11171



    Number   Major   Minor   RaidDevice State

       0       8        3        0      active sync   /dev/sda3

       1       0        0        1      removed

       2       8       35        2      active sync   /dev/sdc3

       3       8       51        3      active sync   /dev/sdd3

       4       8       19        4      active sync   /dev/sdb3


# mdadm --stop /dev/md0

mdadm: stopped /dev/md0

# date ; cat /proc/mdstat

Tue May 17 09:04:49 NZST 2011

Personalities : [raid6] [raid5] [raid4]=20

md2 : active raid6 sda4[0] sdc4[6] sdd4[3] sdb4[5] sde4[1]

      1114745856 blocks super 1.1 level 6, 512k chunk, algorithm 2 [5/5=
] [UUUUU]

      bitmap: 2/3 pages [8KB], 65536KB chunk



md1 : active raid6 sda2[0] sdc2[4] sdd2[3] sde2[2] sdb2[1]

      307198464 blocks level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]

     =20

unused devices: <none>

#=20


--
All Adults share the Responsibility
to help Raise Today's Children,
for they are Tomorrow's Society!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
