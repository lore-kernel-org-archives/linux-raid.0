From: Andreas Feldmann <aef@az-aachen.de>
Subject: BUG: raid0_make_request bug in kernel 2.6.0-test5-bk10
Date: Wed, 24 Sep 2003 17:06:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F71B2E6.4010805@az-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[1.] One line summary of the problem:
raid0_make_request bug in kernel 2.6.0-test5-bk10

[2.] Full description of the problem/report:
Since I updated to the 2.6.0-test5-bk10 kernel I get these bug messages
everytime the computer executes a binary file in one of my raid0/lvm
partitions (see below how my harddisk is partitioned) for the first time
since bootup:
> raid0_make_request bug: can't convert block across chunks or bigger 
than 4k 286485088 64
The second last number in the bug message differs with every message I
get. The last one is either 8, 12, 20, 24 or 64 (and maybe some more
which I didn't see).
The numbers of messages I get also differs with every exutable.
Naturally I get a lot of these messages at boot time from the point
onward that init is started.
With the 2.6.0-test5-bk3 kernel this problem didn't occur.
Despite the fact that these messages are quite annoying they don't seem
to have any effect on the work flow. Everything seems to work fine.

[3.] Keywords (i.e., modules, networking, kernel):
raid, lvm

[4.] Kernel version (from /proc/version):
root@chaos:/proc # cat version
Linux version 2.6.0-test5-bk10 (root@chaos.diy) (gcc version 3.2.3
(Debian)) #1 Tue Sep 23 17:51:27 CEST 2003

[5.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/oops-tracing.txt)
[6.] A small shell script or example program which triggers the
      problem (if possible)
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)
root@chaos:/usr/src/linux/scripts # ./ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux chaos.diy 2.6.0-test5-bk10 #1 Tue Sep 23 17:51:27 CEST 2003 i686
GNU/Linux

Gnu C                  3.2.3
Gnu make               3.79.1
util-linux             2.11n
mount                  2.11n
e2fsprogs              1.34-WIP
PPP                    2.4.1
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 2.0.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.0
Modules Loaded         lp parport_pc parport fan thermal processor
button snd_ens1371 snd_rawmidi snd_ac97_codec snd_seq_device snd_pcm_oss
snd_pcm snd_page_alloc snd_timer snd_mixer_oss snd via_rhine mii crc32
ppp_generic slhc autofs4 cpuid hid ehci_hcd uhci_hcd usbcore nvidia
agpgart ipv6 sg sr_mod cdrom ide_scsi scsi_mod

[7.2.] Processor information (from /proc/cpuinfo):
root@chaos:/proc # cat cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Athlon(tm) XP 2200+
stepping        : 1
cpu MHz         : 1800.492
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow
bogomips        : 3530.75

[7.3.] Module information (from /proc/modules):
root@chaos:/proc # cat modules
lp 9824 0 - Live 0xe0991000
parport_pc 23368 1 - Live 0xe0997000
parport 28864 2 lp,parport_pc, Live 0xe0936000
fan 3976 0 - Live 0xe0827000
thermal 13832 0 - Live 0xe0987000
processor 14232 1 thermal, Live 0xe08fb000
button 6100 0 - Live 0xe0921000
snd_ens1371 20036 0 - Live 0xe0947000
snd_rawmidi 25536 1 snd_ens1371, Live 0xe093f000
snd_ac97_codec 53892 1 snd_ens1371, Live 0xe0978000
snd_seq_device 8388 1 snd_rawmidi, Live 0xe0932000
snd_pcm_oss 52740 0 - Live 0xe096a000
snd_pcm 100224 2 snd_ens1371,snd_pcm_oss, Live 0xe0950000
snd_page_alloc 11844 1 snd_pcm, Live 0xe0900000
snd_timer 26240 1 snd_pcm, Live 0xe0919000
snd_mixer_oss 19328 1 snd_pcm_oss, Live 0xe0913000
snd 51780 8
snd_ens1371,snd_rawmidi,snd_ac97_codec,snd_seq_device,snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss, 

Live 0xe0924000
via_rhine 19784 0 - Live 0xe090d000
mii 5184 1 via_rhine, Live 0xe0897000
crc32 4352 1 via_rhine, Live 0xe0864000
ppp_generic 27848 0 - Live 0xe0905000
slhc 7488 1 ppp_generic, Live 0xe0861000
autofs4 16448 0 - Live 0xe08f5000
cpuid 2496 0 - Live 0xe083b000
hid 33472 0 - Live 0xe088d000
ehci_hcd 24832 0 - Live 0xe0885000
uhci_hcd 32968 0 - Live 0xe087b000
usbcore 110612 5 hid,ehci_hcd,uhci_hcd, Live 0xe089b000
nvidia 1702188 10 - Live 0xe0ac7000
agpgart 32648 0 - Live 0xe0872000
ipv6 243296 47 - Live 0xe08b8000
sg 33292 0 - Live 0xe0868000
sr_mod 16032 0 - Live 0xe0830000
cdrom 35808 1 sr_mod, Live 0xe0853000
ide_scsi 16000 0 - Live 0xe082b000
scsi_mod 77848 3 sg,sr_mod,ide_scsi, Live 0xe083e000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
root@chaos:/proc # cat ioports
0000-001f : dma1
0020-0021 : pic1
0040-005f : timer
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide1
01f0-01f7 : ide0
0376-0376 : ide1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f6-03f6 : ide0
0cf8-0cff : PCI conf1
dc00-dcff : 0000:00:12.0
   dc00-dcff : via-rhine
e000-e01f : 0000:00:10.0
   e000-e01f : uhci-hcd
e400-e41f : 0000:00:10.1
   e400-e41f : uhci-hcd
e800-e81f : 0000:00:10.2
   e800-e81f : uhci-hcd
ec00-ec3f : 0000:00:0b.0
   ec00-ec3f : Ensoniq AudioPCI
fc00-fc0f : 0000:00:11.1
   fc00-fc07 : ide0
   fc08-fc0f : ide1


root@chaos:/proc # cat iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000d2000-000d7fff : reserved
000f0000-000fffff : System ROM
00100000-1ffeffff : System RAM
   00100000-002cadad : Kernel code
   002cadae-0035d53f : Kernel data
1fff0000-1fff7fff : ACPI Tables
1fff8000-1fffffff : ACPI Non-volatile Storage
cdc00000-ddcfffff : PCI Bus #01
   d0000000-d7ffffff : 0000:01:00.0
   ddc80000-ddcfffff : 0000:01:00.0
dde00000-dfefffff : PCI Bus #01
   de000000-deffffff : 0000:01:00.0
dffffe00-dffffeff : 0000:00:12.0
   dffffe00-dffffeff : via-rhine
dfffff00-dfffffff : 0000:00:10.3
   dfffff00-dfffffff : ehci_hcd
e0000000-e1ffffff : 0000:00:00.0
fec00000-fec00fff : reserved
fee00000-fee00fff : reserved
fff80000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)
root@chaos:/proc # lspci -vvv
00:00.0 Host bridge: VIA Technologies, Inc.: Unknown device 3116
         Subsystem: Unknown device 1849:3156
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR-
         Latency: 8
         Region 0: Memory at e0000000 (32-bit, prefetchable) [size=32M]
         Capabilities: [a0] AGP version 2.0
                 Status: RQ=31 SBA+ 64bit- FW- Rate=x1,x2
                 Command: RQ=0 SBA- AGP- 64bit- FW- Rate=<none>
         Capabilities: [c0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT8633 [Apollo Pro266 AGP]
(prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR-
         Latency: 0
         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
         I/O behind bridge: 0000f000-00000fff
         Memory behind bridge: dde00000-dfefffff
         Prefetchable memory behind bridge: cdc00000-ddcfffff
         BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0b.0 Multimedia audio controller: Ensoniq 5880 AudioPCI (rev 02)
         Subsystem: Ensoniq: Unknown device 8001
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
         Latency: 32 (3000ns min, 32000ns max)
         Interrupt: pin A routed to IRQ 19
         Region 0: I/O ports at ec00 [size=64]
         Capabilities: [dc] Power Management version 1
                 Flags: PMEClk- DSI+ D1- D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.0 USB Controller: VIA Technologies, Inc. UHCI USB (rev 80)
(prog-if 00 [UHCI])
         Subsystem: VIA Technologies, Inc. UHCI USB
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32, cache line size 08
         Interrupt: pin A routed to IRQ 21
         Region 4: I/O ports at e000 [size=32]
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.1 USB Controller: VIA Technologies, Inc. UHCI USB (rev 80)
(prog-if 00 [UHCI])
         Subsystem: VIA Technologies, Inc. UHCI USB
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32, cache line size 08
         Interrupt: pin B routed to IRQ 21
         Region 4: I/O ports at e400 [size=32]
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.2 USB Controller: VIA Technologies, Inc. UHCI USB (rev 80)
(prog-if 00 [UHCI])
         Subsystem: VIA Technologies, Inc. UHCI USB
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32, cache line size 08
         Interrupt: pin C routed to IRQ 21
         Region 4: I/O ports at e800 [size=32]
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.3 USB Controller: VIA Technologies, Inc.: Unknown device 3104 (rev
82) (prog-if 20)
         Subsystem: VIA Technologies, Inc.: Unknown device 3104
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32, cache line size 10
         Interrupt: pin D routed to IRQ 21
         Region 0: Memory at dfffff00 (32-bit, non-prefetchable) [size=256]
         Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.0 ISA bridge: VIA Technologies, Inc.: Unknown device 3177
         Subsystem: Unknown device 1849:3177
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Capabilities: [c0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.1 IDE interface: VIA Technologies, Inc. Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP])
         Subsystem: Unknown device 1849:0571
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32
         Interrupt: pin A routed to IRQ 255
         Region 4: I/O ports at fc00 [size=16]
         Capabilities: [c0] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:12.0 Ethernet controller: VIA Technologies, Inc. Ethernet Controller
(rev 74)
         Subsystem: VIA Technologies, Inc. Ethernet Controller
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 32 (750ns min, 2000ns max), cache line size 08
         Interrupt: pin A routed to IRQ 23
         Region 0: I/O ports at dc00 [size=256]
         Region 1: Memory at dffffe00 (32-bit, non-prefetchable) [size=256]
         Capabilities: [40] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: nVidia Corporation: Unknown device
0253 (rev a3) (prog-if 00 [VGA])
         Subsystem: CardExpert Technology: Unknown device 0002
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 248 (1250ns min, 250ns max)
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=16M]
         Region 1: Memory at d0000000 (32-bit, prefetchable) [size=128M]
         Region 2: Memory at ddc80000 (32-bit, prefetchable) [size=512K]
         Expansion ROM at dfee0000 [disabled] [size=128K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [44] AGP version 2.0
                 Status: RQ=31 SBA+ 64bit- FW+ Rate=x1,x2
                 Command: RQ=0 SBA- AGP- 64bit- FW- Rate=<none>


[7.6.] SCSI information (from /proc/scsi/scsi)
root@chaos:/proc # cat scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
   Vendor: SONY     Model: CD-ROM CDU5211   Rev: YYS7
   Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
   Vendor: YAMAHA   Model: CRW8824E         Rev: 1.00
   Type:   CD-ROM                           ANSI SCSI revision: 02

[7.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):
root@chaos:/proc # cat mdstat
Personalities : [raid0] [multipath]
md1 : active raid0 hdc3[1] hda5[0]
       979648 blocks 4k chunks

md0 : active raid0 hdc2[1] hda6[0]
       148874240 blocks 4k chunks

unused devices: <none>

root@chaos:/proc # mount
/dev/md1 on / type ext3 (rw,errors=remount-ro)
proc on /proc type proc (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/hda1 on /boot type ext3 (rw)
/dev/vg01/usr on /usr type ext3 (rw)
/dev/vg01/opt on /opt type ext3 (rw)
/dev/vg01/home on /home type ext3 (rw)
/dev/vg01/data on /mnt/data type ext3 (rw)

!!vg01 is a volume group on md0!!

[X.] Other notes, patches, fixes, workarounds:

-- 

"One world, one web, one program"  -- Microsoft promotional ad
"Ein Volk, ein Reich, ein Fuehrer"  -- Adolf Hitler

computers and internet gave you freedom. TCPA would TAKE your FREEDOM!
http://www.againsttcpa.com




