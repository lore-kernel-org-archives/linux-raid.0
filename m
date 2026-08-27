Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6E1231C91
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 03:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787801522; cv=none; b=uyJL4zPKLiiKVFBVVNjLp1tmnbkeFMwCmSH3N+dyJOnaajRvIGKCE6fCoBJWkA0V4yYNe3H5YQkK1d5qVBTK1PGh5YkL4olwmVOB0ukMxbFsoWmXRWKSQHIuWv0JtVUdv6V1Vg7IMz+/A2lMCIP1fuKCsUUzHboj4qRYEMxjBlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787801522; c=relaxed/simple;
	bh=P18LY7grLXbGjeVrAD6ccSbEMRAkS9GDkng/7pf79o8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nPIkltSEN7y0rokCueL5jYT3L8jugl1lydMwT3pz2unZzU3rgWiZLW/zsMRIkZIFlHvLTDatDsY3JdG8OigTyuji6rcn1C23DigWXxPR9r3ezN0+SnDfRtPYlUy0dKPBjMqoPZmKDrwDOiQRiTRBaK7QGO8ct5rz7w5e/7pvwA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RfcJmIai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RfcJmIai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFE41F000E9;
	Thu, 27 Aug 2026 03:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787801520;
	bh=DLJ9oFahH4w0bSYRAhWYvuWLdI7WJWbtm8BeWozzBM0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RfcJmIai/MJWmVqyXmhN/DizZNONWnREcodu/pvRJeVaPvyE9S47oSBWtGQicJbQt
	 pOz+3HCQLp0fbEOEY4lyKee6/HpPuK7m8HlBUR15d3V39gbTjQrUQmKoPwt9rkd8yW
	 ae/Qp9lIzJ6nTBAT9Ynu1mD1eKnbAyvbRLe+ExAyMerqBjp1+hgRXKC/dIhdUL8uvS
	 qqe1SmFv1HUQ+0w0gD48hUzFlPAuwup8p1rMYgVpssstridX4gT1QsgFBgAUTpjX1T
	 c2jBrqyrSol/3SKkkjHtdhN43XJJ1cPBc5lWihQ57HIVQO1Wi9ZTc9RJpikuPzpL3V
	 A5rBCf8REcvIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] md/raid5: fix pool_size leak in resize_stripes
 error path
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827031646.49080-1-ghuicao@163.com>
References: <20260827031646.49080-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 03:32:00 +0000
Message-Id: <20260827033200.7EFE41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Premature update of `pool_size` causes subsequent reshape retries =
to bypass stripe cache resizing, leading to a NULL pointer dereference.

Pre-existing issues:
- [High] Lockless access to `conf->disks` in `raid5_status()` can lead to a=
 Use-After-Free if it races with `resize_stripes()` freeing the array.
--

commit 021dd13adb2ffa7a0e256f63ee764cd6ee6f46ab
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md/raid5: fix pool_size leak in resize_stripes error path

This commit updates conf->pool_size immediately after replacing conf->disks
in resize_stripes(). It intends to ensure pool_size matches the allocated
array size so free_conf() frees the correct number of extra page allocations
on teardown.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090de..fa64cf059b8ea 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2642,6 +2642,7 @@ static int resize_stripes(struct r5conf *conf, int =
newsize)
>  		} else {
>  			kfree(conf->disks);

[Severity: High]
This is a pre-existing issue, but does freeing the old disks array here
without synchronization (e.g., an RCU grace period) allow a use-after-free?

Concurrent readers like raid5_status() access the freed disks array lockles=
sly
since md_seq_show() only holds mddev->lock (a spinlock), while this code
executes under mddev->reconfig_mutex and conf->cache_size_mutex.

For example, in raid5_status():

drivers/md/raid5.c:raid5_status() {
    ...
    struct md_rdev *rdev =3D READ_ONCE(conf->disks[i].rdev);
    ...
}

If an unprivileged user reads /proc/mdstat exactly when root initiates a
reshape, it appears the kernel will dereference the memory freed here.

>  			conf->disks =3D ndisks;
> +			conf->pool_size =3D newsize;

[Severity: High]
Does moving the pool_size update here cause a NULL pointer dereference on
reshape retries?

If the alloc_page() calls in Step 4 of resize_stripes() fail due to memory
pressure, the function sets err =3D -ENOMEM and returns, but conf->pool_size
has already been updated to newsize. The stripes are then released into the
cache with missing (NULL) pages.

If a user retries the array reshape operation after the -ENOMEM failure,
check_reshape() will evaluate this condition:

drivers/md/raid5.c:check_reshape() {
    ...
    if (conf->previous_raid_disks + mddev->delta_disks <=3D conf->pool_size)
        return 0; /* never bother to shrink */
    ...
}

This evaluates to true because pool_size was already updated. The retry
bypasses resize_stripes() and proceeds with the reshape. Later, when
operations like ops_run_io() access the unallocated pages for the new
devices, it results in a NULL pointer dereference.

>  		}
>  	} else
>  		err =3D -ENOMEM;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827031646.4908=
0-1-ghuicao@163.com?part=3D1
