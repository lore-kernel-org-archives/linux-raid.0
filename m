From: Pietro Abate <Pietro.Abate@pps.jussieu.fr>
Subject: Re: drivers/ata/libata-core.c:4732 ata_qc_issue+0x4c/0x2e0
Date: Tue, 9 Sep 2008 14:03:15 +0200
Message-ID: <20080909120315.GA31147@uranium.pps.jussieu.fr>
References: <20080909111643.GB6239@deprecation.cyrius.com> <48C661F8.5000709@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48C661F8.5000709@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Martin Michlmayr <tbm@cyrius.com>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 09, 2008 at 01:46:00PM +0200, Tejun Heo wrote:
> Martin Michlmayr wrote:
> > A Debian user reported the following oops (2.6.26, RAID1 + LVM,
> > running on an ARM platform, sata_mv):
> Can you please attach full log?

unfortunately I've rebooted the box and lost the logs :(
It it happens again, I'll make sure to keep the entire log.

this should be a useful context :

[42949380.710000] ata1.00: configured for UDMA/133
[42949381.230000] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[42949381.250000] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01112, max UDMA7
[42949381.250000] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[42949381.280000] ata2.00: configured for UDMA/133
[42949381.280000] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[42949381.290000] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[42949381.470000] Driver 'sd' needs updating - please use bus_type methods
[42949381.520000] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[42949381.520000] sd 0:0:0:0: [sda] Write Protect is off
[42949381.530000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[42949381.530000] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[42949381.560000] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[42949381.570000] sd 0:0:0:0: [sda] Write Protect is off
[42949381.570000] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[42949381.570000] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[42949381.580000]  sda: sda1
[42949381.600000] sd 0:0:0:0: [sda] Attached SCSI disk
[42949381.640000] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[42949381.650000] sd 1:0:0:0: [sdb] Write Protect is off
[42949381.660000] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[42949381.680000] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[42949381.690000] sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
[42949381.710000] sd 1:0:0:0: [sdb] Write Protect is off
[42949381.710000] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[42949381.710000] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[42949381.720000]  sdb: sdb1
[42949381.750000] sd 1:0:0:0: [sdb] Attached SCSI disk
[42949767.970000] warning: process `rdate' used the deprecated sysctl system call with 1.40.
[42949775.860000] Initializing USB Mass Storage driver...
[42949775.860000] usbcore: registered new interface driver usb-storage
[42949775.860000] USB Mass Storage support registered.
[42949809.460000] md: md0 stopped.
[42949809.510000] md: bind<sdb1>
[42949809.510000] md: bind<sda1>
[42949809.510000] md: md0: raid array is not clean -- starting background reconstruction
[42949809.590000] md: raid1 personality registered for level 1
[42949809.590000] raid1: raid set md0 active with 2 out of 2 mirrors
[42949809.620000] md: resync of RAID array md0
[42949809.620000] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[42949809.620000] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[42949809.620000] md: using 128k window, over a total of 488383936 blocks.
[42949811.110000] device-mapper: uevent: version 1.0.3
[42949811.140000] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[42949814.890000] NOHZ: local_softirq_pending 100

