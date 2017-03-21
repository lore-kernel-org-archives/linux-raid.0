From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v5 3/7] raid5-ppl: Partial Parity Log write logging implementation
Date: Wed, 22 Mar 2017 09:00:47 +1100
Message-ID: <87wpbib88g.fsf@notabene.neil.brown.name>
References: <20170309090003.13298-1-artur.paszkiewicz@intel.com> <20170309090003.13298-4-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170309090003.13298-4-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@fb.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Thu, Mar 09 2017, Artur Paszkiewicz wrote:

> Implement the calculation of partial parity for a stripe and PPL write
> logging functionality. The description of PPL is added to the
> documentation. More details can be found in the comments in raid5-ppl.c.
>
> Attach a page for holding the partial parity data to stripe_head.
> Allocate it only if mddev has the MD_HAS_PPL flag set.
>
> Partial parity is the xor of not modified data chunks of a stripe and is
> calculated as follows:
>
> - reconstruct-write case:
>   xor data from all not updated disks in a stripe
>
> - read-modify-write case:
>   xor old data and parity from all updated disks in a stripe
>
> Implement it using the async_tx API and integrate into raid_run_ops().
> It must be called when we still have access to old data, so do it when
> STRIPE_OP_BIODRAIN is set, but before ops_run_prexor5(). The result is
> stored into sh->ppl_page.
>
> Partial parity is not meaningful for full stripe write and is not stored
> in the log or used for recovery, so don't attempt to calculate it when
> stripe has STRIPE_FULL_WRITE.
>
> Put the PPL metadata structures to md_p.h because userspace tools
> (mdadm) will also need to read/write PPL.
>
> Warn about using PPL with enabled disk volatile write-back cache for
> now. It can be removed once disk cache flushing before writing PPL is
> implemented.
>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Sorry for the delay in getting to this for review...

> +static struct ppl_io_unit *ppl_new_iounit(struct ppl_log *log,
> +					  struct stripe_head *sh)
> +{
> +	struct ppl_conf *ppl_conf = log->ppl_conf;
> +	struct ppl_io_unit *io;
> +	struct ppl_header *pplhdr;
> +
> +	io = mempool_alloc(ppl_conf->io_pool, GFP_ATOMIC);
> +	if (!io)
> +		return NULL;
> +
> +	memset(io, 0, sizeof(*io));
> +	io->log = log;
> +	INIT_LIST_HEAD(&io->log_sibling);
> +	INIT_LIST_HEAD(&io->stripe_list);
> +	atomic_set(&io->pending_stripes, 0);
> +	bio_init(&io->bio, io->biovec, PPL_IO_INLINE_BVECS);
> +
> +	io->header_page = mempool_alloc(ppl_conf->meta_pool, GFP_NOIO);

I'm trying to understand how these two mempool_alloc()s relate, and
particularly why the first one needs to be GFP_ATOMIC, while the second
one can safely be GFP_NOIO.
I see that the allocated memory is freed in different places:
header_page is called from the bi_endio function as soon as the write
completes, while 'io' is freed later.  But I'm not sure that is enough
to make it safe.

When working with mempools, you need to assume that the pool only
contains one element, and that every time you call mempool_alloc(), it
waits for that one element to be available.  While that doesn't usually
happen, it is possible and if that case isn't handled correctly, the
system can deadlock.

If no memory is available when this mempool_alloc() is called, it will
block.  As it is called from the raid5d thread, the whole array will
block.  So this can only complete safely is the write request has
already been submitted - or if there is some other workqueue which
submit requests after a timeout or similar.
I don't see that in the code.  These ppl_io_unit structures can queue up
and are only submitted later by raid5d (I think).  So if raid5d waits
for one to become free, it will wait forever.

One easy way around this problem (assuming my understanding is correct)
is to just have a single mempool which allocates both a struct
ppl_io_unit and a page.  You would need to define you own alloc/free
routines for the pool but that is easy enough.

Then you only need a single mempool_alloc(), which can sensibly be
GFP_ATOMIC.
If that fails, you queue for later handling as you do now.  If it
succeeds, then you continue to use the memory without any risk of
deadlocking.

Thanks,
NeilBrown


> +	pplhdr = page_address(io->header_page);
> +	clear_page(pplhdr);
> +	memset(pplhdr->reserved, 0xff, PPL_HDR_RESERVED);
> +	pplhdr->signature = cpu_to_le32(ppl_conf->signature);
> +
> +	io->seq = atomic64_add_return(1, &ppl_conf->seq);
> +	pplhdr->generation = cpu_to_le64(io->seq);
> +
> +	return io;
> +}

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljRoo8ACgkQOeye3VZi
gbkumhAArzgx2gA4JCalc1GNKBPexkBgGkG11pWfCM6BysmSEbyEf5JgRyaGttiF
D2L0ZmSkF7XewAABIapJiFwq4fddTb14pOfPQbClxMaxESjnyn8/gFBauvarEH3L
6zFiNQx1SGnioHlF+KcqlLZ3kGE9f3pSJl2OA2Rfx/ca7usHKI5c64tGUMg1rKEB
NEKFe6BjpC9jBTHvxeswO5Vn1CxYe0mrCJPl6SdNqGtOrVxViuZVkXospXxBE1d2
O1euC+YscRQ/WoSFHPXQE3obWw8SNKPr5Y2ocmWG5ePEnvq0PHsRgCeJhnUSEtzI
0nKkIBurgG1LjixcaBMnixnKiX+5SujZAVvq9rDEwL9r9YnBhlqAAh6hAr+uRgm+
grWZ9JxaqIF7F1MJI2uNubFoIa1qYFbIe+26vyDk0KHjPtcXdkydQ8jsnKfEdSgd
Li+RcaW28PO23sHIPNBIJ3w5VqHagXTGcY77j+AaGUVNA56sA2DuB3vorOShqr1y
mU0Y/ak6hY/JfLLTUDqdwHehBq8gC81QadnWBMeT6QLS5JBzcDqdqBSFUIa8Mx+c
tWKX2sE9dvlC1AULLJysCaOUyz6muYJ/VJObBfrmBoEF2qO7W3U3gvWNjqnUADP4
LaEJHwhO2YsBdSJ1O5l4+F1Hi545xOu2XAYLQQiv4XYKP40PwjI=
=rJnX
-----END PGP SIGNATURE-----
--=-=-=--
