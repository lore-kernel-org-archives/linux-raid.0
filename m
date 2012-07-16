From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] raid5: Flush data when do_md_stop in order to avoid
 stripe_cache leaking.
Date: Mon, 16 Jul 2012 18:20:30 +1000
Message-ID: <20120716182030.2d560594@notabene.brown>
References: <201207131357572035860@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/L_5LGsJZQ8Frgm6/AjNT5T6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201207131357572035860@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/L_5LGsJZQ8Frgm6/AjNT5T6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jul 2012 13:58:00 +0800 majianpeng <majianpeng@gmail.com> wrote:

> I found some kernel message below:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> [  432.213819] BUG raid5-md0 (Not tainted): Objects remaining on kmem_cac=
he_close()
> [  432.213820]
> -------------------------------------------------------------------------=
----
> [  432.213820]
> [  432.213823] INFO: Slab 0xffffea00029cae00 objects=3D24 used=3D1
> fp=3D0xffff8800a72bb910 flags=3D0x100000000004080
> [  432.213825] Pid: 6207, comm: mdadm Not tainted 3.5.0-rc6+ #56
> [  432.213827] Call Trace:
> [  432.213833]  [<ffffffff8111b4a1>] slab_err+0x71/0x80
> [  432.213836]  [<ffffffff810e4998>] ? __free_pages+0x18/0x30
> [  432.213839]  [<ffffffff8111f45a>] ? kmem_cache_destroy+0x16a/0x3a0
> [  432.213841]  [<ffffffff8111f47d>] kmem_cache_destroy+0x18d/0x3a0
> [  432.213845]  [<ffffffffa007ef8d>] free_conf+0x2d/0xf0 [raid456]
> [  432.213848]  [<ffffffffa007f8b1>] stop+0x41/0x60 [raid456]

This is certainly something to be concerned about...


>=20
> By the following steps, it can reappear.
> 1:create raid5
> 2:dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M
> 3:when exec "mdadm -S /dev/md0", press "CTRL+C" in dd-command screen.

Thanks - this worked first time.
Thought the 'bug' I got was different.

[  526.720419] BUG: unable to handle kernel paging request at ffff8801363fb=
e30
[  526.720877] IP: [<ffffffff8183cb34>] raid5_end_write_request+0x1f4/0x2f0

I think it is the same root cause though.

>=20
> In commit 271f5a9b8f8ae0db95de72779d115c9d0b9d3cc5
> Author: NeilBrown <neilb@suse.de>
> Remove invalidate_partition call from do_md_stop
>=20
> Because the deadlock, Neil remove the flush data.But in this pathch,Neil
> only thoungt the filesystem,but not consider the raw block deivces.

Please don't try to guess what I am thinking ;-)

Raw block device access is in many ways just like filesystem access.
/dev/md0 provides access to a special filesystem that provides exactly one
file which is 1-1 mapped to the block device. e.g It uses the same page cac=
he
as other filesystems.

do_md_stop will fail with -EBUSY if any program has the block device open.
When the last program closes /dev/md0, __blkdev_put will call sync_blockdev
which will flush out any writes.  So when do_md_stop starts disassembling t=
he
array there should be no writes.
But there are.

The problem happens if some other program (dd in this case) closes /dev/md0
between the time that mdadm opens it and the time that mdadm issues the
STOP_ARRAY ioctl.
In this case dd isn't the last program with /dev/md0 open, so the
sync_blockdev in __blkdev_put isn't called.

So if mdadm stopped the array by effectively doing
   echo clear > /sys/block/md0/md/array_state
(without holding /dev/md0 open) this race could not happen.  Either the
'echo' would, or the last close of /dev/md0 would have happened and the blo=
ck
device will have been flushed.

So the problem is that the ioctl holds the block device open preventing the
last flush.  So the fix should be in md_ioctl.
in md_ioctl we have a pointer to the bdev, so we don't need to try to find
one with bdget_disk.

Unfortunately we need to call sync_blockdev *after* taking ->open_mutex
otherwise the race still exists, and md_ioctl can't currently take open_mut=
ex.

We need to fix md_set_readonly too - it has the same problem.
Maybe I'll pass the bdev in to these two functions and get them to
call sync_blockdev after taking the lock and checking the count.

But it's late today - I'll sort this out tomorrow.

Thanks for finding this!

NeilBrown


>=20
> Using the latest kernel and readding "invalidate_partition" function.
> By the patch suggested, i create os in md0(softraid5).But the deadlock
> did not appear.
> But maybe my test not correct,so i don't using "invalidate_partition" to
> flush data. I used sync_block to flush data.
>=20
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/md.c    |    6 ++++++
>  drivers/md/raid5.c |    1 +
>  2 files changed, 7 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index a4c219e..5716569 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5395,10 +5395,16 @@ static int do_md_stop(struct mddev * mddev, int m=
ode, int is_open)
>  	}
> =20
>  	if (mddev->pers) {
> +		struct block_device *bdev;
>  		if (mddev->ro)
>  			set_disk_ro(disk, 0);
> =20
>  		__md_stop_writes(mddev);
> +		/*flush data*/
> +		bdev =3D bdget_disk(disk, 0);
> +		sync_blockdev(bdev);
> +		bdput(bdev);
> +
>  		md_stop(mddev);
>  		mddev->queue->merge_bvec_fn =3D NULL;
>  		mddev->queue->backing_dev_info.congested_fn =3D NULL;
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 04348d7..922e26e 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -1682,6 +1682,7 @@ static void shrink_stripes(struct r5conf *conf)
>  	while (drop_one_stripe(conf))
>  		;
> =20
> +	BUG_ON(atomic_read(&conf->active_stripes));
>  	if (conf->slab_cache)
>  		kmem_cache_destroy(conf->slab_cache);
>  	conf->slab_cache =3D NULL;


--Sig_/L_5LGsJZQ8Frgm6/AjNT5T6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAPOzjnsnt1WYoG5AQI3whAAsbWeuekcjlqT9rZkG49f4HKWuenMZS8K
aTI62+1JNCscVI/Z2GE+HZ7PkQGT2LlYcpVV3F9ttrFHp7HDG2zWTE7yYjsCy5ny
1GS08cAW5eoiZZ6NYp7O0D0osWa/yRyKc28afLSw1/MiCJHPT4BcmDDeq/YAsOrX
RRSqr0wnRQ5XP3T5SUD8E/w1m48SoGz7OPJtEgEcZRaq4XoWKU6orDPk8KWXVFN6
A3ppsRYp4KfSULma6ZQ3xSSiA1uwnEnG3ivGM/VTgoDe9BNoeU5ffUdVZ1s+yj/N
Mva5tdDCN4bqlpG9gxLjT1pFLQ02dZz/H1c1rgvNPDFnhXqGha1gPW7SnOMxgCMA
44XGO2rl98J0tmoAkXgLNtjg3uZIinwsg+B5I8J/XINXPfQqj0lvI7QFT3RErpaA
WQIC2STliH8AT2hvN95ZHc3hPLI4l5mk5jU0p6lEqefd18hk4BSh4LJJl+DpHfUP
VxvCETYM6zCGR9fd6NrhI7BQkhghjXE1UpiRBWpXteg4UrFaKLRBHoT7JSnp1hWy
k+jYgnLBDnidU90xjB+cnnpQDvvGUyCj/redgzSdiBS197aS7v6VzhY/XA3dDNDQ
ufQvW37GWIRSlWOkg6OGp073dsx7XCVgltNxOJRocBkyG7MHo7cbRNxHhbj0sP1O
v7TvL4Ich/U=
=V0nA
-----END PGP SIGNATURE-----

--Sig_/L_5LGsJZQ8Frgm6/AjNT5T6--
