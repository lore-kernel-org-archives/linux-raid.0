From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] raid5: allow r5l_io_unit allocations to fail
Date: Wed, 23 Dec 2015 09:29:09 +1100
Message-ID: <87lh8m2k3u.fsf@notabene.neil.brown.name>
References: <1450390197-19479-1-git-send-email-hch@lst.de> <1450390197-19479-4-git-send-email-hch@lst.de> <20151217234748.GA1860175@devbig084.prn1.facebook.com> <874mfg8qyc.fsf@notabene.neil.brown.name> <20151218015847.GA2146501@devbig084.prn1.facebook.com> <20151218112535.GB28224@lst.de> <20151218230657.GA342953@devbig084.prn1.facebook.com> <87vb7s680r.fsf@notabene.neil.brown.name> <20151222152050.GA28310@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151222152050.GA28310@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 23 2015, Christoph Hellwig wrote:

>> I wonder if we should have a mempool for these io units too.
>> We would allocate with GFP_ATOMIC (or similar) so the allocation woult
>> fail instead of blocking, but we would then know that an allocation
>> could only fail if there was another request in flight.  So the place
>> where we free an io_unit would be the obviously correct place to trigger
>> a retry of the delayed-due-to-mem-allocation-failure stripes.
>>=20
>> So I think I would prefer two lists, another mempool, and very well
>> defined places to retry the two lists.  Is that over-engineering?
>
> How about the variant below (relative to md/for-next)?  This implements
> the above and passes testing fine:
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 18de1fc..4fa9457 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -75,7 +75,10 @@ struct r5l_log {
>  	struct list_head finished_ios;	/* io_units which settle down in log dis=
k */
>  	struct bio flush_bio;
>=20=20
> +	struct list_head no_mem_stripes;   /* pending stripes, -ENOMEM */
> +
>  	struct kmem_cache *io_kc;
> +	mempool_t *io_pool;
>  	struct bio_set *bs;
>  	mempool_t *meta_pool;
>=20=20
> @@ -287,9 +290,10 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_l=
og *log)
>  	struct r5l_io_unit *io;
>  	struct r5l_meta_block *block;
>=20=20
> -	io =3D kmem_cache_zalloc(log->io_kc, GFP_ATOMIC);
> +	io =3D mempool_alloc(log->io_pool, GFP_ATOMIC);
>  	if (!io)
>  		return NULL;
> +	memset(io, 0, sizeof(*io));
>=20=20
>  	io->log =3D log;
>  	INIT_LIST_HEAD(&io->log_sibling);
> @@ -490,24 +494,25 @@ int r5l_write_stripe(struct r5l_log *log, struct st=
ripe_head *sh)
>  	mutex_lock(&log->io_mutex);
>  	/* meta + data */
>  	reserve =3D (1 + write_disks) << (PAGE_SHIFT - 9);
> -	if (!r5l_has_free_space(log, reserve))
> -		goto err_retry;
> +	if (!r5l_has_free_space(log, reserve)) {
> +		spin_lock(&log->no_space_stripes_lock);
> +		list_add_tail(&sh->log_list, &log->no_space_stripes);
> +		spin_unlock(&log->no_space_stripes_lock);
> +
> +		r5l_wake_reclaim(log, reserve);
> +		goto out_unlock;
> +	}
>=20=20
>  	ret =3D r5l_log_stripe(log, sh, data_pages, parity_pages);
> -	if (ret)
> -		goto err_retry;
> +	if (ret) {
> +		spin_lock_irq(&log->io_list_lock);
> +		list_add_tail(&sh->log_list, &log->no_mem_stripes);
> +		spin_unlock_irq(&log->io_list_lock);
> +	}
>=20=20
>  out_unlock:
>  	mutex_unlock(&log->io_mutex);
>  	return 0;
> -
> -err_retry:
> -	spin_lock(&log->no_space_stripes_lock);
> -	list_add_tail(&sh->log_list, &log->no_space_stripes);
> -	spin_unlock(&log->no_space_stripes_lock);
> -
> -	r5l_wake_reclaim(log, reserve);
> -	goto out_unlock;
>  }
>=20=20
>  void r5l_write_stripe_run(struct r5l_log *log)
> @@ -559,6 +564,21 @@ static sector_t r5l_reclaimable_space(struct r5l_log=
 *log)
>  				 log->next_checkpoint);
>  }
>=20=20
> +static void r5l_run_no_mem_stripe(struct r5l_log *log)
> +{
> +	struct stripe_head *sh;
> +
> +	assert_spin_locked(&log->io_list_lock);
> +
> +	if (!list_empty(&log->no_mem_stripes)) {
> +		sh =3D list_first_entry(&log->no_mem_stripes,
> +				      struct stripe_head, log_list);
> +		list_del_init(&sh->log_list);
> +		set_bit(STRIPE_HANDLE, &sh->state);
> +		raid5_release_stripe(sh);
> +	}
> +}
> +
>  static bool r5l_complete_finished_ios(struct r5l_log *log)
>  {
>  	struct r5l_io_unit *io, *next;
> @@ -575,7 +595,8 @@ static bool r5l_complete_finished_ios(struct r5l_log =
*log)
>  		log->next_cp_seq =3D io->seq;
>=20=20
>  		list_del(&io->log_sibling);
> -		kmem_cache_free(log->io_kc, io);
> +		mempool_free(io, log->io_pool);
> +		r5l_run_no_mem_stripe(log);
>=20=20
>  		found =3D true;
>  	}
> @@ -1189,6 +1210,10 @@ int r5l_init_log(struct r5conf *conf, struct md_rd=
ev *rdev)
>  	if (!log->io_kc)
>  		goto io_kc;
>=20=20
> +	log->io_pool =3D mempool_create_slab_pool(R5L_POOL_SIZE, log->io_kc);
> +	if (!log->io_pool)
> +		goto io_pool;
> +
>  	log->bs =3D bioset_create(R5L_POOL_SIZE, 0);
>  	if (!log->bs)
>  		goto io_bs;
> @@ -1203,6 +1228,8 @@ int r5l_init_log(struct r5conf *conf, struct md_rde=
v *rdev)
>  		goto reclaim_thread;
>  	init_waitqueue_head(&log->iounit_wait);
>=20=20
> +	INIT_LIST_HEAD(&log->no_mem_stripes);
> +
>  	INIT_LIST_HEAD(&log->no_space_stripes);
>  	spin_lock_init(&log->no_space_stripes_lock);
>=20=20
> @@ -1219,6 +1246,8 @@ reclaim_thread:
>  out_mempool:
>  	bioset_free(log->bs);
>  io_bs:
> +	mempool_destroy(log->io_pool);
> +io_pool:
>  	kmem_cache_destroy(log->io_kc);
>  io_kc:
>  	kfree(log);

Yes, that looks just right - thanks.
I feel a lot more confident that this code won't deadlock.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWec61AAoJEDnsnt1WYoG57TYP/146HAiNtXezvqcl5i7P/qJg
VvwRrMfTuAQGChRCQI9E9JyoBPyyVI8NAJdsbYsqoZT2iIC41/lkDrHvQtExRUeu
9WqJqynFNAUGvZC7LqStRMhAXpG+2pjFQd1qRov2sea8Fvb34nenGDUU03IcMMmu
wyLpEkWHyIUDALBXmuj/ED2AUTotMa4ur8H7ySOnpKZC4o69HzQJaTTbDbB7oXzn
sFJFE6KJdNLrAVVcObNT1y2HgBg3B4tnlbG4p8WRmMq3kGxYMSBlBc2iA+UZqSZD
n1GU+84sp1jhL+3JfeIw2sJdxsUErcF3SKn9tnclVPNGRoxZR6wQQGPlpaZ2Zq3L
oZK6SDnVJBLPzSw/FZqcvUtL6iCiy/vrozc1JjBdSA641bq0JbItvVPBamyUs9VY
8M/t3wW3S3wQACXncoHw8ltRSryIP6KZsfZGpUAzx8i00mg2s/2F/ixs8vvAMJ68
oHfzuV+LYenQ6py6DvqzuIzp7CS8kQPU42awiXnsvxunGsgPNKmiVSIGexDraUhI
qwjcUq+TTlEmARQECQfioLVOVxxovYLQpoDc0fPFxi5xwH4x9H7yPvIreRocT7Ao
Dx/QKrrwFpStgU5ACCh2B3m77Bx5imGlmrXKZSwGmMkmOkF/wRIKnNYHQM+8XrTC
6XUE/hAwnEZA5MCC86U1
=msVI
-----END PGP SIGNATURE-----
--=-=-=--
