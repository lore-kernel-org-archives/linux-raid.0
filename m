From: Brad Campbell <brad@wasp.net.au>
Subject: 2.6.11-rc4 md loops on missing drives
Date: Tue, 15 Feb 2005 17:38:33 +0400
Message-ID: <4211FB59.7090104@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

G'day all,

I have just finished my shiny new RAID-6 box. 15 x 250GB SATA drives.
While doing some failure testing (inadvertently due to libata SMART causing command errors) I 
dropped 3 drives out of the array in sequence.
md coped with the first two (as it should), but after the third one dropped out I got the below 
errors spinning continuously in my syslog until I managed to stop the array with mdadm --stop /dev/md0

I'm not really sure how it's supposed to cope with losing more disks than planned, but filling the 
syslog with nastiness is not very polite.

This box takes _ages_ (like between 6 an 10 hours) to rebuild the array, but I'm willing to run some 
tests if anyone has particular RAID-6 stuff they want tested before I put it into service.
I do plan on a couple of days burn-in testing before I really load it up anyway.

The last disk is missing at the moment as I'm short one disk due to a Maxtor dropping its bundle 
after about 5000 hours.

I'm using todays BK kernel plus the libata and libata-dev trees. The drives are all on Promise 
SATA150TX4 controllers.


Feb 15 17:58:28 storage1 kernel: .<6>md: syncing RAID array md0
Feb 15 17:58:28 storage1 kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Feb 15 17:58:28 storage1 kernel: md: using maximum available idle IO bandwith (but not more than 
200000 KB/sec) for reconstruction.
Feb 15 17:58:28 storage1 kernel: md: using 128k window, over a total of 245117312 blocks.
Feb 15 17:58:28 storage1 kernel: md: md0: sync done.
Feb 15 17:58:28 storage1 kernel: .<6>md: syncing RAID array md0
Feb 15 17:58:28 storage1 kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Feb 15 17:58:28 storage1 kernel: md: using maximum available idle IO bandwith (but not more than 
200000 KB/sec) for reconstruction.
Feb 15 17:58:28 storage1 kernel: md: using 128k window, over a total of 245117312 blocks.
Feb 15 17:58:28 storage1 kernel: md: md0: sync done.
Feb 15 17:58:28 storage1 kernel: .<6>md: syncing RAID array md0
Feb 15 17:58:28 storage1 kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Feb 15 17:58:28 storage1 kernel: md: using maximum available idle IO bandwith (but not more than 
200000 KB/sec) for reconstruction.
Feb 15 17:58:28 storage1 kernel: md: using 128k window, over a total of 245117312 blocks.
Feb 15 17:58:28 storage1 kernel: md: md0: sync done.
Feb 15 17:58:28 storage1 kernel: .<6>md: syncing RAID array md0
Feb 15 17:58:28 storage1 kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Feb 15 17:58:28 storage1 kernel: md: using maximum available idle IO bandwith (but not more than 
200000 KB/sec) for reconstruction.
Feb 15 17:58:28 storage1 kernel: md: using 128k window, over a total of 245117312 blocks.
Feb 15 17:58:28 storage1 kernel: md: md0: sync done.
Feb 15 17:58:28 storage1 kernel: .<6>md: syncing RAID array md0
Feb 15 17:58:28 storage1 kernel: md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Feb 15 17:58:28 storage1 kernel: md: using maximum available idle IO bandwith (but not more than 
200000 KB/sec) for reconstruction.
<to infinity and beyond>

Existing raid config below. Fail any additional 2 drives due to IO errors to cause this issue.

storage1:/home/brad# mdadm --detail /dev/md0
/dev/md0:
         Version : 00.90.01
   Creation Time : Tue Feb 15 22:00:16 2005
      Raid Level : raid6
      Array Size : 3186525056 (3038.91 GiB 3263.00 GB)
     Device Size : 245117312 (233.76 GiB 251.00 GB)
    Raid Devices : 15
   Total Devices : 15
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Feb 15 17:17:36 2005
           State : clean, degraded, resyncing
  Active Devices : 14
Working Devices : 14
  Failed Devices : 1
   Spare Devices : 0

      Chunk Size : 128K

  Rebuild Status : 0% complete

            UUID : 11217f79:ac676966:279f2816:f5678084
          Events : 0.40101

     Number   Major   Minor   RaidDevice State
        0       8        0        0      active sync   /dev/devfs/scsi/host0/bus0/target0/lun0/disc
        1       8       16        1      active sync   /dev/devfs/scsi/host1/bus0/target0/lun0/disc
        2       8       32        2      active sync   /dev/devfs/scsi/host2/bus0/target0/lun0/disc
        3       8       48        3      active sync   /dev/devfs/scsi/host3/bus0/target0/lun0/disc
        4       8       64        4      active sync   /dev/devfs/scsi/host4/bus0/target0/lun0/disc
        5       8       80        5      active sync   /dev/devfs/scsi/host5/bus0/target0/lun0/disc
        6       8       96        6      active sync   /dev/devfs/scsi/host6/bus0/target0/lun0/disc
        7       8      112        7      active sync   /dev/devfs/scsi/host7/bus0/target0/lun0/disc
        8       8      128        8      active sync   /dev/devfs/scsi/host8/bus0/target0/lun0/disc
        9       8      144        9      active sync   /dev/devfs/scsi/host9/bus0/target0/lun0/disc
       10       8      160       10      active sync   /dev/devfs/scsi/host10/bus0/target0/lun0/disc
       11       8      176       11      active sync   /dev/devfs/scsi/host11/bus0/target0/lun0/disc
       12       8      192       12      active sync   /dev/devfs/scsi/host12/bus0/target0/lun0/disc
       13       8      208       13      active sync   /dev/devfs/scsi/host13/bus0/target0/lun0/disc
       14       0        0        -      removed

       15       8      224        -      faulty   /dev/devfs/scsi/host14/bus0/target0/lun0/disc

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
