From: "Vincze, Tamas" <vincze@neb.com>
Subject: raid5 failure + libata irq: nobody cared
Date: Fri, 16 Nov 2007 12:05:39 -0500
Message-ID: <473DCDE3.5060904@neb.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Last night a drive failed in my RAID5 array and it was kicked
out of the array, continuing with 3 drives as expected.

However a few minutes later this was logged:

irq 18: nobody cared (try booting with the "irqpoll" option)
Call Trace: <IRQ> <ffffffff8015b930>{__report_bad_irq+48}
    <ffffffff8015bb2e>{note_interrupt+433} <ffffffff8015b444>{__do_IRQ+191}

IRQ 18 belongs to the SATA controller where all 4 drives are connected.

Nothing more was logged, probably because the interrupt got disabled,
making it impossible to talk to the drives anymore. It's bad because
I ended up with a dirty degraded array the second time this year.

How would a RAID-6 handle a crash when a drive is missing?
Would that also lead to possible silent corruptions?
Or is the only option to avoid silent corruptions is a battery
backed hardware controller?


Kernel is 2.6.16-1.2133_FC5

Here's the full log:

Nov 16 00:43:10 p4 kernel: ata1: command 0xea timeout, stat 0xd0 host_stat 0x0
Nov 16 00:43:10 p4 kernel: ata1: status=0xd0 { Busy }
Nov 16 00:43:10 p4 kernel: ATA: abnormal status 0xD0 on port 0xE407
Nov 16 00:43:10 p4 last message repeated 2 times
Nov 16 01:30:06 p4 kernel: ata1: command 0xea timeout, stat 0xd0 host_stat 0x0
Nov 16 01:30:06 p4 kernel: ata1: status=0xd0 { Busy }
Nov 16 01:30:06 p4 kernel: ATA: abnormal status 0xD0 on port 0xE407
Nov 16 01:30:06 p4 last message repeated 2 times
Nov 16 01:34:13 p4 kernel: ata1: command 0xea timeout, stat 0xd0 host_stat 0x0
Nov 16 01:34:13 p4 kernel: ata1: status=0xd0 { Busy }
Nov 16 01:34:13 p4 kernel: ATA: abnormal status 0xD0 on port 0xE407
Nov 16 01:34:13 p4 last message repeated 2 times
Nov 16 01:35:13 p4 kernel: ata1: command 0x35 timeout, stat 0xd0 host_stat 0x61
Nov 16 01:35:13 p4 kernel: ata1: status=0xd0 { Busy }
Nov 16 01:35:13 p4 kernel: sd 0:0:0:0: SCSI error: return code = 0x8000002
Nov 16 01:35:13 p4 kernel: sda: Current: sense key: Aborted Command
Nov 16 01:35:13 p4 kernel:     Additional sense: Scsi parity error
Nov 16 01:35:13 p4 kernel: end_request: I/O error, dev sda, sector 781015848
Nov 16 01:35:43 p4 kernel: ATA: abnormal status 0xD0 on port 0xE407
Nov 16 01:35:44 p4 last message repeated 2 times
Nov 16 01:35:44 p4 kernel: ata1: command 0xea timeout, stat 0xd0 host_stat 0x0
Nov 16 01:35:44 p4 kernel: ata1: status=0xd0 { Busy }
Nov 16 01:35:44 p4 kernel: raid5: Disk failure on sda3, disabling device. 
Operation continuing on 3 devices
Nov 16 01:35:44 p4 kernel: ATA: abnormal status 0xD0 on port 0xE407
Nov 16 01:35:44 p4 kernel: RAID5 conf printout:
Nov 16 01:35:44 p4 kernel:  --- rd:4 wd:3 fd:1
Nov 16 01:35:44 p4 kernel:  disk 0, o:0, dev:sda3
Nov 16 01:35:44 p4 kernel:  disk 1, o:1, dev:sdc3
Nov 16 01:35:44 p4 kernel:  disk 2, o:1, dev:sdb3
Nov 16 01:35:44 p4 kernel:  disk 3, o:1, dev:sdd3
Nov 16 01:35:44 p4 kernel: RAID5 conf printout:
Nov 16 01:35:44 p4 kernel:  --- rd:4 wd:3 fd:1
Nov 16 01:35:44 p4 kernel:  disk 1, o:1, dev:sdc3
Nov 16 01:35:44 p4 kernel:  disk 2, o:1, dev:sdb3
Nov 16 01:35:44 p4 kernel:  disk 3, o:1, dev:sdd3
Nov 16 01:37:36 p4 kernel: irq 18: nobody cared (try booting with the 
"irqpoll" option)
Nov 16 01:37:36 p4 kernel:
Nov 16 01:37:36 p4 kernel: Call Trace: <IRQ> 
<ffffffff8015b930>{__report_bad_irq+48}

Nov 16 01:37:36 p4 kernel:        <ffffffff8015bb2e>{note_interrupt+433} 
<ffffffff8015b444>{__do_IRQ+191}


-Tamas
