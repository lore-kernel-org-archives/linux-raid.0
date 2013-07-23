From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: MD array keeps resyncing after rebooting
Date: Tue, 23 Jul 2013 14:55:33 +0200
Message-ID: <CAC9WiBjs4DQqt1G911OBALzSqn=o_=L1S4_K_MvUWhAu-rhtUw@mail.gmail.com>
References: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjm5-RJ=CfpXMG7CCBp7StzWDuhp5XyFs4hAW3sxX7Gfw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Martin Wilck <mwilck@arcor.de>
List-Id: linux-raid.ids

On Tue, Jul 23, 2013 at 11:46 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> I'm using a RAID1 with DDF metadata format. The array has been
> initialized by the bios and contains my root partition.
>
> After booting I waited for the RAID1 array to finish syncing then rebooting.
>
> Then I rebooted but the sync restarts again:
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md126 : active raid1 sdb[1] sda[0]
>       975585280 blocks super external:/md127/0 [2/2] [UU]
>       [=>...................]  resync =  7.3% (71783424/975585280)
> finish=112.1min speed=134299K/sec
>
> md127 : inactive sdb[1](S) sda[0](S)
>       2354608 blocks super external:ddf
>
> unused devices: <none>
>
> Could anybody tell me what's happening ?
>

More information taken from kernel logs:

[    2.175802] SCSI subsystem initialized
[    2.178912] libata version 3.00 loaded.
[    2.184876] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    2.185057] isci 0000:0e:00.0: driver configured for rev: 6 silicon
[    2.185212] isci 0000:0e:00.0: OEM SAS parameters (version: 1.3)
loaded (firmware)
[    2.188451] isci 0000:0e:00.0: SCU controller 0: phy 3-0 cables:
{short, short, short, short}
[    2.191041] scsi0 : isci
[    2.191755] isci 0000:0e:00.0: irq 71 for MSI/MSI-X
[    2.191764] isci 0000:0e:00.0: irq 72 for MSI/MSI-X
[    2.442020] Refined TSC clocksource calibration: 1799.999 MHz.
[    2.442059] sas: phy-0:0 added to port-0:0, phy_mask:0x1 (5fcfffff00000001)
[    2.442141] Switching to clocksource tsc
[    2.491953] sas: DOING DISCOVERY on port 0, pid:5
[    2.491976] sas: DONE DISCOVERY on port 0, pid:5, result:0
[    2.491985] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[    2.492191] sas: ata1: end_device-0:0: dev error handler
[    2.842323] ata1.00: ATA-8: ST1000NM0011         81Y9807
81Y3867IBM, BB4A, max UDMA/133
[    2.842469] ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.843622] ata1.00: configured for UDMA/133
[    2.843791] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
[    2.861663] scsi 0:0:0:0: Direct-Access     ATA      ST1000NM0011
  BB4A PQ: 0 ANSI: 5
[    2.865250] ahci 0000:00:1f.2: version 3.0
[    2.865352] ahci 0000:00:1f.2: irq 73 for MSI/MSI-X
[    2.865408] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 1.5
Gbps 0x1 impl SATA mode
[    2.865555] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio
slum part ems apst
[    2.865700] ahci 0000:00:1f.2: setting latency timer to 64
[    2.866183] scsi1 : ahci
[    2.866466] scsi2 : ahci
[    2.866746] scsi3 : ahci
[    2.867032] scsi4 : ahci
[    2.867316] scsi5 : ahci
[    2.867562] scsi6 : ahci
[    2.867722] ata2: SATA max UDMA/133 abar m2048@0x902ff000 port
0x902ff100 irq 73
[    2.867865] ata3: DUMMY
[    2.867973] ata4: DUMMY
[    2.868081] ata5: DUMMY
[    2.868188] ata6: DUMMY
[    2.868296] ata7: DUMMY
[    3.210812] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.211262] ata2.00: ATAPI: IBM SATA DEVICE 81Y3666, IB00, max UDMA/100
[    3.212441] ata2.00: configured for UDMA/100
[    3.214231] scsi 1:0:0:0: CD-ROM            IBM SATA DEVICE 81Y3666
  IB00 PQ: 0 ANSI: 5
[    3.284669] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    3.284855] sd 0:0:0:0: [sda] Write Protect is off
[    3.284970] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.285008] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.402209] md: bind<sda>
[    3.408409] md: bind<sda>
[    3.430547] sas: phy-0:1 added to port-0:1, phy_mask:0x2 (5fcfffff00000002)
[    3.430564] sas: DOING DISCOVERY on port 1, pid:88
[    3.430647] sas: DONE DISCOVERY on port 1, pid:88, result:0
[    3.430694] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[    3.430741] sas: ata1: end_device-0:0: dev error handler
[    3.430754] sas: ata8: end_device-0:1: dev error handler
[    3.660124] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    3.810483] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    3.810605] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.811114] hub 1-1:1.0: USB hub found
[    3.811313] hub 1-1:1.0: 6 ports detected
[    3.850059] ata8.00: ATA-8: WD1003FBYX-23        81Y9807
81Y3867IBM,     WB35, max UDMA/133
[    3.850207] ata8.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.851914] ata8.00: configured for UDMA/133
[    3.852068] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0
[    3.870029] scsi 0:0:1:0: Direct-Access     ATA      WD1003FBYX-23
  n/a  PQ: 0 ANSI: 5
[    3.870326] sd 0:0:1:0: [sdb] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    3.870710] sd 0:0:1:0: [sdb] Write Protect is off
[    3.870827] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    3.870862] sd 0:0:1:0: [sdb] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.899616]  sdb: sdb1 sdb2 < sdb5 sdb6 >
[    3.900677] sd 0:0:1:0: [sdb] Attached SCSI disk
[    3.929662] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    3.976356] md: bind<sdb>
[    3.980302] md: bind<sdb>
[    3.980487] md: export_rdev(sda)
[    3.982381] md: raid1 personality registered for level 1
[    3.982798] bio: create slab <bio-1> at 1
[    3.983026] md/raid1:md126: not clean -- starting background reconstruction
[    3.983155] md/raid1:md126: active with 2 out of 2 mirrors
[    3.983288] md126: detected capacity change from 0 to 998999326720
[    3.984714]  md126: p1 p2 < p5 p6 >
[    4.362728] md: md126 switched to read-write mode.
[    4.362980] md: resync of RAID array md126
[    4.363107] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[    4.363224] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for resync.
[    4.363437] md: using 128k window, over a total of 975585280k.

Thanks
--
Francis
