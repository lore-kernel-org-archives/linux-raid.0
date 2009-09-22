From: "Majed B." <majedb@gmail.com>
Subject: Re: md data-check causes soft lockup
Date: Tue, 22 Sep 2009 18:13:31 +0300
Message-ID: <70ed7c3e0909220813t44d97414xdd4ee050f2e1c75e@mail.gmail.com>
References: <4AB7C11E.60801@howardsilvan.com> <70ed7c3e0909211154y3e4abcadyf76822e60127dfad@mail.gmail.com>
	<4AB8E2A6.2020800@howardsilvan.com> <70ed7c3e0909220748y2e151ebv7f232cf2b7c79617@mail.gmail.com>
	<4AB8E661.8080706@howardsilvan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AB8E661.8080706@howardsilvan.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lee Howard <faxguy@howardsilvan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Have you tried attaching the checking process to a specific CPU/Core?
It's called Affinity.

Also, did you try to reduce the numbers in: /proc/sys/dev/raid/speed_li=
mit_min

Keep it as low as possible, and md should drop to that number (I think
it's in kB) when the system is being utilized, then go back to
/proc/sys/dev/raid/speed_limit_max when it's idle.

On Tue, Sep 22, 2009 at 5:59 PM, Lee Howard <faxguy@howardsilvan.com> w=
rote:
> Majed B. wrote:
>>
>> I must have missed that part. It may not work for your case, but wor=
th
>> trying.
>>
>> Perhaps Neil Brown, or someone involved could shed some light on thi=
s.
>>
>> If I remember correctly, those soft lockups were harmless anyway.
>>
>
> Not harmless for production use. =C2=A0Yes, data is not harmed, and y=
es, the
> problem state does recover when the data-check finishes, but during t=
he
> data-check the system is virtually unresponsive and all other use of =
the
> system is stalled.
>
> Thanks,
>
> Lee.
>
>> On Tue, Sep 22, 2009 at 5:43 PM, Lee Howard <faxguy@howardsilvan.com=
>
>> wrote:
>>
>>>
>>> Thanks Majed,
>>>
>>> I've looked at the patch and it modifies md/raid5.c. =C2=A0However,=
 I'm using
>>> RAID1. =C2=A0Am I ignorant for doubting that the patch to raid5.c h=
as any
>>> affect
>>> on RAID1?
>>>
>>> Thanks,
>>>
>>> Lee.
>>>
>>>
>>> Majed B. wrote:
>>>
>>>>
>>>> Hello,
>>>>
>>>> Check out the thread with the subject: BUG: soft lockup in
>>>> [md4_raid5:21137]
>>>>
>>>> I think the guys have already fixed this in 2.6.32. The patch is
>>>> mentioned in one of the replies, if you wish to try it.
>>>>
>>>> On Mon, Sep 21, 2009 at 9:08 PM, Lee Howard <faxguy@howardsilvan.c=
om>
>>>> wrote:
>>>>
>>>>
>>>>>
>>>>> Linux software RAID maintainers and developers,
>>>>>
>>>>> Two months ago I wrote to the Linux kernel mailing list regarding=
 a
>>>>> condition expressed as "BUG: soft lockup - CPU#3 stuck for 61s!".=
 =C2=A0I
>>>>> initially battled this recurring problem in both Fedora 10 and Fe=
dora
>>>>> 11.
>>>>> =C2=A0Rafael J. Wysocki suggested that I update the kernel (to 2.=
6.31-rc4 or
>>>>> later) and see if the problem resurfaced. =C2=A0I then used kerne=
l
>>>>> 2.6.31-0.94.rc4.fc12.x86_64 and found that the problem still cont=
inued,
>>>>> but
>>>>> noticeably only when the md data-check process was run.
>>>>>
>>>>> You can read the last post to the LKML thread (with links to the =
entire
>>>>> thread) here:
>>>>>
>>>>> http://lkml.org/lkml/2009/8/6/387
>>>>>
>>>>> The md data-check is being run in Fedora 11 by
>>>>> /etc/cron.weekly/raid-check
>>>>> which is a little shell script that looks like this:
>>>>>
>>>>> ------------------------------------------------------
>>>>> #!/bin/bash
>>>>>
>>>>> for dev in `grep "^md.*: active" /proc/mdstat | cut -f 1 -d ' '`;=
 do
>>>>> =C2=A0 =C2=A0 [ -f /sys/block/$dev/md/sync_action ] && \
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo "check" > /sys/blo=
ck/$dev/md/sync_action
>>>>> done
>>>>> ------------------------------------------------------
>>>>>
>>>>> I have disabled this weekly data-check, and since doing so have n=
ot
>>>>> encountered any soft lockup (or any other problem, for that matte=
r).
>>>>>
>>>>> For reference, you can see in this thread here that I am not the =
only
>>>>> one
>>>>> to
>>>>> have this problem:
>>>>>
>>>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/212684
>>>>>
>>>>> It may important to note that I am running a 4-disk RAID1 array o=
n
>>>>> 500GB
>>>>> Western-Digial SATA drives. =C2=A0I've attached the output of 'ls=
pci -vv' as
>>>>> "lspci.out". =C2=A0I've attached the output of 'hdparm -I /dev/sd=
a' as
>>>>> "hdparm.out". =C2=A0/dev/sda, /dev/sdb, /dev/sdc, and /dev/sdd ar=
e all
>>>>> identical
>>>>> drive types. =C2=A0I've attached the output of 'for i in 0 1 2; d=
o mdadm
>>>>> --detail
>>>>> /dev/md$i; done' as "mdadm.out".
>>>>>
>>>>> Please let me know if this is a configuration problem, a kernel b=
ug, or
>>>>> something else. =C2=A0Please let me know how to fix this problem =
so that I
>>>>> can
>>>>> safely re-enable md data-check.
>>>>>
>>>>> Thanks,
>>>>>
>>>>> Lee.
>>>>>
>>>>> 00:00.0 RAM memory: nVidia Corporation MCP55 Memory Controller (r=
ev a2)
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem+ BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR+ FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [44] HyperTransport: Slave or P=
rimary Interface
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Command: BaseUnit=
ID=3D0 UnitCnt=3D15 MastHost- DefDir- DUL-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Control 0: C=
=46lE+ CST- CFE- <LkFail- Init+ EOC- TXO-
>>>>> <CRCErr=3D0 IsocEn- LSEn+ ExtCTL- 64b-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Config 0: ML=
WI=3D16bit DwFcIn- MLWO=3D16bit DwFcOut-
>>>>> LWI=3D16bit DwFcInEn- LWO=3D16bit DwFcOutEn-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Control 1: C=
=46lE- CST- CFE- <LkFail+ Init- EOC+ TXO+
>>>>> <CRCErr=3D0 IsocEn- LSEn- ExtCTL- 64b-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Config 1: ML=
WI=3D8bit DwFcIn- MLWO=3D8bit DwFcOut-
>>>>> LWI=3D8bit
>>>>> DwFcInEn- LWO=3D8bit DwFcOutEn-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Revision ID: 1.03
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Frequency 0:=
 1.0GHz
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Error 0: <Pr=
ot- <Ovfl- <EOC- CTLTm-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Frequency Ca=
pability 0: 200MHz+ 300MHz+ 400MHz+
>>>>> 500MHz+
>>>>> 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Feature Capabilit=
y: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA-
>>>>> UIDRD-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Frequency 1:=
 200MHz
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Error 1: <Pr=
ot- <Ovfl- <EOC- CTLTm-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Frequency Ca=
pability 1: 200MHz- 300MHz- 400MHz-
>>>>> 500MHz-
>>>>> 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Error Handling: P=
=46lE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE-
>>>>> SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Prefetchable memo=
ry behind bridge Upper: 00-00
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Bus Number: 00
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [dc] HyperTransport: MSI Mappin=
g Enable+ Fixed-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mapping Address B=
ase: 00000000fee00000
>>>>>
>>>>> 00:01.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a3)
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: I/O ports at 2f00 [size=3D128]
>>>>>
>>>>> 00:01.1 SMBus: nVidia Corporation MCP55 SMBus (rev a3)
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem- BusMaster- SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Interrupt: pin A routed to IRQ 10
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: I/O ports at dc00 [size=3D64]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 4: I/O ports at 2d00 [size=3D64]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 5: I/O ports at 2e00 [size=3D64]
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [44] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0-,D1-,D2-,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: nForce2_smbus
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: i2c-nforce2
>>>>>
>>>>> 00:02.0 USB Controller: nVidia Corporation MCP55 USB Controller (=
rev
>>>>> a1)
>>>>> (prog-if 10 [OHCI])
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0 (750ns min, 250ns max)
>>>>> =C2=A0 =C2=A0 =C2=A0Interrupt: pin A routed to IRQ 22
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: Memory at feafb000 (32-bit, non-pre=
fetchable) [size=3D4K]
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [44] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1+ D2+ AuxCurrent=3D0mA
>>>>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: ohci_hcd
>>>>>
>>>>> 00:02.1 USB Controller: nVidia Corporation MCP55 USB Controller (=
rev
>>>>> a2)
>>>>> (prog-if 20 [EHCI])
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem+ BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0 (750ns min, 250ns max)
>>>>> =C2=A0 =C2=A0 =C2=A0Interrupt: pin B routed to IRQ 23
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: Memory at feafac00 (32-bit, non-pre=
fetchable) [size=3D256]
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [44] Debug port: BAR=3D1 offset=
=3D0098
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [80] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1+ D2+ AuxCurrent=3D0mA
>>>>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: ehci_hcd
>>>>>
>>>>> 00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1) (pro=
g-if
>>>>> 8a
>>>>> [Master SecP PriP])
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem- BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0 (750ns min, 250ns max)
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: [virtual] Memory at 000001f0 (32-bi=
t, non-prefetchable)
>>>>> [size=3D8]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 1: [virtual] Memory at 000003f0 (type =
3, non-prefetchable)
>>>>> [size=3D1]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 2: [virtual] Memory at 00000170 (32-bi=
t, non-prefetchable)
>>>>> [size=3D8]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 3: [virtual] Memory at 00000370 (type =
3, non-prefetchable)
>>>>> [size=3D1]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 4: I/O ports at ffa0 [size=3D16]
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [44] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: pata_amd
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: ata_generic, pata_acpi, pata_=
amd
>>>>>
>>>>> 00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (=
rev
>>>>> a3)
>>>>> (prog-if 85 [Master SecO PriO])
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0 (750ns min, 250ns max)
>>>>> =C2=A0 =C2=A0 =C2=A0Interrupt: pin A routed to IRQ 21
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: I/O ports at d480 [size=3D8]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 1: I/O ports at d400 [size=3D4]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 2: I/O ports at d080 [size=3D8]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 3: I/O ports at d000 [size=3D4]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 4: I/O ports at cc00 [size=3D16]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 5: Memory at feaf9000 (32-bit, non-pre=
fetchable) [size=3D4K]
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [44] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [b0] MSI: Mask- 64bit+ Count=3D=
1/4 Enable-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
00000000 =C2=A0Data: 0000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [cc] HyperTransport: MSI Mappin=
g Enable- Fixed+
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: sata_nv
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: ata_generic, pata_acpi, sata_=
nv
>>>>>
>>>>> 00:05.1 IDE interface: nVidia Corporation MCP55 SATA Controller (=
rev
>>>>> a3)
>>>>> (prog-if 85 [Master SecO PriO])
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0 (750ns min, 250ns max)
>>>>> =C2=A0 =C2=A0 =C2=A0Interrupt: pin B routed to IRQ 20
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: I/O ports at c880 [size=3D8]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 1: I/O ports at c800 [size=3D4]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 2: I/O ports at c480 [size=3D8]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 3: I/O ports at c400 [size=3D4]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 4: I/O ports at c080 [size=3D16]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 5: Memory at feaf8000 (32-bit, non-pre=
fetchable) [size=3D4K]
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [44] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [b0] MSI: Mask- 64bit+ Count=3D=
1/4 Enable-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
00000000 =C2=A0Data: 0000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [cc] HyperTransport: MSI Mappin=
g Enable- Fixed+
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: sata_nv
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: ata_generic, pata_acpi, sata_=
nv
>>>>>
>>>>> 00:05.2 IDE interface: nVidia Corporation MCP55 SATA Controller (=
rev
>>>>> a3)
>>>>> (prog-if 85 [Master SecO PriO])
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0 (750ns min, 250ns max)
>>>>> =C2=A0 =C2=A0 =C2=A0Interrupt: pin C routed to IRQ 23
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: I/O ports at c000 [size=3D8]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 1: I/O ports at bc00 [size=3D4]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 2: I/O ports at b880 [size=3D8]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 3: I/O ports at b800 [size=3D4]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 4: I/O ports at b480 [size=3D16]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 5: Memory at feaf7000 (32-bit, non-pre=
fetchable) [size=3D4K]
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [44] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [b0] MSI: Mask- 64bit+ Count=3D=
1/4 Enable-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
00000000 =C2=A0Data: 0000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [cc] HyperTransport: MSI Mappin=
g Enable- Fixed+
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: sata_nv
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: ata_generic, pata_acpi, sata_=
nv
>>>>>
>>>>> 00:06.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2)
>>>>> (prog-if
>>>>> 01
>>>>> [Subtractive decode])
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0
>>>>> =C2=A0 =C2=A0 =C2=A0Bus: primary=3D00, secondary=3D01, subordinat=
e=3D01, sec-latency=3D64
>>>>> =C2=A0 =C2=A0 =C2=A0I/O behind bridge: 0000e000-0000efff
>>>>> =C2=A0 =C2=A0 =C2=A0Memory behind bridge: feb00000-febfffff
>>>>> =C2=A0 =C2=A0 =C2=A0Prefetchable memory behind bridge: f8000000-f=
bffffff
>>>>> =C2=A0 =C2=A0 =C2=A0Secondary status: 66MHz- FastB2B+ ParErr- DEV=
SEL=3Dmedium >TAbort-
>>>>> <TAbort- <MAbort- <SERR- <PERR-
>>>>> =C2=A0 =C2=A0 =C2=A0BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- =
>Reset- FastB2B-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PriDiscTmr- SecDi=
scTmr+ DiscTmrStat- DiscTmrSERREn-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [b8] Subsystem: nVidia Corporat=
ion Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [8c] HyperTransport: MSI Mappin=
g Enable- Fixed-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mapping Address B=
ase: 00000000fee00000
>>>>>
>>>>> 00:08.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx+
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0 (250ns min, 5000ns max)
>>>>> =C2=A0 =C2=A0 =C2=A0Interrupt: pin A routed to IRQ 30
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: Memory at feaf6000 (32-bit, non-pre=
fetchable) [size=3D4K]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 1: I/O ports at b400 [size=3D8]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 2: Memory at feafa800 (32-bit, non-pre=
fetchable) [size=3D256]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 3: Memory at feafa400 (32-bit, non-pre=
fetchable) [size=3D16]
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [44] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1+ D2+ AuxCurrent=3D0mA
>>>>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able+ DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [70] MSI-X: Enable- Mask- TabSi=
ze=3D8
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Vector table: BAR=
=3D2 offset=3D00000000
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PBA: BAR=3D3 offs=
et=3D00000000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [50] MSI: Mask+ 64bit+ Count=3D=
1/8 Enable+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
fee0400c =C2=A0Data: 4199
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Masking: 000000fe=
 =C2=A0Pending: 00000000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [6c] HyperTransport: MSI Mappin=
g Enable- Fixed+
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: forcedeth
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: forcedeth
>>>>>
>>>>> 00:09.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a3)
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: nVidia Corporation Device cb84
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx+
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0 (250ns min, 5000ns max)
>>>>> =C2=A0 =C2=A0 =C2=A0Interrupt: pin A routed to IRQ 31
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: Memory at feaf5000 (32-bit, non-pre=
fetchable) [size=3D4K]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 1: I/O ports at b080 [size=3D8]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 2: Memory at feafa000 (32-bit, non-pre=
fetchable) [size=3D256]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 3: Memory at feaf4c00 (32-bit, non-pre=
fetchable) [size=3D16]
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [44] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1+ D2+ AuxCurrent=3D0mA
>>>>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able+ DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [70] MSI-X: Enable- Mask- TabSi=
ze=3D8
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Vector table: BAR=
=3D2 offset=3D00000000
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PBA: BAR=3D3 offs=
et=3D00000000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [50] MSI: Mask+ 64bit+ Count=3D=
1/8 Enable+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
fee0200c =C2=A0Data: 41a1
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Masking: 000000fe=
 =C2=A0Pending: 00000000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [6c] HyperTransport: MSI Mappin=
g Enable- Fixed+
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: forcedeth
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: forcedeth
>>>>>
>>>>> 00:0a.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (=
rev
>>>>> a3)
>>>>> (prog-if 00 [Normal decode])
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx+
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0, Cache Line Size: 64 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0Bus: primary=3D00, secondary=3D02, subordinat=
e=3D02, sec-latency=3D0
>>>>> =C2=A0 =C2=A0 =C2=A0Secondary status: 66MHz- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- <SERR- <PERR-
>>>>> =C2=A0 =C2=A0 =C2=A0BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- =
>Reset- FastB2B-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PriDiscTmr- SecDi=
scTmr- DiscTmrStat- DiscTmrSERREn-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [40] Subsystem: nVidia Corporat=
ion Device 0000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [48] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [50] MSI: Mask- 64bit+ Count=3D=
1/2 Enable+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
fee0f00c =C2=A0Data: 4149
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [60] HyperTransport: MSI Mappin=
g Enable- Fixed-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mapping Address B=
ase: 00000000fee00000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [80] Express (v1) Root Port (Sl=
ot+), MSI 00
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCap: MaxPayloa=
d 256 bytes, PhantFunc 0, Latency L0s
>>>>> <64ns,
>>>>> L1 <1us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtTag- RBE+ FLReset-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCtl: Report er=
rors: Correctable- Non-Fatal- Fatal-
>>>>> Unsupported-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0MaxPayload 128 bytes, MaxReadReq 512 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevSta: CorrErr- =
UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>>>>> TransPend-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCap: Port #5, =
Speed 2.5GT/s, Width x8, ASPM L0s L1,
>>>>> Latency L0 <512ns, L1 <4us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ClockPM- Surprise- LLActRep+ BwNot-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCtl: ASPM Disa=
bled; RCB 64 bytes Disabled- Retrain-
>>>>> CommClk-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkSta: Speed 2.5=
GT/s, Width x8, TrErr- Train- SlotClk+
>>>>> DLActive- BWMgmt- ABWMgmt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCap: AttnBtn- =
PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>>>>> Surpise-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Slot # =C2=A00, PowerLimit 0.000000; Interlock-
>>>>> NoCompl-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCtl: Enable: A=
ttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>>>>> HPIrq- LinkChg-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Control: AttnInd Off, PwrInd On, Power- Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltSta: Status: A=
ttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>>>>> Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Changed: MRL- PresDet- LinkState-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCtl: ErrCorre=
ctable- ErrNon-Fatal- ErrFatal-
>>>>> PMEIntEna-
>>>>> CRSVisible-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCap: CRSVisib=
le-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootSta: PME ReqI=
D 0000, PMEStatus- PMEPending-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [100] Virtual Channel <?>
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: pcieport-driver
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: shpchp
>>>>>
>>>>> 00:0b.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (=
rev
>>>>> a3)
>>>>> (prog-if 00 [Normal decode])
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx+
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0, Cache Line Size: 64 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0Bus: primary=3D00, secondary=3D03, subordinat=
e=3D03, sec-latency=3D0
>>>>> =C2=A0 =C2=A0 =C2=A0Secondary status: 66MHz- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- <SERR- <PERR-
>>>>> =C2=A0 =C2=A0 =C2=A0BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- =
>Reset- FastB2B-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PriDiscTmr- SecDi=
scTmr- DiscTmrStat- DiscTmrSERREn-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [40] Subsystem: nVidia Corporat=
ion Device 0000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [48] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [50] MSI: Mask- 64bit+ Count=3D=
1/2 Enable+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
fee0f00c =C2=A0Data: 4151
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [60] HyperTransport: MSI Mappin=
g Enable- Fixed-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mapping Address B=
ase: 00000000fee00000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [80] Express (v1) Root Port (Sl=
ot+), MSI 00
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCap: MaxPayloa=
d 256 bytes, PhantFunc 0, Latency L0s
>>>>> <64ns,
>>>>> L1 <1us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtTag- RBE+ FLReset-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCtl: Report er=
rors: Correctable- Non-Fatal- Fatal-
>>>>> Unsupported-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0MaxPayload 128 bytes, MaxReadReq 512 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevSta: CorrErr- =
UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>>>>> TransPend-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCap: Port #4, =
Speed 2.5GT/s, Width x1, ASPM L0s L1,
>>>>> Latency L0 <512ns, L1 <4us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ClockPM- Surprise- LLActRep+ BwNot-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCtl: ASPM Disa=
bled; RCB 64 bytes Disabled- Retrain-
>>>>> CommClk-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkSta: Speed 2.5=
GT/s, Width x4, TrErr- Train- SlotClk+
>>>>> DLActive- BWMgmt- ABWMgmt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCap: AttnBtn- =
PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>>>>> Surpise-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Slot # =C2=A00, PowerLimit 0.000000; Interlock-
>>>>> NoCompl-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCtl: Enable: A=
ttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>>>>> HPIrq- LinkChg-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Control: AttnInd Off, PwrInd On, Power- Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltSta: Status: A=
ttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>>>>> Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Changed: MRL- PresDet- LinkState-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCtl: ErrCorre=
ctable- ErrNon-Fatal- ErrFatal-
>>>>> PMEIntEna-
>>>>> CRSVisible-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCap: CRSVisib=
le-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootSta: PME ReqI=
D 0000, PMEStatus- PMEPending-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [100] Virtual Channel <?>
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: pcieport-driver
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: shpchp
>>>>>
>>>>> 00:0c.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (=
rev
>>>>> a3)
>>>>> (prog-if 00 [Normal decode])
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx+
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0, Cache Line Size: 64 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0Bus: primary=3D00, secondary=3D04, subordinat=
e=3D04, sec-latency=3D0
>>>>> =C2=A0 =C2=A0 =C2=A0Secondary status: 66MHz- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- <SERR- <PERR-
>>>>> =C2=A0 =C2=A0 =C2=A0BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- =
>Reset- FastB2B-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PriDiscTmr- SecDi=
scTmr- DiscTmrStat- DiscTmrSERREn-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [40] Subsystem: nVidia Corporat=
ion Device 0000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [48] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [50] MSI: Mask- 64bit+ Count=3D=
1/2 Enable+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
fee0f00c =C2=A0Data: 4159
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [60] HyperTransport: MSI Mappin=
g Enable- Fixed-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mapping Address B=
ase: 00000000fee00000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [80] Express (v1) Root Port (Sl=
ot+), MSI 00
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCap: MaxPayloa=
d 256 bytes, PhantFunc 0, Latency L0s
>>>>> <64ns,
>>>>> L1 <1us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtTag- RBE+ FLReset-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCtl: Report er=
rors: Correctable- Non-Fatal- Fatal-
>>>>> Unsupported-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0MaxPayload 128 bytes, MaxReadReq 512 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevSta: CorrErr- =
UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>>>>> TransPend-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCap: Port #3, =
Speed 2.5GT/s, Width x1, ASPM L0s L1,
>>>>> Latency L0 <512ns, L1 <4us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ClockPM- Surprise- LLActRep+ BwNot-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCtl: ASPM Disa=
bled; RCB 64 bytes Disabled- Retrain-
>>>>> CommClk-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkSta: Speed 2.5=
GT/s, Width x4, TrErr- Train- SlotClk+
>>>>> DLActive- BWMgmt- ABWMgmt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCap: AttnBtn- =
PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>>>>> Surpise-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Slot # =C2=A00, PowerLimit 0.000000; Interlock-
>>>>> NoCompl-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCtl: Enable: A=
ttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>>>>> HPIrq- LinkChg-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Control: AttnInd Off, PwrInd On, Power- Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltSta: Status: A=
ttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>>>>> Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Changed: MRL- PresDet- LinkState-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCtl: ErrCorre=
ctable- ErrNon-Fatal- ErrFatal-
>>>>> PMEIntEna-
>>>>> CRSVisible-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCap: CRSVisib=
le-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootSta: PME ReqI=
D 0000, PMEStatus- PMEPending-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [100] Virtual Channel <?>
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: pcieport-driver
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: shpchp
>>>>>
>>>>> 00:0d.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (=
rev
>>>>> a3)
>>>>> (prog-if 00 [Normal decode])
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx+
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0, Cache Line Size: 64 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0Bus: primary=3D00, secondary=3D05, subordinat=
e=3D05, sec-latency=3D0
>>>>> =C2=A0 =C2=A0 =C2=A0Secondary status: 66MHz- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- <SERR- <PERR-
>>>>> =C2=A0 =C2=A0 =C2=A0BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- =
>Reset- FastB2B-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PriDiscTmr- SecDi=
scTmr- DiscTmrStat- DiscTmrSERREn-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [40] Subsystem: nVidia Corporat=
ion Device 0000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [48] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [50] MSI: Mask- 64bit+ Count=3D=
1/2 Enable+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
fee0f00c =C2=A0Data: 4161
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [60] HyperTransport: MSI Mappin=
g Enable- Fixed-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mapping Address B=
ase: 00000000fee00000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [80] Express (v1) Root Port (Sl=
ot+), MSI 00
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCap: MaxPayloa=
d 256 bytes, PhantFunc 0, Latency L0s
>>>>> <64ns,
>>>>> L1 <1us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtTag- RBE+ FLReset-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCtl: Report er=
rors: Correctable- Non-Fatal- Fatal-
>>>>> Unsupported-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0MaxPayload 128 bytes, MaxReadReq 512 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevSta: CorrErr- =
UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>>>>> TransPend-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCap: Port #2, =
Speed 2.5GT/s, Width x1, ASPM L0s L1,
>>>>> Latency L0 <512ns, L1 <4us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ClockPM- Surprise- LLActRep+ BwNot-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCtl: ASPM Disa=
bled; RCB 64 bytes Disabled- Retrain-
>>>>> CommClk-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkSta: Speed 2.5=
GT/s, Width x4, TrErr- Train- SlotClk+
>>>>> DLActive- BWMgmt- ABWMgmt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCap: AttnBtn- =
PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>>>>> Surpise-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Slot # =C2=A00, PowerLimit 0.000000; Interlock-
>>>>> NoCompl-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCtl: Enable: A=
ttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>>>>> HPIrq- LinkChg-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Control: AttnInd Off, PwrInd On, Power- Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltSta: Status: A=
ttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>>>>> Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Changed: MRL- PresDet- LinkState-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCtl: ErrCorre=
ctable- ErrNon-Fatal- ErrFatal-
>>>>> PMEIntEna-
>>>>> CRSVisible-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCap: CRSVisib=
le-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootSta: PME ReqI=
D 0000, PMEStatus- PMEPending-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [100] Virtual Channel <?>
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: pcieport-driver
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: shpchp
>>>>>
>>>>> 00:0e.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (=
rev
>>>>> a3)
>>>>> (prog-if 00 [Normal decode])
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx+
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0, Cache Line Size: 64 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0Bus: primary=3D00, secondary=3D06, subordinat=
e=3D06, sec-latency=3D0
>>>>> =C2=A0 =C2=A0 =C2=A0Secondary status: 66MHz- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- <SERR- <PERR-
>>>>> =C2=A0 =C2=A0 =C2=A0BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- =
>Reset- FastB2B-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PriDiscTmr- SecDi=
scTmr- DiscTmrStat- DiscTmrSERREn-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [40] Subsystem: nVidia Corporat=
ion Device 0000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [48] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [50] MSI: Mask- 64bit+ Count=3D=
1/2 Enable+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
fee0f00c =C2=A0Data: 4169
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [60] HyperTransport: MSI Mappin=
g Enable- Fixed-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mapping Address B=
ase: 00000000fee00000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [80] Express (v1) Root Port (Sl=
ot+), MSI 00
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCap: MaxPayloa=
d 256 bytes, PhantFunc 0, Latency L0s
>>>>> <64ns,
>>>>> L1 <1us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtTag- RBE+ FLReset-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCtl: Report er=
rors: Correctable- Non-Fatal- Fatal-
>>>>> Unsupported-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0MaxPayload 128 bytes, MaxReadReq 512 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevSta: CorrErr- =
UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>>>>> TransPend-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCap: Port #1, =
Speed 2.5GT/s, Width x1, ASPM L0s L1,
>>>>> Latency L0 <512ns, L1 <4us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ClockPM- Surprise- LLActRep+ BwNot-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCtl: ASPM Disa=
bled; RCB 64 bytes Disabled- Retrain-
>>>>> CommClk-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkSta: Speed 2.5=
GT/s, Width x8, TrErr- Train- SlotClk+
>>>>> DLActive- BWMgmt- ABWMgmt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCap: AttnBtn- =
PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>>>>> Surpise-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Slot # =C2=A00, PowerLimit 0.000000; Interlock-
>>>>> NoCompl-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCtl: Enable: A=
ttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>>>>> HPIrq- LinkChg-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Control: AttnInd Off, PwrInd On, Power- Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltSta: Status: A=
ttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>>>>> Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Changed: MRL- PresDet- LinkState-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCtl: ErrCorre=
ctable- ErrNon-Fatal- ErrFatal-
>>>>> PMEIntEna-
>>>>> CRSVisible-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCap: CRSVisib=
le-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootSta: PME ReqI=
D 0000, PMEStatus- PMEPending-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [100] Virtual Channel <?>
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: pcieport-driver
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: shpchp
>>>>>
>>>>> 00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (=
rev
>>>>> a3)
>>>>> (prog-if 00 [Normal decode])
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster+ SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx+
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Latency: 0, Cache Line Size: 64 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0Bus: primary=3D00, secondary=3D07, subordinat=
e=3D07, sec-latency=3D0
>>>>> =C2=A0 =C2=A0 =C2=A0Secondary status: 66MHz- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- <SERR- <PERR-
>>>>> =C2=A0 =C2=A0 =C2=A0BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- =
>Reset- FastB2B-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0PriDiscTmr- SecDi=
scTmr- DiscTmrStat- DiscTmrSERREn-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [40] Subsystem: nVidia Corporat=
ion Device 0000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [48] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1- D2- AuxCurrent=3D0mA
>>>>> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [50] MSI: Mask- 64bit+ Count=3D=
1/2 Enable+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Address: 00000000=
fee0f00c =C2=A0Data: 4171
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [60] HyperTransport: MSI Mappin=
g Enable- Fixed-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Mapping Address B=
ase: 00000000fee00000
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [80] Express (v1) Root Port (Sl=
ot+), MSI 00
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCap: MaxPayloa=
d 256 bytes, PhantFunc 0, Latency L0s
>>>>> <64ns,
>>>>> L1 <1us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtTag- RBE+ FLReset-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevCtl: Report er=
rors: Correctable- Non-Fatal- Fatal-
>>>>> Unsupported-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0MaxPayload 128 bytes, MaxReadReq 512 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DevSta: CorrErr- =
UncorrErr- FatalErr- UnsuppReq- AuxPwr-
>>>>> TransPend-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCap: Port #0, =
Speed 2.5GT/s, Width x16, ASPM L0s L1,
>>>>> Latency L0 <512ns, L1 <4us
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ClockPM- Surprise- LLActRep+ BwNot-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkCtl: ASPM Disa=
bled; RCB 64 bytes Disabled- Retrain-
>>>>> CommClk-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LnkSta: Speed 2.5=
GT/s, Width x16, TrErr- Train- SlotClk+
>>>>> DLActive- BWMgmt- ABWMgmt-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCap: AttnBtn- =
PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
>>>>> Surpise-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Slot # =C2=A00, PowerLimit 0.000000; Interlock-
>>>>> NoCompl-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltCtl: Enable: A=
ttnBtn- PwrFlt- MRL- PresDet- CmdCplt-
>>>>> HPIrq- LinkChg-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Control: AttnInd Off, PwrInd On, Power- Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SltSta: Status: A=
ttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
>>>>> Interlock-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0Changed: MRL- PresDet- LinkState-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCtl: ErrCorre=
ctable- ErrNon-Fatal- ErrFatal-
>>>>> PMEIntEna-
>>>>> CRSVisible-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootCap: CRSVisib=
le-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0RootSta: PME ReqI=
D 0000, PMEStatus- PMEPending-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [100] Virtual Channel <?>
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel driver in use: pcieport-driver
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: shpchp
>>>>>
>>>>> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opt=
eron,
>>>>> Athlon64, Sempron] HyperTransport Configuration
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster- SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [80] HyperTransport: Host or Se=
condary Interface
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Command: WarmRst+=
 DblEnd- DevNum=3D0 ChainSide- HostHide+
>>>>> Slave- <EOCErr- DUL-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Control: CFl=
E- CST- CFE- <LkFail- Init+ EOC- TXO-
>>>>> <CRCErr=3D0 IsocEn- LSEn+ ExtCTL- 64b-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Config: MLWI=
=3D16bit DwFcIn- MLWO=3D16bit DwFcOut-
>>>>> LWI=3D16bit
>>>>> DwFcInEn- LWO=3D16bit DwFcOutEn-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Revision ID: 3.00
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Frequency: 1=
=2E0GHz
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Error: <Prot=
- <Ovfl- <EOC- CTLTm-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Link Frequency Ca=
pability: 200MHz+ 300MHz- 400MHz+ 500MHz-
>>>>> 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Feature Capabilit=
y: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+
>>>>> UIDRD- ExtRS- UCnfE-
>>>>>
>>>>> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opt=
eron,
>>>>> Athlon64, Sempron] Address Map
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster- SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>
>>>>> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opt=
eron,
>>>>> Athlon64, Sempron] DRAM Controller
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster- SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Kernel modules: amd64_edac_mod
>>>>>
>>>>> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opt=
eron,
>>>>> Athlon64, Sempron] Miscellaneous Control
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster- SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [f0] Secure device <?>
>>>>>
>>>>> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opt=
eron,
>>>>> Athlon64, Sempron] Link Control
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O- Mem- BusMaster- SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEV=
SEL=3Dfast >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>>
>>>>> 01:0a.0 VGA compatible controller: XGI Technology Inc. (eXtreme
>>>>> Graphics
>>>>> Innovation) Volari Z7/Z9/Z9s (prog-if 00 [VGA controller])
>>>>> =C2=A0 =C2=A0 =C2=A0Subsystem: XGI Technology Inc. (eXtreme Graph=
ics Innovation)
>>>>> Volari
>>>>> Z7/Z9/Z9s
>>>>> =C2=A0 =C2=A0 =C2=A0Control: I/O+ Mem+ BusMaster- SpecCycle- MemW=
INV- VGASnoop-
>>>>> ParErr-
>>>>> Stepping- SERR- FastB2B- DisINTx-
>>>>> =C2=A0 =C2=A0 =C2=A0Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEV=
SEL=3Dmedium >TAbort-
>>>>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>>>>> =C2=A0 =C2=A0 =C2=A0BIST result: 00
>>>>> =C2=A0 =C2=A0 =C2=A0Region 0: Memory at f8000000 (32-bit, prefetc=
hable) [size=3D64M]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 1: Memory at febc0000 (32-bit, non-pre=
fetchable)
>>>>> [size=3D256K]
>>>>> =C2=A0 =C2=A0 =C2=A0Region 2: I/O ports at ec00 [size=3D128]
>>>>> =C2=A0 =C2=A0 =C2=A0Expansion ROM at <unassigned> [disabled]
>>>>> =C2=A0 =C2=A0 =C2=A0Capabilities: [40] Power Management version 2
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Flags: PMEClk- DS=
I- D1+ D2+ AuxCurrent=3D0mA
>>>>> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Status: D0 PME-En=
able- DSel=3D0 DScale=3D0 PME-
>>>>>
>>>>>
>>>>>
>>>>> /dev/sda:
>>>>>
>>>>> ATA device, with non-removable media
>>>>> =C2=A0 =C2=A0 =C2=A0Model Number: =C2=A0 =C2=A0 =C2=A0 WDC WD5000=
AAKS-00A7B2
>>>>> =C2=A0 =C2=A0 =C2=A0Serial Number: =C2=A0 =C2=A0 =C2=A0WD-WCASZ03=
21108
>>>>> =C2=A0 =C2=A0 =C2=A0Firmware Revision: =C2=A001.03B01
>>>>> =C2=A0 =C2=A0 =C2=A0Transport: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Serial, SATA 1.0a, SATA II Extensions, SATA
>>>>> Rev
>>>>> 2.5
>>>>> Standards:
>>>>> =C2=A0 =C2=A0 =C2=A0Supported: 8 7 6 5
>>>>> =C2=A0 =C2=A0 =C2=A0Likely used: 8
>>>>> Configuration:
>>>>> =C2=A0 =C2=A0 =C2=A0Logical =C2=A0 =C2=A0 =C2=A0 =C2=A0 max =C2=A0=
 =C2=A0 current
>>>>> =C2=A0 =C2=A0 =C2=A0cylinders =C2=A0 =C2=A0 =C2=A0 16383 =C2=A0 1=
6383
>>>>> =C2=A0 =C2=A0 =C2=A0heads =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 16 =C2=
=A0 =C2=A0 =C2=A016
>>>>> =C2=A0 =C2=A0 =C2=A0sectors/track =C2=A0 63 =C2=A0 =C2=A0 =C2=A06=
3
>>>>> =C2=A0 =C2=A0 =C2=A0--
>>>>> =C2=A0 =C2=A0 =C2=A0CHS current addressable sectors: =C2=A0 16514=
064
>>>>> =C2=A0 =C2=A0 =C2=A0LBA =C2=A0 =C2=A0user addressable sectors: =C2=
=A0268435455
>>>>> =C2=A0 =C2=A0 =C2=A0LBA48 =C2=A0user addressable sectors: =C2=A09=
76773168
>>>>> =C2=A0 =C2=A0 =C2=A0Logical/Physical Sector size: =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 512 bytes
>>>>> =C2=A0 =C2=A0 =C2=A0device size with M =3D 1024*1024: =C2=A0 =C2=A0=
 =C2=A0476940 MBytes
>>>>> =C2=A0 =C2=A0 =C2=A0device size with M =3D 1000*1000: =C2=A0 =C2=A0=
 =C2=A0500107 MBytes (500 GB)
>>>>> =C2=A0 =C2=A0 =C2=A0cache/buffer size =C2=A0=3D 16384 KBytes
>>>>> Capabilities:
>>>>> =C2=A0 =C2=A0 =C2=A0LBA, IORDY(can be disabled)
>>>>> =C2=A0 =C2=A0 =C2=A0Queue depth: 32
>>>>> =C2=A0 =C2=A0 =C2=A0Standby timer values: spec'd by Standard, wit=
h device specific
>>>>> minimum
>>>>> =C2=A0 =C2=A0 =C2=A0R/W multiple sector transfer: Max =3D 16 =C2=A0=
Current =3D 16
>>>>> =C2=A0 =C2=A0 =C2=A0Recommended acoustic management value: 128, c=
urrent value: 254
>>>>> =C2=A0 =C2=A0 =C2=A0DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma=
3 udma4 udma5 *udma6
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Cycle time: min=3D120ns recomm=
ended=3D120ns
>>>>> =C2=A0 =C2=A0 =C2=A0PIO: pio0 pio1 pio2 pio3 pio4
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Cycle time: no flow control=3D=
120ns =C2=A0IORDY flow control=3D120ns
>>>>> Commands/features:
>>>>> =C2=A0 =C2=A0 =C2=A0Enabled Supported:
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0SMART feature set
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Security Mode fea=
ture set
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Power Management featu=
re set
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Write cache
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Look-ahead
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Host Protected Area fe=
ature set
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0WRITE_BUFFER command
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0READ_BUFFER command
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0NOP cmd
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0DOWNLOAD_MICROCODE
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Power-Up In Stand=
by feature set
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0SET_FEATURES required =
to spinup after power up
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SET_MAX security =
extension
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Automatic Acousti=
c Management feature set
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A048-bit Address feature=
 set
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Device Configuration O=
verlay feature set
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Mandatory FLUSH_CACHE
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0FLUSH_CACHE_EXT
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0SMART error logging
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0SMART self-test
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0General Purpose Loggin=
g feature set
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A064-bit World wide name
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Segmented DOWNLOAD_MIC=
ROCODE
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Gen1 signaling speed (=
1.5Gb/s)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Gen2 signaling speed (=
3.0Gb/s)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Native Command Queuein=
g (NCQ)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Host-initiated interfa=
ce power management
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Phy event counters
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DMA Setup Auto-Ac=
tivate optimization
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0Software settings pres=
ervation
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0SMART Command Transpor=
t (SCT) feature set
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0SCT Long Sector Access=
 (AC1)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0SCT LBA Segment Access=
 (AC2)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0SCT Error Recovery Con=
trol (AC3)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0SCT Features Control (=
AC4)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 * =C2=A0 =C2=A0SCT Data Tables (AC5)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unknown 206[12] (=
vendor specific)
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unknown 206[13] (=
vendor specific)
>>>>> Security:
>>>>> =C2=A0 =C2=A0 =C2=A0Master password revision code =3D 65534
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0supported
>>>>> =C2=A0 =C2=A0 =C2=A0not =C2=A0 =C2=A0 enabled
>>>>> =C2=A0 =C2=A0 =C2=A0not =C2=A0 =C2=A0 locked
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0frozen
>>>>> =C2=A0 =C2=A0 =C2=A0not =C2=A0 =C2=A0 expired: security count
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0supported: enhanc=
ed erase
>>>>> =C2=A0 =C2=A0 =C2=A084min for SECURITY ERASE UNIT. 84min for ENHA=
NCED SECURITY ERASE
>>>>> UNIT.
>>>>> Logical Unit WWN Device Identifier: 50014ee101cedc24
>>>>> =C2=A0 =C2=A0 =C2=A0NAA =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 : 5
>>>>> =C2=A0 =C2=A0 =C2=A0IEEE OUI =C2=A0 =C2=A0 =C2=A0 =C2=A0: 0014ee
>>>>> =C2=A0 =C2=A0 =C2=A0Unique ID =C2=A0 =C2=A0 =C2=A0 : 101cedc24
>>>>> Checksum: correct
>>>>>
>>>>> /dev/md0:
>>>>> =C2=A0 =C2=A0 =C2=A0Version : 0.90
>>>>> =C2=A0Creation Time : Mon Jul 27 22:38:26 2009
>>>>> =C2=A0 Raid Level : raid1
>>>>> =C2=A0 Array Size : 102336 (99.95 MiB 104.79 MB)
>>>>> =C2=A0Used Dev Size : 102336 (99.95 MiB 104.79 MB)
>>>>> =C2=A0Raid Devices : 4
>>>>> =C2=A0Total Devices : 4
>>>>> Preferred Minor : 0
>>>>> =C2=A0Persistence : Superblock is persistent
>>>>>
>>>>> =C2=A0Update Time : Mon Sep 21 11:02:14 2009
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>>>> =C2=A0Active Devices : 4
>>>>> Working Devices : 4
>>>>> =C2=A0Failed Devices : 0
>>>>> =C2=A0Spare Devices : 0
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 9037def2:035b0d10:bfe78010:bc8=
10f04
>>>>> =C2=A0 =C2=A0 =C2=A0 Events : 0.44
>>>>>
>>>>> =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
>>>>> =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
1 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sda1
>>>>> =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 17 =C2=
=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
db1
>>>>> =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 33 =C2=
=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dc1
>>>>> =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 49 =C2=
=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dd1
>>>>> /dev/md1:
>>>>> =C2=A0 =C2=A0 =C2=A0Version : 0.90
>>>>> =C2=A0Creation Time : Mon Jul 27 22:38:28 2009
>>>>> =C2=A0 Raid Level : raid1
>>>>> =C2=A0 Array Size : 4095936 (3.91 GiB 4.19 GB)
>>>>> =C2=A0Used Dev Size : 4095936 (3.91 GiB 4.19 GB)
>>>>> =C2=A0Raid Devices : 4
>>>>> =C2=A0Total Devices : 4
>>>>> Preferred Minor : 1
>>>>> =C2=A0Persistence : Superblock is persistent
>>>>>
>>>>> =C2=A0Update Time : Mon Sep 21 11:02:14 2009
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>>>> =C2=A0Active Devices : 4
>>>>> Working Devices : 4
>>>>> =C2=A0Failed Devices : 0
>>>>> =C2=A0Spare Devices : 0
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 642c2833:bf033a7d:bfe78010:bc8=
10f04
>>>>> =C2=A0 =C2=A0 =C2=A0 Events : 0.44
>>>>>
>>>>> =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
>>>>> =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
2 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sda2
>>>>> =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 18 =C2=
=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
db2
>>>>> =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 34 =C2=
=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dc2
>>>>> =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 50 =C2=
=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dd2
>>>>> /dev/md2:
>>>>> =C2=A0 =C2=A0 =C2=A0Version : 0.90
>>>>> =C2=A0Creation Time : Mon Jul 27 22:38:30 2009
>>>>> =C2=A0 Raid Level : raid1
>>>>> =C2=A0 Array Size : 484185536 (461.76 GiB 495.81 GB)
>>>>> =C2=A0Used Dev Size : 484185536 (461.76 GiB 495.81 GB)
>>>>> =C2=A0Raid Devices : 4
>>>>> =C2=A0Total Devices : 4
>>>>> Preferred Minor : 2
>>>>> =C2=A0Persistence : Superblock is persistent
>>>>>
>>>>> =C2=A0Update Time : Mon Sep 21 11:02:24 2009
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
>>>>> =C2=A0Active Devices : 4
>>>>> Working Devices : 4
>>>>> =C2=A0Failed Devices : 0
>>>>> =C2=A0Spare Devices : 0
>>>>>
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : ce106d52:0c0373f7:bfe78010:bc8=
10f04
>>>>> =C2=A0 =C2=A0 =C2=A0 Events : 0.66
>>>>>
>>>>> =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
>>>>> =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
3 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /=
dev/sda3
>>>>> =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 19 =C2=
=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
db3
>>>>> =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 35 =C2=
=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dc3
>>>>> =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 51 =C2=
=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /dev/s=
dd3
>>>>>
>>>>>
>>>>>
>>>>>
>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>>
>>
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
