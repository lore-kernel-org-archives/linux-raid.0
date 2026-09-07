Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FC64CA781
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788789365; cv=none; b=GLC92Mfo5VHRLtvmbCNVjaL3xrn4dt7ZENTXdWahTVwkMMs87qV9lx56CvHLUaM1m2/XXNzkKW7+4Zf+1ag07vThVtMYkmt7WCcufjsXqJwhFw429ySlQPAQE3aNWVKXq2s2ooWBKgUFnJzLJ+UdXrXuLcxUcTMUDQa+du2PDWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788789365; c=relaxed/simple;
	bh=62kQdqZFAJqhKWQ/h03iIMZ+vLZ84stteFjUbFDuOUE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L9JuAW2INgcsh/oSNP4gOJSnIbY2rpPJ1TtC5IHULFpx0Z8DLAEoI5wTnkb9ihCZMRVQg2Y8SIDAcMqNpOVcdXnQlRGIhokTA3MnFY634aPobvH3sgdJY/gerxBrkRLq6ljrMgCdHs89iycmo9ADn9g18I0UAMb7ff17KXaNb2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TE9wtVuN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TE9wtVuN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280C41F00A3D;
	Mon,  7 Sep 2026 13:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789364;
	bh=d2YUUiKEb0FTbwvd6WJZhCDCcWSF8kdyxglfqB+aPtg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TE9wtVuNgglQv8pO2IZDBK/bptjiwpXgjXzCF2tz2Ttsvt6eIys4tD7rPVuemqMuu
	 gbrdDudST0zAmCBQH/YOhKUBLbHiTVSO0VuWGjvn/jxOAqnHtRtavSDAp/hYKz+CoO
	 p/MnfeKiiCWRIrgV3EhUP0VyGRfxztrZUwI4R8+AUsOqhwvca60lEp8kDs6Y7J1vGW
	 2RuqBW7O6qzEYr63re7R/sn+2lwOJbn8OwJGYZKu+wAr11uUQTMgJ0I1m575+uhGYk
	 EmlGBGmhNfGcb9tLO2ONRSUGFTyxoazeiB2IYtyX8bhNekYRJwTxfdHd0b3iCc3osV
	 ci5vFdipc5Ajg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/6] md: pass a queue_limits down to ->hot_add_disk()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260907133929.1081540-3-jinpu.wang@ionos.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
 <20260907133929.1081540-3-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 13:56:03 +0000
Message-Id: <20260907135604.280C41F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] `linear_add()` ignores the new `lim` argument and unconditionally =
calls `queue_limits_set()`, which will cause a deadlock.

Pre-existing issues:
- [High] Missing limit check and queue limit stacking for replacement disks=
 in `raid1_add_disk()`.
- [High] Missing limits update and stacking when hot-adding a disk in `raid=
5_add_disk()`.
--

commit 37bd7159af00deb7b9d45549d34775a10b587170
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

    md: pass a queue_limits down to ->hot_add_disk()
   =20
    Adding a leg stacks its queue limits, which mddev_stack_new_rdev() does
    by taking q->limits_lock itself.  Callers that hold reconfig_mutex, or
    have the array suspended, must not do that: the lock's holder waits for
    I/O they are blocking.  They need to own the update instead.
   =20
    Give ->hot_add_disk(), remove_and_add_spares() and
    md_choose_sync_action() a queue_limits argument, and add
    mddev_stack_rdev_into() to stack into a caller-owned update.  Every
    caller passes NULL, so no functional change; the users follow.

> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index 73b367b61b873..1f44c2d7db93d 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -186,7 +186,8 @@ static int linear_run(struct mddev *mddev)
>  	return ret;
>  }
> =20
> -static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
> +static int linear_add(struct mddev *mddev, struct md_rdev *rdev,
> +		      struct queue_limits *lim)
>  {
>  	/* Adding a drive to a linear array allows the array to grow.
>  	 * It is permitted if the new drive has a matching superblock

[Severity: High]
Does linear_add() miss using the new lim argument?

Looking at the body of linear_add(), it unconditionally calls linear_conf()=
=20
without passing the limits down. In the final state of this patch series, w=
hen=20
the caller already holds q->limits_lock, linear_conf() will eventually call=
=20
queue_limits_set() which tries to take the lock again. Could this lead to a=
=20
deadlock on q->limits_lock when hot-adding a disk?

[ ... ]
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f0646fb24371f..dd348b5695d06 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1898,7 +1898,8 @@ static bool raid1_remove_conf(struct r1conf *conf, =
int disk)
>  	return true;
>  }
> =20
> -static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
> +static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev,
> +			  struct queue_limits *lim)
>  {
>  	struct r1conf *conf =3D mddev->private;
>  	int err =3D -EEXIST;
> @@ -1923,7 +1924,10 @@ static int raid1_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>  	for (mirror =3D first; mirror <=3D last; mirror++) {
>  		p =3D conf->mirrors + mirror;
>  		if (!p->rdev) {
> -			err =3D mddev_stack_new_rdev(mddev, rdev);
> +			if (lim)
> +				err =3D mddev_stack_rdev_into(mddev, rdev, lim);
> +			else
> +				err =3D mddev_stack_new_rdev(mddev, rdev);
>  			if (err)
>  				return err;

[Severity: High]
This is a pre-existing issue, but I noticed that further down in=20
raid1_add_disk(), we add a replacement disk but omit any limit checks:

	if (err && repl_slot >=3D 0) {
		/* Add this device as a replacement */
		clear_bit(In_sync, &rdev->flags);
		set_bit(Replacement, &rdev->flags);
		raid1_add_conf(conf, rdev, repl_slot, true);
		err =3D 0;
		conf->fullsync =3D 1;
	}

Since mddev_stack_new_rdev() or mddev_stack_rdev_into() is skipped for this=
=20
path, could this allow a replacement disk with incompatible queue limits=20
(such as differing integrity profiles or larger logical block sizes) to joi=
n=20
the array, resulting in data corruption or I/O failures?

[ ... ]
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090de..0ec555ada64a0 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8441,7 +8441,8 @@ static int raid5_remove_disk(struct mddev *mddev, s=
truct md_rdev *rdev)
>  	return err;
>  }
> =20
> -static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
> +static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev,
> +			  struct queue_limits *lim)
>  {
>  	struct r5conf *conf =3D mddev->private;
>  	int ret, err =3D -EEXIST;

[Severity: High]
This isn't a bug introduced by this patch, but I noticed that raid5_add_dis=
k()
does not stack or check queue limits at all when hot-adding a disk:

	for (disk =3D first; disk <=3D last; disk++) {
		p =3D conf->disks + disk;
		if (p->rdev =3D=3D NULL) {
			clear_bit(In_sync, &rdev->flags);
			rdev->raid_disk =3D disk;
			if (rdev->saved_raid_disk !=3D disk)
				conf->fullsync =3D 1;
			WRITE_ONCE(p->rdev, rdev);

			err =3D log_modify(conf, rdev, true);

			goto out;
		}
	}

Because mddev_stack_new_rdev() or mddev_stack_rdev_into() are not called
here, and the new lim argument is ignored, could this allow disks with
incompatible limits to be successfully added to the array?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907133929.1081=
540-1-jinpu.wang@ionos.com?part=3D2
