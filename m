From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Sat, 2 May 2009 21:52:59 +0200
Message-ID: <20090502195259.GA8499@darkside.22.kls.lan>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org> <18922.50050.860008.242658@notabene.brown> <slrnguupf4.911.Mario.Holbe@darkside.dyn.samba-tng.org> <slrngve39c.8a2.Mario.Holbe@darkside.dyn.samba-tng.org> <18938.23135.726382.733302@notabene.brown> <20090501175524.GA8163@darkside.22.kls.lan> <fb9dbbffc38b437042076747a41ddf9b.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fb9dbbffc38b437042076747a41ddf9b.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ZfOjI3PrQbgiZnxM
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 02, 2009 at 07:36:45AM +1000, NeilBrown wrote:
> On Sat, May 2, 2009 3:55 am, Mario 'BitKoenig' Holbe wrote:
> > However, can you confirm that the bitmap is really used in raid10
> > resync? I removed half of the disks (a correctly removable subset, of
=2E..
> > I'll try to watch this and will trigger you again when I have more
> > stable evidence, but perhaps you have some faster test-cases, I have to
> 1/ it processes the whole array from start to finish in chunk-sized blocks
>   and simply doesn't generate IO where it isn't needed.  This is different

It definitely does generate I/O all the time here.

> 2/ With raid1, when it skips a whole bitmap chunk, that chunk is not
>   included in the speed calculation.  With raid10, everything is included.

It doesn't seem to touch the sync-limits here.

> 3/ I found a bug.  If you have two devices missing and add just one,
>   then after the recovery it might clear the bitmap even though
>   there is another missing device.  When that device is re-added, it will

The resync does never seem to respect the bitmap here.

> What speed are (were) you getting for resync.  If it was around 200M/sec,
> then point 2 would explain it.  If it was closer to the device speed,
> then there must be something else going wrong.

I guess, there is something else going wrong here. I attached a (quite
large, sorry for that) transcript of what I was doing with the output of
what I think could help.

What I did:
* I had a stable and clean raid10 out of 6 disks with superblocks all
  uptodate, on-disk bitmaps all uptodate.
* I failed and removed 3 of the disks.
* I set some bits in the bitmap via mounting/umounting the raid10.
* I stopped the raid10 just to make sure all superblocks/bitmaps are
  uptodate.
* I assembled the raid10 again with 3 out of 6 devices now.
* I re-added the 3 missing disks.
  Please note, that I cannot add them all at the same time because if
  the array is read-write the resync starts immediately when the first
  device is added, while I cannot add devices as long as the array is
  read-only.
  In this immediately starting re-sync only the first of the three
  spares is synched, it seems to ignore the bitmap, and it generates
  I/O all the time, I just forgot to c'n'p the evidence. I have seen
  that 3 times now with iostat, it really does I/O.
* I stopped and started the array to make it resync over all 3 spares
  concurrently, it seems to ignore the bitmap, and it generates I/O
  all the time again.


regards
   Mario
--=20
() Ascii Ribbon Campaign
/\ Support plain text e-mail

--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=raid10-resync
Content-Transfer-Encoding: quoted-printable

root@darkside:~# head -4 /proc/mdstat=20
Personalities : [raid1] [raid10]=20
md7 : active raid10 sdc1[0] sdf1[1] sdg1[3] sdh1[5] sde1[4] sdd1[2]
      4395406848 blocks 512K chunks 2 near-copies [6/6] [UUUUUU]
      bitmap: 0/131 pages [0KB], 16384KB chunk
root@darkside:~# mdadm -E /dev/sd[c-h]1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 7

    Update Time : Sat May  2 21:22:22 2009
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e2f919ac - correct
         Events : 13278

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8      113        5      active sync   /dev/sdh1
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 7

    Update Time : Sat May  2 21:22:22 2009
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e2f919c0 - correct
         Events : 13278

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     2       8       49        2      active sync   /dev/sdd1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8      113        5      active sync   /dev/sdh1
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 7

    Update Time : Sat May  2 21:22:22 2009
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e2f919d4 - correct
         Events : 13278

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8      113        5      active sync   /dev/sdh1
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 7

    Update Time : Sat May  2 21:22:22 2009
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e2f919de - correct
         Events : 13278

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     1       8       81        1      active sync   /dev/sdf1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8      113        5      active sync   /dev/sdh1
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 7

    Update Time : Sat May  2 21:22:22 2009
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e2f919f2 - correct
         Events : 13278

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     3       8       97        3      active sync   /dev/sdg1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8      113        5      active sync   /dev/sdh1
/dev/sdh1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 7

    Update Time : Sat May  2 21:22:22 2009
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e2f91a06 - correct
         Events : 13278

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     5       8      113        5      active sync   /dev/sdh1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8      113        5      active sync   /dev/sdh1
root@darkside:~# mdadm -X /dev/sd[c-h]1
        Filename : /dev/sdc1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13278
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 0 dirty (0.0%)
        Filename : /dev/sdd1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13278
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 0 dirty (0.0%)
        Filename : /dev/sde1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13278
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 0 dirty (0.0%)
        Filename : /dev/sdf1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13278
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 0 dirty (0.0%)
        Filename : /dev/sdg1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13278
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 0 dirty (0.0%)
        Filename : /dev/sdh1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13278
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 0 dirty (0.0%)
root@darkside:~# mdadm --fail /dev/md7 /dev/sd[fgh]1
mdadm: set /dev/sdf1 faulty in /dev/md7
mdadm: set /dev/sdg1 faulty in /dev/md7
mdadm: set /dev/sdh1 faulty in /dev/md7
root@darkside:~# mdadm --remove /dev/md7 /dev/sd[fgh]1
mdadm: hot removed /dev/sdf1
mdadm: hot removed /dev/sdg1
mdadm: hot removed /dev/sdh1
root@darkside:~# mount -a
root@darkside:~# umount /dev/md7
root@darkside:~# mdadm --stop /dev/md7
mdadm: stopped /dev/md7
root@darkside:~# mdadm -E /dev/sd[c-h]1
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 3
Preferred Minor : 7

    Update Time : Sat May  2 21:24:31 2009
          State : clean
Internal Bitmap : present
 Active Devices : 3
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 0
       Checksum : e2f91915 - correct
         Events : 13294

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       0        0        5      faulty removed
/dev/sdd1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 3
Preferred Minor : 7

    Update Time : Sat May  2 21:24:31 2009
          State : clean
Internal Bitmap : present
 Active Devices : 3
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 0
       Checksum : e2f91929 - correct
         Events : 13294

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     2       8       49        2      active sync   /dev/sdd1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       0        0        5      faulty removed
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 3
Preferred Minor : 7

    Update Time : Sat May  2 21:24:31 2009
          State : clean
Internal Bitmap : present
 Active Devices : 3
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 0
       Checksum : e2f9193d - correct
         Events : 13294

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       0        0        5      faulty removed
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 7

    Update Time : Sat May  2 21:22:22 2009
          State : clean
Internal Bitmap : present
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : e2f919de - correct
         Events : 13278

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     1       8       81        1      active sync   /dev/sdf1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8      113        5      active sync   /dev/sdh1
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 7

    Update Time : Sat May  2 21:23:51 2009
          State : clean
Internal Bitmap : present
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : e2f91a5e - correct
         Events : 13280

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     3       8       97        3      active sync   /dev/sdg1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       97        3      active sync   /dev/sdg1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8      113        5      active sync   /dev/sdh1
/dev/sdh1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : bbcc5f03:13105928:bea48659:c10950ee
  Creation Time : Sat Apr 18 18:26:28 2009
     Raid Level : raid10
  Used Dev Size : 1465135616 (1397.26 GiB 1500.30 GB)
     Array Size : 4395406848 (4191.79 GiB 4500.90 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 7

    Update Time : Sat May  2 21:23:51 2009
          State : clean
Internal Bitmap : present
 Active Devices : 4
Working Devices : 4
 Failed Devices : 2
  Spare Devices : 0
       Checksum : e2f91a87 - correct
         Events : 13282

         Layout : near=3D2
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     5       8      113        5      active sync   /dev/sdh1

   0     0       8       33        0      active sync   /dev/sdc1
   1     1       0        0        1      faulty removed
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       0        0        3      faulty removed
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8      113        5      active sync   /dev/sdh1
root@darkside:~# mdadm -X /dev/sd[c-h]1
        Filename : /dev/sdc1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13294
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 3 dirty (0.0%)
        Filename : /dev/sdd1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13294
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 3 dirty (0.0%)
        Filename : /dev/sde1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13294
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 3 dirty (0.0%)
        Filename : /dev/sdf1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13278
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 0 dirty (0.0%)
        Filename : /dev/sdg1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13280
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 0 dirty (0.0%)
        Filename : /dev/sdh1
           Magic : 6d746962
         Version : 4
            UUID : bbcc5f03:13105928:bea48659:c10950ee
          Events : 13282
  Events Cleared : 13278
           State : OK
       Chunksize : 16 MB
          Daemon : 5s flush period
      Write Mode : Normal
       Sync Size : 4395406848 (4191.79 GiB 4500.90 GB)
          Bitmap : 268275 bits (chunks), 0 dirty (0.0%)
root@darkside:~# mdadm -A /dev/md7
[115116.898904] md: bind<sdf1>
[115116.907579] md: bind<sdd1>
[115116.916526] md: bind<sdg1>
[115116.926345] md: bind<sde1>
[115116.935542] md: bind<sdh1>
[115116.944477] md: bind<sdc1>
[115116.953071] md: kicking non-fresh sdh1 from array!
[115116.967686] md: unbind<sdh1>
[115116.977298] md: export_rdev(sdh1)
[115116.987495] md: kicking non-fresh sdg1 from array!
[115117.002105] md: unbind<sdg1>
[115117.012009] md: export_rdev(sdg1)
[115117.022209] md: kicking non-fresh sdf1 from array!
[115117.036817] md: unbind<sdf1>
[115117.046827] md: export_rdev(sdf1)
[115117.058179] raid10: raid set md7 active with 3 out of 6 devices
[115117.083006] md7: bitmap initialized from disk: read 9/9 pages, set 3 bi=
ts
[115117.103594] created bitmap (131 pages) for device md7
[115117.171218] md7: detected capacity change from 0 to 4500896612352
[115117.189718]  md7: unknown partition table
mdadm: /dev/md7 has been started with 3 drives (out of 6).
root@darkside:~# mdadm --readonly /dev/md7
[115125.143499] md: md7 switched to read-only mode.
root@darkside:~# mdadm --add /dev/md7 /dev/sd[fgh]1
mdadm: add new device failed for /dev/sdf1 as 6: Read-only file system
root@darkside:~# head -4 /proc/mdstat=20
Personalities : [raid1] [raid10]=20
md7 : active (read-only) raid10 sdc1[0] sde1[4] sdd1[2]
      4395406848 blocks 512K chunks 2 near-copies [6/3] [U_U_U_]
      bitmap: 2/131 pages [8KB], 16384KB chunk
root@darkside:~# mdadm --readwrite /dev/md7
[115207.027682] md: md7 switched to read-write mode.
root@darkside:~# mdadm --add /dev/md7 /dev/sd[fgh]1
[115218.558523] md: bind<sdf1>
[115218.641655] RAID10 conf printout:
[115218.651846]  --- wd:3 rd:6
[115218.660217]  disk 0, wo:0, o:1, dev:sdc1
[115218.660219]  disk 1, wo:1, o:1, dev:sdf1
[115218.660220]  disk 2, wo:0, o:1, dev:sdd1
[115218.660222]  disk 4, wo:0, o:1, dev:sde1
[115218.709281] md: recovery of RAID array md7
[115218.721834] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[115218.739591] md: using maximum available idle IO bandwidth (but not more=
 than 200000 KB/sec) for recovery.
[115218.739596] md: using 128k window, over a total of 1465135616 blocks.
mdadm: re-added /dev/sdf1
[115220.582354] md: bind<sdg1>
[115221.844379] md: bind<sdh1>
mdadm: re-added /dev/sdg1
mdadm: re-added /dev/sdh1
root@darkside:~# head -4 /proc/mdstat=20
Personalities : [raid1] [raid10]=20
md7 : active raid10 sdh1[6](S) sdg1[7](S) sdf1[8] sdc1[0] sde1[4] sdd1[2]
      4395406848 blocks 512K chunks 2 near-copies [6/3] [U_U_U_]
      [>....................]  recovery =3D  0.2% (3877760/1465135616) fini=
sh=3D200.9min speed=3D121180K/sec
root@darkside:~# sleep 60
root@darkside:~# head -4 /proc/mdstat=20
Personalities : [raid1] [raid10]=20
md7 : active raid10 sdh1[6](S) sdg1[7](S) sdf1[8] sdc1[0] sde1[4] sdd1[2]
      4395406848 blocks 512K chunks 2 near-copies [6/3] [U_U_U_]
      [>....................]  recovery =3D  2.0% (29498240/1465135616) fin=
ish=3D193.0min speed=3D123907K/sec
root@darkside:~# mdadm --stop /dev/md7
mdadm: stopped /dev/md7
root@darkside:~# mdadm -A /dev/md7
mdadm: /dev/md7 has been started with 3 drives (out of 6) and 3 spares.
root@darkside:~# head -4 /proc/mdstat=20
Personalities : [raid1] [raid10]=20
md7 : active (auto-read-only) raid10 sdc1[0] sdf1[8](S) sdg1[7](S) sdh1[6](=
S) sde1[4] sdd1[2]
      4395406848 blocks 512K chunks 2 near-copies [6/3] [U_U_U_]
      bitmap: 1/131 pages [4KB], 16384KB chunk
root@darkside:~# mdadm --readwrite /dev/md7
root@darkside:~# head -4 /proc/mdstat=20
Personalities : [raid1] [raid10]=20
md7 : active raid10 sdc1[0] sdf1[8] sdg1[7] sdh1[6] sde1[4] sdd1[2]
      4395406848 blocks 512K chunks 2 near-copies [6/3] [U_U_U_]
      [>....................]  recovery =3D  0.0% (172608/1465135616) finis=
h=3D282.7min speed=3D86304K/sec
root@darkside:~# sleep 10
root@darkside:~# head -4 /proc/mdstat=20
Personalities : [raid1] [raid10]=20
md7 : active raid10 sdc1[0] sdf1[8] sdg1[7] sdh1[6] sde1[4] sdd1[2]
      4395406848 blocks 512K chunks 2 near-copies [6/3] [U_U_U_]
      [>....................]  recovery =3D  0.2% (4008384/1465135616) fini=
sh=3D323.8min speed=3D75191K/sec
root@darkside:~# iostat -m /dev/sd[c-h] 10 2 | tail -11
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           1,34    0,10    4,75    0,99    0,00   92,83

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdc             759,90        73,45         0,00        734          0
sdd             752,20        73,45         0,00        734          0
sde             753,10        73,45         0,00        734          0
sdf             730,70         0,00        73,45          0        734
sdg             261,10         0,00        73,47          0        734
sdh             290,60         0,00        73,41          0        734

--EeQfGwPcQSOJBaQU--

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSfykmxS+e2HeSPbpAQKY2wf6AwNozf6p9gr2H4+vbSVohl7/hKPmo86R
IXQhebiQPbu+qSkLY18MadSPPzsyWxCySkAeA7mX1WYB/imhppxIIKnEEWoSeLgV
+mj2Pnm/HJXWA2sDFeXUM0gAiHoufCtffrXMGoVLXiHwGmgCUc0kpET5z/8xwEIi
gpBAIEnRIy4JN8/uUjfl64zF+JISw60Wn0aih/xnXudk3XRVJnCFf0/CxTDAxYwC
tPQbPBo9tvbSi3DjU/L4hXSIp31xf2AdIW3IErZmWWp34Ts80eLRmZcYdhQasu6q
cvNzmbe8naIgA4o/AB0MhISXweaJVPM8vapMA+8zJ3H0obr++AJ6aw==
=a+IW
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
