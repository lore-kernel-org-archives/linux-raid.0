From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: raid5:md3: kernel BUG , followed by , Silent halt .
Date: Sat, 25 Aug 2007 19:27:26 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0708251903200.6971@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
 <Pine.LNX.4.64.0708181328510.14169@filesrv1.baby-dragons.com>
 <e9c3a7c20708201029l15e37d8eh9db6714be6a8e7b8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="566704117-1411616311-1188095246=:6971"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20708201029l15e37d8eh9db6714be6a8e7b8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--566704117-1411616311-1188095246=:6971
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

 	Hello Dan ,

On Mon, 20 Aug 2007, Dan Williams wrote:
> On 8/18/07, Mr. James W. Laferriere <babydr@baby-dragons.com> wrote:
>>         Hello All ,  Here we go again .  Again attempting to do bonnie++ testing
>> on a small array .
>>         Kernel 2.6.22.1
>>         Patches involved ,
>>         IOP1 ,  2.6.22.1-iop1 for improved sequential write performance
>> (stripe-queue) ,  Dan Williams <dan.j.williams@intel.com>
>
> Hello James,
>
> Thanks for the report.
>
> I tried to reproduce this on my system, no luck.
 	Possibly because there is significant hardware differances ?
 	See 'lspci -v' below .sig .

> However it looks
> like their is a potential race between 'handle_queue' and
> 'add_queue_bio'.  The attached patch moves these critical sections
> under spin_lock(&sq->lock), and adds some debugging output if this BUG
> triggers.  It also includes a fix for retry_aligned_read which is
> unrelated to this debug.
> --
> Dan
 	Applied your patch .  The same 'kernel BUG at drivers/md/raid5.c:3689!' 
messages appear (see attached) .  The system is still responsive with your 
patch ,  the kernel crashed last time .  Tho the bonnie++ run is stuck in 'D' .
And doing a '> /md3/asdf'  stays hung even after passing the parent process a 
'kill -9' .
 	Any further info You can think of I can/should ,  I will try to acquire 
.  But I'll have to repeat these steps to attempt to get the same results . 
I'll be shutting the system down after sending this off .
 	Fyi ,  the previous 'BUG" without your patch was quite repeatable .
 	I might have time over the next couple of weeks to be able to see if it 
is as repatable as the last one .

 	Contents of /proc/mdstat for md3 .

md3 : active raid6 sdx1[3] sdw1[2] sdv1[1] sdu1[0] sdt1[7](S) sds1[6] sdr1[5] sdq1[4]
       717378560 blocks level 6, 1024k chunk, algorithm 2 [7/7] [UUUUUUU]
       bitmap: 2/137 pages [8KB], 512KB chunk

 	Commands I ran that lead to the 'BUG' .

bonniemd3() { /root/bonnie++-1.03a/bonnie++  -u0:0  -d /md3  -s 131072  -f; }
bonniemd3 > 131072MB-bonnie++-run-md3-xfs.log-20070825 2>&1 &

  root@filesrv2:~ # top
top - 02:22:09 up  3:39,  2 users,  load average: 3.09, 2.89, 2.48
Tasks: 155 total,   1 running, 154 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu3  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu4  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu6  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Cpu7  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   8256156k total,  7995044k used,   261112k free,     7480k buffers
Swap:   987896k total,     2784k used,   985112k free,  7787320k cached

   PID USER     P  PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  4073 root     0  18   0     0    0    0 D    0  0.0  15:10.86 [bonnie++]
  4076 root     5  15   0  3000 1828 1252 D    0  0.0   0:00.05 -bash
  4308 root     5  15   0     0    0    0 D    0  0.0   0:01.40 [pdflush]
  4422 root     6  18   0  2212 1168  860 R    0  0.0   0:00.13 top


  root@filesrv2:~ # ps -auxww | grep -C3 bonni
Warning: bad ps syntax, perhaps a bogus '-'? See http://procps.sf.net/faq.html
root      4029  0.0  0.0      0     0 ?        S<   Aug25   0:01 [xfsbufd]
root      4030  0.0  0.0      0     0 ?        S<   Aug25   0:00 [xfssyncd]
root      4072  0.0  0.0   2992   848 ?        S    Aug25   0:00 -bash
root      4073  7.3  0.0      0     0 ?        D    Aug25  15:10 [bonnie++]
root      4074  0.1  0.0   6412  1980 ?        Ss   Aug25   0:12 sshd: root@pts/1
root      4076  0.0  0.0   3000  1828 pts/1    Ds+  Aug25   0:00 -bash
root      4302  0.1  0.0      0     0 ?        S    00:50   0:08 [pdflush]


-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+

  root@filesrv2:~ # lspci -v
00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller Hub (rev b1)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: bus master, fast devsel, latency 0
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
         Capabilities: [6c] Express Root Port (Slot-) IRQ 0
         Capabilities: [100] Advanced Error Reporting

00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 2-3 (rev b1) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=01, subordinate=07, sec-latency=0
         I/O behind bridge: 00002000-00003fff
         Memory behind bridge: d8300000-d85fffff
         Prefetchable memory behind bridge: 00000000d8000000-00000000d8100000
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable+
         Capabilities: [6c] Express Root Port (Slot-) IRQ 0
         Capabilities: [100] Advanced Error Reporting

00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 4-5 (rev b1) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=08, subordinate=08, sec-latency=0
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable+
         Capabilities: [6c] Express Root Port (Slot+) IRQ 0
         Capabilities: [100] Advanced Error Reporting

00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 6-7 (rev b1) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=09, subordinate=0b, sec-latency=0
         I/O behind bridge: 00004000-00004fff
         Memory behind bridge: d8200000-d82fffff
         Prefetchable memory behind bridge: 00000000d8800000-00000000d8900000
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable+
         Capabilities: [6c] Express Root Port (Slot+) IRQ 0
         Capabilities: [100] Advanced Error Reporting

00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA Engine (rev b1)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: bus master, fast devsel, latency 0, IRQ 9
         Memory at fe700000 (64-bit, non-prefetchable) [size=1K]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/0 Enable-
         Capabilities: [6c] Express Unknown type IRQ 0

00:10.0 Host bridge: Intel Corporation 5000 Series Chipset Error Reporting Registers (rev b1)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: fast devsel

00:10.1 Host bridge: Intel Corporation 5000 Series Chipset Error Reporting Registers (rev b1)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: fast devsel

00:10.2 Host bridge: Intel Corporation 5000 Series Chipset Error Reporting Registers (rev b1)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: fast devsel

00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev b1)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: fast devsel

00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev b1)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: fast devsel

00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev b1)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: fast devsel

00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev b1)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: fast devsel

00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI Express Root Port 1 (rev 09) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=0c, subordinate=0e, sec-latency=0
         I/O behind bridge: 00005000-00005fff
         Memory behind bridge: d8600000-d86fffff
         Prefetchable memory behind bridge: 00000000d8a00000-00000000d8b00000
         Capabilities: [40] Express Root Port (Slot+) IRQ 0
         Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0 Enable+
         Capabilities: [90] #0d [0000]
         Capabilities: [a0] Power Management version 2
         Capabilities: [100] Virtual Channel
         Capabilities: [180] Unknown (5)

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9) (prog-if 01 [Subtractive decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=00, secondary=0f, subordinate=0f, sec-latency=32
         I/O behind bridge: 00006000-00006fff
         Memory behind bridge: d8700000-d87fffff
         Prefetchable memory behind bridge: 00000000d0000000-00000000d7f00000
         Capabilities: [50] #0d [0000]

00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC Interface Controller (rev 09)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: bus master, medium devsel, latency 0

00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller (rev 09) (prog-if 8a [Master SecP PriP])
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: bus master, medium devsel, latency 0, IRQ 17
         I/O ports at 01f0 [size=8]
         I/O ports at 03f4 [size=1]
         I/O ports at 0170 [size=8]
         I/O ports at 0374 [size=1]
         I/O ports at 1800 [size=16]

00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus Controller (rev 09)
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: medium devsel, IRQ 19
         I/O ports at 1100 [size=32]

01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstream Port (rev 01) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=01, secondary=02, subordinate=06, sec-latency=0
         I/O behind bridge: 00002000-00003fff
         Memory behind bridge: d8400000-d85fffff
         Prefetchable memory behind bridge: 00000000d8000000-00000000d8100000
         Capabilities: [44] Express Upstream Port IRQ 0
         Capabilities: [70] Power Management version 2
         Capabilities: [80] #0d [0000]
         Capabilities: [100] Advanced Error Reporting

01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PCI-X Bridge (rev 01) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=01, secondary=07, subordinate=07, sec-latency=64
         Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
         Capabilities: [6c] Power Management version 2
         Capabilities: [80] #0d [0000]
         Capabilities: [d8] PCI-X bridge device
         Capabilities: [100] Advanced Error Reporting

02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E1 (rev 01) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=02, secondary=03, subordinate=05, sec-latency=0
         I/O behind bridge: 00002000-00002fff
         Memory behind bridge: d8400000-d84fffff
         Prefetchable memory behind bridge: 00000000d8000000-00000000d8100000
         Capabilities: [44] Express Downstream Port (Slot-) IRQ 0
         Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
         Capabilities: [70] Power Management version 2
         Capabilities: [80] #0d [0000]
         Capabilities: [100] Advanced Error Reporting

02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E3 (rev 01) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=02, secondary=06, subordinate=06, sec-latency=0
         I/O behind bridge: 00003000-00003fff
         Memory behind bridge: d8500000-d85fffff
         Capabilities: [44] Express Downstream Port (Slot-) IRQ 0
         Capabilities: [60] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
         Capabilities: [70] Power Management version 2
         Capabilities: [80] #0d [0000]
         Capabilities: [100] Advanced Error Reporting

03:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge A (rev 09) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=03, secondary=04, subordinate=04, sec-latency=64
         I/O behind bridge: 00002000-00002fff
         Memory behind bridge: d8400000-d84fffff
         Prefetchable memory behind bridge: 00000000d8000000-00000000d8100000
         Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
         Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [6c] Power Management version 2
         Capabilities: [d8] PCI-X bridge device
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [300] Power Budgeting

03:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge B (rev 09) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=03, secondary=05, subordinate=05, sec-latency=64
         Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
         Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [6c] Power Management version 2
         Capabilities: [d8] PCI-X bridge device
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [300] Power Budgeting

04:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
         Subsystem: LSI Logic / Symbios Logic Unknown device 30e0
         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 16
         I/O ports at 2000 [size=256]
         Memory at d8420000 (64-bit, non-prefetchable) [size=128K]
         Memory at d8400000 (64-bit, non-prefetchable) [size=128K]
         [virtual] Expansion ROM at d8000000 [disabled] [size=1M]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [68] PCI-X non-bridge device

04:01.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI (rev 08)
         Subsystem: LSI Logic / Symbios Logic Unknown device 30e0
         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 18
         I/O ports at 2400 [size=256]
         Memory at d8460000 (64-bit, non-prefetchable) [size=128K]
         Memory at d8440000 (64-bit, non-prefetchable) [size=128K]
         [virtual] Expansion ROM at d8100000 [disabled] [size=1M]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [68] PCI-X non-bridge device

06:00.0 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN Controller Copper (rev 01)
         Subsystem: Super Micro Computer Inc Unknown device 0000
         Flags: bus master, fast devsel, latency 0, IRQ 217
         Memory at d8500000 (32-bit, non-prefetchable) [size=128K]
         I/O ports at 3000 [size=32]
         Capabilities: [c8] Power Management version 2
         Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
         Capabilities: [e0] Express Endpoint IRQ 0
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Device Serial Number 9c-9d-34-ff-ff-48-30-00

06:00.1 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN Controller Copper (rev 01)
         Subsystem: Super Micro Computer Inc Unknown device 0000
         Flags: bus master, fast devsel, latency 0, IRQ 19
         Memory at d8520000 (32-bit, non-prefetchable) [size=128K]
         I/O ports at 3020 [size=32]
         Capabilities: [c8] Power Management version 2
         Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [e0] Express Endpoint IRQ 0
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Device Serial Number 9c-9d-34-ff-ff-48-30-00

09:00.0 PCI bridge: Intel Corporation 41210 [Lanai] Serial to Parallel PCI Bridge (A-Segment Bridge) (rev 09) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=09, secondary=0a, subordinate=0a, sec-latency=136
         I/O behind bridge: 00004000-00004fff
         Memory behind bridge: d8200000-d82fffff
         Prefetchable memory behind bridge: 00000000d8800000-00000000d8900000
         Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
         Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [6c] Power Management version 2
         Capabilities: [d8] PCI-X bridge device
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [300] Power Budgeting

09:00.2 PCI bridge: Intel Corporation 41210 [Lanai] Serial to Parallel PCI Bridge (B-Segment Bridge) (rev 09) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=09, secondary=0b, subordinate=0b, sec-latency=0
         Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
         Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [6c] Power Management version 2
         Capabilities: [d8] PCI-X bridge device
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [300] Power Budgeting

0a:04.0 SCSI storage controller: Atto Technology Ultra320 SCSI Host Adapter (rev 08)
         Subsystem: Atto Technology Unknown device 8027
         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 17
         I/O ports at 4000 [size=256]
         Memory at d8240000 (64-bit, non-prefetchable) [size=256K]
         Memory at d8200000 (64-bit, non-prefetchable) [size=256K]
         [virtual] Expansion ROM at d8800000 [disabled] [size=1M]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [68] PCI-X non-bridge device

0a:04.1 SCSI storage controller: Atto Technology Ultra320 SCSI Host Adapter (rev 08)
         Subsystem: Atto Technology Unknown device 8027
         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 19
         I/O ports at 4400 [size=256]
         Memory at d82c0000 (64-bit, non-prefetchable) [size=256K]
         Memory at d8280000 (64-bit, non-prefetchable) [size=256K]
         [virtual] Expansion ROM at d8900000 [disabled] [size=1M]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [68] PCI-X non-bridge device

0c:00.0 PCI bridge: Intel Corporation 41210 [Lanai] Serial to Parallel PCI Bridge (A-Segment Bridge) (rev 09) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=0c, secondary=0d, subordinate=0d, sec-latency=136
         I/O behind bridge: 00005000-00005fff
         Memory behind bridge: d8600000-d86fffff
         Prefetchable memory behind bridge: 00000000d8a00000-00000000d8b00000
         Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
         Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [6c] Power Management version 2
         Capabilities: [d8] PCI-X bridge device
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [300] Power Budgeting

0c:00.2 PCI bridge: Intel Corporation 41210 [Lanai] Serial to Parallel PCI Bridge (B-Segment Bridge) (rev 09) (prog-if 00 [Normal decode])
         Flags: bus master, fast devsel, latency 0
         Bus: primary=0c, secondary=0e, subordinate=0e, sec-latency=0
         Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
         Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [6c] Power Management version 2
         Capabilities: [d8] PCI-X bridge device
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [300] Power Budgeting

0d:04.0 SCSI storage controller: Atto Technology Ultra320 SCSI Host Adapter (rev 08)
         Subsystem: Atto Technology Unknown device 8027
         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 16
         I/O ports at 5000 [size=256]
         Memory at d8640000 (64-bit, non-prefetchable) [size=256K]
         Memory at d8600000 (64-bit, non-prefetchable) [size=256K]
         [virtual] Expansion ROM at d8a00000 [disabled] [size=1M]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [68] PCI-X non-bridge device

0d:04.1 SCSI storage controller: Atto Technology Ultra320 SCSI Host Adapter (rev 08)
         Subsystem: Atto Technology Unknown device 8027
         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 18
         I/O ports at 5400 [size=256]
         Memory at d86c0000 (64-bit, non-prefetchable) [size=256K]
         Memory at d8680000 (64-bit, non-prefetchable) [size=256K]
         [virtual] Expansion ROM at d8b00000 [disabled] [size=1M]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
         Capabilities: [68] PCI-X non-bridge device

0f:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02) (prog-if 00 [VGA])
         Subsystem: Super Micro Computer Inc Unknown device 8080
         Flags: bus master, stepping, fast Back2Back, medium devsel, latency 66, IRQ 17
         Memory at d0000000 (32-bit, prefetchable) [size=128M]
         I/O ports at 6000 [size=256]
         Memory at d8700000 (32-bit, non-prefetchable) [size=64K]
         [virtual] Expansion ROM at d8720000 [disabled] [size=128K]
         Capabilities: [50] Power Management version 2
--566704117-1411616311-1188095246=:6971
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=junky123
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0708251927260.6971@filesrv1.baby-dragons.com>
Content-Description: 
Content-Disposition: attachment; filename=junky123

DQpBdWcgMjUgMjI6NDk6MjUgZmlsZXNydjIga2VybmVsOiBGaWxlc3lzdGVt
ICJtZDMiOiBEaXNhYmxpbmcgYmFycmllcnMsIG5vdCBzdXBwb3J0ZWQgYnkg
dGhlIHVuZGVybHlpbmcgZGV2aWNlDQpBdWcgMjUgMjI6NDk6MjUgZmlsZXNy
djIga2VybmVsOiBYRlMgbW91bnRpbmcgZmlsZXN5c3RlbSBtZDMNCkF1ZyAy
NSAyMjo0OToyNSBmaWxlc3J2MiBrZXJuZWw6IEVuZGluZyBjbGVhbiBYRlMg
bW91bnQgZm9yIGZpbGVzeXN0ZW06IG1kMw0KQXVnIDI1IDIyOjQ5OjI1IGZp
bGVzcnYyIGtlcm5lbDogRmlsZXN5c3RlbSAibWQ0IjogRGlzYWJsaW5nIGJh
cnJpZXJzLCBub3Qgc3VwcG9ydGVkIGJ5IHRoZSB1bmRlcmx5aW5nIGRldmlj
ZQ0KQXVnIDI1IDIyOjQ5OjI1IGZpbGVzcnYyIGtlcm5lbDogWEZTIG1vdW50
aW5nIGZpbGVzeXN0ZW0gbWQ0DQpBdWcgMjUgMjI6NDk6MjUgZmlsZXNydjIg
a2VybmVsOiBTdGFydGluZyBYRlMgcmVjb3Zlcnkgb24gZmlsZXN5c3RlbTog
bWQ0IChsb2dkZXY6IGludGVybmFsKQ0KQXVnIDI1IDIyOjQ5OjI1IGZpbGVz
cnYyIGtlcm5lbDogRW5kaW5nIFhGUyByZWNvdmVyeSBvbiBmaWxlc3lzdGVt
OiBtZDQgKGxvZ2RldjogaW50ZXJuYWwpDQpBdWcgMjUgMjI6NTc6MDAgZmls
ZXNydjIgc3NoZFs0MDc0XTogQWNjZXB0ZWQgcGFzc3dvcmQgZm9yIHJvb3Qg
ZnJvbSAxOTkuMzMuMjQ1LjU1IHBvcnQgNDQ5Nzkgc3NoMg0KQXVnIDI1IDIz
OjI0OjQ2IGZpbGVzcnYyIC0tIE1BUksgLS0NCkF1ZyAyNSAyMzo0NDo0NiBm
aWxlc3J2MiAtLSBNQVJLIC0tDQpBdWcgMjYgMDA6MDQ6NDYgZmlsZXNydjIg
LS0gTUFSSyAtLQ0KQXVnIDI2IDAwOjI0OjQ2IGZpbGVzcnYyIC0tIE1BUksg
LS0NCkF1ZyAyNiAwMDo0NDo0NyBmaWxlc3J2MiAtLSBNQVJLIC0tDQotLS0t
LS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NCmtlcm5lbCBCVUcg
YXQgZHJpdmVycy9tZC9yYWlkNS5jOjM2ODkhDQppbnZhbGlkIG9wY29kZTog
MDAwMCBbIzFdDQpTTVANCk1vZHVsZXMgbGlua2VkIGluOg0KQ1BVOiAgICAw
DQpFSVA6ICAgIDAwNjA6WzxjMDZlZWI3YT5dICAgIE5vdCB0YWludGVkIFZM
SQ0KRUZMQUdTOiAwMDAxMDI4NiAgICgyLjYuMjIuMS1pb3AxICMzKQ0KRUlQ
IGlzIGF0IGhhbmRsZV9xdWV1ZSsweGVhLzB4ZjANCmVheDogZjYxMDdjMzAg
ICBlYng6IGY2MjNkYzI4ICAgZWN4OiAwMDAwMDAwMyAgIGVkeDogMDAwMDAw
MDANCmVzaTogMDAwMDAwMDcgICBlZGk6IDAwMDAwMDAwICAgZWJwOiBlZjFi
MThkYyAgIGVzcDogZWYxYjE4YzgNCmRzOiAwMDdiICAgZXM6IDAwN2IgICBm
czogMDBkOCAgZ3M6IDAwMzMgIHNzOiAwMDY4DQpQcm9jZXNzIGJvbm5pZSsr
IChwaWQ6IDQwNzMsIHRpPWVmMWIwMDAwIHRhc2s9ZjdkM2UwMzAgdGFzay50
aT1lZjFiMDAwMCkNClN0YWNrOiBmNjIzZGM0NCAwMDAwMDAwNSBmNjIzZGMy
OCBmNzMwYmUwMCAwMDAwMDAwNyBlZjFiMTk3NCBjMDZlZjc2NyAwMDAwMDAw
MQ0KICAgICAgIDAwMDAwMDA2IDAwMDAwMDAwIGY3MzBiZTAwIGY3MzBiZmEw
IGY3MzBiZjQwIDAwMDAwMDAzIDAwMDAwMDA1IDAwMDAwMDAxDQogICAgICAg
MGU0ZWZiZTAgMDAwMDAwMDAgMGU0ZWZiOTggMDAwMDAwMDAgZjdmZDFjMDAg
ZjQyNDM0MDAgMDAwMDAwMDEgMDAwMDAwMDYNCkNhbGwgVHJhY2U6DQogWzxj
MDEwMzg1YT5dIHNob3dfdHJhY2VfbG9nX2x2bCsweDFhLzB4MzANCiBbPGMw
MTAzOTJhPl0gc2hvd19zdGFja19sb2dfbHZsKzB4OWEvMHhjMA0KIFs8YzAx
MDNiODY+XSBzaG93X3JlZ2lzdGVycysweDFkNi8weDJlMA0KIFs8YzAxMDNk
ZmU+XSBkaWUrMHgxMGUvMHgyMTANCiBbPGMwMTAzZjkxPl0gZG9fdHJhcCsw
eDkxLzB4ZDANCiBbPGMwMTA0MjM5Pl0gZG9faW52YWxpZF9vcCsweDg5LzB4
YTANCiBbPGMwODA1NzQyPl0gZXJyb3JfY29kZSsweDcyLzB4NzgNCiBbPGMw
NmVmNzY3Pl0gbWFrZV9yZXF1ZXN0KzB4MmY3LzB4M2YwDQogWzxjMDNmODY2
NT5dIGdlbmVyaWNfbWFrZV9yZXF1ZXN0KzB4MWQ1LzB4MmMwDQogWzxjMDNm
ODc5Zj5dIHN1Ym1pdF9iaW8rMHg0Zi8weGYwDQogWzxjMDM4NjBhZT5dIHhm
c19zdWJtaXRfaW9lbmRfYmlvKzB4MWUvMHgzMA0KIFs8YzAzODYyZTI+XSB4
ZnNfc3VibWl0X2lvZW5kKzB4ZjIvMHgxMDANCiBbPGMwMzg3MTEwPl0geGZz
X3BhZ2Vfc3RhdGVfY29udmVydCsweDQzMC8weDY0MA0KIFs8YzAzODczODM+
XSB4ZnNfdm1fd3JpdGVwYWdlKzB4NjMvMHgxMDANCiBbPGMwMTViMjNiPl0g
X193cml0ZXBhZ2UrMHhiLzB4MzANCiBbPGMwMTViMTM2Pl0gd3JpdGVfY2Fj
aGVfcGFnZXMrMHgyMDYvMHgzMDANCiBbPGMwMTViMjhmPl0gZ2VuZXJpY193
cml0ZXBhZ2VzKzB4MmYvMHg0MA0KIFs8YzAzODc0NDQ+XSB4ZnNfdm1fd3Jp
dGVwYWdlcysweDI0LzB4NjANCiBbPGMwMTViMmNlPl0gZG9fd3JpdGVwYWdl
cysweDJlLzB4NTANCiBbPGMwMTk1YjU4Pl0gX193cml0ZWJhY2tfc2luZ2xl
X2lub2RlKzB4MTg4LzB4MWUwDQogWzxjMDE5NWNkZD5dIHN5bmNfc2JfaW5v
ZGVzKzB4MTJkLzB4MjUwDQogWzxjMDE5NWVjYz5dIHdyaXRlYmFja19pbm9k
ZXMrMHhjYy8weGUwDQogWzxjMDE1YTljMj5dIGJhbGFuY2VfZGlydHlfcGFn
ZXMrMHg1Mi8weDE3MA0KIFs8YzAxNWFiNzY+XSBiYWxhbmNlX2RpcnR5X3Bh
Z2VzX3JhdGVsaW1pdGVkX25yKzB4NTYvMHg2MA0KIFs8YzAxNTZlYjY+XSBn
ZW5lcmljX2ZpbGVfYnVmZmVyZWRfd3JpdGUrMHgyOTYvMHg2NDANCiBbPGMw
MzhlY2Q3Pl0geGZzX3dyaXRlKzB4N2I3LzB4YjQwDQogWzxjMDM4YTE3Mj5d
IHhmc19maWxlX2Fpb193cml0ZSsweDcyLzB4ODANCiBbPGMwMTc3ZWQ3Pl0g
ZG9fc3luY193cml0ZSsweGM3LzB4MTIwDQogWzxjMDE3ODBjMD5dIHZmc193
cml0ZSsweDE5MC8weDFhMA0KIFs8YzAxNzgxN2Q+XSBzeXNfd3JpdGUrMHgz
ZC8weDcwDQogWzxjMDEwMmE3Nj5dIHN5c2NhbGxfY2FsbCsweDcvMHhiDQog
PT09PT09PT09PT09PT09PT09PT09PT0NCkNvZGU6IDk1IGZmIGZmIDgzIGM0
IDA4IDViIDVlIDVmIDVkIGMzIGYwIDBmIGJhIDZiIDNjIDAyIGI5IDAxIDAw
IDAwIDAwIDg5IGYyIDg5IGQ4IGU4IDMyIDlhIGZmIGZmIDg5IGM3IGViIDlm
IGYwIDBmIGJhIDZiIDNjIDAxIGViIGU2IDwwZj4gMGIgZWIgZmUgODkgZjYg
NTUgODkgZTUgODMgZWMgMTQgODkgNzUgZjggODkgYzYgODkgNWQgZjQgODkN
CkVJUDogWzxjMDZlZWI3YT5dIGhhbmRsZV9xdWV1ZSsweGVhLzB4ZjAgU1M6
RVNQIDAwNjg6ZWYxYjE4YzgNCkF1ZyAyNiAwMDo1NjozMyBmaWxlc3J2MiBr
ZXJuZWw6IC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQ0K
QXVnIDI2IDAwOjU2OjMzIGZpbGVzcnYyIGtlcm5lbDoga2VybmVsIEJVRyBh
dCBkcml2ZXJzL21kL3JhaWQ1LmM6MzY4OSENCkF1ZyAyNiAwMDo1NjozMyBm
aWxlc3J2MiBrZXJuZWw6IGludmFsaWQgb3Bjb2RlOiAwMDAwIFsjMV0NCkF1
ZyAyNiAwMDo1NjozMyBmaWxlc3J2MiBrZXJuZWw6IFNNUA0KQXVnIDI2IDAw
OjU2OjMzIGZpbGVzcnYyIGtlcm5lbDogTW9kdWxlcyBsaW5rZWQgaW46DQpB
dWcgMjYgMDA6NTY6MzMgZmlsZXNydjIga2VybmVsOiBDUFU6ICAgIDANCkF1
ZyAyNiAwMDo1NjozMyBmaWxlc3J2MiBrZXJuZWw6IEVJUDogICAgMDA2MDpb
PGMwNmVlYjdhPl0gICAgTm90IHRhaW50ZWQgVkxJDQpBdWcgMjYgMDA6NTY6
MzMgZmlsZXNydjIga2VybmVsOiBFRkxBR1M6IDAwMDEwMjg2ICAgKDIuNi4y
Mi4xLWlvcDEgIzMpDQpBdWcgMjYgMDA6NTY6MzMgZmlsZXNydjIga2VybmVs
OiBFSVAgaXMgYXQgaGFuZGxlX3F1ZXVlKzB4ZWEvMHhmMA0KQXVnIDI2IDAw
OjU2OjMzIGZpbGVzcnYyIGtlcm5lbDogZWF4OiBmNjEwN2MzMCAgIGVieDog
ZjYyM2RjMjggICBlY3g6IDAwMDAwMDAzICAgZWR4OiAwMDAwMDAwMA0KQXVn
IDI2IDAwOjU2OjMzIGZpbGVzcnYyIGtlcm5lbDogZXNpOiAwMDAwMDAwNyAg
IGVkaTogMDAwMDAwMDAgICBlYnA6IGVmMWIxOGRjICAgZXNwOiBlZjFiMThj
OA0KQXVnIDI2IDAwOjU2OjMzIGZpbGVzcnYyIGtlcm5lbDogZHM6IDAwN2Ig
ICBlczogMDA3YiAgIGZzOiAwMGQ4ICBnczogMDAzMyAgc3M6IDAwNjgNCkF1
ZyAyNiAwMDo1NjozMyBmaWxlc3J2MiBrZXJuZWw6IFByb2Nlc3MgYm9ubmll
KysgKHBpZDogNDA3MywgdGk9ZWYxYjAwMDAgdGFzaz1mN2QzZTAzMCB0YXNr
LnRpPWVmMWIwMDAwKQ0KQXVnIDI2IDAwOjU2OjMzIGZpbGVzcnYyIGtlcm5l
bDogU3RhY2s6IGY2MjNkYzQ0IDAwMDAwMDA1IGY2MjNkYzI4IGY3MzBiZTAw
IDAwMDAwMDA3IGVmMWIxOTc0IGMwNmVmNzY3IDAwMDAwMDAxDQpBdWcgMjYg
MDA6NTY6MzMgZmlsZXNydjIga2VybmVsOiAgICAgICAgMDAwMDAwMDYgMDAw
MDAwMDAgZjczMGJlMDAgZjczMGJmYTAgZjczMGJmNDAgMDAwMDAwMDMgMDAw
MDAwMDUgMDAwMDAwMDENCkF1ZyAyNiAwMDo1NjozNCBmaWxlc3J2MiBrZXJu
ZWw6ICAgICAgICAwZTRlZmJlMCAwMDAwMDAwMCAwZTRlZmI5OCAwMDAwMDAw
MCBmN2ZkMWMwMCBmNDI0MzQwMCAwMDAwMDAwMSAwMDAwMDAwNg0KQXVnIDI2
IDAwOjU2OjM0IGZpbGVzcnYyIGtlcm5lbDogQ2FsbCBUcmFjZToNCkF1ZyAy
NiAwMDo1NjozNCBmaWxlc3J2MiBrZXJuZWw6ICBbPGMwMTAzODVhPl0gc2hv
d190cmFjZV9sb2dfbHZsKzB4MWEvMHgzMA0KQXVnIDI2IDAwOjU2OjM0IGZp
bGVzcnYyIGtlcm5lbDogIFs8YzAxMDM5MmE+XSBzaG93X3N0YWNrX2xvZ19s
dmwrMHg5YS8weGMwDQpBdWcgMjYgMDA6NTY6MzQgZmlsZXNydjIga2VybmVs
OiAgWzxjMDEwM2I4Nj5dIHNob3dfcmVnaXN0ZXJzKzB4MWQ2LzB4MmUwDQpB
dWcgMjYgMDA6NTY6MzQgZmlsZXNydjIga2VybmVsOiAgWzxjMDEwM2RmZT5d
IGRpZSsweDEwZS8weDIxMA0KQXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYyIGtl
cm5lbDogIFs8YzAxMDNmOTE+XSBkb190cmFwKzB4OTEvMHhkMA0KQXVnIDI2
IDAwOjU2OjM0IGZpbGVzcnYyIGtlcm5lbDogIFs8YzAxMDQyMzk+XSBkb19p
bnZhbGlkX29wKzB4ODkvMHhhMA0KQXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYy
IGtlcm5lbDogIFs8YzA4MDU3NDI+XSBlcnJvcl9jb2RlKzB4NzIvMHg3OA0K
QXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYyIGtlcm5lbDogIFs8YzA2ZWY3Njc+
XSBtYWtlX3JlcXVlc3QrMHgyZjcvMHgzZjANCkF1ZyAyNiAwMDo1NjozNCBm
aWxlc3J2MiBrZXJuZWw6ICBbPGMwM2Y4NjY1Pl0gZ2VuZXJpY19tYWtlX3Jl
cXVlc3QrMHgxZDUvMHgyYzANCkF1ZyAyNiAwMDo1NjozNCBmaWxlc3J2MiBr
ZXJuZWw6ICBbPGMwM2Y4NzlmPl0gc3VibWl0X2JpbysweDRmLzB4ZjANCkF1
ZyAyNiAwMDo1NjozNCBmaWxlc3J2MiBrZXJuZWw6ICBbPGMwMzg2MGFlPl0g
eGZzX3N1Ym1pdF9pb2VuZF9iaW8rMHgxZS8weDMwDQpBdWcgMjYgMDA6NTY6
MzQgZmlsZXNydjIga2VybmVsOiAgWzxjMDM4NjJlMj5dIHhmc19zdWJtaXRf
aW9lbmQrMHhmMi8weDEwMA0KQXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYyIGtl
cm5lbDogIFs8YzAzODcxMTA+XSB4ZnNfcGFnZV9zdGF0ZV9jb252ZXJ0KzB4
NDMwLzB4NjQwDQpBdWcgMjYgMDA6NTY6MzQgZmlsZXNydjIga2VybmVsOiAg
WzxjMDM4NzM4Mz5dIHhmc192bV93cml0ZXBhZ2UrMHg2My8weDEwMA0KQXVn
IDI2IDAwOjU2OjM0IGZpbGVzcnYyIGtlcm5lbDogIFs8YzAxNWIyM2I+XSBf
X3dyaXRlcGFnZSsweGIvMHgzMA0KQXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYy
IGtlcm5lbDogIFs8YzAxNWIxMzY+XSB3cml0ZV9jYWNoZV9wYWdlcysweDIw
Ni8weDMwMA0KQXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYyIGtlcm5lbDogIFs8
YzAxNWIyOGY+XSBnZW5lcmljX3dyaXRlcGFnZXMrMHgyZi8weDQwDQpBdWcg
MjYgMDA6NTY6MzQgZmlsZXNydjIga2VybmVsOiAgWzxjMDM4NzQ0ND5dIHhm
c192bV93cml0ZXBhZ2VzKzB4MjQvMHg2MA0KQXVnIDI2IDAwOjU2OjM0IGZp
bGVzcnYyIGtlcm5lbDogIFs8YzAxNWIyY2U+XSBkb193cml0ZXBhZ2VzKzB4
MmUvMHg1MA0KQXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYyIGtlcm5lbDogIFs8
YzAxOTViNTg+XSBfX3dyaXRlYmFja19zaW5nbGVfaW5vZGUrMHgxODgvMHgx
ZTANCkF1ZyAyNiAwMDo1NjozNCBmaWxlc3J2MiBrZXJuZWw6ICBbPGMwMTk1
Y2RkPl0gc3luY19zYl9pbm9kZXMrMHgxMmQvMHgyNTANCkF1ZyAyNiAwMDo1
NjozNCBmaWxlc3J2MiBrZXJuZWw6ICBbPGMwMTk1ZWNjPl0gd3JpdGViYWNr
X2lub2RlcysweGNjLzB4ZTANCkF1ZyAyNiAwMDo1NjozNCBmaWxlc3J2MiBr
ZXJuZWw6ICBbPGMwMTVhOWMyPl0gYmFsYW5jZV9kaXJ0eV9wYWdlcysweDUy
LzB4MTcwDQpBdWcgMjYgMDA6NTY6MzQgZmlsZXNydjIga2VybmVsOiAgWzxj
MDE1YWI3Nj5dIGJhbGFuY2VfZGlydHlfcGFnZXNfcmF0ZWxpbWl0ZWRfbnIr
MHg1Ni8weDYwDQpBdWcgMjYgMDA6NTY6MzQgZmlsZXNydjIga2VybmVsOiAg
WzxjMDE1NmViNj5dIGdlbmVyaWNfZmlsZV9idWZmZXJlZF93cml0ZSsweDI5
Ni8weDY0MA0KQXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYyIGtlcm5lbDogIFs8
YzAzOGVjZDc+XSB4ZnNfd3JpdGUrMHg3YjcvMHhiNDANCkF1ZyAyNiAwMDo1
NjozNCBmaWxlc3J2MiBrZXJuZWw6ICBbPGMwMzhhMTcyPl0geGZzX2ZpbGVf
YWlvX3dyaXRlKzB4NzIvMHg4MA0KQXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYy
IGtlcm5lbDogIFs8YzAxNzdlZDc+XSBkb19zeW5jX3dyaXRlKzB4YzcvMHgx
MjANCkF1ZyAyNiAwMDo1NjozNCBmaWxlc3J2MiBrZXJuZWw6ICBbPGMwMTc4
MGMwPl0gdmZzX3dyaXRlKzB4MTkwLzB4MWEwDQpBdWcgMjYgMDA6NTY6MzQg
ZmlsZXNydjIga2VybmVsOiAgWzxjMDE3ODE3ZD5dIHN5c193cml0ZSsweDNk
LzB4NzANCkF1ZyAyNiAwMDo1NjozNCBmaWxlc3J2MiBrZXJuZWw6ICBbPGMw
MTAyYTc2Pl0gc3lzY2FsbF9jYWxsKzB4Ny8weGINCkF1ZyAyNiAwMDo1Njoz
NCBmaWxlc3J2MiBrZXJuZWw6ICA9PT09PT09PT09PT09PT09PT09PT09PQ0K
QXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYyIGtlcm5lbDogQ29kZTogOTUgZmYg
ZmYgODMgYzQgMDggNWIgNWUgNWYgNWQgYzMgZjAgMGYgYmEgNmIgM2MgMDIg
YjkgMDEgMDAgMDAgMDAgODkgZjIgODkgZDggZTggMzIgOWEgZmYgZmYgODkg
YzcgZWIgOWYgZjAgMGYgYmEgNmIgM2MgMDEgZWIgZTYgPDBmPiAwYiBlYiBm
ZSA4OSBmNiA1NSA4OSBlNSA4MyBlYyAxNCA4OSA3NSBmOCA4OSBjNiA4OSA1
ZCBmNCA4OQ0KQXVnIDI2IDAwOjU2OjM0IGZpbGVzcnYyIGtlcm5lbDogRUlQ
OiBbPGMwNmVlYjdhPl0gaGFuZGxlX3F1ZXVlKzB4ZWEvMHhmMCBTUzpFU1Ag
MDA2ODplZjFiMThjOA0KQXVnIDI2IDAxOjI0OjQ3IGZpbGVzcnYyIC0tIE1B
UksgLS0NCkF1ZyAyNiAwMTo0NDo0NyBmaWxlc3J2MiAtLSBNQVJLIC0tDQoN
Cg0KLS0gDQorLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQp8IEphbWVzICAgVy4g
ICBMYWZlcnJpZXJlIHwgU3lzdGVtICAgVGVjaG5pcXVlcyB8IEdpdmUgbWUg
Vk1TICAgICB8DQp8IE5ldHdvcmsgICAgICAgIEVuZ2luZWVyIHwgNjYzICBC
ZWF1bW9udCAgQmx2ZCB8ICBHaXZlIG1lIExpbnV4ICB8DQp8IGJhYnlkckBi
YWJ5LWRyYWdvbnMuY29tIHwgUGFjaWZpY2EsIENBLiA5NDA0NCB8ICAgb25s
eSAgb24gIEFYUCB8DQorLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0rDQo=

--566704117-1411616311-1188095246=:6971--
