From: drtebi@drtebi.com
Subject: Re: RAID1 always resyncs at boot???
Date: Thu, 27 Nov 2003 20:33:07 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <hp1on7.90c5en@mail.drtebi.com>
References: <hp0nmt.3pm23q@mail.drtebi.com> <16326.34106.78894.57151@notabene.cse.unsw.edu.au> <hp1alh.rftuxt@mail.drtebi.com> <16326.36888.900928.183987@notabene.cse.unsw.edu.au>
Reply-To: drtebi@drtebi.com
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16326.36888.900928.183987@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well,
I thought it was fixed, but I suppose I was wrong... 

OK, I admit I was a bit brutal, but anyway.
The problem is that I have power outages here once in a while, it's something
with the wiring in this appartment (yes, I am running this server at home,
have an UPS, but it only lasts 40 min.).
 
So I pulled the plug of the server to give it a test, to see if it comes back
up fine and will reconstruct the array right.

Everything comes back up fine, the RAID array starts reconstructing. But after
an hour or so I find this:

/proc/mdstat:
Nov 28 04:41:56 [kernel] md: md_do_sync() got signal ... exiting
Nov 28 04:41:56 [kernel] raid1: mirror resync was not fully finished,
restarting next time.

.
/bus1/target0/lun0/part1


in my log:
Nov 28 04:41:44 [kernel] hda: dma_intr: status=0x51 { DriveReady SeekComplete
Error }
Nov 28 04:41:44 [kernel] md: (skipping faulty
ide/host0/bus0/target0/lun0/part1 )
Nov 28 04:41:45 [kernel] hda: dma_intr: status=0x51 { DriveReady SeekComplete
Error }
                - Last output repeated 8 times -
Nov 28 04:41:56 [kernel] md: md_do_sync() got signal ... exiting
Nov 28 04:41:56 [kernel] raid1: mirror resync was not fully finished,
restarting next time.

Does this mean one of the drives is bad?

Here is some more info from mdadm:
bully@drtebi: mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Thu Nov 27 01:46:27 2003
     Raid Level : raid1
     Array Size : 120053632 (114.49 GiB 122.93 GB)
    Device Size : 120053632 (114.49 GiB 122.93 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Nov 28 04:41:44 2003
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       3        1        0      faulty  
/dev/ide/host0/bus0/target0/lun0/part1
       1      22        1        1      active sync  
/dev/ide/host0/bus1/target0/lun0/part1
           UUID : 96c32ab9:7f492b81:623580da:29d8a727
         Events : 0.16

------------
bully@drtebi: mdadm --examine /dev/hda1
/dev/hda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 96c32ab9:7f492b81:623580da:29d8a727
  Creation Time : Thu Nov 27 01:46:27 2003
     Raid Level : raid1
    Device Size : 120053632 (114.49 GiB 122.93 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Fri Nov 28 04:32:17 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d1fbb8ef - correct
         Events : 0.15


      Number   Major   Minor   RaidDevice State
this     0       3        1        0      active sync  
/dev/ide/host0/bus0/target0/lun0/part1
   0     0       3        1        0      active sync  
/dev/ide/host0/bus0/target0/lun0/part1
   1     1      22        1        1      active sync  
/dev/ide/host0/bus1/target0/lun0/part1

bully@drtebi: mdadm --examine /dev/hda1
/dev/hda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 96c32ab9:7f492b81:623580da:29d8a727
  Creation Time : Thu Nov 27 01:46:27 2003
     Raid Level : raid1
    Device Size : 120053632 (114.49 GiB 122.93 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Fri Nov 28 04:32:17 2003
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d1fbb8ef - correct
         Events : 0.15


      Number   Major   Minor   RaidDevice State
this     0       3        1        0      active sync  
/dev/ide/host0/bus0/target0/lun0/part1
   0     0       3        1        0      active sync  
/dev/ide/host0/bus0/target0/lun0/part1
   1     1      22        1        1      active sync  
/dev/ide/host0/bus1/target0/lun0/part1

-------------
bully@drtebi: mdadm --query /dev/md0
/dev/md0: 114.49GiB raid1 2 devices, 0 spares. Use mdadm --detail for more
detail.
/dev/md0: No md super block found, not an md component.

The last message is weird... no md super block?

Thanks,
DrTebi

P.S.: I don't really like IDE drives :(


