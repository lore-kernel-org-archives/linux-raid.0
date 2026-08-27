Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF4F30BF6B
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 06:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787811891; cv=none; b=Dumndck65WNGSku5dpY6snSs00awZMRiTHOgeKJxQLphBlfQwY7IFVY/+/lbZC3v9+AcJSqAnzY7bqEkOj0HJsS/Pphsuo+CBTl00AwMcVR5h90haXvs6oXudaW0vi/rWxrdbefRdovHiGcqoVxyL1eELl3IMJEabr8Q6mRT8JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787811891; c=relaxed/simple;
	bh=oSQMcOs+CkdbRHmFwFXh0oid0RV714atNwSQDl5NDfk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QdSSpgBM1B0XUtr1EHsR5l7PnFWJS7GR6/2sXSk+mmPm46FywEtTG3N3gCVDJjoY3+kjhE/nhwaLt4l0DzmfRlCQzid2f/QcbNhvc+Px+K1OQPXWut8xMvdTCzw04E/JS7ibW9yNiH/ghVdt+svkqF8Up/RkW55p+toNJbdMXRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2UCdUdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2UCdUdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958811F000E9;
	Thu, 27 Aug 2026 06:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787811889;
	bh=Yqk0eIbpynFM/4Q7ZVM/W7wyJeo4y0xcWLhJd/gaI0Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l2UCdUdwT80bdNndcOxWm8FEJtRq41dccNNpcF8EZPN6AP/g8qUcrmrT0xz+jivxJ
	 n08OIuYAK4EZgcenGCY1rGWo3IR264DjMr4eTFcRRZt0H1oYDhyQAfuZr4v0alhn7H
	 /J/uBScrFHrcSd2oRRNJaRnP7vMxRQ6hfzwoDPgr7D6QG0Je5tKL3pzrJ8vtnp5OvU
	 RPNfWUe5VBrVYeUjZ0xhFIJmOrzGYxbYzkrL9ITiwi1o01gWWEKI2VmazBFFIcrbi6
	 ZRjSaVtcWrGFq8IwXLPkHXq0TrdZq6rAY7LXGSZ2ZHlOsqEAwKSMG1kkwZZO03kUuk
	 NlGkun3TyeK6A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] md-cluster: fix error handling and superblock
 update in update_size revert
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827061200.79753-1-ghuicao@163.com>
References: <20260827025229.40138-1-ghuicao@163.com>
 <20260827061200.79753-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 06:24:49 +0000
Message-Id: <20260827062449.958811F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Guaranteed self-deadlock and potential double-unlocks in `update_s=
ize` due to calling `md_update_sb()` while the cluster communication lock i=
s held.
--

commit bae2db67348747b3864a225bb7b24be69937b7a2
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md-cluster: fix error handling and superblock update in update_size revert

This commit addresses error handling and metadata updates when reverting an
array resize operation in a cluster. It checks the return value of resize()
and updates the superblock to match the in-memory array size.

> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 24dac6f09da82..9f404660a1fb7 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1349,6 +1349,10 @@ static void update_size(struct mddev *mddev, secto=
r_t old_dev_sectors)
>  	} else {
>  		/* revert to previous sectors */
>  		ret =3D mddev->pers->resize(mddev, old_dev_sectors);
> +		if (ret)
> +			pr_err("%s:%d: failed to revert array size\n",
> +			       __func__, __LINE__);
> +		md_update_sb(mddev, 1);

[Severity: High]
Does this call to md_update_sb() cause a self-deadlock?

At this point in update_size(), the cluster communication lock
(MD_CLUSTER_SEND_LOCK) is already held via lock_comm(). When md_update_sb()
is called, it enters mddev->cluster_ops->metadata_update_start(mddev), which
waits for MD_CLUSTER_SEND_LOCK to be cleared. Since the lock is held by the
same thread, this appears to result in a strict self-deadlock during a fail=
ed
array resize operation.

Additionally, if the deadlock could somehow be bypassed, md_update_sb() wou=
ld
complete by calling metadata_update_finish(), which prematurely calls
unlock_comm(), leading to a fatal double-unlock when update_size() later
attempts to call unlock_comm() itself.

>  		ret =3D __sendmsg(cinfo, &cmsg);
>  		if (ret)
>  			pr_err("%s:%d: failed to send METADATA_UPDATED msg\n",

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827061200.7975=
3-1-ghuicao@163.com?part=3D1
