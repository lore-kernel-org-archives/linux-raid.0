From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: Impact of missing parameter during mdadm create
Date: Tue, 1 Mar 2011 13:38:22 -0500
Message-ID: <BAY148-w11FE2CD7493A098E62E08DEFC10@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linuxraid@kendrummond.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Tue, 1 Mar 2011 17:13:09 +1000  wrote:
>
>>
>> Manual re-assembly outputs as follows:
>>
>>
>> mdadm -Ss
>>
>> mdadm: stopped /dev/md0
>>
>> ---
>>
>> mdadm -Asvvv
>>
>> mdadm: looking for devices for /dev/md/0
>> mdadm: no RAID superblock on /dev/dm-6
>> mdadm: /dev/dm-6 has wrong uuid.
>> mdadm: no RAID superblock on /dev/dm-5
>> mdadm: /dev/dm-5 has wrong uuid.
>> mdadm: no RAID superblock on /dev/dm-4
>> mdadm: /dev/dm-4 has wrong uuid.
>> mdadm: no RAID superblock on /dev/dm-3
>> mdadm: /dev/dm-3 has wrong uuid.
>> mdadm: cannot open device /dev/dm-2: Device or resource busy
>> mdadm: /dev/dm-2 has wrong uuid.
>> mdadm: no RAID superblock on /dev/dm-1
>> mdadm: /dev/dm-1 has wrong uuid.
>> mdadm: no RAID superblock on /dev/dm-0
>> mdadm: /dev/dm-0 has wrong uuid.
>> mdadm: no RAID superblock on /dev/sde
>> mdadm: /dev/sde has wrong uuid.
>> mdadm: no RAID superblock on /dev/sdd
>> mdadm: /dev/sdd has wrong uuid.
>> mdadm: cannot open device /dev/sdc7: Device or resource busy
>> mdadm: /dev/sdc7 has wrong uuid.
>> mdadm: cannot open device /dev/sdc6: Device or resource busy
>> mdadm: /dev/sdc6 has wrong uuid.
>> mdadm: cannot open device /dev/sdc5: Device or resource busy
>> mdadm: /dev/sdc5 has wrong uuid.
>> mdadm: no RAID superblock on /dev/sdc2
>> mdadm: /dev/sdc2 has wrong uuid.
>> mdadm: cannot open device /dev/sdc1: Device or resource busy
>> mdadm: /dev/sdc1 has wrong uuid.
>> mdadm: cannot open device /dev/sdc: Device or resource busy
>> mdadm: /dev/sdc has wrong uuid.
>> mdadm: no RAID superblock on /dev/sda
>> mdadm: /dev/sda has wrong uuid.
>> mdadm: no RAID superblock on /dev/sdb
>> mdadm: /dev/sdb has wrong uuid.
>> mdadm: /dev/sdd1 is identified as a member of /dev/md/0, slot 2.
>> mdadm: /dev/sda1 is identified as a member of /dev/md/0, slot 0.
>> mdadm: /dev/sdb1 is identified as a member of /dev/md/0, slot 1.
>> mdadm: added /dev/sdb1 to /dev/md/0 as 1
>> mdadm: added /dev/sdd1 to /dev/md/0 as 2
>> mdadm: looking for devices for /dev/md/0
>> mdadm: no RAID superblock on /dev/dm-6
>> mdadm: /dev/dm-6 has wrong uuid.
>> mdadm: no RAID superblock on /dev/dm-5
>> mdadm: /dev/dm-5 has wrong uuid.
>> mdadm: no RAID superblock on /dev/dm-4
>> mdadm: /dev/dm-4 has wrong uuid.
>> mdadm: no RAID superblock on /dev/dm-3
>> mdadm: /dev/dm-3 has wrong uuid.
>> mdadm: cannot open device /dev/dm-2: Device or resource busy
>> mdadm: /dev/dm-2 has wrong uuid.
>> mdadm: no RAID superblock on /dev/dm-1
>> mdadm: /dev/dm-1 has wrong uuid.
>> mdadm: no RAID superblock on /dev/dm-0
>> mdadm: /dev/dm-0 has wrong uuid.
>> mdadm: no RAID superblock on /dev/sde
>> mdadm: /dev/sde has wrong uuid.
>> mdadm: no RAID superblock on /dev/sdd
>> mdadm: /dev/sdd has wrong uuid.
>> mdadm: cannot open device /dev/sdc7: Device or resource busy
>> mdadm: /dev/sdc7 has wrong uuid.
>> mdadm: cannot open device /dev/sdc6: Device or resource busy
>> mdadm: /dev/sdc6 has wrong uuid.
>> mdadm: cannot open device /dev/sdc5: Device or resource busy
>> mdadm: /dev/sdc5 has wrong uuid.
>> mdadm: no RAID superblock on /dev/sdc2
>> mdadm: /dev/sdc2 has wrong uuid.
>> mdadm: cannot open device /dev/sdc1: Device or resource busy
>> mdadm: /dev/sdc1 has wrong uuid.
>> mdadm: cannot open device /dev/sdc: Device or resource busy
>> mdadm: /dev/sdc has wrong uuid.
>> mdadm: no RAID superblock on /dev/sda
>> mdadm: /dev/sda has wrong uuid.
>> mdadm: no RAID superblock on /dev/sdb
>> mdadm: /dev/sdb has wrong uuid.
>> mdadm: /dev/sdd1 is identified as a member of /dev/md/0, slot 2.
>> mdadm: /dev/sda1 is identified as a member of /dev/md/0, slot 0.
>> mdadm: /dev/sdb1 is identified as a member of /dev/md/0, slot 1.
>> mdadm: added /dev/sdb1 to /dev/md/0 as 1
>> mdadm: added /dev/sdd1 to /dev/md/0 as 2
>> mdadm: added /dev/sda1 to /dev/md/0 as 0
>> mdadm: /dev/md/0 has been started with 2 drives (out of 3).
>>
>> ---
>>
>> mdadm --examine /dev/sd{a,b,d}1
>>
>> /dev/sda1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
>>            Name : XEN-HOST:0  (local to host XEN-HOST)
>>   Creation Time : Mon Dec 20 09:48:07 2010
>>      Raid Level : raid5
>>    Raid Devices : 3
>>
>>  Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
>>      Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
>>   Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
>>     Data Offset : 2048 sectors
>>    Super Offset : 8 sectors
>>           State : clean
>>     Device UUID : 25f4baf0:9a378d2c:16a87f0c:ff89b2c8
>>
>>     Update Time : Mon Feb 28 23:35:20 2011
>>        Checksum : 3745d2b9 - correct
>>          Events : 33374
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 0
>>    Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
>>
>> /dev/sdb1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
>>            Name : XEN-HOST:0  (local to host XEN-HOST)
>>   Creation Time : Mon Dec 20 09:48:07 2010
>>      Raid Level : raid5
>>    Raid Devices : 3
>>
>>  Avail Dev Size : 1953517954 (931.51 GiB 1000.20 GB)
>>      Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
>>   Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
>>     Data Offset : 2048 sectors
>>    Super Offset : 8 sectors
>>           State : clean
>>     Device UUID : f20ab5fd:1f141cae:e0547278:d6cf063e
>>
>>     Update Time : Mon Feb 28 23:35:20 2011
>>        Checksum : a715b8ad - correct
>>          Events : 33374
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 1
>>    Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
>>
>> /dev/sdd1:
>>           Magic : a92b4efc
>>         Version : 1.2
>>     Feature Map : 0x0
>>      Array UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
>>            Name : XEN-HOST:0  (local to host XEN-HOST)
>>   Creation Time : Mon Dec 20 09:48:07 2010
>>      Raid Level : raid5
>>    Raid Devices : 3
>>
>>  Avail Dev Size : 1953521072 (931.51 GiB 1000.20 GB)
>>      Array Size : 3907035136 (1863.02 GiB 2000.40 GB)
>>   Used Dev Size : 1953517568 (931.51 GiB 1000.20 GB)
>>     Data Offset : 2048 sectors
>>    Super Offset : 8 sectors
>>           State : clean
>>     Device UUID : 33d70114:ffdc4fcc:2c8d65ba:ab50bab2
>>
>>     Update Time : Mon Feb 28 23:29:05 2011
>>        Checksum : 923d11a2 - correct
>>          Events : 33368
>>
>>          Layout : left-symmetric
>>      Chunk Size : 512K
>>
>>    Device Role : Active device 2
>>    Array State : AAA ('A' =3D=3D active, '.' =3D=3D missing)
>>
>> ---
>>
>>
>> Any ideas or tips? I am considering this might be a bug, but I have =
only
>> had this problem in my Debian Squeeze system.
>>
>
> What do cat /proc/mdstat and mdadm -D /dev/md0 show you? Also have yo=
u
> updated your mdadm.conf (and the mdadm.conf in the initramfs if you u=
se
> one)?
>

After a reboot I see

cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda1[0] sdb1[1]
      1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2=
] [UU_]

unused devices:=20


But sometimes I see

cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active (auto-read-only) raid5 sda1[0] sdb1[1]
      1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2=
] [UU_]

unused devices:=20


QUESTION: What does '(auto-read-only)' mean?

In either case --detail output is the same for both cases.

mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Mon Dec 20 09:48:07 2010
     Raid Level : raid5
     Array Size : 1953517568 (1863.02 GiB 2000.40 GB)
  Used Dev Size : 976758784 (931.51 GiB 1000.20 GB)
   Raid Devices : 3
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Tue Mar  1 13:50:53 2011
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : XEN-HOST:0  (local to host XEN-HOST)
           UUID : 7d8a7c68:95a230d0:0a8f6e74:4c8f81e9
         Events : 33422

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       0        0        2      removed


Hmm, so the array is aware that it is missing drive number/RaidDevice o=
f 2, I am not sure what implication of having a major/minor of 0.
QUESTION: Must the Major/Minor information exactly match what the syste=
m detect vs the meta data on the array (I presume)?

If that is the case it looks like I need to make drive number/RaidDevic=
e 2 have a major/minor 8/49.

ls -l /dev/sda1
brw-rw---- 1 root disk 8, 1 Mar=A0 1 14:17 /dev/sda1

ls -l /dev/sdb1
brw-rw---- 1 root disk 8, 17 Mar=A0 1 14:17 /dev/sdb1

ls -l /dev/sdd1
brw-rw---- 1 root floppy 8, 49 Mar=A0 1 14:17 /dev/sdd1


Until I find a solution I am manually running:

mdadm --re-add /dev/md0 /dev/sdd1 -vvv
mdadm: re-added /dev/sdd1

or

mdadm --add /dev/md0 /dev/sdd1 -vvv
mdadm: re-added /dev/sdd1


Which then gives me:

cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[3] sda1[0] sdb1[1]
      1953517568 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2=
] [UU_]
      [>....................]  recovery =3D  0.1% (1222156/976758784) f=
inish=3D622.3min speed=3D26126K/sec

unused devices:=20

QUESTION: Here is seems sdd1 is given drive number 3 not 2, is that a p=
roblem? (e.g: sdd1[2] vs sdd1[3])


I am also certain my mdadm.conf on my file system is in sync/updated wi=
th the one in my initramfs for all kernels actually.


cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks=
=2E
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions containers

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST=20

# definitions of existing MD arrays
ARRAY /dev/md/0 metadata=3D1.2 UUID=3D7d8a7c68:95a230d0:0a8f6e74:4c8f81=
e9 name=3DXEN-HOST:0



In trying to fix the problem I attempted to change the preferred minor =
of an MD array (RAID) by follow these instructions.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # you need to manually assemble the array to change the preferred m=
inor
    # if you manually assemble, the superblock will be updated to refle=
ct
    # the preferred minor as you indicate with the assembly.
    # for example, to set the preferred minor to 4:
    mdadm --assemble /dev/md4 /dev/sd[abc]1

    # this only works on 2.6 kernels, and only for RAID levels of 1 and=
 above.


mdadm --assemble /dev/md0 /dev/sd{a,b,d}1 -vvv
mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
mdadm: added /dev/sdb1 to /dev/md0 as 1
mdadm: added /dev/sdd1 to /dev/md0 as 2
mdadm: added /dev/sda1 to /dev/md0 as 0
mdadm: /dev/md0 has been started with 2 drives (out of 3) and 1 rebuild=
ing.


So because I specified all the drives, I assume this is the same things=
 as assembling the RAID degraded and then manually re-adding the last o=
ne (/dev/sdd1).


-M





 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
