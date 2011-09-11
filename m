From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Kernel warning while read/writing
Date: Sun, 11 Sep 2011 09:03:30 -0400
Message-ID: <CALJXSJoiyRzsdUgg4tQDxNG9DOvMh60-XNGm04=NUfxVgoTihw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've got this warning yesterday while writing to a samba share on ARM.
The samba process was deadlocked, I rebooted the device and issued
e2fsck and it seems it didn't damage anything from the FS structure.
Looking at flush_pending_writes I see it talks about bitmaps, however
I know this RAID1 hasn't any bitmap set.

[841839.034022] Unable to handle kernel paging request at virtual
address c6f32204
[841839.042408] pgd =3D c097c000
[841839.046051] [c6f32204] *pgd=3D06e0041e(bad)
[841839.053346] Internal error: Oops: 1 [#1] PREEMPT
[841839.058082] Modules linked in: ipv6 mv_cesa raid1 md_mod
[841839.063563] CPU: 0=C2=A0=C2=A0=C2=A0 Not tainted=C2=A0 (3.0-ARCH #1=
)
[841839.068299] PC is at generic_make_request+0x394/0x538
[841839.073462] LR is at generic_make_request+0x350/0x538
[841839.078634] pc : [<c020f740>]=C2=A0=C2=A0=C2=A0 lr : [<c020f6fc>]=C2=
=A0=C2=A0=C2=A0 psr: 20000013
[841839.078639] sp : c6ca7e30=C2=A0 ip : c6f32104=C2=A0 fp : 00000000
[841839.090351] r10: 74706db0=C2=A0 r9 : 00000010=C2=A0 r8 : c72fb2c0
[841839.095688] r7 : 00706db0=C2=A0 r6 : c6ca6000=C2=A0 r5 : 00000000=C2=
=A0 r4 : c6f32204
[841839.102333] r3 : 00000000=C2=A0 r2 : 00000010=C2=A0 r1 : 00000000=C2=
=A0 r0 : 74706db0
[841839.108978] Flags: nzCv=C2=A0 IRQs on=C2=A0 FIQs on=C2=A0 Mode SVC_=
32=C2=A0 ISA ARM
Segment kernel
[841839.116415] Control: 0005397f=C2=A0 Table: 0097c000=C2=A0 DAC: 0000=
0017
[841839.122276] Process md127_raid1 (pid: 951, stack limit =3D 0xc6ca62=
70)
[841839.128746] Stack: (0xc6ca7e30 to 0xc6ca8000)
[841839.133212] 7e20:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 00000007
c795e400 741065b0 00000000
[841839.141526] 7e40: 74706db0 00000000 10324438 00000000 00000000
00800010 c72fb2c0 00800012
[841839.149835] 7e60: 0ff23c38 00000000 00000000 c020df7c c6ca7e90
c72fb2c0 00000061 60000013
[841839.158145] 7e80: 00000000 00000000 00000000 00000000 c6ca7e90
c6f32204 c6f32e04 00000000
[841839.166457] 7ea0: c6d41368 7fffffff 00000000 c006457c 00000000
bf021780 c6d41360 c6ca6000
[841839.174767] 7ec0: c6c31a80 bf0219ec 00000102 c03c8fcc 60000093
c6ca6000 c05bd6b4 c004d118
[841839.183077] 7ee0: c78f28c0 c72eb400 00000001 00000000 c6ca6000
0000000b 00000000 c6ca6000
[841839.191387] 7f00: 00000001 c6c31a80 c6ca6000 c6c31a98 00000000
c004d598 00000000 bf00383c
[841839.199697] 7f20: 7fffffff c6ca7fa8 c6d41368 7fffffff 00000000
c006457c 00000000 c03c8fcc
[841839.208009] 7f40: c6d41360 c6ca6000 c6ca7fa8 c6d41368 7fffffff
00000000 91827364 c17221b0
[841839.216318] 7f60: c7b031b0 c6ca7f64 c6ca7f64 00000001 60000013
c6d41360 c6ca6000 c6ca7fa8
[841839.224627] 7f80: c6d41368 7fffffff 00000000 c006457c 00000000
bf003884 c6cb1e20 00000000
[841839.232939] 7fa0: c72046c0 c006457c c6ca7fa8 c6ca7fa8 c6d41360
c6cb1e10 c6d41360 bf003774
[841839.241247] 7fc0: 00000013 00000000 00000000 c0063e04 00000000
00000000 c6d41360 00000000
[841839.249558] 7fe0: c6ca7fe0 c6ca7fe0 c6cb1e10 c0063d88 c0033234
c0033234 00000000 00000000
[841839.257889] [<c020f740>] (generic_make_request+0x394/0x538) from
[<bf021780>] (flush_pending_writes+0x8c/0xd0 [raid1])
[841839.268746] [<bf021780>] (flush_pending_writes+0x8c/0xd0 [raid1])
from [<bf0219ec>] (raid1d+0x54/0xe38 [raid1])
[841839.279026] [<bf0219ec>] (raid1d+0x54/0xe38 [raid1]) from
[<bf003884>] (md_thread+0x110/0x12c [md_mod])
[841839.288599] [<bf003884>] (md_thread+0x110/0x12c [md_mod]) from
[<c0063e04>] (kthread+0x7c/0x84)
[841839.297449] [<c0063e04>] (kthread+0x7c/0x84) from [<c0033234>]
(kernel_thread_exit+0x0/0x8)
[841839.305934] Code: e3a03000 e1cda1d0 e15b0003 015a0002 (e1c400d0)
[841839.313651] ---[ end trace 56f85a7cd71a670b ]---
[841839.319251] ------------[ cut here ]------------
[841839.324593] WARNING: at kernel/exit.c:910 do_exit+0x80/0x780()
[841839.332182] Modules linked in: ipv6 mv_cesa raid1 md_mod
[841839.338967] [<c00370d0>] (unwind_backtrace+0x0/0xe0) from
[<c0046a1c>] (warn_slowpath_common+0x4c/0x64)
[841839.349470] [<c0046a1c>] (warn_slowpath_common+0x4c/0x64) from
[<c0046a4c>] (warn_slowpath_null+0x18/0x1c)
[841839.360104] [<c0046a4c>] (warn_slowpath_null+0x18/0x1c) from
[<c004a06c>] (do_exit+0x80/0x780)
[841839.370185] [<c004a06c>] (do_exit+0x80/0x780) from [<c00356f4>]
(die+0x1d4/0x200)
[841839.378469] [<c00356f4>] (die+0x1d4/0x200) from [<c03c4f60>]
(__do_kernel_fault.part.3+0x54/0x74)
[841839.388681] [<c03c4f60>] (__do_kernel_fault.part.3+0x54/0x74) from
[<c0038110>] (do_bad_area+0x70/0x78)
[841839.399061] [<c0038110>] (do_bad_area+0x70/0x78) from [<c003a374>]
(do_alignment+0x5bc/0x748)
[841839.409862] [<c003a374>] (do_alignment+0x5bc/0x748) from
[<c0032248>] (do_DataAbort+0x34/0x98)
[841839.419464] [<c0032248>] (do_DataAbort+0x34/0x98) from
[<c03ca7ec>] (__dabt_svc+0x4c/0x60)
[841839.429003] Exception stack(0xc6ca7de8 to 0xc6ca7e30)
[841839.434896] 7de0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 74706db0 0000=
0000 00000010
00000000 c6f32204 00000000
[841839.443900] 7e00: c6ca6000 00706db0 c72fb2c0 00000010 74706db0
00000000 c6f32104 c6ca7e30
[841839.453995] 7e20: c020f6fc c020f740 20000013 ffffffff
[841839.465333] [<c03ca7ec>] (__dabt_svc+0x4c/0x60) from [<c020f740>]
(generic_make_request+0x394/0x538)
[841839.497471] [<c020f740>] (generic_make_request+0x394/0x538) from
[<bf021780>] (flush_pending_writes+0x8c/0xd0 [raid1])
[841839.515583] [<bf021780>] (flush_pending_writes+0x8c/0xd0 [raid1])
from [<bf0219ec>] (raid1d+0x54/0xe38 [raid1])
[841839.527865] [<bf0219ec>] (raid1d+0x54/0xe38 [raid1]) from
[<bf003884>] (md_thread+0x110/0x12c [md_mod])
[841839.539566] [<bf003884>] (md_thread+0x110/0x12c [md_mod]) from
[<c0063e04>] (kthread+0x7c/0x84)
[841839.549013] [<c0063e04>] (kthread+0x7c/0x84) from [<c0033234>]
(kernel_thread_exit+0x0/0x8)
[841839.559184] ---[ end trace 56f85a7cd71a670c ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
