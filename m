From: Teitur Ingi Sigurdsson <teitso@gmail.com>
Subject: mdadm No md superblock detected
Date: Thu, 21 Nov 2013 23:14:46 +0000
Message-ID: <AF9C012C-CC64-4F6D-8248-49FD37D4853C@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there and thanks for your service

I=92m having a problem with my 4x 2tb raid 5 mdadm array.

After an unexpected shutdown my machine booted into dos busybox, when i=
 typed exit I got the ubuntu(12.04) logo and a message telling me it co=
uld not mount my raid drive so I pressed S to skip it.

The first thing I did was to do a complete long test with seagate sea t=
ools to check all my hard drives for errors and all the drives are ok.

I found out that 2 of my drives where not assembling into the array.

When I tried to assemble the array it told me on these two drives there=
 were no md superblocks detected.

I started googling around and trying to find a solution to the problem =
, found lots of forums and people with similar problems,

When I tried : sudo mdadm =97assemble =97scan in the first place it res=
ponded that i had duplicate UUID in my mdadm config file. So I looked a=
t the config file and found these 2 UUID :
ARRAY /dev/md0 level=3Draid5 num-devices=3D3 UUID=3Df7783df2:bc896dcc:9=
c729cd1:10366cce
ARRAY /dev/md0 level=3Draid5 num-devices=3D3 UUID=3D48877e00:48c5e221:9=
c729cd1:10366cce

the weird thing here is that the number of devices here are 3 not 4 lik=
e I have always been using, at least I=92ve been using 4 2 tb drives to=
 get about 6 tb of space in an array in raid 5, not that it really matt=
ers anyways, tried changing it but nothing happens when i execute the c=
ommand : sudo mdadm =97assemble =97scan , don=92t know why that is, may=
be there is another config file I don=92t know about

anyways=92 i got this command from somebody with a similar problem : su=
do mdadm =96examine =96scan =96config=3Dmdadm.conf >> /etc/mdadm/mdadm.=
conf
and got some UUID copy-ed into my config file and tried the scan again =
but it did not work.

I=92ve tried so far : root@tserver:~# mdadm --create /dev/md0 --verbose=
 --level=3D5 --raid-devices=3D4 /dev/sdd missing /dev/sdc missing=20
and got this response: mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 512K
mdadm: /dev/sdd appears to contain an ext2fs file system
    size=3D1565576192K  mtime=3DSat Nov  9 20:54:11 2013
mdadm: /dev/sdd appears to be part of a raid array:
    level=3Draid5 devices=3D4 ctime=3DTue Jan 11 00:26:47 2011
mdadm: /dev/sdc appears to be part of a raid array:
    level=3Draid5 devices=3D4 ctime=3DTue Jan 11 00:26:47 2011
mdadm: size set to 1953382912K
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: RUN_ARRAY failed: Input/output error

i was afraid that the create command could erase my data but some peopl=
e in the same position suggested it was okay.

I=92ve tried the UUID assemble command and nothing happens : mdadm --as=
semble /dev/md# --uuid=3D<UUID>

here is my mdadm =97examine :=20
root@tserver:~# mdadm --examine /dev/sda
mdadm: No md superblock detected on /dev/sda.
root@tserver:~# mdadm --examine /dev/sda1
mdadm: cannot open /dev/sda1: No such file or directory
root@tserver:~# mdadm --examine /dev/sda
mdadm: No md superblock detected on /dev/sda.
root@tserver:~# mdadm --examine /dev/sdc
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3e74cf9b:b49ecf15:98722946:b19b30b6
           Name : tserver:0  (local to host tserver)
  Creation Time : Mon Nov 18 23:05:33 2013
     Raid Level : raid5
   Raid Devices : 4
=20
 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 5860148736 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3c5cb8d9:072a09df:72a9bf89:fa579762
=20
    Update Time : Mon Nov 18 23:05:33 2013
       Checksum : 1fe51ccc - correct
         Events : 0
=20
         Layout : left-symmetric
     Chunk Size : 512K
=20
   Device Role : Active device 2
   Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing)
root@tserver:~# mdadm --examine /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3e74cf9b:b49ecf15:98722946:b19b30b6
           Name : tserver:0  (local to host tserver)
  Creation Time : Mon Nov 18 23:05:33 2013
     Raid Level : raid5
   Raid Devices : 4
=20
 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 5860148736 (5588.67 GiB 6000.79 GB)
  Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9a96576f:4fba1e25:7077591b:c9987f29
=20
    Update Time : Mon Nov 18 23:05:33 2013
       Checksum : 541bf63b - correct
         Events : 0
=20
         Layout : left-symmetric
     Chunk Size : 512K
=20
   Device Role : Active device 0
   Array State : A.A. ('A' =3D=3D active, '.' =3D=3D missing)
root@tserver:~# mdadm --examine /dev/sde
mdadm: No md superblock detected on /dev/sde.


and sudo fdisk -l :=20
sudo fdisk -l

=20
Disk /dev/sda: 2000.4 GB, 2000397852160 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907027055 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000
=20
Disk /dev/sda doesn't contain a valid partition table
=20
Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000
=20
Disk /dev/sdc doesn't contain a valid partition table
=20
Disk /dev/sde: 2000.4 GB, 2000397852160 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907027055 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000
=20
Disk /dev/sde doesn't contain a valid partition table
=20
Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000
=20
Disk /dev/sdd doesn't contain a valid partition table
=20
Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders, total 976773168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00026ec6
=20
   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *        2048   937164799   468581376   83  Linux
/dev/sdb2       937166846   976771071    19802113    5  Extended
/dev/sdb5       937166848   976771071    19802112   82  Linux swap / So=
laris


can you suggest anything?

My goal is to be able to re arrange my array without any data loss :)

Thanks for reading=20

Best Regards=20
Teitur--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
