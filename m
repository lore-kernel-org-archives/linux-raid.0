Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2793A4274
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 08:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787818768; cv=none; b=rcnhyJit3TImYOfXnK2Xtz8A3A8CggBhDumvpI5LeS/2dc0tSkIEtCmR5D1cktcWm55UvU2kI8umr7Eilf5mWGq4AFStpMhFWDtAr5hdBUQxNn0hlgqe/4XnNnGrfXvwzV1bNud3Jgl8Ce+pdJ+E5elN9KuSy7c1sRz9XSGRZeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787818768; c=relaxed/simple;
	bh=sMWeCefoiC8GI25+Yt+5Ak5vQ5yMFiSxIRoUdsQf4AA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TxfM3MTmTM24wofC/DUwRu+2Tf2Leq2datmGLA78sukQ/Jn4IuEKSCGMKsrnU0MHVFNFaJe71glFkaz86DJzHMKMAdnqvZrSupaYiW7ookNJJIUpIOihUbNwzJATgyhqKYg08YmR02JFVwi2X1d/eeFujYM20yjwAuKTZrtrn8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMHmzi8M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMHmzi8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2526A1F000E9;
	Thu, 27 Aug 2026 08:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787818767;
	bh=nVYfgNT2aOnW9xbe+gOQeHiNHtSdo9cZxE9CYwRi0hU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GMHmzi8MBFYMoNeb0LuYLjFbThDveHrj2HuoPFxWyaf/6PFumAHrG8uY2MTIuTQ7g
	 HYw1Pb1lt4gbOfV59ah2f/AMjeq9GZ+zg0/l0Qpx9mP6YNLoP+2rn+aHuXhOOqOTcs
	 F6vogI6OlB9yimAcIB54LQGWTjQOSzatv1jIyQ9DSG4uuh1cGbr+zqi125JnMF54hG
	 Qdif/imYzDk655SFgB/Hj01nVCIw1kEaqrwENPNWX+QQQYIAzeXuOvJQUZe7cNkJcn
	 ssTOMr6LmVR2a60Yucqi+qw2CCkpydLv2R65Ypa76RJsYPpKzp/9xd+XW7jFzmWj29
	 z36ieLgEWeIiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/2] md/raid5: track disks array size to fix
 extra_page leak on error paths
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827080341.112296-1-ghuicao@163.com>
References: <20260827063235.85375-1-ghuicao@163.com>
 <20260827080341.112296-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 08:19:26 +0000
Message-Id: <20260827081927.2526A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Retrying `resize_stripes()` after a partial failure leaks `extra_p=
age` allocations from the previous attempt.
- [High] `resize_stripes()` leaks `stripe_head` pages if Step 4 fails (on a=
rchitectures where PAGE_SIZE =3D=3D DEFAULT_STRIPE_SIZE).
- [High] Use-After-Free race condition on `conf->disks` array between `raid=
5_status()` and `resize_stripes()`
--

commit c7f0ab9943c7136150bf0d1225ef069780dedbe5
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md/raid5: track disks array size to fix extra_page leak on error paths

This commit introduces disks_cnt to struct r5conf to track the actual number
of entries in conf->disks and uses it in free_conf() to fix memory leaks
when pool_size doesn't match the actual allocated array size.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090de..e5838bf516e38 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2642,6 +2642,7 @@ static int resize_stripes(struct r5conf *conf, int =
newsize)
>  		} else {
>  			kfree(conf->disks);

[Severity: High]
This is a pre-existing issue, but can freeing the disks array directly here=
=20
cause a use-after-free race with raid5_status()?

raid5_status() runs with only mddev->lock held and iterates over
conf->disks[i].rdev:

drivers/md/raid5.c:raid5_status() {
    ...
    struct md_rdev *rdev =3D READ_ONCE(conf->disks[i].rdev);
    ...
}

Would calling kfree() here (without kfree_rcu or synchronize_rcu) allow the
array to be freed while raid5_status() is actively reading from it?

[Severity: High]
This is also a pre-existing issue, but will this kfree() leak the=20
extra_page allocations on retry if a previous reshape failed in Step 4?

If resize_stripes() succeeds in Step 3 (updating conf->disks) but fails
in Step 4, conf->pool_size is not updated. On a retry, the earlier copy
loop only copies elements up to the outdated conf->pool_size:

drivers/md/raid5.c:resize_stripes() {
    ...
    for (i =3D 0; i < conf->pool_size; i++)
        ndisks[i] =3D conf->disks[i];
    ...
}

Will this cause the extra_page allocations at indices >=3D pool_size from
the previous attempt to be permanently abandoned and leaked when this
kfree(conf->disks) is called?

>  			conf->disks =3D ndisks;
> +			conf->disks_cnt =3D newsize;

[Severity: High]
This isn't a bug introduced by this patch, but could resize_stripes()
leak stripe_head pages if a failure happens later in Step 4?

In Step 4, pages are allocated for the new stripe size:

drivers/md/raid5.c:resize_stripes() {
    ...
    for (i =3D conf->raid_disks; i < newsize; i++)
        if (nsh->dev[i].page =3D=3D NULL) {
            struct page *p =3D alloc_page(GFP_NOIO);
            nsh->dev[i].page =3D p;
    ...
}

If an allocation fails, err =3D -ENOMEM is set, but the loop continues and
previously allocated pages remain attached. Because err is set,
conf->pool_size is never updated.

Later, shrink_buffers() bounds itself strictly to pool_size:

drivers/md/raid5.c:shrink_buffers() {
    ...
    int num =3D sh->raid_conf->pool_size;
   =20
    #if PAGE_SIZE =3D=3D DEFAULT_STRIPE_SIZE
    for (i =3D 0; i < num ; i++) {
    ...
}

Will this unconditionally leak all orphaned pages residing at higher
indices (>=3D pool_size) when the stripe_head structures are dropped?

>  		}
>  	} else
>  		err =3D -ENOMEM;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827063235.8537=
5-1-ghuicao@163.com?part=3D1
