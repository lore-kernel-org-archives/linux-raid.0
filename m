From: Hans Malissa <hmalissa@me.com>
Subject: RAID1 degraded
Date: Mon, 03 Aug 2015 16:18:02 -0600
Message-ID: <AA2DC53A-A663-45CE-A8FE-DF6C8C285F37@me.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everybody,

It looks like one of my disks in my RAID1 just failed:

 # cat /proc/mdstat
Personalities : [raid1]=20
md0 : active raid1 sdc1[1](F) sdb1[0]
      976629568 blocks super 1.2 [2/1] [U_]
     =20
unused devices: <none>

and

# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Sun May 17 15:21:30 2015
     Raid Level : raid1
     Array Size : 976629568 (931.39 GiB 1000.07 GB)
  Used Dev Size : 976629568 (931.39 GiB 1000.07 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Mon Aug  3 16:13:56 2015
          State : clean, degraded=20
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           Name : eprb21:0
           UUID : 0901fe50:444a29b6:d3caff14:e45ef9cc
         Events : 7619

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       0        0        1      removed

       1       8       33        -      faulty   /dev/sdc1

Looks like there=92s something wrong with /dev/sdc1:

# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 0901fe50:444a29b6:d3caff14:e45ef9cc
           Name : eprb21:0
  Creation Time : Sun May 17 15:21:30 2015
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 976629568 (931.39 GiB 1000.07 GB)
  Used Dev Size : 1953259136 (931.39 GiB 1000.07 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3e6d5330:3ee6ef06:2acf46ad:44513d37

    Update Time : Mon Aug  3 16:14:32 2015
       Checksum : d474a441 - correct
         Events : 7627


   Device Role : Active device 0
   Array State : A. ('A' =3D=3D active, '.' =3D=3D missing)

and

# mdadm --examine /dev/sdc1
mdadm: No md superblock detected on /dev/sdc1.

The file system seems to be ok for the time being:

# fsck -n /dev/md0
fsck from util-linux 2.21.2
e2fsck 1.42.6 (21-Sep-2012)
Warning!  /dev/md0 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem=
 check.
/dev/md0: clean, 218192/61046784 files, 213484777/244157392 blocks

Are there any other tests I could run in order to figure out what=92s g=
oing on? It looks like I will have to replace /dev/sdc1 with a new hard=
 drive. What is the correct procedure to do so without loosing my data?
Best regards, and thanks a lot,

Hans--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
