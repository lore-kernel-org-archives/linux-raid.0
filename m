From: Jean-Paul Sergent <jpsergent@gmail.com>
Subject: 2 disk raid 5 failure
Date: Sat, 4 Oct 2014 22:43:01 -0700
Message-ID: <CANuKpt=QJsham0TQWR1Cu1EC8GLyc0aSdU4p3DOznBRrEea11A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

Recently I lost 2 disks, out of 5, in my raid 5 array from a bad SATA power
cable. It was a Y splitter and it shorted... it was cheap. I was wondering
if there was any chance in getting my data back.

Of the 2 disks that blew out, one actually had bad/unreadable sectors on
the disk and the other disk seems fine. I have cloned both disks with DD to
2 new disks and forced the one disk to clone even with errors. The
remaining 3 disks are in tact. The events number on the array for all 5
disks are very close to each other:

         Events : 201636
         Events : 201636
         Events : 201636
         Events : 201630
         Events : 201633

Which from my reading gives me some hope, but I'm not sure. I have not done
"recovering a failed software raid" on the wiki yet, the part about
using a loop device to protect your array. I thought I would send a
message out to this list first before going down
that route.

I did try to do a mdadm --force --assemble on the array but is says that it
only has 3 disks which isn't enough to start the array. I don't want to do
anything else before consulting the mailing list first.

below I have pasted the mdadm --examine from each member drive. Any help would
be greatly appreciated.

Thanks,
-JP

/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7de100f5:4f30f751:62456293:fe98f735
           Name : b1ackb0x:1
  Creation Time : Sun Jan 13 00:01:44 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=816 sectors
          State : clean
    Device UUID : 71d7c3d7:7b232399:51571715:711da6f6

    Update Time : Tue Apr 29 02:49:21 2014
       Checksum : cd29f83c - correct
         Events : 201636

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7de100f5:4f30f751:62456293:fe98f735
           Name : b1ackb0x:1
  Creation Time : Sun Jan 13 00:01:44 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=816 sectors
          State : clean
    Device UUID : b47c32b5:b2f9e81a:37150c33:8e3fa6ca

    Update Time : Tue Apr 29 02:49:21 2014
       Checksum : 1e5353af - correct
         Events : 201636

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7de100f5:4f30f751:62456293:fe98f735
           Name : b1ackb0x:1
  Creation Time : Sun Jan 13 00:01:44 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=816 sectors
          State : clean
    Device UUID : 0398da5b:0bcddd81:8f7e77e9:6689ee0c

    Update Time : Tue Apr 29 02:49:21 2014
       Checksum : 24a3f586 - correct
         Events : 201636

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7de100f5:4f30f751:62456293:fe98f735
           Name : b1ackb0x:1
  Creation Time : Sun Jan 13 00:01:44 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=976752816 sectors
          State : clean
    Device UUID : 356c6d85:627a994f:753dec0d:db4fa4f2

    Update Time : Tue Apr 29 02:37:38 2014
       Checksum : 2621f9d5 - correct
         Events : 201630

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7de100f5:4f30f751:62456293:fe98f735
           Name : b1ackb0x:1
  Creation Time : Sun Jan 13 00:01:44 2013
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 2930275120 (1397.26 GiB 1500.30 GB)
     Array Size : 5860548608 (5589.05 GiB 6001.20 GB)
  Used Dev Size : 2930274304 (1397.26 GiB 1500.30 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=976752816 sectors
          State : clean
    Device UUID : 3dc152d8:832dd43a:a6d638e3:6e12b394

    Update Time : Tue Apr 29 02:48:01 2014
       Checksum : db9e6008 - correct
         Events : 201633

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAA.A ('A' == active, '.' == missing, 'R' == replacing)
