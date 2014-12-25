From: "Stephan Hafiz" <forum@hafis.de>
Subject: md_raid5 recovering failed need help
Date: Thu, 25 Dec 2014 15:24:42 +0100
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAOgLllvGWotKlJcBYHqu4VUCgQAAEAAAAJjrgwWxkKFFjrGxfwSsmpoBAAAAAA==@hafis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: de
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: forum@hafis.de
List-Id: linux-raid.ids

Hi! I=E2=80=99m from germany and my raid and me needs help.
My english isn=E2=80=99t very good, but i think it=E2=80=99s sufficient=
=2E And i think, this mailinglist is my last hope =E2=98=BA

So on, =E2=80=A6. Here ist my problem.
The raid5 has lost 2 of 5 disks. First one disk and then the second one=
=2E
I have been trying for several weeks to solve the problem alone =E2=80=A6=
 unsucessful =E2=98=B9

And here some informations about this disaster.



!SMART Status
for i in a b c d e f; do echo Device  sd$i; smartctl -H /dev/sd$i | egr=
ep overall; echo; done;
Device sda
SMART overall-health self-assessment test result: PASSED

Device sdb
SMART overall-health self-assessment test result: PASSED

Device sdc
SMART overall-health self-assessment test result: PASSED

Device sdd
SMART overall-health self-assessment test result: PASSED

Device sde
SMART overall-health self-assessment test result: PASSED

Device sdf
SMART overall-health self-assessment test result: PASSED



!mdadm version
mdadm - v3.2.5 - 18th May 2012
I have read about recent versions 3.3.x @ raid.wiki.kernel.org, i haven=
=E2=80=99t tested this version.



!superblock informations
Only the Events from sdb1 are off

/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : 19fc2188:8d10ae41:fee05ce5:06321b30
           Name : pluto:0  (local to host pluto)
  Creation Time : Tue Sep 24 22:45:51 2013
     Raid Level : raid5
   Raid Devices : 5

Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
     Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
Recovery Offset : 99655656 sectors
          State : clean
    Device UUID : 4aab22d5:21663d86:98f49007:0b776d30

    Update Time : Thu Dec 18 20:12:19 2014
       Checksum : f7a68c46 - correct
         Events : 195

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 19fc2188:8d10ae41:fee05ce5:06321b30
           Name : pluto:0  (local to host pluto)
  Creation Time : Tue Sep 24 22:45:51 2013
     Raid Level : raid5
   Raid Devices : 5

Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
     Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 61b9afe4:ba695181:7d1a1431:3e52621b

    Update Time : Sat Dec 20 20:49:35 2014
       Checksum : 10d2aaf0 - correct
         Events : 217

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : .AAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 19fc2188:8d10ae41:fee05ce5:06321b30
           Name : pluto:0  (local to host pluto)
  Creation Time : Tue Sep 24 22:45:51 2013
     Raid Level : raid5
   Raid Devices : 5

Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
     Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : bf5ed2c0:95e837fa:e8b8eabf:b5cc8dba

    Update Time : Sun Dec 21 12:22:33 2014
       Checksum : 93dbc2b8 - correct
         Events : 217

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : ..AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 19fc2188:8d10ae41:fee05ce5:06321b30
           Name : pluto:0  (local to host pluto)
  Creation Time : Tue Sep 24 22:45:51 2013
     Raid Level : raid5
   Raid Devices : 5

Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
     Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 52f8c258:96d54789:0cbdad3d:b17e85ae

    Update Time : Sun Dec 21 12:22:33 2014
       Checksum : 2c96ff6c - correct
         Events : 217

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : ..AAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 19fc2188:8d10ae41:fee05ce5:06321b30
           Name : pluto:0  (local to host pluto)
  Creation Time : Tue Sep 24 22:45:51 2013
     Raid Level : raid5
   Raid Devices : 5

Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
     Array Size : 11720536064 (11177.57 GiB 12001.83 GB)
  Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 418df97d:1658bced:ca887a61:2d7f3c05

    Update Time : Sun Dec 21 12:22:33 2014
       Checksum : 30c5e317 - correct
         Events : 217

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : ..AAA ('A' =3D=3D active, '.' =3D=3D missing)



!Process Status md
cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4] [raid10]
md0 : inactive sdf1[5](S) sdc1[1](S) sdd1[2](S) sde1[3](S) sdb1[6](S)
      14650672357 blocks super 1.2

unused devices: <none>



!reassemble force
mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/=
sdf1 --force
mdadm: ignoring /dev/sdd1 as it reports /dev/sdc1 as failed
mdadm: ignoring /dev/sde1 as it reports /dev/sdc1 as failed
mdadm: ignoring /dev/sdf1 as it reports /dev/sdc1 as failed
mdadm: /dev/md0 assembled from 1 drive - not enough to start the array.




i hope i don=E2=80=99t get the award =E2=80=9Epaint onself in to the co=
rner=E2=80=9C =E2=80=A6=E2=80=A6

merry christmas =E2=80=A6 David

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
