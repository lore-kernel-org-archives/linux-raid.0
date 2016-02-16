From: Shaohua Li <shli@kernel.org>
Subject: Re: swiotlb buffer is full
Date: Tue, 16 Feb 2016 12:13:47 -0800
Message-ID: <20160216201347.GB13119@kernel.org>
References: <20160215122539.DC34B3811B2@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160215122539.DC34B3811B2@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 15, 2016 at 01:25:39PM +0100, Wolfgang Denk wrote:
> Hello,
> 
> first, I would like to apologize in advance if I should be off topic
> here.  Actually I'm not really sure which kernel component causes
> problems here, but as it gets triggered by a MD task I thought I start
> asking here...
> 
> 
> The problem is, that the system more or less reliably crashes with
> "swiotlb buffer is full" errors when a data-check on the RAID arrays
> is run.
> 
> The RAID configuration looks like this:
> 
> -> cat /proc/mdstat 
> Personalities : [raid1] [raid6] [raid5] [raid4] 
> md1 : active raid1 sdf3[2] sdg3[3]
>       970206800 blocks super 1.2 [2/2] [UU]
>       
> md0 : active raid1 sdf1[0] sdg1[1]
>       262132 blocks super 1.0 [2/2] [UU]
>       
> md3 : active raid1 sdc[1] sdb[0]
>       117219728 blocks super 1.2 [2/2] [UU]
>       
> md2 : active raid6 sdk[5] sdi[3] sdj[4] sdh[2] sde[1] sdd[0]
>       3907049792 blocks super 1.2 level 6, 16k chunk, algorithm 2 [6/6] [UUUUUU]
>       
> unused devices: <none>
> 
> 
> What happens is always the same: a cron job will trigger a data-check
> on the raid arrays, and then it goes like this:
> 
> Jan  3 04:00:01 castor kernel: md: data-check of RAID array md1
> Jan  3 04:00:01 castor kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Jan  3 04:00:01 castor kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
> Jan  3 04:00:01 castor kernel: md: using 128k window, over a total of 970206800k.
> Jan  3 04:00:08 castor kernel: md: delaying data-check of md0 until md1 has finished (they share one or more physical units)
> Jan  3 04:00:14 castor kernel: md: data-check of RAID array md3
> Jan  3 04:00:14 castor kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Jan  3 04:00:14 castor kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
> Jan  3 04:00:14 castor kernel: md: using 128k window, over a total of 117219728k.
> Jan  3 04:00:20 castor kernel: md: data-check of RAID array md2
> Jan  3 04:00:20 castor kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> Jan  3 04:00:20 castor kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
> Jan  3 04:00:20 castor kernel: md: using 128k window, over a total of 976762448k.
> Jan  3 04:23:22 castor kernel: md: md3: data-check done.
> Jan  3 04:23:22 castor kernel: md: delaying data-check of md0 until md1 has finished (they share one or more physical units)
> Jan  3 04:23:22 castor kernel: md: delaying data-check of md0 until md1 has finished (they share one or more physical units)
> Jan  3 04:23:22 castor kernel: md: delaying data-check of md0 until md1 has finished (they share one or more physical units)
> Jan  3 04:57:45 castor kernel: sata_via 0000:03:06.0: swiotlb buffer is full (sz: 16384 bytes)
> Jan  3 04:57:45 castor kernel: DMA: Out of SW-IOMMU space for 16384 bytes at device 0000:03:06.0
> Jan  3 04:57:45 castor kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> Jan  3 04:57:45 castor kernel: ata4.00: failed command: READ DMA EXT
> Jan  3 04:57:45 castor kernel: ata4.00: cmd 25/00:80:80:df:42/00:05:0d:00:00/e0 tag 0 dma 720896 in#012         res 50/00:00:7f:df:42/00:00:0d:00:00/e0 Emask 0x40 (internal error)
> Jan  3 04:57:45 castor kernel: ata4.00: status: { DRDY }
> Jan  3 04:57:45 castor kernel: ata4.00: configured for UDMA/133
> Jan  3 04:57:45 castor kernel: ata4: EH complete
> Jan  3 04:58:06 castor kernel: sata_nv 0000:00:05.0: swiotlb buffer is full (sz: 4096 bytes)
> Jan  3 04:58:06 castor kernel: DMA: Out of SW-IOMMU space for 4096 bytes at device 0000:00:05.0
> Jan  3 04:58:06 castor kernel: sata_via 0000:03:06.0: swiotlb buffer is full (sz: 16384 bytes)
> Jan  3 04:58:06 castor kernel: DMA: Out of SW-IOMMU space for 16384 bytes at device 0000:03:06.0
> Jan  3 04:58:06 castor kernel: ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> Jan  3 04:58:06 castor kernel: ata4.00: failed command: READ DMA EXT
> Jan  3 04:58:06 castor kernel: ata4.00: cmd 25/00:80:00:d4:5c/00:06:0d:00:00/e0 tag 0 dma 851968 in#012         res 50/00:00:ff:d3:5c/00:00:0d:00:00/e0 Emask 0x40 (internal error)
> Jan  3 04:58:06 castor kernel: ata4.00: status: { DRDY }
> Jan  3 04:58:06 castor kernel: ata4.00: configured for UDMA/133
> Jan  3 04:58:06 castor kernel: ata15: EH in SWNCQ mode,QC:qc_active 0x10000 sactive 0x10000
> Jan  3 04:58:06 castor kernel: ata15: SWNCQ:qc_active 0x0 defer_bits 0x0 last_issue_tag 0x11#012  dhfis 0x0 dmafis 0x0 sdbfis 0x0
> Jan  3 04:58:06 castor kernel: ata15: ATA_REG 0x40 ERR_REG 0x0
> Jan  3 04:58:06 castor kernel: ata15: tag : dhfis dmafis sdbfis sactive
> Jan  3 04:58:06 castor kernel: ata15.00: exception Emask 0x0 SAct 0x10000 SErr 0x0 action 0x6
> Jan  3 04:58:06 castor kernel: ata15.00: failed command: READ FPDMA QUEUED
> Jan  3 04:58:06 castor kernel: ata15.00: cmd 60/00:80:f0:16:85/04:00:1d:00:00/40 tag 16 ncq 524288 in#012         res 40/00:20:f0:e6:84/00:00:1d:00:00/40 Emask 0x40 (internal error)
> Jan  3 04:58:06 castor kernel: ata15.00: status: { DRDY }
> Jan  3 04:58:06 castor kernel: ata15: hard resetting link
> Jan  3 04:58:06 castor kernel: ata15: nv: skipping hardreset on occupied port
> Jan  3 04:58:06 castor kernel: ata4: EH complete
> Jan  3 04:58:06 castor kernel: ata15: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Jan  3 04:58:06 castor kernel: ata15.00: configured for UDMA/133
> Jan  3 04:58:06 castor kernel: ata15: EH complete
> Jan  3 05:02:49 castor kernel: sata_nv 0000:00:05.0: swiotlb buffer is full (sz: 4096 bytes)
> Jan  3 05:02:50 castor kernel: DMA: Out of SW-IOMMU space for 4096 bytes at device 0000:00:05.0
> ...
> 
> From here the system is basically dead:  it will report I/O errors on
> the root file system, remount root read-only, and drop /dev/sdf3 from
> RAID array /dev/md1.  I have to reboot - the root file system is
> corrupted so I have to run fsck manually to repair it, and I have to
> re-add /dev/sdf3 to /dev/md1 and resync.
> 
> This is _exactly_ the same in all cases.  For reference, full kernel
> logs of 5 such crashes are available at [1] 
> 
> [1] https://www.amazon.com/clouddrive/share/qZjRneB0tA5TXrNqBQVzyhN6Hy8HzxpLHCKHIhfzYyk
> 
> 
> The system has been working fine for years, up to and including
> Fedora 22.  The crashes started happening after I upgraded to Fedora
> 23 over Xmas.  I've installed all available updates sinde, with no
> avails.  Current configuration looks like this:
> 
> kernel-4.3.4-300.fc23.x86_64
> mdadm-3.3.4-2.fc23.x86_64
> 
> 
> As the first error reported is always "swiotlb buffer is full", I
> tried to add "swiotlb=32768" to the kernel command line, but this
> does not appear to make any effect, as I still see in the kernel
> messages:
> 
> [    1.518575] software IO TLB [mem 0xdbff0000-0xdfff0000] (64MB) mapped at [ffff8800dbff0000-ffff8800dffeffff]
> 
> [I think the software IOMMU implementation is used because this is a
> Dual-Core AMD Opteron Processor 2216 on a Supermicro H8DM8-2 main
> board; I believe this does not support an IOMMU ?]
> 
> 
> Has anybody any ideas what might cause such an effect?
> 
> I think it is interesting that always the same RAID array gets
> kicked, and always the same disk.  I cannot see any hardware
> problems, and a preventive replacement of the disk drive did not fix
> the problem.

this doesn't like a md problem. Probably a dma address leak in the driver. To
verify this, you can do some IO against the raw disk (sdf/sdg) and check if you
see the 'swiotlb buffer is full' issue. Did you really need iommu, eg if
iommu=off works?

Thanks,
Shaohua
