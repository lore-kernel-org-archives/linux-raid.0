From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 07/10 v3] md: personality can provide unplug private
 data
Date: Mon, 2 Jul 2012 11:06:32 +1000
Message-ID: <20120702110632.71359f80@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072653.743080746@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+nK=oHpDdqQokrNHAR2uNaE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625072653.743080746@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/+nK=oHpDdqQokrNHAR2uNaE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 15:24:54 +0800 Shaohua Li <shli@kernel.org> wrote:

> Allow personality providing unplug private data. Next patch will use it.

Thanks. I've applied this with a couple of minor changes.

In particular I change the 'size' arg to be size total size of the
plug structure, not the amount to add to the end.  I also change it
to use kzalloc rather then an extra memset.

Thanks,
NeilBrown


>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/md.c     |   31 +++++++++++++------------------
>  drivers/md/md.h     |   20 +++++++++++++++++++-
>  drivers/md/raid1.c  |    2 +-
>  drivers/md/raid10.c |    2 +-
>  drivers/md/raid5.c  |    2 +-
>  5 files changed, 35 insertions(+), 22 deletions(-)
>=20
> Index: linux/drivers/md/md.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/md.c	2012-06-25 14:36:13.668642048 +0800
> +++ linux/drivers/md/md.c	2012-06-25 14:38:33.106889041 +0800
> @@ -498,22 +498,13 @@ void md_flush_request(struct mddev *mdde
>  }
>  EXPORT_SYMBOL(md_flush_request);
> =20
> -/* Support for plugging.
> - * This mirrors the plugging support in request_queue, but does not
> - * require having a whole queue or request structures.
> - * We allocate an md_plug_cb for each md device and each thread it gets
> - * plugged on.  This links tot the private plug_handle structure in the
> - * personality data where we keep a count of the number of outstanding
> - * plugs so other code can see if a plug is active.
> - */
> -struct md_plug_cb {
> -	struct blk_plug_cb cb;
> -	struct mddev *mddev;
> -};
> =20
>  static void plugger_unplug(struct blk_plug_cb *cb)
>  {
>  	struct md_plug_cb *mdcb =3D container_of(cb, struct md_plug_cb, cb);
> +
> +	if (mdcb->unplug)
> +		mdcb->unplug(mdcb);
>  	if (atomic_dec_and_test(&mdcb->mddev->plug_cnt))
>  		md_wakeup_thread(mdcb->mddev->thread);
>  	kfree(mdcb);
> @@ -522,13 +513,14 @@ static void plugger_unplug(struct blk_pl
>  /* Check that an unplug wakeup will come shortly.
>   * If not, wakeup the md thread immediately
>   */
> -int mddev_check_plugged(struct mddev *mddev)
> +struct md_plug_cb *mddev_check_plugged(struct mddev *mddev,
> +	md_unplug_func_t unplug, size_t size)
>  {
>  	struct blk_plug *plug =3D current->plug;
>  	struct md_plug_cb *mdcb;
> =20
>  	if (!plug)
> -		return 0;
> +		return NULL;
> =20
>  	list_for_each_entry(mdcb, &plug->cb_list, cb.list) {
>  		if (mdcb->cb.callback =3D=3D plugger_unplug &&
> @@ -538,19 +530,22 @@ int mddev_check_plugged(struct mddev *md
>  						    struct md_plug_cb,
>  						    cb.list))
>  				list_move(&mdcb->cb.list, &plug->cb_list);
> -			return 1;
> +			return mdcb;
>  		}
>  	}
>  	/* Not currently on the callback list */
> -	mdcb =3D kmalloc(sizeof(*mdcb), GFP_ATOMIC);
> +	mdcb =3D kmalloc(sizeof(*mdcb) + size, GFP_ATOMIC);
>  	if (!mdcb)
> -		return 0;
> +		return NULL;
> =20
>  	mdcb->mddev =3D mddev;
>  	mdcb->cb.callback =3D plugger_unplug;
>  	atomic_inc(&mddev->plug_cnt);
>  	list_add(&mdcb->cb.list, &plug->cb_list);
> -	return 1;
> +	mdcb->unplug =3D unplug;
> +	if (size)
> +		memset((void *)(mdcb + 1), 0, size);
> +	return mdcb;
>  }
>  EXPORT_SYMBOL_GPL(mddev_check_plugged);
> =20
> Index: linux/drivers/md/md.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/md.h	2012-06-25 14:36:13.676641948 +0800
> +++ linux/drivers/md/md.h	2012-06-25 14:38:33.106889041 +0800
> @@ -630,6 +630,24 @@ extern struct bio *bio_clone_mddev(struc
>  				   struct mddev *mddev);
>  extern struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iovecs,
>  				   struct mddev *mddev);
> -extern int mddev_check_plugged(struct mddev *mddev);
> +
> +/* Support for plugging.
> + * This mirrors the plugging support in request_queue, but does not
> + * require having a whole queue or request structures.
> + * We allocate an md_plug_cb for each md device and each thread it gets
> + * plugged on.  This links tot the private plug_handle structure in the
> + * personality data where we keep a count of the number of outstanding
> + * plugs so other code can see if a plug is active.
> + */
> +struct md_plug_cb;
> +typedef void (*md_unplug_func_t)(struct md_plug_cb *mdcb);
> +struct md_plug_cb {
> +	struct blk_plug_cb cb;
> +	struct mddev *mddev;
> +	md_unplug_func_t unplug;
> +};
> +
> +extern struct md_plug_cb *mddev_check_plugged(struct mddev *mddev,
> +	md_unplug_func_t unplug, size_t size);
>  extern void md_trim_bio(struct bio *bio, int offset, int size);
>  #endif /* _MD_MD_H */
> Index: linux/drivers/md/raid1.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid1.c	2012-06-25 14:36:13.696641695 +0800
> +++ linux/drivers/md/raid1.c	2012-06-25 14:38:33.110889008 +0800
> @@ -1034,7 +1034,7 @@ read_again:
>  	 * the bad blocks.  Each set of writes gets it's own r1bio
>  	 * with a set of bios attached.
>  	 */
> -	plugged =3D mddev_check_plugged(mddev);
> +	plugged =3D !!mddev_check_plugged(mddev, NULL, 0);
> =20
>  	disks =3D conf->raid_disks * 2;
>   retry_write:
> Index: linux/drivers/md/raid10.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid10.c	2012-06-25 14:36:13.684641847 +0800
> +++ linux/drivers/md/raid10.c	2012-06-25 14:38:33.110889008 +0800
> @@ -1239,7 +1239,7 @@ read_again:
>  	 * of r10_bios is recored in bio->bi_phys_segments just as with
>  	 * the read case.
>  	 */
> -	plugged =3D mddev_check_plugged(mddev);
> +	plugged =3D !!mddev_check_plugged(mddev, NULL, 0);
> =20
>  	r10_bio->read_slot =3D -1; /* make sure repl_bio gets freed */
>  	raid10_find_phys(conf, r10_bio);
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-25 14:38:13.899130571 +0800
> +++ linux/drivers/md/raid5.c	2012-06-25 14:38:33.110889008 +0800
> @@ -4012,7 +4012,7 @@ static void make_request(struct mddev *m
>  	bi->bi_next =3D NULL;
>  	bi->bi_phys_segments =3D 1;	/* over-loaded to count active stripes */
> =20
> -	plugged =3D mddev_check_plugged(mddev);
> +	plugged =3D !!mddev_check_plugged(mddev, NULL, 0);
>  	for (;logical_sector < last_sector; logical_sector +=3D STRIPE_SECTORS)=
 {
>  		DEFINE_WAIT(w);
>  		int previous;


--Sig_/+nK=oHpDdqQokrNHAR2uNaE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/D0GDnsnt1WYoG5AQJwmw//bNfg8munMp7dfBiuurdsaD33KbHGZtu/
S7e75zpdVEnbfKsMi6486WfLEpv4FPJij7iC97rPuOCg2nrpRMxp0jPWPNzpz8N9
3MfVwZgrhGX9z61DHbRF0JPuIhqTiAVnmTBLvATmWNEnwj8lPM41nTtcV2odSdR2
ddqGQdLfapjLB+J+BDwrW+53BsLTMOvZSYO5e4X3sFEadLmF7glNsP5R7AhcgiOO
UQsf2IbmahE42IGOuAHJCmXpwYiFzOWdc7jNZfSn6KT53HRTIfcPTBemeVlUCQox
YYTJs/FWQISPnjn9ZLLWk/4+G3JK6TLzWX6QzcbQIjY86ZsHT2T+OYR9DPFHBiFG
v1+m1Tlk2wyYj1vnrVqr5qWcCBbi/cK9xQ9P+KTOygmwOR9L4zs5N3Yvj8lpTb4j
BYKpDc/YUZmC2OZvinPn5DjTaYJQ1OMZ8g7x37zUJQc+5XMuWuCA5T7+sjBEAm58
c/FKSWFTFP5QWYaSGpE+s95VwIb3l1owexZBOojSq4k+MYodoMgrE0X0izd40IRh
Rg1cbugfbNyhPAfS+9kdyAGxtWyty0ndBbw0v/8vxx6u+/5p5gqPI/c6IJW+tEbk
2KvFkujGCnzv4JRGoCilmLV5PxAe76K77S6ACl07TECB7xcJ/VkiEuzZLWoCmYXS
ZWh1kGgj5Us=
=yF5d
-----END PGP SIGNATURE-----

--Sig_/+nK=oHpDdqQokrNHAR2uNaE--
