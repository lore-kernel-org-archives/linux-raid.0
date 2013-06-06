From: Aleh Suprunovich <a.suprunovich@sam-solutions.com>
Subject: RAID10 freeze system instead of failing
Date: Thu, 6 Jun 2013 16:24:12 +0300
Message-ID: <20130606132412.GA14474@sam-solutions.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

Dear linux-raid members,

I have an issue with RAID10 while testing NAS device capability to ger over
different RAID failures.

We running current Debian stable with 3.2 kernel.

# uname -a
Linux <hostname> 3.2.0-4-amd64 #1 SMP Debian 3.2.41-2 x86_64 GNU/Linux

System has 4 disks, partitioned in a way to create 2 RAID1 arrays over all disks
to run the system and one array to store data, RAID10 in this case. After
removing three devices out of NAS I expect RAID10 to became failed, but instead,
system freezes in couple of minutes after removing third drive.

Here is the mdstat in clean state:

# cat /proc/mdstat
Personalities : [raid1] [linear] [raid10]
md2 : active raid10 sde4[3] sdd4[2] sdc4[1] sda4[0]
      38121216 blocks super 1.2 64K chunks 2 near-copies [4/4] [UUUU]

md1 : active raid1 sde3[6] sdc3[5] sdd3[4] sda3[0]
      9991040 blocks super 1.2 [4/4] [UUUU]

md0 : active raid1 sde2[6] sdc2[5] sdd2[4] sda2[0]
      9991040 blocks super 1.2 [4/4] [UUUU]

unused devices: <none>

First and second disk removal works as intended, RAID is in degraded state after
this:

# mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Thu Jun  6 13:23:49 2013
     Raid Level : raid10
     Array Size : 38121216 (36.36 GiB 39.04 GB)
  Used Dev Size : 19060608 (18.18 GiB 19.52 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Thu Jun  6 13:51:53 2013
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 64K

           Name : BizNAS-223-322:2  (local to host BizNAS-223-322)
           UUID : 5eefc5e1:77a2acc3:ac49dc42:0b4b7906
         Events : 127

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       0        0        1      removed
       2       0        0        2      removed
       3       8       68        3      active sync   /dev/sde4

       1       8       36        -      faulty spare
       2       8       52        -      faulty spare

But after removing third device, RAID is still reported as degraded by mdadm:

# mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Thu Jun  6 13:23:49 2013
     Raid Level : raid10
     Array Size : 38121216 (36.36 GiB 39.04 GB)
  Used Dev Size : 19060608 (18.18 GiB 19.52 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Thu Jun  6 14:06:57 2013
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 64K

           Name : BizNAS-223-322:2  (local to host BizNAS-223-322)
           UUID : 5eefc5e1:77a2acc3:ac49dc42:0b4b7906
         Events : 865

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       0        0        1      removed
       2       0        0        2      removed
       3       8       68        3      active sync

       1       8       36        -      faulty spare
       2       8       52        -      faulty spare

# mdadm --manage /dev/md2 --remove failed
mdadm: hot removed 8:36 from /dev/md2
mdadm: hot removed 8:52 from /dev/md2
root@BizNAS-223-322:~# mdadm -D /dev/md2
/dev/md2:
        Version : 1.2
  Creation Time : Thu Jun  6 13:23:49 2013
     Raid Level : raid10
     Array Size : 38121216 (36.36 GiB 39.04 GB)
  Used Dev Size : 19060608 (18.18 GiB 19.52 GB)
   Raid Devices : 4
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Thu Jun  6 14:07:07 2013
          State : active, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 64K

           Name : BizNAS-223-322:2  (local to host BizNAS-223-322)
           UUID : 5eefc5e1:77a2acc3:ac49dc42:0b4b7906
         Events : 876

    Number   Major   Minor   RaidDevice State
       0       8        4        0      active sync   /dev/sda4
       1       0        0        1      removed
       2       0        0        2      removed
       3       8       68        3      active sync

After this, a number of errors logged in dmesg, and after some time system
becomes unresponsible via network or attached keyboard/monitor console.

kern.log excerpt for a period from clean system with functioning RAID, through
devices removal and up to system reset after 'freezing' is attached.

And here is the question, does anyone know reason for this behaviour, does there
any bug report exist (I didn't found one) or maybe someone may suggest any way
to deal with issues like this one.

I will appreciate any input.

Best regards,

Aleh Suprunovich 

a.suprunovich@sam-solutions.com



--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="kern.log"

Jun  6 13:33:19 BizNAS-223-322 kernel: [ 4866.322167] md: md2: resync done.
Jun  6 13:33:20 BizNAS-223-322 kernel: [ 4867.060910] RAID10 conf printout:
Jun  6 13:33:20 BizNAS-223-322 kernel: [ 4867.060920]  --- wd:4 rd:4
Jun  6 13:33:20 BizNAS-223-322 kernel: [ 4867.060928]  disk 0, wo:0, o:1, dev:sda4
Jun  6 13:33:20 BizNAS-223-322 kernel: [ 4867.060936]  disk 1, wo:0, o:1, dev:sdc4
Jun  6 13:33:20 BizNAS-223-322 kernel: [ 4867.060943]  disk 2, wo:0, o:1, dev:sdd4
Jun  6 13:33:20 BizNAS-223-322 kernel: [ 4867.060951]  disk 3, wo:0, o:1, dev:sde4
Jun  6 13:49:24 BizNAS-223-322 kernel: [ 5831.942732] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
Jun  6 13:49:24 BizNAS-223-322 kernel: [ 5831.947098] ata4: irq_stat 0x00400040, connection status changed
Jun  6 13:49:25 BizNAS-223-322 kernel: [ 5831.952246] ata4: SError: { PHYRdyChg DevExch }
Jun  6 13:49:25 BizNAS-223-322 kernel: [ 5831.956892] ata4: hard resetting link
Jun  6 13:49:25 BizNAS-223-322 kernel: [ 5832.684052] ata4: SATA link down (SStatus 0 SControl 300)
Jun  6 13:49:30 BizNAS-223-322 kernel: [ 5837.684044] ata4: hard resetting link
Jun  6 13:49:31 BizNAS-223-322 kernel: [ 5838.004047] ata4: SATA link down (SStatus 0 SControl 300)
Jun  6 13:49:31 BizNAS-223-322 kernel: [ 5838.007443] ata4: limiting SATA link speed to 1.5 Gbps
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.004059] ata4: hard resetting link
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.324047] ata4: SATA link down (SStatus 0 SControl 310)
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.327547] ata4.00: disabled
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.331064] ata4: EH complete
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.332033] sd 3:0:0:0: rejecting I/O to offline device
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.332041] sd 3:0:0:0: [sdd] killing request
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.332072] sd 3:0:0:0: rejecting I/O to offline device
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.332083] md: super_written gets error=-5, uptodate=0
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.332093] md/raid1:md0: Disk failure on sdd2, disabling device.
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.332097] md/raid1:md0: Operation continuing on 3 devices.
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.354810] ata4.00: detaching (SCSI 3:0:0:0)
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.362926] sd 3:0:0:0: [sdd] Synchronizing SCSI cache
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.367365] sd 3:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.370705] sd 3:0:0:0: [sdd] Stopping disk
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.373964] sd 3:0:0:0: [sdd] START_STOP FAILED
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.377139] RAID1 conf printout:
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.377150]  --- wd:3 rd:4
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.377161]  disk 0, wo:0, o:1, dev:sda2
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.377169]  disk 1, wo:1, o:0, dev:sdd2
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.377177]  disk 2, wo:0, o:1, dev:sde2
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.377185]  disk 3, wo:0, o:1, dev:sdc2
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.377194] sd 3:0:0:0: [sdd]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.400090] RAID1 conf printout:
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.400100]  --- wd:3 rd:4
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.400109]  disk 0, wo:0, o:1, dev:sda2
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.400117]  disk 2, wo:0, o:1, dev:sde2
Jun  6 13:49:36 BizNAS-223-322 kernel: [ 5843.400125]  disk 3, wo:0, o:1, dev:sdc2
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.049776] md: super_written gets error=-19, uptodate=0
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.052012] md/raid1:md1: Disk failure on sdd3, disabling device.
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.052012] md/raid1:md1: Operation continuing on 3 devices.
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.102911] RAID1 conf printout:
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.102918]  --- wd:3 rd:4
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.102924]  disk 0, wo:0, o:1, dev:sda3
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.102929]  disk 1, wo:1, o:0, dev:sdd3
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.102934]  disk 2, wo:0, o:1, dev:sde3
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.102939]  disk 3, wo:0, o:1, dev:sdc3
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.103002] RAID1 conf printout:
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.103006]  --- wd:3 rd:4
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.103011]  disk 0, wo:0, o:1, dev:sda3
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.103016]  disk 2, wo:0, o:1, dev:sde3
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.103021]  disk 3, wo:0, o:1, dev:sdc3
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.125531] md: super_written gets error=-19, uptodate=0
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.128521] md/raid10:md2: Disk failure on sdd4, disabling device.
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.128521] md/raid10:md2: Operation continuing on 3 devices.
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.166333] RAID10 conf printout:
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.166343]  --- wd:3 rd:4
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.166354]  disk 0, wo:0, o:1, dev:sda4
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.166362]  disk 1, wo:0, o:1, dev:sdc4
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.166369]  disk 2, wo:1, o:0, dev:sdd4
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.166378]  disk 3, wo:0, o:1, dev:sde4
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.188186] RAID10 conf printout:
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.188195]  --- wd:3 rd:4
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.188204]  disk 0, wo:0, o:1, dev:sda4
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.188211]  disk 1, wo:0, o:1, dev:sdc4
Jun  6 13:49:50 BizNAS-223-322 kernel: [ 5857.188218]  disk 3, wo:0, o:1, dev:sde4
Jun  6 13:50:12 BizNAS-223-322 kernel: [ 5879.304646] ata3: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
Jun  6 13:50:12 BizNAS-223-322 kernel: [ 5879.307797] ata3: irq_stat 0x00400040, connection status changed
Jun  6 13:50:12 BizNAS-223-322 kernel: [ 5879.311019] ata3: SError: { PHYRdyChg DevExch }
Jun  6 13:50:12 BizNAS-223-322 kernel: [ 5879.314291] ata3: hard resetting link
Jun  6 13:50:13 BizNAS-223-322 kernel: [ 5880.040047] ata3: SATA link down (SStatus 0 SControl 300)
Jun  6 13:50:18 BizNAS-223-322 kernel: [ 5885.040040] ata3: hard resetting link
Jun  6 13:50:18 BizNAS-223-322 kernel: [ 5885.360050] ata3: SATA link down (SStatus 0 SControl 300)
Jun  6 13:50:18 BizNAS-223-322 kernel: [ 5885.363364] ata3: limiting SATA link speed to 1.5 Gbps
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.360055] ata3: hard resetting link
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.680052] ata3: SATA link down (SStatus 0 SControl 310)
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.683315] ata3.00: disabled
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.686571] ata3: EH complete
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.688032] sd 2:0:0:0: rejecting I/O to offline device
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.688040] sd 2:0:0:0: [sdc] killing request
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.688073] sd 2:0:0:0: rejecting I/O to offline device
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.688083] md: super_written gets error=-5, uptodate=0
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.688092] md/raid1:md0: Disk failure on sdc2, disabling device.
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.688094] md/raid1:md0: Operation continuing on 2 devices.
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.708331] ata3.00: detaching (SCSI 2:0:0:0)
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.717218] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.720535] sd 2:0:0:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.723692] sd 2:0:0:0: [sdc] Stopping disk
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.726809] sd 2:0:0:0: [sdc] START_STOP FAILED
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.729902] RAID1 conf printout:
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.729919]  --- wd:2 rd:4
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.729927]  disk 0, wo:0, o:1, dev:sda2
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.729934]  disk 2, wo:0, o:1, dev:sde2
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.729942]  disk 3, wo:1, o:0, dev:sdc2
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.729960] sd 2:0:0:0: [sdc]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.748179] RAID1 conf printout:
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.748189]  --- wd:2 rd:4
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.748198]  disk 0, wo:0, o:1, dev:sda2
Jun  6 13:50:23 BizNAS-223-322 kernel: [ 5890.748206]  disk 2, wo:0, o:1, dev:sde2
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.256650] md: super_written gets error=-19, uptodate=0
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.260027] md/raid10:md2: Disk failure on sdc4, disabling device.
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.260027] md/raid10:md2: Operation continuing on 2 devices.
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.314956] RAID10 conf printout:
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.314966]  --- wd:2 rd:4
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.314976]  disk 0, wo:0, o:1, dev:sda4
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.314983]  disk 1, wo:1, o:0, dev:sdc4
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.314990]  disk 3, wo:0, o:1, dev:sde4
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.336116] RAID10 conf printout:
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.336128]  --- wd:2 rd:4
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.336137]  disk 0, wo:0, o:1, dev:sda4
Jun  6 13:50:25 BizNAS-223-322 kernel: [ 5892.336145]  disk 3, wo:0, o:1, dev:sde4
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.348732] md: super_written gets error=-19, uptodate=0
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.352018] md/raid1:md1: Disk failure on sdc3, disabling device.
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.352018] md/raid1:md1: Operation continuing on 2 devices.
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.400484] RAID1 conf printout:
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.400493]  --- wd:2 rd:4
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.400503]  disk 0, wo:0, o:1, dev:sda3
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.400510]  disk 2, wo:0, o:1, dev:sde3
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.400517]  disk 3, wo:1, o:0, dev:sdc3
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.424077] RAID1 conf printout:
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.424089]  --- wd:2 rd:4
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.424097]  disk 0, wo:0, o:1, dev:sda3
Jun  6 13:50:37 BizNAS-223-322 kernel: [ 5904.424103]  disk 2, wo:0, o:1, dev:sde3
Jun  6 13:54:07 BizNAS-223-322 kernel: [ 6114.740002] ata2: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
Jun  6 13:54:07 BizNAS-223-322 kernel: [ 6114.743299] ata2: irq_stat 0x00400040, connection status changed
Jun  6 13:54:07 BizNAS-223-322 kernel: [ 6114.746587] ata2: SError: { PHYRdyChg DevExch }
Jun  6 13:54:07 BizNAS-223-322 kernel: [ 6114.749950] ata2: hard resetting link
Jun  6 13:54:08 BizNAS-223-322 kernel: [ 6115.476080] ata2: SATA link down (SStatus 0 SControl 300)
Jun  6 13:54:13 BizNAS-223-322 kernel: [ 6120.480103] ata2: hard resetting link
Jun  6 13:54:13 BizNAS-223-322 kernel: [ 6120.800044] ata2: SATA link down (SStatus 0 SControl 300)
Jun  6 13:54:13 BizNAS-223-322 kernel: [ 6120.803269] ata2: limiting SATA link speed to 1.5 Gbps
Jun  6 13:54:18 BizNAS-223-322 kernel: [ 6125.800131] ata2: hard resetting link
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.124058] ata2: SATA link down (SStatus 0 SControl 310)
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.128236] ata2.00: disabled
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.132729] ata2: EH complete
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.136105] sd 1:0:0:0: rejecting I/O to offline device
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.136124] sd 1:0:0:0: [sde] killing request
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.136169] sd 1:0:0:0: rejecting I/O to offline device
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.136182] md: super_written gets error=-5, uptodate=0
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.136192] md/raid1:md0: Disk failure on sde2, disabling device.
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.136196] md/raid1:md0: Operation continuing on 1 devices.
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.160853] ata2.00: detaching (SCSI 1:0:0:0)
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.170179] sd 1:0:0:0: [sde] Synchronizing SCSI cache
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.174652] sd 1:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.179035] sd 1:0:0:0: [sde] Stopping disk
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.183813] sd 1:0:0:0: [sde] START_STOP FAILED
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.185472] RAID1 conf printout:
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.185479]  --- wd:1 rd:4
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.185487]  disk 0, wo:0, o:1, dev:sda2
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.185494]  disk 2, wo:1, o:0, dev:sde2
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.188163] sd 1:0:0:0: [sde]  Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.208080] RAID1 conf printout:
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.208090]  --- wd:1 rd:4
Jun  6 13:54:19 BizNAS-223-322 kernel: [ 6126.208099]  disk 0, wo:0, o:1, dev:sda2
Jun  6 13:54:20 BizNAS-223-322 kernel: [ 6127.168072] md: super_written gets error=-19, uptodate=0
--- skipped repeated messages ---
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.767316] md: super_written gets error=-19, uptodate=0
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.768690] md/raid1:md1: Disk failure on sde3, disabling device.
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.768690] md/raid1:md1: Operation continuing on 1 devices.
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.806367] RAID1 conf printout:
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.806376]  --- wd:1 rd:4
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.806384]  disk 0, wo:0, o:1, dev:sda3
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.806392]  disk 2, wo:1, o:0, dev:sde3
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.844032] RAID1 conf printout:
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.844039]  --- wd:1 rd:4
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.844045]  disk 0, wo:0, o:1, dev:sda3
Jun  6 13:54:32 BizNAS-223-322 kernel: [ 6139.858521] md: super_written gets error=-19, uptodate=0
--- skipped repeated messages ---
Jun  6 14:07:04 BizNAS-223-322 kernel: [ 6891.798607] md: super_written gets error=-19, uptodate=0
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.434151] md: unbind<sdc4>
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.492085] md: export_rdev(sdc4)
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.492840] md: super_written gets error=-19, uptodate=0
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.512836] md: unbind<sdd4>
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.556036] md: export_rdev(sdd4)
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.556905] md: super_written gets error=-19, uptodate=0
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.585558] md/raid10:md2: sde4: rescheduling sector 76242304
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.586547] md/raid10:md2: sde4: redirecting sector 76242304 to another mirror
--- skipped repeated messages ---
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.611488] md/raid10:md2: sde4: rescheduling sector 76242304
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.613415] md/raid10:md2: sde4: redirecting sector 76242304 to another mirror
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.615504] md/raid10:md2: sde4: Raid device exceeded read_error threshold [cur 21:max 20]
Jun  6 14:07:06 BizNAS-223-322 kernel: [ 6893.617632] md/raid10:md2: sde4: Failing raid device
--- skipped repeated messages ---
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.586422] md/raid10:md2: sde4: Raid device exceeded read_error threshold [cur 621:max 20]
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.590583] md/raid10:md2: sde4: Failing raid device
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.594521] handle_read_error: 610 callbacks suppressed
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.598609] md/raid10:md2: sde4: redirecting sector 76242304 to another mirror
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.602573] raid10_end_read_request: 611 callbacks suppressed
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.606471] md/raid10:md2: sde4: rescheduling sector 76242304
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.610397] md/raid10:md2: sde4: Raid device exceeded read_error threshold [cur 622:max 20]
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.614389] md/raid10:md2: sde4: Failing raid device
--- skipped repeated messages ---
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.735370] md/raid10:md2: sde4: Raid device exceeded read_error threshold [cur 630:max 20]
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.739168] md/raid10:md2: sde4: Failing raid device
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.742917] md/raid10:md2: sde4: redirecting sector 76242304 to another mirror
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.746855] md/raid10:md2: sde4: rescheduling sector 76242304
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.750551] md/raid10:md2: sde4: Raid device exceeded read_error threshold [cur 631:max 20]
Jun  6 14:07:11 BizNAS-223-322 kernel: [ 6898.754336] md/raid10:md2: sde4: Failing raid device
--- skipped repeated messages ---
Jun  6 14:07:16 BizNAS-223-322 kernel: [ 6903.619886] md/raid10:md2: sde4: Raid device exceeded read_error threshold [cur 1212:max 20]
Jun  6 14:07:16 BizNAS-223-322 kernel: [ 6903.624032] md/raid10:md2: sde4: Failing raid device
Jun  6 14:07:16 BizNAS-223-322 kernel: [ 6903.628060] handle_read_error: 581 callbacks suppressed
Jun  6 14:07:16 BizNAS-223-322 kernel: [ 6903.632068] md/raid10:md2: sde4: redirecting sector 76242304 to another mirror
Jun  6 14:07:16 BizNAS-223-322 kernel: [ 6903.636108] raid10_end_read_request: 581 callbacks suppressed
----
Skipping messages "Raid device exceeded read_error threshold" and "Failing raid
device" which are repeated up to the system reset.
----
Jun  6 14:07:29 BizNAS-223-322 kernel: [ 6916.179897] md/raid10:md2: sde4: Raid device exceeded read_error threshold [cur 2670:max 20]
Jun  6 14:07:29 BizNAS-223-322 kernel: [ 6916.183986] md/raid10:md2: sde4: Failing raid device
Jun  6 14:19:39 BizNAS-223-322 kernel: imklog 5.8.11, log source = /proc/kmsg started.
Jun  6 14:19:39 BizNAS-223-322 kernel: [    0.000000] Initializing cgroup subsys cpuset
Jun  6 14:19:39 BizNAS-223-322 kernel: [    0.000000] Initializing cgroup subsys cpu
Jun  6 14:19:39 BizNAS-223-322 kernel: [    0.000000] Linux version 3.2.0-4-amd64 (debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-15) ) #1 SMP Debian 3.2.41-2

--wRRV7LY7NUeQGEoC--
