From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: [sucess?] upgrading LSI SAS9211-8i fw IR->IT
Date: Sat, 28 Oct 2017 10:09:34 +1100
Message-ID: <19b2182e-dca2-512a-6d20-c2664857f0b9@eyal.emu.id.au>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
 <f268a7a1-6a73-8c9f-b4c8-1e8190f54850@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f268a7a1-6a73-8c9f-b4c8-1e8190f54850@eyal.emu.id.au>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/10/17 14:31, Eyal Lebedinsky wrote:

[trimmed fw upgrade notes]

> As a final test I plan to boot the actual server with this card and 3 sacrificial
> disks (now all zeroed) attached, to confirm that nothing is written to the disks.

I installed the card with three disks that were zeroed and booted a fedora 26. I saw the disks OK.
I rebooted the machine (removing the disks) and then checked all disks and they were still zeroed.

I am ready to commission this controller after next week's backup, but would still like answers to
some questions.

Q1) I did not flash a rom file, do I need to do so (with the IT fw)?

Q2) The upgrade changed the SAS Address, should I reprogram the original address?

Q3) Below are the relevant messages from the test, do they look good?
     Is the "overriding NVDATA EEDPTagMode setting" OK?

cheers
	Eyal

kernel: mpt3sas version 15.100.00.00 loaded
kernel: mpt3sas 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
kernel: mpt2sas_cm0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (8162760 kB)
kernel: mpt2sas_cm0: MSI-X vectors supported: 1, no of cores: 4, max_msix_vectors: -1
kernel: mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 30
kernel: mpt2sas_cm0: iomem(0x00000000f1040000), mapped(0xffffb20541444000), size(16384)
kernel: mpt2sas_cm0: ioport(0x000000000000b000), size(256)
kernel: mpt2sas_cm0: Allocated physical memory: size(7579 kB)
kernel: mpt2sas_cm0: Current Controller Queue Depth(3364),Max Controller Queue Depth(3432)
kernel: mpt2sas_cm0: Scatter Gather Elements per IO(128)
kernel: mpt2sas_cm0: overriding NVDATA EEDPTagMode setting
kernel: mpt2sas_cm0: LSISAS2008: FWVersion(20.00.07.00), ChipRevision(0x03), BiosVersion(00.00.00.00)
kernel: mpt2sas_cm0: Protocol=(
kernel: Initiator
kernel: ,Target
kernel: ),
kernel: Capabilities=(
kernel: TLR
kernel: ,EEDP
kernel: ,Snapshot Buffer
kernel: ,Diag Trace Buffer
kernel: ,Task Set Full
kernel: ,NCQ
kernel: )
kernel: scsi host8: Fusion MPT SAS Host
kernel: mpt2sas_cm0: sending port enable !!
kernel: mpt2sas_cm0: host_add: handle(0x0001), sas_addr(0x500605b0013ca580), phys(8)
kernel: scsi 8:0:0:0: Direct-Access     ATA      SAMSUNG HD400LJ  0-15 PQ: 0 ANSI: 6
kernel: scsi 8:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221101000000), phy(1), device_name(0x0000000000000000)
kernel: scsi 8:0:0:0: SATA: enclosure_logical_id(0x500605b0013ca580), slot(2)
kernel: scsi 8:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
kernel: scsi 8:0:1:0: Direct-Access     ATA      SAMSUNG HD401LJ  0-15 PQ: 0 ANSI: 6
kernel: scsi 8:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221102000000), phy(2), device_name(0x0000000000000000)
kernel: scsi 8:0:1:0: SATA: enclosure_logical_id(0x500605b0013ca580), slot(1)
kernel: scsi 8:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
kernel: scsi 8:0:2:0: Direct-Access     ATA      WDC WD3200JD-00K 5J08 PQ: 0 ANSI: 6
kernel: scsi 8:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221103000000), phy(3), device_name(0x0000000000000000)
kernel: scsi 8:0:2:0: SATA: enclosure_logical_id(0x500605b0013ca580), slot(0)
kernel: scsi 8:0:2:0: atapi(n), ncq(n), asyn_notify(n), smart(y), fua(n), sw_preserve(n)
kernel: mpt2sas_cm0: port enable: SUCCESS
kernel: sd 8:0:0:0: Attached scsi generic sg10 type 0
kernel: sd 8:0:1:0: Attached scsi generic sg11 type 0
kernel: sd 8:0:2:0: Attached scsi generic sg12 type 0
kernel: sd 8:0:2:0: [sdl] 625140335 512-byte logical blocks: (320 GB/298 GiB)
kernel: sd 8:0:0:0: [sdj] 781422768 512-byte logical blocks: (400 GB/373 GiB)
kernel: sd 8:0:1:0: [sdk] 781422768 512-byte logical blocks: (400 GB/373 GiB)
kernel: sd 8:0:2:0: [sdl] Write Protect is off
kernel: sd 8:0:2:0: [sdl] Write cache: enabled, read cache: enabled, supports DPO and FUA
kernel: sd 8:0:0:0: [sdj] Write Protect is off
kernel: sd 8:0:2:0: [sdl] Attached SCSI disk
kernel: sd 8:0:0:0: [sdj] Write cache: enabled, read cache: enabled, supports DPO and FUA
kernel: sd 8:0:1:0: [sdk] Write Protect is off
kernel: sd 8:0:1:0: [sdk] Write cache: enabled, read cache: enabled, supports DPO and FUA
kernel: sd 8:0:0:0: [sdj] Attached SCSI disk
kernel: sd 8:0:1:0: [sdk] Attached SCSI disk

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
