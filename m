Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE15264FBD;
	Sat, 18 Jul 2026 17:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784394433; cv=none; b=tss7ff+pU5Twtqhfp6+PhAcG6yx7QZcrotzkwk/TRrsx6Dggkm7KXwlBmZqwd1EEtAEhkMbEX25Yegp1RdrV30vOz4MVC3Po5xYNbJrUlDBvTTiLQQgpmzoEs3buhUgPqRy2GU+/+MI08pnFYgEdxln9ybxQoZfdQA5wFoFzHYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784394433; c=relaxed/simple;
	bh=rwZt302m5NalWqeFFw+5ooBF/pCuJO43fQ1Vo1qprVk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XS+tfgEJbUYJzrxpWJMxqG8LvHS+1SmEpgICn08L+I4G0ksk37tUbhoEjmeqg/x4dT19fFP4iLDTvUq3c6bud+NhGDqdHWtLvF/9acuUFk85njgP1O0aD2qZCQw12nE9EYGISWhXsqKcENKLu6ZJUNB4kcv0Pnv19rhg0Y02ZtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y9Y7bzDd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y9Y7bzDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B44C1F000E9;
	Sat, 18 Jul 2026 17:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784394431;
	bh=kaPR9lqOhelgtq+iVBmtU6IvV3qww30nI79kBYxXaiU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y9Y7bzDdJ5Kof6lMn8ekGeBf+pmLPYrGZKEmNOtKbNvrOJOSaQ65/fEBfr6YWDCFW
	 eFMUP75xdHlyJeFUzvrlnIP/ztJ6PlJwmY5Ezok+bvIM3QVVY36M9XTP848ZTtuAeL
	 hiQnf+mbr0TG1TxMrNNr4HjekW8+8XkPbmaLH7Cnr5byYMxTFMi9/R8QFCsVZ/9TCu
	 oJQ/TjZ31Z2XwIYBEftAbqLfMxja5P5ptbVwcv9jzL/E4rdmqbUC0ua3S3+KC25TNC
	 E7qE0/imOs5dRue8eAg9rXesaWNHgV+cAikAMADyO9at6uqO5F3L2UNrkexhQO8ppp
	 KafdTm5klZWag==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/6] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260718162547.448892-6-mykola@meshstor.io>
References: <20260718162547.448892-1-mykola@meshstor.io>
 <20260718162547.448892-6-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Jul 2026 17:07:11 +0000
Message-Id: <20260718170711.5B44C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] `md_bio_p2pdma_mapping_error()` accesses `bio->bi_io_vec->bv_page`=
 without a valid operation type guard, leading to a wild pointer dereferenc=
e on data-less bios.
--

--- Patch [5]: [PATCH 5/6] md/raid1,raid10: skip futile retries on P2PDMA m=
apping failures ---
commit 56153d6522aaf7c00c17b02d6bbccf2b3fb20978
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: skip futile retries on P2PDMA mapping failures
   =20
This patch modifies raid1 and raid10 to explicitly handle P2PDMA mapping
failures (BLK_STS_TARGET). It avoids excessive per-block retries and
prevents healthy members from being evicted when peer memory cannot be
DMA-mapped.

> diff --git a/drivers/md/md.h b/drivers/md/md.h
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -40,6 +40,19 @@ static inline bool md_bio_is_p2pdma(struct bio *bio)
>  	       is_pci_p2pdma_page(bio->bi_io_vec->bv_page);
>  }
> =20
> +/*
> + * True when a leg bio failed because its P2PDMA pages cannot be DMA-map=
ped
> + * to this member (BLK_STS_TARGET from blk_dma_map_iter_start()). Usable=
 at
> + * completion time, unlike md_bio_is_p2pdma(): leg bios are clones shari=
ng
> + * the master bio's bvec table, which outlives the leg's end_io, but the=
ir
> + * iterator is consumed by then, so bio_has_data() cannot gate the acces=
s.
> + */
> +static inline bool md_bio_p2pdma_mapping_error(struct bio *bio)
> +{
> +	return bio->bi_status =3D=3D BLK_STS_TARGET && bio->bi_io_vec &&
> +	       is_pci_p2pdma_page(bio->bi_io_vec->bv_page);
> +}

[Severity: High]
Can this result in a wild pointer dereference for data-less bios?

Data-less bios (like REQ_OP_FLUSH) can legally be allocated with nr_vecs > =
0,
such as when they are reused via bio_reset(). For these bios, bio->bi_io_vec
might be non-NULL while bv_page remains uninitialized.

If such a bio fails with BLK_STS_TARGET (for example, from an NVMe drive
returning NVME_SC_NS_NOT_READY), is it safe to access bv_page here and pass
it to is_pci_p2pdma_page() without a bio_has_data() guard?

[ ... ]

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2629,7 +2640,20 @@ static void handle_write_finished(struct r1conf *c=
onf, struct r1bio *r1_bio)
>  			 * errors.
>  			 */
>  			fail =3D true;
> -			narrow_write_error(r1_bio, m);
> +			if (md_bio_p2pdma_mapping_error(r1_bio->bios[m]))

[Severity: High]
Will this error path unconditionally pass failed cloned bios, including
data-less ones like REQ_OP_FLUSH, to the mapping check above?

> +				/*
> +				 * A P2PDMA mapping failure fails the whole
> +				 * range identically, so narrowing block by

[ ... ]

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2948,7 +2971,23 @@ static void handle_write_completed(struct r10conf =
*conf, struct r10bio *r10_bio)
>  				rdev_dec_pending(rdev, conf->mddev);
>  			} else if (bio !=3D NULL && bio->bi_status) {
>  				fail =3D true;
> -				narrow_write_error(r10_bio, m);
> +				if (md_bio_p2pdma_mapping_error(bio))

[Severity: High]
Similarly, does this RAID10 error path pass failed bios to the mapping
check without verifying if the operation actually carries data?

> +					/*
> +					 * A P2PDMA mapping failure fails
> +					 * the whole range identically, so
> +					 * narrowing block by block cannot

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260718162547.4488=
92-1-mykola@meshstor.io?part=3D5
