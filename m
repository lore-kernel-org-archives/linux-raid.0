From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Re-assemble RAID6 from SW to HW RAID
Date: Mon, 17 Nov 2014 22:51:33 +0000
Message-ID: <CADNH=7HeKemJvN5gNtxznZWArqe2ibBaMTMJqdfsKyYAr4EcKw@mail.gmail.com>
References: <CADNH=7H=ge5P9rm5hRjO3GhOFF-jAqFZrNMjNeEGVDwe=BOARw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7H=ge5P9rm5hRjO3GhOFF-jAqFZrNMjNeEGVDwe=BOARw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17 November 2014 22:14, Mathias Bur=C3=A9n <mathias.buren@gmail.com>=
 wrote:
> Hi all,
>
> I've a 6 disk RAID6 array, with 1 missing disk. I moved 2 of the HDDs
> from the on-board SATA controller to a LSI MegaRAID controller where =
I
> created them as individual RAID0's. The data in the array isn't
> important, but it'd be nice if I can reassemble it.
>
> This is what it looks like:
>
> $ for I in /dev/sd?;do sudo mdadm -E $I;done
>
>
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
>            Name : ion:md0  (local to host ion)
>   Creation Time : Tue Feb  5 17:33:27 2013
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 78df2586:cb5649aa:e0b6d211:d92dc224
>
>     Update Time : Tue Nov  4 21:43:49 2014
>        Checksum : 50c95b7c - correct
>          Events : 97557
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 5
>    Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
>            Name : ion:md0  (local to host ion)
>   Creation Time : Tue Feb  5 17:33:27 2013
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 41712f8c:255b0f3e:0e345f7b:e1504e42
>
>     Update Time : Tue Nov  4 21:43:49 2014
>        Checksum : 71b191d6 - correct
>          Events : 97557
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 1
>    Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdd:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
>            Name : ion:md0  (local to host ion)
>   Creation Time : Tue Feb  5 17:33:27 2013
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : a09fc60d:5c4a27a5:4b89bc33:29b01582
>
>     Update Time : Tue Nov  4 21:43:49 2014
>        Checksum : 528563ee - correct
>          Events : 97557
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 3
>    Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sde:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
>            Name : ion:md0  (local to host ion)
>   Creation Time : Tue Feb  5 17:33:27 2013
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 39c0b717:a9ca1dd7:bcba618f:caed0879
>
>     Update Time : Tue Nov  4 21:43:49 2014
>        Checksum : 55758eeb - correct
>          Events : 97557
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 4
>    Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdf:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
>            Name : ion:md0  (local to host ion)
>   Creation Time : Tue Feb  5 17:33:27 2013
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
>      Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
>   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 93568b01:632395bf:7d0082a5:db9b6ff9
>
>     Update Time : Tue Nov  4 21:43:49 2014
>        Checksum : 49d756ca - correct
>          Events : 97557
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing)
>
> $ ls -la /dev/disk/by-id/ | grep -v Cors | grep -v dm
>
> lrwxrwxrwx 1 root root   9 Nov 17 22:04
> ata-SAMSUNG_HD204UI_S2H7JR0B501861 -> ../../sdb
> lrwxrwxrwx 1 root root   9 Nov 17 22:04
> ata-WDC_WD20EARS-00J99B0_WD-WCAWZ2036074 -> ../../sdc
> lrwxrwxrwx 1 root root   9 Nov 17 22:04
> ata-WDC_WD20EARS-00MVWB0_WD-WMAZA6473013 -> ../../sdd
> lrwxrwxrwx 1 root root   9 Nov 17 22:04
> scsi-3600605b0025eff501bfd2d550b74a2d5 -> ../../sde
> lrwxrwxrwx 1 root root   9 Nov 17 22:04
> scsi-3600605b0025eff501bfd2d5709c4a486 -> ../../sdf
> lrwxrwxrwx 1 root root   9 Nov 17 22:04 wwn-0x50000f00500b6118 -> ../=
=2E./sdb
> lrwxrwxrwx 1 root root   9 Nov 17 22:04 wwn-0x50014ee0030a1204 -> ../=
=2E./sdd
> lrwxrwxrwx 1 root root   9 Nov 17 22:04 wwn-0x50014ee206d9cbd2 -> ../=
=2E./sdc
> lrwxrwxrwx 1 root root 9 Nov 17 22:04
> wwn-0x600605b0025eff501bfd2d550b74a2d5 -> ../../sde
> lrwxrwxrwx 1 root root   9 Nov 17 22:04
> wwn-0x600605b0025eff501bfd2d5709c4a486 -> ../../sdf
>
> Any idea if this is rescuable?
>
> Thanks


I tried something, but I'm not sure how to proceed:

$ sudo mdadm --verbose --assemble /dev/md0 /dev/sdb /dev/sde /dev/sdf
/dev/sda /dev/sdd
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sde is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdf is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sda is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdd is identified as a member of /dev/md0, slot 5.
mdadm: added /dev/sde to /dev/md0 as 1
mdadm: no uptodate device for slot 4 of /dev/md0
mdadm: added /dev/sdf to /dev/md0 as 3
mdadm: failed to add /dev/sda to /dev/md0: Invalid argument
mdadm: added /dev/sdd to /dev/md0 as 5
mdadm: failed to add /dev/sdb to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 3 drives - need 5 to start (use --run to=
 insist).

dmesg:

[ 1815.848865] md: md0 stopped.
[ 1815.848870] md: unbind<sdd>
[ 1815.869743] md: export_rdev(sdd)
[ 1815.869816] md: unbind<sdf>
[ 1815.894653] md: export_rdev(sdf)
[ 1815.894732] md: unbind<sde>
[ 1815.933751] md: export_rdev(sde)
[ 1823.136749] md: md0 stopped.
[ 1823.161460] md: bind<sde>
[ 1823.161556] md: bind<sdf>
[ 1823.161755] md: sda does not have a valid v1.2 superblock, not impor=
ting!
[ 1823.161759] md: md_import_device returned -22
[ 1823.161863] md: bind<sdd>
[ 1823.162029] md: sdb does not have a valid v1.2 superblock, not impor=
ting!
[ 1823.162032] md: md_import_device returned -22
[ 1823.162045] md: md0 stopped.
[ 1823.162048] md: unbind<sdd>
[ 1823.173683] md: export_rdev(sdd)
[ 1823.173690] md: unbind<sdf>
[ 1823.185723] md: export_rdev(sdf)
[ 1823.185742] md: unbind<sde>
[ 1823.193750] md: export_rdev(sde)

It appears to have a superblock?

$ sudo mdadm -E /dev/sda
/dev/sda:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
           Name : ion:md0  (local to host ion)
  Creation Time : Tue Feb  5 17:33:27 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 5860271024 (2794.40 GiB 3000.46 GB)
     Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262064 sectors, after=3D385940480 sectors
          State : clean
    Device UUID : 39c0b717:a9ca1dd7:bcba618f:caed0879

    Update Time : Tue Nov  4 21:43:49 2014
       Checksum : 55758eeb - correct
         Events : 97557

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)

$ sudo mdadm -E /dev/sdb
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 0ad2603e:e43283ee:02180773:98e716ef
           Name : ion:md0  (local to host ion)
  Creation Time : Tue Feb  5 17:33:27 2013
     Raid Level : raid6
   Raid Devices : 6

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 7813531648 (7451.56 GiB 8001.06 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262064 sectors, after=3D18446744073706818560=
 sectors
          State : clean
    Device UUID : 93568b01:632395bf:7d0082a5:db9b6ff9

    Update Time : Tue Nov  4 21:43:49 2014
       Checksum : 49d756ca - correct
         Events : 97557

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.AAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)

Ragards
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
