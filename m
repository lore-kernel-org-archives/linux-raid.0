From: "Andrey J. Melnikoff (TEMHOTA)" <temnota@kmv.ru>
Subject: OOPS: software raid5 crashes on kernel 2.4.20 SMP
Date: Tue, 24 Dec 2002 18:09:57 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021224180957.Y8793@kmv.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: mingo@redhat.com, linux-raid@vger.kernel.org
Cc: linux-smp@vger.kernel.org
List-Id: linux-raid.ids

ksymoops output:

No modules in ksyms, skipping objects
Warning (read_lsmod): no symbols in lsmod, is /proc/modules a valid lsmod file?

Unable to handle kernel paging request at virtual address 0000b2ed
0000b2ed
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<0000b2ed>]    Not tainted
EFLAGS: 00010002
eax: cc6bddcc   ebx: 00011000   ecx: 0000b2ed   edx: 00000296
esi: d1b5c556   edi: d1b5c55a   ebp: 00000004   esp: d1e41e68
ds: 0018   es: 0018   ss: 0018
Process raid5d (pid: 11, stackpage=d1e41000)
Stack: c0112a08 00000296 d1b782e0 c02498da d1b782e0 00000aa6 00000000 d1b5c556
       d1b5c55a 00000004 00000002 00000018 00000018 fffffffb c01e39a3 00000010
       00000246 00000001 c0123d8d 00000001 d1e41ec0 00000000 0000000c d1e41ec0
Call Trace:    [smp_call_function_interrupt+40/62] [handle_stripe+2979/3840] [timer_bh+77/1184] [update_wall_time+11/64] [raid5d+357/480]
Call Trace:    [<c0112a08>] [<c01e39a3>] [<c0123d8d>] [<c0123aeb>] [<c01e42e5>]
  [<c01ebbad>] [<c01057e6>] [<c01eb9b0>]
Code:  Bad EIP value.

>>EIP; 0000b2ed Before first symbol   <=====
Trace; c0112a08 <smp_call_function_interrupt+28/3e>
Trace; c01e39a3 <handle_stripe+ba3/f00>
Trace; c0123d8d <timer_bh+4d/4a0>
Trace; c0123aeb <update_wall_time+b/40>
Trace; c01e42e5 <raid5d+165/1e0>
Trace; c01ebbad <md_thread+1fd/2b0>
Trace; c01057e6 <kernel_thread+26/30>
Trace; c01eb9b0 <md_thread+0/2b0>

Unable to handle kernel paging request at virtual address 0000238d
0000238d
*pde = 00000000
Oops: 0000
CPU:    1
EIP:    0010:[<0000238d>]    Not tainted
EFLAGS: 00010002
eax: c2f39dcc   ebx: c027ba6c   ecx: 0000238d   edx: 00000296
esi: d1b29c94   edi: d1b29c98   ebp: 00000004   esp: d1e41e68
ds: 0018   es: 0018   ss: 0018
Process raid5d (pid: 11, stackpage=d1e41000)
Stack: c0112a08 00000296 d1b3b740 c02498da d1b3b740 00000368 00000000 d1b29c94
       d1b29c98 00000004 00000002 00000018 00000018 fffffffb c01e39a3 00000010
       00000246 c01b137c 00000006 00000000 d1e41ec8 c01bfd69 0000000c 00000286
Call Trace:    [smp_call_function_interrupt+40/62] [handle_stripe+2979/3840] [scsi_done+12/288] [ahc_linux_isr+777/848] [raid5d+357/480]
Call Trace:    [<c0112a08>] [<c01e39a3>] [<c01b137c>] [<c01bfd69>] [<c01e42e5>]
  [<c01ebbad>] [<c01057e6>] [<c01eb9b0>]
Code:  Bad EIP value.

>>EIP; 0000238d Before first symbol   <=====
Trace; c0112a08 <smp_call_function_interrupt+28/3e>
Trace; c01e39a3 <handle_stripe+ba3/f00>
Trace; c01b137c <scsi_done+c/120>
Trace; c01bfd69 <ahc_linux_isr+309/350>
Trace; c01e42e5 <raid5d+165/1e0>
Trace; c01ebbad <md_thread+1fd/2b0>
Trace; c01057e6 <kernel_thread+26/30>
Trace; c01eb9b0 <md_thread+0/2b0>

Unable to handle kernel paging request at virtual address 0000c195
0000c195
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0010:[<0000c195>]    Not tainted
EFLAGS: 00010002
eax: cd2e5dcc   ebx: 00011000   ecx: 0000c195   edx: 00000296
esi: d1b28a0c   edi: d1b28a10   ebp: 00000004   esp: d1e3de68
ds: 0018   es: 0018   ss: 0018
Process raid5d (pid: 11, stackpage=d1e3d000)
Stack: c0112a08 00000296 d1b442a0 c02498da d1b442a0 000005f0 00000000 d1b28a0c
       d1b28a10 00000004 00000000 00000018 00000018 fffffffb c01e39a3 00000010
       00000246 00000001 c0123d8d 00000001 d1e3dec0 00000000 0000000c d1e3dec0
Call Trace:    [smp_call_function_interrupt+40/62] [handle_stripe+2979/3840] [timer_bh+77/1184] [raid5d+357/480] [md_thread+509/688]
Call Trace:    [<c0112a08>] [<c01e39a3>] [<c0123d8d>] [<c01e42e5>] [<c01ebbad>]
  [<c01057e6>] [<c01eb9b0>]
Code:  Bad EIP value.

>>EIP; 0000c195 Before first symbol   <=====
Trace; c0112a08 <smp_call_function_interrupt+28/3e>
Trace; c01e39a3 <handle_stripe+ba3/f00>
Trace; c0123d8d <timer_bh+4d/4a0>
Trace; c01e42e5 <raid5d+165/1e0>
Trace; c01ebbad <md_thread+1fd/2b0>
Trace; c01057e6 <kernel_thread+26/30>
Trace; c01eb9b0 <md_thread+0/2b0>

Software version:
Linux pyat.kmv.ru 2.4.20-smp #2 SMP Tue Dec 10 18:00:53 MSK 2002 i586 unknown

Gnu C                  2.96
Gnu make               3.79.1
util-linux             2.11n
mount                  2.11n
modutils               2.4.18
e2fsprogs              1.27
reiserfsprogs          3.x.0j
Linux C Library        2.2.5
Dynamic linker (ldd)   2.2.5
Procps                 2.0.7
Net-tools              1.60
Console-tools          0.3.3
Sh-utils               2.0.11
Modules Loaded

/proc/cpuinfo:
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 5
model		: 2
model name	: Pentium 75 - 200
stepping	: 5
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: yes
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse msr mce cx8 apic
bogomips	: 53.04

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 5
model		: 2
model name	: Pentium 75 - 200
stepping	: 5
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: yes
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse msr mce cx8 apic
bogomips	: 53.24

/proc/ioports:
0000-001f : dma1
0020-003f : pic1
0040-005f : timer
0060-006f : keyboard
0070-007f : rtc
0080-008f : dma page reg
00a0-00bf : pic2
00c0-00df : dma2
00f0-00ff : fpu
02f8-02ff : serial(auto)
03c0-03df : vga+
03f8-03ff : serial(auto)
0cf8-0cff : PCI conf1
ef80-ef9f : Intel Corp. 82557/8/9 [Ethernet Pro 100]
  ef80-ef9f : eepro100
f800-f8ff : Adaptec AHA-294x / AIC-7870 (#2)
fc00-fcff : Adaptec AHA-294x / AIC-7870

/proc/iomem:
00000000-0009fbff : System RAM
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000cc7ff : Extension ROM
000cc800-000d0fff : Extension ROM
000f0000-000fffff : System ROM
00100000-11ffffff : System RAM
  00100000-0023fda6 : Kernel code
  0023fda7-002941bf : Kernel data
12000000-120003ff : Intel Corp. Extended Express System Support Controller
12000400-120007ff : Intel Corp. Extended Express System Support Controller
12000800-12000bff : Intel Corp. Extended Express System Support Controller
12000c00-12000fff : Intel Corp. Extended Express System Support Controller
12001000-120013ff : Intel Corp. Extended Express System Support Controller
fec00000-fec003ff : reserved
fee00000-fee00fff : reserved
ffa00000-ffafffff : Intel Corp. 82557/8/9 [Ethernet Pro 100]
ffcfe000-ffcfefff : Adaptec AHA-294x / AIC-7870 (#2)
  ffcfe000-ffcfefff : aic7xxx
ffcff000-ffcfffff : Adaptec AHA-294x / AIC-7870
  ffcff000-ffcfffff : aic7xxx
ffe7ec00-ffe7efff : Intel Corp. Extended Express System Support Controller
ffe7f000-ffe7ffff : Intel Corp. 82557/8/9 [Ethernet Pro 100]
  ffe7f000-ffe7ffff : eepro100
ffe80000-ffffffff : reserved

lspci -vvv:
00:00.0 Host bridge: Intel Corp. 82452KX/GX [Orion] (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 6 (500ns min)

00:0d.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Latency: 66 (2000ns min, 14000ns max)
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at ffe7f000 (32-bit, prefetchable) [size=4K]
	Region 1: I/O ports at ef80 [size=32]
	Region 2: Memory at ffa00000 (32-bit, non-prefetchable) [size=1M]
	Expansion ROM at <unassigned> [disabled] [size=1M]

00:0e.0 Non-VGA unclassified device: Intel Corp. 82375EB (rev 05)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 248

00:0f.0 Class ff00: Intel Corp.: Unknown device 0008
	Subsystem: Unknown device ec08:ffe7
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Region 0: Memory at ffe7ec00 (32-bit, prefetchable) [size=1K]
	Region 1: Memory at 12000000 (32-bit, prefetchable) [size=1K]
	Region 2: Memory at 12000400 (32-bit, prefetchable) [size=1K]
	Region 3: Memory at 12000800 (32-bit, prefetchable) [size=1K]
	Region 4: Memory at 12000c00 (32-bit, prefetchable) [size=1K]
	Region 5: Memory at 12001000 (32-bit, prefetchable) [size=1K]
	Expansion ROM at fffff800 [disabled] [size=2K]

01:00.0 Host bridge: Intel Corp. 82452KX/GX [Orion] (rev 02)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 6 (500ns min)

01:0d.0 SCSI storage controller: Adaptec AHA-294x / AIC-7870 (rev 03)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Latency: 64 (2000ns min, 2000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at fc00 [disabled] [size=256]
	Region 1: Memory at ffcff000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at <unassigned> [disabled] [size=64K]

01:0e.0 SCSI storage controller: Adaptec AHA-294x / AIC-7870 (rev 03)
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Latency: 64 (2000ns min, 2000ns max), cache line size 08
	Interrupt: pin A routed to IRQ 9
	Region 0: I/O ports at f800 [disabled] [size=256]
	Region 1: Memory at ffcfe000 (32-bit, non-prefetchable) [size=4K]
	Expansion ROM at <unassigned> [disabled] [size=64K]

/proc/scsi/scsi:

Attached devices: 
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: HP       Model: 4.26 GB 1ST      Rev: 1071
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: HP       Model: 4.26 GB 1ST      Rev: 1071
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 05 Lun: 00
  Vendor: SONY     Model: CD-ROM CDU-76S   Rev: 1.1c
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: HP       Model: 4.26GB A 80-LXP0 Rev: LXP0
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 05 Lun: 00
  Vendor: HP       Model: 4.26GB A 80-LXP0 Rev: LXP0
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 00
  Vendor: HP       Model: 4.26GB B 80-L918 Rev: L918
  Type:   Direct-Access                    ANSI SCSI revision: 02

/proc/mdstat:

Personalities : [raid5] 
read_ahead 1024 sectors
md0 : active raid5 sde1[2] sdd1[1] sdc1[0] sdb1[3]
      8328960 blocks level 5, 4k chunk, algorithm 2 [3/3] [UUU]
      
unused devices: <none>

-- 
 Best regards, TEMHOTA-RIPN aka MJA13-RIPE
 System Administrator. mailto:temnota@kmv.ru

