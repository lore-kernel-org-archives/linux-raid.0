From: Tim Small <tim@buttersideup.com>
Subject: Controller problems during reshape -> can't continue reshape after
 reboot.
Date: Mon, 20 Aug 2012 20:55:38 +0100
Message-ID: <5032963A.8000908@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I was attempting to reshape a RAID5 from 4 to 5 devices.  During the
reshape, I had a problem with one of the controller cards in the
machine, so that first one drive, had repeated errors (and was
eventually marked as failed), and then several hours later, I/O to
another drive effectively stalled.  At this point, /proc/mdstat was
showing the reshape proceeding (with one drive marked as failed), but
the throughput had dropped to zero.


After rebooting the machine (alt-sysrq s, u, b) the array won't
reassemble (with or without '--force')...

(I've now replaced the card, and read all data on all drives
successfully...)

[ 2716.070788] raid5: md1 is not clean -- starting background reconstruction
[ 2716.070984] raid5: reshape will continue
[ 2716.071166] raid5: device sda1 operational as raid disk 0
[ 2716.071350] raid5: device sdi1 operational as raid disk 4
[ 2716.071534] raid5: device sdj1 operational as raid disk 3
[ 2716.071715] raid5: device sdk1 operational as raid disk 1
[ 2716.072217] raid5: allocated 5334kB for md1
[ 2716.072452] 0: w=1 pa=2 pr=4 m=1 a=2 r=5 op1=0 op2=0
[ 2716.072633] 4: w=2 pa=2 pr=4 m=1 a=2 r=5 op1=0 op2=0
[ 2716.072816] 3: w=3 pa=2 pr=4 m=1 a=2 r=5 op1=0 op2=0
[ 2716.073001] 1: w=4 pa=2 pr=4 m=1 a=2 r=5 op1=0 op2=0
[ 2716.073180] raid5: cannot start dirty degraded array for md1
[ 2716.073372] RAID5 conf printout:
[ 2716.073544]  --- rd:5 wd:4
[ 2716.073717]  disk 0, o:1, dev:sda1
[ 2716.073884]  disk 1, o:1, dev:sdk1
[ 2716.074071]  disk 3, o:1, dev:sdj1
[ 2716.074239]  disk 4, o:1, dev:sdi1
[ 2716.074575] raid5: failed to run raid set md1
[ 2716.074749] md: pers->run() failed ...


Any chance of carrying on where it left off, or should I recreate the
array from scratch?

# cat /etc/debian_version ; uname -a
6.0.2
Linux rodmell 2.6.32-5-amd64 #1 SMP Tue Jun 14 09:42:28 UTC 2011 x86_64
GNU/Linux
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : inactive sda1[0] sdi1[5] sdj1[4] sdk1[1]
      7814054112 blocks super 1.2
# mdadm -E /dev/sd[hijak]1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 717d7de6:49a886f6:fb20ac87:5a1e8a84
           Name : rodmell:1  (local to host rodmell)
  Creation Time : Mon Dec 19 18:00:13 2011
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 3907027056 (1863.02 GiB 2000.40 GB)
     Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 1bf82ae0:82b71e9b:6283dc62:467026fc

  Reshape pos'n : 1622353920 (1547.20 GiB 1661.29 GB)
  Delta Devices : 1 (4->5)

    Update Time : Mon Aug 20 08:42:56 2012
       Checksum : 46d057ad - correct
         Events : 24587

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AA.AA ('A' == active, '.' == missing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 717d7de6:49a886f6:fb20ac87:5a1e8a84
           Name : rodmell:1  (local to host rodmell)
  Creation Time : Mon Dec 19 18:00:13 2011
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 3907027056 (1863.02 GiB 2000.40 GB)
     Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 3e9cca4d:3872738b:1903ee56:5a91b935

  Reshape pos'n : 10582016 (10.09 GiB 10.84 GB)
  Delta Devices : 1 (4->5)

    Update Time : Thu Aug 16 17:30:46 2012
       Checksum : 12400b18 - correct
         Events : 15896

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAA ('A' == active, '.' == missing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 717d7de6:49a886f6:fb20ac87:5a1e8a84
           Name : rodmell:1  (local to host rodmell)
  Creation Time : Mon Dec 19 18:00:13 2011
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 3907027056 (1863.02 GiB 2000.40 GB)
     Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 904de121:58fbef1d:16546bd7:d3ab29c5

  Reshape pos'n : 1622353920 (1547.20 GiB 1661.29 GB)
  Delta Devices : 1 (4->5)

    Update Time : Fri Aug 17 01:32:23 2012
       Checksum : 48e5a3d3 - correct
         Events : 24586

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AA.AA ('A' == active, '.' == missing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 717d7de6:49a886f6:fb20ac87:5a1e8a84
           Name : rodmell:1  (local to host rodmell)
  Creation Time : Mon Dec 19 18:00:13 2011
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 3907027056 (1863.02 GiB 2000.40 GB)
     Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 59efcddf:9e679807:09ce1bc4:d882af69

  Reshape pos'n : 1622353920 (1547.20 GiB 1661.29 GB)
  Delta Devices : 1 (4->5)

    Update Time : Mon Aug 20 08:42:56 2012
       Checksum : 81b55c43 - correct
         Events : 24587

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AA.AA ('A' == active, '.' == missing)
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 717d7de6:49a886f6:fb20ac87:5a1e8a84
           Name : rodmell:1  (local to host rodmell)
  Creation Time : Mon Dec 19 18:00:13 2011
     Raid Level : raid5
   Raid Devices : 5

 Avail Dev Size : 3907027056 (1863.02 GiB 2000.40 GB)
     Array Size : 15628103680 (7452.06 GiB 8001.59 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 31b29cdb:0b70201e:de2036a4:5aecda02

  Reshape pos'n : 1622353920 (1547.20 GiB 1661.29 GB)
  Delta Devices : 1 (4->5)

    Update Time : Mon Aug 20 08:42:56 2012
       Checksum : d51e3dc - correct
         Events : 24587

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA.AA ('A' == active, '.' == missing)



Cheers,

Tim.
