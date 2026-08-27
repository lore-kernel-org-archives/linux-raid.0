Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50593D9547
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 08:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787818541; cv=none; b=YoY2IlT8URtWAlMKvDIJA+jIGjHhGYlVy1CGLrV8xDqVy0j4NIWEs3ks902OPFpfccda0EoaRXjC9lnnlcIKFKcUfZC0x4x8IwG4OjRFAsUgiKMagn1D5/NPs1lBHCvayoX02sdbHIn0XJUb/BqQlHIn5tSH6pcocKNNqZMeuF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787818541; c=relaxed/simple;
	bh=28hzlqNjYwOcfBBYKB5Zp8Iac1rY2eXLd+V6Fo7I+vk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Dg/IC5ffBEtXoZ8pD3XOy9zhTlBz60MA46csAbZk9VGRctEA669zSbHZVMIEDLa/o75oLZi4zYECMGnYYBvTtMHLFiEUyIejANT/ofGWrWAQ+HOEhfieDQa7fFWZeB9wi/d2fu75XE6xCj1ICR8BhBIj8WDh4ja7GRUW1YFVg9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GT6FQusv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GT6FQusv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534041F000E9;
	Thu, 27 Aug 2026 08:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787818539;
	bh=+7KhzQBPi/7twttTIp6G3VxU46CZFdY3xlEfrj5N3V4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GT6FQusvyb6irXLuvHFmZDlfAuDcJC9lgmBm10yQAwr1yH+PAhQHudFtPri4akzT8
	 eJM64G1a7fV+KZizG0HJ1gyP4+XQ2YpOVYZJC99slOMIZaOGDSJql6SS+zt3m2ONNq
	 9JjBx0/YLgmvGoQhBKWPo8DajeKupQNQ/euKIPss9iaWpgj3ujLXm2HhFJUTpPozeg
	 vQMBfsfIr4Pius/s7nHaTe6+lpPqYfFT9SKISyvAcb3QOKGjilg3ZxZ+fir1GEs/6s
	 Z9YyrA96MSteIvzzFS4gNlfV/Ki99OcIoe2iDz0Am4pxrZr188oq6Mr+9010Z2wabf
	 kQLoa8sjaMmSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/3] md/raid1-10: add rdev_bb_block_sectors() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260827075620.3599227-3-dayou5941@163.com>
References: <20260827075620.3599227-1-dayou5941@163.com>
 <20260827075620.3599227-3-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 08:15:38 +0000
Message-Id: <20260827081539.534041F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Converting a data-less bio (e.g., REQ_OP_SECURE_ERASE) to REQ_OP_W=
RITE causes a NULL pointer dereference in error handling.
--

commit 7d28d3b35b9395eb9bc70edade7e6a8cd0c8563e
Author: Li Youhong <liyouhong@kylinos.cn>

md/raid1-10: add rdev_bb_block_sectors() helper

This commit factors out the badblocks-aligned block size computation
logic used in both RAID1 and RAID10 into a new inline helper function,
rdev_bb_block_sectors(). The refactoring simplifies narrow_write_error()
in both drivers.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 9d8441348f14a..8a40c69d70a37 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2465,16 +2465,11 @@ static void narrow_write_error(struct r1bio *r1_b=
io, int i)
>  	 * We currently own a reference on the rdev.
>  	 */
> =20
> -	int block_sectors, lbs =3D bdev_logical_block_size(rdev->bdev) >> 9;
> +	int block_sectors =3D rdev_bb_block_sectors(rdev);

[Severity: High]
This is a pre-existing issue, but while reviewing the refactoring in
narrow_write_error(), I noticed a potential problem further down in the
function.

If a dataless write operation such as REQ_OP_SECURE_ERASE is issued and fai=
ls
on an underlying drive, the error handling path clones the failing dataless
master bio (which lacks data buffers and has bi_io_vec =3D=3D NULL) and doe=
s the
following:

drivers/md/raid1.c:narrow_write_error() {
    ...
    wbio->bi_opf =3D REQ_OP_WRITE;
    wbio->bi_iter.bi_sector =3D r1_bio->sector;
    wbio->bi_iter.bi_size =3D r1_bio->sectors << 9;
    ...
}

By unconditionally setting REQ_OP_WRITE without providing a data vector, do=
es
this turn a dataless operation into an illegal write?

When this modified bio is trimmed or submitted to the block layer, the block
core and underlying drivers will treat it as a standard data-carrying write
and attempt to iterate over its missing data bvecs. Can this cause a NULL
pointer dereference and kernel panic?

The exact same buggy behavior also exists in raid10 error handling:

drivers/md/raid10.c:narrow_write_error() {
    ...
    wbio->bi_iter.bi_sector =3D wsector +
                              choose_data_offset(r10_bio, rdev);
    wbio->bi_opf =3D REQ_OP_WRITE;
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827075620.3599=
227-1-dayou5941@163.com?part=3D2
