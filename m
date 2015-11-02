From: Nicolas Tellier <telliern@gmail.com>
Subject: Failed Raid 5 due to OS mbr written on one of the array drives
Date: Mon, 2 Nov 2015 18:02:50 +0100
Message-ID: <CAArDwD-7=Vmo16K3GH0dxZie=RAiSavZNfMNvabf4X6G4fK34w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm looking for advices regarding a failed (2 disc down) Raid 5 array
with 4 disks. It was running in a NAS for quite some time but after I
came back from a trip, I found out that the system disk was dead.
After replacing the drive, I reinstalled the OS (OpenMediaVault for
the curious). Sadly the mbr was written to one of the raid disk
instead of the OS one. This would not have been too critical if, after
booting the system, I didn't realized that the array was already
running in degraded mode prior to the OS disk problem. Luckily I have
a backup for most of the critical data on that array. There is nothing
that I cannot replace, but it would still be quite inconvenient. I
guess it's a good opportunity to learn more about raid :)

 mdadm --stop /dev/md0 and removing the boot flag from the wrongly
written raid disk are the only stuff that I did so far.

Here are the informations I gathered :


root@NAStradamus:~# uname -a
Linux NAStradamus 3.2.0-4-amd64 #1 SMP Debian 3.2.68-1+deb7u5 x86_64 GN=
U/Linux


root@NAStradamus:~# mdadm --examine /dev/sd[a-z]1

mdadm: No md superblock detected on /dev/sda1.

/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : a08bcee5:9fb42352:319ecab9:53d6277b
           Name : ArchliNAS:0
  Creation Time : Sun Jul  8 17:59:49 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953005569 (931.27 GiB 999.94 GB)
     Array Size : 2929507584 (2793.80 GiB 2999.82 GB)
  Used Dev Size : 1953005056 (931.27 GiB 999.94 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9b28a04c:f2c3d6c9:6f76859d:624927f0

    Update Time : Wed Sep 16 19:32:12 2015
       Checksum : 4fb98985 - correct
         Events : 108016

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing)

/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : a08bcee5:9fb42352:319ecab9:53d6277b
           Name : ArchliNAS:0
  Creation Time : Sun Jul  8 17:59:49 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953005569 (931.27 GiB 999.94 GB)
     Array Size : 2929507584 (2793.80 GiB 2999.82 GB)
  Used Dev Size : 1953005056 (931.27 GiB 999.94 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1952e898:50043e66:8247a64d:72ffb6c0

    Update Time : Wed Sep 16 19:32:12 2015
       Checksum : b9197a85 - correct
         Events : 108016

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAA. ('A' =3D=3D active, '.' =3D=3D missing)


root@NAStradamus:~# mdadm --examine /dev/sdd
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : a08bcee5:9fb42352:319ecab9:53d6277b
           Name : ArchliNAS:0
  Creation Time : Sun Jul  8 17:59:49 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 1953523120 (931.51 GiB 1000.20 GB)
     Array Size : 2929507584 (2793.80 GiB 2999.82 GB)
  Used Dev Size : 1953005056 (931.27 GiB 999.94 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 425c85ec:0c038b4b:cd59b4b5:280bf233

    Update Time : Mon May  4 08:18:04 2015
       Checksum : cca22997 - correct
         Events : 55532

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAA ('A' =3D=3D active, '.' =3D=3D missing)


root@NAStradamus:~# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : inactive sdb1[1] sdc1[3]
      1953005569 blocks super 1.2

unused devices: <none>


root@NAStradamus:~# mdadm --examine --scan
ARRAY /dev/md/0 metadata=3D1.2 UUID=3Da08bcee5:9fb42352:319ecab9:53d627=
7b
name=3DArchliNAS:0


root@NAStradamus:~# fdisk -l

Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
107 heads, 58 sectors/track, 314780 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00048269

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048  1953269760   976633856+  da  Non-FS data

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1            2048  1953269760   976633856+  da  Non-FS data

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1            2048  1953269760   976633856+  da  Non-FS data

Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders, total 1953525168 sectors
Units =3D sectors of 1 * 512 =3D 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/sdd doesn't contain a valid partition table





=46irst off we can see that /dev/sdd is in a weird state. You need to
know that it was added later in order to grow the array. It seems that
I was drunk when I did that as I didn't put any partition on that
disk=E2=80=A6
Besides the event count is way off. My understanding is that there is
nothing to be done here, apart from re-adding it to the array once it
is up and running again (hopefully) and once the disk has been checked
for error and reinitialized (with a proper partition this time !).

Now, /dev/sda is more interesting. The partition is still present and
looks intact, it seems like it's just missing the superblock because
of the mbr shenanigan. Also the two healthy drives still see it as
active.

After looking around on the internet, I found people suggesting to
re-create the raid. It seems a bit extreme to me, but I cannot find
any other solution=E2=80=A6
Luckily I saved the original command used to create this array. Here
is the one I think would be relevant in this case :

mdadm --create --verbose --assume-clean /dev/md0 --level=3D5
--metadata=3D1.2 --chunk=3D128 --raid-devices=3D4 /dev/sda1 /dev/sdb1
/dev/sdc1 missing /dev/sdd

This would be followed by a backup, the re-addition of /dev/sdd and a
migration to raid 6 with 2 more disks.
The wiki advise to get an experienced person review the measures
you're about to take, I don't know anybody experienced in RAID, hence
this e-mail :) What do you think ?

Please, CC me on the answers/comments posted to the list in response
to this; I'm not subscribed to the mailing list.

Thanks in advance for your time !

Nico
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
