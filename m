From: Peter van Es <vanes.peter@gmail.com>
Subject: Re: Help needed recovering from raid failure
Date: Wed, 29 Apr 2015 20:17:09 +0200
Message-ID: <C17D8E8D-492C-4BDD-904C-75CCA70B2CD9@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

first of all, I really appreciate you trying to help me. This is the fi=
rst time I=E2=80=99m deploying software raid, so really appreciate the =
guidance.


> On 29 Apr 2015, at 00:26, NeilBrown <neilb@suse.de> wrote:
>=20
> This isn't really reporting anything new.
> There is probably a daily cron job which reports all degraded arrays.=
  This
> message is reported by that job.

I understand...

>=20
>=20
> Why do you think the array is off-line?  The above message doesn't su=
ggest
> that.
>=20

My Ubuntu server was accessible through ssh but did not serve webpages,=
 files etc. When I went to the console,=20
it told me it had taken the array offline because of degraded /dev/sdd2=
 and /dev/sdc2
Those two drives were out of the array.=20

>=20
>>=20
>> Needless to say, I can't boot the system anymore as the boot drive i=
s /dev/md0, and GRUB can't
>> get at it. I do need to recover data (I know, but there's stuf on th=
ere I have no backup for--yet).
>=20
> You boot off a RAID5?  Does grub support that?  I didn't know.
> But md0 hasn't failed, has it?
>=20
> Confused.

Well, it took a little time but yes, I managed to define a raid 5 array=
 that the system was able to boot from.=20

> There is something VERY sick here.  I suggest that you tread very car=
efully.
>=20
> All your '1' partitions should be about 2GB and the '2' parititions a=
bout 2TB
>=20
> But the --examine output suggests sda2 and sdb2 are 2TB, while sdd2 a=
nd sde2
> are 2GB.
>=20
> That really really shouldn't happen.  Maybe check your partition tabl=
e
> (fdisk).
> I really cannot see how this would happen.

But this question, and the previous question you asked, tell me a littl=
e of what I may have done=E2=80=A6

I think confused /dev/md0 and /dev/md1 (now called /dev/md126 and /dev/=
md127 when running of the USB stick).=20

/dev/md0 is a swap array (around 6GB, comprised of 4 x 2 GB in raid 5)
/dev/md1 is the boot and data array (around 5 TB, comprised of 4 x ~2 T=
B in raid 5)=20

I must have confused them and tried to add the /dev/sdc2 and /dev/sdd2 =
drive to the /dev/md0 array (mdadm =E2=80=94add /dev/md0 /dev/sdc2)
instead of to the /dev/md1 array.  They were  then added as spare drive=
s, their superblocks were overwritten, but since
a) no swap space was used, and=20
b) they were added as spares

The data should not have been overwritten.

>=20
> Can you
>  mdadm -Ss
>=20
> to stop all the arrays, then
>=20
>  fdisk -l /dev/sd?
>=20
> then=20
>=20
>  mdadm -Esvv
>=20

Neil, here they are: again, I appreciate you taking the time and guidin=
g me through this!

Is there any way to resurrect the super blocks and try to force assembl=
e the array, skipping the failing drive /dev/sdd2 (the /dev/sdd2 drive =
created some errors I observed in the log, /dev/sdc2 must have had a on=
e off issue to be taken out=E2=80=A6.). I have two new drives (arrived =
today), and a new SSD drive. I would want to get the new array assemble=
d using /dev/sdc2 perhaps forcing it back to the array geometry and =E2=
=80=9Choping for the best=E2=80=9D and then install a new /dev/sdd2 to =
be recovered. Then I=E2=80=99ll create a boot and swap drive off the SS=
D which means that any array failures should not prevent the system fro=
m booting=E2=80=A6

Requested outputs are below

Thanks,=20

Peter


fdisk output: (USB devices deleted)


Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000f24ee

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048     3905535     1951744   fd  Linux raid auto=
detect
/dev/sda2   *     3905536  3907028991  1951561728   fd  Linux raid auto=
detect

Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00029d5c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048     3905535     1951744   fd  Linux raid auto=
detect
/dev/sdb2   *     3905536  3907028991  1951561728   fd  Linux raid auto=
detect


Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000727bf

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1            2048     3905535     1951744   fd  Linux raid auto=
detect
/dev/sdd2   *     3905536  3907028991  1951561728   fd  Linux raid auto=
detect

Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0009fe7f

   Device Boot      Start         End      Blocks   Id  System
/dev/sde1            2048     3905535     1951744   fd  Linux raid auto=
detect
/dev/sde2   *     3905536  3907028991  1951561728   fd  Linux raid auto=
detect


mdadm -Esvv output (USB devices deleted)

/dev/sde2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dbe238a3:c7a528c1:a1b78589:276ecfcf
           Name : ubuntu:0  (local to host ubuntu)
  Creation Time : Wed Apr  1 22:27:42 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3903121408 (1861.15 GiB 1998.40 GB)
     Array Size : 5850624 (5.58 GiB 5.99 GB)
  Used Dev Size : 3900416 (1904.82 MiB 1997.01 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : cdae3287:91168194:942ba99d:1a85c466

    Update Time : Wed Apr 29 17:46:25 2015
       Checksum : b8b84dad - correct
         Events : 30

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dbe238a3:c7a528c1:a1b78589:276ecfcf
           Name : ubuntu:0  (local to host ubuntu)
  Creation Time : Wed Apr  1 22:27:42 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
     Array Size : 5850624 (5.58 GiB 5.99 GB)
  Used Dev Size : 3900416 (1904.82 MiB 1997.01 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b051f523:4887e729:cd63bed1:8c2a7575

    Update Time : Wed Apr 29 17:46:25 2015
       Checksum : 453ddeef - correct
         Events : 30

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde:
   MBR Magic : aa55
Partition[0] :      3903488 sectors at         2048 (type fd)
Partition[1] :   3903123456 sectors at      3905536 (type fd)
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dbe238a3:c7a528c1:a1b78589:276ecfcf
           Name : ubuntu:0  (local to host ubuntu)
  Creation Time : Wed Apr  1 22:27:42 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3903121408 (1861.15 GiB 1998.40 GB)
     Array Size : 5850624 (5.58 GiB 5.99 GB)
  Used Dev Size : 3900416 (1904.82 MiB 1997.01 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0f3f2b91:09cbb344:e52c4c4b:722d65c4

    Update Time : Wed Apr 29 17:46:25 2015
       Checksum : 7e273c0f - correct
         Events : 30

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dbe238a3:c7a528c1:a1b78589:276ecfcf
           Name : ubuntu:0  (local to host ubuntu)
  Creation Time : Wed Apr  1 22:27:42 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
     Array Size : 5850624 (5.58 GiB 5.99 GB)
  Used Dev Size : 3900416 (1904.82 MiB 1997.01 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b6668730:3b1380bf:556700d9:30df829c

    Update Time : Wed Apr 29 17:46:25 2015
       Checksum : 15b83814 - correct
         Events : 30

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :      3903488 sectors at         2048 (type fd)
Partition[1] :   3903123456 sectors at      3905536 (type fd)
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1f28f7bb:7b3ecd41:ca0fa5d1:ccd008df
           Name : ubuntu:1  (local to host ubuntu)
  Creation Time : Wed Apr  1 22:27:58 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3902861312 (1861.03 GiB 1998.26 GB)
     Array Size : 5854290432 (5583.09 GiB 5994.79 GB)
  Used Dev Size : 3902860288 (1861.03 GiB 1998.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f1e79609:79b7ac23:55197f70:e8fbfd58

    Update Time : Sun Apr 26 05:59:13 2015
       Checksum : 696f4e76 - correct
         Events : 18014

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dbe238a3:c7a528c1:a1b78589:276ecfcf
           Name : ubuntu:0  (local to host ubuntu)
  Creation Time : Wed Apr  1 22:27:42 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
     Array Size : 5850624 (5.58 GiB 5.99 GB)
  Used Dev Size : 3900416 (1904.82 MiB 1997.01 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f52239b1:0fb87e7e:71e29ea4:bf67184a

    Update Time : Wed Apr 29 17:46:25 2015
       Checksum : ce9c9cd0 - correct
         Events : 30

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdb:
   MBR Magic : aa55
Partition[0] :      3903488 sectors at         2048 (type fd)
Partition[1] :   3903123456 sectors at      3905536 (type fd)
/dev/sda2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 1f28f7bb:7b3ecd41:ca0fa5d1:ccd008df
           Name : ubuntu:1  (local to host ubuntu)
  Creation Time : Wed Apr  1 22:27:58 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3902861312 (1861.03 GiB 1998.26 GB)
     Array Size : 5854290432 (5583.09 GiB 5994.79 GB)
  Used Dev Size : 3902860288 (1861.03 GiB 1998.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 713e556d:ca104217:785db68a:d820a57b

    Update Time : Sun Apr 26 05:59:13 2015
       Checksum : fda151f9 - correct
         Events : 18014

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.. ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : dbe238a3:c7a528c1:a1b78589:276ecfcf
           Name : ubuntu:0  (local to host ubuntu)
  Creation Time : Wed Apr  1 22:27:42 2015
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3901440 (1905.32 MiB 1997.54 MB)
     Array Size : 5850624 (5.58 GiB 5.99 GB)
  Used Dev Size : 3900416 (1904.82 MiB 1997.01 MB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : c483532d:06f93351:cfdf5a92:e83855b5

    Update Time : Wed Apr 29 17:46:25 2015
       Checksum : 76650d1c - correct
         Events : 30

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sda:
   MBR Magic : aa55
Partition[0] :      3903488 sectors at         2048 (type fd)
Partition[1] :   3903123456 sectors at      3905536 (type fd)--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
