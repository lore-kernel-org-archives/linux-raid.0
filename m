Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BC71E4AF
	for <linux-raid@vger.kernel.org>; Fri, 19 Jun 2026 04:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781844678; cv=none; b=UUCfR1aJ8gUTIu6EERCx/9w8uunHVLV2/7zfOAgrIfmsc8scLZxIGo1EUW+DBlwOzoq2/mT0E0SpF8lWUzHvvl17LC+WQhwywQdqeq2ONECXOcKC4hbY1PctPurB2uH3TxwlAGEaBezIUdmIAObg24QDGR28F6uxdCe5/KNgmGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781844678; c=relaxed/simple;
	bh=fkFH5m+qBmBwZc3VM5v8vlLmHCjMG/OpKpfpid9c/Q4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Pbd9B+pwGYeBFIJoLobDLP9PdUUscRzvwggRS0FF6nGYOBM7JLXFSccja4jsOMdjctffMiXA1q1LFnf9KTxXVpVJpEN8odQRN5C0do0POTWMbbR4NN8tbXpaWVjjwYbXXmfsFNGYrJ9UyKRqRiqkth+yyRoPW7H+AtS7D0uRjPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SArHkyJ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SArHkyJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12901F000E9;
	Fri, 19 Jun 2026 04:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781844677;
	bh=8YMD8VQiAhgSq2Lz3BeGyMFcxpergQokK/HdTltGa2A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SArHkyJ23A6W1zJFFdl9nEBLeNqOXQjCYdsvXFGnsV/s15/35OiqD2dq19qSOkpST
	 KfduasLzWu9Pga5z8mI5jw6lJt8OinSVuc1Nj18H+DSBvU7jA7Lbi7EVwXGFpzs2k1
	 qYc8obq7d16rJZN7fyEiJf/qYJ464H+SKu7g6Ns3odw0s3x3KQpN6h3niJ/woVIY3w
	 Q6WkhwC0NWHI4XdSms3nE7BkPfuqGsXaqJB1rTj3tAFCP9Wi9Rnsv+AvoE1LoKeh5/
	 2apnck1ITFh3TKSKnHgS5z0B7SL0PMe0Fip+WDO2VWSzQ4N7kQOWCrh7aU4mhI9A7L
	 T5Gw1Cabmk8Zw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid1: protect head_position for read balance
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260619044114.1208456-1-chencheng@fnnas.com>
References: <20260619044114.1208456-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 19 Jun 2026 04:51:16 +0000
Message-Id: <20260619045116.E12901F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Medium] The commit fixes a KCSAN-reported data race on `head_position` i=
n `raid1.c` but misses the identical data race in the sibling `raid10.c` su=
bsystem.
- [Medium] The patch addresses a KCSAN data race for `head_position` but mi=
sses identical concurrent data races on adjacent heuristic variables `next_=
seq_sect` and `seq_start`, leading to a potential double-fetch bug and unsi=
gned integer underflow.
--

commit 754549019263d81271c296e50e19909fb366125b
Author: Chen Cheng <chencheng@fnnas.com>

md/raid1: protect head_position for read balance

KCSAN reports a data race between raid1_end_read_request() and
raid1_read_request().

The completion path updates conf->mirrors[disk].head_position in
update_head_pos() without a lock, while the read-balance heuristic reads
the same field locklessly in is_sequential() and choose_best_rdev().

[Severity: Medium]
This is a pre-existing issue, but does raid10 also need this same fix?

Looking at drivers/md/raid10.c, update_head_pos() updates
conf->mirrors[r10_bio->devs[slot].devnum].head_position locklessly, and
read_balance() reads it locklessly:

drivers/md/raid10.c:read_balance() {
...
	new_distance =3D abs(r10_bio->devs[slot].addr -
			   conf->mirrors[disk].head_position);
...
}

Since raid10 shares this read-balancing heuristic, should the data race be
addressed there as well to prevent torn reads?

[ ... ]

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 5b9368bd9e700..4cdf4484cab6c 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
[ ... ]
> @@ -737,7 +737,7 @@ static bool is_sequential(struct r1conf *conf, int di=
sk, struct r1bio *r1_bio)
>  {
>  	/* TODO: address issues with this check and concurrency. */
>  	return conf->mirrors[disk].next_seq_sect =3D=3D r1_bio->sector ||
> -	       conf->mirrors[disk].head_position =3D=3D r1_bio->sector;
> +	       READ_ONCE(conf->mirrors[disk].head_position) =3D=3D r1_bio->sect=
or;
>  }

[Severity: Medium]
This is a pre-existing issue, but should next_seq_sect and seq_start also
be protected to prevent double-fetch bugs and underflows?

While this patch secures head_position, next_seq_sect is still read lockles=
sly
here and in should_choose_next():

drivers/md/raid1.c:should_choose_next() {
...
	return opt_iosize > 0 && mirror->seq_start !=3D MaxSector &&
	       mirror->next_seq_sect > opt_iosize &&
	       mirror->next_seq_sect - opt_iosize >=3D mirror->seq_start;
}

Because mirror->next_seq_sect is read multiple times without READ_ONCE(),
could the compiler emit multiple memory loads?

If a concurrent update from update_read_sectors() reduces next_seq_sect
after the safety check (mirror->next_seq_sect > opt_iosize) but before the
subtraction, could it cause an unsigned integer underflow, bypassing the
seq_start check?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260619044114.1208=
456-1-chencheng@fnnas.com?part=3D1
