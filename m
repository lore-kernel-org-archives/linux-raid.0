From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] Fix oops when changed group_thread_cnt
Date: Wed, 13 Nov 2013 14:29:08 +1100
Message-ID: <20131113142908.767faf2d@notabene.brown>
References: <201311121043206295204@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OBjpVR0v1LOlUV5N=_YZ6OI"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201311121043206295204@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: shli <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/OBjpVR0v1LOlUV5N=_YZ6OI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Nov 2013 10:43:27 +0800 majianpeng <majianpeng@gmail.com> wrote:

> When change group_thread_cnt from sysfs entry, it met two oops.
> The kernel messages are:
>=20
> [  740.961389] BUG: unable to handle kernel NULL pointer dereference at 0=
000000000000008
> [  740.961444] IP: [<ffffffff81062570>] process_one_work+0x30/0x500
> [  740.961476] PGD b9013067 PUD b651e067 PMD 0=20
> [  740.961503] Oops: 0000 [#1] SMP=20
> [  740.961525] Modules linked in: netconsole e1000e ptp pps_core
> [  740.961577] CPU: 0 PID: 3683 Comm: kworker/u8:5 Not tainted 3.12.0+ #23
> [  740.961602] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.=
M./To be filled by O.E.M., BIOS 080015  11/09/2011
> [  740.961646] task: ffff88013abe0000 ti: ffff88013a246000 task.ti: ffff8=
8013a246000
> [  740.961673] RIP: 0010:[<ffffffff81062570>]  [<ffffffff81062570>] proce=
ss_one_work+0x30/0x500
> [  740.961708] RSP: 0018:ffff88013a247e08  EFLAGS: 00010086
> [  740.961730] RAX: ffff8800b912b400 RBX: ffff88013a61e680 RCX: ffff8800b=
912b400
> [  740.961757] RDX: ffff8800b912b600 RSI: ffff8800b912b600 RDI: ffff88013=
a61e680
> [  740.961782] RBP: ffff88013a247e48 R08: ffff88013a246000 R09: 000000000=
002c09d
> [  740.961808] R10: 000000000000010f R11: 0000000000000000 R12: ffff88013=
b00cc00
> [  740.961833] R13: 0000000000000000 R14: ffff88013b00cf80 R15: ffff88013=
a61e6b0
> [  740.961861] FS:  0000000000000000(0000) GS:ffff88013fc00000(0000) knlG=
S:0000000000000000
> [  740.961893] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  740.962001] CR2: 00000000000000b8 CR3: 00000000b24fe000 CR4: 000000000=
00407f0
> [  740.962001] Stack:
> [  740.962001]  0000000000000008 ffff8800b912b600 ffff88013b00cc00 ffff88=
013a61e680
> [  740.962001]  ffff88013b00cc00 ffff88013b00cc18 ffff88013b00cf80 ffff88=
013a61e6b0
> [  740.962001]  ffff88013a247eb8 ffffffff810639c6 0000000000012a80 ffff88=
013a247fd8
> [  740.962001] Call Trace:
> [  740.962001]  [<ffffffff810639c6>] worker_thread+0x206/0x3f0
> [  740.962001]  [<ffffffff810637c0>] ? manage_workers+0x2c0/0x2c0
> [  740.962001]  [<ffffffff81069656>] kthread+0xc6/0xd0
> [  740.962001]  [<ffffffff81069590>] ? kthread_freezable_should_stop+0x70=
/0x70
> [  740.962001]  [<ffffffff81722ffc>] ret_from_fork+0x7c/0xb0
> [  740.962001]  [<ffffffff81069590>] ? kthread_freezable_should_stop+0x70=
/0x70
> [  740.962001] Code: 89 e5 41 57 41 56 41 55 45 31 ed 41 54 53 48 89 fb 4=
8 83 ec 18 48 8b 06 4c 8b 67 48 48 89 c1 30 c9 a8 04 4c 0f 45 e9 80 7f 58 0=
0 <49> 8b 45 08 44 8b b0 00 01 00 00 78 0c 41 f6 44 24 10 04 0f 84=20
> [  740.962001] RIP  [<ffffffff81062570>] process_one_work+0x30/0x500
> [  740.962001]  RSP <ffff88013a247e08>
> [  740.962001] CR2: 0000000000000008
> [  740.962001] ---[ end trace 39181460000748de ]---
> [  740.962001] Kernel panic - not syncing: Fatal exception
>=20
>=20
> [  135.299021] BUG: unable to handle kernel NULL pointer dereference at  =
         (null)
> [  135.299073] IP: [<ffffffff815188ab>] handle_active_stripes+0x32b/0x440
> [  135.299107] PGD 0=20
> [  135.299122] Oops: 0000 [#1] SMP=20
> [  135.299144] Modules linked in: netconsole e1000e ptp pps_core
> [  135.299188] CPU: 3 PID: 2225 Comm: md0_raid5 Not tainted 3.12.0+ #24
> [  135.299214] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.=
M./To be filled by O.E.M., BIOS 080015  11/09/2011
> [  135.299255] task: ffff8800b9638f80 ti: ffff8800b77a4000 task.ti: ffff8=
800b77a4000
> [  135.299283] RIP: 0010:[<ffffffff815188ab>]  [<ffffffff815188ab>] handl=
e_active_stripes+0x32b/0x440
> [  135.299323] RSP: 0018:ffff8800b77a5c48  EFLAGS: 00010002
> [  135.299344] RAX: ffff880037bb5c70 RBX: 0000000000000000 RCX: 000000000=
0000008
> [  135.299371] RDX: ffff880037bb5cb8 RSI: 0000000000000001 RDI: ffff88003=
7bb5c00
> [  135.299398] RBP: ffff8800b77a5d08 R08: 0000000000000001 R09: 000000000=
0000000
> [  135.299425] R10: ffff8800b77a5c98 R11: 00000000ffffffff R12: ffff88003=
7bb5c00
> [  135.299452] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88003=
7bb5c70
> [  135.299479] FS:  0000000000000000(0000) GS:ffff88013fd80000(0000) knlG=
S:0000000000000000
> [  135.299510] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  135.299532] CR2: 0000000000000000 CR3: 0000000001c0b000 CR4: 000000000=
00407e0
> [  135.299559] Stack:
> [  135.299570]  ffff8800b77a5c88 ffffffff8107383e ffff8800b77a5c88 ffff88=
0037a64300
> [  135.299611]  000000000000ec08 ffff880037bb5cb8 ffff8800b77a5c98 ffffff=
ffffffffd8
> [  135.299654]  000000000000ec08 ffff880037bb5c60 ffff8800b77a5c98 ffff88=
00b77a5c98
> [  135.299696] Call Trace:
> [  135.299711]  [<ffffffff8107383e>] ? __wake_up+0x4e/0x70
> [  135.299733]  [<ffffffff81518f88>] raid5d+0x4c8/0x680
> [  135.299756]  [<ffffffff817174ed>] ? schedule_timeout+0x15d/0x1f0
> [  135.299781]  [<ffffffff81524c9f>] md_thread+0x11f/0x170
> [  135.299804]  [<ffffffff81069cd0>] ? wake_up_bit+0x40/0x40
> [  135.299826]  [<ffffffff81524b80>] ? md_rdev_init+0x110/0x110
> [  135.299850]  [<ffffffff81069656>] kthread+0xc6/0xd0
> [  135.299871]  [<ffffffff81069590>] ? kthread_freezable_should_stop+0x70=
/0x70
> [  135.299899]  [<ffffffff81722ffc>] ret_from_fork+0x7c/0xb0
> [  135.299923]  [<ffffffff81069590>] ? kthread_freezable_should_stop+0x70=
/0x70
> [  135.299951] Code: ff ff ff 0f 84 d7 fe ff ff e9 5c fe ff ff 66 90 41 8=
b b4 24 d8 01 00 00 45 31 ed 85 f6 0f 8e 7b fd ff ff 49 8b 9c 24 d0 01 00 0=
0 <48> 3b 1b 49 89 dd 0f 85 67 fd ff ff 48 8d 43 28 31 d2 eb 17 90=20
> [  135.300005] RIP  [<ffffffff815188ab>] handle_active_stripes+0x32b/0x440
> [  135.300005]  RSP <ffff8800b77a5c48>
> [  135.300005] CR2: 0000000000000000
> [  135.300005] ---[ end trace 504854e5bb7562ed ]---
> [  135.300005] Kernel panic - not syncing: Fatal exception
>=20
> To reproduce those bugs, i use this shell:
>=20
> mdadm -CR /dev/md0 -l5 -n4 /dev/sd[b-e]
> sleep 4
> while true
> do
>         cd /sys/block/md0/md
>         echo 1  > group_thread_cnt
>         sleep 1
>         echo 0 > group_thread_cnt
>         sleep 1
> done
>=20
> Using this shell, it can easily to reproduce those bugs.
>=20
> Jianpeng Ma (2):
>   raid5: Before freeing old multi-thread worker,it should flush them.
>   raid5: Using conf->device_lock protect multi-thread resouce when
>     changed.
>=20
>  drivers/md/raid5.c |   61 ++++++++++++++++++++++++++++++++--------------=
-----
>  1 files changed, 38 insertions(+), 23 deletions(-)


Both applied, thanks,
NeilBrown

--Sig_/OBjpVR0v1LOlUV5N=_YZ6OI
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUoLyBDnsnt1WYoG5AQLUzA/8CH5kwq+6EbiPBPcj62Ln1aryu45Y022j
kKXSZBnJT7i+939fOoepGzWlj16bC6OVZQGdGz1ABDgV/GFyJosApz2ljfabT0SH
RraBV9Wzn+lnY3GJIpjyBY5Gd8qdTpJjtxe7uYNDutZPnEy8ma2u40GDqc6o6Qkf
DdhgoKBqgCYvv+g7TlHf/XUx/3um2xhlYKZpkrG4dRVUyz9SiVfxj+7GA5Wq2IWO
zSFW6mI+4H9528zctl3xT7+YRGSd/Es2yTutxtVr9bykL8vfXEW64S/UukBbG3BX
nONx5pxuzWbbtFuw4bgdYYpZVbCP242xlaChwpql/wfVYUWIMQ6T3PX5LgQPFtC+
tcpoM4GyTvHLDMqk423IuK9bGLn/k0IYVCxTFGxbPGvOmmIZ1Ct+jJwtksgDbSqD
Tnnp9foxexSbycj/tY3ECqUYWFB0AKIvc0W9GVtvxqijJV1elthOLeCJ/FW1rX8F
qQKWJ6Zcntw+CWKgeVV2a0Q02ZqrTzPAocygP+uoPN+NVn0IHTAMcj7Os4h+qiNl
lP4HnfP5VJIX/PC4byQ6liimLzaNrWjl+4YYGAcGHovQ4Yn9NudDj1HKUGJBHAj/
ac3Z6EIeWmw/tMfWIHKygyZ542qguKHDrdj34eFeQBdKNTALfOD7dY8a7eQIvY1B
0xCTUtQaJj0=
=E5aG
-----END PGP SIGNATURE-----

--Sig_/OBjpVR0v1LOlUV5N=_YZ6OI--
