Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00664369A
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 19:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781984647; cv=none; b=dmSv7PIVCst+ftY8jDc+ExPxMX07/DQ2rKzo39mdfN+jPIR4CUyhQ6Fph19mJAoe7KRojOCzF+DfI/kXUFlEwM2ldQ8Cl9rmGLEya7n/Ye8aiyRf/jfwEQTb7oM2hZ5bLm/mebviqjnxTmHQJ67Wan/wv/aK4ZN2lSF5yd7jh9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781984647; c=relaxed/simple;
	bh=lRgJVCxY5tJruMD5EHGmasfgRnAshOV5FyHZPORa9eg=;
	h=From:Date:Content-Type:Message-Id:Mime-Version:To:Cc:Subject:
	 References:In-Reply-To; b=QWd0yzr8upVrUe0qZimOkrJbyWON+Gmt2AXFdcckXxKN6fVYF8KBhg4Da1EbUSGh993UmYBEy5YbMlFqGQkPRHmgTbBpuv6kOr5LejKQ7X7kwE8xn0yyzXS5BW7jbC6O/K3dlbIid+G7KtGgBXFRat3gko/HnWt/DaqCPJjIY1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=BgVvstms; arc=none smtp.client-ip=209.127.231.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="BgVvstms"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781984632;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=v43EFWR5Ac3eq80QQw1siF8EqSCh1z7zdg8b1hi1my8=;
 b=BgVvstmsBdWAdHt8uWrp5t2omS1fKa495e5poQGVYkjn3nGC5I/WhPF0iDIJqK6AlCcR/G
 z1QdzaNE2YoyEXBxL/+ooBF1CR1HovdeF2kS9rWK5DdDPKn/yTijtvh0FNEqUT3fYJWzNu
 l4nA1IVFNP/OssvID2IEzD1J3iEWZMG1gd9/wBwpeGCIXz4MXKggt0CN8mGVaVtnr+gICl
 3suge8XoRipR4DhwEfwiO4/I66oN+ANCUfl0CPr1gATu4OUT+QYBQOHe0finV4iNEhtc0T
 1opyGqzTMHNrRuZA6z7EFeYlDJMlcM5nCA7JXMRycvgTh/YRRAxIcaSVBbL8BQ==
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 21 Jun 2026 03:43:47 +0800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 19:43:50 +0000
Reply-To: yukuai@fygo.io
Message-Id: <9919b1ec-66ca-4f91-af58-fdc34c0f8273@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a36ed77+830bd4+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] md: suspend array before raid10 reshape via sync_action
References: <20260603035925.217847-1-chencheng@fnnas.com> <20260603035925.217847-2-chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260603035925.217847-2-chencheng@fnnas.com>

Hi,

=E5=9C=A8 2026/6/3 11:59, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> The sync_action=3Dreshape path currently enters mddev_start_reshape() wit=
h
> reconfig_mutex held but without suspending the array first. For raid10,
> that means raid10_start_reshape() has to drop reconfig_mutex and reacquir=
e
> the array through mddev_suspend_and_lock_nointr() before it can safely
> switch geometry-dependent state.
>
> Use mddev_suspend_and_lock() for ACTION_RESHAPE in action_store(), so
> the sysfs reshape path reaches mddev_start_reshape() with the array
> already suspended and locked.
>
> Other sync_action operations keep using mddev_lock() unchanged.
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/md.c | 22 +++++++++++++++++-----
>   1 file changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 096bb64e87bd..5bc937e149ac 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5256,30 +5256,39 @@ static int mddev_start_reshape(struct mddev *mdde=
v)
>  =20
>   static ssize_t
>   action_store(struct mddev *mddev, const char *page, size_t len)
>   {
>   	int ret;
> +	bool suspended =3D false;
>   	enum sync_action action;
>  =20
>   	if (!mddev->pers || !mddev->pers->sync_request)
>   		return -EINVAL;
>  =20
> +	action =3D md_sync_action_by_name(page);
>   retry:
>   	if (work_busy(&mddev->sync_work))
>   		flush_work(&mddev->sync_work);
>  =20
> -	ret =3D mddev_lock(mddev);
> +	if (action =3D=3D ACTION_RESHAPE) {
> +		ret =3D mddev_suspend_and_lock(mddev);

suspend during retry is too heavy. Please move suspend above retry.

> +		suspended =3D true;
> +	} else {
> +		ret =3D mddev_lock(mddev);
> +		suspended =3D false;
> +	}
>   	if (ret)
>   		return ret;
>  =20
>   	if (work_busy(&mddev->sync_work)) {
> -		mddev_unlock(mddev);
> +		if (suspended)
> +			mddev_unlock_and_resume(mddev);
> +		else
> +			mddev_unlock(mddev);
>   		goto retry;
>   	}
>  =20
> -	action =3D md_sync_action_by_name(page);
> -
>   	/* TODO: mdadm rely on "idle" to start sync_thread. */
>   	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
>   		switch (action) {
>   		case ACTION_FROZEN:
>   			md_frozen_sync_thread(mddev);
> @@ -5344,11 +5353,14 @@ action_store(struct mddev *mddev, const char *pag=
e, size_t len)
>   	md_wakeup_thread(mddev->thread);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
>   	ret =3D len;
>  =20
>   out:
> -	mddev_unlock(mddev);
> +	if (suspended)
> +		mddev_unlock_and_resume(mddev);
> +	else
> +		mddev_unlock(mddev);
>   	return ret;
>   }
>  =20
>   static struct md_sysfs_entry md_scan_mode =3D
>   __ATTR_PREALLOC(sync_action, S_IRUGO|S_IWUSR, action_show, action_store=
);

--=20
Thanks,
Kuai
