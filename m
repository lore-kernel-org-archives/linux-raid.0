Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD14362153
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 07:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787814159; cv=none; b=tXWlF+7xSJ4CH/2uvL1KAvjt+6cqbhbwNXo6VKerOS8ttq4iglRbAS7UKQ4gNIlSMCh/ntuK9RbEogqITnM1YcR1HElGMqm19+oEFAXhkR+rqtoLrVf31BYROvZGt8bfdViYgKDXheghpmsVKL3jwIi/MmiopKGgwSELOf93Hgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787814159; c=relaxed/simple;
	bh=7ofXFVb3e5OKtgyP11uXGMATOmYKHuxncN4Fm7WY248=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Oe/rCNlmghcDWdRZeesOt5YcbN5Kb3fv+l+MtmuScTSgedDy5KbTeRDmXyMEOHqXjRKWz/5/iMRWfv1YuWcnlW720iXOAaCq76ftx01VyvElXqsuCtUUPcr99vzDo7x7mcBzftDE0sKXpEDmdzszpNSjq5WJLjLySgCxMirbdto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ju6Kyoo1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ju6Kyoo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960481F000E9;
	Thu, 27 Aug 2026 07:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787814156;
	bh=oyDV/eAy3FCbUFbC7dVTw2qtXNWgTRtx9vwkKSN4ek8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ju6Kyoo1aIcYS8XhUy86NB7LR1mKQ9rXIOMvTcqRPW8cgI3ooCj4ys+wqw53nVNDk
	 yCRdykk2f/cSiMplu7gFFp8cDjwjtW2qPvc7daAb69kvtklQopHe/d7YBbzTn0ypwS
	 OdX8osNXwBvrY1afsGaA1cRboKRjq7gDMDht2UdWCt8qU3/tUNQ8AFqMM1UfKDeon3
	 iev7ORXezv0SL2c7JnqqKPjHL1GY1crJLY3N0d14hCcfCEOyEPNayBpSrm8BmGoFdH
	 1WD+57Y4CNFKKX2+U4vQME0uSQJS/Mbz+sFzJcOW8MNcptNTYl7YvCQ23bW/K8huEW
	 ESYhrXrJ+gWTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] md/raid5: fix leak and use-after-free in
 resize_stripes error path
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827063235.85375-2-ghuicao@163.com>
References: <20260827023803.36602-1-ghuicao@163.com>
 <20260827063235.85375-1-ghuicao@163.com>
 <20260827063235.85375-2-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 07:02:36 +0000
Message-Id: <20260827070236.960481F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Moving the replacement and freeing of `conf->disks` to after S=
tep 4 introduces a severe Use-After-Free race with the main IO thread (`rai=
d5d`).

Pre-existing issues:
- [High] Incomplete UAF fix: `conf->disks` is still vulnerable to a concurr=
ent use-after-free by `raid5_error()` and `raid5_calc_degraded()`.
--

commit bd1f3c6216c041887763e5099827c3cd4343c423
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md/raid5: fix leak and use-after-free in resize_stripes error path

This commit addresses a memory leak when stripe slot allocation fails, and
attempts to fix a concurrent use-after-free by swapping the conf->disks arr=
ay
under mddev->lock. The array replacement is deferred until after new stripe
slots are successfully allocated.

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
                ^^^^^^^^^^^^^^^^^

[Severity: Critical]
By deferring the kfree() of old_disks until after Step 4, does this code
introduce a race with the main IO thread?

During Step 4 (just above this code), resize_stripes() calls
raid5_release_stripe(), which returns stripes to service and wakes up the
raid5d IO thread.

Once awakened, raid5d resumes processing stripes and will locklessly access
the disks array:

raid5d()
  handle_stripe()
    analyse_stripe()
      rdev =3D conf->disks[i].replacement;

Because raid5d does not acquire mddev->lock, won't it dereference the freed
old_disks array when this code executes concurrently?


[Severity: High]
This isn't a bug introduced by this patch, but does protecting the pointer
swap with mddev->lock completely prevent concurrent use-after-free of
conf->disks?

The commit message notes that raid5_status() reads conf->disks under
mddev->lock. However, a concurrent block IO error can trigger raid5_error(),
which calls raid5_calc_degraded():

raid5_error()
  raid5_calc_degraded()
    struct md_rdev *rdev =3D READ_ONCE(conf->disks[i].rdev);

In raid5_error(), this is protected by conf->device_lock, not mddev->lock.
If raid5_error() executes concurrently with this kfree(), won't it
dereference the freed old_disks array?

>  		conf->pool_size =3D newsize;
> +	} else if (ndisks) {
> +		for (i =3D conf->pool_size; i < newsize; i++)
> +			if (ndisks[i].extra_page)
> +				put_page(ndisks[i].extra_page);
> +		kfree(ndisks);
> +	}
>  	mutex_unlock(&conf->cache_size_mutex);
> =20
>  	return err;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827063235.8537=
5-1-ghuicao@163.com?part=3D2
