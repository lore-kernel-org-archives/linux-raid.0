From: Sebastian Reichel <sre@ring0.de>
Subject: mdadm hangs during raid5 grow
Date: Wed, 4 Jan 2017 07:42:11 +0100
Message-ID: <20170104064210.4exlw2rdbe2fcal2@earth>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wrqif2zrvmn5iyo6"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--wrqif2zrvmn5iyo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I have a problem with hanging mdadm reshape task at 100% CPU load
(kernel thread "md2_raid5"). Any operation on the raid (i.e. mdadm
-S) is also hanging.  Rebooting worked, but after triggering the
reshape (mdadm --readwrite /dev/md2) I get the same behaviour.

dmesg has this stacktrace:

[ 1813.500745] INFO: task md2_resync:3377 blocked for more than 120 seconds.
[ 1813.500778]       Not tainted 4.8.0-2-amd64 #1
[ 1813.500795] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this message.
[ 1813.500822] md2_resync      D ffff93207bc98180     0  3377      2 0x0000=
0000
[ 1813.500827]  ffff93206f46d000 ffff93207642a1c0 0000000000000246 ffff9320=
59607bf0
[ 1813.500829]  ffff932059608000 ffff93206effc400 ffff93206effc688 ffff9320=
59607d24
[ 1813.500830]  ffff932059607bf0 ffff93206e0a3000 ffffffffbc7eb6d1 ffff9320=
6e0a3000
[ 1813.500832] Call Trace:
[ 1813.500841]  [<ffffffffbc7eb6d1>] ? schedule+0x31/0x80
[ 1813.500847]  [<ffffffffc0356924>] ? reshape_request+0x7b4/0x910 [raid456]
[ 1813.500851]  [<ffffffffbc2bce80>] ? wake_atomic_t_function+0x60/0x60
[ 1813.500854]  [<ffffffffc0356da3>] ? raid5_sync_request+0x323/0x3a0 [raid=
456]
[ 1813.500862]  [<ffffffffc0271b50>] ? is_mddev_idle+0x98/0xf3 [md_mod]
[ 1813.500866]  [<ffffffffc02649a9>] ? md_do_sync+0x959/0xed0 [md_mod]
[ 1813.500868]  [<ffffffffbc2bce80>] ? wake_atomic_t_function+0x60/0x60
[ 1813.500872]  [<ffffffffc0261363>] ? md_thread+0x133/0x140 [md_mod]
[ 1813.500873]  [<ffffffffbc7eb1c9>] ? __schedule+0x289/0x760
[ 1813.500877]  [<ffffffffc0261230>] ? find_pers+0x70/0x70 [md_mod]
[ 1813.500879]  [<ffffffffbc29aecd>] ? kthread+0xcd/0xf0
[ 1813.500881]  [<ffffffffbc7efcaf>] ? ret_from_fork+0x1f/0x40
[ 1813.500883]  [<ffffffffbc29ae00>] ? kthread_create_on_node+0x190/0x190

Is this a known bug / some patch available?

[0] http://serverfault.com/questions/773244/mdadm-stuck-reshape-operation
[1] http://serverfault.com/questions/697193/raid-5-reshape-freeze

-- Sebastian

FWIW here are some infos about the raid:

mars# uname -a
Linux mars 4.8.0-2-amd64 #1 SMP Debian 4.8.11-1 (2016-12-02) x86_64 GNU/Lin=
ux
sre@mars ~ % cat /proc/mdstat=20
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] [raid0=
] [raid10]=20
md2 : active raid5 sdl[4] sdk[6] sdm[3] sdj[5]
      7813774720 blocks super 1.2 level 5, 64k chunk, algorithm 2 [4/4] [UU=
UU]
      [>....................]  reshape =3D  0.2% (10197888/3906887360) fini=
sh=3D157305.2min speed=3D412K/sec
=2E..
mars# for disk in /dev/sd[jmlk]; smartctl -i $disk | grep "Device Model"
Device Model:     WDC WD40EFRX-68WT0N0
Device Model:     WDC WD40EFRX-68WT0N0
Device Model:     WDC WD40EFRX-68WT0N0
Device Model:     WDC WD40EFRX-68WT0N0
mars# for disk in /dev/sd[jmlk]; if smartctl -l scterc,70,70 $disk > /dev/n=
ull ; then echo "$disk is good"; fi
/dev/sdj is good
/dev/sdk is good
/dev/sdl is good
/dev/sdm is good
mars# mdadm --detail /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Wed Jan 15 12:59:19 2014
     Raid Level : raid5
     Array Size : 7813774720 (7451.80 GiB 8001.31 GB)
  Used Dev Size : 3906887360 (3725.90 GiB 4000.65 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Wed Jan  4 06:09:53 2017
          State : clean, reshaping=20
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

 Reshape Status : 0% complete
  Delta Devices : 1, (3->4)

           Name : mars:2  (local to host mars)
           UUID : a9946f57:e2c50b35:d192467d:fa495817
         Events : 39050

    Number   Major   Minor   RaidDevice State
       4       8      176        0      active sync   /dev/sdl
       5       8      144        1      active sync   /dev/sdj
       3       8      192        2      active sync   /dev/sdm
       6       8      160        3      active sync   /dev/sdk
mars# mdadm --examine /dev/sd[jmlk]   =20
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0xc
     Array UUID : a9946f57:e2c50b35:d192467d:fa495817
           Name : mars:2  (local to host mars)
  Creation Time : Wed Jan 15 12:59:19 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 7813775280 (3725.90 GiB 4000.65 GB)
     Array Size : 11720662080 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 7813774720 (3725.90 GiB 4000.65 GB)
    Data Offset : 261888 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D261800 sectors, after=3D560 sectors
          State : active
    Device UUID : 94bb69dc:955c3040:5cc4ecbb:28130785

  Reshape pos'n : 29073984 (27.73 GiB 29.77 GB)
  Delta Devices : 1 (3->4)

    Update Time : Wed Jan  4 06:09:53 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks p=
resent.
       Checksum : ed4b675b - correct
         Events : 39050

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)
/dev/sdk:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : a9946f57:e2c50b35:d192467d:fa495817
           Name : mars:2  (local to host mars)
  Creation Time : Wed Jan 15 12:59:19 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 7813775280 (3725.90 GiB 4000.65 GB)
     Array Size : 11720662080 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 7813774720 (3725.90 GiB 4000.65 GB)
    Data Offset : 261888 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D261800 sectors, after=3D560 sectors
          State : active
    Device UUID : 213a97fc:46865f42:0e8b06be:7309eac1

  Reshape pos'n : 29073984 (27.73 GiB 29.77 GB)
  Delta Devices : 1 (3->4)

    Update Time : Wed Jan  4 06:09:53 2017
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 4ea4cc90 - correct
         Events : 39050

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)
/dev/sdl:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0xc
     Array UUID : a9946f57:e2c50b35:d192467d:fa495817
           Name : mars:2  (local to host mars)
  Creation Time : Wed Jan 15 12:59:19 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 7813775280 (3725.90 GiB 4000.65 GB)
     Array Size : 11720662080 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 7813774720 (3725.90 GiB 4000.65 GB)
    Data Offset : 261888 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D261800 sectors, after=3D560 sectors
          State : active
    Device UUID : a25cccf5:d23f2274:30dc0ffa:d8a79f14

  Reshape pos'n : 29073984 (27.73 GiB 29.77 GB)
  Delta Devices : 1 (3->4)

    Update Time : Wed Jan  4 06:09:53 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks p=
resent.
       Checksum : 85b982a - correct
         Events : 39050

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)
/dev/sdm:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0xc
     Array UUID : a9946f57:e2c50b35:d192467d:fa495817
           Name : mars:2  (local to host mars)
  Creation Time : Wed Jan 15 12:59:19 2014
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 7813775280 (3725.90 GiB 4000.65 GB)
     Array Size : 11720662080 (11177.69 GiB 12001.96 GB)
  Used Dev Size : 7813774720 (3725.90 GiB 4000.65 GB)
    Data Offset : 261888 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D261800 sectors, after=3D560 sectors
          State : active
    Device UUID : 21517788:cdc63605:5bdc0bee:d23cc234

  Reshape pos'n : 29073984 (27.73 GiB 29.77 GB)
  Delta Devices : 1 (3->4)

    Update Time : Wed Jan  4 06:09:53 2017
  Bad Block Log : 512 entries available at offset 72 sectors - bad blocks p=
resent.
       Checksum : 4039a8c7 - correct
         Events : 39050

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D re=
placing)

--wrqif2zrvmn5iyo6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlhsmT0ACgkQ2O7X88g7
+pq6URAAl+13NnvPmXHRmXn/PYm43uPdb7PZGdZ16Jw3dJXir03zeF6ShUKviurx
pCtWsRfGTam8qs60PhYRkl1iJCLvJzNbwTo81lAr9ffeiMTDhS66S/GQ47ng2sHU
h1/lar9/1CLojkuSzAY2a/T8vu0xIxHEy66BNG+xa8hW+Zdd+l/k9bfDazABcxXn
qb+MSj/61vilJax2+/3QqGnffIOHY6s1gngi2WmZ4qJn6nGUHW6z5tzRqVi8XLs3
mNoHDYqvq4O7jwQmAXQM02Jt3DS1X4KusN4p0EdwlTlNdQ/AqUpqOv8oEQSo47nG
oRimcHn7APefvtAzTYhJ/zV3AHd2CNdWSQdj7YxL4V5895kab+/OryJBLk26dzcg
RlTU6ZP3ZMhdAL+G/wj5BN6uLKfaD6OSxP5V3/p9Fac5KdxdYyckXa7H01EXkFiz
9NzAG2nTSk5Q1pHn8tPz2yjjA7YWiwUhy36PC0dVO66u6UXv1WSmBzlaqxECYKVO
hlf3u2eaxHGiQLpgblfPI7OnexgENilRucvbxrTdG+ogkYXScvLafksAsINoFt7p
9jgQUiDPIhJ8o11kjttpuv+FRML80VWeZDkw3GqPC829mMtm4PW1VxsyIRliJfYe
S4efR0sbdI9BFQomyF5lLTpjVmibr9Rnn01VKFK3RQeuBaGZ9BY=
=MyIe
-----END PGP SIGNATURE-----

--wrqif2zrvmn5iyo6--
