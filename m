From: Steven Dake <sdake@mvista.com>
Subject: Re: EIO AP-1680 ATA133 RAID PCI Controller
Date: Mon, 10 Feb 2003 10:32:56 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E47E248.3080006@mvista.com>
References: <3E4329CE.5020706@netscape.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E4329CE.5020706@netscape.net>
To: tk Voice <tkVoice@netscape.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tk,

Most of these "hardware" raid cards do not have an I/O processor, which 
(which is the definition of "hardware" raid).  They have a BIOS which 
translates and allows the RAID to be booted into the target OS.  Once in 
the target OS, their specific driver takes over the RAID task (so RAID 
is part of the driver instead of some higher level algorithm).

You might try the ataraid drivers and see if your's is supported.  The 
only advantage you get with these types of cards is that you can boot 
multiple OS'es with the same layout on the disk.

Thanks
-steve

tk Voice wrote:

> I was under the impression that these EIDE RAID cards were "hardware 
> RAID" as I see it this seems to just be a 2-Channel IDE controller 
> That I will have to set up as MD (Software RAID).
>
> Has anyone got one of these working as a hardware RAID controller 
> under LINUX ?
>
> Does anyone have any hints you can give me to get this working without 
> using "Software RAID" ?
>
> Here are the details of this controller:
>
> EIO (Extreme IO) is a division of InnoVISION (www.ivmm.com)
>
> They have a ATA RAID solution: "EIO AP-1680 ATA133 RAID PCI Controller"
> It can be viewed here: http://www.ivmm.com/eio/products_ap1680.html
>
> Which they claim is LINUX compatible
>
> It is based on Silicon Image's "Sil 0680 Ultra ATA133" chipset.
>
> Silicon Image "Sil 0680" chipset link is:
> http://siimage.cubik.com/products/sii0680.asp
>
> The Driver for this chipset is in the kernel source:
> CONFIG_BLK_DEV_CMD64X and CONFIG_BLK_DEV_CMD680
>
> Output from lspci -vvv is this:
> ---------------------------------------------------------------------------
> 00:09.0 RAID bus controller: CMD Technology Inc: Unknown device 0680 
> (rev 02)
>    Subsystem: Unknown device 1771:1680
>    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B-
>    Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR-
>    Latency: 32, cache line size 01
>    Interrupt: pin A routed to IRQ 12
>    Region 0: I/O ports at a000 [size=8]
>    Region 1: I/O ports at a400 [size=4]
>    Region 2: I/O ports at a800 [size=8]
>    Region 3: I/O ports at ac00 [size=4]
>    Region 4: I/O ports at b000 [size=16]
>    Region 5: Memory at df001000 (32-bit, non-prefetchable) [size=256]
>    Expansion ROM at <unassigned> [disabled] [size=512K]
>    Capabilities: [60] Power Management version 2
>            Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>            Status: D0 PME-Enable- DSel=0 DScale=2 PME-
> -----------------------------------------------------------------
>
> I have attached two(2) 40GB drives to this card one on each ide 
> channel both set as Master. I went into the controllers BIOS and made 
> configuration changes to reflect RAID 1 and built the set adding both 
> drives to it. Everything looks fine a boot time. The controllers BIOS 
> states two drives found combined as RAID 1 as 0x80. Under Window 98 I 
> only see one drive. Which is what I would expect.
>
> But after compiling these drivers into my LINUX kernel the system sees 
> my drives as 2 separate disks (I have an ATAPI CDROM drive on 
> Motherboard's 2nd-IDE channel) Here are my messages at boot time:
> ----------------------------------------------------------
> VP_IDE: IDE controller on PCI bus 00 dev 39
> VP_IDE: chipset revision 6
> VP_IDE: not 100% native mode: will probe irqs later
> VP_IDE: VIA vt82c686b (rev 40) IDE UDMA100 controller on pci00:07.1
> ide0: BM-DMA at 0x9000-0x9007, BIOS settings: hda:pio, hdb:pio
> ide1: BM-DMA at 0x9008-0x900f, BIOS settings: hdc:pio, hdd:DMA
> PCI: Found IRQ 12 for device 00:09.0
> CMD680: chipset revision 2
> CMD680: not 100% native mode: will probe irqs later
> ide2: BM-DMA at 0xb000-0xb007, BIOS settings: hde:pio, hdf:pio
> ide3: BM-DMA at 0xb008-0xb00f, BIOS settings: hdg:pio, hdh:pio
> hdd: CD-ROM 56X/AKH, ATAPI CD/DVD-ROM drive
> hde: WDC WD400AB-00BVA0, ATA DISK drive
> hdg: WDC WD400AB-00BVA0, ATA DISK drive
> ide1 at 0x170-0x177,0x376 on irq 15
> ide2 at 0xa000-0xa007,0xa402 on irq 12
> ide3 at 0xa800-0xa807,0xac02 on irq 12
> blk: queue c02c766c, I/O limit 4095Mb (mask 0xffffffff)
> hde: 78165360 sectors (40021 MB) w/2048KiB Cache, CHS=77545/16/63, 
> UDMA(100)
> blk: queue c02c79d0, I/O limit 4095Mb (mask 0xffffffff)
> hdg: 78165360 sectors (40021 MB) w/2048KiB Cache, CHS=77545/16/63, 
> UDMA(100)
> Partition check:
> hde: [PTBL] [4865/255/63] hde1 hde2 hde3
> hdg: [PTBL] [4865/255/63] hdg1 hdg2 hdg3
> --------------------------------------------------------------------
>
> Thanks
>
> Peter
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>

