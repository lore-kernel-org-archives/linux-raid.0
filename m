From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Determining which spindle is out of order
Date: Sat, 06 Nov 2010 21:17:48 +0000
Message-ID: <4CD5C5FC.3090809@anonymous.org.uk>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD57048.4020107@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

(Resending because I forgot to cc the list originally)

On 06/11/2010 15:12, Phil Turmel wrote:
[...]
> Thanks for the feedback.  The script only looks in sysfs for controllers
> implementing the scsi_host interface.  So it won't pick up anything using
> the legacy IDE interface.  If that's not the case on the first server, I'd
> like to see lspci -vvv for the controller in question.

I get no output on my CentOS 5, 
kernel-xen-2.6.18-194.8.1.el5.centos.plus, much the same as the 
CentOS/RHEL kernel-xen-2.6.18-194.8.1.el5.

Here's my lspci -vvv for my storage/SCSI devices:

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA 
AHCI Controller (prog-if 01 [AHCI 1.0])
         Subsystem: ASUSTeK Computer Inc. P5Q Deluxe Motherboard
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 251
         Region 0: I/O ports at 9c00 [size=8]
         Region 1: I/O ports at 9880 [size=4]
         Region 2: I/O ports at 9800 [size=8]
         Region 3: I/O ports at 9480 [size=4]
         Region 4: I/O ports at 9400 [size=32]
         Region 5: Memory at f5ffe800 (32-bit, non-prefetchable) [size=2K]
         Capabilities: [80] Message Signalled Interrupts: 64bit- 
Queue=0/4 Enable+
                 Address: fee0100c  Data: 4129
         Capabilities: [70] Power Management version 3
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [a8] #12 [0010]
         Capabilities: [b0] Vendor Specific Information

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
         Subsystem: ASUSTeK Computer Inc. Unknown device 82d4
         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin C routed to IRQ 18
         Region 0: Memory at f5fff400 (64-bit, non-prefetchable) [size=256]
         Region 4: I/O ports at 0400 [size=32]

03:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6121 SATA II 
Controller (rev b2) (prog-if 8f [Master SecP SecO PriP PriO])
         Subsystem: ASUSTeK Computer Inc. Unknown device 82e0
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0, Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: I/O ports at dc00 [size=8]
         Region 1: I/O ports at d880 [size=4]
         Region 2: I/O ports at d800 [size=8]
         Region 3: I/O ports at d480 [size=4]
         Region 4: I/O ports at d400 [size=16]
         Region 5: Memory at fafffc00 (32-bit, non-prefetchable) [size=1K]
         Capabilities: [48] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0+,D1+,D2-,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [50] Message Signalled Interrupts: 64bit- 
Queue=0/0 Enable-
                 Address: 00000000  Data: 0000
         Capabilities: [e0] Express Legacy Endpoint IRQ 0
                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, 
ExtTag-
                 Device: Latency L0s unlimited, L1 unlimited
                 Device: AtnBtn- AtnInd- PwrInd-
                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr+ NoSnoop-
                 Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                 Link: Latency L0s <256ns, L1 unlimited
                 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                 Link: Speed 2.5Gb/s, Width x1

05:01.0 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m 
(rev 01)
         Subsystem: Compaq Computer Corporation Compaq 64-Bit/66MHz Dual 
Channel Wide Ultra3 SCSI Adapter
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (10000ns min, 6250ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 17
         BIST result: 00
         Region 0: I/O ports at e400 [disabled] [size=256]
         Region 1: Memory at febfe000 (64-bit, non-prefetchable) [size=4K]
         Expansion ROM at e0000000 [disabled] [size=128K]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:01.1 SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m 
(rev 01)
         Subsystem: Compaq Computer Corporation Compaq 64-Bit/66MHz Dual 
Channel Wide Ultra3 SCSI Adapter
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (10000ns min, 6250ns max), Cache Line Size: 32 bytes
         Interrupt: pin B routed to IRQ 18
         BIST result: 00
         Region 0: I/O ports at e800 [disabled] [size=256]
         Region 1: Memory at febff000 (64-bit, non-prefetchable) [size=4K]
         Expansion ROM at e0020000 [disabled] [size=128K]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-


[...]
> find /sys/devices/ -name scsi_host |check_host

This may be the culprit, this find command finds nothing, but I think my 
devices still support the sysfs scsi_host interface:

[root@beast ~]# find /sys/devices/ -name scsi_host
[root@beast ~]# find /sys/devices/ -name *scsi_host*
/sys/devices/pci0000:00/0000:00:1f.2/host7/scsi_host:host7
/sys/devices/pci0000:00/0000:00:1f.2/host6/scsi_host:host6
/sys/devices/pci0000:00/0000:00:1f.2/host5/scsi_host:host5
/sys/devices/pci0000:00/0000:00:1f.2/host4/scsi_host:host4
/sys/devices/pci0000:00/0000:00:1f.2/host3/scsi_host:host3
/sys/devices/pci0000:00/0000:00:1f.2/host2/scsi_host:host2
/sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.1/host9/scsi_host:host9
/sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.0/host8/scsi_host:host8
/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host1/scsi_host:host1
/sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host0/scsi_host:host0
[root@beast ~]#

When I change the script to use my find command, I get:

[root@beast ~]# ~john/projects/describe_scsi/describe_scsi
/home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: 
command not found
Controller device @ pci0000:00/0000:00:1f.2 []
     host7: [Empty]
     host6: [Empty]
     host5: [Empty]
     host4: [Empty]
     host3: [Empty]
     host2: [Empty]
/home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: 
command not found
Controller device @ pci0000:00/0000:00:1e.0/0000:05:01.1 []
     host9: [Empty]
/home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: 
command not found
Controller device @ pci0000:00/0000:00:1e.0/0000:05:01.0 []
     host8: [Empty]
/home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: 
command not found
Controller device @ pci0000:00/0000:00:1c.4/0000:03:00.0 []
     host1: [Empty]
     host0: [Empty]
[root@beast ~]#

Now I need to find udevadm I guess. It must have been introduced since 
the udev version that comes with RHEL/CentOS 5, which is 
udev-095-14.21.el5_5.1. rpmfind.net suggests it's only been in since 
version 118 or so. Never mind :-)

Cheers,

John.

