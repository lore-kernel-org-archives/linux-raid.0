From: stef@chronozon.artofdns.com (Stef Telford)
Subject: 2.5.62 oops and Raid-5
Date: Mon, 17 Feb 2003 18:46:19 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030217234619.CBF2B23134@chronozon.artofdns.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: stef@chronozon.artofdns.com
List-Id: linux-raid.ids

Hello,
        sorry to be a pain, but for some reason I
am getting a symoops under 2.5.62, yet everything
works fine in 2.5.58 (although i notice reiserfs
corruption in that one. not good)
 
        The symoops only comes after the raid-5 has
finished rebuilding, or if i try to mount it whilst
its still in degraded mode/rebuilding. either way,
it crashes.
 
md: md0: sync done.
RAID5 conf printout:
 --- rd:4 wd:4 fd:0
 disk 0, o:1, dev:ide/host2/bus0/target0/lun0/part6
 disk 1, o:1, dev:ide/host2/bus1/target0/lun0/part1
 disk 2, o:1, dev:ide/host4/bus0/target0/lun0/part6
 disk 3, o:1, dev:ide/host4/bus1/target0/lun0/part1
md: updating md0 RAID superblock on device
md: ide/host4/bus1/target0/lun0/part1 <6>(write) ide/host4/bus1/target0/lun0/part1's sb offset: 58633216
md: ide/host4/bus0/target0/lun0/part6 <6>(write) ide/host4/bus0/target0/lun0/part6's sb offset: 58633728
md: ide/host2/bus1/target0/lun0/part1 <6>(write) ide/host2/bus1/target0/lun0/part1's sb offset: 58633216
md: ide/host2/bus0/target0/lun0/part6 <6>(write) ide/host2/bus0/target0/lun0/part6's sb offset: 58633728
Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
00000000
*pde = 00000000
Oops: 0000
CPU:    0
EIP:    0060:[<00000000>]    Not tainted
EFLAGS: 00010046
eax: 00000000   ebx: cfd904ac   ecx: cfd905d0   edx: 00000000
esi: cffe8880   edi: cfd90584   ebp: c12ba000   esp: c12bbf4c
ds: 007b   es: 007b   ss: 0068
Process events/0 (pid: 3, threadinfo=c12ba000 task=c12bec40)
Stack: c0267f47 cfd904ac cfd90588 c012c403 cfd904ac cffe8884 c12ba000 cfd904ac
       c0267f50 cffe8884 cffe8880 c1299fa8 cffe888c c012c078 cffe8880 c12bbfa0
       00000000 00000000 c12ba000 c12ba000 c12ba000 00000001 00000000 c0119fd0
Call Trace: [<c0267f47>]  [<c012c403>]  [<c0267f50>]  [<c012c078>]  [<c0119fd0>]  [<c0119fd0>]  [<c012beb0>]  [<c0108d39>]
Code:  Bad EIP value.
 <6>note: events/0[3] exited with preempt_count 1

 
If there is anything else that may be of use,
jst let me know and i will forward that as well.
 
Thanks
Stef.
