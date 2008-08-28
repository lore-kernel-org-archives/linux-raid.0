From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Help to decipher kernel io error log
Date: Thu, 28 Aug 2008 12:03:07 +0200
Message-ID: <48B677DB.4010306@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

This is not a strictly raid question, but this is the best list I know
of for this type of questions. Two days ago my server ground to a halt
without apparent reasons. There were tons of processes in D state, with
no signs of any significant work being done. I attributed it to resource
starvation (the server is pretty loaded), rebooted and went on with my
life.

Yesterday I received the log messages included at the bottom of this
email. Since I am running a --level=10 --raid-devices=4 --layout=f3 I am
not that worried abiut losing data, and decided to investigate. I
removed (mdadm -r) the devices in question from the arrays, power cycled
 the server, and executed a full badblocks -svw /dev/sda run. It passed
with flying colors.

So here is my question - what does the log below signify (there are no
omissions, this is all I got) - is my controller dying? Or is there
indeed a well masked hard drive failure? Should I change the drive, the
controller, or both?

Thank you for your thoughts!

Peter

====================
=== Hardware setup

Intel SE7210 TP1-E board
(http://www.intel.com/support/motherboards/server/se7210tp1-e/index.htm)

4 identical 250GB Maxtor 7Y250M0 hard drives

- two of them attached to the on board SATA controller:
00:1f.2 IDE interface: Intel Corporation 6300ESB SATA Storage Controller
(rev 02) (prog-if 8f [Master SecP SecO PriP PriO])
	Subsystem: Intel Corporation Device 342f
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at e400 [size=8]
	Region 1: I/O ports at e000 [size=4]
	Region 2: I/O ports at dc00 [size=8]
	Region 3: I/O ports at d800 [size=4]
	Region 4: I/O ports at d400 [size=16]
	Kernel driver in use: ata_piix

- two of them attached to a RocketRaid 1820A controller
(http://www.highpoint-tech.com/USA/rr1820a.htm)
02:04.0 SCSI storage controller: Marvell Technology Group Ltd.
MV88SX5081 8-port SATA I PCI-X Controller (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+
Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fc480000 (64-bit, non-prefetchable) [size=512K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk+ DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0
Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [60] PCI-X non-bridge device
		Command: DPERE- ERO- RBC=512 OST=4
		Status: Dev=ff:1f.0 64bit+ 133MHz+ SCD- USC- DC=simple DMMRBC=512
DMOST=4 DMCRS=8 RSCEM- 266MHz- 533MHz-

====================
=== Kernel error log


Aug 27 02:27:02 Arzamas kernel: IAL: COMPLETION ERROR, adapter 0,
channel 2, flags=104 lba 6dc0b7 sectors 10 cmd 20
Aug 27 02:27:02 Arzamas kernel: ATA regs: error 40, sector count 0, LBA
low b7, LBA mid c0, LBA high 6d, device 40, status 51
Aug 27 02:27:02 Arzamas kernel: --- RR182x: Channel [0/2] State Dump ---
Aug 27 02:27:02 Arzamas kernel: pending commands:
Aug 27 02:27:02 Arzamas kernel: EDMA registers:
Aug 27 02:27:02 Arzamas kernel: [26000] = 00000100   [26004] = A63D8198
Aug 27 02:27:02 Arzamas kernel: [26008] = 00000000   [2600C] = 00000118
Aug 27 02:27:02 Arzamas kernel: [26010] = 00000000   [26014] = 37CDCC00
Aug 27 02:27:02 Arzamas kernel: [26018] = 00000000   [2601C] = 00000000
Aug 27 02:27:02 Arzamas kernel: [26020] = 00000000   [26024] = 031DB300
Aug 27 02:27:02 Arzamas kernel: [26028] = 00000000   [2602C] = 00000000
Aug 27 02:27:02 Arzamas kernel: [26030] = 0000003E   [26034] = 000000BC
Aug 27 02:27:02 Arzamas kernel: Device registers:
Aug 27 02:27:02 Arzamas kernel: [26100] = 00000000   [26104] = 00000001
Aug 27 02:27:02 Arzamas kernel: [26108] = 00000001   [2610C] = 00000001
Aug 27 02:27:02 Arzamas kernel: [26110] = 00000000   [26114] = 00000000
Aug 27 02:27:02 Arzamas kernel: [26118] = 00000000   [2611C] = 00000050
Aug 27 02:27:02 Arzamas kernel: [26120] = 00000050   [26124] = 00000000
Aug 27 02:27:02 Arzamas kernel: SATA Bridge registers:
Aug 27 02:27:02 Arzamas kernel: [20300] = 00000113
Aug 27 02:27:02 Arzamas kernel: [20304] = 00000000
Aug 27 02:27:02 Arzamas kernel: [20308] = 00000000
Aug 27 02:27:02 Arzamas kernel: [2030C] = 00500001
Aug 27 02:27:02 Arzamas kernel: [2033C] = 40000000
Aug 27 02:27:02 Arzamas kernel: [20374] = 05EAC880
Aug 27 02:27:03 Arzamas kernel: channel 2: perform recalibrate command
Aug 27 02:27:03 Arzamas kernel: Retry on channel(2)
Aug 27 02:27:05 Arzamas kernel: IAL: COMPLETION ERROR, adapter 0,
channel 2, flags=104 lba 6dc0b7 sectors 10 cmd 20
Aug 27 02:27:05 Arzamas kernel: ATA regs: error 40, sector count 0, LBA
low b7, LBA mid c0, LBA high 6d, device 40, status 51
Aug 27 02:27:05 Arzamas kernel: --- RR182x: Channel [0/2] State Dump ---
Aug 27 02:27:05 Arzamas kernel: pending commands:
Aug 27 02:27:05 Arzamas kernel: EDMA registers:
Aug 27 02:27:05 Arzamas kernel: [26000] = 00000100   [26004] = A63D8401
Aug 27 02:27:05 Arzamas kernel: [26008] = 00000000   [2600C] = 00000118
Aug 27 02:27:05 Arzamas kernel: [26010] = 00000000   [26014] = 37CDCC00
Aug 27 02:27:05 Arzamas kernel: [26018] = 00000000   [2601C] = 00000000
Aug 27 02:27:05 Arzamas kernel: [26020] = 00000000   [26024] = 031DB300
Aug 27 02:27:05 Arzamas kernel: [26028] = 00000000   [2602C] = 00000000
Aug 27 02:27:05 Arzamas kernel: [26030] = 0000003F   [26034] = 000000BC
Aug 27 02:27:05 Arzamas kernel: Device registers:
Aug 27 02:27:05 Arzamas kernel: [26100] = 00000000   [26104] = 00000001
Aug 27 02:27:05 Arzamas kernel: [26108] = 00000001   [2610C] = 00000001
Aug 27 02:27:05 Arzamas kernel: [26110] = 00000000   [26114] = 00000000
Aug 27 02:27:05 Arzamas kernel: [26118] = 00000000   [2611C] = 00000050
Aug 27 02:27:05 Arzamas kernel: [26120] = 00000050   [26124] = 00000000
Aug 27 02:27:05 Arzamas kernel: SATA Bridge registers:
Aug 27 02:27:05 Arzamas kernel: [20300] = 00000113
Aug 27 02:27:05 Arzamas kernel: [20304] = 00000000
Aug 27 02:27:05 Arzamas kernel: [20308] = 00000000
Aug 27 02:27:05 Arzamas kernel: [2030C] = 00500001
Aug 27 02:27:05 Arzamas kernel: [2033C] = 40000000
Aug 27 02:27:05 Arzamas kernel: [20374] = 05EAC880
Aug 27 02:27:05 Arzamas kernel: channel 2: perform recalibrate command
Aug 27 02:27:05 Arzamas kernel: Retry on channel(2)
Aug 27 02:27:07 Arzamas kernel: IAL: COMPLETION ERROR, adapter 0,
channel 2, flags=104 lba 6dc0b7 sectors 10 cmd 20
Aug 27 02:27:07 Arzamas kernel: ATA regs: error 40, sector count 0, LBA
low b7, LBA mid c0, LBA high 6d, device 40, status 51
Aug 27 02:27:07 Arzamas kernel: --- RR182x: Channel [0/2] State Dump ---
Aug 27 02:27:07 Arzamas kernel: pending commands:
Aug 27 02:27:07 Arzamas kernel: EDMA registers:
Aug 27 02:27:07 Arzamas kernel: [26000] = 00000100   [26004] = A63D8669
Aug 27 02:27:07 Arzamas kernel: [26008] = 00000000   [2600C] = 00000118
Aug 27 02:27:07 Arzamas kernel: [26010] = 00000000   [26014] = 37CDCC00
Aug 27 02:27:07 Arzamas kernel: [26018] = 00000000   [2601C] = 00000000
Aug 27 02:27:07 Arzamas kernel: [26020] = 00000000   [26024] = 031DB300
Aug 27 02:27:07 Arzamas kernel: [26028] = 00000000   [2602C] = 00000000
Aug 27 02:27:07 Arzamas kernel: [26030] = 0000003F   [26034] = 000000BC
Aug 27 02:27:07 Arzamas kernel: Device registers:
Aug 27 02:27:07 Arzamas kernel: [26100] = 00000000   [26104] = 00000001
Aug 27 02:27:07 Arzamas kernel: [26108] = 00000001   [2610C] = 00000001
Aug 27 02:27:07 Arzamas kernel: [26110] = 00000000   [26114] = 00000000
Aug 27 02:27:07 Arzamas kernel: [26118] = 00000000   [2611C] = 00000050
Aug 27 02:27:07 Arzamas kernel: [26120] = 00000050   [26124] = 00000000
Aug 27 02:27:07 Arzamas kernel: SATA Bridge registers:
Aug 27 02:27:07 Arzamas kernel: [20300] = 00000113
Aug 27 02:27:07 Arzamas kernel: [20304] = 00000000
Aug 27 02:27:07 Arzamas kernel: [20308] = 00000000
Aug 27 02:27:07 Arzamas kernel: [2030C] = 00500001
Aug 27 02:27:07 Arzamas kernel: [2033C] = 40000000
Aug 27 02:27:07 Arzamas kernel: [20374] = 05EAC880
Aug 27 02:27:07 Arzamas kernel: channel 2: perform recalibrate command
Aug 27 02:27:07 Arzamas kernel: Retry on channel(2)
Aug 27 02:27:08 Arzamas kernel: IAL: COMPLETION ERROR, adapter 0,
channel 2, flags=104 lba 6dc0b7 sectors 10 cmd 20
Aug 27 02:27:08 Arzamas kernel: ATA regs: error 40, sector count 0, LBA
low b7, LBA mid c0, LBA high 6d, device 40, status 51
Aug 27 02:27:08 Arzamas kernel: --- RR182x: Channel [0/2] State Dump ---
Aug 27 02:27:08 Arzamas kernel: pending commands:
Aug 27 02:27:08 Arzamas kernel: EDMA registers:
Aug 27 02:27:08 Arzamas kernel: [26000] = 00000100   [26004] = A63D88D1
Aug 27 02:27:08 Arzamas kernel: [26008] = 00000000   [2600C] = 00000118
Aug 27 02:27:08 Arzamas kernel: [26010] = 00000000   [26014] = 37CDCC00
Aug 27 02:27:08 Arzamas kernel: [26018] = 00000000   [2601C] = 00000000
Aug 27 02:27:08 Arzamas kernel: [26020] = 00000000   [26024] = 031DB300
Aug 27 02:27:08 Arzamas kernel: [26028] = 00000000   [2602C] = 00000000
Aug 27 02:27:08 Arzamas kernel: [26030] = 0000003F   [26034] = 000000BC
Aug 27 02:27:08 Arzamas kernel: Device registers:
Aug 27 02:27:08 Arzamas kernel: [26100] = 00000000   [26104] = 00000001
Aug 27 02:27:08 Arzamas kernel: [26108] = 00000001   [2610C] = 00000001
Aug 27 02:27:08 Arzamas kernel: [26110] = 00000000   [26114] = 00000000
Aug 27 02:27:08 Arzamas kernel: [26118] = 00000000   [2611C] = 00000050
Aug 27 02:27:08 Arzamas kernel: [26120] = 00000050   [26124] = 00000000
Aug 27 02:27:08 Arzamas kernel: SATA Bridge registers:
Aug 27 02:27:08 Arzamas kernel: [20300] = 00000113
Aug 27 02:27:08 Arzamas kernel: [20304] = 00000000
Aug 27 02:27:08 Arzamas kernel: [20308] = 00000000
Aug 27 02:27:08 Arzamas kernel: [2030C] = 00500001
Aug 27 02:27:08 Arzamas kernel: [2033C] = 40000000
Aug 27 02:27:08 Arzamas kernel: [20374] = 05EAC880
Aug 27 02:27:08 Arzamas kernel: RR182x [0,2]: Reset more than 3 times,
disconnect it
Aug 27 02:27:08 Arzamas kernel: sd 0:0:0:0: [sda] Result: hostbyte=0x05
driverbyte=0x25
Aug 27 02:27:08 Arzamas kernel: end_request: I/O error, dev sda, sector
7192759
Aug 27 02:27:08 Arzamas kernel: raid1: sda1: rescheduling sector 7192696
Aug 27 02:27:08 Arzamas kernel: sd 0:0:0:0: [sda] Result: hostbyte=0x00
driverbyte=0x00
Aug 27 02:27:08 Arzamas kernel: end_request: I/O error, dev sda, sector
12000319
Aug 27 02:27:08 Arzamas kernel: md: super_written gets error=-5, uptodate=0
Aug 27 02:27:08 Arzamas kernel: raid1: Disk failure on sda1, disabling
device.
Aug 27 02:27:08 Arzamas kernel: 	Operation continuing on 3 devices
Aug 27 02:27:08 Arzamas kernel: RAID1 conf printout:
Aug 27 02:27:08 Arzamas kernel: --- wd:3 rd:4
Aug 27 02:27:08 Arzamas kernel: disk 0, wo:1, o:0, dev:sda1
Aug 27 02:27:08 Arzamas kernel: disk 1, wo:0, o:1, dev:sdb1
Aug 27 02:27:08 Arzamas kernel: disk 2, wo:0, o:1, dev:sdd1
Aug 27 02:27:08 Arzamas kernel: disk 3, wo:0, o:1, dev:sde1
Aug 27 02:27:08 Arzamas kernel: RAID1 conf printout:
Aug 27 02:27:08 Arzamas kernel: --- wd:3 rd:4
Aug 27 02:27:08 Arzamas kernel: disk 1, wo:0, o:1, dev:sdb1
Aug 27 02:27:08 Arzamas kernel: disk 2, wo:0, o:1, dev:sdd1
Aug 27 02:27:08 Arzamas kernel: disk 3, wo:0, o:1, dev:sde1
Aug 27 02:27:08 Arzamas kernel: raid1: sdd1: redirecting sector 7192696
to another mirror
Aug 27 02:27:15 Arzamas kernel: sd 0:0:0:0: [sda] Result: hostbyte=0x00
driverbyte=0x00
Aug 27 02:27:15 Arzamas kernel: end_request: I/O error, dev sda, sector
488166955
Aug 27 02:27:15 Arzamas kernel: md: super_written gets error=-5, uptodate=0
Aug 27 02:27:15 Arzamas kernel: raid10: Disk failure on sda2, disabling
device.
Aug 27 02:27:15 Arzamas kernel: 	Operation continuing on 3 devices
Aug 27 02:27:16 Arzamas kernel: RAID10 conf printout:
Aug 27 02:27:16 Arzamas kernel: --- wd:3 rd:4
Aug 27 02:27:16 Arzamas kernel: disk 0, wo:1, o:0, dev:sda2
Aug 27 02:27:16 Arzamas kernel: disk 1, wo:0, o:1, dev:sdb2
Aug 27 02:27:16 Arzamas kernel: disk 2, wo:0, o:1, dev:sdd2
Aug 27 02:27:16 Arzamas kernel: disk 3, wo:0, o:1, dev:sde2
Aug 27 02:27:16 Arzamas kernel: RAID10 conf printout:
Aug 27 02:27:16 Arzamas kernel: --- wd:3 rd:4
Aug 27 02:27:16 Arzamas kernel: disk 1, wo:0, o:1, dev:sdb2
Aug 27 02:27:16 Arzamas kernel: disk 2, wo:0, o:1, dev:sdd2
Aug 27 02:27:16 Arzamas kernel: disk 3, wo:0, o:1, dev:sde2
