From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: dm-crypt over raid6 unreadable after crash
Date: Thu, 7 Jul 2011 11:05:40 +0200
Message-ID: <20110707090540.GA7288@apartia.fr>
References: <20110706161228.GA1491@apartia.fr>
 <4E1494BB.9060101@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E1494BB.9060101@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 06, 2011 at 01:00:43PM -0400, Phil Turmel wrote:
> > After a hardware crash I can no longer open a dm-crypt partition lo=
cated
> > directly over a md-raid6 partition. I get this error:
> >=20
> > 	root@grml ~ # cryptsetup isLuks /dev/md1=20
> > 	Device /dev/md1 is not a valid LUKS device
> >=20
> > It seems the LUKS header has been shifted a few bytes forward, but =
looks
> > otherwise fine to specialists on the dm-crypt mailing list. Normall=
y the
> > "LUKS" signature should be at 0x00000000
> >=20
> > Is there some way that the md layer could have shifted its contents=
?
> >=20
> > Here is a hexdum of /dev/md1 done with "hd /dev/md1 | head -n 40"
> >=20
> > 00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |......=
=2E.........|
> > *
> > 00100000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00  |LUKS..=
=2E.aes.....|
> > 00100010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |......=
=2E.........|
> > 00100020  00 00 00 00 00 00 00 00  63 62 63 2d 65 73 73 69  |......=
=2E.cbc-essi|
> > 00100030  76 3a 73 68 61 32 35 36  00 00 00 00 00 00 00 00  |v:sha2=
56........|

Hi Phil,

> The offset is precisely 1MB.  This is the default data offset for
> metadata types 1.1 and 1.2 (nowadays).  Metadata types 0.90 and 1.0
> have a zero offset (the metadata is at the end.)
>=20
> You don't say what your recovery efforts were, but I'd guess you did =
a
> "mdadm --create" somewhere in there, and didn't match the original
> parameters.  Or you used an older version of mdadm than was used
> originally, and therefore got different defaults.

No I did a mdadm-startall with a grml livecd.

> Another possibility is that the original array was set up on a 1MB
> aligned partition, and the array is now using the whole device.  This
> can happen with v0.90 metadata.  If so, the original partition table
> is obviously zeroed out now.
>=20
> Please share more information about what you've done so far.  Also

Nothing appart from assembling the array and failing to decrypt it with
cryptsetup.

> show us the output of "mdadm -D /dev/md1"=20

/dev/md1:
        Version : 1.2
  Creation Time : Wed Oct 20 21:40:40 2010
     Raid Level : raid6
     Array Size : 841863168 (802.86 GiB 862.07 GB)
  Used Dev Size : 140310528 (133.81 GiB 143.68 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Jul  7 09:44:49 2011
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : grml:1  (local to host grml)
           UUID : 1434a46a:f2b751cd:8604803c:b545de8c
         Events : 8292

    Number   Major   Minor   RaidDevice State
       0       8      130        0      active sync   /dev/sdi2
       1       8       50        1      active sync   /dev/sdd2
       2       8       34        2      active sync   /dev/sdc2
       3       8       82        3      active sync   /dev/sdf2
       4       8       66        4      active sync   /dev/sde2
       5       8      146        5      active sync   /dev/sdj2
       8       8      114        6      active sync   /dev/sdh2
       7       8       98        7      active sync   /dev/sdg2

> and then "mdadm -E /dev/xxx" for each of its components.


/dev/sdc2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1434a46a:f2b751cd:8604803c:b545de8c
           Name : grml:1  (local to host grml)
  Creation Time : Wed Oct 20 21:40:40 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 280621372 (133.81 GiB 143.68 GB)
     Array Size : 1683726336 (802.86 GiB 862.07 GB)
  Used Dev Size : 280621056 (133.81 GiB 143.68 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0a10d6c3:8a6f1948:f1a546a4:32f10094

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Jul  7 11:00:42 2011
       Checksum : 16c1099b - correct
         Events : 8292

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1434a46a:f2b751cd:8604803c:b545de8c
           Name : grml:1  (local to host grml)
  Creation Time : Wed Oct 20 21:40:40 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 280621372 (133.81 GiB 143.68 GB)
     Array Size : 1683726336 (802.86 GiB 862.07 GB)
  Used Dev Size : 280621056 (133.81 GiB 143.68 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5f8c46cb:614354cf:dd91f7c2:f1260b2e

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Jul  7 11:00:42 2011
       Checksum : 5e277b71 - correct
         Events : 8292

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1434a46a:f2b751cd:8604803c:b545de8c
           Name : grml:1  (local to host grml)
  Creation Time : Wed Oct 20 21:40:40 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 280621372 (133.81 GiB 143.68 GB)
     Array Size : 1683726336 (802.86 GiB 862.07 GB)
  Used Dev Size : 280621056 (133.81 GiB 143.68 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : ab27b114:ea95aa0a:9adb310b:c456ee56

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Jul  7 11:00:42 2011
       Checksum : 5405e2d7 - correct
         Events : 8292

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdf2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1434a46a:f2b751cd:8604803c:b545de8c
           Name : grml:1  (local to host grml)
  Creation Time : Wed Oct 20 21:40:40 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 280621372 (133.81 GiB 143.68 GB)
     Array Size : 1683726336 (802.86 GiB 862.07 GB)
  Used Dev Size : 280621056 (133.81 GiB 143.68 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 31bc8c85:7b754501:ea0b713e:2714810a

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Jul  7 11:00:42 2011
       Checksum : a24e44a0 - correct
         Events : 8292

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdg2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1434a46a:f2b751cd:8604803c:b545de8c
           Name : grml:1  (local to host grml)
  Creation Time : Wed Oct 20 21:40:40 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 280621372 (133.81 GiB 143.68 GB)
     Array Size : 1683726336 (802.86 GiB 862.07 GB)
  Used Dev Size : 280621056 (133.81 GiB 143.68 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4db23afd:d4422390:e39d701e:7223cc9e

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Jul  7 11:00:42 2011
       Checksum : 1d24a95f - correct
         Events : 8292

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdh2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1434a46a:f2b751cd:8604803c:b545de8c
           Name : grml:1  (local to host grml)
  Creation Time : Wed Oct 20 21:40:40 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 280621372 (133.81 GiB 143.68 GB)
     Array Size : 1683726336 (802.86 GiB 862.07 GB)
  Used Dev Size : 280621056 (133.81 GiB 143.68 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1f220bf2:1c86fc2b:0e99f2d2:8283497c

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Jul  7 11:00:42 2011
       Checksum : 3fcdb7b5 - correct
         Events : 8292

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdi2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1434a46a:f2b751cd:8604803c:b545de8c
           Name : grml:1  (local to host grml)
  Creation Time : Wed Oct 20 21:40:40 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 280621372 (133.81 GiB 143.68 GB)
     Array Size : 1683726336 (802.86 GiB 862.07 GB)
  Used Dev Size : 280621056 (133.81 GiB 143.68 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6acb87a4:3ac53237:1f5fff58:3611a0b0

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Jul  7 11:00:42 2011
       Checksum : b7e3f3da - correct
         Events : 8292

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdj2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : 1434a46a:f2b751cd:8604803c:b545de8c
           Name : grml:1  (local to host grml)
  Creation Time : Wed Oct 20 21:40:40 2010
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 280621372 (133.81 GiB 143.68 GB)
     Array Size : 1683726336 (802.86 GiB 862.07 GB)
  Used Dev Size : 280621056 (133.81 GiB 143.68 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1515f5a7:b0c78638:8ca1d918:f1fa47d7

Internal Bitmap : 2 sectors from superblock
    Update Time : Thu Jul  7 11:00:42 2011
       Checksum : a3276c28 - correct
         Events : 8292

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

> The output of "lsdrv"[1] would also be useful for visualizing your se=
tup.

PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation 82801IB (ICH9) =
2 port SATA IDE Controller (rev 02)
 =E2=94=9C=E2=94=80scsi 0:0:0:0 HL-DT-ST DVD+-RW GH50N {K1LA7D41849}
 =E2=94=82  =E2=94=94=E2=94=80sr0: [11:0] Partitioned (dos) 224.00m 'gr=
ml64-medium_2011.05'
 =E2=94=82     =E2=94=94=E2=94=80Mounted as /dev/sr0 @ /live/image
 =E2=94=94=E2=94=80scsi 1:x:x:x [Empty]
PCI [mpt2sas] 02:00.0 Serial Attached SCSI controller: LSI Logic / Symb=
ios Logic SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 02)
 =E2=94=9C=E2=94=80scsi 2:0:0:0 ATA WDC WD1002FAEX-0 {WD-WCATR1851552}
 =E2=94=82  =E2=94=94=E2=94=80sdc: [8:32] Partitioned (dos) 931.51g
 =E2=94=82     =E2=94=9C=E2=94=80sdc1: [8:33] MD raid1 (2/8) 250.98m md=
0 clean in_sync {2871f814-ceb7-6a88-d8b7-8f6599226e41}
 =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80md0: [9:0] Partitioned (dos=
) 250.88m {d1d876e9-6905-4940-bf55-7cdb4b64484f}
 =E2=94=82     =E2=94=9C=E2=94=80sdc2: [8:34] MD raid6 (2/8) 133.81g md=
1 clean in_sync 'grml:1' {1434a46a-f2b7-51cd-8604-803cb545de8c}
 =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80md1: [9:1] Empty/Unknown 80=
2.86g
 =E2=94=82     =E2=94=94=E2=94=80sdc3: [8:35] MD raid6 (0/8) 797.36g md=
2 clean in_sync 'zenon:2' {5c037ba3-ca4b-f7b9-eb8f-b01608e1fd3b}
 =E2=94=82        =E2=94=94=E2=94=80md2: [9:2] (crypto_LUKS) 4.67t {1d3=
0a244-9d40-48e8-925a-1d6c93a45474}
 =E2=94=82           =E2=94=94=E2=94=80dm-0: [253:0] (xfs) 4.67t {3cad6=
3a0-a586-43e0-bf89-5be9066c884f}
 =E2=94=82              =E2=94=94=E2=94=80Mounted as /dev/mapper/cmd2 @=
 /backup
 =E2=94=9C=E2=94=80scsi 2:0:1:0 ATA WDC WD1002FAEX-0 {WD-WCATR2968402}
 =E2=94=82  =E2=94=94=E2=94=80sdd: [8:48] Partitioned (dos) 931.51g
 =E2=94=82     =E2=94=9C=E2=94=80sdd1: [8:49] MD raid1 (3/8) 250.98m md=
0 clean in_sync {2871f814-ceb7-6a88-d8b7-8f6599226e41}
 =E2=94=82     =E2=94=9C=E2=94=80sdd2: [8:50] MD raid6 (1/8) 133.81g md=
1 clean in_sync 'grml:1' {1434a46a-f2b7-51cd-8604-803cb545de8c}
 =E2=94=82     =E2=94=94=E2=94=80sdd3: [8:51] MD raid6 (5/8) 797.36g md=
2 clean in_sync 'zenon:2' {5c037ba3-ca4b-f7b9-eb8f-b01608e1fd3b}
 =E2=94=9C=E2=94=80scsi 2:0:2:0 ATA WDC WD1002FAEX-0 {WD-WCATR1851573}
 =E2=94=82  =E2=94=94=E2=94=80sde: [8:64] Partitioned (dos) 931.51g
 =E2=94=82     =E2=94=9C=E2=94=80sde1: [8:65] MD raid1 (7/8) 250.98m md=
0 clean in_sync {2871f814-ceb7-6a88-d8b7-8f6599226e41}
 =E2=94=82     =E2=94=9C=E2=94=80sde2: [8:66] MD raid6 (4/8) 133.81g md=
1 clean in_sync 'grml:1' {1434a46a-f2b7-51cd-8604-803cb545de8c}
 =E2=94=82     =E2=94=94=E2=94=80sde3: [8:67] MD raid6 (6/8) 797.36g md=
2 clean in_sync 'zenon:2' {5c037ba3-ca4b-f7b9-eb8f-b01608e1fd3b}
 =E2=94=9C=E2=94=80scsi 2:0:3:0 ATA WDC WD1002FAEX-0 {WD-WCATR3005506}
 =E2=94=82  =E2=94=94=E2=94=80sdf: [8:80] Partitioned (dos) 931.51g
 =E2=94=82     =E2=94=9C=E2=94=80sdf1: [8:81] MD raid1 (0/8) 250.98m md=
0 clean in_sync {2871f814-ceb7-6a88-d8b7-8f6599226e41}
 =E2=94=82     =E2=94=9C=E2=94=80sdf2: [8:82] MD raid6 (3/8) 133.81g md=
1 clean in_sync 'grml:1' {1434a46a-f2b7-51cd-8604-803cb545de8c}
 =E2=94=82     =E2=94=94=E2=94=80sdf3: [8:83] MD raid6 (4/8) 797.36g md=
2 clean in_sync 'zenon:2' {5c037ba3-ca4b-f7b9-eb8f-b01608e1fd3b}
 =E2=94=9C=E2=94=80scsi 2:0:4:0 ATA WDC WD1002FAEX-0 {WD-WCATR3007070}
 =E2=94=82  =E2=94=94=E2=94=80sdg: [8:96] Partitioned (dos) 931.51g
 =E2=94=82     =E2=94=9C=E2=94=80sdg1: [8:97] MD raid1 (6/8) 250.98m md=
0 clean in_sync {2871f814-ceb7-6a88-d8b7-8f6599226e41}
 =E2=94=82     =E2=94=9C=E2=94=80sdg2: [8:98] MD raid6 (7/8) 133.81g md=
1 clean in_sync 'grml:1' {1434a46a-f2b7-51cd-8604-803cb545de8c}
 =E2=94=82     =E2=94=94=E2=94=80sdg3: [8:99] MD raid6 (3/8) 797.36g md=
2 clean in_sync 'zenon:2' {5c037ba3-ca4b-f7b9-eb8f-b01608e1fd3b}
 =E2=94=9C=E2=94=80scsi 2:0:5:0 ATA WDC WD1002FAEX-0 {WD-WCATR3004862}
 =E2=94=82  =E2=94=94=E2=94=80sdh: [8:112] Partitioned (dos) 931.51g
 =E2=94=82     =E2=94=9C=E2=94=80sdh1: [8:113] MD raid1 (4/8) 250.98m m=
d0 clean in_sync {2871f814-ceb7-6a88-d8b7-8f6599226e41}
 =E2=94=82     =E2=94=9C=E2=94=80sdh2: [8:114] MD raid6 (6/8) 133.81g m=
d1 clean in_sync 'grml:1' {1434a46a-f2b7-51cd-8604-803cb545de8c}
 =E2=94=82     =E2=94=94=E2=94=80sdh3: [8:115] MD raid6 (1/8) 797.36g m=
d2 clean in_sync 'zenon:2' {5c037ba3-ca4b-f7b9-eb8f-b01608e1fd3b}
 =E2=94=9C=E2=94=80scsi 2:0:6:0 ATA WDC WD1002FAEX-0 {WD-WCATR2969087}
 =E2=94=82  =E2=94=94=E2=94=80sdi: [8:128] Partitioned (dos) 931.51g
 =E2=94=82     =E2=94=9C=E2=94=80sdi1: [8:129] MD raid1 (1/8) 250.98m m=
d0 clean in_sync {2871f814-ceb7-6a88-d8b7-8f6599226e41}
 =E2=94=82     =E2=94=9C=E2=94=80sdi2: [8:130] MD raid6 (0/8) 133.81g m=
d1 clean in_sync 'grml:1' {1434a46a-f2b7-51cd-8604-803cb545de8c}
 =E2=94=82     =E2=94=94=E2=94=80sdi3: [8:131] MD raid6 (7/8) 797.36g m=
d2 clean in_sync 'zenon:2' {5c037ba3-ca4b-f7b9-eb8f-b01608e1fd3b}
 =E2=94=9C=E2=94=80scsi 2:0:7:0 ATA WDC WD1002FAEX-0 {WD-WCATR2984361}
 =E2=94=82  =E2=94=94=E2=94=80sdj: [8:144] Partitioned (dos) 931.51g
 =E2=94=82     =E2=94=9C=E2=94=80sdj1: [8:145] MD raid1 (5/8) 250.98m m=
d0 clean in_sync {2871f814-ceb7-6a88-d8b7-8f6599226e41}
 =E2=94=82     =E2=94=9C=E2=94=80sdj2: [8:146] MD raid6 (5/8) 133.81g m=
d1 clean in_sync 'grml:1' {1434a46a-f2b7-51cd-8604-803cb545de8c}
 =E2=94=82     =E2=94=94=E2=94=80sdj3: [8:147] MD raid6 (2/8) 797.36g m=
d2 clean in_sync 'zenon:2' {5c037ba3-ca4b-f7b9-eb8f-b01608e1fd3b}
 =E2=94=94=E2=94=80scsi 2:x:x:x [Empty]
USB [usb-storage] Bus 002 Device 004: ID 0624:0249 Avocent Corp.  {2008=
0519}
 =E2=94=94=E2=94=80scsi 3:0:0:0 iDRAC LCDRIVE
    =E2=94=94=E2=94=80sda: [8:0] Empty/Unknown 0.00k
USB [usb-storage] Bus 002 Device 004: ID 0624:0249 Avocent Corp.  {2008=
0519}
 =E2=94=9C=E2=94=80scsi 4:0:0:0 iDRAC Virtual CD
 =E2=94=82  =E2=94=94=E2=94=80sr1: [11:1] Empty/Unknown 1.00g
 =E2=94=94=E2=94=80scsi 4:0:0:1 iDRAC Virtual Floppy
    =E2=94=94=E2=94=80sdb: [8:16] Empty/Unknown 0.00k
Other Block Devices
 =E2=94=94=E2=94=80loop0: [7:0] (squashfs) 199.44m
    =E2=94=94=E2=94=80Mounted as /dev/loop0 @ /grml64-medium.squashfs

> Regards,

Thanks,
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
