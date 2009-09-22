From: Lee Howard <faxguy@howardsilvan.com>
Subject: Re: md data-check causes soft lockup
Date: Tue, 22 Sep 2009 07:43:50 -0700
Message-ID: <4AB8E2A6.2020800@howardsilvan.com>
References: <4AB7C11E.60801@howardsilvan.com> <70ed7c3e0909211154y3e4abcadyf76822e60127dfad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909211154y3e4abcadyf76822e60127dfad@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Majed,

I've looked at the patch and it modifies md/raid5.c.  However, I'm using 
RAID1.  Am I ignorant for doubting that the patch to raid5.c has any 
affect on RAID1?

Thanks,

Lee.


Majed B. wrote:
> Hello,
>
> Check out the thread with the subject: BUG: soft lockup in [md4_raid5:21137]
>
> I think the guys have already fixed this in 2.6.32. The patch is
> mentioned in one of the replies, if you wish to try it.
>
> On Mon, Sep 21, 2009 at 9:08 PM, Lee Howard <faxguy@howardsilvan.com> wrote:
>   
>> Linux software RAID maintainers and developers,
>>
>> Two months ago I wrote to the Linux kernel mailing list regarding a
>> condition expressed as "BUG: soft lockup - CPU#3 stuck for 61s!".  I
>> initially battled this recurring problem in both Fedora 10 and Fedora 11.
>>  Rafael J. Wysocki suggested that I update the kernel (to 2.6.31-rc4 or
>> later) and see if the problem resurfaced.  I then used kernel
>> 2.6.31-0.94.rc4.fc12.x86_64 and found that the problem still continued, but
>> noticeably only when the md data-check process was run.
>>
>> You can read the last post to the LKML thread (with links to the entire
>> thread) here:
>>
>> http://lkml.org/lkml/2009/8/6/387
>>
>> The md data-check is being run in Fedora 11 by /etc/cron.weekly/raid-check
>> which is a little shell script that looks like this:
>>
>> ------------------------------------------------------
>> #!/bin/bash
>>
>> for dev in `grep "^md.*: active" /proc/mdstat | cut -f 1 -d ' '`; do
>>       [ -f /sys/block/$dev/md/sync_action ] && \
>>               echo "check" > /sys/block/$dev/md/sync_action
>> done
>> ------------------------------------------------------
>>
>> I have disabled this weekly data-check, and since doing so have not
>> encountered any soft lockup (or any other problem, for that matter).
>>
>> For reference, you can see in this thread here that I am not the only one to
>> have this problem:
>>
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/212684
>>
>> It may important to note that I am running a 4-disk RAID1 array on 500GB
>> Western-Digial SATA drives.  I've attached the output of 'lspci -vv' as
>> "lspci.out".  I've attached the output of 'hdparm -I /dev/sda' as
>> "hdparm.out".  /dev/sda, /dev/sdb, /dev/sdc, and /dev/sdd are all identical
>> drive types.  I've attached the output of 'for i in 0 1 2; do mdadm --detail
>> /dev/md$i; done' as "mdadm.out".
>>
>> Please let me know if this is a configuration problem, a kernel bug, or
>> something else.  Please let me know how to fix this problem so that I can
>> safely re-enable md data-check.
>>
>> Thanks,
>>
>> Lee.
>>
>> 00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a2)
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR+ FastB2B- DisINTx-
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Capabilities: [44] HyperTransport: Slave or Primary Interface
>>                Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
>>                Link Control 0: CFlE+ CST- CFE- <LkFail- Init+ EOC- TXO-
>> <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
>>                Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut-
>> LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
>>                Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+
>> <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
>>                Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit
>> DwFcInEn- LWO=8bit DwFcOutEn-
>>                Revision ID: 1.03
>>                Link Frequency 0: 1.0GHz
>>                Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
>>                Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+
>> 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>>                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA-
>> UIDRD-
>>                Link Frequency 1: 200MHz
>>                Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
>>                Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz-
>> 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>>                Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE-
>> SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
>>                Prefetchable memory behind bridge Upper: 00-00
>>                Bus Number: 00
>>        Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
>>                Mapping Address Base: 00000000fee00000
>>
>> 00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a3)
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Region 0: I/O ports at 2f00 [size=128]
>>
>> 00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a3)
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Interrupt: pin A routed to IRQ 10
>>        Region 0: I/O ports at dc00 [size=64]
>>        Region 4: I/O ports at 2d00 [size=64]
>>        Region 5: I/O ports at 2e00 [size=64]
>>        Capabilities: [44] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot+,D3cold+)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Kernel driver in use: nForce2_smbus
>>        Kernel modules: i2c-nforce2
>>
>> 00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1)
>> (prog-if 10 [OHCI])
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0 (750ns min, 250ns max)
>>        Interrupt: pin A routed to IRQ 22
>>        Region 0: Memory at feafb000 (32-bit, non-prefetchable) [size=4K]
>>        Capabilities: [44] Power Management version 2
>>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Kernel driver in use: ohci_hcd
>>
>> 00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2)
>> (prog-if 20 [EHCI])
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0 (750ns min, 250ns max)
>>        Interrupt: pin B routed to IRQ 23
>>        Region 0: Memory at feafac00 (32-bit, non-prefetchable) [size=256]
>>        Capabilities: [44] Debug port: BAR=1 offset=0098
>>        Capabilities: [80] Power Management version 2
>>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Kernel driver in use: ehci_hcd
>>
>> 00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1) (prog-if 8a
>> [Master SecP PriP])
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0 (750ns min, 250ns max)
>>        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
>> [size=8]
>>        Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
>> [size=1]
>>        Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable)
>> [size=8]
>>        Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
>> [size=1]
>>        Region 4: I/O ports at ffa0 [size=16]
>>        Capabilities: [44] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Kernel driver in use: pata_amd
>>        Kernel modules: ata_generic, pata_acpi, pata_amd
>>
>> 00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
>> (prog-if 85 [Master SecO PriO])
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0 (750ns min, 250ns max)
>>        Interrupt: pin A routed to IRQ 21
>>        Region 0: I/O ports at d480 [size=8]
>>        Region 1: I/O ports at d400 [size=4]
>>        Region 2: I/O ports at d080 [size=8]
>>        Region 3: I/O ports at d000 [size=4]
>>        Region 4: I/O ports at cc00 [size=16]
>>        Region 5: Memory at feaf9000 (32-bit, non-prefetchable) [size=4K]
>>        Capabilities: [44] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Capabilities: [b0] MSI: Mask- 64bit+ Count=1/4 Enable-
>>                Address: 0000000000000000  Data: 0000
>>        Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
>>        Kernel driver in use: sata_nv
>>        Kernel modules: ata_generic, pata_acpi, sata_nv
>>
>> 00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
>> (prog-if 85 [Master SecO PriO])
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0 (750ns min, 250ns max)
>>        Interrupt: pin B routed to IRQ 20
>>        Region 0: I/O ports at c880 [size=8]
>>        Region 1: I/O ports at c800 [size=4]
>>        Region 2: I/O ports at c480 [size=8]
>>        Region 3: I/O ports at c400 [size=4]
>>        Region 4: I/O ports at c080 [size=16]
>>        Region 5: Memory at feaf8000 (32-bit, non-prefetchable) [size=4K]
>>        Capabilities: [44] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Capabilities: [b0] MSI: Mask- 64bit+ Count=1/4 Enable-
>>                Address: 0000000000000000  Data: 0000
>>        Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
>>        Kernel driver in use: sata_nv
>>        Kernel modules: ata_generic, pata_acpi, sata_nv
>>
>> 00:05.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3)
>> (prog-if 85 [Master SecO PriO])
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0 (750ns min, 250ns max)
>>        Interrupt: pin C routed to IRQ 23
>>        Region 0: I/O ports at c000 [size=8]
>>        Region 1: I/O ports at bc00 [size=4]
>>        Region 2: I/O ports at b880 [size=8]
>>        Region 3: I/O ports at b800 [size=4]
>>        Region 4: I/O ports at b480 [size=16]
>>        Region 5: Memory at feaf7000 (32-bit, non-prefetchable) [size=4K]
>>        Capabilities: [44] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Capabilities: [b0] MSI: Mask- 64bit+ Count=1/4 Enable-
>>                Address: 0000000000000000  Data: 0000
>>        Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
>>        Kernel driver in use: sata_nv
>>        Kernel modules: ata_generic, pata_acpi, sata_nv
>>
>> 00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2) (prog-if 01
>> [Subtractive decode])
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0
>>        Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
>>        I/O behind bridge: 0000e000-0000efff
>>        Memory behind bridge: feb00000-febfffff
>>        Prefetchable memory behind bridge: f8000000-fbffffff
>>        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- <SERR- <PERR-
>>        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>>                PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
>>        Capabilities: [b8] Subsystem: nVidia Corporation Device cb84
>>        Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
>>                Mapping Address Base: 00000000fee00000
>>
>> 00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0 (250ns min, 5000ns max)
>>        Interrupt: pin A routed to IRQ 30
>>        Region 0: Memory at feaf6000 (32-bit, non-prefetchable) [size=4K]
>>        Region 1: I/O ports at b400 [size=8]
>>        Region 2: Memory at feafa800 (32-bit, non-prefetchable) [size=256]
>>        Region 3: Memory at feafa400 (32-bit, non-prefetchable) [size=16]
>>        Capabilities: [44] Power Management version 2
>>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
>>        Capabilities: [70] MSI-X: Enable- Mask- TabSize=8
>>                Vector table: BAR=2 offset=00000000
>>                PBA: BAR=3 offset=00000000
>>        Capabilities: [50] MSI: Mask+ 64bit+ Count=1/8 Enable+
>>                Address: 00000000fee0400c  Data: 4199
>>                Masking: 000000fe  Pending: 00000000
>>        Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
>>        Kernel driver in use: forcedeth
>>        Kernel modules: forcedeth
>>
>> 00:09.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
>>        Subsystem: nVidia Corporation Device cb84
>>        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0 (250ns min, 5000ns max)
>>        Interrupt: pin A routed to IRQ 31
>>        Region 0: Memory at feaf5000 (32-bit, non-prefetchable) [size=4K]
>>        Region 1: I/O ports at b080 [size=8]
>>        Region 2: Memory at feafa000 (32-bit, non-prefetchable) [size=256]
>>        Region 3: Memory at feaf4c00 (32-bit, non-prefetchable) [size=16]
>>        Capabilities: [44] Power Management version 2
>>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
>>        Capabilities: [70] MSI-X: Enable- Mask- TabSize=8
>>                Vector table: BAR=2 offset=00000000
>>                PBA: BAR=3 offset=00000000
>>        Capabilities: [50] MSI: Mask+ 64bit+ Count=1/8 Enable+
>>                Address: 00000000fee0200c  Data: 41a1
>>                Masking: 000000fe  Pending: 00000000
>>        Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
>>        Kernel driver in use: forcedeth
>>        Kernel modules: forcedeth
>>
>> 00:0a.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
>> (prog-if 00 [Normal decode])
>>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0, Cache Line Size: 64 bytes
>>        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- <SERR- <PERR-
>>        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>        Capabilities: [40] Subsystem: nVidia Corporation Device 0000
>>        Capabilities: [48] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Capabilities: [50] MSI: Mask- 64bit+ Count=1/2 Enable+
>>                Address: 00000000fee0f00c  Data: 4149
>>        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>>                Mapping Address Base: 00000000fee00000
>>        Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
>>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
>> L1 <1us
>>                        ExtTag- RBE+ FLReset-
>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>> TransPend-
>>                LnkCap: Port #5, Speed 2.5GT/s, Width x8, ASPM L0s L1,
>> Latency L0 <512ns, L1 <4us
>>                        ClockPM- Surprise- LLActRep+ BwNot-
>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
>> CommClk-
>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+
>> DLActive- BWMgmt- ABWMgmt-
>>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surpise-
>>                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
>>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>> HPIrq- LinkChg-
>>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>> Interlock-
>>                        Changed: MRL- PresDet- LinkState-
>>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>                RootCap: CRSVisible-
>>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>        Capabilities: [100] Virtual Channel <?>
>>        Kernel driver in use: pcieport-driver
>>        Kernel modules: shpchp
>>
>> 00:0b.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
>> (prog-if 00 [Normal decode])
>>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0, Cache Line Size: 64 bytes
>>        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- <SERR- <PERR-
>>        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>        Capabilities: [40] Subsystem: nVidia Corporation Device 0000
>>        Capabilities: [48] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Capabilities: [50] MSI: Mask- 64bit+ Count=1/2 Enable+
>>                Address: 00000000fee0f00c  Data: 4151
>>        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>>                Mapping Address Base: 00000000fee00000
>>        Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
>>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
>> L1 <1us
>>                        ExtTag- RBE+ FLReset-
>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>> TransPend-
>>                LnkCap: Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>> Latency L0 <512ns, L1 <4us
>>                        ClockPM- Surprise- LLActRep+ BwNot-
>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
>> CommClk-
>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+
>> DLActive- BWMgmt- ABWMgmt-
>>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surpise-
>>                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
>>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>> HPIrq- LinkChg-
>>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>> Interlock-
>>                        Changed: MRL- PresDet- LinkState-
>>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>                RootCap: CRSVisible-
>>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>        Capabilities: [100] Virtual Channel <?>
>>        Kernel driver in use: pcieport-driver
>>        Kernel modules: shpchp
>>
>> 00:0c.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
>> (prog-if 00 [Normal decode])
>>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0, Cache Line Size: 64 bytes
>>        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
>>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- <SERR- <PERR-
>>        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>        Capabilities: [40] Subsystem: nVidia Corporation Device 0000
>>        Capabilities: [48] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Capabilities: [50] MSI: Mask- 64bit+ Count=1/2 Enable+
>>                Address: 00000000fee0f00c  Data: 4159
>>        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>>                Mapping Address Base: 00000000fee00000
>>        Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
>>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
>> L1 <1us
>>                        ExtTag- RBE+ FLReset-
>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>> TransPend-
>>                LnkCap: Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>> Latency L0 <512ns, L1 <4us
>>                        ClockPM- Surprise- LLActRep+ BwNot-
>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
>> CommClk-
>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+
>> DLActive- BWMgmt- ABWMgmt-
>>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surpise-
>>                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
>>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>> HPIrq- LinkChg-
>>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>> Interlock-
>>                        Changed: MRL- PresDet- LinkState-
>>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>                RootCap: CRSVisible-
>>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>        Capabilities: [100] Virtual Channel <?>
>>        Kernel driver in use: pcieport-driver
>>        Kernel modules: shpchp
>>
>> 00:0d.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
>> (prog-if 00 [Normal decode])
>>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0, Cache Line Size: 64 bytes
>>        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
>>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- <SERR- <PERR-
>>        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>        Capabilities: [40] Subsystem: nVidia Corporation Device 0000
>>        Capabilities: [48] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Capabilities: [50] MSI: Mask- 64bit+ Count=1/2 Enable+
>>                Address: 00000000fee0f00c  Data: 4161
>>        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>>                Mapping Address Base: 00000000fee00000
>>        Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
>>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
>> L1 <1us
>>                        ExtTag- RBE+ FLReset-
>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>> TransPend-
>>                LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>> Latency L0 <512ns, L1 <4us
>>                        ClockPM- Surprise- LLActRep+ BwNot-
>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
>> CommClk-
>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+
>> DLActive- BWMgmt- ABWMgmt-
>>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surpise-
>>                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
>>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>> HPIrq- LinkChg-
>>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>> Interlock-
>>                        Changed: MRL- PresDet- LinkState-
>>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>                RootCap: CRSVisible-
>>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>        Capabilities: [100] Virtual Channel <?>
>>        Kernel driver in use: pcieport-driver
>>        Kernel modules: shpchp
>>
>> 00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
>> (prog-if 00 [Normal decode])
>>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0, Cache Line Size: 64 bytes
>>        Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
>>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- <SERR- <PERR-
>>        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>        Capabilities: [40] Subsystem: nVidia Corporation Device 0000
>>        Capabilities: [48] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Capabilities: [50] MSI: Mask- 64bit+ Count=1/2 Enable+
>>                Address: 00000000fee0f00c  Data: 4169
>>        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>>                Mapping Address Base: 00000000fee00000
>>        Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
>>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
>> L1 <1us
>>                        ExtTag- RBE+ FLReset-
>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>> TransPend-
>>                LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1,
>> Latency L0 <512ns, L1 <4us
>>                        ClockPM- Surprise- LLActRep+ BwNot-
>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
>> CommClk-
>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk+
>> DLActive- BWMgmt- ABWMgmt-
>>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surpise-
>>                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
>>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>> HPIrq- LinkChg-
>>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>> Interlock-
>>                        Changed: MRL- PresDet- LinkState-
>>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>                RootCap: CRSVisible-
>>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>        Capabilities: [100] Virtual Channel <?>
>>        Kernel driver in use: pcieport-driver
>>        Kernel modules: shpchp
>>
>> 00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3)
>> (prog-if 00 [Normal decode])
>>        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Latency: 0, Cache Line Size: 64 bytes
>>        Bus: primary=00, secondary=07, subordinate=07, sec-latency=0
>>        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- <SERR- <PERR-
>>        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>>                PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>>        Capabilities: [40] Subsystem: nVidia Corporation Device 0000
>>        Capabilities: [48] Power Management version 2
>>                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>        Capabilities: [50] MSI: Mask- 64bit+ Count=1/2 Enable+
>>                Address: 00000000fee0f00c  Data: 4171
>>        Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
>>                Mapping Address Base: 00000000fee00000
>>        Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
>>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
>> L1 <1us
>>                        ExtTag- RBE+ FLReset-
>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>>                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>> TransPend-
>>                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1,
>> Latency L0 <512ns, L1 <4us
>>                        ClockPM- Surprise- LLActRep+ BwNot-
>>                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain-
>> CommClk-
>>                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+
>> DLActive- BWMgmt- ABWMgmt-
>>                SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>> Surpise-
>>                        Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
>>                SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>> HPIrq- LinkChg-
>>                        Control: AttnInd Off, PwrInd On, Power- Interlock-
>>                SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>> Interlock-
>>                        Changed: MRL- PresDet- LinkState-
>>                RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
>> CRSVisible-
>>                RootCap: CRSVisible-
>>                RootSta: PME ReqID 0000, PMEStatus- PMEPending-
>>        Capabilities: [100] Virtual Channel <?>
>>        Kernel driver in use: pcieport-driver
>>        Kernel modules: shpchp
>>
>> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
>> Athlon64, Sempron] HyperTransport Configuration
>>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Capabilities: [80] HyperTransport: Host or Secondary Interface
>>                Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+
>> Slave- <EOCErr- DUL-
>>                Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO-
>> <CRCErr=0 IsocEn- LSEn+ ExtCTL- 64b-
>>                Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
>> DwFcInEn- LWO=16bit DwFcOutEn-
>>                Revision ID: 3.00
>>                Link Frequency: 1.0GHz
>>                Link Error: <Prot- <Ovfl- <EOC- CTLTm-
>>                Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz-
>> 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
>>                Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+
>> UIDRD- ExtRS- UCnfE-
>>
>> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
>> Athlon64, Sempron] Address Map
>>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>
>> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
>> Athlon64, Sempron] DRAM Controller
>>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Kernel modules: amd64_edac_mod
>>
>> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
>> Athlon64, Sempron] Miscellaneous Control
>>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        Capabilities: [f0] Secure device <?>
>>
>> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron,
>> Athlon64, Sempron] Link Control
>>        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>
>> 01:0a.0 VGA compatible controller: XGI Technology Inc. (eXtreme Graphics
>> Innovation) Volari Z7/Z9/Z9s (prog-if 00 [VGA controller])
>>        Subsystem: XGI Technology Inc. (eXtreme Graphics Innovation) Volari
>> Z7/Z9/Z9s
>>        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
>> Stepping- SERR- FastB2B- DisINTx-
>>        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>        BIST result: 00
>>        Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
>>        Region 1: Memory at febc0000 (32-bit, non-prefetchable) [size=256K]
>>        Region 2: I/O ports at ec00 [size=128]
>>        Expansion ROM at <unassigned> [disabled]
>>        Capabilities: [40] Power Management version 2
>>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>>
>>
>>
>> /dev/sda:
>>
>> ATA device, with non-removable media
>>        Model Number:       WDC WD5000AAKS-00A7B2
>>        Serial Number:      WD-WCASZ0321108
>>        Firmware Revision:  01.03B01
>>        Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev
>> 2.5
>> Standards:
>>        Supported: 8 7 6 5
>>        Likely used: 8
>> Configuration:
>>        Logical         max     current
>>        cylinders       16383   16383
>>        heads           16      16
>>        sectors/track   63      63
>>        --
>>        CHS current addressable sectors:   16514064
>>        LBA    user addressable sectors:  268435455
>>        LBA48  user addressable sectors:  976773168
>>        Logical/Physical Sector size:           512 bytes
>>        device size with M = 1024*1024:      476940 MBytes
>>        device size with M = 1000*1000:      500107 MBytes (500 GB)
>>        cache/buffer size  = 16384 KBytes
>> Capabilities:
>>        LBA, IORDY(can be disabled)
>>        Queue depth: 32
>>        Standby timer values: spec'd by Standard, with device specific
>> minimum
>>        R/W multiple sector transfer: Max = 16  Current = 16
>>        Recommended acoustic management value: 128, current value: 254
>>        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
>>             Cycle time: min=120ns recommended=120ns
>>        PIO: pio0 pio1 pio2 pio3 pio4
>>             Cycle time: no flow control=120ns  IORDY flow control=120ns
>> Commands/features:
>>        Enabled Supported:
>>           *    SMART feature set
>>                Security Mode feature set
>>           *    Power Management feature set
>>           *    Write cache
>>           *    Look-ahead
>>           *    Host Protected Area feature set
>>           *    WRITE_BUFFER command
>>           *    READ_BUFFER command
>>           *    NOP cmd
>>           *    DOWNLOAD_MICROCODE
>>                Power-Up In Standby feature set
>>           *    SET_FEATURES required to spinup after power up
>>                SET_MAX security extension
>>                Automatic Acoustic Management feature set
>>           *    48-bit Address feature set
>>           *    Device Configuration Overlay feature set
>>           *    Mandatory FLUSH_CACHE
>>           *    FLUSH_CACHE_EXT
>>           *    SMART error logging
>>           *    SMART self-test
>>           *    General Purpose Logging feature set
>>           *    64-bit World wide name
>>           *    Segmented DOWNLOAD_MICROCODE
>>           *    Gen1 signaling speed (1.5Gb/s)
>>           *    Gen2 signaling speed (3.0Gb/s)
>>           *    Native Command Queueing (NCQ)
>>           *    Host-initiated interface power management
>>           *    Phy event counters
>>                DMA Setup Auto-Activate optimization
>>           *    Software settings preservation
>>           *    SMART Command Transport (SCT) feature set
>>           *    SCT Long Sector Access (AC1)
>>           *    SCT LBA Segment Access (AC2)
>>           *    SCT Error Recovery Control (AC3)
>>           *    SCT Features Control (AC4)
>>           *    SCT Data Tables (AC5)
>>                unknown 206[12] (vendor specific)
>>                unknown 206[13] (vendor specific)
>> Security:
>>        Master password revision code = 65534
>>                supported
>>        not     enabled
>>        not     locked
>>                frozen
>>        not     expired: security count
>>                supported: enhanced erase
>>        84min for SECURITY ERASE UNIT. 84min for ENHANCED SECURITY ERASE
>> UNIT.
>> Logical Unit WWN Device Identifier: 50014ee101cedc24
>>        NAA             : 5
>>        IEEE OUI        : 0014ee
>>        Unique ID       : 101cedc24
>> Checksum: correct
>>
>> /dev/md0:
>>        Version : 0.90
>>  Creation Time : Mon Jul 27 22:38:26 2009
>>     Raid Level : raid1
>>     Array Size : 102336 (99.95 MiB 104.79 MB)
>>  Used Dev Size : 102336 (99.95 MiB 104.79 MB)
>>   Raid Devices : 4
>>  Total Devices : 4
>> Preferred Minor : 0
>>    Persistence : Superblock is persistent
>>
>>    Update Time : Mon Sep 21 11:02:14 2009
>>          State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>  Spare Devices : 0
>>
>>           UUID : 9037def2:035b0d10:bfe78010:bc810f04
>>         Events : 0.44
>>
>>    Number   Major   Minor   RaidDevice State
>>       0       8        1        0      active sync   /dev/sda1
>>       1       8       17        1      active sync   /dev/sdb1
>>       2       8       33        2      active sync   /dev/sdc1
>>       3       8       49        3      active sync   /dev/sdd1
>> /dev/md1:
>>        Version : 0.90
>>  Creation Time : Mon Jul 27 22:38:28 2009
>>     Raid Level : raid1
>>     Array Size : 4095936 (3.91 GiB 4.19 GB)
>>  Used Dev Size : 4095936 (3.91 GiB 4.19 GB)
>>   Raid Devices : 4
>>  Total Devices : 4
>> Preferred Minor : 1
>>    Persistence : Superblock is persistent
>>
>>    Update Time : Mon Sep 21 11:02:14 2009
>>          State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>  Spare Devices : 0
>>
>>           UUID : 642c2833:bf033a7d:bfe78010:bc810f04
>>         Events : 0.44
>>
>>    Number   Major   Minor   RaidDevice State
>>       0       8        2        0      active sync   /dev/sda2
>>       1       8       18        1      active sync   /dev/sdb2
>>       2       8       34        2      active sync   /dev/sdc2
>>       3       8       50        3      active sync   /dev/sdd2
>> /dev/md2:
>>        Version : 0.90
>>  Creation Time : Mon Jul 27 22:38:30 2009
>>     Raid Level : raid1
>>     Array Size : 484185536 (461.76 GiB 495.81 GB)
>>  Used Dev Size : 484185536 (461.76 GiB 495.81 GB)
>>   Raid Devices : 4
>>  Total Devices : 4
>> Preferred Minor : 2
>>    Persistence : Superblock is persistent
>>
>>    Update Time : Mon Sep 21 11:02:24 2009
>>          State : clean
>>  Active Devices : 4
>> Working Devices : 4
>>  Failed Devices : 0
>>  Spare Devices : 0
>>
>>           UUID : ce106d52:0c0373f7:bfe78010:bc810f04
>>         Events : 0.66
>>
>>    Number   Major   Minor   RaidDevice State
>>       0       8        3        0      active sync   /dev/sda3
>>       1       8       19        1      active sync   /dev/sdb3
>>       2       8       35        2      active sync   /dev/sdc3
>>       3       8       51        3      active sync   /dev/sdd3
>>
>>
>>     
>
>
>
>   

