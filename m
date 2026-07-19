Received: from va-2-55.ptr.blmpb.com (va-2-55.ptr.blmpb.com [209.127.231.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F031D35F609
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 10:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784456715; cv=none; b=iRPK/9IFSv5DNDFA73fSrCTCMDm3dl9P+5QeVPrCLy6XCEgJKZzNHXzmjT0FaTNkK53x8o8LlBMNcnz5xivnKv5bSMl6oBt49K6zAjWSju9WR2wByDETuL1fKT9q6vYOhpUqLgb43ko4ZDMcQJg9wNkQ116nNMHQh7uueDxIuMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784456715; c=relaxed/simple;
	bh=I9/6JrAnthrJ6zrn0Ee9F4iCPN4eNVejSn1wT9BIkEE=;
	h=Subject:Message-Id:Mime-Version:To:From:Date:Content-Type:
	 In-Reply-To:References:Cc; b=XVHck6Gbg2+D+sbTA3YkisL7GBH5tl/jRifis1VIKgCRRKopDqLPl5Do0zlBh4BXniml+1KkBoxjWCTB0cEfEMf6Sw7s1nvaotv7APOWnQSnOJFpq5dvzmJxsCQk3ioHNTpARlc+HnrVmWnYuz5AkSpKrImXVqqDrM2Ab7Y31Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Q+PT+zxt; arc=none smtp.client-ip=209.127.231.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Q+PT+zxt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784456703;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=TlN9P2VyCfhbm2IW1bdYSuqwtnwHVO2SPNZxp41mPGM=;
 b=Q+PT+zxtHjpulNt4bOmxNXTN60/fV+WU+9Pr80g/QJHsz5oP2erTAwq2bMDImciN4SdE6m
 7gp1D59e278RBcJj1n8FPaoaKjWftSzzZ47Xgpz1feqlPRgO01iL5wnep7ZWik3CuTwuzn
 I7I/YnTLlaKnTBZEQIsvZleMmXPrTfyU4wkuHGc41gaIe0gJ1KKQ3e2GKBFXUh0+l6lK2X
 Fk2Znow6gesPkfrxhg2DBZ1JjOWY6bJTRFOCdNzqLjQFz2jQrV8G3t1xFv4dS7d6a1CTZZ
 AMUpaRelVr9QgacLh7cX9ZbrstL0g7K3rBZbMqnoxDVR/VuCDUQ2vm14M1GsNA==
Subject: Re: [PATCH] md: handle serial pool allocation failures
Message-Id: <d565dac8-e0e9-4aba-bbfa-78c5449f1f9e@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Sun, 19 Jul 2026 10:25:01 +0000
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a5ca5fe+17df8d+vger.kernel.org+yukuai@fygo.io>
Date: Sun, 19 Jul 2026 18:24:58 +0800
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260718105551.608500-1-chencheng@fnnas.com>
References: <20260718105551.608500-1-chencheng@fnnas.com>
Cc: <chencheng@fygo.io>, <linux-kernel@vger.kernel.org>

Hi,

=E5=9C=A8 2026/7/18 18:55, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> sashiko-bot report a issue:
> mddev_create_serial_pool() silently ignored allocation failures, allowing
> callers to continue with incomplete serialization state.
>
> validation:
>
> fail_page_alloc with a stacktrace filter for rdev_init_serial() to force
> the serial allocation and its kvmalloc fallback to fail.
>
> A/B result:
> - Without this patch, serialize_policy accepts the write despite the
> 	injected allocation failure, leaving serialization state
> 	incomplete.
> - With this patch, the write returns -ENOMEM and serialize_policy remains
> 	unchanged.

I don't see what's the problem here. If mddev_create_serial_pool() failed, =
then write behind
will be disabled.

>
> Fixes: 3938f5fb82ae ("md: add serialize_policy sysfs node for raid1")
> Link: https://github.com/chencheng-fnnas/reproducer/blob/main/test-serial=
-pool-oom.sh
>
> sashiko-bot report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [Severity: Critical]
> This is a pre-existing issue, but further down in backlog_store(), is it
> possible for mddev_create_serial_pool() to fail silently?
>
> drivers/md/md-bitmap.c:backlog_store() {
>      ...
>      } else if (backlog && !mddev->serial_info_pool) {
>          /* serial_info_pool is needed since backlog is not zero */
>          rdev_for_each(rdev, mddev)
>              mddev_create_serial_pool(mddev, rdev);
>      }
>      ...
> }
>
> Since mddev_create_serial_pool() returns void, it hides memory allocation
> failures. If it fails for a disk in this loop, that device is left withou=
t
> initialization. Does this silently bypass write-behind serialization for
> that disk, leading to overlapping writes and silent data corruption?
>
> Similarly, if MD_SERIALIZE_POLICY is active, check_and_add_serial() in
> drivers/md/raid1.c will unconditionally dereference rdev->serial:
>
>      int idx =3D sector_to_idx(r1_bio->sector);
>      struct serial_in_rdev *serial =3D &rdev->serial[idx];
>      struct serial_info *head_si;
>
>      spin_lock_irqsave(&serial->serial_lock, flags);
>
> Can this cause a NULL pointer dereference for devices that failed
> initialization?

There is a per rdev flag CollisionCheck for protection, I don't think there=
 will
be NULL pointer dereference.

>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/md-bitmap.c | 20 +++++++++++++++-----
>   drivers/md/md.c        | 33 ++++++++++++++++++++++-----------
>   drivers/md/md.h        |  2 +-
>   drivers/md/raid1.c     |  9 +++++++--
>   4 files changed, 45 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 6d495cdf3fb2..e0510e3cae3e 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2211,12 +2211,15 @@ static int bitmap_load(struct mddev *mddev)
>   	struct md_rdev *rdev;
>  =20
>   	if (!bitmap)
>   		goto out;
>  =20
> -	rdev_for_each(rdev, mddev)
> -		mddev_create_serial_pool(mddev, rdev);
> +	rdev_for_each(rdev, mddev) {
> +		err =3D mddev_create_serial_pool(mddev, rdev);
> +		if (err)
> +			goto out;
> +	}
>  =20
>   	if (mddev_is_clustered(mddev))
>   		mddev->cluster_ops->load_bitmaps(mddev, mddev->bitmap_info.nodes);
>  =20
>   	/* Clear out old bitmap info first:  Either there is none, or we
> @@ -2868,18 +2871,25 @@ backlog_store(struct mddev *mddev, const char *bu=
f, size_t len)
>   		/* serial_info_pool is not needed if backlog is zero */
>   		if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
>   			mddev_destroy_serial_pool(mddev, NULL);
>   	} else if (backlog && !mddev->serial_info_pool) {
>   		/* serial_info_pool is needed since backlog is not zero */
> -		rdev_for_each(rdev, mddev)
> -			mddev_create_serial_pool(mddev, rdev);
> +		rdev_for_each(rdev, mddev) {
> +			rv =3D mddev_create_serial_pool(mddev, rdev);
> +			if (rv) {
> +				mddev->bitmap_info.max_write_behind =3D old_mwb;
> +				mddev_destroy_serial_pool(mddev, NULL);
> +				goto out;
> +			}
> +		}
>   	}
>   	if (old_mwb !=3D backlog)
>   		bitmap_update_sb(mddev->bitmap);
>  =20
> +out:
>   	mddev_unlock_and_resume(mddev);
> -	return len;
> +	return rv ?: len;
>   }
>  =20
>   static struct md_sysfs_entry bitmap_backlog =3D
>   __ATTR(backlog, S_IRUGO|S_IWUSR, backlog_show, backlog_store);
>  =20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 25e06f088dc1..048ffd28869b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -228,18 +228,19 @@ static int rdev_need_serial(struct md_rdev *rdev)
>   /*
>    * Init resource for rdev(s), then create serial_info_pool if:
>    * 1. rdev is the first device which return true from rdev_enable_seria=
l.
>    * 2. rdev is NULL, means we want to enable serialization for all rdevs=
.
>    */
> -void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
> +int mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
>   {
>   	int ret =3D 0;
>   	unsigned int noio_flags;
>  =20
>   	if (rdev && !rdev_need_serial(rdev) &&
> -	    !test_bit(CollisionCheck, &rdev->flags))
> -		return;
> +	    !test_bit(CollisionCheck, &rdev->flags) &&
> +	    !test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
> +		return 0;
>  =20
>   	noio_flags =3D memalloc_noio_save();
>   	if (!rdev)
>   		ret =3D rdevs_init_serial(mddev);
>   	else
> @@ -248,18 +249,22 @@ void mddev_create_serial_pool(struct mddev *mddev, =
struct md_rdev *rdev)
>   		goto out;
>  =20
>   	if (mddev->serial_info_pool =3D=3D NULL) {
>   		mddev->serial_info_pool =3D
>   			mempool_create_kmalloc_pool(NR_SERIAL_INFOS,
> -						sizeof(struct serial_info));
> +						    sizeof(struct serial_info));
>   		if (!mddev->serial_info_pool) {
> +			if (rdev)
> +				rdev_uninit_serial(rdev);
>   			rdevs_uninit_serial(mddev);
>   			pr_err("can't alloc memory pool for serialization\n");
> +			ret =3D -ENOMEM;
>   		}
>   	}
>   out:
>   	memalloc_noio_restore(noio_flags);
> +	return ret;
>   }
>  =20
>   /*
>    * Free resource from rdev(s), and destroy serial_info_pool under condi=
tions:
>    * 1. rdev is the last device flaged with CollisionCheck.
> @@ -2605,12 +2610,15 @@ static int bind_rdev_to_array(struct md_rdev *rde=
v, struct mddev *mddev)
>   	strreplace(b, '/', '!');
>  =20
>   	rdev->mddev =3D mddev;
>   	pr_debug("md: bind<%s>\n", b);
>  =20
> -	if (mddev->raid_disks)
> -		mddev_create_serial_pool(mddev, rdev);
> +	if (mddev->raid_disks) {
> +		err =3D mddev_create_serial_pool(mddev, rdev);
> +		if (err)
> +			return err;
> +	}
>  =20
>   	if ((err =3D kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
>   		goto fail;
>  =20
>   	/* failure here is OK */
> @@ -3118,13 +3126,15 @@ state_store(struct md_rdev *rdev, const char *buf=
, size_t len)
>   				md_new_event();
>   			}
>   		}
>   	} else if (cmd_match(buf, "writemostly")) {
>   		set_bit(WriteMostly, &rdev->flags);
> -		mddev_create_serial_pool(rdev->mddev, rdev);
> -		need_update_sb =3D true;
> -		err =3D 0;
> +		err =3D mddev_create_serial_pool(rdev->mddev, rdev);
> +		if (err)
> +			clear_bit(WriteMostly, &rdev->flags);
> +		else
> +			need_update_sb =3D true;
>   	} else if (cmd_match(buf, "-writemostly")) {
>   		mddev_destroy_serial_pool(rdev->mddev, rdev);
>   		clear_bit(WriteMostly, &rdev->flags);
>   		need_update_sb =3D true;
>   		err =3D 0;
> @@ -5943,12 +5953,13 @@ serialize_policy_store(struct mddev *mddev, const=
 char *buf, size_t len)
>   		err =3D -EINVAL;
>   		goto unlock;
>   	}
>  =20
>   	if (value) {
> -		mddev_create_serial_pool(mddev, NULL);
> -		set_bit(MD_SERIALIZE_POLICY, &mddev->flags);
> +		err =3D mddev_create_serial_pool(mddev, NULL);
> +		if (!err)
> +			set_bit(MD_SERIALIZE_POLICY, &mddev->flags);
>   	} else {
>   		mddev_destroy_serial_pool(mddev, NULL);
>   		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
>   	}
>   unlock:
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 76488cd9e81e..e6ea0cc3669a 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -959,11 +959,11 @@ extern void mddev_resume(struct mddev *mddev);
>   extern void md_idle_sync_thread(struct mddev *mddev);
>   extern void md_frozen_sync_thread(struct mddev *mddev);
>   extern void md_unfrozen_sync_thread(struct mddev *mddev);
>  =20
>   extern void md_update_sb(struct mddev *mddev, int force);
> -extern void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev=
 *rdev);
> +extern int mddev_create_serial_pool(struct mddev *mddev, struct md_rdev =
*rdev);
>   extern void mddev_destroy_serial_pool(struct mddev *mddev,
>   				      struct md_rdev *rdev);
>   struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
>   struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
>  =20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 5b9368bd9e70..ef3812806f30 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -90,11 +90,11 @@ static int check_and_add_serial(struct md_rdev *rdev,=
 struct r1bio *r1_bio,
>   static void wait_for_serialization(struct md_rdev *rdev, struct r1bio *=
r1_bio)
>   {
>   	struct mddev *mddev =3D rdev->mddev;
>   	struct serial_info *si;
>  =20
> -	if (WARN_ON(!mddev->serial_info_pool))
> +	if (WARN_ON(!mddev->serial_info_pool || !rdev->serial))
>   		return;
>   	si =3D mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
>   	INIT_LIST_HEAD(&si->waiters);
>   	INIT_LIST_HEAD(&si->list_node);
>   	init_completion(&si->ready);
> @@ -109,11 +109,16 @@ static void remove_serial(struct md_rdev *rdev, sec=
tor_t lo, sector_t hi)
>   	struct serial_info *si, *iter_si;
>   	unsigned long flags;
>   	int found =3D 0;
>   	struct mddev *mddev =3D rdev->mddev;
>   	int idx =3D sector_to_idx(lo);
> -	struct serial_in_rdev *serial =3D &rdev->serial[idx];
> +	struct serial_in_rdev *serial;
> +
> +	if (WARN_ON(!mddev->serial_info_pool || !rdev->serial))
> +		return;
> +
> +	serial =3D &rdev->serial[idx];
>  =20
>   	spin_lock_irqsave(&serial->serial_lock, flags);
>   	for (si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
>   	     si; si =3D raid1_rb_iter_next(si, lo, hi)) {
>   		if (si->start =3D=3D lo && si->last =3D=3D hi) {

--=20
Thanks,
Kuai
