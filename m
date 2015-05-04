From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5: init batch_xxx for new sh at resize_stripes
Date: Mon, 4 May 2015 17:24:24 +1000
Message-ID: <20150504172424.283b7727@notabene.brown>
References: <1430718624-8988-1-git-send-email-yuanhan.liu@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/pvAvrYIf4gxZ7S5GaLYav/q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1430718624-8988-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

--Sig_/pvAvrYIf4gxZ7S5GaLYav/q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon,  4 May 2015 13:50:24 +0800 Yuanhan Liu <yuanhan.liu@linux.intel.com>
wrote:

> This is to fix a kernel NULL dereference oops introduced by commit
> 59fc630b("RAID5: batch adjacent full stripe write"), which introduced
> several batch_xxx fields, and did initiation for them at grow_one_stripes=
(),
> but forgot to do same at resize_stripes().
>=20
> This oops can be easily triggered by following steps:
>=20
>     __create RAID5 /dev/md0
>     __grow /dev/md0
>     mdadm --wait /dev/md0
>     dd if=3D/dev/zero of=3D/dev/md0
>=20
> Here is the detailed oops log:
>=20
> [   32.384499] BUG: unable to handle kernel NULL pointer dereference at  =
         (null)
> [   32.385366] IP: [<ffffffff81844082>] add_stripe_bio+0x48d/0x544
> [   32.385955] PGD 373f3067 PUD 36e34067 PMD 0
> [   32.386404] Oops: 0002 [#1] SMP
> [   32.386740] Modules linked in:
> [   32.387040] CPU: 0 PID: 1059 Comm: kworker/u2:2 Not tainted 4.0.0-next=
-20150427+ #107
> [   32.387762] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
> [   32.388044] Workqueue: writeback bdi_writeback_workfn (flush-9:0)
> [   32.388044] task: ffff88003d038000 ti: ffff88003d40c000 task.ti: ffff8=
8003d40c000
> [   32.388044] RIP: 0010:[<ffffffff81844082>]  [<ffffffff81844082>] add_s=
tripe_bio+0x48d/0x544
> [   32.388044] RSP: 0000:ffff88003d40f6f8  EFLAGS: 00010046
> [   32.388044] RAX: 0000000000000000 RBX: ffff880037168cd0 RCX: ffff88003=
7179a28
> [   32.388044] RDX: ffff880037168d58 RSI: 0000000000000000 RDI: ffff88003=
7179a20
> [   32.388044] RBP: ffff88003d40f738 R08: 0000000000000410 R09: 000000000=
0000410
> [   32.388044] R10: 0000000000000410 R11: 0000000000000002 R12: ffff88003=
71799a0
> [   32.388044] R13: ffff88003c3d0800 R14: 0000000000000001 R15: ffff88003=
7179a08
> [   32.388044] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlG=
S:0000000000000000
> [   32.388044] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   32.388044] CR2: 0000000000000000 CR3: 0000000036e33000 CR4: 000000000=
00006f0
> [   32.388044] Stack:
> [   32.388044]  0000000200000000 ffff880037168d38 ffff88003d40f738 ffff88=
003c3abd00
> [   32.388044]  ffff88003c2df800 ffff88003c3d0800 0000000000000408 ffff88=
003c3d0b54
> [   32.388044]  ffff88003d40f828 ffffffff8184b9ea ffffffff3d40f7e8 000000=
0000000292
> [   32.388044] Call Trace:
> [   32.388044]  [<ffffffff8184b9ea>] make_request+0x7a8/0xaee
> [   32.388044]  [<ffffffff81120387>] ? wait_woken+0x79/0x79
> [   32.388044]  [<ffffffff811e9a85>] ? kmem_cache_alloc+0x95/0x1b6
> [   32.388044]  [<ffffffff8186b944>] md_make_request+0xeb/0x1c3
> [   32.388044]  [<ffffffff811a3025>] ? mempool_alloc+0x64/0x127
> [   32.388044]  [<ffffffff81481575>] generic_make_request+0x9c/0xdb
> [   32.388044]  [<ffffffff814816aa>] submit_bio+0xf6/0x134
> [   32.388044]  [<ffffffff8122a1f7>] _submit_bh+0x119/0x141
> [   32.388044]  [<ffffffff8122a22f>] submit_bh+0x10/0x12
> [   32.388044]  [<ffffffff8122bbb9>] __block_write_full_page.constprop.30=
+0x1a3/0x2a4
> [   32.388044]  [<ffffffff8122bead>] ? I_BDEV+0xd/0xd
> [   32.388044]  [<ffffffff8122bd65>] block_write_full_page+0xab/0xaf
> [   32.388044]  [<ffffffff8122c657>] blkdev_writepage+0x18/0x1a
> [   32.388044]  [<ffffffff811a9853>] __writepage+0x14/0x2d
> [   32.388044]  [<ffffffff811a9ef3>] write_cache_pages+0x29a/0x3a7
> [   32.388044]  [<ffffffff811a983f>] ? mapping_tagged+0x14/0x14
> [   32.388044]  [<ffffffff811aa03e>] generic_writepages+0x3e/0x56
> [   32.388044]  [<ffffffff811ab638>] do_writepages+0x1e/0x2c
> [   32.388044]  [<ffffffff812229ed>] __writeback_single_inode+0x5b/0x27e
> [   32.388044]  [<ffffffff81222ec7>] writeback_sb_inodes+0x1dc/0x358
> [   32.388044]  [<ffffffff812230c2>] __writeback_inodes_wb+0x7f/0xb8
> [   32.388044]  [<ffffffff812232b9>] wb_writeback+0x11a/0x271
> [   32.388044]  [<ffffffff811aa483>] ? global_dirty_limits+0x1b/0xfd
> [   32.388044]  [<ffffffff8122399c>] bdi_writeback_workfn+0x1ae/0x360
> [   32.388044]  [<ffffffff81101bab>] process_one_work+0x1c2/0x340
> [   32.388044]  [<ffffffff81102571>] worker_thread+0x28b/0x389
> [   32.388044]  [<ffffffff811022e6>] ? cancel_delayed_work_sync+0x15/0x15
> [   32.388044]  [<ffffffff81106936>] kthread+0xd2/0xda
> [   32.388044]  [<ffffffff81106864>] ? kthread_create_on_node+0x17c/0x17c
> [   32.388044]  [<ffffffff81a16682>] ret_from_fork+0x42/0x70
> [   32.388044]  [<ffffffff81106864>] ? kthread_create_on_node+0x17c/0x17c
> [   32.388044] Code: 84 24 90 00 00 00 48 8d 93 88 00 00 00 49 8d 8c 24 8=
8 00 00 00 49 89 94 24 90 00 00 00 48 89 8b 88 00 00 00 48 89 83 90 00 00 0=
0 <48> 89 10 66 41 83 84 24 80 00 00 00 01 3e 0f ba 73 48 06 72 02
> [   32.388044] RIP  [<ffffffff81844082>] add_stripe_bio+0x48d/0x544
> [   32.388044]  RSP <ffff88003d40f6f8>
> [   32.388044] CR2: 0000000000000000
> [   32.388044] ---[ end trace 2b255d3f55be9eb3 ]---
>=20
> Cc: Shaohua Li <shli@kernel.org>
> Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> ---
>  drivers/md/raid5.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 697d77a..7b074f7 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2217,6 +2217,10 @@ static int resize_stripes(struct r5conf *conf, int=
 newsize)
>  				if (!p)
>  					err =3D -ENOMEM;
>  			}
> +
> +		spin_lock_init(&nsh->batch_lock);
> +		INIT_LIST_HEAD(&nsh->batch_list);
> +		nsh->batch_head =3D NULL;
>  		release_stripe(nsh);
>  	}
>  	/* critical section pass, GFP_NOIO no longer needed */

Thanks!

However I already have the following fix queued - though not pushed  out
you.  I probably would have got it into -rc2 except that I was chasing
another raid5 bug.  The
	BUG_ON(sh->batch_head);

in handle_stripe_fill() fires when I run the mdadm selftests.  I got caught
up chasing that and didn't push the other fix.

Thanks,
NeilBrown


=46rom 3dd8ba734349e602fe17d647ce3da5f4a13748aa Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 30 Apr 2015 11:24:28 +1000
Subject: [PATCH] md/raid5 new alloc_stripe function.


diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 77dfd720aaa0..91a1e8b26b52 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1971,17 +1971,30 @@ static void raid_run_ops(struct stripe_head *sh, un=
signed long ops_request)
 	put_cpu();
 }
=20
+static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp)
+{
+	struct stripe_head *sh;
+
+	sh =3D kmem_cache_zalloc(sc, gfp);
+	if (sh) {
+		spin_lock_init(&sh->stripe_lock);
+		spin_lock_init(&sh->batch_lock);
+		INIT_LIST_HEAD(&sh->batch_list);
+		INIT_LIST_HEAD(&sh->lru);
+		atomic_set(&sh->count, 1);
+	}
+	return sh;
+}
 static int grow_one_stripe(struct r5conf *conf, gfp_t gfp)
 {
 	struct stripe_head *sh;
-	sh =3D kmem_cache_zalloc(conf->slab_cache, gfp);
+
+	sh =3D alloc_stripe(conf->slab_cache, gfp);
 	if (!sh)
 		return 0;
=20
 	sh->raid_conf =3D conf;
=20
-	spin_lock_init(&sh->stripe_lock);
-
 	if (grow_buffers(sh, gfp)) {
 		shrink_buffers(sh);
 		kmem_cache_free(conf->slab_cache, sh);
@@ -1990,13 +2003,8 @@ static int grow_one_stripe(struct r5conf *conf, gfp_=
t gfp)
 	sh->hash_lock_index =3D
 		conf->max_nr_stripes % NR_STRIPE_HASH_LOCKS;
 	/* we just created an active stripe so... */
-	atomic_set(&sh->count, 1);
 	atomic_inc(&conf->active_stripes);
-	INIT_LIST_HEAD(&sh->lru);
=20
-	spin_lock_init(&sh->batch_lock);
-	INIT_LIST_HEAD(&sh->batch_list);
-	sh->batch_head =3D NULL;
 	release_stripe(sh);
 	conf->max_nr_stripes++;
 	return 1;
@@ -2109,13 +2117,11 @@ static int resize_stripes(struct r5conf *conf, int =
newsize)
 		return -ENOMEM;
=20
 	for (i =3D conf->max_nr_stripes; i; i--) {
-		nsh =3D kmem_cache_zalloc(sc, GFP_KERNEL);
+		nsh =3D alloc_stripe(sc, GFP_KERNEL);
 		if (!nsh)
 			break;
=20
 		nsh->raid_conf =3D conf;
-		spin_lock_init(&nsh->stripe_lock);
-
 		list_add(&nsh->lru, &newstripes);
 	}
 	if (i) {
@@ -2142,13 +2148,11 @@ static int resize_stripes(struct r5conf *conf, int =
newsize)
 				    lock_device_hash_lock(conf, hash));
 		osh =3D get_free_stripe(conf, hash);
 		unlock_device_hash_lock(conf, hash);
-		atomic_set(&nsh->count, 1);
+
 		for(i=3D0; i<conf->pool_size; i++) {
 			nsh->dev[i].page =3D osh->dev[i].page;
 			nsh->dev[i].orig_page =3D osh->dev[i].page;
 		}
-		for( ; i<newsize; i++)
-			nsh->dev[i].page =3D NULL;
 		nsh->hash_lock_index =3D hash;
 		kmem_cache_free(conf->slab_cache, osh);
 		cnt++;


--Sig_/pvAvrYIf4gxZ7S5GaLYav/q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUceqTnsnt1WYoG5AQJQHg/9HHr0arBDsmOKNlULJRkADWgbdZRD6gPw
eVAWiLmf8j+ll/xyocPfvqpHfwT+UQ1TYwuLdrdrh4Z+9u0q49MWRmA/WQThkaae
zMYhKN72tiR5LkOnvq9YCg2Mh6SBqXGtqFyryXCypOo90sEaE9YYACcQ1CSmOEY1
km6lkg+Pv2HajkCPcsvXqlBiHJBwMo6I6QHMGDixQdVXW69UHINUju3EPPXjhBgG
H8lKBqLL3OKz94BhCQC4cEuIRkpNc/okyq0cLIY4K7R1cd2HlwTnLD+q0e6BR2aK
ubmrfJcQJaqLAPh+o+b7+vUM6yAg5yGlwJIW3qHOYFCsvfu97j+TD89ytw3Y2l9T
VU3DeXdLGF+6VG+Dr2ys3nSq3NO8PCeCcWoNAH/mRBPe08e3NChQkAuGBGv1Hzkm
gmgyBf9rC7npazotOrFqjNBF04CkDAvoDP3EJVNasT5IQEUdJpvP1jxjpyPwaKVw
sHcqLnASphTVXahliVdYeIGP7zxva/LdCsTZYS6M2TiAlL8AaJ1bWKIuy/DO301e
eTqEvCLYcnOqKjLV+iXwB7+QbK2kPloqIoz/GipHUyNUOXNRUxD9UvteDmkK0Qsv
4kDbwaIabUD9W8cKB08uCvQr8zPsAX754eTcCdVWdwF3ZZRk17HHTgLdTphicVHx
Y8wkTbvII+E=
=T3s1
-----END PGP SIGNATURE-----

--Sig_/pvAvrYIf4gxZ7S5GaLYav/q--
