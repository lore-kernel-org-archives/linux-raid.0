From: Yuri Tikhonov <yur_t@mail.ru>
Subject: =?koi8-r?Q?Re=3A_[PATCH_00/12]_md_raid_acceleration_and_the_async=5Ftx_api?=
Date: Thu, 18 Jan 2007 12:03:10 +0300
Message-ID: <E1H7TAs-0009kG-00.yur_t-mail-ru@f79.mail.ru>
Reply-To: Yuri Tikhonov <yur_t@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hello, Dan.

 It seems there is a bug in your 06.11.30 raid acceleration patch-set. I tried to run the Linux s/w RAID-5 driver patched with your 06.11.30 patch-set and found that it fails during write operations when the RAID-5 array consists of 6 or more number of drives (I tested up to 8 drives). For 5 and less number of drives everything works as expected. There are no such problems with your 06.09.12 set of patches. Do you have any assumptions about the reasons of this fault? 

 The kernel I used was 2.6.19, your 06.11.30 patch-set was applied without any warnings/errors. Here is the kernel Oops report:

Oops: kernel access of bad area, sig: 11 [#1]
NIP: C014F980 LR: C014FD0C CTR: 00000080
REGS: eee49d40 TRAP: 0300   Not tainted  (2.6.19-g0726acdc-dirty)
MSR: 00029000 <EE,ME>  CR: 44002042  XER: 20000000
DAR: 17970004, DSISR: 00000000
TASK = eed5a7d0[280] 'md0_raid5_ops/0' THREAD: eee48000
GPR00: 0000007F EEE49DF0 EED5A7D0 00000080 EEDFC000 00000000 19D70000 17870000 
GPR08: 00001000 C02B0000 EEDFC000 C014F950 EEDFC000 30000000 C015B8D8 17970000 
GPR16: C08AC180 C02B0000 EEE0CB48 0000003A 0000000C 00001000 00000000 00000001 
GPR24: 00000000 C015B8D8 00000004 0000003A EEDFC000 00000004 19D70000 17870000 
NIP [C014F980] xor_32regs_4+0x30/0x158
LR [C014FD0C] xor_block+0xc4/0x12c
Call Trace:
[EEE49E40] [EEE49E58] 0xeee49e58
[EEE49E50] [C014EFAC] async_xor+0x134/0x200
[EEE49EB0] [C015A960] ops_run_postxor+0xf8/0x198
[EEE49F00] [C0162458] raid5_run_ops+0x8dc/0x994
[EEE49F50] [C0029F7C] run_workqueue+0xa4/0x118
[EEE49F70] [C002A198] worker_thread+0xf8/0x13c
[EEE49FC0] [C002E20C] kthread+0xf8/0x100
[EEE49FF0] [C0003DA0] kernel_thread+0x44/0x60
Instruction dump:
5463d97e 7c601b78 3400ffff 9421ffb0 bde1000c 7c6903a6 7c8c2378 7caf2b78 
7cde3378 7cff3b78 41800124 80ac0000 <82ef0004> 82cf0008 82af000c 828f0010

 Regards, Yuri.

