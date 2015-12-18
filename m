From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] raid5: allow r5l_io_unit allocations to fail
Date: Fri, 18 Dec 2015 12:51:07 +1100
Message-ID: <874mfg8qyc.fsf@notabene.neil.brown.name>
References: <1450390197-19479-1-git-send-email-hch@lst.de> <1450390197-19479-4-git-send-email-hch@lst.de> <20151217234748.GA1860175@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151217234748.GA1860175@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 18 2015, Shaohua Li wrote:

> On Thu, Dec 17, 2015 at 11:09:57PM +0100, Christoph Hellwig wrote:
>> And propagate the error up the stack so we can add the stripe
>> to no_stripes_list and retry our log operation later.  This avoids
>> blocking raid5d due to reclaim, an it allows to get rid of the
>> deadlock-prone GFP_NOFAIL allocation.
>>=20
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  drivers/md/raid5-cache.c | 49 +++++++++++++++++++++++++++++++++--------=
-------
>>  1 file changed, 34 insertions(+), 15 deletions(-)
>>=20
>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> index e0a605f..ddee884 100644
>> --- a/drivers/md/raid5-cache.c
>> +++ b/drivers/md/raid5-cache.c
>> @@ -287,8 +287,10 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_=
log *log)
>>  	struct r5l_io_unit *io;
>>  	struct r5l_meta_block *block;
>>=20=20
>> -	/* We can't handle memory allocate failure so far */
>> -	io =3D kmem_cache_zalloc(log->io_kc, GFP_NOIO | __GFP_NOFAIL);
>> +	io =3D kmem_cache_zalloc(log->io_kc, GFP_ATOMIC);
>> +	if (!io)
>> +		return NULL;
>> +
>>  	io->log =3D log;
>>  	INIT_LIST_HEAD(&io->log_sibling);
>>  	INIT_LIST_HEAD(&io->stripe_list);
>> @@ -326,8 +328,12 @@ static int r5l_get_meta(struct r5l_log *log, unsign=
ed int payload_size)
>>  	    log->current_io->meta_offset + payload_size > PAGE_SIZE)
>>  		r5l_submit_current_io(log);
>>=20=20
>> -	if (!log->current_io)
>> +	if (!log->current_io) {
>>  		log->current_io =3D r5l_new_meta(log);
>> +		if (!log->current_io)
>> +			return -ENOMEM;
>> +	}
>> +
>>  	return 0;
>>  }
>>=20=20
>> @@ -372,11 +378,12 @@ static void r5l_append_payload_page(struct r5l_log=
 *log, struct page *page)
>>  	r5_reserve_log_entry(log, io);
>>  }
>>=20=20
>> -static void r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
>> +static int r5l_log_stripe(struct r5l_log *log, struct stripe_head *sh,
>>  			   int data_pages, int parity_pages)
>>  {
>>  	int i;
>>  	int meta_size;
>> +	int ret;
>>  	struct r5l_io_unit *io;
>>=20=20
>>  	meta_size =3D
>> @@ -385,7 +392,10 @@ static void r5l_log_stripe(struct r5l_log *log, str=
uct stripe_head *sh,
>>  		sizeof(struct r5l_payload_data_parity) +
>>  		sizeof(__le32) * parity_pages;
>>=20=20
>> -	r5l_get_meta(log, meta_size);
>> +	ret =3D r5l_get_meta(log, meta_size);
>> +	if (ret)
>> +		return ret;
>> +
>>  	io =3D log->current_io;
>>=20=20
>>  	for (i =3D 0; i < sh->disks; i++) {
>> @@ -415,6 +425,8 @@ static void r5l_log_stripe(struct r5l_log *log, stru=
ct stripe_head *sh,
>>  	list_add_tail(&sh->log_list, &io->stripe_list);
>>  	atomic_inc(&io->pending_stripe);
>>  	sh->log_io =3D io;
>> +
>> +	return 0;
>>  }
>>=20=20
>>  static void r5l_wake_reclaim(struct r5l_log *log, sector_t space);
>> @@ -429,6 +441,7 @@ int r5l_write_stripe(struct r5l_log *log, struct str=
ipe_head *sh)
>>  	int meta_size;
>>  	int reserve;
>>  	int i;
>> +	int ret =3D 0;
>>=20=20
>>  	if (!log)
>>  		return -EAGAIN;
>> @@ -477,18 +490,24 @@ int r5l_write_stripe(struct r5l_log *log, struct s=
tripe_head *sh)
>>  	mutex_lock(&log->io_mutex);
>>  	/* meta + data */
>>  	reserve =3D (1 + write_disks) << (PAGE_SHIFT - 9);
>> -	if (r5l_has_free_space(log, reserve))
>> -		r5l_log_stripe(log, sh, data_pages, parity_pages);
>> -	else {
>> -		spin_lock(&log->no_space_stripes_lock);
>> -		list_add_tail(&sh->log_list, &log->no_space_stripes);
>> -		spin_unlock(&log->no_space_stripes_lock);
>> -
>> -		r5l_wake_reclaim(log, reserve);
>> -	}
>> -	mutex_unlock(&log->io_mutex);
>> +	if (!r5l_has_free_space(log, reserve))
>> +		goto err_retry;
>>=20=20
>> +	ret =3D r5l_log_stripe(log, sh, data_pages, parity_pages);
>> +	if (ret)
>> +		goto err_retry;
>> +
>> +out_unlock:
>> +	mutex_unlock(&log->io_mutex);
>>  	return 0;
>> +
>> +err_retry:
>> +	spin_lock(&log->no_space_stripes_lock);
>> +	list_add_tail(&sh->log_list, &log->no_space_stripes);
>> +	spin_unlock(&log->no_space_stripes_lock);
>> +
>> +	r5l_wake_reclaim(log, reserve);
>> +	goto out_unlock;
>>  }
>
> if the reclaim thread doesn't have anything to reclaim,
> r5l_run_no_space_stripes isn't called. we might miss the retry.

so something like this:
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 18de1fc4a75b..b63878edf7e9 100644
=2D-- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -596,7 +596,8 @@ static void __r5l_stripe_write_finished(struct r5l_io_u=
nit *io)
 		return;
 	}
=20
=2D	if (r5l_reclaimable_space(log) > log->max_free_space)
+	if (r5l_reclaimable_space(log) > log->max_free_space ||
+	    !list_empty(&log->no_space_stripes))
 		r5l_wake_reclaim(log, 0);
=20
 	spin_unlock_irqrestore(&log->io_list_lock, flags);

or is that too simplistic?

>
> I'm a little worrying about the GFP_ATOMIC allocation. In the first try,
> GFP_NOWAIT is better. And on the other hand, why sleep is bad here? We
> could use GFP_NOIO | __GFP_NORETRY, there is no deadlock risk.
>
> In the retry, GFP_NOIO looks better. No deadlock too, since it's not
> called from raid5d (maybe we shouldn't call from reclaim thread if using
> GFP_NOIO, a workqueue is better). Otherwise we could keep retring but do
> nothing.

I did wonder a little bit about that.
GFP_ATOMIC is (__GFP_HIGH)
GFP_NOIO | __GFP_NORETRY is  (__GFP_WAIT | __GFP_NORETRY)

It isn't clear that we need 'HIGH', and WAIT with NORETRY should be OK.
It allows __alloc_pages_direct_reclaim, but only once and never waits
for other IO.

We probably should add __GFP_NOWARN too because we expect occasional
failure.

So

=2D-- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -287,7 +287,7 @@ static struct r5l_io_unit *r5l_new_meta(struct r5l_log =
*log)
 	struct r5l_io_unit *io;
 	struct r5l_meta_block *block;
=20
=2D	io =3D kmem_cache_zalloc(log->io_kc, GFP_ATOMIC);
+	io =3D kmem_cache_zalloc(log->io_kc, GFP_NOIO | __GFP_NORETRY | __GFP_NOW=
ARN);
 	if (!io)
 		return NULL;
=20


Thoughts?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWc2aLAAoJEDnsnt1WYoG5+mYP/Rc0LJ3yNjsRoc5iSbtias90
FBsL/eSBrXnr1a4wDuSSz3LPMDMX0/MUzMxi85jJCRUAdWrT6HWFR66+kZndDce1
dxt/9Es/8cQoD4wY/rlmAWlbvhqN5iFHq6NvWW44Au9CYnVH3MA/JV41LpfaMuZz
BwCe/EcqChjAOVHEsauQA15+AZ2DQay6iySZNHt6P7Y3VRMqcwW0iwm1if45v43N
b2+kfsjmokOG+t+39owxnzXNt0lpTu/QF45SY/Xw274a+yQ77NiGKckwwmKT6Iu2
p8sJqy5Bcu0b2DX5xwwfMOhqq5JSz74nf95KvbdyRwkkVku1CYicnUIrqiMOhV96
/6SgUPSzRMrAiAgQFvcNfud3CbVA+k9MioqWdoL7Phl8DCt95ogauxaVSF4GMcwL
y0xD5ovsRBNVicfWb1ED/5Ct7Xd4mcflutr8yXCBhV/frUI5gBnBPH3MGErlKp0u
f9PdYLD+Cj3ZnCdqK9LhujCmpqjVzM7XT7a3zr01DGOwV/yF5g2/k1DWIWi0omMZ
uRVfWkOqwXRaU4B5jy3+ypanOGF2SFY28+uaUw9TAtTyncZgxdaMPByNzWgmSB07
FuzzREpvsQPmTBO0kW5Xi7RySeQHbfNUF1okGOJLidFbR3srrYQ0XZwg/Fvz0h7m
wED6jyy5wz/25ffdC0ER
=bRSh
-----END PGP SIGNATURE-----
--=-=-=--
