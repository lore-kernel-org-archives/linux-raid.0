From: =?UTF-8?B?U2VyZ2l1c3ogQnJ6ZXppxYRza2k=?=
	<Sergiusz.Brzezinski@supersystem.pl>
Subject: mdadm -add doesn't start rebuilding array
Date: Mon, 20 Aug 2012 11:36:10 +0200
Message-ID: <5032050A.4000801@supersystem.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

My system is Ubuntu 12.04, kernel 3.2.0-27. mdadm: 3.2.3

If I do:

# mdadm /dev/md0 -a /dev/sdc3

then nothing happen! No message on command line, no info in logs!

Man mdadm says:

-a, --add
hot-add listed devices.  If a device appears to have recently been part=
 of the=20
array (possibly it failed or was removed) the device is  re-added  as  =
describe=20
  in  the  next point.   If  that  fails  or the device was never part =
of the=20
array, the device is added as a hot-spare.  If the array is degraded, i=
t will=20
immediately start to rebuild data onto that spare.

But array doesn't wont to rebuild.

But not exactly. The bad info is, that sometimes it works and sometimes=
 it doesn't.

And if I restart the system, the array SOMETIMES start rebuilding and s=
omethimes=20
doesn't!

There is no information what's up (comnand line or logs) so I don't kno=
w what to do.



I describe bellow the whole procedure:

1.
There ist a working Raid1 array:

# cat /proc/mdstat

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [r=
aid4]=20
[raid10]
md0 : active raid1 sda3[2] sdb3[3]
       115999672 blocks super 1.0 [2/2] [UU]
       bitmap: 0/1 pages [0KB], 65536KB chunk

# mdadm --detail /dev/md0

/dev/md0:
         Version : 1.0
   Creation Time : Wed Aug  1 15:45:56 2012
      Raid Level : raid1
      Array Size : 115999672 (110.63 GiB 118.78 GB)
   Used Dev Size : 115999672 (110.63 GiB 118.78 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Mon Aug 20 11:10:00 2012
           State : active
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : linux:0
            UUID : b7407176:2e88c73d:2c85e940:05ff7e06
          Events : 5897

     Number   Major   Minor   RaidDevice State
        3       8       19        0      active sync   /dev/sdb3
        2       8        3        1      active sync   /dev/sda3


2.
I remove (phisicaly) the "/dev/sdb" drive of the box (hot-swap)

# cat /proc/mdstat

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [r=
aid4]=20
[raid10]
md0 : active raid1 sda3[2] sdb3[3](F)
       115999672 blocks super 1.0 [2/1] [_U]
       bitmap: 1/1 pages [4KB], 65536KB chunk

# mdadm --detail /dev/md0
/dev/md0:
         Version : 1.0
   Creation Time : Wed Aug  1 15:45:56 2012
      Raid Level : raid1
      Array Size : 115999672 (110.63 GiB 118.78 GB)
   Used Dev Size : 115999672 (110.63 GiB 118.78 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Mon Aug 20 11:11:58 2012
           State : active, degraded
  Active Devices : 1
Working Devices : 1
  Failed Devices : 1
   Spare Devices : 0

            Name : linux:0
            UUID : b7407176:2e88c73d:2c85e940:05ff7e06
          Events : 5908

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        2       8        3        1      active sync   /dev/sda3

        3       8       19        -      faulty spare


3.
I insert the drive again - it become "/dev/sdc" instead of "/dev/sdb"

4.
And now I do the following to rebuild the array:

# mdadm /dev/md0 -a /dev/sdc3

mdadm: /dev/sdc3 reports being an active member for /dev/md0, but a --r=
e-add fails.
mdadm: not performing --add as that would convert /dev/sdc3 in to a spa=
re.
mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdc3" fi=
rst.

I have never seen this messages before (on another systems). But this i=
s not a=20
problem. I do, what they suggest:

# mdadm --zero-superblock /dev/sdc3

# mdadm --examine /dev/sdc3
mdadm: No md superblock detected on /dev/sdc3.

5.
And now I try again rebuild the array:

# mdadm /dev/md0 -a /dev/sdc3

=2E.. and nothing happen! No message, no info. I repeat some times the =
command.

I also try this:

# mdadm /dev/md0 -a -vv --force /dev/sdc3

=2E.. also nothing. Somethimes, if I repeat the command one by one, in =
logs appear=20
the line:

Aug 20 11:30:52 serwer-linmot kernel: [ 1978.111282] md: export_rdev(sd=
c3)

=2E.. and nothing else


# mdadm --examine /dev/sdc3
/dev/sdc3:
           Magic : a92b4efc
         Version : 1.0
     Feature Map : 0x1
      Array UUID : b7407176:2e88c73d:2c85e940:05ff7e06
            Name : linux:0
   Creation Time : Wed Aug  1 15:45:56 2012
      Raid Level : raid1
    Raid Devices : 2

  Avail Dev Size : 231999344 (110.63 GiB 118.78 GB)
      Array Size : 231999344 (110.63 GiB 118.78 GB)
    Super Offset : 231999472 sectors
           State : clean
     Device UUID : f1a1f291:e10d85cc:b574c6d2:45fc0c5d

Internal Bitmap : -8 sectors from superblock
     Update Time : Mon Aug 20 11:17:07 2012
        Checksum : 71bcac04 - correct
          Events : 0


    Device Role : spare
    Array State : .A ('A' =3D=3D active, '.' =3D=3D missing)


# mdadm --detail /dev/md0

/dev/md0:
         Version : 1.0
   Creation Time : Wed Aug  1 15:45:56 2012
      Raid Level : raid1
      Array Size : 115999672 (110.63 GiB 118.78 GB)
   Used Dev Size : 115999672 (110.63 GiB 118.78 GB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Mon Aug 20 11:18:43 2012
           State : active, degraded
  Active Devices : 1
Working Devices : 1
  Failed Devices : 1
   Spare Devices : 0

            Name : linux:0
            UUID : b7407176:2e88c73d:2c85e940:05ff7e06
          Events : 5946

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        2       8        3        1      active sync   /dev/sda3

        3       8       19        -      faulty spare


Can anyone help?

many thanks in advance

Sergiusz Brzezi=C5=84ski














--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
