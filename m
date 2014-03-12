From: "Manibalan P" <pmanibalan@amiindia.co.in>
Subject: RE: raid6 - data integrity issue - data mis-compare on rebuilding RAID 6 - with 100 Mb resync speed.
Date: Wed, 12 Mar 2014 13:09:28 +0530
Message-ID: <13688C12F44C7C428726663F950CA253094ADEC6@venus.in.megatrends.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi,

>I don't know what kernel "CentOS 6.4" runs.  Please report the actual
kernel version as well as distro details.
The Kernel version is : 2.6.32
 Centos  distribution  : 2.6.32-358.23.2.el6.x86_64 #1 SMP : x86_64
GNU/Linux

>I know nothing about "dit32" and so cannot easily interpret the output.
Is it saying that just a few bytes were wrong?

It is not just few bytes of corruption, it looks like some number of
sectors are corrupted (for example - 40 sectors ).  dit32 will write a
pattern of IO, and after each write cycle, it will read it back and
verify.
Actually, the data which is written on the reported LBA itself
corrupted. What I mean to say is,  this looks like write corruption.

>
>Was the array fully synced before you started the test?

Yes , IO is started, only after the re-sync is completed.
 And to add more info,
             I am facing this mis-compare only with high resync speed
(30M to 100M), I ran the same test with resync speed min -10M and max -
30M, without any issue. So the  issue has relationship with
sync_speed_max / min.

>
>I can't think of anything else that might cause an inconsistency.  I 
>test the
>RAID6 recovery code from time to time and it always works flawlessly
for me.

Do you suggest, any IO tool or test to ensure data integrity.

One more thing, I like to bring to your notification. I did the same IO
test on Ubuntu 13 (Linux ubuntu 3.8.0-19-generic #29-Ubuntu SMP Wed Apr
17 18:16:28 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux ) system also. And I
faced same type of data corruption.

Thanks,
Manibalan.

More Information:

[root@Cento6 ~]# mdadm --version
mdadm - v3.2.5 - 18th May 2012
------------------------------------------------------------------------
-----------------------------
[root@Cento6 ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdd6[13] sdg6[11] sdf6[12] sde6[9] sdh6[8] sdc6[10]
sdb6[7]
      26214400 blocks super 1.2 level 6, 64k chunk, algorithm 2 [7/6]
[UUUUUU_]
      [===============>.....]  recovery = 75.2% (3943692/5242880)
finish=0.3min speed=60112K/sec

unused devices: <none>
------------------------------------------------------------------------
-----------------------------
[root@Cento6 ~]# mdadm -Evvvs
/dev/md0:
   MBR Magic : aa55
Partition[0] :     52422656 sectors at         2048 (type 0c)
mdadm: No md superblock detected on /dev/dm-2.
mdadm: No md superblock detected on /dev/dm-1.
mdadm: No md superblock detected on /dev/dm-0.
mdadm: No md superblock detected on /dev/sda2.
mdadm: No md superblock detected on /dev/sda1.
/dev/sda:
   MBR Magic : aa55
Partition[0] :      1024000 sectors at         2048 (type 83)
Partition[1] :    285722624 sectors at      1026048 (type 8e)
/dev/sdd6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x2
     Array UUID : 6e5e1ed7:5b4bbe23:ae3ce08e:8502c4d5
           Name : initiator:0
  Creation Time : Fri Mar  7 20:33:24 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 3891293457 (1855.51 GiB 1992.34 GB)
     Array Size : 26214400 (25.00 GiB 26.84 GB)
  Used Dev Size : 10485760 (5.00 GiB 5.37 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
Recovery Offset : 9830520 sectors
          State : clean
    Device UUID : 0df3501e:7cdae253:4a6628ba:e0aed1c2

    Update Time : Sat Mar  8 10:00:15 2014
       Checksum : 6b146a09 - correct
         Events : 14853

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 6
   Array State : AAAAAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdd5.
mdadm: No md superblock detected on /dev/sdd4.
mdadm: No md superblock detected on /dev/sdd3.
mdadm: No md superblock detected on /dev/sdd2.
mdadm: No md superblock detected on /dev/sdd1.
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
/dev/sdc6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6e5e1ed7:5b4bbe23:ae3ce08e:8502c4d5
           Name : initiator:0
  Creation Time : Fri Mar  7 20:33:24 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 3891293457 (1855.51 GiB 1992.34 GB)
     Array Size : 26214400 (25.00 GiB 26.84 GB)
  Used Dev Size : 10485760 (5.00 GiB 5.37 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5304a667:f7ff5099:4d438d70:6d4d7aed

    Update Time : Sat Mar  8 10:00:15 2014
       Checksum : da4f1bdd - correct
         Events : 14853

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : AAAAAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdc5.
mdadm: No md superblock detected on /dev/sdc4.
mdadm: No md superblock detected on /dev/sdc3.
mdadm: No md superblock detected on /dev/sdc2.
mdadm: No md superblock detected on /dev/sdc1.
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
/dev/sdb6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6e5e1ed7:5b4bbe23:ae3ce08e:8502c4d5
           Name : initiator:0
  Creation Time : Fri Mar  7 20:33:24 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 3891293457 (1855.51 GiB 1992.34 GB)
     Array Size : 26214400 (25.00 GiB 26.84 GB)
  Used Dev Size : 10485760 (5.00 GiB 5.37 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 0042c71b:f2642cec:4455ac44:e941ab66

    Update Time : Sat Mar  8 10:00:15 2014
       Checksum : 2e9bc4f5 - correct
         Events : 14853

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 0
   Array State : AAAAAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdb5.
mdadm: No md superblock detected on /dev/sdb4.
mdadm: No md superblock detected on /dev/sdb3.
mdadm: No md superblock detected on /dev/sdb2.
mdadm: No md superblock detected on /dev/sdb1.
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
/dev/sdg6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6e5e1ed7:5b4bbe23:ae3ce08e:8502c4d5
           Name : initiator:0
  Creation Time : Fri Mar  7 20:33:24 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 3891293457 (1855.51 GiB 1992.34 GB)
     Array Size : 26214400 (25.00 GiB 26.84 GB)
  Used Dev Size : 10485760 (5.00 GiB 5.37 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b05ea97b:fd15cd87:4a71f688:e5140be8

    Update Time : Sat Mar  8 10:00:15 2014
       Checksum : efc881b6 - correct
         Events : 14853

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 4
   Array State : AAAAAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdg5.
mdadm: No md superblock detected on /dev/sdg4.
mdadm: No md superblock detected on /dev/sdg3.
mdadm: No md superblock detected on /dev/sdg2.
mdadm: No md superblock detected on /dev/sdg1.
/dev/sdg:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
/dev/sdh6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6e5e1ed7:5b4bbe23:ae3ce08e:8502c4d5
           Name : initiator:0
  Creation Time : Fri Mar  7 20:33:24 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 3891293457 (1855.51 GiB 1992.34 GB)
     Array Size : 26214400 (25.00 GiB 26.84 GB)
  Used Dev Size : 10485760 (5.00 GiB 5.37 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 7002db82:8feb4355:9c7d788c:b89a2823

    Update Time : Sat Mar  8 10:00:15 2014
       Checksum : 3108d2a - correct
         Events : 14853

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : AAAAAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdh5.
mdadm: No md superblock detected on /dev/sdh4.
mdadm: No md superblock detected on /dev/sdh3.
mdadm: No md superblock detected on /dev/sdh2.
mdadm: No md superblock detected on /dev/sdh1.
/dev/sdh:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
/dev/sde6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6e5e1ed7:5b4bbe23:ae3ce08e:8502c4d5
           Name : initiator:0
  Creation Time : Fri Mar  7 20:33:24 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 3891293457 (1855.51 GiB 1992.34 GB)
     Array Size : 26214400 (25.00 GiB 26.84 GB)
  Used Dev Size : 10485760 (5.00 GiB 5.37 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : afc8f016:23c110f2:4a209140:d9c0cef8

    Update Time : Sat Mar  8 10:00:15 2014
       Checksum : bdb1f1cd - correct
         Events : 14853

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAAAAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sde5.
mdadm: No md superblock detected on /dev/sde4.
mdadm: No md superblock detected on /dev/sde3.
mdadm: No md superblock detected on /dev/sde2.
mdadm: No md superblock detected on /dev/sde1.
/dev/sde:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
/dev/sdf6:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 6e5e1ed7:5b4bbe23:ae3ce08e:8502c4d5
           Name : initiator:0
  Creation Time : Fri Mar  7 20:33:24 2014
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 3891293457 (1855.51 GiB 1992.34 GB)
     Array Size : 26214400 (25.00 GiB 26.84 GB)
  Used Dev Size : 10485760 (5.00 GiB 5.37 GB)
    Data Offset : 8192 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 62ff3273:a8e1260b:4c0e8ba0:48093e3f

    Update Time : Sat Mar  8 10:00:15 2014
       Checksum : d9737f78 - correct
         Events : 14853

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 5
   Array State : AAAAAAA ('A' == active, '.' == missing)
mdadm: No md superblock detected on /dev/sdf5.
mdadm: No md superblock detected on /dev/sdf4.
mdadm: No md superblock detected on /dev/sdf3.
mdadm: No md superblock detected on /dev/sdf2.
mdadm: No md superblock detected on /dev/sdf1.
/dev/sdf:
   MBR Magic : aa55
Partition[0] :   3907029167 sectors at            1 (type ee)
------------------------------------------------------------------------
-----------------------------
[root@Cento6 ~]# mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Fri Mar  7 20:33:24 2014
     Raid Level : raid6
     Array Size : 26214400 (25.00 GiB 26.84 GB)
  Used Dev Size : 5242880 (5.00 GiB 5.37 GB)
   Raid Devices : 7
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Sat Mar  8 10:00:32 2014
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : initiator:0
           UUID : 6e5e1ed7:5b4bbe23:ae3ce08e:8502c4d5
         Events : 14855

    Number   Major   Minor   RaidDevice State
       7       8       22        0      active sync   /dev/sdb6
       8       8      118        1      active sync   /dev/sdh6
       9       8       70        2      active sync   /dev/sde6
      10       8       38        3      active sync   /dev/sdc6
      11       8      102        4      active sync   /dev/sdg6
      12       8       86        5      active sync   /dev/sdf6
      13       8       54        6      active sync   /dev/sdd6
------------------------------------------------------------------------
-----------------------------
[root@Cento6 ~]# tgtadm --mode target --op show
Target 1: iqn.2011-07.world.server:target0
    System information:
        Driver: iscsi
        State: ready
    I_T nexus information:
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: IET     00010000
            SCSI SN: beaf10
            Size: 0 MB, Block size: 1
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            Backing store type: null
            Backing store path: None
            Backing store flags:
        LUN: 1
            Type: disk
            SCSI ID: IET     00010001
            SCSI SN: beaf11
            Size: 26844 MB, Block size: 512
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            Backing store type: rdwr
            Backing store path: /dev/md0
            Backing store flags:
    Account information:
    ACL information:
        ALL
------------------------------------------------------------------------
-----------------------------
[root@Cento6 ~]# cat /sys/block/md0/md/sync_speed_max
100000 (local)
[root@Cento6 ~]# cat /sys/block/md0/md/sync_speed_min
100000 (local)


-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: Tuesday, March 11, 2014 8:34 AM
To: Manibalan P
Cc: linux-raid@vger.kernel.org
Subject: Re: raid6 - data intefrity issue - data mis-compare on
rebuilding RAID 6 - with 100 Mb resync speed.

On Fri, 7 Mar 2014 14:18:59 +0530 "Manibalan P"
<pmanibalan@amiindia.co.in>
wrote:

> Hi,

Hi,
 when posting to vger.kernel.org lists, please don't send HTML mail,
just  plain text.
 Because you did the original email didn't get to the list.

> 
>  
> 
> We are facing a data integrity issue on RAID 6. On CentOS 6.4 kernel.

I don't know what kernel "CentOS 6.4" runs.  Please report the actual
kernel version as well as distro details.

> 
>  
> 
> Details of the setup:
> 
>  
> 
> 1.       7 drives Raid6 md devices (md0) - Capacity 25 GB
> 
> 2.       Resync speed max and min set to 100000 (100Mb)
> 
> 3.       A script is running to simulate drive failure, this script
will
> do the following
> 
> a.       Mdadm set faulty for two random drives on the md, the mdadm
> remove those drives.
> 
> b.      Mdadm add ond drive, and wait for rebuild to complete, then
> insert the next one.
> 
> c.       Wait till the md become optimal, and continue the disk
removal
> cycle again.
> 
> 4.       iSCSI target is configured to "/dev/md0"
> 
> 5.       From  Windows server, the md0 target is connected using
> MicroSoft iSCSI initiator, and formatted with NTFS.
> 
> 6.       Dit32 IO tool is running on the formatted volume.
> 
>  
> 
> Issue#:
> 
>                 The Dit32 tool will running IO in multiple threads, in

> each thread, IO will be written and verified.
> 
>                 And on the verification Cycle, we are getting 
> mis-compare. Below is the log from the dit32 tool.
> 
>                 
> 
> Thu Mar 06 23:19:31 2014 INFO:  DITNT application started
> 
> Thu Mar 06 23:20:19 2014 INFO:  Test started on Drive D:
> 
>      Dir Sets=8, Dirs per Set=70, Files per Dir=75
> 
>      File Size=512KB
> 
>      Read Only=N, Debug Stamp=Y, Verify During Copy=Y
> 
>      Build I/O Size range=1 to 128 sectors
> 
>      Copy Read I/O Size range=1 to 128 sectors
> 
>      Copy Write I/O Size range=1 to 128 sectors
> 
>      Verify I/O Size range=1 to 128 sectors
> 
> Fri Mar 07 01:28:09 2014 ERROR: Miscompare Found: File 
> "D:\dit\s6\d51\s6d51f37", offset=00048008
> 
>      Expected Data: 06 33 25 01 0240 (dirSet, dirNo, fileNo, 
> elementNo,
> sectorOffset)
> 
>          Read Data: 05 08 2d 01 0240 (dirSet, dirNo, fileNo, 
> elementNo,
> sectorOffset)
> 
>      Read Request: offset=00043000, size=00008600
> 
>  
> 
> This mail has been attached with the following files for your 
> reference
> 
> 1.       Raid5.c and .h files, the Code what we are using.
> 
> 2.       RollingHotSpareTwoDriveFailure.sh - the script which
simulates
> the two disk failure.
> 
> 3.       dit32log.sav - Log file from the dit32 tool
> 
> 4.       s6d31f37 - the file where the corruption happened(hex format)
> 
> 5.       CentOS-system-info - md and system info
> 
>  

I didn't find any "CentOS-system-info" attached.

I know nothing about "dit32" and so can not easily interpret the output.
Is it saying that just a few bytes were wrong?

Was the array fully synced before you started the test?

I can't think of anything else that might cause an inconsistency.  I
test the
RAID6 recovery code from time to time and it always works flawlessly for
me.

NeilBrown



> 
>                 
> 
> Thanks,
> 
> Manibalan.
> 
>  
> 

