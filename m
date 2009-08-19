From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Hot-swapping: what's that? (and 3ware 9650SE)
Date: Wed, 19 Aug 2009 03:31:16 +0100
Message-ID: <4A8B63F4.7090108@anonymous.org.uk>
References: <4A8AFC5F.3070108@shiftmail.org> <c268e4660908181549k4ce5082bm33862349f220e848@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660908181549k4ce5082bm33862349f220e848@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18/08/2009 23:49, Drew wrote:
>> One question remains: ok but what is hot-swap anyway?
[...]
> In the context of RAID, "hot swap" typically refers to any system
> which allows drives to be changed out on a live system without having
> to interact with the operating system beforehand. IBM's ServeRAID
> controllers are a good example. Replacing a failed drive is as simple
> as walking over to the server, pulling out the drive identified as
> defective, and inserting a replacement. The raid controller recognizes
> the replacement and begins to integrate it back into the array within
> 30secs.

By the above definition, md RAID doesn't do hot swap. My hardware does 
hot swap (ICH10R SATA, SuperMicro drive cage), and I just tried yanking 
one of my drives:

Aug 19 02:21:56 beast kernel: ata3: exception Emask 0x50 SAct 0x0 SErr 
0x4090800 action 0xe frozen
Aug 19 02:21:56 beast kernel: ata3: irq_stat 0x00400040, connection 
status changed
Aug 19 02:21:56 beast kernel: ata3: SError: { HostInt PHYRdyChg 10B8B 
DevExch }
Aug 19 02:21:56 beast kernel: ata3: hard resetting link
Aug 19 02:21:57 beast kernel: ata3: SATA link down (SStatus 0 SControl 300)
Aug 19 02:21:57 beast kernel: ata3: failed to recover some devices, 
retrying in 5 secs
Aug 19 02:22:02 beast kernel: ata3: hard resetting link
Aug 19 02:22:02 beast kernel: ata3: SATA link down (SStatus 0 SControl 300)
Aug 19 02:22:02 beast kernel: ata3: failed to recover some devices, 
retrying in 5 secs
Aug 19 02:22:07 beast kernel: ata3: hard resetting link
Aug 19 02:22:07 beast kernel: ata3: SATA link down (SStatus 0 SControl 300)
Aug 19 02:22:07 beast kernel: ata3.00: disabled
Aug 19 02:22:07 beast kernel: sd 2:0:0:0: rejecting I/O to offline device
Aug 19 02:22:08 beast last message repeated 2 times
Aug 19 02:22:08 beast kernel: raid5: Disk failure on sda2, disabling 
device. Operation continuing on 2 devices
Aug 19 02:22:08 beast kernel: RAID5 conf printout:
Aug 19 02:22:08 beast kernel:  --- rd:3 wd:2 fd:1
Aug 19 02:22:08 beast kernel:  disk 0, o:0, dev:sda2
Aug 19 02:22:08 beast kernel:  disk 1, o:1, dev:sdb2
Aug 19 02:22:08 beast kernel:  disk 2, o:1, dev:sdc2
Aug 19 02:22:08 beast kernel: RAID5 conf printout:
Aug 19 02:22:08 beast kernel:  --- rd:3 wd:2 fd:1
Aug 19 02:22:08 beast kernel:  disk 1, o:1, dev:sdb2
Aug 19 02:22:08 beast kernel:  disk 2, o:1, dev:sdc2
Aug 19 02:22:08 beast kernel: ata3: EH complete
Aug 19 02:22:08 beast kernel: ata3.00: detaching (SCSI 2:0:0:0)

So that all went well. Then I plugged it in again:

Aug 19 02:22:48 beast kernel: ata3: exception Emask 0x10 SAct 0x0 SErr 
0x4040000 action 0xe frozen
Aug 19 02:22:48 beast kernel: ata3: irq_stat 0x00000040, connection 
status changed
Aug 19 02:22:48 beast kernel: ata3: SError: { CommWake DevExch }
Aug 19 02:22:48 beast kernel: ata3: hard resetting link
Aug 19 02:22:55 beast kernel: ata3: link is slow to respond, please be 
patient (ready=0)
Aug 19 02:22:58 beast kernel: ata3: softreset failed (device not ready)
Aug 19 02:22:58 beast kernel: ata3: hard resetting link
Aug 19 02:23:00 beast kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 
SControl 300)
Aug 19 02:23:00 beast kernel: ata3.00: ATA-7: SAMSUNG HD103UJ, 1AA01112, 
max UDMA7
Aug 19 02:23:00 beast kernel: ata3.00: 1953525168 sectors, multi 0: 
LBA48 NCQ (depth 31/32)
Aug 19 02:23:00 beast kernel: ata3.00: configured for UDMA/133
Aug 19 02:23:00 beast kernel: ata3: EH complete
Aug 19 02:23:00 beast kernel:   Vendor: ATA       Model: SAMSUNG HD103UJ 
   Rev: 1AA0
Aug 19 02:23:00 beast kernel:   Type:   Direct-Access 
    ANSI SCSI revision: 05
Aug 19 02:23:00 beast kernel: SCSI device sdd: 1953525168 512-byte hdwr 
sectors (1000205 MB)
Aug 19 02:23:00 beast kernel: sdd: Write Protect is off
Aug 19 02:23:00 beast kernel: SCSI device sdd: drive cache: write back
Aug 19 02:23:00 beast kernel: SCSI device sdd: 1953525168 512-byte hdwr 
sectors (1000205 MB)
Aug 19 02:23:00 beast kernel: sdd: Write Protect is off
Aug 19 02:23:00 beast kernel: SCSI device sdd: drive cache: write back
Aug 19 02:23:00 beast kernel:  sdd: sdd1 sdd2
Aug 19 02:23:00 beast kernel: sd 2:0:0:0: Attached scsi disk sdd
Aug 19 02:23:00 beast kernel: sd 2:0:0:0: Attached scsi generic sg1 type 0

I waited for a bit to see if anything else would happen automatically. 
It didn't, so I manually re-added sdd2 to md1:

Aug 19 02:24:05 beast kernel: md: bind<sdd2>
Aug 19 02:24:05 beast kernel: RAID5 conf printout:
Aug 19 02:24:05 beast kernel:  --- rd:3 wd:2 fd:1
Aug 19 02:24:05 beast kernel:  disk 0, o:1, dev:sdd2
Aug 19 02:24:05 beast kernel:  disk 1, o:1, dev:sdb2
Aug 19 02:24:05 beast kernel:  disk 2, o:1, dev:sdc2
Aug 19 02:24:05 beast kernel: md: syncing RAID array md1
Aug 19 02:24:05 beast kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Aug 19 02:24:05 beast kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Aug 19 02:24:05 beast kernel: md: using 128k window, over a total of 
976655360 blocks.
Aug 19 02:24:09 beast kernel: md: md1: sync done.
Aug 19 02:24:10 beast kernel: RAID5 conf printout:
Aug 19 02:24:10 beast kernel:  --- rd:3 wd:3 fd:0
Aug 19 02:24:10 beast kernel:  disk 0, o:1, dev:sdd2
Aug 19 02:24:10 beast kernel:  disk 1, o:1, dev:sdb2
Aug 19 02:24:10 beast kernel:  disk 2, o:1, dev:sdc2

Then I realised that md0 hadn't noticed sda1 was missing. I re-added 
sdd1 anyway; it said it was adding it, not re-adding it, and this is 
what was logged:

Aug 19 02:24:12 beast kernel: md: export_rdev(sdd1)
Aug 19 02:24:12 beast kernel: md: bind<sdd1>
Aug 19 02:24:29 beast kernel: scsi 2:0:0:0: rejecting I/O to dead device
Aug 19 02:24:29 beast kernel: raid1: sda1: rescheduling sector 208512
Aug 19 02:24:29 beast kernel: raid1: sda1: rescheduling sector 208514
Aug 19 02:24:29 beast kernel: raid1: sda1: rescheduling sector 208516
Aug 19 02:24:29 beast kernel: raid1: sda1: rescheduling sector 208518
Aug 19 02:24:29 beast kernel: scsi 2:0:0:0: rejecting I/O to dead device
Aug 19 02:24:29 beast kernel: scsi 2:0:0:0: rejecting I/O to dead device
Aug 19 02:24:29 beast kernel: raid1: Disk failure on sda1, disabling device.
Aug 19 02:24:29 beast kernel:   Operation continuing on 2 devices
Aug 19 02:24:29 beast kernel: raid1: sdb1: redirecting sector 208512 to 
another mirror
Aug 19 02:24:29 beast kernel: raid1: sdb1: redirecting sector 208514 to 
another mirror
Aug 19 02:24:29 beast kernel: raid1: sdb1: redirecting sector 208516 to 
another mirror
Aug 19 02:24:29 beast kernel: raid1: sdb1: redirecting sector 208518 to 
another mirror
Aug 19 02:24:29 beast kernel: RAID1 conf printout:
Aug 19 02:24:29 beast kernel:  --- wd:2 rd:3
Aug 19 02:24:29 beast kernel:  disk 0, wo:1, o:0, dev:sda1
Aug 19 02:24:29 beast kernel:  disk 1, wo:0, o:1, dev:sdb1
Aug 19 02:24:29 beast kernel:  disk 2, wo:0, o:1, dev:sdc1
Aug 19 02:24:29 beast kernel: RAID1 conf printout:
Aug 19 02:24:29 beast kernel:  --- wd:2 rd:3
Aug 19 02:24:29 beast kernel:  disk 1, wo:0, o:1, dev:sdb1
Aug 19 02:24:29 beast kernel:  disk 2, wo:0, o:1, dev:sdc1
Aug 19 02:24:30 beast kernel: RAID1 conf printout:
Aug 19 02:24:30 beast kernel:  --- wd:2 rd:3
Aug 19 02:24:30 beast kernel:  disk 0, wo:1, o:1, dev:sdd1
Aug 19 02:24:30 beast kernel:  disk 1, wo:0, o:1, dev:sdb1
Aug 19 02:24:30 beast kernel:  disk 2, wo:0, o:1, dev:sdc1
Aug 19 02:24:30 beast kernel: md: syncing RAID array md0
Aug 19 02:24:30 beast kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Aug 19 02:24:30 beast kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Aug 19 02:24:30 beast kernel: md: using 128k window, over a total of 
104320 blocks.
Aug 19 02:24:32 beast kernel: md: md0: sync done.
Aug 19 02:24:32 beast kernel: RAID1 conf printout:
Aug 19 02:24:32 beast kernel:  --- wd:3 rd:3
Aug 19 02:24:32 beast kernel:  disk 0, wo:0, o:1, dev:sdd1
Aug 19 02:24:32 beast kernel:  disk 1, wo:0, o:1, dev:sdb1
Aug 19 02:24:32 beast kernel:  disk 2, wo:0, o:1, dev:sdc1

So that all worked perfectly. Now is there a tool out there I can use in 
conjunction with udev (for hotplugging) and md/mdadm to do this 
automatically (including recreating my partition table if it's a fresh 
disc)? I like IBM ServeRAID, and more to the point I would like to be 
able to have rebuilds begin as soon as the operator in the data centre 
has changed a dead drive.

I've just done a spot of Googling etc. and found scsirastools but it 
looks like it's a year since anything was done with it, it talks about 
kernel patches to make it work, it bundles mdadm 1.3.0 and its SRPM 
doesn't build on CentOS 5, so I'm not sure that's quite the thing!

Cheers,

John.
