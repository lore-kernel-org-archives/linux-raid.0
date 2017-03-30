From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: update slab_cache before releasing new stripes when stripes resizing
Date: Thu, 30 Mar 2017 14:01:18 +1100
Message-ID: <87inmr5uyp.fsf@notabene.neil.brown.name>
References: <1490773573-32692-1-git-send-email-dennisyang@qnap.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1490773573-32692-1-git-send-email-dennisyang@qnap.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dennis Yang <dennisyang@qnap.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 29 2017, Dennis Yang wrote:

> When growing raid5 device on machine with small memory, there is chance t=
hat
> mdadm will be killed and the following bug report can be observed. The sa=
me
> bug could also be reproduced in linux-4.10.6.
>
> [57600.075774] BUG: unable to handle kernel NULL pointer dereference at  =
         (null)
> [57600.083796] IP: [<ffffffff81a6aa87>] _raw_spin_lock+0x7/0x20
> [57600.110378] PGD 421cf067 PUD 4442d067 PMD 0
> [57600.114678] Oops: 0002 [#1] SMP
> [57600.180799] CPU: 1 PID: 25990 Comm: mdadm Tainted: P           O    4.=
2.8 #1
> [57600.187849] Hardware name: To be filled by O.E.M. To be filled by O.E.=
M./MAHOBAY, BIOS QV05AR66 03/06/2013
> [57600.197490] task: ffff880044e47240 ti: ffff880043070000 task.ti: ffff8=
80043070000
> [57600.204963] RIP: 0010:[<ffffffff81a6aa87>]  [<ffffffff81a6aa87>] _raw_=
spin_lock+0x7/0x20
> [57600.213057] RSP: 0018:ffff880043073810  EFLAGS: 00010046
> [57600.218359] RAX: 0000000000000000 RBX: 000000000000000c RCX: ffff88011=
e296dd0
> [57600.225486] RDX: 0000000000000001 RSI: ffffe8ffffcb46c0 RDI: 000000000=
0000000
> [57600.232613] RBP: ffff880043073878 R08: ffff88011e5f8170 R09: 000000000=
0000282
> [57600.239739] R10: 0000000000000005 R11: 28f5c28f5c28f5c3 R12: ffff88004=
3073838
> [57600.246872] R13: ffffe8ffffcb46c0 R14: 0000000000000000 R15: ffff8800b=
9706a00
> [57600.253999] FS:  00007f576106c700(0000) GS:ffff88011e280000(0000) knlG=
S:0000000000000000
> [57600.262078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [57600.267817] CR2: 0000000000000000 CR3: 00000000428fe000 CR4: 000000000=
01406e0
> [57600.274942] Stack:
> [57600.276949]  ffffffff8114ee35 ffff880043073868 0000000000000282 000000=
000000eb3f
> [57600.284383]  ffffffff81119043 ffff880043073838 ffff880043073838 ffff88=
003e197b98
> [57600.291820]  ffffe8ffffcb46c0 ffff88003e197360 0000000000000286 ffff88=
0043073968
> [57600.299254] Call Trace:
> [57600.301698]  [<ffffffff8114ee35>] ? cache_flusharray+0x35/0xe0
> [57600.307523]  [<ffffffff81119043>] ? __page_cache_release+0x23/0x110
> [57600.313779]  [<ffffffff8114eb53>] kmem_cache_free+0x63/0xc0
> [57600.319344]  [<ffffffff81579942>] drop_one_stripe+0x62/0x90
> [57600.324915]  [<ffffffff81579b5b>] raid5_cache_scan+0x8b/0xb0
> [57600.330563]  [<ffffffff8111b98a>] shrink_slab.part.36+0x19a/0x250
> [57600.336650]  [<ffffffff8111e38c>] shrink_zone+0x23c/0x250
> [57600.342039]  [<ffffffff8111e4f3>] do_try_to_free_pages+0x153/0x420
> [57600.348210]  [<ffffffff8111e851>] try_to_free_pages+0x91/0xa0
> [57600.353959]  [<ffffffff811145b1>] __alloc_pages_nodemask+0x4d1/0x8b0
> [57600.360303]  [<ffffffff8157a30b>] check_reshape+0x62b/0x770
> [57600.365866]  [<ffffffff8157a4a5>] raid5_check_reshape+0x55/0xa0
> [57600.371778]  [<ffffffff81583df7>] update_raid_disks+0xc7/0x110
> [57600.377604]  [<ffffffff81592b73>] md_ioctl+0xd83/0x1b10
> [57600.382827]  [<ffffffff81385380>] blkdev_ioctl+0x170/0x690
> [57600.388307]  [<ffffffff81195238>] block_ioctl+0x38/0x40
> [57600.393525]  [<ffffffff811731c5>] do_vfs_ioctl+0x2b5/0x480
> [57600.399010]  [<ffffffff8115e07b>] ? vfs_write+0x14b/0x1f0
> [57600.404400]  [<ffffffff811733cc>] SyS_ioctl+0x3c/0x70
> [57600.409447]  [<ffffffff81a6ad97>] entry_SYSCALL_64_fastpath+0x12/0x6a
> [57600.415875] Code: 00 00 00 00 55 48 89 e5 8b 07 85 c0 74 04 31 c0 5d c=
3 ba 01 00 00 00 f0 0f b1 17 85 c0 75 ef b0 01 5d c3 90 31 c0 ba 01 00 00 0=
0 <f0> 0f b1 17 85 c0 75 01 c3 55 89 c6 48 89 e5 e8 85 d1 63 ff 5d
> [57600.435460] RIP  [<ffffffff81a6aa87>] _raw_spin_lock+0x7/0x20
> [57600.441208]  RSP <ffff880043073810>
> [57600.444690] CR2: 0000000000000000
> [57600.448000] ---[ end trace cbc6b5cc4bf9831d ]---
>
> The problem is that resize_stripes() releases new stripe_heads before ass=
igning new
> slab cache to conf->slab_cache. If the shrinker function raid5_cache_scan=
() gets called
> after resize_stripes() starting releasing new stripes but right before ne=
w slab cache
> being assigned, it is possible that these new stripe_heads will be freed =
with the old
> slab_cache which was already been destoryed and that triggers this bug.
>
> Signed-off-by: Dennis Yang <dennisyang@qnap.com>
> ---
>  drivers/md/raid5.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6661db2c..172edc1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2286,6 +2286,10 @@ static int resize_stripes(struct r5conf *conf, int=
 newsize)
>  		err =3D -ENOMEM;
>=20=20
>  	mutex_unlock(&conf->cache_size_mutex);
> +=09
> +	conf->slab_cache =3D sc;
> +	conf->active_name =3D 1-conf->active_name;
> +
>  	/* Step 4, return new stripes to service */
>  	while(!list_empty(&newstripes)) {
>  		nsh =3D list_entry(newstripes.next, struct stripe_head, lru);
> @@ -2303,8 +2307,6 @@ static int resize_stripes(struct r5conf *conf, int =
newsize)
>  	}
>  	/* critical section pass, GFP_NOIO no longer needed */
>=20=20
> -	conf->slab_cache =3D sc;
> -	conf->active_name =3D 1-conf->active_name;
>  	if (!err)
>  		conf->pool_size =3D newsize;
>  	return err;
> --=20

Thanks!  I'd probably mark this for stable.  I suspect the bug was
introduced by  edbe83ab4c27

Fixes: edbe83ab4c27 ("md/raid5: allow the stripe_cache to grow and shrink.")
Cc: stable@vger.kernel.org (4.1+)
Reviewed-by: NeilBrown <neilb@suse.com>

Thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljcdP4ACgkQOeye3VZi
gblOPg//arOkI+nVXQuJ85iCDcYLcI7jw3Zgbo4weUyPXrA3CAd2jzDkEtSavosz
kGMBdtlUel4onooKw90aDLbhNGW5Jckka5sH5gsqFOYiq0jYtm3Fp9rW6saif7mK
vKo78y7MwDAx251sxRpDXC4oAxAnPbb8fYCedSAtigvqJKapjqmWK7DKZv9Uw9dg
2hg8fE3pXuoaFscy6dLQe/fTLYrJGph5231HsVD5zOEyuOJr8hxHubWaCMKQpOfa
Xtfp/3148H7C7ND5LfOxNP++0mFKf+B9P9q3sVmRBva45nFMoG4QHzYy62i2DuxB
DFQEmEtaC08O5qp1DrPOKvGMzAi7ZdiDJeKaPCJruRpTo904Vwyzo/5RuVWRSU8s
ENK7DAbZXY44cS03cWHjNgBSFRquomK9e+iYRJS6TDW1XIXoHyQCwxcE/6Z+ciaL
r98jrwz1ubNxRMqrOodFoZ6m0KkzL1HNX+/VRDe6xBkKS066Gq71zgAxej9I8sDF
O9Jt+j+DNo9WbROlDC+Tm8xmTz2qMHL23XLEVVQqjhQkBbqjDrqLUd6R5SeCuq6H
7V1iyhaYJVYznlVuyh6uxYfO3tmvHRv95iT523G61W11YqyDvpJmCgnqFYlW/mBb
W4gS5u+aLuYIpURL4rr4TnNaiiizZmqvoI6/EzFlAS7dniOLQQ4=
=AiMX
-----END PGP SIGNATURE-----
--=-=-=--
