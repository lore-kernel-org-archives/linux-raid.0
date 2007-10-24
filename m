From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Wed, 24 Oct 2007 16:01:09 -0400
Message-ID: <471FA485.6010705@tmr.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com> <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471F5542.3020504@amfes.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Daniel L. Miller" <dmiller@amfes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel L. Miller wrote:
> Daniel L. Miller wrote:
>> Richard Scobie wrote:
>>> Daniel L. Miller wrote:
>>>
>>>> And you didn't ask, but my mdadm.conf:
>>>> DEVICE partitions
>>>> ARRAY /dev/.static/dev/md0 level=raid10 num-devices=4 
>>>> UUID=9d94b17b:f5fac31a:577c252b:0d4c4b2a
>>>
>>> Try adding
>>>
>>> auto=part
>>>
>>> at the end of you mdadm.conf ARRAY line.
>> Thanks - will see what happens on my next reboot.
>>
> Current mdadm.conf:
> DEVICE partitions
> ARRAY /dev/.static/dev/md0 level=raid10 num-devices=4 
> UUID=9d94b17b:f5fac31a:577c252b:0d4c4b2a auto=part
>
> still have the problem where on boot one drive is not part of the 
> array.  Is there a log file I can check to find out WHY a drive is not 
> being added?  It's been a while since the reboot, but I did find some 
> entries in dmesg - I'm appending both the md lines and the physical 
> disk related lines.  The bottom shows one disk not being added (this 
> time is was sda) - and the disk that gets skipped on each boot seems 
> to be random - there's no consistent failure:

I suspect the base problem is that you are using whole disks instead of 
partitions, and the problem with the partition table below is probably 
an indication that you have something on that drive which looks like a 
partition table but isn't. That prevents the drive from being recognized 
as a whole drive. You're lucky, if the data looked enough like a 
partition table to be valid the o/s probably would have tried to do 
something with it.

I can't see any easy (or safe) backout on this, you have used the whole 
disk, so you can't just drop a drive, partition, and add the partition 
back in place of the drive. And if you have a failure and ever have to 
replace a drive, you will have to use a drive or partition at least as 
large as what you have. Hopefully someone will have a good idea how to 
gracefully transition to a safer setup, if random data ever looks like a 
valid partition table, evil may occur. And if you ever get this on two 
drives at once the system won't boot. Two time-bomb cases, and they're 
not mutually exclusive.

This may be the rare case where you really do need to specify the actual 
devices to get reliable operation.
>
> [...]
> md: raid10 personality registered for level 10
> [...]
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> [...]
> scsi0 : sata_nv
> scsi1 : sata_nv
> ata1: SATA max UDMA/133 cmd 0xffffc20001428480 ctl 0xffffc200014284a0 
> bmdma 0x0000000000011410 irq 23
> ata2: SATA max UDMA/133 cmd 0xffffc20001428580 ctl 0xffffc200014285a0 
> bmdma 0x0000000000011418 irq 23
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
> ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
> ata1.00: configured for UDMA/133
> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata2.00: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
> ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
> ata2.00: configured for UDMA/133
> scsi 0:0:0:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 
> ANSI: 5
> ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
> segs 61
> scsi 1:0:0:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 
> ANSI: 5
> ata2: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
> segs 61
> ACPI: PCI Interrupt Link [LSI1] enabled at IRQ 22
> ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSI1] -> GSI 22 (level, 
> high) -> IRQ 22
> sata_nv 0000:00:08.0: Using ADMA mode
> PCI: Setting latency timer of device 0000:00:08.0 to 64
> scsi2 : sata_nv
> scsi3 : sata_nv
> ata3: SATA max UDMA/133 cmd 0xffffc2000142a480 ctl 0xffffc2000142a4a0 
> bmdma 0x0000000000011420 irq 22
> ata4: SATA max UDMA/133 cmd 0xffffc2000142a580 ctl 0xffffc2000142a5a0 
> bmdma 0x0000000000011428 irq 22
> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata3.00: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
> ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
> ata3.00: configured for UDMA/133
> ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata4.00: ATA-7: ST3160811AS, 3.AAE, max UDMA/133
> ata4.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
> ata4.00: configured for UDMA/133
> scsi 2:0:0:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 
> ANSI: 5
> ata3: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
> segs 61
> scsi 3:0:0:0: Direct-Access     ATA      ST3160811AS      3.AA PQ: 0 
> ANSI: 5
> ata4: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw 
> segs 61
> sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sda: unknown partition table
> sd 0:0:0:0: [sda] Attached SCSI disk
> sd 1:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
> sd 1:0:0:0: [sdb] Write Protect is off
> sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 1:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
> sd 1:0:0:0: [sdb] Write Protect is off
> sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sdb: unknown partition table
> sd 1:0:0:0: [sdb] Attached SCSI disk
> sd 2:0:0:0: [sdc] 312581808 512-byte hardware sectors (160042 MB)
> sd 2:0:0:0: [sdc] Write Protect is off
> sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 2:0:0:0: [sdc] 312581808 512-byte hardware sectors (160042 MB)
> sd 2:0:0:0: [sdc] Write Protect is off
> sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sdc: unknown partition table
> sd 2:0:0:0: [sdc] Attached SCSI disk
> sd 3:0:0:0: [sdd] 312581808 512-byte hardware sectors (160042 MB)
> sd 3:0:0:0: [sdd] Write Protect is off
> sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 3:0:0:0: [sdd] 312581808 512-byte hardware sectors (160042 MB)
> sd 3:0:0:0: [sdd] Write Protect is off
> sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sdd: unknown partition table
> sd 3:0:0:0: [sdd] Attached SCSI disk
> [...]
> md: md0 stopped.
> md: md0 stopped.
> md: bind<sdc>
> md: bind<sdd>
> md: bind<sdb>
> md: md0: raid array is not clean -- starting background reconstruction
> raid10: raid set md0 active with 3 out of 4 devices
> md: couldn't update array info. -22
> md: resync of RAID array md0
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 
> 200000 KB/sec) for resync.
> md: using 128k window, over a total of 312581632 blocks.
> Filesystem "md0": Disabling barriers, not supported by the underlying 
> device
> XFS mounting filesystem md0
> Starting XFS recovery on filesystem: md0 (logdev: internal)
> Ending XFS recovery on filesystem: md0 (logdev: internal)
>
>
>


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

