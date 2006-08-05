From: Jason Lunz <lunz@falooley.org>
Subject: raid1 oops, 2.6.16
Date: Sat, 5 Aug 2006 14:04:08 +0000 (UTC)
Message-ID: <eb28go$vl2$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just had a disk die in a 2.6.16 (debian kernel) raid1 server, and it's
triggered an oops in raid1.

There are a bunch of 2-partition mirrors:

Personalities : [raid1]
md5 : active raid1 hdc7[2](F) hda7[1]
      77625984 blocks [2/1] [_U]

md4 : active raid1 hdc6[2](F) hda6[1]
      16000640 blocks [2/1] [_U]

md3 : active raid1 hdc5[2](F) hda5[1]
      12570752 blocks [2/1] [_U]

md2 : active raid1 hdc3[2](F) hda3[1]
      8000256 blocks [2/1] [_U]

md1 : active raid1 hdc2[2](F) hda2[1]
      2000000 blocks [2/1] [_U]

md0 : active raid1 hdc1[2](F) hda1[1]
      995904 blocks [2/1] [_U]

unused devices: <none>


amidst all the failure messages for these arrays in dmesg, I have this:


RAID1 conf printout:
 --- wd:1 rd:2
 disk 1, wo:0, o:1, dev:hda1
Unable to handle kernel NULL pointer dereference at virtual address 00000088
 printing eip:
f0831ea8
*pde = 00000000
Oops: 0002 [#1]
Modules linked in: thermal fan button processor ac battery e1000 rtc ext3 jbd mbcache raid1 md_mod ide_disk generic siimage ide_core evdev mousedev
CPU:    0
EIP:    0060:[<f0831ea8>]    Not tainted VLI
EFLAGS: 00010246   (2.6.16-2-686 #1)
EIP is at raid1d+0x2c8/0x4c3 [raid1]
eax: 00000008   ebx: 00000000   ecx: c9c60100   edx: b1a1ac60
esi: 00000000   edi: dd67c6c0   ebp: efd52740   esp: b1ac1f08
ds: 007b   es: 007b   ss: 0068
Process md5_raid1 (pid: 1001, threadinfo=b1ac0000 task=b1bc5a70)
Stack: <0>000000b1 5e341300 003e0387 00000001 00000001 00000008 00000008 025e1458
       00000000 b1bc5b98 00000001 efd5275c b1ac1fa4 7fffffff b026e32b 00000005
       b1ac0000 b1ac1f84 7fffffff 00000000 b1a1aba0 b1ac1f84 b1ac1fa4 7fffffff
Call Trace:
 [<b026e32b>] schedule_timeout+0x13/0x8e
 [<f0864095>] md_thread+0xe3/0xfb [md_mod]
 [<b012522e>] autoremove_wake_function+0x0/0x3a
 [<b026dced>] schedule+0x45f/0x4cd
 [<b012522e>] autoremove_wake_function+0x0/0x3a
 [<f0863fb2>] md_thread+0x0/0xfb [md_mod]
 [<b0124efe>] kthread+0x79/0xa3
 [<b0124e85>] kthread+0x0/0xa3
 [<b01012cd>] kernel_thread_helper+0x5/0xb
Code: 83 7c 24 10 00 8b 47 20 0f 84 dc 00 00 00 89 74 24 0c 39 c6 74 63 85 f6 75 03 8b 75
08 4e 8b 55 04 6b c6 0c 8b 1c 02 8b 44 24 14 <01> 83 88 00 00 00 85 db 74 3f 8b 43 70 a8 04 74 38 6a 01 ff 75
 end_request: I/O error, dev hdc, sector 26464418


The server is still running, but processes (like sync(1)) are getting hung in D
state.

Jason

