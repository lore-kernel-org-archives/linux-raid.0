Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A57430CC3
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 11:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783510635; cv=none; b=PPxBubBEQVQFstbvmiWSxzxL8B3glAgPoy9oN2V/dniDR+Zf/HYqr63EcMGVXpCH5XVROUc05/HUn3B/RJNP8jHkdoxtl3wnTykSajKih/a26uXymRJ92l/TTTBIZi9D4J+bk+PT/T5J/+rGM018p/wAcu4gu4iDMqGR+GkPtiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783510635; c=relaxed/simple;
	bh=Qag74SZ1aEIFqKn+6zrgmv8bBsJPsQddg8cRkoJcUFA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SYqhezxDFO76Cxno8trJdNIC73GXciBLvicKw+1gTMS2BxLT9M1+laZgKukCdH9pnF6XvwzCyT0Q8v4PghONHZdjnbdUUnmNtZCw4MqGdh5uM0vQLyVFF0gQSisDwEFyp0ny2Q5GEJSYrIHvWaEhL6Ut1LQMesI/ji1ULB/gOQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G1HvmHfK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G1HvmHfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77311F00ACF;
	Wed,  8 Jul 2026 11:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783510634;
	bh=mwIGQArw8PKFLjlDlwTpLdCZkgvqqFk0+FbBMPwahTc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G1HvmHfK7vdgp4ZsSPjSbQ02U6eX/zLGvIgyz+BOPi7pMkRaVw3h+zAgxDT6VBG3r
	 9CmLC/BnbdkKOzhw09J7D0+bgsTT7m2NxndlxmAx9KggD334NgJgxwaXQtJ1dCrhkB
	 EWhVFpmH3/9VZUIA54jYrhAkWO0ZnWirJNy4u+VIU5nA6WAQIE9qlB9G/M14D8/kmB
	 3cC3teBrZiW+c5zfaCHN7ClZoUr/BICMT8EnL3HSgVVQU2Nvy6iPI+U41M7hbroPm9
	 TfM4cog6iZ4wnImrITtMt8TXw9lXt830LmhDevIyifLxiBcVEDqPKcwCrBmJ5cIrxw
	 Br0enYCPPjAaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md: recheck spare changes before starting sync
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260708112003.474537-1-abd.masalkhi@gmail.com>
References: <20260708112003.474537-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 11:37:13 +0000
Message-Id: <20260708113713.B77311F00ACF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Incomplete fix for a TOCTOU race condition causing a NULL pointer =
dereference when modifying the spare configuration without suspending the a=
rray.
--

--- Patch [1]: [PATCH v2] md: recheck spare changes before starting sync ---
commit 0ddb3cd53c96b4255d51183f6d5da4fcd8b938bf
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md: recheck spare changes before starting sync

This patch aims to fix a race condition where spare configurations are
modified without suspending the array. It adds a recheck for spare
configuration changes after acquiring the reconfig_mutex to avoid operating
on stale states.

Link: https://lore.kernel.org/linux-raid/20260630075640.1081634-1-abd.masal=
khi@gmail.com/

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -10181,13 +10181,25 @@ static void md_start_sync(struct work_struct *w=
s)

[ ... ]

>  	mddev_lock_nointr(mddev);
> +
> +	/*
> +	 * The spare configuration can change before reconfig_mutex is acquired.
> +	 * Recheck while holding the lock and suspend if needed.
> +	 */
> +	if (!suspend && (mddev->reshape_position =3D=3D MaxSector || !md_is_rdw=
r(mddev)) &&
> +	    md_spares_need_change(mddev)) {
> +		mddev_unlock(mddev);
> +		mddev_suspend_and_lock_nointr(mddev);
> +		suspend =3D true;
> +	}
> +

[Severity: High]
This is a pre-existing issue, but does this recheck completely close the ra=
ce
window?

If a faulty drive has pending I/O, md_spares_need_change() will evaluate
rdev_removeable(), which checks atomic_read(&rdev->nr_pending). If that is
greater than zero, md_spares_need_change() returns false. This causes both
the initial check and this new recheck to bypass suspension.

If an asynchronous I/O completion happens immediately after this recheck,
nr_pending can decrement to 0. When md_start_sync() continues and eventually
calls remove_spares(), it will re-evaluate rdev_removeable(), find
nr_pending =3D=3D 0, and remove the disk. This nullifies the disk pointer.

Because the array was never suspended, couldn't concurrent I/O re-read the
nullified pointer and crash? For example, in drivers/md/raid10.c:

err_handle() {
    ...
    struct md_rdev *rrdev =3D conf->mirrors[d].replacement;
    ...
    if (r10_bio->devs[k].repl_bio) {
        rdev_dec_pending(rrdev, mddev);
        r10_bio->devs[k].repl_bio =3D NULL;
    }
}

If rrdev is fetched as NULL due to the concurrent removal, rdev_dec_pending=
()
will dereference it.

Could remove_spares() be restricted to only remove drives if the array is
actually suspended, or should suspension be enforced earlier regardless of
nr_pending?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708112003.4745=
37-1-abd.masalkhi@gmail.com?part=3D1
