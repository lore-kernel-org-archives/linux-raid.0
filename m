From: Arnold Schulz <arnysch@gmx.net>
Subject: Raid1 resync problem with leap seconds ?
Date: Fri, 06 Jul 2012 14:33:47 +0200
Message-ID: <4FF6DB2B.1090905@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

about 8 seconds after inserting the leap second, a running raid1
resync crashed.

Not being able to assess if it is the raid code or some kernel
timer function to blame, I just present the log here.

Regards,
Arnold

--------------------------------------------
Jul  1 01:03:24 ip4-router kernel: md: data-check of RAID array md2
Jul  1 01:03:24 ip4-router kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Jul  1 01:03:24 ip4-router kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
Jul  1 01:03:24 ip4-router kernel: md: using 128k window, over a total of 1924209408k.
Jul  1 01:59:59 ip4-router kernel: Clock: inserting leap second 23:59:60 UTC
Jul  1 02:07:12 ip4-router kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
Jul  1 02:07:12 ip4-router kernel: IP: [<ffffffff81300e18>] sync_request+0x628/0x970
Jul  1 02:07:12 ip4-router kernel: PGD 0
Jul  1 02:07:12 ip4-router kernel: Oops: 0000 [#1] PREEMPT SMP
Jul  1 02:07:12 ip4-router kernel: CPU 1
Jul  1 02:07:12 ip4-router kernel: Modules linked in: parport_pc parport binfmt_misc deflate zlib_deflate zlib_inflate ctr 
twofish_generic twofish_x86_64_3way twofish_x86_64 camellia_generic twofish_common camellia_x86_64 serpent_sse2_x86_64 
serpent_generic cryptd lrw blowfish_generic blowfish_x86_64 blowfish_common cast5 des_generic xcbc rmd160 sha512_generic 
sha256_generic sha1_generic crypto_null af_key fuse mt2060 dvb_usb_dib0700 dib3000mc dib8000 dvb_usb dib0070 dib7000m dib7000p 
dibx000_common dib0090 dvb_core hfcpci mISDN_core
Jul  1 02:07:12 ip4-router kernel:
Jul  1 02:07:12 ip4-router kernel: Pid: 17823, comm: md2_resync Not tainted 3.4.4 #109 To Be Filled By O.E.M. To Be Filled By 
O.E.M./N68PV-GS
Jul  1 02:07:12 ip4-router kernel: RIP: 0010:[<ffffffff81300e18>]  [<ffffffff81300e18>] sync_request+0x628/0x970
Jul  1 02:07:12 ip4-router kernel: RSP: 0018:ffff8800224e9c30  EFLAGS: 00010202
Jul  1 02:07:12 ip4-router kernel: RAX: 0000000000000002 RBX: 0000000000000002 RCX: 0000000000000001
Jul  1 02:07:12 ip4-router kernel: RDX: 0000000000000002 RSI: ffff88006d7c4d30 RDI: 0000000000000000
Jul  1 02:07:12 ip4-router kernel: RBP: ffff8800224e9ce0 R08: ffff8800224e8000 R09: 0000000000000001
Jul  1 02:07:12 ip4-router kernel: R10: 000000000000013e R11: 0000000000000000 R12: 0000000000000080
Jul  1 02:07:12 ip4-router kernel: R13: ffff88006b403840 R14: ffff88006c711680 R15: ffffea0000ca7580
Jul  1 02:07:12 ip4-router kernel: FS:  00007f441eafa700(0000) GS:ffff88006fd00000(0000) knlGS:0000000000000000
Jul  1 02:07:12 ip4-router kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Jul  1 02:07:12 ip4-router kernel: CR2: 0000000000000050 CR3: 000000005c53f000 CR4: 00000000000007e0
Jul  1 02:07:12 ip4-router kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Jul  1 02:07:12 ip4-router kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jul  1 02:07:12 ip4-router kernel: Process md2_resync (pid: 17823, threadinfo ffff8800224e8000, task ffff88006d7c4d30)
Jul  1 02:07:12 ip4-router kernel: Stack:
Jul  1 02:07:12 ip4-router kernel: 00000000e5623600 ffff880000000000 0000000029ca6880 0000008029ca5f00
Jul  1 02:07:12 ip4-router kernel: ffff8800224e9e2c 0000000000000000 0000000200000000 0000000029ca6900
Jul  1 02:07:12 ip4-router kernel: 0000000029ca6900 0000000000000080 0000000000001000 ffff88006b68dc00
Jul  1 02:07:12 ip4-router kernel: Call Trace:
Jul  1 02:07:12 ip4-router kernel: [<ffffffff813163e3>] md_do_sync+0x7d3/0xc60
Jul  1 02:07:12 ip4-router kernel: [<ffffffff8104ac90>] ? abort_exclusive_wait+0xb0/0xb0
Jul  1 02:07:12 ip4-router kernel: [<ffffffff81312f7e>] md_thread+0x10e/0x140
Jul  1 02:07:12 ip4-router kernel: [<ffffffff81312e70>] ? md_register_thread+0x110/0x110
Jul  1 02:07:12 ip4-router kernel: [<ffffffff8104a4ee>] kthread+0x8e/0xa0
Jul  1 02:07:12 ip4-router kernel: [<ffffffff8146b4f4>] kernel_thread_helper+0x4/0x10
Jul  1 02:07:12 ip4-router kernel: [<ffffffff8104a460>] ? kthread_worker_fn+0x130/0x130
Jul  1 02:07:12 ip4-router kernel: [<ffffffff8146b4f0>] ? gs_change+0xb/0xb
Jul  1 02:07:12 ip4-router kernel: Code: 0f 84 35 02 00 00 8b 45 84 41 89 06 41 8b 55 10 48 8b 45 98 8d 0c 12 85 c9 0f 8e 85 fa 
ff ff 31 db 66 90 48 63 c3 49 8b 7c c6 58 <48> 81 7f 50 10 f4 2f 81 0f 84 b2 01 00 00 8d 04 12 ff c3 39 d8
Jul  1 02:07:12 ip4-router kernel: RIP  [<ffffffff81300e18>] sync_request+0x628/0x970
Jul  1 02:07:12 ip4-router kernel: RSP <ffff8800224e9c30>
Jul  1 02:07:12 ip4-router kernel: CR2: 0000000000000050
Jul  1 02:07:12 ip4-router kernel: ---[ end trace 79aec5e8bd378abc ]---
