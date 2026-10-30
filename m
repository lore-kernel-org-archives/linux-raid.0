Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793349359;
	b=Dj42aysmehyb0JzxK5ztXejepA7qkLffjqe0ASpyTqIpcd+SkxXbSg/lYeqcYormWInM
	 GrslyqA+or4xUpuk7EuNXZ6Qb66anLLVfmXb/JhoB+X7B9MEXzQU1bYZCCigkkMBAxw1l
	 WgA9sa4StjP5L7KvmMjZpzX6iz4lRcy5HXySyw1+dpw6Rdq1toakltSa0L6C/TP4Sziys
	 HcrYFUSZGnd6rgqLVTVTn2uol56Ei9wOJdHp/pJmKO22Z1qpoqC3+u+urm/x9TLwoM1cd
	 7T/NQSMAHy+Ehde/5zyh6WGbMSvz9xKid1TRUJjuKhBYfzgw7LPTOgZ9XdXU8ZyV/hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793349359;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=6pg7wDugZYCIDD/HeApg4u2+Ts4evhIA12x8FkAfU3Y=;
	b=18Kx85vvYkqEyQ8PBNr9K32FCdEbHc6jeGCWZUTbd9OJTQdXI0gZ/aIdaoQcBo5TDUEm
	 Oeff7dxziIOT+bgjXKTt/8iXysJF1PAVMkzDgoAI587QDTT449rUnhDb49dI+MHU2epqM
	 teagkDFplXjSlElwqjAHrUsfkmN5i8QvoMrYvvayNyS6Rsv++q6OE1yruqw+Yt3il/RTU
	 9GrEaSeOHcLnNhqdbbTqL1I0fRhMG6zPfS+IC/qi05Qid0lqPU5zL5X2kDPRIKgr0Brb0
	 79VN3dPxnSP4oNmorgfLouPIMd70UXhliKw6xdiz6mgSP5htRpKzyLZarCC0C6jKLNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wkXCtxi4;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A58660A260F
	for <linux-raid@vger.kernel.org>; Fri, 30 Oct 2026 08:35:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A58660A260F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wkXCtxi4
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48c4be28b82so422962f8f.2
        for <linux-raid@vger.kernel.org>; Fri, 30 Oct 2026 01:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793349356; x=1793954156; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6pg7wDugZYCIDD/HeApg4u2+Ts4evhIA12x8FkAfU3Y=;
        b=wkXCtxi4YR73VPNWEut6SoWwXKzb3ZHZ8TsssLi83Rt/PANWFoUUxkMGTI6CX6nFsF
         vfT6JPYPX6eFifNUW1rzQxYQZbeGpvR9FfQfG+g/8FCLuudZt5ii2wm9X7BM/mZ/oV4D
         /G2fHqb98NmJtGMMPAWVGTLz+5rG616Zc/EgtFfbWUSMxiCHHpNUW5MwbM9zFTOvMytd
         mGrqJcr2qDhZpXEyhpN6bEMEYBvWJIttuJzqet2Bs4e+iZx4ovh7NBoRGP+oRPO4L/Ff
         t70xlndJe4YBjhxVe0ikiPCDjoOj3YP6QeK4Jt8FVypL34/deNFwO/Zg6tSZsbu6EB+e
         pjww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793349356; x=1793954156;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6pg7wDugZYCIDD/HeApg4u2+Ts4evhIA12x8FkAfU3Y=;
        b=xSoq9RP5C02BoE4OxDHmcQ5WLpDxdGRDDC7mqSK2XbwAGnWyhSUVImR/Zo4+zPoLdG
         6bo0nng30nly10YIEyaOpEvQQ4DQPrG4Z6LI4qqsUJz+5ZB01tDq3bjCbho1j8/8HFxh
         Dpc3OPqjNg7+/xLtJ0leLlVN53HFDChwuaTQphIjpb3Lhvm0nKUcRLBEhSZCGcTADV1d
         e+yd+dohEAX0l7AiwKiaD6DNMuo6dgpe/4ZAFBERg2PRsim8Nwk3iWGhHC5HmccpH76E
         ioKGoLwmoZ7GWW7HZ0ZQren7HJ8TXQPAYLLY1ChLa0OCcBu8t1ya9KgqfPjB31lP2t2Z
         XTUw==
X-Gm-Message-State: AFq9FYIn2FIIDU7U+sj9FWx8VnXObAHPyM+14QR3fER3GINxBK1iOz7w
	G1039+FLE3XTqw2opTM8XdymKtJf7hPYZWObASOSfBCdGwH11RMxsKu3
X-Gm-Gg: AYBFou1+BrDDKMe+DT7ikdCtsiVKk7JNhbCAzzcwm2CMtk8uVchHMmaPpWz3Xwn23ex
	CyQWJFUe3+OoQGjrxFKS1kdt+74Fo8l24elg5qCNv1sbcjX9Q/Un6CewmUvKxjR1AkTYUHmR8an
	kPU1Rh3DVlZfPlQFzNfjAvJj8C20/EVtWTgbrKxfLI5HPT55jCrB8pCKmxVlgC6qOuJj0PQs6oR
	BaEJRs8vD/flvhXCelnMRAemdqBeZjAtWkRBHtu2/lJ41aJPK8ElyG75wnJmuDDma8J4G6J3AOq
	EdXOPq2GE9FZk3a7N6lsIx+U4c+lh9AHkNqnwlK9gDzafrs0dR3APIby6elbnLliPlof9pVYcXX
	vDMBOsLeeKGYlCNYFE9NaS6U+cIDRZK8dMfv+msbcRRKwg1TfL1V3CzzCB3D0R9QhNy2KtWGTgS
	phd3aM+8P0AE4Pg7IvgcfxaUgnEhgiBSm/v9WuyC2M5jFtZWo735n1GNwHJPn7Yh5MTiMKEOaF4
	fU0Bb4jj1wNzYcGHOeOrWISjpitRi+dACm/uBxHpoxuEIuoIZiqWer8Ge2UL53fvHL5/TyGJTmb
	8JmH8Y4IcW9IPTWbouN763xy+M41g9NmhzKKaYUVlQTtJGV7HKL4OTXoqtzzLiHp
X-Received: by 2002:a05:6000:4007:b0:48e:6812:5ef1 with SMTP id ffacd0b85a97d-48e6e4f55f9mr4243993f8f.25.1793349355302;
        Fri, 30 Oct 2026 01:35:55 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([195.72.110.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b728ddsm1971263f8f.9.2026.10.30.01.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 01:35:54 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Subject: Re: [RFC PATCH v5 4/4] md: add a control device for array management
In-Reply-To: <sashiko-outbox-189939@kernel.org>
References: <20261029202209.1422567-1-abd.masalkhi@gmail.com>
 <20261029202209.1422567-5-abd.masalkhi@gmail.com>
 <sashiko-outbox-189939@kernel.org>
Date: Fri, 30 Oct 2026 09:35:52 +0100
Message-ID: <m2wlqz1t7b.fsf@gmail.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Kuai,

On Thu, Oct 29, 2026 at 20:48 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 7 potential issu=
e(s) to consider:
> - [Critical] md: unlocked set_disk_faulty() call in mdctl_ioctl() races w=
ith __md_stop()
> - [High] md: missing MD_CLOSING check in mdctl_find_mddev() and mdctl_ioc=
tl()
> - [High] md: missing state revalidation after lock drop in mdctl_ioctl()
> - [Medium] md: MD_CTL_STOP_ARRAY with MD_CTL_RO_FLAG returns -EINVAL on i=
nactive array
> - [Medium] md: mdctl_get_mddev_uuid() and mdctl_lookup_array() use non-na=
tive or stale uuid
> - [Medium] md: tautological MINOR() check and u64 md_dev truncation in md=
ctl_find_mddev()
> - [Medium] md: race between md_alloc() kobject_add() failure and mdctl_fi=
nd_mddev()
> --
>
> commit a0c97489b840f0bb7566f8fcc5073f039699c2e5
> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>
> md: add a control device for array management
>
> This commit introduces a /dev/md-control misc device to allow configuring,
> querying, and stopping MD arrays by name, UUID, or device number without
> opening the MD block device directly. It also moves disks_mutex to file
> scope to synchronize control device lookups with md_alloc().
>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 3b4497b615cf0..a1425b5e6b3ec 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>
> [ ... ]
>
>> @@ -8601,6 +8607,618 @@ static int md_compat_ioctl(struct block_device *=
bdev, blk_mode_t mode,
>>  }
>>  #endif /* CONFIG_COMPAT */
>>=20=20
>> +static struct mddev *mdctl_get_mddev_dev(dev_t dev)
>> +{
>> +	struct mddev *mddev, *ret =3D ERR_PTR(-EINVAL);
>> +
>> +	if (MINOR(dev) >=3D (1 << MINORBITS))
>> +		return ret;
>
> [ ... ]
>
>> +static struct mddev *mdctl_get_mddev_uuid(const char *uuid)
>> +{
>> +	struct mddev *mddev, *ret =3D ERR_PTR(-ENODEV);
>> +
>> +	spin_lock(&all_mddevs_lock);
>> +	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
>> +		if (memcmp(mddev->uuid, uuid, sizeof(mddev->uuid)) =3D=3D 0) {
>> +			ret =3D mddev_get(mddev);
>> +			if (!ret)
>> +				ret =3D ERR_PTR(-ENODEV);
>> +			break;
>> +		}
>> +	}
>> +	spin_unlock(&all_mddevs_lock);
>> +
>> +	return ret;
>> +}
>
> [Severity: Medium]
> Can mdctl_get_mddev_uuid() and mdctl_lookup_array() match or report a
> non-native or stale mddev->uuid?
>
> The commit description notes that UUID lookup is only available for arrays
> with native metadata, but there are two places where mddev->uuid is
> populated on arrays that do not have active persistent native metadata:
>
> 1. In md_set_array_info(), get_random_bytes(mddev->uuid, 16) populates
>    mddev->uuid even when info->not_persistent is set (!mddev->persistent).
>    As a result, mdctl_get_mddev_uuid() matches non-persistent arrays and
>    mdctl_lookup_array() copies a non-zero UUID to userspace for them.
>

In the case of external metadata, wouldn't the internal UUID differ
from the real one? Shouldn't get_random_bytes() be called only for
native metadata?

> 2. When an array is stopped via do_md_stop() -> md_clean(), md_clean()
>    resets mddev->raid_disks and mddev->persistent to 0, but never clears
>    mddev->uuid:
>
> drivers/md/md.c:md_clean() {
> 	mddev->array_sectors =3D 0;
> 	...
> 	mddev->raid_disks =3D 0;
> 	...
> 	mddev->persistent =3D 0;
> }
>
> If the stopped mddev remains in all_mddevs (for example, while
> hold_active =3D=3D UNTIL_STOP or before delayed deletion completes),
> mdctl_get_mddev_uuid() will still match its stale mddev->uuid. Furthermor=
e,
> if an older mddev with MD_DELETED set is still on all_mddevs when the arr=
ay
> is re-assembled on a new mddev later in the list, mddev_get() will return
> NULL on the first match and mdctl_get_mddev_uuid() will break out of the
> loop and return -ENODEV instead of continuing to find the live mddev.
>
> Should mdctl_get_mddev_uuid() and mdctl_lookup_array() check
> mddev->persistent (and skip entries where mddev_get() fails), or should
> md_clean() also clear mddev->uuid?
>
>> +
>> +static struct mddev *mdctl_find_mddev(struct mdu_ioctl *md_ctl)
>> +{
>> +	struct mddev *ret =3D ERR_PTR(-EINVAL);
>> +
>> +	/*
>> +	 * md_alloc() adds a new mddev to all_mddevs before it creates the
>> +	 * gendisk. If creation fails. it frees the mddev directly, without
>> +	 * looking at ->active. All of this happens under disks_mutex.
>> +	 * Holding disks_mutex for the lookup means we only see mddevs that
>> +	 * md_alloc() has finished, so taking a reference is safe and every
>> +	 * mddev we find has a gendisk.
>> +	 */
>> +	mutex_lock(&disks_mutex);
>
> [Severity: Medium]
> Does holding disks_mutex in mdctl_find_mddev() prevent taking a reference=
 to
> an mddev when kobject_add() fails in md_alloc()?
>
> In md_alloc(), if kobject_add() fails, disks_mutex is unlocked before
> mddev_put() is called:
>
> drivers/md/md.c:md_alloc() {
> 	...
> 	error =3D kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md"=
);
> 	if (error) {
> 		mddev->hold_active =3D 0;
> 		mutex_unlock(&disks_mutex);
> 		mddev_put(mddev);
> 		return ERR_PTR(error);
> 	}
> }
>
> Because MD_DELETED is only set inside mddev_put() -> __mddev_put() when
> mddev->active drops to 0, a concurrent mdctl_ioctl() -> mdctl_find_mddev()
> can acquire disks_mutex right after md_alloc() unlocks it and call
> mddev_get(mddev), incrementing mddev->active from 1 to 2 before md_alloc()
> calls mddev_put(mddev).
>
> When md_alloc() then calls mddev_put(mddev), atomic_dec_and_lock() sees
> mddev->active drop from 2 to 1 and returns early without setting MD_DELET=
ED.
> If the racing mdctl_ioctl() runs MD_CTL_SET_ARRAY_INFO, md_set_array_info=
()
> sets mddev->ctime (and mddev->raid_disks), causing the subsequent
> mddev_put() in mdctl_ioctl() to also skip __mddev_put() deletion and leav=
ing
> an mddev without a sysfs kobject in all_mddevs.
>

Yes, i will fix this in the next version.

>> +
>> +	if (memchr_inv(md_ctl->md_uuid, 0, MD_UUID_LEN)) {
>> +		if (*md_ctl->md_name || md_ctl->md_dev) {
>> +			pr_err_ratelimited("md: only supply one of name, uuid or dev number\=
n");
>> +			goto out;
>> +		}
>> +		ret =3D mdctl_get_mddev_uuid(md_ctl->md_uuid);
>> +	} else if (*md_ctl->md_name) {
>> +		if (md_ctl->md_dev) {
>> +			pr_err_ratelimited("md: only supply one of name, uuid or dev number\=
n");
>> +			goto out;
>> +		}
>> +		ret =3D mdctl_get_mddev_name(md_ctl->md_name);
>> +	} else if (md_ctl->md_dev) {
>> +		ret =3D mdctl_get_mddev_dev(new_decode_dev(md_ctl->md_dev));
>> +	}
>
> [Severity: Medium]
> Can passing md_ctl->md_dev directly to new_decode_dev() silently truncate
> 64-bit device numbers, and is the MINOR(dev) check in mdctl_get_mddev_dev=
()
> reachable?
>
> In struct mdu_ioctl, md_dev is __u64, whereas new_decode_dev() takes a u3=
2.
> In 64-bit userspace, dev_t encodings (such as glibc makedev()) store
> minor[31:20] and major[31:12] in the upper 32 bits. Passing md_ctl->md_dev
> to new_decode_dev() without checking that it fits in u32 (or using
> huge_decode_dev()) discards the upper 32 bits, so a device number with
> minor =3D (1 << 20) decodes as minor 0 and aliases to md0 instead of fail=
ing
> with -EINVAL.
>
> In addition, in mdctl_get_mddev_dev():
>
> 	if (MINOR(dev) >=3D (1 << MINORBITS))
> 		return ret;
>
> MINOR(dev) is defined as ((unsigned int)((dev) & MINORMASK)) where MINORM=
ASK
> is ((1U << MINORBITS) - 1), so MINOR(dev) >=3D (1 << MINORBITS) is always
> false.
>
>> +
>> +out:
>> +	mutex_unlock(&disks_mutex);
>> +	return ret;
>> +}
>
> [ ... ]
>
>> +static long mdctl_ioctl(struct file *filp, uint cmd, ulong u)
>> +{
>
> [ ... ]
>
>> +	/* These commands do not need reconfig_mutex. */
>> +	err =3D -ENODEV;
>> +	switch (cmd) {
>> +	case MD_CTL_GET_ARRAY_INFO:
>> +		if (mddev_configured(mddev))
>> +			err =3D mdctl_get_array_info(mddev, arg);
>> +		goto out;
>> +
>> +	case MD_CTL_GET_DISK_INFO:
>> +		if (mddev_configured(mddev))
>> +			err =3D mdctl_get_disk_info(mddev, arg);
>> +		goto out;
>> +
>> +	case MD_CTL_GET_BITMAP_FILE:
>> +		err =3D get_bitmap_file(mddev, arg);
>> +		goto out;
>> +
>> +	case MD_CTL_SET_DISK_FAULTY:
>> +		err =3D set_disk_faulty(mddev, new_decode_dev(md_ctl.arg));
>> +		goto out;
>> +	}
>
> [Severity: Critical]
> Can calling set_disk_faulty() here without reconfig_mutex or an opener
> reference race with __md_stop() and trigger a use-after-free or NULL poin=
ter
> dereference?
>
> In the legacy block device md_ioctl() path, the caller holds /dev/mdX ope=
n,
> so mddev->openers >=3D 1 prevents another task from stopping the array via
> STOP_ARRAY. Through /dev/md-control, mdctl_ioctl() does not open the block
> device, so mddev->openers is 0 and MD_CTL_SET_DISK_FAULTY runs without
> reconfig_mutex.
>

Yes, The old path is not fully safe either. after fork(), both tasks
share the same open file, so one task can stop the array with STOP_ARRAY
while the other sets a disk faulty.

I will fix poth.

> If another task concurrently stops the array via MD_CTL_STOP_ARRAY (or wr=
ites
> "inactive" or "clear" to sysfs array_state), do_md_stop() calls
> __md_stop(mddev) before export_array(mddev) unbinds the rdevs:
>
> drivers/md/md.c:__md_stop() {
> 	...
> 	spin_lock(&mddev->lock);
> 	mddev->pers =3D NULL;
> 	spin_unlock(&mddev->lock);
> 	if (mddev->private)
> 		pers->free(mddev, mddev->private);
> 	mddev->private =3D NULL;
> 	put_pers(pers);
> }
>
> Concurrently, set_disk_faulty() only takes rcu_read_lock(), finds the sti=
ll
> bound rdev via md_find_rdev_rcu(), and calls md_error(mddev, rdev):
>
> drivers/md/md.c:md_error() {
> 	...
> 	if (!mddev->pers || !mddev->pers->error_handler)
> 		return;
> 	mddev->pers->error_handler(mddev, rdev);
>
> 	if (mddev->pers->head.id =3D=3D ID_RAID0 ||
> 	    mddev->pers->head.id =3D=3D ID_LINEAR)
> 		return;
> 	...
> }
>
> Because __md_stop() clears mddev->pers and immediately frees mddev->priva=
te
> (such as struct r1conf, r10conf, or r5conf) without waiting for an RCU gr=
ace
> period or holding reconfig_mutex against set_disk_faulty(), md_error() and
> mddev->pers->error_handler() can dereference a NULL mddev->pers or a freed
> mddev->private.
>
>> +
>> +	if (cmd =3D=3D MD_CTL_STOP_ARRAY) {
>> +		/* Need to flush page cache, and ensure no openers */
>> +		err =3D mddev_set_closing_and_sync_blockdev(mddev, 0);
>> +		if (err)
>> +			goto out;
>> +
>> +		closing =3D true;
>> +	}
>> +
>> +	if (!md_is_rdwr(mddev))
>> +		flush_work(&mddev->sync_work);
>> +
>> +	suspend =3D mdctl_ioctl_need_suspend(cmd);
>> +	err =3D suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
>> +	if (err) {
>> +		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
>> +			 err, cmd);
>> +		goto out;
>> +	}
>
> [Severity: High]
> Does mdctl_ioctl() or mdctl_find_mddev() need to check whether MD_CLOSING=
 is
> set on mddev->flags?
>
> When legacy_async_del_gendisk is true (the default), stopping an array wh=
ere
> mddev->hold_active =3D=3D 0 via do_md_stop(mddev, 0) -> md_clean() leaves
> MD_CLOSING set on mddev->flags without setting MD_DELETED:
>
> drivers/md/md.c:md_clean() {
> 	...
> 	if (legacy_async_del_gendisk && mddev->hold_active) {
> 		clear_bit(MD_CLOSING, &mddev->flags);
> 	} else {
> 		/* if UNTIL_STOP is set, it's cleared here */
> 		mddev->hold_active =3D 0;
> 		/* Don't clear MD_CLOSING, or mddev can be opened again. */
> 		mddev->flags &=3D BIT_ULL_MASK(MD_CLOSING);
> 	}
> }
>
> For legacy block device ioctls, md_open() checks test_bit(MD_CLOSING,
> &mddev->flags) and returns -ENODEV, preventing any new ioctls from
> reconfiguring the array before mddev_put() -> __mddev_put() sets MD_DELET=
ED
> and queues del_work.
>
> However, mdctl_find_mddev() -> mddev_get() and mddev_lock() only check
> MD_DELETED, not MD_CLOSING. If a concurrent task issues MD_CTL_SET_ARRAY_=
INFO
> or MD_CTL_ADD_NEW_DISK via /dev/md-control and grabs a reference in
> mdctl_find_mddev() before the stopping task's mddev_put() drops
> mddev->active to 0, __mddev_put() will not run when the stop finishes. The
> second task then locks the mddev and populates mddev->ctime,
> mddev->raid_disks, or mddev->disks while MD_CLOSING is still set. When
> mddev_put() later drops mddev->active to 0, __mddev_put() sees that the
> mddev is no longer empty and returns early without deleting it:
>
> drivers/md/md.c:__mddev_put() {
> 	if (mddev->raid_disks || !list_empty(&mddev->disks) ||
> 	    mddev->ctime || mddev->hold_active)
> 		return;
> 	...
> }
>
> This leaves MD_CLOSING permanently set on the mddev, leaking the mddev and
> its bound rdevs and causing subsequent md_open() calls to fail with -ENOD=
EV
> and MD_CTL_STOP_ARRAY calls to fail with -EBUSY.
>

Yes, I will fix this in the next version.

>> +	if (suspend)
>> +		noio_flags =3D memalloc_noio_save();
>> +
>> +	/*
>> +	 * Commands querying/configuring an existing array.
>> +	 *
>> +	 * If the array is not initialised yet, check of the command requires
>> +	 * the array to be initialised.
>> +	 */
>> +	if (!mddev_configured(mddev) && mdctl_ioctl_need_config(cmd, flags)) {
>> +		err =3D -ENODEV;
>> +		goto unlock;
>> +	}
>> +
>> +	/*
>> +	 * Commands even a read-only array can execute:
>> +	 */
>> +	switch (cmd) {
>> +	case MD_CTL_SET_ARRAY_INFO:
>> +		err =3D mdctl_set_array_info(mddev, arg);
>> +		goto unlock;
>> +
>> +	case MD_CTL_RESTART_ARRAY_RW:
>> +		err =3D restart_array(mddev);
>> +		goto unlock;
>> +
>> +	case MD_CTL_STOP_ARRAY:
>> +		err =3D -EINVAL;
>> +		if (!flags)
>> +			err =3D do_md_stop(mddev, 0);
>> +		else if (flags =3D=3D MD_CTL_RO_FLAG && mddev->pers)
>> +			err =3D md_set_readonly(mddev);
>> +		goto unlock;
>
> [Severity: Medium]
> What happens when MD_CTL_STOP_ARRAY is called with flags =3D=3D MD_CTL_RO=
_FLAG
> on a configured array that is not currently running (mddev->pers =3D=3D N=
ULL)?
>
> In the legacy md_ioctl() handler, err is initialized to 0 before the swit=
ch:
>
> drivers/md/md.c:md_ioctl() {
> 	...
> 	case STOP_ARRAY_RO:
> 		if (mddev->pers)
> 			err =3D md_set_readonly(mddev);
> 		goto unlock;
> }
>
> so STOP_ARRAY_RO on a configured but inactive array succeeds with 0 (and
> clears mddev->hold_active =3D=3D UNTIL_IOCTL at unlock).
>
> In mdctl_ioctl(), err is set to -EINVAL before the if/else chain, so when
> flags =3D=3D MD_CTL_RO_FLAG and mddev->pers is NULL, neither branch is ta=
ken and
> mdctl_ioctl() returns -EINVAL.
>

This is intentional. STOP_ARRAY_RO returns 0 for an array that is not
running, although nothing was switched to read-only.

>> +
>> +	case MD_CTL_HOT_REMOVE_DISK:
>> +		err =3D hot_remove_disk(mddev, new_decode_dev(md_ctl.arg));
>> +		goto unlock;
>> +
>> +	case MD_CTL_ADD_NEW_DISK:
>> +		/* We can support ADD_NEW_DISK on read-only arrays
>> +		 * only if we are re-adding a preexisting device.
>> +		 * So require mddev->pers and MD_DISK_SYNC.
>> +		 */
>> +		if (mddev->pers) {
>> +			struct mdu_disk_info64 info;
>> +
>> +			if (copy_from_user(&info, arg, sizeof(info)))
>> +				err =3D -EFAULT;
>> +			else if (!(info.state & (1 << MD_DISK_SYNC)))
>> +				/* Need to clear read-only for this */
>> +				break;
>> +			else
>> +				err =3D md_add_new_disk(mddev, &info);
>> +			goto unlock;
>> +		}
>> +		break;
>> +	}
>> +
>> +	/*
>> +	 * The remaining ioctls are changing the state of the
>> +	 * superblock, so we do not allow them on read-only arrays.
>> +	 */
>> +	if (!md_is_rdwr(mddev) && mddev->pers) {
>> +		if (mddev->ro !=3D MD_AUTO_READ) {
>> +			err =3D -EROFS;
>> +			goto unlock;
>> +		}
>> +		mddev->ro =3D MD_RDWR;
>> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
>> +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>> +		/* mddev_unlock will wake thread */
>> +		/* If a device failed while we were read-only, we
>> +		 * need to make sure the metadata is updated now.
>> +		 */
>> +		if (test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags)) {
>> +			mddev_unlock(mddev);
>> +			wait_event(mddev->sb_wait,
>> +				   !test_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags) &&
>> +				   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
>> +			mddev_lock_nointr(mddev);
>> +		}
>> +	}
>
> [Severity: High]
> Can the array be stopped and deleted while mdctl_ioctl() drops
> reconfig_mutex to wait on mddev->sb_wait here?
>
> In md_ioctl(), the caller holds the block device open (mddev->openers >=
=3D 1),
> which prevents a concurrent STOP_ARRAY from passing
> mddev_set_closing_and_sync_blockdev() while reconfig_mutex is dropped.
> In mdctl_ioctl(), the block device is not open (mddev->openers =3D=3D 0).
>
> When mdctl_ioctl() drops reconfig_mutex via mddev_unlock(mddev) and sleeps
> in wait_event(mddev->sb_wait, ...), a concurrent MD_CTL_STOP_ARRAY (which
> does not call mddev_suspend()) or a sysfs array_state write can acquire
> reconfig_mutex and run do_md_stop(mddev, 0). That stops the personality,
> exports all disks, clears mddev->sb_flags and mddev->raid_disks in
> md_clean(), sets MD_DELETED (when !legacy_async_del_gendisk), and in
> mddev_unlock() wakes mddev->sb_wait and deletes the gendisk.
>
> mdctl_ioctl() then wakes up, reacquires reconfig_mutex via
> mddev_lock_nointr(mddev) (which does not check MD_DELETED or MD_CLOSING),
> and proceeds into the switch below without revalidating that the array is
> still active or configured. For example, if cmd is MD_CTL_ADD_NEW_DISK,
> md_add_new_disk() will see mddev->raid_disks =3D=3D 0 and bind a new rdev=
 onto
> the stopped/deleted mddev, preventing __mddev_put() from freeing the mddev
> and leaving the rdev's block device claimed.
>
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029202209.14=
22567-1-abd.masalkhi@gmail.com?part=3D4

--=20
Best Regards,
Abd-Alrhman
