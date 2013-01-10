From: Daniel Browning <db@kavod.com>
Subject: What to do about "ignoring %s as it reports %s as failed"?
Date: Thu, 10 Jan 2013 11:01:01 -0800
Message-ID: <201301101101.01371.db@kavod.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, folks. What should I do about the following error?

	mdadm: ignoring /dev/sdd1 as it reports /dev/sdb1 as failed

I'm building a new replacement array and restoring from backup, but I would 
still like to try and salvage this failed one if possible, and I was 
surprised to find very few results on google for that particular error 
message.

Here is the background. I recently had a 4-disk raid5 array made up of:

	/dev/sdb1
	/dev/sdc1
	/dev/sdd1
	/dev/sde1

Wednesday afternoon (yesterday), /dev/sde1 failed, so the array went into 
degraded (no parity) state. I thought I'd give sde another chance, so I 
zero'd the superblock and re-added it to the array, which began rebuilding. 
But then when it had reached 72.4% early this morning, /dev/sdb1 failed:

md127 : active raid5 sde1[5] sdc1[0] sdb1[1](F) sdd1[4]
      5859302400 blocks super 1.2 level 5, 512k chunk,
      algorithm 2 [4/2] [U__U]
      [==============>......]  recovery = 72.4% (1414790348/1953100800)
      finish=1192.3min speed=7524K/sec

But /dev/sdb1 is working now (same as /dev/sde1). I tried to re-assemble the 
raid:

[root@lx4 ~]# mdadm --assemble --verbose /dev/md127 /dev/sd[bcde]1
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sde1 is identified as a member of /dev/md127, slot -1.
mdadm: added /dev/sdb1 to /dev/md127 as 1 (possibly out of date)
mdadm: no uptodate device for slot 2 of /dev/md127
mdadm: added /dev/sdd1 to /dev/md127 as 3
mdadm: added /dev/sde1 to /dev/md127 as -1
mdadm: added /dev/sdc1 to /dev/md127 as 0
mdadm: /dev/md127 assembled from 2 drives and 1 spare - not enough to start 
the array.

But it rejected /dev/sdb1, so I ran --force to have it update the event 
count:

[root@lx4 ~]# mdadm --assemble --force --verbose /dev/md127 /dev/sd[bcde]1
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sde1 is identified as a member of /dev/md127, slot -1.
mdadm: forcing event count in /dev/sdb1(1) from 905199 upto 905262
mdadm: clearing FAULTY flag for device 0 in /dev/md127 for /dev/sdb1
mdadm: Marking array /dev/md127 as 'clean'
mdadm: added /dev/sdb1 to /dev/md127 as 1
mdadm: no uptodate device for slot 2 of /dev/md127
mdadm: added /dev/sdd1 to /dev/md127 as 3
mdadm: added /dev/sde1 to /dev/md127 as -1
mdadm: added /dev/sdc1 to /dev/md127 as 0
mdadm: /dev/md127 assembled from 3 drives and 1 spare - not enough to start 
the array.

This surprised me a lot, because I thought 3 drives would have been enough 
to start the array. But when I ran it again, I got a different error:

[root@lx4 ~]# mdadm --assemble --force --verbose /dev/md127 /dev/sd[bcde]1
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdb1 is identified as a member of /dev/md127, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 3.
mdadm: /dev/sde1 is identified as a member of /dev/md127, slot -1.
mdadm: ignoring /dev/sdd1 as it reports /dev/sdb1 as failed
mdadm: added /dev/sdb1 to /dev/md127 as 1
mdadm: no uptodate device for slot 2 of /dev/md127
mdadm: no uptodate device for slot 3 of /dev/md127
mdadm: added /dev/sde1 to /dev/md127 as -1
mdadm: added /dev/sdc1 to /dev/md127 as 0
mdadm: /dev/md127 assembled from 2 drives and 1 spare - not enough to start 
the array.

It appears to be failing because of this:

	mdadm: ignoring /dev/sdd1 as it reports /dev/sdb1 as failed

The sauce says this:

/* If this device thinks that 'most_recent' has failed, then
 * we must reject this device.
 */

But I can't interpret that into a possible fix. Any ideas?

Thanks in advance,
--
Daniel Browning



Appendix A. Versions
Distro: Fedora Core 16
Kernel: 3.4.4-4.fc16.x86_64 #1 SMP Thu Jul 5 20:01:38 UTC 2012
mdadm: v3.2.5 - 18th May 2012



Appendix B. contents of mdstat after a failed "--assemble":
md127 : inactive sdc1[0](S) sdb1[1](S)
      3906202639 blocks super 1.2



Appendix C. mdadm --examine for all disks, from *before* the 
"--assemble --force" was executed:
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 4ca86345:c28c62be:03c9f77b:6760ef5c
           Name : lx4:127
  Creation Time : Sun Oct 10 15:46:28 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906202639 (1862.62 GiB 1999.98 GB)
     Array Size : 5859302400 (5587.87 GiB 5999.93 GB)
  Used Dev Size : 3906201600 (1862.62 GiB 1999.98 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 156bc6e0:eaa285fd:8f4ef720:6f2171c2

    Update Time : Thu Jan 10 00:50:25 2013
       Checksum : f0945b4a - correct
         Events : 905199

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 4ca86345:c28c62be:03c9f77b:6760ef5c
           Name : lx4:127
  Creation Time : Sun Oct 10 15:46:28 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906202639 (1862.62 GiB 1999.98 GB)
     Array Size : 5859302400 (5587.87 GiB 5999.93 GB)
  Used Dev Size : 3906201600 (1862.62 GiB 1999.98 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 2dbbc5d0:f3deb841:50c7c992:c9abf856

    Update Time : Thu Jan 10 09:14:03 2013
       Checksum : 2b1b4f88 - correct
         Events : 905262

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A..A ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 4ca86345:c28c62be:03c9f77b:6760ef5c
           Name : lx4:127
  Creation Time : Sun Oct 10 15:46:28 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906202639 (1862.62 GiB 1999.98 GB)
     Array Size : 5859302400 (5587.87 GiB 5999.93 GB)
  Used Dev Size : 3906201600 (1862.62 GiB 1999.98 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : bdd8c401:9389bf9b:c80762a2:682b0297

    Update Time : Thu Jan 10 09:14:03 2013
       Checksum : 5c2d7d3 - correct
         Events : 905262

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : A..A ('A' == active, '.' == missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 4ca86345:c28c62be:03c9f77b:6760ef5c
           Name : lx4:127
  Creation Time : Sun Oct 10 15:46:28 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3906202639 (1862.62 GiB 1999.98 GB)
     Array Size : 5859302400 (5587.87 GiB 5999.93 GB)
  Used Dev Size : 3906201600 (1862.62 GiB 1999.98 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 78c381f7:1447cbd4:6af86729:d4c08320

    Update Time : Thu Jan 10 09:14:03 2013
       Checksum : 4513061e - correct
         Events : 905262

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : A..A ('A' == active, '.' == missing)
