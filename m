Received: from sg-1-17.ptr.blmpb.com (sg-1-17.ptr.blmpb.com [118.26.132.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B1F329C64
	for <linux-raid@vger.kernel.org>; Tue, 28 Oct 2025 12:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761652922; cv=none; b=NhJe+XmN34zA1IziLk5g93ZZSfvBwKyPLA3ejhRyp8C99meJTffH6B28q4EAmmFNWhHJMQnx8Z8v6GcfHVVuLCLlPoXKW4OUlK64K5lv2BAfVY+G6PT0/UmsgsRYUw41/WDN8OHr5QAAHrzM2Ybmm8OS3WUl64VSY92H6a5PvL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761652922; c=relaxed/simple;
	bh=FqVdAvB7cJ3bEnfcXXz4afwcjFpV9Hal5X7e453syz8=;
	h=Cc:Subject:Mime-Version:References:From:Date:Content-Type:
	 In-Reply-To:To:Message-Id; b=d2TfYIUN6Yn7yc1qWpgJKmYnIAe+wiRhoXfTaxdhToeR9YPbOs6/L4paexSx0BalPH3dCkwB12qreNUuG1G4vP+SknW2x+rdQcOsrhleoxrFL5CqIfUtkCtkoliTxAyEig/lKNWAgOCoWEH+SF5iS/PmKPDUJ1Uu4k9OYLFz3qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=D4RnKXG4; arc=none smtp.client-ip=118.26.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="D4RnKXG4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1761652911;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=qrdpkSUzpkeuew8x0js4jD14VDEyFeMHTwoUeSVoFuI=;
 b=D4RnKXG4hIwCAhpR+Qh2Amn/J02yZp2vFSaxJnouVbxeS6j1U3VVioKuGnHcPSokH6QgOF
 wwnDb9ddvWpHAS0u3Uxj9luPlKi/8Q/0v4ct52uMNsA7Bccu4/CpAonrVxTD6ZEOhTd8AV
 Er57n3y/xkmyiw/vpDzv/jc5rHkRu5q+Xmi9GKnA8fJSTHU7+az/Kvf38TKxMo0fAQIOM3
 SYOGs2aO6Gc0LDDCs2gAROYYcB3CzWcMOkeSZrCT/3+MeLDNszHS+PyLAO1Q0s0RNvTfF1
 am5vVukzNksWmysz2+07C60iqQ656BMoNiL3Jwxm0/kBQlEy2z8kIlq/KIkY6A==
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, <linan666@huaweicloud.com>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: Re: [PATCH v7 2/4] md: init bioset in mddev_init
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251027072915.3014463-1-linan122@huawei.com> <20251027072915.3014463-3-linan122@huawei.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Tue, 28 Oct 2025 20:01:48 +0800
Content-Transfer-Encoding: quoted-printable
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Tue, 28 Oct 2025 20:01:47 +0800
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20251027072915.3014463-3-linan122@huawei.com>
X-Lms-Return-Path: <lba+26900b0ad+7d3938+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
To: <linan122@huawei.com>, <corbet@lwn.net>, <song@kernel.org>, 
	<hare@suse.de>, <xni@redhat.com>
Message-Id: <69829383-8212-473b-9346-d093d33f1d27@fnnas.com>

Hi,

=E5=9C=A8 2025/10/27 15:29, linan122@huawei.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> IO operations may be needed before md_run(), such as updating metadata
> after writing sysfs. Without bioset, this triggers a NULL pointer
> dereference as below:
>
>   BUG: kernel NULL pointer dereference, address: 0000000000000020
>   Call Trace:
>    md_update_sb+0x658/0xe00
>    new_level_store+0xc5/0x120
>    md_attr_store+0xc9/0x1e0
>    sysfs_kf_write+0x6f/0xa0
>    kernfs_fop_write_iter+0x141/0x2a0
>    vfs_write+0x1fc/0x5a0
>    ksys_write+0x79/0x180
>    __x64_sys_write+0x1d/0x30
>    x64_sys_call+0x2818/0x2880
>    do_syscall_64+0xa9/0x580
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>
> Reproducer
> ```
>    mdadm -CR /dev/md0 -l1 -n2 /dev/sd[cd]
>    echo inactive > /sys/block/md0/md/array_state
>    echo 10 > /sys/block/md0/md/new_level
> ```
>
> Fixes: d981ed841930 ("md: Add new_level sysfs interface")
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c | 74 +++++++++++++++++++++++++------------------------
>   1 file changed, 38 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f6fd55a1637b..51f0201e4906 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -730,6 +730,8 @@ static void mddev_clear_bitmap_ops(struct mddev *mdde=
v)
>  =20
>   int mddev_init(struct mddev *mddev)
>   {
> +	int err =3D 0;
> +
>   	if (!IS_ENABLED(CONFIG_MD_BITMAP))
>   		mddev->bitmap_id =3D ID_BITMAP_NONE;
>   	else
> @@ -741,8 +743,26 @@ int mddev_init(struct mddev *mddev)
>  =20
>   	if (percpu_ref_init(&mddev->writes_pending, no_op,
>   			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> -		percpu_ref_exit(&mddev->active_io);
> -		return -ENOMEM;
> +		err =3D -ENOMEM;
> +		goto exit_acitve_io;
> +	}
> +
> +	if (!bioset_initialized(&mddev->bio_set)) {
> +		err =3D bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVE=
CS);

mddev_init() can only be called once for one mddev, no need to test if bios=
et
is initialized here.

> +		if (err)
> +			goto exit_writes_pending;
> +	}
> +	if (!bioset_initialized(&mddev->sync_set)) {

same here.

> +		err =3D bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BV=
ECS);
> +		if (err)
> +			goto exit_bio_set;
> +	}
> +
> +	if (!bioset_initialized(&mddev->io_clone_set)) {

And here.

Thanks,
Kuai

> +		err =3D bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
> +				  offsetof(struct md_io_clone, bio_clone), 0);
> +		if (err)
> +			goto exit_sync_set;
>   	}
>  =20
>   	/* We want to start with the refcount at zero */
> @@ -773,11 +793,24 @@ int mddev_init(struct mddev *mddev)
>   	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
>  =20
>   	return 0;
> +
> +exit_sync_set:
> +	bioset_exit(&mddev->sync_set);
> +exit_bio_set:
> +	bioset_exit(&mddev->bio_set);
> +exit_writes_pending:
> +	percpu_ref_exit(&mddev->writes_pending);
> +exit_acitve_io:
> +	percpu_ref_exit(&mddev->active_io);
> +	return err;
>   }
>   EXPORT_SYMBOL_GPL(mddev_init);
>  =20
>   void mddev_destroy(struct mddev *mddev)
>   {
> +	bioset_exit(&mddev->bio_set);
> +	bioset_exit(&mddev->sync_set);
> +	bioset_exit(&mddev->io_clone_set);
>   	percpu_ref_exit(&mddev->active_io);
>   	percpu_ref_exit(&mddev->writes_pending);
>   }
> @@ -6393,29 +6426,9 @@ int md_run(struct mddev *mddev)
>   		nowait =3D nowait && bdev_nowait(rdev->bdev);
>   	}
>  =20
> -	if (!bioset_initialized(&mddev->bio_set)) {
> -		err =3D bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVE=
CS);
> -		if (err)
> -			return err;
> -	}
> -	if (!bioset_initialized(&mddev->sync_set)) {
> -		err =3D bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BV=
ECS);
> -		if (err)
> -			goto exit_bio_set;
> -	}
> -
> -	if (!bioset_initialized(&mddev->io_clone_set)) {
> -		err =3D bioset_init(&mddev->io_clone_set, BIO_POOL_SIZE,
> -				  offsetof(struct md_io_clone, bio_clone), 0);
> -		if (err)
> -			goto exit_sync_set;
> -	}
> -
>   	pers =3D get_pers(mddev->level, mddev->clevel);
> -	if (!pers) {
> -		err =3D -EINVAL;
> -		goto abort;
> -	}
> +	if (!pers)
> +		return -EINVAL;
>   	if (mddev->level !=3D pers->head.id) {
>   		mddev->level =3D pers->head.id;
>   		mddev->new_level =3D pers->head.id;
> @@ -6426,8 +6439,7 @@ int md_run(struct mddev *mddev)
>   	    pers->start_reshape =3D=3D NULL) {
>   		/* This personality cannot handle reshaping... */
>   		put_pers(pers);
> -		err =3D -EINVAL;
> -		goto abort;
> +		return -EINVAL;
>   	}
>  =20
>   	if (pers->sync_request) {
> @@ -6554,12 +6566,6 @@ int md_run(struct mddev *mddev)
>   	mddev->private =3D NULL;
>   	put_pers(pers);
>   	md_bitmap_destroy(mddev);
> -abort:
> -	bioset_exit(&mddev->io_clone_set);
> -exit_sync_set:
> -	bioset_exit(&mddev->sync_set);
> -exit_bio_set:
> -	bioset_exit(&mddev->bio_set);
>   	return err;
>   }
>   EXPORT_SYMBOL_GPL(md_run);
> @@ -6784,10 +6790,6 @@ static void __md_stop(struct mddev *mddev)
>   	mddev->private =3D NULL;
>   	put_pers(pers);
>   	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> -
> -	bioset_exit(&mddev->bio_set);
> -	bioset_exit(&mddev->sync_set);
> -	bioset_exit(&mddev->io_clone_set);
>   }
>  =20
>   void md_stop(struct mddev *mddev)
