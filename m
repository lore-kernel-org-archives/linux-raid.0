From: Simon McNair <simonmcnair@gmail.com>
Subject: Linux software RAID assistance
Date: Thu, 10 Feb 2011 16:16:44 +0000
Message-ID: <4D540F6C.6050904@gmail.com>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi all

I use a 3ware 9500-12 port sata card (JBOD) which will not work without=
 a
128mb sodimm.  The sodimm socket is flakey and the result is that the
machine occasionally crashes.  Yesterday I finally gave in and put=20
together another
machine so that I can rsync between them.  When I turned the machine
on today to set up rync, the RAID array was not gone, but corrupted.=20
  Typical...

I built the array in Aug 2010 using the following command:

mdadm --create --verbose /dev/md0 --metadata=3D1.1 --level=3D5
--raid-devices=3D10 /dev/sd{b,c,d,e,f,g,h,i,j,k}1 --chunk=3D64

Using LVM, I did the following:
pvscan
pvcreate -M2 /dev/md0
vgcreate lvm-raid /dev/md0
vgdisplay lvm-raid
vgscan
lvscan
lvcreate -v -l 100%VG -n RAID lvm-raid
lvdisplay /dev/lvm-raid/lvm0

I then formatted using:
mkfs -t ext4 -v -m .1 -b 4096 -E stride=3D16,stripe-width=3D144=20
/dev/lvm-raid/RAID

This worked perfectly since I created the array.  Now mdadm is coming u=
p=20
with

proxmox:/dev/md# mdadm --assemble --scan --verbose
mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on /dev/md/ubuntu:0
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: cannot open device /dev/dm-1: Device or resource busy
mdadm: cannot open device /dev/dm-0: Device or resource busy
mdadm: cannot open device /dev/sdm1: Device or resource busy
mdadm: cannot open device /dev/sdm: Device or resource busy
mdadm: cannot open device /dev/sdl1: Device or resource busy
mdadm: cannot open device /dev/sdl: Device or resource busy
mdadm: cannot open device /dev/sdk1: Device or resource busy
mdadm: cannot open device /dev/sdk: Device or resource busy
mdadm: cannot open device /dev/sdj1: Device or resource busy
mdadm: cannot open device /dev/sdj: Device or resource busy
mdadm: cannot open device /dev/sdh1: Device or resource busy
mdadm: cannot open device /dev/sdh: Device or resource busy
mdadm: cannot open device /dev/sdi1: Device or resource busy
mdadm: cannot open device /dev/sdi: Device or resource busy
mdadm: cannot open device /dev/sdg1: Device or resource busy
mdadm: cannot open device /dev/sdg: Device or resource busy
mdadm: cannot open device /dev/sdf1: Device or resource busy
mdadm: cannot open device /dev/sdf: Device or resource busy
mdadm: cannot open device /dev/sde1: Device or resource busy
mdadm: cannot open device /dev/sde: Device or resource busy
mdadm: no RAID superblock on /dev/sdd
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sdd1 is identified as a member of /dev/md/pro=EF=BF=BDlox:0=
, slot 0.
mdadm: no uptodate device for slot 1 of /dev/md/pro=EF=BF=BDlox:0
mdadm: no uptodate device for slot 2 of /dev/md/pro=EF=BF=BDlox:0
mdadm: no uptodate device for slot 3 of /dev/md/pro=EF=BF=BDlox:0
mdadm: no uptodate device for slot 4 of /dev/md/pro=EF=BF=BDlox:0
mdadm: no uptodate device for slot 5 of /dev/md/pro=EF=BF=BDlox:0
mdadm: no uptodate device for slot 6 of /dev/md/pro=EF=BF=BDlox:0
mdadm: no uptodate device for slot 7 of /dev/md/pro=EF=BF=BDlox:0
mdadm: no uptodate device for slot 8 of /dev/md/pro=EF=BF=BDlox:0
mdadm: no uptodate device for slot 9 of /dev/md/pro=EF=BF=BDlox:0
mdadm: failed to add /dev/sdd1 to /dev/md/pro=EF=BF=BDlox:0: Invalid ar=
gument
mdadm: /dev/md/pro=EF=BF=BDlox:0 assembled from 0 drives - not enough t=
o start
the array.
mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on /dev/sdd
mdadm: No arrays found in config file or automatically

pvscan and vgscan show nothing.

So I tried running mdadm --create --verbose /dev/md0 --metadata=3D1.1
--level=3D5 --raid-devices=3D10 missing /dev/sde1 /dev/sdf1 /dev/sdg1
/dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 --chunk=3D6=
4

as it seemed that /dev/sdd1 failed to be added to the array.  This did=20
nothing.

dmesg contains:

md: invalid superblock checksum on sdd1
md: sdd1 does not have a valid v1.1 superblock, not importing!
md: md_import_device returned -22

The output of mdadm -E is as follows:

proxmox:~# mdadm -E /dev/sd[d-m]1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : c4f62f32:4244a1db:b7746203:f10b5227
           Name : pro=C3=B8lox:0
  Creation Time : Sat Aug 21 19:16:38 2010
     Raid Level : raid5
   Raid Devices : 10

  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : b0ffd0a1:866676af:3ae4c03c:d219676e

    Update Time : Mon Feb  7 21:08:29 2011
       Checksum : 13aa9685 - expected 93aa9672
         Events : 60802

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 7d55c29e:273c35da:f6438197:0365f95f
           Name : ubuntu:0
  Creation Time : Thu Feb 10 11:59:48 2011
     Raid Level : raid5
   Raid Devices : 10

  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 4121fa31:7543218c:f42a937d:fddf04e8

    Update Time : Thu Feb 10 12:17:59 2011
       Checksum : 5f965c84 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : .AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 7d55c29e:273c35da:f6438197:0365f95f
           Name : ubuntu:0
  Creation Time : Thu Feb 10 11:59:48 2011
     Raid Level : raid5
   Raid Devices : 10

  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : e70da8ed:c80e9533:7d8e200e:dc285255

    Update Time : Thu Feb 10 12:17:59 2011
       Checksum : c092c0e5 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : .AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 7d55c29e:273c35da:f6438197:0365f95f
           Name : ubuntu:0
  Creation Time : Thu Feb 10 11:59:48 2011
     Raid Level : raid5
   Raid Devices : 10

  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 5878fdbb:d0c7c892:40c8fa6c:0c5e257b

    Update Time : Thu Feb 10 12:17:59 2011
       Checksum : 72c95353 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : .AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 7d55c29e:273c35da:f6438197:0365f95f
           Name : ubuntu:0
  Creation Time : Thu Feb 10 11:59:48 2011
     Raid Level : raid5
   Raid Devices : 10

  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 7bced3d0:5ebac414:02effc8b:ac1ad69e

    Update Time : Thu Feb 10 12:17:59 2011
       Checksum : 4c4e7f67 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 4
   Array State : .AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 7d55c29e:273c35da:f6438197:0365f95f
           Name : ubuntu:0
  Creation Time : Thu Feb 10 11:59:48 2011
     Raid Level : raid5
   Raid Devices : 10

  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 56513558:a25025bb:11e8b563:ae42f8d4

    Update Time : Thu Feb 10 12:17:59 2011
       Checksum : 87ebb998 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 5
   Array State : .AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 7d55c29e:273c35da:f6438197:0365f95f
           Name : ubuntu:0
  Creation Time : Thu Feb 10 11:59:48 2011
     Raid Level : raid5
   Raid Devices : 10

  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 90621937:23cff36c:c55b1581:ed28b433

    Update Time : Thu Feb 10 12:17:59 2011
       Checksum : 94b9a346 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 6
   Array State : .AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 7d55c29e:273c35da:f6438197:0365f95f
           Name : ubuntu:0
  Creation Time : Thu Feb 10 11:59:48 2011
     Raid Level : raid5
   Raid Devices : 10

  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 72d5ce06:855aa34c:3a354abc:0ddb6e80

    Update Time : Thu Feb 10 12:17:59 2011
       Checksum : cc0e2d20 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 7
   Array State : .AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 7d55c29e:273c35da:f6438197:0365f95f
           Name : ubuntu:0
  Creation Time : Thu Feb 10 11:59:48 2011
     Raid Level : raid5
   Raid Devices : 10

  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 8792e04a:ee298ace:fec79850:ddd3167b

    Update Time : Thu Feb 10 12:17:59 2011
       Checksum : 20fd4534 - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 8
   Array State : .AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdm1:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : 7d55c29e:273c35da:f6438197:0365f95f
           Name : ubuntu:0
  Creation Time : Thu Feb 10 11:59:48 2011
     Raid Level : raid5
   Raid Devices : 10

  Avail Dev Size : 1953099512 (931.31 GiB 999.99 GB)
     Array Size : 17577894528 (8381.79 GiB 8999.88 GB)
  Used Dev Size : 1953099392 (931.31 GiB 999.99 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 8916d09c:448a5791:c2923182:ab99eb92

    Update Time : Thu Feb 10 12:17:59 2011
       Checksum : 7f27ba1f - correct
         Events : 4

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 9
   Array State : .AAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

I'm confident the data is on there, I just need to get a backup of it o=
ff !

Yours desperately.

regards
Simon McNair


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
