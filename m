From: "Bo Moon" <bo@anthologysolutions.com>
Subject: Kernel OOps: bad magic 0 while RAID5 resync operation
Date: Wed, 22 Oct 2003 15:54:29 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <068601c398ef$736fac50$6501a8c0@bmasi>
References: <7da.3f929f6e.d36f3@altium.nl> <16275.32127.862408.701013@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

Anyone has this OOps before? Is it harmful?

I am using debian arm linux 2.4.20.

Thanks in advance,



Bo

-------------------------- console log--------------------------------------

PRAETORIAN:/home/bmoon# cat /proc/mdstat

Personalities : [linear] [raid0] [raid1] [raid5]

read_ahead 4096 sectors

md0 : active raid5 hde4[3] hdc4[1] hda4[0]

20479360 blocks chunks 64k algorithm 2 [3/2] [UU_]

[=================>...] recovery = 86.2% (8838224/10239680) finish=5.4min
speed=4272K/sec

unused devices: <none>

-----------------------------------------------------Kernel
OOPS------------------------------------------------------------------------
----

PRAETORIAN:/home/bmoon# bad magic 0 (should be 304a03c), <2>kernel BUG at
/home/bo/queengate2/linux/include/linux/wait.h:229!

Unable to handle kernel NULL pointer dereference at virtual address 00000000

mm = c000e78c pgd = c37a8000

*pgd = c37ac001, *pmd = c37ac001, *pte = 00000000, *ppte = 00000000

Internal error: Oops: ffffffff

CPU: 0

pc : [<c0025844>] lr : [<c002dbf4>] Not tainted

sp : c2a1fec4 ip : c2a1fe74 fp : c2a1fed4

r10: 00000009 r9 : 00000104 r8 : c2a1ff64

r7 : 00000000 r6 : 00000100 r5 : a0000013 r4 : 00000000

r3 : 00000000 r2 : c38b3f38 r1 : c38b3f38 r0 : 00000001

Flags: nZCv IRQs off FIQs on Mode SVC_32 Segment user

Control: C37AB17F Table: C37AB17F DAC: 00000015

Process winbindd (pid: 527, stack limit = 0xc2a1e37c)

Stack: (0xc2a1fec4 to 0xc2a20000)

fec0: 0304a02c c2a1feec c2a1fed8 c002b718 c002580c 0304a028 c088a000

fee0: c2a1ff04 c2a1fef0 c005eed8 c002b6c8 00000000 c2b0b734 c2a1ff50
c2a1ff08

ff00: c005f308 c005eeb8 c2a1e000 c2a1ff20 00000000 00000000 c2a1ff60
00000009

ff20: 00000000 c088a000 00000004 00000001 c2a1e000 00000004 c1faa924
00000009

ff40: bfffe9bc c2a1ffa4 c2a1ff54 c005f648 c005f0e8 00000028 00000000
00000000

ff60: 00000009 c1faa924 c1faa928 c1faa92c c1faa930 c1faa934 c1faa938
bfffe8b4

ff80: bfffe9bc 00000009 0000008e c00206e4 c2a1e000 00000000 00000000
c2a1ffa8

ffa0: c0020540 c005f35c bfffe8b4 c00299ec 00000009 bfffe9bc 00000000
00000000

ffc0: bfffe8b4 bfffe9bc 00000009 00000000 00000000 00000000 00000000
bfffe9bc

ffe0: 0010c4d8 bfffe804 000591b0 4014482c a0000010 00000009 00000000
00000000

Backtrace:

Function entered at [<c0025800>] from [<c002b718>]

r4 = 0304A02C

Function entered at [<c002b6bc>] from [<c005eed8>]

r5 = C088A000 r4 = 0304A028

Function entered at [<c005eeac>] from [<c005f308>]

r5 = C2B0B734 r4 = 00000000

Function entered at [<c005f0dc>] from [<c005f648>]

Function entered at [<c005f350>] from [<c0020540>]

Code: eb002013 e59f0014 eb002011 e3a03000 (e5833000)

md: hde4 [events: 00000002](write) hde4's sb offset: 10249344

md: hdc4 [events: 00000002](write) hdc4's sb offset: 10239680

md: hda4 [events: 00000002](write) hda4's sb offset: 10484096

----------------------------------------------------------------------------
--------after OOPs----------------------------------

PRAETORIAN:/home/bmoon# cat /proc/mdstat

Personalities : [linear] [raid0] [raid1] [raid5]

read_ahead 4096 sectors

md0 : active raid5 hde4[2] hdc4[1] hda4[0]

20479360 blocks chunks 64k algorithm 2 [3/3] [UUU]


unused devices: <none>

