From: Sebastian Hegler <sebastian.hegler@tu-dresden.de>
Subject: Re: mdadm-3.2.5: segfault in "--grow --continue"
Date: Tue, 10 Jul 2012 18:51:22 +0200
Message-ID: <BC57DF1E-7CA3-429E-8935-44A94003B5E5@tu-dresden.de>
References: <D6EAEC68-9C5B-4CBF-943C-85ABF3E319BD@tu-dresden.de> <20120710230205.171ee562@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: multipart/mixed; boundary="Apple-Mail=_88F5A3F9-4DD9-40C6-B56B-3C2560E7D484"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120710230205.171ee562@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, 681056@bugs.debian.org
List-Id: linux-raid.ids


--Apple-Mail=_88F5A3F9-4DD9-40C6-B56B-3C2560E7D484
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi!

Am 10.07.2012 um 15:02 schrieb NeilBrown:
> On Tue, 10 Jul 2012 12:46:19 +0200 Sebastian Hegler =
<sebastian.hegler@tu-dresden.de> wrote:
>> I had to shut down a server with a raid grow operation (cleanly). =
After some hassles I got the array assembled again (manually), but it =
would not continue to grow. When trying=20
>>=20
>> mdadm --grow --continue /dev/md127=20
>>=20
>> (as per the manpage) I receive a segfault. Compiling from source, and =
using gdb, I see:
>>=20
>> root@kuiper:~/mdadm-3.2.5# gdb ./mdadm=20
>> [SNIP]
>> Reading symbols from /root/mdadm-3.2.5/mdadm...done.
>> (gdb) set args --grow --continue /dev/md127=20
>> (gdb) run=20
>> Starting program: /root/mdadm-3.2.5/mdadm --grow --continue =
/dev/md127=20
>>=20
>> Program received signal SIGSEGV, Segmentation fault.
>> Grow_continue_command (devname=3D0x7fffffffe8cc "/dev/md127", fd=3D7, =
backup_file=3D0x0, verbose=3D0) at Grow.c:4118
>> 4118		if (verify_reshape_position(content,
>> (gdb) bt
>> #0  Grow_continue_command (devname=3D0x7fffffffe8cc "/dev/md127", =
fd=3D7, backup_file=3D0x0, verbose=3D0) at Grow.c:4118
>> #1  0x0000000000407ac2 in main (argc=3D4, argv=3D0x7fffffffe678) at =
mdadm.c:1701
>>=20
>>=20
>>=20
>> The same bug is present in the git repository, but another location:
>>=20
>> root@kuiper:~/mdadm.git# gdb ./mdadm=20
>> [SNIP]
>> Reading symbols from /root/mdadm.git/mdadm...done.
>> (gdb) set args --grow --continue /dev/md127=20
>> (gdb) run=20
>> Starting program: /root/mdadm.git/mdadm --grow --continue /dev/md127=20=

>>=20
>> Program received signal SIGSEGV, Segmentation fault.
>> Grow_continue_command (devname=3D0x7fffffffe8d0 "/dev/md127", fd=3D7, =
backup_file=3D0x0, verbose=3D0) at Grow.c:4086
>> 4086		if (verify_reshape_position(content,
>> (gdb) bt
>> #0  Grow_continue_command (devname=3D0x7fffffffe8d0 "/dev/md127", =
fd=3D7, backup_file=3D0x0, verbose=3D0) at Grow.c:4086
>> #1  0x0000000000406c39 in main (argc=3D4, argv=3D0x7fffffffe678) at =
mdadm.c:1447
>>=20
>>=20
>> I also filed a bug against Debian's BTS, but I did not receive a bug =
number yet. In the meantime, I'd be very happy about any information on =
how to get my RAID array back into growing. I'm not on the list, please =
CC me.
>=20
> --grow --continue should only be needed if the array was assembled =
with --freeze-reshape (I think).
>=20
> Normally, the reshape should continue automatically.
Well, it did not.

> cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]=20
md127 : active raid6 sdi[14] sdh[22] sdt[11] sdp[16] sdq[13] sdo[17] =
sdn[18] sdu[12] sdm[19] sdl[20] sdk[21] sdj[15]
      17581629312 blocks super 1.2 level 6, 128k chunk, algorithm 2 =
[12/12] [UUUUUUUUUUUU]

> mdadm -E ....
root@kuiper:~# for i in /sys/block/md127/md/dev-sd* ; do mdadm -E =
/`basename $i |tr - / ` ; done=20
/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : f281deb2:b5de8070:487c1900:0078e6e1

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:45 2012
       Checksum : 16d3efce - correct
         Events : 6245853

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 11
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdi:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b67b1847:cb68ac69:7ab0b4ee:894a268b

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:45 2012
       Checksum : 3c147a5b - correct
         Events : 6245853

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdj:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5c4e03cc:e2fe014e:bd3d17a9:517d34f5

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:46 2012
       Checksum : c9c5a324 - correct
         Events : 6245852

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdk:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e276dc2b:048e6135:2364e8d0:00566eed

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:46 2012
       Checksum : 310959e7 - correct
         Events : 6245852

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdl:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 547956df:6be81839:89424cbc:664bc6d6

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:46 2012
       Checksum : bcf68a8b - correct
         Events : 6245852

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdm:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 72a0a33b:faa5ecd4:7b543389:f49798a2

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:46 2012
       Checksum : 4dd0cdb7 - correct
         Events : 6245852

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 4
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdn:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 11c4c3ac:ac1be81a:d4750037:45a85a60

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:46 2012
       Checksum : 707b98b0 - correct
         Events : 6245852

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 6
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdo:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 76692433:04aab129:7f46b4f6:d2d93ffd

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:46 2012
       Checksum : 623ecea5 - correct
         Events : 6245852

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 7
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdp:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f62ba0d8:17345ece:55a5d1bf:39540cc5

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:46 2012
       Checksum : 3d50f475 - correct
         Events : 6245852

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 9
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdq:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a4091eff:68556278:3a22b428:aa59ea46

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:46 2012
       Checksum : f89375c5 - correct
         Events : 6245852

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 8
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdt:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f8425467:c7533842:df4c4da6:424e107f

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:46 2012
       Checksum : e05eccb3 - correct
         Events : 6245852

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 10
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdu:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 42683d6d:6479d415:492ede77:6fe9437b
           Name : kuiper:scratch2G  (local to host kuiper)
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
   Raid Devices : 12

 Avail Dev Size : 3907028736 (1863.02 GiB 2000.40 GB)
     Array Size : 19535143680 (18630.17 GiB 20003.99 GB)
    Data Offset : 432 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : acde8544:51d21dcd:e6b6827e:c258f274

  Reshape pos'n : 6220766720 (5932.59 GiB 6370.07 GB)
  Delta Devices : 1 (11->12)

    Update Time : Tue Jul 10 16:10:46 2012
       Checksum : 168d5b7a - correct
         Events : 6245852

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 5
   Array State : AAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

> mdadm -D ...
root@kuiper:~# mdadm -D /dev/md127=20
/dev/md127:
        Version : 1.2
  Creation Time : Fri Apr 16 12:26:18 2010
     Raid Level : raid6
     Array Size : 17581629312 (16767.15 GiB 18003.59 GB)
  Used Dev Size : 1953514368 (1863.02 GiB 2000.40 GB)
   Raid Devices : 12
  Total Devices : 12
    Persistence : Superblock is persistent

    Update Time : Tue Jul 10 16:11:23 2012
          State : clean=20
 Active Devices : 12
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

  Delta Devices : 1, (11->12)

           Name : kuiper:scratch2G  (local to host kuiper)
           UUID : 42683d6d:6479d415:492ede77:6fe9437b
         Events : 6245852

    Number   Major   Minor   RaidDevice State
      14       8      128        0      active sync   /dev/sdi
      15       8      144        1      active sync   /dev/sdj
      21       8      160        2      active sync   /dev/sdk
      20       8      176        3      active sync   /dev/sdl
      19       8      192        4      active sync   /dev/sdm
      12      65       64        5      active sync   /dev/sdu
      18       8      208        6      active sync   /dev/sdn
      17       8      224        7      active sync   /dev/sdo
      13      65        0        8      active sync   /dev/sdq
      16       8      240        9      active sync   /dev/sdp
      11      65       48       10      active sync   /dev/sdt
      22       8      112       11      active sync   /dev/sdh

> would be helpful, maybe together with kernel logs if there are any.
Please see the attached files. I truncated the file up until the first =
segfault of mdadm. Short wrapup of the contents:
* Bad interaction: "mpt-sas ioc1" is too slow for md. md is assembling =
RAID arrays from the disks it sees, creating some MD devices, one =
partially broken and recovering where there is no need (if md had =
waited), and two incomplete arrays actually belonging to one array =
(timestamps: 35.655213, 34.528229). Some disks are also completely =
missing thanks to failed slots in the enclosure.
* I then removed all drives belonging to the array I interrupted in the =
Grow procedure (via "/sys/block/sd*/delete"), re-inserted them into the =
enclosure, and re-assembled the RAID array manually. Finish is at =
"1397.498460": "md/raid:md127: reshape will continue"
* At "1565.278839" The RAID array is in "auto-read-only" mode. I mount =
the FS, wondering about not seeing the enclosure LEDs blink. After =
checking "/proc/mdstat", I see that everything is quiet, although I =
expected a progress bar.
* At "2612.464768" (fourth-to-last line) mdadm segfaults with the =
command "mdadm --grow --continue /dev/md127"

After yet another reboot, and careful manual re-assembly of the RAID =
array in question, everything works fine. Grow operation continued after =
mounting the file system.=20

The issue was assigned bug number 681056 in the Debian BTS in the =
meantime: CCing the BTS.

Yours,
Sebastian

--Apple-Mail=_88F5A3F9-4DD9-40C6-B56B-3C2560E7D484
Content-Disposition: attachment;
	filename=kern.mdcrash.log.xz
Content-Type: application/octet-stream;
	name="kern.mdcrash.log.xz"
Content-Transfer-Encoding: base64

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

--Apple-Mail=_88F5A3F9-4DD9-40C6-B56B-3C2560E7D484--
