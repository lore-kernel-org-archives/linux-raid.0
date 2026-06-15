Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5B9212F89
	for <linux-raid@vger.kernel.org>; Mon, 15 Jun 2026 11:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781524171; cv=none; b=SJoFL4tFX7CmInEzO2jLyhZBwiOx3OgNgQq8PWNY/RA8dpX1HSq9GYz/Yg4c9WqRPw399qzYkF/q+MGyTF20oXrX45BYAK62oKBpIMFlOvWpezBWF4pPYLsz18tuF/2+ko+sejHpnkwUBvdAPpTv+P9rhnMAsOJAiXH71id9LPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781524171; c=relaxed/simple;
	bh=jmCd37Ep9pEPoYQUFZ6Z7xLrdla+iID5Bkf9Sz8aOu0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=p+obxdHAh/Khk4fPhU+NZUNtwYHWWkeB2EhemDy4EQuP5g1TvdPNDjoagYNUFAkMkKP/6Ij0dhZeZbF+f69QBpyDi23GMz0SM/uLQJWhCAgoCBoZsYXvUyFy9j0xJDUBDrGz3FDZDd03EzB0YcX3h0WXRQGJcxRqqTCzQ/XIGTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KhiRtlxN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KhiRtlxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BAD1F00A3A;
	Mon, 15 Jun 2026 11:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524170;
	bh=AjVa0NdicXhWaZkq5S66XQqZMLtRqqiVUO0pt9qh6sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KhiRtlxN7f3BapOx+F86cDCOZ+Mfr6c6/ocG0BVOr0j3F5DK6elKiWMdyZWrD7vxy
	 xv4KE0gdA2p5WCPcZipmbxEHuibl7h/eqnxIZ6SfXtFdgitH3h+faMgON7KQABSKgs
	 3PnRabg6rtnfsPpZYFb7fPdm7N96C8+eDDA2HpTQTbG1jFHPXxLamB0PG1bDSH5Yz3
	 8jVAoESc7VFoVyq7L46+u2WA5woG0k70f7wcLTetwdXFpWOiCFZKF4qY7Rbg3ImDkK
	 CGsbg9Bxc6gBRFL615318oarf8yQlLAtZWcYPOQ1iUn7yOGZiDg0qQa0LPYooNJxU9
	 ppCH2Y70xTRcw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md/raid5: fix reshape deadlock while failed devices
 more than max degraded
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260615113450.2088877-1-chencheng@fnnas.com>
References: <20260615113450.2088877-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 15 Jun 2026 11:49:29 +0000
Message-Id: <20260615114929.E5BAD1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Clearing STRIPE_EXPANDING prematurely in handle_failed_reshape=
() allows a destination stripe to be freed and reused while asynchronous DM=
A is still writing to its pages, leading to DMA-after-free memory corruptio=
n.
--

commit ec55b78c975b4f9f35e287b83bee72d76b92b33a
Author: Chen Cheng <chencheng@fnnas.com>

md/raid5: fix reshape deadlock while failed devices more than max degraded
   =20
This patch fixes a deadlock in raid5 reshape by cleaning up stripe states=20
(including destination and source stripes) when failed devices exceed the=20
max degraded count.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d0d7f96fd7cd9..2f4d82bd7c2e6 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3730,6 +3730,78 @@ handle_failed_sync(struct r5conf *conf, struct str=
ipe_head *sh,
>  		md_sync_error(conf->mddev);
>  }
> =20
> +/*
> + * handle_failed_reshape - handl failed stripes when reshape failed and
> + *			   degraded devices >=3D max_degraded

[ ... ]

> +static void handle_failed_reshape(struct r5conf *conf, struct stripe_hea=
d *sh,
> +				  struct stripe_head_state *s)
> +{
> +	int i;

[ ... ]

> +	/* release the destination stripes that are waiting to be filled */
> +	if (test_and_clear_bit(STRIPE_EXPAND_SOURCE, &sh->state)) {
> +		for (i =3D 0; i < sh->disks; i++) {
> +			int dd_idx;
> +			struct stripe_head *sh2;
> +			sector_t bn, sec;
> +
> +			if (i =3D=3D sh->pd_idx)
> +				continue;
> +			if (conf->level =3D=3D 6 && i =3D=3D sh->qd_idx)
> +				continue;
> +
> +			bn =3D raid5_compute_blocknr(sh, i, 1);
> +			sec =3D raid5_compute_sector(conf, bn, 0, &dd_idx, NULL);
> +			sh2 =3D raid5_get_active_stripe(conf, NULL, sec,
> +					R5_GAS_NOBLOCK | R5_GAS_NOQUIESCE);
> +			if (!sh2)
> +				continue;
> +
> +			if (test_and_clear_bit(STRIPE_EXPANDING, &sh2->state)) {

[Severity: Critical]
Could clearing STRIPE_EXPANDING prematurely here lead to a DMA-after-free?

During a reshape, a destination stripe (sh2) might require data from multip=
le
source stripes. STRIPE_EXPANDING normally prevents the destination stripe f=
rom
being returned to the free list before all data is copied.

If Worker 1 is handling a source stripe via handle_stripe_expansion(), it
submits an asynchronous DMA copy to sh2's pages and then calls
raid5_release_stripe(sh2) to drop its reference BEFORE waiting for the DMA =
to
complete:

drivers/md/raid5.c:handle_stripe_expansion() {
    ...
            raid5_release_stripe(sh2);
        }
    /* done submitting copies, wait for them to complete */
    async_tx_quiesce(&tx);
    ...
}

If the array concurrently fails, Worker 2 could enter handle_failed_reshape=
()
for a different source stripe, look up sh2, clear its STRIPE_EXPANDING bit,
and release it.=20

If sh2's refcount drops to 0 without STRIPE_EXPANDING set, could it be
added to the inactive_list and reallocated (or have its pages freed) while
the DMA from Worker 1 is still actively writing to it?

> +				atomic_dec(&conf->reshape_stripes);
> +				wake_up(&conf->wait_for_reshape);
> +				md_done_sync(conf->mddev,
> +					     RAID5_STRIPE_SECTORS(conf));
> +			}
> +
> +			clear_bit(STRIPE_EXPAND_READY, &sh2->state);
> +
> +			raid5_release_stripe(sh2);
> +		}
> +	}
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260615113450.2088=
877-1-chencheng@fnnas.com?part=3D1
