From: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [MD] Crash with 4.12+ kernel and high disk load -- bisected to
 4ad23a976413: MD: use per-cpu counter for writes_pending
Date: Tue, 8 Aug 2017 09:10:08 +0200
Message-ID: <20170808071008.GA6211@light.dominikbrodowski.net>
References: <ee7921d2-d3ff-2381-1f05-2c07b8001d08@unsolicited.net>
 <c2df7906-67b2-b33f-0e82-49e6ef53f5f1@unsolicited.net>
 <20170807112025.GA3094@light.dominikbrodowski.net>
 <20170808045103.xpi32xkjidjuxczq@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170808045103.xpi32xkjidjuxczq@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>, David R <david@unsolicited.net>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, tj@kernel.org
List-Id: linux-raid.ids


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Shaouhua,

( really CC'ing Tejun now )

On Mon, Aug 07, 2017 at 09:51:03PM -0700, Shaohua Li wrote:
> On Mon, Aug 07, 2017 at 01:20:25PM +0200, Dominik Brodowski wrote:
> > Neil, Shaohua,
> >=20
> > following up on David R's bug message: I have observed something similar
> > on v4.12.[345] and v4.13-rc4, but not on v4.11. This is a RAID1 (on bare
> > metal partitions, /dev/sdaX and /dev/sdbY linked together). In case it
> > matters: Further upwards are cryptsetup, a DM volume group, then logical
> > volumes, and then filesystems (ext4, but also happened with xfs).
> >=20
> > In a tedious bisect (the bug wasn't as quickly reproducible as I would =
like,
> > but happened when I repeatedly created large lvs and filled them with s=
ome
> > content, while compiling kernels in parallel), I was able to track this
> > down to:
> >=20
> >=20
> > commit 4ad23a976413aa57fe5ba7a25953dc35ccca5b71
> > Author: NeilBrown <neilb@suse.com>
> > Date:   Wed Mar 15 14:05:14 2017 +1100
> >=20
> >     MD: use per-cpu counter for writes_pending
> >    =20
> >     The 'writes_pending' counter is used to determine when the
> >     array is stable so that it can be marked in the superblock
> >     as "Clean".  Consequently it needs to be updated frequently
> >     but only checked for zero occasionally.  Recent changes to
> >     raid5 cause the count to be updated even more often - once
> >     per 4K rather than once per bio.  This provided
> >     justification for making the updates more efficient.
> >=20
> >     ...
> >=20
> >=20
> > CC'ing tj@kernel.org, as 4ad23a976413 is the first (and only?) user
> > of percpu_ref_switch_to_atomic_sync() introduced in 210f7cdcf088.
> >=20
> > Applying a415c0f10627 on top of 4ad23a976413 does *not* fix the issue, =
but
> > reverting all of a2bfc6753065, a415c0f10627 and 4ad23a976413 seems to f=
ix
> > the issue for v4.12.5.
>=20
> Spent some time to check this one,

Thanks for taking a look at this issue!

> unfortunately I can't find how that patch makes rcu stall. the percpu part
> looks good to me too. Can you double check if reverting 4ad23a976413aa57
> makes the issue go away?

v4.12.5 with the three patches reverted survived many hours of testing
yesterday. Rebooted into 4ad23a976413aa57 (rebuilt with lockup detection),
and got back traces for mdX_raid1 after a few minutes. The following test
was done with plain v4.12.5, with the first stall after around ~1 minute:

> When the rcu stall happens, what the /sys/block/md/md0/array_state?

First, a "ps axf | grep 'md'" snippet:

  498 ?        S<     0:00  \_ [md]
 1163 ?        D      0:01  \_ [md0_raid1]
 1172 ?        D      0:07  \_ [md1_raid1]
 1182 ?        D      0:00  \_ [md2_raid1]
 1192 ?        R      1:35  \_ [md3_raid1]

(why are md[012]_raid1 continuously in "D" state?)

array_state for md0: active
array_state for md1: active-idle
array_state for md2: active-idle
array_state for md3: clean

> please also attach /proc/mdstat.

Personalities : [raid1]=20
md3 : active raid1 sda8[0] sdb5[1]
      174981120 blocks super 1.2 [2/2] [UU]
      bitmap: 0/2 pages [0KB], 65536KB chunk

md2 : active raid1 sda7[0] sdb6[1]
      174981120 blocks super 1.2 [2/2] [UU]
      bitmap: 1/2 pages [4KB], 65536KB chunk

md1 : active raid1 sda6[0] sdb7[1]
      174981120 blocks super 1.2 [2/2] [UU]
      bitmap: 2/2 pages [8KB], 65536KB chunk

md0 : active raid1 sda5[0] sdb8[1]
      174981120 blocks super 1.2 [2/2] [UU]
      bitmap: 1/2 pages [4KB], 65536KB chunk

unused devices: <none>

> When you say the mdx_raid1 threads are in 'R' state, can you double check
> if the /proc/pid/stack always 0xffffffffff?

root@i3test ~ # cat /proc/1192/stack # md3_raid1
[<ffffffffffffffff>] 0xffffffffffffffff

root@i3test ~ # cat /proc/1182/stack=20
[<ffffffff8143b9ff>] percpu_ref_switch_to_atomic_sync+0x3f/0x80
[<ffffffff815d03a8>] set_in_sync+0x68/0xe0
[<ffffffff815db314>] md_check_recovery+0x284/0x4c0
[<ffffffff815cc45c>] raid1d+0x4c/0x910
[<ffffffff815d030d>] md_thread+0x12d/0x160
[<ffffffff81141bb1>] kthread+0x131/0x170
[<ffffffff81793dd7>] ret_from_fork+0x27/0x40
[<ffffffffffffffff>] 0xffffffffffffffff

root@i3test ~ # cat /proc/1172/stack=20
[<ffffffff8143b9ff>] percpu_ref_switch_to_atomic_sync+0x3f/0x80
[<ffffffff815d03a8>] set_in_sync+0x68/0xe0
[<ffffffff815db314>] md_check_recovery+0x284/0x4c0
[<ffffffff815cc45c>] raid1d+0x4c/0x910
[<ffffffff815d030d>] md_thread+0x12d/0x160
[<ffffffff81141bb1>] kthread+0x131/0x170
[<ffffffff81793dd7>] ret_from_fork+0x27/0x40
[<ffffffffffffffff>] 0xffffffffffffffff

root@i3test ~ # cat /proc/1163/stack=20
[<ffffffff8143b9ff>] percpu_ref_switch_to_atomic_sync+0x3f/0x80
[<ffffffff815d03a8>] set_in_sync+0x68/0xe0
[<ffffffff815db314>] md_check_recovery+0x284/0x4c0
[<ffffffff815cc45c>] raid1d+0x4c/0x910
[<ffffffff815d030d>] md_thread+0x12d/0x160
[<ffffffff81141bb1>] kthread+0x131/0x170
[<ffffffff81793dd7>] ret_from_fork+0x27/0x40
[<ffffffffffffffff>] 0xffffffffffffffff

So the other md[012]_raid1 threads are waiting in
percpu_ref_switch_to_atomic_sync(). And md3_raid1 is,
(according to NMI watchdog: BUG: soft lockup - CPU#4 stuck for 23s!
[md3_raid1:1192], stuck somewhere in raid1d...

[   92.564717] task: ffff880234442e80 task.stack: ffffc9000102c000
[   92.564781] RIP: 0010:_raw_spin_unlock_irqrestore+0x33/0x50
[   92.564843] RSP: 0018:ffffc9000102fdb0 EFLAGS: 00000246 ORIG_RAX: ffffff=
ffffffff10
[   92.564913] RAX: 0000000000000000 RBX: 0000000000000246 RCX: ffff8802321=
a1e00
[   92.564995] RDX: ffffffff815cca08 RSI: 0000000000000001 RDI: ffffffff817=
93291
[   92.565077] RBP: ffffc9000102fdc0 R08: 0000000000000000 R09: 00000000000=
00000
[   92.565159] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8802321=
a1e18
[   92.565241] R13: ffff8802321a1e70 R14: ffff880234442e80 R15: 00000000000=
00000
[   92.565323] FS:  0000000000000000(0000) GS:ffff880236e00000(0000) knlGS:=
0000000000000000
[   92.565425] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   92.565502] CR2: 00000083b78e4e30 CR3: 0000000001c23000 CR4: 00000000000=
006e0
[   92.565585] Call Trace:
[   92.565657]  raid1d+0x5f8/0x910
[   92.565729]  ? retint_kernel+0x10/0x10
[   92.565802]  md_thread+0x12d/0x160
[   92.565874]  ? md_thread+0x12d/0x160
[   92.565947]  ? __wake_up_common+0x80/0x80
[   92.566022]  kthread+0x131/0x170
[   92.566093]  ? find_pers+0x70/0x70
[   92.566165]  ? __kthread_create_on_node+0x220/0x220
[   92.566241]  ret_from_fork+0x27/0x40
[   92.566312] Code: fc 48 8b 55 08 53 48 8d 7f 18 48 89 f3 be 01 00 00 00 =
e8 b1 ce 9d ff 4c 89 e7 e8 19 0c 9e ff f6 c7 02 74 13 e8 ff 90 9d ff 53 9d =
<65> ff 0d 3e 94 87 7e 5b 41 5c 5d c3 53 9d e8 4a 93 9d ff eb eb=20

Thanks,
	Dominik

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEmgXaWKgmjrvkPhLCmpdgiUyNow0FAlmJY80ACgkQmpdgiUyN
ow2v6g/+OR/B3FtQ71yB/DlgjXyj4WgzdXfOkrrg/zSaLjpx/CBxtE03npF9gG3E
+GVG2zv35RbImA0bjU4idUqeTRzhpzAn0RWnYlFwCt1RBLV+Cf5szLPgcKuFfxwF
YDs7NjQ9f0XwMAlCs9aa41myTVzX9KLiyxzMFNwNn96F7ncBV7SVar+MLqjD0SsQ
UU9zcBxb/5yaJf8lPsYZU9gj1bxzjH8trNhl2s5mEm/AwAp8gFbBb1E1yLAsLZ6i
pAZ2bVtccJy/tJSoBiET2GxlHufQBX3brY8lTXhDoZu/ZBaemSheZRwcD41FT9Ww
AEXk7omU0etwLyf1M8xIVVAZXl7kbr/pj0wDxDQ5KXmjSG3Y8kywgABlWPWNcOTZ
WqzlRY+5SX25o57VMq/BSi8MyYtsypW6HOFqvaHGnNuvanxBJyCrSmszabLpLrzk
KrkMUyf6tFvYSar99sEc1PswU4cAIeAi3eWfpysc3JvqIvd5K37c9ptq5g2Z8nnn
xopJoQA6nBepMXDDzOYszHjht9+Vp5I9h/5TZtZKwVwkzpQ0aW0netGr/wLVX2An
3jhXYryMpObJnDwS6LhjRYWz18zwxJ9pqKktHx49hKrb0FnUYdai3AmzQREqGXkl
W1WjNGQvahA/X9xtQ5hHlrxbXUFsqu4I9D5MF5v+82OWDJ70llQ=
=s7n1
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
