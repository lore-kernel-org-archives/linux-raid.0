Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793955217;
	b=l2PB9bR75kVX/vsQNJHZwPi88tEt3vRaMlTWtRnRZqYYOA9iH57X/DZ6+aoVS3IBF+QQ
	 kab0qx4iFTWKEARcs8F51jdd08DNlwq4pYwrE094S9/5RPeguVavkDfnhu4zNcvG35u8C
	 ZvLlH9NKzTKXrQfpgyzQf08xQQS1Qcz3nkqDpfFiBtgxIkJQf3LnkdmH1mEnGSRKf9//0
	 SXzcOQ/L8Sil5mleU9oa4rv/2NutGYnxeu2kpi6qXfMwlmxyBFwtq0F3DmtZriyH+Brgv
	 4uXW57Yc4rfO+gYzFpjwKuW02tyUI0fsP4A+YNtpm3SxSUE/re4pgQq3AHAgvtJHLWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793955217;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=q8dISGVyx+/VTNI1tDmxFw8c4jIPKrCvTq/mHo9sLt0=;
	b=J5bD1ftcPST1BDTrv+2f9LoPvV0VA9Yda0rwl0NAy4IO8uAhVLdw99VmCCmXu1RHtys4
	 zGsWrb2Ykpz/AG0FqxYFA/hPEh9k8S5IdMHANYBQ9BOxwtDvlHUFDeefSKJRMumDU3Sad
	 8PmVZOJapeJ4aW5yl7khPJzMEiFo1WXPgE2wQItfvY/kIy9P0dkBlNBWM2/DwYVXKkiKR
	 lroUsaKZPEXQngK/YD91ildhDDfcanZ4OXKYtjihoXDk6Z6/hV5Q7A6sxISjx8CNmkLCB
	 esj/fgdUuOkPRpf+U6bnO0QsznqMIAJIjgtINPqPI/CN1ht6jD818RDu00p0DvVfKvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NOplUp0E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B8F606A326
	for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2026 08:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NOplUp0E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63821F0089F;
	Fri,  6 Nov 2026 08:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793955216;
	bh=q8dISGVyx+/VTNI1tDmxFw8c4jIPKrCvTq/mHo9sLt0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NOplUp0En/m5I5X7bBAZPoBNqWCCawR9l7bwv0VJPFAkmbpk3P64CVnn4ZWoKg6Hx
	 Av0/gAaqqzqtOjqJAtG6ftFvSRTEZt4lNFyjLG+yfNXmsIUROUQ6Uqd2arHi+qfVxZ
	 7w58K5e8wkb/ysB9JuTDqJh7eOOtpnVEV7VwIOlWQ0/BPzLFs2unrC1+RvdsECbVX5
	 u726mXAlVtxjgaFe3ubDJgydnnRR5I6pZsxG4r4y6PU+wUXGJEDGhxdZUbIAn+pKjZ
	 XiBp6Vy5rTsbLNzM/nMePMjDgr5v+ptroDBea0S/okuovRneIBq2+c+dLtnK78dzKZ
	 VZr40RsOXRH4w==
Message-ID: <sashiko-outbox-201094@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: fix NULL dereference of pers in md_start_sync()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261106083543.249267-1-dayou5941@163.com>
References: <20261106083543.249267-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 08:53:36 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] md: use-after-free of mddev in md_start_sync() after md_stop()
--

commit 430c0b94e66563acd0f6769283c9a65888eb4dba
Author: Li Youhong <liyouhong@kylinos.cn>

md: fix NULL dereference of pers in md_start_sync()

This commit adds a NULL check for mddev->pers in md_start_sync() to bail
out via not_running if md_stop() has already cleared pers.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..9cafa8d673e82 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -10312,6 +10312,13 @@ static void md_start_sync(struct work_struct *ws)
>  		noio_flags =3D memalloc_noio_save();
>  	}
> =20
> +	/*
> +	 * md_stop() clears pers. This work may have been queued earlier and
> +	 * can run after that, so pers may already be NULL here.
> +	 */
> +	if (!mddev->pers)
> +		goto not_running;

[Severity: High]
Can md_start_sync() still use mddev after it is freed when dm-raid calls
md_stop()?

Standard md teardown in do_md_stop() calls stop_sync_thread(), which flushes
mddev->sync_work before __md_stop() clears mddev->pers.  In contrast,
dm-raid's raid_dtr() calls md_stop(), unlocks reconfig_mutex, flushes only
event_work, and immediately destroys and frees rs without cancelling or
flushing sync_work:

CPU0                                  CPU1 (kworker)
raid_dtr()                            md_start_sync()
  mddev_lock_nointr(&rs->md)
  md_stop(&rs->md)
    __md_stop(&rs->md)
      mddev->pers =3D NULL
  mddev_unlock(&rs->md)
                                        mddev_lock_nointr(mddev)
                                        if (!mddev->pers)
                                          goto not_running;
                                        ...
                                        mddev_unlock(mddev)
  raid_set_free(rs)
    mddev_destroy(&rs->md)
      percpu_ref_exit(&mddev->active_io)
    kfree(rs)
                                        __mddev_resume(mddev, false)
                                        test_and_clear_bit(..., &mddev->rec=
overy)
                                          <-- use-after-free

If md_start_sync() starts after raid_dtr() unlocks reconfig_mutex, it can
also access freed mddev memory before reaching the !mddev->pers check, and
the check itself sits after the conditional unlock-and-suspend block that
can drop reconfig_mutex and suspend an already-stopped array.

Should md_stop() (or __md_stop_writes()) flush or cancel mddev->sync_work
before __md_stop() clears mddev->pers?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106083543.2492=
67-1-dayou5941@163.com?part=3D1
