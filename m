From: <robin-lists@robinbowes.com>
Subject: Kernel halt building raid5 array
Date: Thu, 22 Jul 2004 00:21:10 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S266773AbUGUXVQ/20040721232116Z+309@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I got this error when creating a raid5 array:

Jul 21 23:58:33 dude kernel: eip: 0211e5c9
Jul 21 23:58:33 dude kernel: ------------[ cut here ]------------
Jul 21 23:58:33 dude kernel: kernel BUG at include/asm/spinlock.h:152!
Jul 21 23:58:33 dude kernel: invalid operand: 0000 [#1]
Jul 21 23:58:33 dude kernel: SMP
Jul 21 23:58:33 dude kernel: Modules linked in: ipv6 autofs4 natsemi
ipt_REJECT
ipt_state ip_conntrack iptable_filter ip_tables floppy sg microcode uhci_hcd
ext
3 jbd raid5 xor raid1 dm_mod sata_promise libata sd_mod scsi_mod
Jul 21 23:58:33 dude kernel: CPU:    0
Jul 21 23:58:33 dude kernel: EIP:    0060:[<0211e5f3>]    Not tainted
Jul 21 23:58:33 dude kernel: EFLAGS: 00010046   (2.6.7-1.492smp)
Jul 21 23:58:33 dude kernel: EIP is at complete+0x2a/0x85
Jul 21 23:58:33 dude kernel: eax: 022dfb0d   ebx: 5c8d7f3c   ecx: 5c8d7f3c
edx
: 0211e5c9
Jul 21 23:58:33 dude kernel: esi: 5c8d7f40   edi: 00000246   ebp: 58061f94
esp
: 58061f80
Jul 21 23:58:33 dude kernel: ds: 007b   es: 007b   ss: 0068
Jul 21 23:58:33 dude kernel: Process md5_resync (pid: 8384,
threadinfo=58061000
task=58128860)
Jul 21 23:58:33 dude kernel: Stack: 00000000 00000000 58061000 39e05b80
58061fb0
 00000000 0227126d 00000000
Jul 21 23:58:33 dude kernel:        58128860 0211ff27 58061fc8 58061fc8
0211ce95
 0231fa20 0238bfe0 00000000
Jul 21 23:58:33 dude kernel:        58128860 0211ff27 58061fc8 58061fc8
00000000
 00000000 00000000 00000000
Jul 21 23:58:33 dude kernel: Call Trace:
Jul 21 23:58:33 dude kernel:  [<0227126d>] md_thread+0x1b0/0x1b9
Jul 21 23:58:33 dude kernel:  [<0211ff27>] autoremove_wake_function+0x0/0x2d
Jul 21 23:58:33 dude kernel:  [<0211ce95>] schedule_tail+0xc/0x37
Jul 21 23:58:33 dude kernel:  [<0211ff27>] autoremove_wake_function+0x0/0x2d
Jul 21 23:58:33 dude kernel:  [<022710bd>] md_thread+0x0/0x1b9
Jul 21 23:58:33 dude kernel:  [<021041f1>] kernel_thread_helper+0x5/0xb
Jul 21 23:58:33 dude kernel: Code: 0f 0b 98 00 c8 fa 2d 02 f0 fe 4b 04 0f 88
39
14 00 00 ff 03


I'm running 2.6.7-1.492smp on Fedora Core 2 with Promise SATA150 TX4
controllers and Maxtor Maxline II Plus drives.

Anyone seen this before?

R.
--
http://robinbowes.com 

