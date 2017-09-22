From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: ServeRAID-BR10i (LSI SAS1068E) strageness
Date: Fri, 22 Sep 2017 18:11:36 +1000
Message-ID: <74846504-299c-1d75-d6e9-8fbe8b603f52@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an IBM ServeRAID-BR10i. Identified at boot time as
	LSISAS1068E B3, FwRev=011b5600h
I was using another controller (HighPoint RocketRAID 2720SGL) which gives me grief
so decided to re-commission my old (slow) controller. It worked perfectly until retired
4 years ago.

I want to use this old controller, to confirm that my recent problems are from my controller,
and if so acquire a reliable one.

The LSI controller POST messages indicated it seed all 7 disks, and they are also
present in the linux messages, but the partitions are not there. I did not enter
the controller's configuration dialogue.

Each disk has one (unformatted, created with gparted) partition which is a member of
a RAID6.

The messages in the log are these:

Sep 22 14:59:18 e7 kernel: mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 20, phy 0, sas_addr 0x70944e23a5c4b492
Sep 22 14:59:18 e7 kernel: scsi 6:0:0:0: Direct-Access     ATA      WDC WD4003FZEX-0 1A01 PQ: 0 ANSI: 5
Sep 22 14:59:18 e7 kernel: sd 6:0:0:0: Attached scsi generic sg2 type 0
Sep 22 14:59:18 e7 kernel: sd 6:0:0:0: [sdc] 4294967294 512-byte logical blocks: (2.20 TB/2.00 TiB)
Sep 22 14:59:18 e7 kernel: sd 6:0:0:0: [sdc] Write Protect is off
Sep 22 14:59:18 e7 kernel: sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Unlike the usual messages:

Sep 23 01:05:17 e7 kernel: ata7.00: ATA-8: WDC WD4001FAEX-00MJRA0, 01.01L01, max UDMA/133
Sep 23 01:05:17 e7 kernel: ata7.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth 31/32)
Sep 23 01:05:17 e7 kernel: ata7.00: configured for UDMA/133
Sep 23 01:05:17 e7 kernel: scsi 6:0:0:0: Direct-Access     ATA      WDC WD4001FAEX-0 1L01 PQ: 0 ANSI: 5
Sep 23 01:05:19 e7 kernel: sd 6:0:0:0: Attached scsi generic sg2 type 0
Sep 23 01:05:19 e7 kernel: sd 6:0:0:0: [sdc] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)
Sep 23 01:05:19 e7 kernel: sd 6:0:0:0: [sdc] Write Protect is off
Sep 23 01:05:19 e7 kernel: sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Sep 23 01:05:19 e7 kernel: sdc: sdc1
Sep 23 01:05:19 e7 kernel: sd 6:0:0:0: [sdc] Attached SCSI disk

In short, no ata?.00 devices and no 'sdc: sdc1' partition list.

As an aside, I notice that the messages from parted are a bit different from what I have recorded.
My records are from when I was running f19 (now on f26) so maybe the utilities changed.

The old record (from f19):

$ sudo parted /dev/sdj print
Model: ATA WDC WD4001FAEX-0 (scsi)
Disk /dev/sdj: 4001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
  1      1049kB  4001GB  4001GB

What I see now (from f26):

$ sudo parted /dev/sdc print
Model: ATA WDC WD4001FAEX-0 (scsi)
Disk /dev/sdc: 4001GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags:

Number  Start   End     Size    File system  Name  Flags
  1      1049kB  4001GB  4001GB                     msftdata

The partition is now showing a flag 'msftdata'.
Is this a utility change (fdisk is also slightly different) or did the LSI touch the partition table?

TIA

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
