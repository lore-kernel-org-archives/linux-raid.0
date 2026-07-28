Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B56C41D117
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230557; cv=none; b=Xj5uDyoaH8Xt/i9S5kHfBQbd86SEpea8yc8OfqncE7PMK3VK23zw6iWtzZCCu/vkL/Q0hzWK8JpnkkISjz8IYjawcTtca1P6eIHj7AL4NoJ6VK/XdQFeXVRCVsUw1NbHjVtHFHTlbY6P/CR2hoHQ3K8Dpwtlqxqk5Waxkez68lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230557; c=relaxed/simple;
	bh=1BA6QTxW0UT/C8FZGacEcLgMzrTnZajHjxkgm1USWiM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MkNeO+fd6WX6/5uqhGcIK5UJX1puPv1FcuIvvsqUrSceKb6bTLTRSOWEhvUf24UQozJodRiVhBJ4kWSHfvp2+Zv5MFuwvZsXtm7/Omhdu4Y2HvM0awxsnvP0ZL1026fcA+bTpL3AiL9a6o0lId6dIgLe9XXWNklikgyTbG7EbYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XjfRNHTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XjfRNHTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7841F000E9;
	Tue, 28 Jul 2026 09:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785230555;
	bh=9Hq2xYFDF33dN9ctnCjpu3zX65LFHcbBYHQPGcdQwEo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XjfRNHTWd2Z3T3KyMG9Zz0zmKQYN1IM1h0zyZsHvxWayPvs66aSxIYu6mbfb2STnM
	 ZG6lShlchCYhLP5W83q3KJhOKwhFogTXI6P3J4DHNgtltxKqDVgKH0FIlPjrrjUJtp
	 ZbS/9sltE2onH5eVouHcH8h0IcA/5gRfEOtKRFUExJwpyJwzlXtXv2XssQ5bMiefSj
	 cA9mvE/w/z1YT4/QbTqd5los5PBb4Q+wHrop6XN+lSluNAt9niyGeIc5dBZiC1dZjC
	 9zJFY/dxbblBtPH454+zjOlM3Ji+qpu027beXBAwERXJdel8+uJx4JGHssJEzihOHc
	 SMAapOP3cIH/Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 19/21] md/raid5: reject llbitmap reshape when md
 chunk shrinks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <649ae8376b9960aff1567265162c132fd80df566.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <649ae8376b9960aff1567265162c132fd80df566.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:22:35 +0000
Message-Id: <20260728092235.9B7841F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Writing a value less than 512 to the `chunk_size` sysfs attribute =
bypasses chunk validation and causes a divide-by-zero kernel panic during r=
eshape.
--

--- Patch [19]: [PATCH v3 19/21] md/raid5: reject llbitmap reshape when md =
chunk shrinks ---
commit fd741104c871960b0c928c6a03adfc7d3df39d70
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: reject llbitmap reshape when md chunk shrinks
   =20
This commit prevents llbitmap reshapes from shrinking the chunk size,
as doing so cannot safely make an existing bitmap bit cover a smaller
data range.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8b28afa538e2b..f0817599dd271 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8509,6 +8509,9 @@ static int check_reshape(struct mddev *mddev)
>  	if (!check_stripe_cache(mddev))
>  		return -ENOSPC;
> =20
> +	if (mddev->bitmap_id =3D=3D ID_LLBITMAP &&
> +	    mddev->new_chunk_sectors < mddev->chunk_sectors)
> +		return -EOPNOTSUPP;

[Severity: High]
This is a pre-existing issue, but since we are looking at new_chunk_sectors
validation, what prevents a user from triggering a divide-by-zero panic by
writing a value smaller than 512 bytes to the chunk_size sysfs attribute?

In chunk_size_store(), user input less than 512 bytes is converted to
0 sectors before calling into the reshape checks:

drivers/md/md.c:chunk_size_store() {
    ...
    mddev->new_chunk_sectors =3D n >> 9;
    err =3D mddev->pers->check_reshape(mddev);
    ...
}

The downstream chunk validation logic skips the chunk check if the value
is zero:

    if (new_chunk > 0) {
        if (!is_power_of_2(new_chunk))
            return -EINVAL;
    }

If a user has no llbitmap configured, this 0 sector value appears to bypass
validation. If conf->chunk_sectors is updated to 0, will subsequent I/O or
reshape operations that divide by conf->chunk_sectors (such as
raid5_bitmap_sector_map() or raid5_bio_lowest_chunk_sector()) trigger a
divide-by-zero panic?

>  	if (mddev->new_chunk_sectors > mddev->chunk_sectors ||
>  	    mddev->delta_disks > 0)
>  		if (resize_chunks(conf,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D19
