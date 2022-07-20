Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14A6C43334
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 15:55:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbiGTPzX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 11:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiGTPzM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 11:55:12 -0400
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30E826F6
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 08:55:09 -0700 (PDT)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 26KFt5SE018272
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 20 Jul 2022 16:55:05 +0100
From:   Nix <nix@esperi.org.uk>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
References: <87o7xmsjcv.fsf@esperi.org.uk>
        <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
Emacs:  an inspiring example of form following function... to Hell.
Date:   Wed, 20 Jul 2022 16:55:05 +0100
In-Reply-To: <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk> (Wols
        Lists's message of "Mon, 18 Jul 2022 14:17:30 +0100")
Message-ID: <87bktjpyna.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=2 Fuz1=2 Fuz2=2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 18 Jul 2022, Wols Lists spake thusly:

> On 18/07/2022 13:20, Nix wrote:
>> So I have a pair of RAID-6 mdraid arrays on this machine (one of which
>> has a bcache layered on top of it, with an LVM VG stretched across
>> both). Kernel 5.16 + mdadm 4.0 (I know, it's old) works fine, but I just
>> rebooted into 5.18.12 and it failed to assemble. mdadm didn't display
>> anything useful: an mdadm --assemble --scan --auto=md --freeze-reshape
>> simply didn't find anything to assemble, and after that nothing else was
>> going to work. But rebooting into 5.16 worked fine, so everything was
>> (thank goodness) actually still there.
>
> Everything should still be there ... and the difference between mdadm 4.0 and 4.2 isn't that much I don't think ... a few bugfixes
> here and there ...

Yeah, I was just a bit worried :)

> When you reboot into the new kernel, try lsdrv
>
> https://raid.wiki.kernel.org/index.php/Asking_for_help#lsdrv

Um, it's a Python script. I don't have Python in my initramfs and it
seems a bit excessive to put it there. (The system doesn't boot any
further than that.)

I'll stick dmesg in there so I can at least see what that says about
block device enumeration, because I fear something has gone wrong with
that. Normal operation says (non-blockdev lines pruned):

[    2.931660] SCSI subsystem initialized
[    2.931660] libata version 3.00 loaded.
[    4.116098] ahci 0000:00:11.4: version 3.0
[    4.116209] ahci 0000:00:11.4: SSS flag set, parallel bus scan disabled
[    4.116241] ahci 0000:00:11.4: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0xf impl SATA mode
[    4.116246] ahci 0000:00:11.4: flags: 64bit ncq stag led clo pio slum part ems apst 
[    4.197974] scsi host0: ahci
[    4.198200] scsi host1: ahci
[    4.198475] scsi host2: ahci
[    4.198719] scsi host3: ahci
[    4.198755] ata1: SATA max UDMA/133 abar m2048@0x91d00000 port 0x91d00100 irq 40
[    4.198760] ata2: SATA max UDMA/133 abar m2048@0x91d00000 port 0x91d00180 irq 40
[    4.198764] ata3: SATA max UDMA/133 abar m2048@0x91d00000 port 0x91d00200 irq 40
[    4.198767] ata4: SATA max UDMA/133 abar m2048@0x91d00000 port 0x91d00280 irq 40
[    4.198891] ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
[    4.198925] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    4.198929] ahci 0000:00:1f.2: flags: 64bit ncq stag led clo pio slum part ems apst 
[    4.348114] scsi host4: ahci
[    4.348244] scsi host5: ahci
[    4.348364] scsi host6: ahci
[    4.348487] scsi host7: ahci
[    4.348605] scsi host8: ahci
[    4.348718] scsi host9: ahci
[    4.348747] ata5: SATA max UDMA/133 abar m2048@0x91d04000 port 0x91d04100 irq 41
[    4.348751] ata6: SATA max UDMA/133 abar m2048@0x91d04000 port 0x91d04180 irq 41
[    4.348754] ata7: SATA max UDMA/133 abar m2048@0x91d04000 port 0x91d04200 irq 41
[    4.348757] ata8: SATA max UDMA/133 abar m2048@0x91d04000 port 0x91d04280 irq 41
[    4.348760] ata9: SATA max UDMA/133 abar m2048@0x91d04000 port 0x91d04300 irq 41
[    4.348763] ata10: SATA max UDMA/133 abar m2048@0x91d04000 port 0x91d04380 irq 41
[    4.530018] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    4.566415] ata1.00: ATA-10: ST8000NM0055-1RM112, SN02, max UDMA/133
[    4.566826] ata1.00: 15628053168 sectors, multi 0: LBA48 NCQ (depth 32), AA
[    4.566834] ata1.00: Features: NCQ-sndrcv
[    4.569771] ata1.00: configured for UDMA/133
[    4.569903] scsi 0:0:0:0: Direct-Access     ATA      ST8000NM0055-1RM SN02 PQ: 0 ANSI: 5
[    4.570019] scsi 0:0:0:0: Attached scsi generic sg0 type 0
[    4.570110] sd 0:0:0:0: [sda] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    4.570115] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    4.570125] sd 0:0:0:0: [sda] Write Protect is off
[    4.570133] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.570147] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.610510]  sda: sda1 sda2 sda3 sda4
[    4.610751] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.689645] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    4.690219] ata5.00: ATA-9: INTEL SSDSC2BB480G6, G2010150, max UDMA/133
[    4.690225] ata5.00: 937703088 sectors, multi 1: LBA48 NCQ (depth 32)
[    4.690860] ata5.00: configured for UDMA/133
[    4.899866] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    4.938473] ata2.00: ATA-10: ST8000NM0055-1RM112, SN02, max UDMA/133
[    4.938961] ata2.00: 15628053168 sectors, multi 0: LBA48 NCQ (depth 32), AA
[    4.938969] ata2.00: Features: NCQ-sndrcv
[    4.941907] ata2.00: configured for UDMA/133
[    4.942104] scsi 1:0:0:0: Direct-Access     ATA      ST8000NM0055-1RM SN02 PQ: 0 ANSI: 5
[    4.942278] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    4.942382] sd 1:0:0:0: [sdb] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    4.942390] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    4.942400] sd 1:0:0:0: [sdb] Write Protect is off
[    4.942407] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.942421] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.987817]  sdb: sdb1 sdb2 sdb3 sdb4
[    4.988027] sd 1:0:0:0: [sdb] Attached SCSI disk
[    5.270040] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    5.301388] ata3.00: ATA-10: ST8000NM0055-1RM112, SN02, max UDMA/133
[    5.301788] ata3.00: 15628053168 sectors, multi 0: LBA48 NCQ (depth 32), AA
[    5.301796] ata3.00: Features: NCQ-sndrcv
[    5.304877] ata3.00: configured for UDMA/133
[    5.305004] scsi 2:0:0:0: Direct-Access     ATA      ST8000NM0055-1RM SN02 PQ: 0 ANSI: 5
[    5.305121] scsi 2:0:0:0: Attached scsi generic sg2 type 0
[    5.305214] sd 2:0:0:0: [sdc] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    5.305223] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    5.305233] sd 2:0:0:0: [sdc] Write Protect is off
[    5.305240] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.305255] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.349535]  sdc: sdc1 sdc2 sdc3 sdc4
[    5.349777] sd 2:0:0:0: [sdc] Attached SCSI disk
[    5.628177] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    5.683296] ata4.00: ATA-10: ST8000NM0055-1RM112, SN02, max UDMA/133
[    5.704658] ata4.00: 15628053168 sectors, multi 0: LBA48 NCQ (depth 32), AA
[    5.723876] ata4.00: Features: NCQ-sndrcv
[    5.749175] ata4.00: configured for UDMA/133
[    5.751203] scsi 3:0:0:0: Direct-Access     ATA      ST8000NM0055-1RM SN02 PQ: 0 ANSI: 5
[    5.753293] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    5.754362] sd 3:0:0:0: [sdd] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    5.754366] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    5.754566] sd 3:0:0:0: [sdd] Write Protect is off
[    5.754572] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    5.754943] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.756201] scsi 4:0:0:0: Direct-Access     ATA      INTEL SSDSC2BB48 0150 PQ: 0 ANSI: 5
[    5.759989] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    5.760299] ata5.00: Enabling discard_zeroes_data
[    5.760991] sd 4:0:0:0: [sde] 937703088 512-byte logical blocks: (480 GB/447 GiB)
[    5.761024] sd 4:0:0:0: [sde] 4096-byte physical blocks
[    5.761510] sd 4:0:0:0: [sde] Write Protect is off
[    5.761552] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    5.761741] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.763924] ata5.00: Enabling discard_zeroes_data
[    5.773947]  sde: sde1 sde2 sde3 sde4
[    5.777368] ata5.00: Enabling discard_zeroes_data
[    5.783988] sd 4:0:0:0: [sde] Attached SCSI disk
[    5.802611]  sdd: sdd1 sdd2 sdd3 sdd4
[    5.983148] sd 3:0:0:0: [sdd] Attached SCSI disk
[    6.089568] ata6: SATA link down (SStatus 0 SControl 300)
[    6.168948] scsi host10: usb-storage 4-2:1.0
[    6.439910] ata7: SATA link down (SStatus 0 SControl 300)
[    6.679999] scsi host11: usb-storage 4-5:1.0
[    6.781246] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.810999] ata8.00: ATA-9: WDC WD8002FRYZ-01FF2B0, 01.01H01, max UDMA/133
[    6.826101] ata8.00: 15628053168 sectors, multi 0: LBA48 NCQ (depth 32), AA
[    6.836947] ata8.00: Features: NCQ-prio
[    6.855027] ata8.00: configured for UDMA/133
[    6.865804] scsi 7:0:0:0: Direct-Access     ATA      WDC WD8002FRYZ-0 1H01 PQ: 0 ANSI: 5
[    6.876950] sd 7:0:0:0: Attached scsi generic sg5 type 0
[    6.878866] sd 7:0:0:0: [sdf] 15628053168 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    6.898797] sd 7:0:0:0: [sdf] 4096-byte physical blocks
[    6.909825] sd 7:0:0:0: [sdf] Write Protect is off
[    6.920793] sd 7:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    6.920885] sd 7:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.984949]  sdf: sdf1 sdf2 sdf3 sdf4
[    6.996451] sd 7:0:0:0: [sdf] Attached SCSI disk
[    7.237933] scsi 10:0:0:0: Direct-Access     WD       Elements 2620    1018 PQ: 0 ANSI: 6
[    7.240503] ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.250420] sd 10:0:0:0: Attached scsi generic sg6 type 0
[    7.254284] sd 10:0:0:0: [sdg] Very big device. Trying to use READ CAPACITY(16).
[    7.256321] sd 10:0:0:0: [sdg] 7813969920 512-byte logical blocks: (4.00 TB/3.64 TiB)
[    7.256323] sd 10:0:0:0: [sdg] 4096-byte physical blocks
[    7.259476] sd 10:0:0:0: [sdg] Write Protect is off
[    7.259557] sd 10:0:0:0: [sdg] Mode Sense: 47 00 10 08
[    7.262178] sd 10:0:0:0: [sdg] No Caching mode page found
[    7.263117] ata9.00: ATAPI: DRW-24D5MT, 1.00, max UDMA/133
[    7.265518] ata9.00: configured for UDMA/133
[    7.273067] scsi 8:0:0:0: CD-ROM            ASUS     DRW-24D5MT       1.00 PQ: 0 ANSI: 5
[    7.367203] sd 10:0:0:0: [sdg] Assuming drive cache: write through
[    7.422400]  sdg: sdg1
[    7.434721] sd 10:0:0:0: [sdg] Attached SCSI disk
[    7.510635] sr 8:0:0:0: [sr0] scsi3-mmc drive: 48x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[    7.522495] cdrom: Uniform CD-ROM driver Revision: 3.20
[    7.588448] sr 8:0:0:0: Attached scsi CD-ROM sr0
[    7.588544] sr 8:0:0:0: Attached scsi generic sg7 type 5
[    7.718002] scsi 11:0:0:0: Direct-Access     WD       My Book 25EE     4004 PQ: 0 ANSI: 6
[    7.729417] sd 11:0:0:0: Attached scsi generic sg8 type 0
[    7.730810] sd 11:0:0:0: [sdh] Very big device. Trying to use READ CAPACITY(16).
[    7.742732] scsi 11:0:0:1: Enclosure         WD       SES Device       4004 PQ: 0 ANSI: 6
[    7.752636] sd 11:0:0:0: [sdh] 15628052480 512-byte logical blocks: (8.00 TB/7.28 TiB)
[    7.752639] sd 11:0:0:0: [sdh] 4096-byte physical blocks
[    7.754504] sd 11:0:0:0: [sdh] Write Protect is off
[    7.754637] sd 11:0:0:0: [sdh] Mode Sense: 47 00 10 08
[    7.756623] sd 11:0:0:0: [sdh] No Caching mode page found
[    7.756639] sd 11:0:0:0: [sdh] Assuming drive cache: write through
[    7.776877] scsi 11:0:0:1: Attached scsi generic sg9 type 13
[    7.870482]  sdh: sdh1
[    7.889706] sd 11:0:0:0: [sdh] Attached SCSI disk
[    7.931823] ata10: SATA link down (SStatus 0 SControl 300)

(and then, of course)

[    9.547004] md: md127 stopped.
[    9.559904] md127: detected capacity change from 0 to 2620129280
[    9.833720] md: md126 stopped.
[    9.847327] md/raid:md126: device sda4 operational as raid disk 0
[    9.857837] md/raid:md126: device sdf4 operational as raid disk 4
[    9.868167] md/raid:md126: device sdd4 operational as raid disk 3
[    9.878245] md/raid:md126: device sdc4 operational as raid disk 2
[    9.887941] md/raid:md126: device sdb4 operational as raid disk 1
[    9.897551] md/raid:md126: raid level 6 active with 5 out of 5 devices, algorithm 2
[    9.925899] md126: detected capacity change from 0 to 14520041472
[   10.265325] md: md125 stopped.
[   10.276577] md/raid:md125: device sda3 operational as raid disk 0
[   10.285798] md/raid:md125: device sdf3 operational as raid disk 4
[   10.294810] md/raid:md125: device sdd3 operational as raid disk 3
[   10.303631] md/raid:md125: device sdc3 operational as raid disk 2
[   10.312258] md/raid:md125: device sdb3 operational as raid disk 1
[   10.321129] md/raid:md125: raid level 6 active with 5 out of 5 devices, algorithm 2
[   10.329649] md125: detected capacity change from 0 to 30783378432

and then piles of noise as bcache initializes; but I'm betting I'll see
something quite different this time.

> But I've not seen any reports of problems elsewhere, so this is either
> new or unique to you I would think ...

I could believe either :)

-- 
NULL && (void)
