From: Simon Mcnair <simonmcnair@gmail.com>
Subject: removing AHCI SATA devices
Date: Tue, 22 Feb 2011 16:05:43 +0000
Message-ID: <AANLkTimkAMh9T0G_6XyajcMVv9gbNn1-gPpvmBSAAfPY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi all,
Whilst I am aware that with AHCI and SATAII I can just unplug a HDD at
will what is the correct process for doing a 'clean' dismount ?

Since MD is a layer over the top of the physical device how can you
ensure with certainty that all data has been flushed and the device
removal is clean ?

The advice I was given was that if I unmount the filesystem it'll be
fine, but I don't like the messages I get in dmesg:

ata5: exception Emask 0x10 SAct 0x0 SErr 0x4090000 action 0xe frozen
ata5: irq_stat 0x00400040, connection status changed
ata5: SError: { PHYRdyChg 10B8B DevExch }
ata5: hard resetting link
ata5: SATA link down (SStatus 0 SControl 300)
ata5: hard resetting link
ata5: SATA link down (SStatus 0 SControl 300)
ata5: limiting SATA link speed to 1.5 Gbps
ata5: hard resetting link
ata5: SATA link down (SStatus 0 SControl 310)
ata5.00: disabled
ata5: EH complete
ata5.00: detaching (SCSI 5:0:0:0)
scst: Detached from scsi5, channel 0, id 0, lun 0, type 0
sd 5:0:0:0: [sdd] Synchronizing SCSI cache
sd 5:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 5:0:0:0: [sdd] Stopping disk
sd 5:0:0:0: [sdd] START_STOP FAILED
sd 5:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK

do I need to do:
echo 1 > /sys/block/sdd/device/delete
or follow:
http://tldp.org/HOWTO/archived/SCSI-Programming-HOWTO/SCSI-Programming-HOWTO-4.html
(Dynamically insert and remove SCSI devices)
or something else completely ? (or just put up with it ?)

Some advice would be appreciated.

regards
Simon
