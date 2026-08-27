Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21545284693
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 06:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787812073; cv=none; b=GtDiGXhLJslubdblQeUSqubFNxrXIvy1dbDWM3oQEtqdawLbAKLTfFiJZOKyqovsV0HKSQiUoJtmdqR2iD3eiEZ/hwqPrlLcW3iYytobO83BOtgbvgllMyB23s2/l2RM9GcrD41rCr3EF7jMHKUkawNke6ilHGyOd86qzBxNFZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787812073; c=relaxed/simple;
	bh=dECjvrAYr9ymtQagnzjpWy3GasGtEnJLGzMs95azIqU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CZl1x8nOAKshSwrHdbd78kEnOLHkb9nhW0vFYQt4eDjxN3iyktqrN8+ONt1MmneL/JyAyBpRgfdmQ3hBI417t27YtqUzjBkHTMabl1N/xTCZ+BPqTwvS4E0SMulEXsUYct/u0hlbNSlMNhdrMNY406AqLDT6VAobW052Wpdcc04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y89lE1Ld; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y89lE1Ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768881F000E9;
	Thu, 27 Aug 2026 06:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787812071;
	bh=LbRShek3uIID8dMQ4+IxzXJrUU2qhdxn53NdLtTywYg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y89lE1Ld8bQSqSxksb85LLcuF7oZXvY2L1qC+xQv4JV/MVL+MFyF1iKiDe5E/Xok/
	 uSlkL23hQ4aMkgejN2X/NPwXCIsxF6Ko78bD+RKZTcreGEfN/Ezm44SKGy0Pak1A0H
	 oM8Y8oUwofoZ0l0SLVvIU+AXSMNKgOBzdkYK+LUjUojzQ9EoDSSFmRXRId70HE2JNX
	 VxcQFFkb2DleDfkNHa8Ve309TGD1iWQDVPJuO+WVnNEwQoZIC5dm3nBq0Pd61KpCT4
	 w5u50WAgUBnl3oporatQesGBfPvTjKZO36or5bHvkS4T+MluajNO8fghs0Z5S8Dvbe
	 YT2rewUpPsDng==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] md/raid5: fix leak and use-after-free in
 resize_stripes error path
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827060554.77849-2-ghuicao@163.com>
References: <20260827023803.36602-1-ghuicao@163.com>
 <20260827060554.77849-1-ghuicao@163.com>
 <20260827060554.77849-2-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 06:27:51 +0000
Message-Id: <20260827062751.768881F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Concurrent lockless read of `conf->disks` in IO and error path=
s races with synchronous `kfree(old_disks)`.
- [High] Memory leak of `stripe_head` pages (`nsh->dev[i].page`) when Step =
4 of `resize_stripes()` fails.
--

commit 42a858726c79b14d53c892c406bd10d16e4932f8
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md/raid5: fix leak and use-after-free in resize_stripes error path

This commit attempts to fix a memory leak and a use-after-free issue
in the resize_stripes error path. It defers the conf->disks replacement
and performs it under mddev->lock to prevent concurrent reads in
raid5_status from seeing a freed array.

Cc: stable@vger.kernel.org

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 4efaef622fc05..e481c48b45093 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c

[ ... ]

> @@ -2685,8 +2683,20 @@ static int resize_stripes(struct r5conf *conf, int=
 newsize)
>  	}
>  	/* critical section pass, GFP_NOIO no longer needed */
> =20
> -	if (!err)
> +	if (!err && ndisks) {
> +		struct disk_info *old_disks =3D conf->disks;
> +
> +		spin_lock_irq(&conf->mddev->lock);
> +		conf->disks =3D ndisks;
> +		spin_unlock_irq(&conf->mddev->lock);
> +		kfree(old_disks);

[Severity: Critical]
This is a pre-existing issue, but the patch's attempt to fix the conf->disks
use-after-free is incomplete and leaves critical race windows open. This
kfree() is synchronous and doesn't wait for an RCU grace period.

Because check_reshape() invokes resize_stripes() before reshape_position is
updated, chunk_aligned_read is still enabled. Does this allow
raid5_read_one_chunk() to run concurrently and read the freed conf->disks
array completely locklessly?

drivers/md/raid5.c:raid5_read_one_chunk() {
    ...
    rdev =3D conf->disks[dd_idx].replacement;
    if (!rdev || test_bit(Faulty, &rdev->flags) ||
        READ_ONCE(rdev->recovery_offset) < end_sector) {
        rdev =3D conf->disks[dd_idx].rdev;
    ...
}

Additionally, raid5_calc_degraded() iterates over conf->disks holding only
rcu_read_lock(). Will this synchronous kfree() cause a use-after-free for
those RCU readers as well?

drivers/md/raid5.c:raid5_calc_degraded() {
    ...
    struct md_rdev *rdev =3D READ_ONCE(conf->disks[i].rdev);
    ...
}

>  		conf->pool_size =3D newsize;
> +	} else if (ndisks) {

[Severity: High]
This isn't a bug introduced by this patch, but the patch attempts to fix
leaks in this error path and structurally misses this one. When Step 4 of
resize_stripes() fails to allocate a page for the new stripe slots
(nsh->dev[i].page), err is set to -ENOMEM and the pool_size update is
skipped here.

During array teardown, shrink_buffers() iterates only up to
sh->raid_conf->pool_size:

drivers/md/raid5.c:shrink_buffers() {
    ...
    int num =3D sh->raid_conf->pool_size;

#if PAGE_SIZE =3D=3D DEFAULT_STRIPE_SIZE
    for (i =3D 0; i < num ; i++) {
    ...
}

Are the successfully allocated pages at indices >=3D pool_size permanently
leaked when free_stripe() destroys the slab object, because the cleanup loop
misses them?

> +		for (i =3D conf->pool_size; i < newsize; i++)
> +			if (ndisks[i].extra_page)
> +				put_page(ndisks[i].extra_page);
> +		kfree(ndisks);
> +	}
>  	mutex_unlock(&conf->cache_size_mutex);
> =20
>  	return err;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827060554.7784=
9-1-ghuicao@163.com?part=3D2
