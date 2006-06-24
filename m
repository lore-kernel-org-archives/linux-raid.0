From: Ronald Lembcke <es186@fen-net.de>
Subject: RAID5 degraded after mdadm -S, mdadm --assemble (everytime)
Date: Sat, 24 Jun 2006 12:47:45 +0200
Message-ID: <20060624104745.GA6352@defiant.crash>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I set up a RAID5 array of 4 disks. I initially created a degraded array
and added the fourth disk (sda1) later.

The array is "clean", but when I do =20
  mdadm -S /dev/md0=20
  mdadm --assemble /dev/md0 /dev/sd[abcd]1
it won't start. It always says sda1 is "failed".

When I remove sda1 and add it again everything seems to be fine until I
stop the array.=20

Below is the output of /proc/mdstat, mdadm -D -Q, mdadm -E and a piece of t=
he
kernel log.
The output of mdadm -E looks strange for /dev/sd[bcd]1, saying "1 failed".

What can I do about this?
How could this happen? I mixed up the syntax when adding the fourth disk and
tried these two commands (at least one didn't yield an error message):
mdadm --manage -a /dev/md0 /dev/sda1
mdadm --manage -a /dev/sda1 /dev/md0


Thanks in advance ...
                      Roni



ganges:~# cat /proc/mdstat=20
Personalities : [raid5] [raid4]=20
md0 : active raid5 sda1[4] sdc1[0] sdb1[2] sdd1[1]
      691404864 blocks super 1.0 level 5, 64k chunk, algorithm 2 [4/4] [UUU=
U]
     =20
unused devices: <none>


ganges:~# mdadm -Q -D /dev/md0
/dev/md0:
        Version : 01.00.03
  Creation Time : Wed Jun 21 13:00:41 2006
     Raid Level : raid5
     Array Size : 691404864 (659.38 GiB 708.00 GB)
    Device Size : 460936576 (219.79 GiB 236.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jun 23 15:54:23 2006
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : 0
           UUID : f937e8c2:15b41d19:fe79ccca:2614b165
         Events : 32429

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       17        2      active sync   /dev/sdb1
       4       8        1        3      active sync   /dev/sda1



ganges:~# mdadm -E /dev/sd[abcd]1
/dev/sda1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : f937e8c2:15b41d19:fe79ccca:2614b165
           Name : 0
  Creation Time : Wed Jun 21 13:00:41 2006
     Raid Level : raid5
   Raid Devices : 4

    Device Size : 460936832 (219.79 GiB 236.00 GB)
     Array Size : 1382809728 (659.38 GiB 708.00 GB)
      Used Size : 460936576 (219.79 GiB 236.00 GB)
   Super Offset : 460936960 sectors
          State : active
    Device UUID : f41dfb24:72cc87b7:4003ad32:bc19c70c

    Update Time : Fri Jun 23 15:54:23 2006
       Checksum : ad466c73 - correct
         Events : 32429

         Layout : left-symmetric
     Chunk Size : 64K

   Array State : uuuu 1 failed
/dev/sdb1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : f937e8c2:15b41d19:fe79ccca:2614b165
           Name : 0
  Creation Time : Wed Jun 21 13:00:41 2006
     Raid Level : raid5
   Raid Devices : 4

    Device Size : 460936832 (219.79 GiB 236.00 GB)
     Array Size : 1382809728 (659.38 GiB 708.00 GB)
      Used Size : 460936576 (219.79 GiB 236.00 GB)
   Super Offset : 460936960 sectors
          State : active
    Device UUID : 6283effa:df4cb959:d449e09e:4eb0a65b

    Update Time : Fri Jun 23 15:54:23 2006
       Checksum : e07f2f74 - correct
         Events : 32429

         Layout : left-symmetric
     Chunk Size : 64K

   Array State : uuUu 1 failed
/dev/sdc1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : f937e8c2:15b41d19:fe79ccca:2614b165
           Name : 0
  Creation Time : Wed Jun 21 13:00:41 2006
     Raid Level : raid5
   Raid Devices : 4

    Device Size : 460936768 (219.79 GiB 236.00 GB)
     Array Size : 1382809728 (659.38 GiB 708.00 GB)
      Used Size : 460936576 (219.79 GiB 236.00 GB)
   Super Offset : 460936896 sectors
          State : active
    Device UUID : 4f581aed:e24b4ac2:3d2ca149:191c89c1

    Update Time : Fri Jun 23 15:54:23 2006
       Checksum : 4bde5117 - correct
         Events : 32429

         Layout : left-symmetric
     Chunk Size : 64K

   Array State : Uuuu 1 failed
/dev/sdd1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x0
     Array UUID : f937e8c2:15b41d19:fe79ccca:2614b165
           Name : 0
  Creation Time : Wed Jun 21 13:00:41 2006
     Raid Level : raid5
   Raid Devices : 4

    Device Size : 460936832 (219.79 GiB 236.00 GB)
     Array Size : 1382809728 (659.38 GiB 708.00 GB)
      Used Size : 460936576 (219.79 GiB 236.00 GB)
   Super Offset : 460936960 sectors
          State : active
    Device UUID : b5fc3eba:07da8be3:81646894:e3c313dc

    Update Time : Fri Jun 23 15:54:23 2006
       Checksum : 9f966431 - correct
         Events : 32429

         Layout : left-symmetric
     Chunk Size : 64K

   Array State : uUuu 1 failed

[  174.318555] md: md0 stopped.
[  174.400617] md: bind<sdd1>
[  174.401850] md: bind<sdb1>
[  174.403068] md: bind<sda1>
[  174.404321] md: bind<sdc1>
[  174.442943] raid5: measuring checksumming speed
[  174.463185]    8regs     :   543.000 MB/sec
[  174.483171]    8regs_prefetch:   431.000 MB/sec
[  174.503162]    32regs    :   335.000 MB/sec
[  174.523152]    32regs_prefetch:   293.000 MB/sec
[  174.543144]    pII_mmx   :   938.000 MB/sec
[  174.563138]    p5_mmx    :   901.000 MB/sec
[  174.563466] raid5: using function: pII_mmx (938.000 MB/sec)
[  174.578432] md: raid5 personality registered for level 5
[  174.578808] md: raid4 personality registered for level 4
[  174.580416] raid5: device sdc1 operational as raid disk 0
[  174.580773] raid5: device sdb1 operational as raid disk 2
[  174.581118] raid5: device sdd1 operational as raid disk 1
[  174.584893] raid5: allocated 4196kB for md0
[  174.585242] raid5: raid level 5 set md0 active with 3 out of 4 devices, =
algorithm 2
[  174.585805] RAID5 conf printout:
[  174.586108]  --- rd:4 wd:3 fd:1
[  174.586411]  disk 0, o:1, dev:sdc1
[  174.586718]  disk 1, o:1, dev:sdd1
[  174.587019]  disk 2, o:1, dev:sdb1
[  219.660549] md: unbind<sda1>
[  219.660921] md: export_rdev(sda1)
[  227.126828] md: bind<sda1>
[  227.127242] RAID5 conf printout:
[  227.127538]  --- rd:4 wd:3 fd:1
[  227.127829]  disk 0, o:1, dev:sdc1
[  227.128132]  disk 1, o:1, dev:sdd1
[  227.128428]  disk 2, o:1, dev:sdb1
[  227.128721]  disk 3, o:1, dev:sda1
[  227.129163] md: syncing RAID array md0
[  227.129478] md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/d=
isc.
[  227.129892] md: using maximum available idle IO bandwidth (but not more =
than 200000 KB/sec) for reconstruction.
[  227.130499] md: using 128k window, over a total of 230468288 blocks.
[16359.493868] md: md0: sync done.
[16359.499961] RAID5 conf printout:
[16359.500213]  --- rd:4 wd:4 fd:0
[16359.500453]  disk 0, o:1, dev:sdc1
[16359.500714]  disk 1, o:1, dev:sdd1
[16359.500958]  disk 2, o:1, dev:sdb1
[16359.501202]  disk 3, o:1, dev:sda1



--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEnRhR1AoV+KoUdT8RAlaLAJ9LekXeQhMB18q+FPYM7QkMpO+0swCdHTR5
uiruNYmWEJqrtrnIyYRfyGQ=
=X7Wj
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
