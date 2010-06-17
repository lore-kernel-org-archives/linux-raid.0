From: David Watson <David.Watson@team17.com>
Subject: Raid 1 array degrades on reboot
Date: Thu, 17 Jun 2010 11:15:11 +0100
Message-ID: <4C19F5AF.5060300@team17.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Recently I upgraded to 2Tb disks on one of my servers, I built a new
degraded raid1 array:
mdadm --create /dev/md7 -level 1 --raid-devices=2 missing /dev/sdd1

added its entry to /etc/mdadm/mdadm.conf then I rebooted to add the
second disk and added it to the array:
mdadm --manage /dev/md7  --add /dev/sdb1

I updated /etc/mdadm/mdadm.conf, although I noticed no difference in the
output of:
mdadm --detail --scan


I use a monolithic kernel so there is no ramdisk to regenerate. This is
my first 1.00 array, and the existing 0.9 arrays have never shown this
issue. I have attempted the same process on a test server with no
issues, and I can't really think of what to look at next.

apologies for the long post.



The array I'm having trouble with is md7, I'm on debian lenny

# mdadm -V
mdadm - v2.6.7.2 - 14th November 2008




After boot and a resync:

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [multipath] [faulty]
md7 : active raid1 sdb1[2] sdd1[1]
      1953511864 blocks super 1.0 [2/2] [UU]

md1 : active raid1 sdc2[1] sda2[0]
      497920 blocks [2/2] [UU]

md2 : active raid1 sdc5[1] sda5[0]
      3911680 blocks [2/2] [UU]

md3 : active raid1 sdc6[1] sda6[0]
      4891648 blocks [2/2] [UU]

md4 : active raid1 sdc7[1] sda7[0]
      3911680 blocks [2/2] [UU]

md5 : active raid1 sdc8[1] sda8[0]
      276872128 blocks [2/2] [UU]

md0 : active raid1 sdc1[1] sda1[0]
      1959808 blocks [2/2] [UU]

unused devices: <none>


# mdadm --detail --scan
ARRAY /dev/md0 level=raid1 num-devices=2 metadata=00.90
UUID=b43f6098:06acab7b:580ff883:3ab60d5b
ARRAY /dev/md5 level=raid1 num-devices=2 metadata=00.90
UUID=eaa425c7:502672ee:dabc9034:1a71332c
ARRAY /dev/md4 level=raid1 num-devices=2 metadata=00.90
UUID=2b48f938:99b2b0e3:519fddc6:1290322f
ARRAY /dev/md3 level=raid1 num-devices=2 metadata=00.90
UUID=ccad63d9:d0b7c626:8348c59b:766a05a5
ARRAY /dev/md2 level=raid1 num-devices=2 metadata=00.90
UUID=bc9c8e72:de7eb7fb:231484db:a9ec47c7
ARRAY /dev/md1 level=raid1 num-devices=2 metadata=00.90
UUID=e047f745:4ba432d8:26e9533e:8c2555b4
ARRAY /dev/md7 level=raid1 num-devices=2 metadata=01.00 name=7
UUID=0ed787fb:7d7c6b5c:82113c0c:b30493e3

# cat /etc/mdadm/mdadm.conf
DEVICE /dev/sda* /deb/sdb* /dev/sdc* /dev/sdd*
CREATE owner=root group=disk mode=0660 auto=yes metadata=1
MAILADDR root
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=b43f6098:06acab7b:580ff883:3ab60d5b
ARRAY /dev/md5 level=raid1 num-devices=2
UUID=eaa425c7:502672ee:dabc9034:1a71332c
ARRAY /dev/md4 level=raid1 num-devices=2
UUID=2b48f938:99b2b0e3:519fddc6:1290322f
ARRAY /dev/md3 level=raid1 num-devices=2
UUID=ccad63d9:d0b7c626:8348c59b:766a05a5
ARRAY /dev/md2 level=raid1 num-devices=2
UUID=bc9c8e72:de7eb7fb:231484db:a9ec47c7
ARRAY /dev/md1 level=raid1 num-devices=2
UUID=e047f745:4ba432d8:26e9533e:8c2555b4
ARRAY /dev/md7 level=raid1 num-devices=2 metadata=1.0 name=7
UUID=0ed787fb:7d7c6b5c:82113c0c:b30493e3

# mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 0ed787fb:7d7c6b5c:82113c0c:b30493e3
           Name : 7
  Creation Time : Fri Jun  4 12:19:54 2010
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3907023728 (1863.01 GiB 2000.40 GB)
     Array Size : 3907023728 (1863.01 GiB 2000.40 GB)
   Super Offset : 3907023984 sectors
          State : clean
    Device UUID : 99055997:7584cb3c:12f75ae1:dbbc5dfa

    Update Time : Thu Jun 17 10:52:58 2010
       Checksum : f3904db3 - correct
         Events : 10260


    Array Slot : 2 (failed, 1, 0)
   Array State : Uu 1 failed


# mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x0
     Array UUID : 0ed787fb:7d7c6b5c:82113c0c:b30493e3
           Name : 7
  Creation Time : Fri Jun  4 12:19:54 2010
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 3907023728 (1863.01 GiB 2000.40 GB)
     Array Size : 3907023728 (1863.01 GiB 2000.40 GB)
   Super Offset : 3907023984 sectors
          State : clean
    Device UUID : b5defada:b9882124:28febea7:7775802f

    Update Time : Thu Jun 17 10:52:58 2010
       Checksum : 1a0eeac4 - correct
         Events : 10260


    Array Slot : 1 (failed, 1, 0)
   Array State : uU 1 failed

# fdisk -l /dev/sdb

Disk /dev/sdb: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x4bf7ec5a

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1      243201  1953512001   da  Non-FS data

# fdisk -l /dev/sdd

Disk /dev/sdd: 2000.3 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x81e47a11

   Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1      243201  1953512001   da  Non-FS data
buildstore:~#
