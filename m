Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0FF3EA66
	for <linux-raid@vger.kernel.org>; Sun,  5 Jul 2026 07:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783237439; cv=none; b=I569TpBWjR/axZjvWk8FXVH8AehedVFBNZOcfyyFLOi8yM8Ab26H6/XtdxEaEf/mLFR0aR6E0eFIuwMq8zkarBmAxDAUix8LB8gh6rI2CqUJvyzmRBIxAzAqK3w4RDPlEj7OVF+BKDAFdBJb4bMKM7aMuGVexMbCmBS9W1U9+M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783237439; c=relaxed/simple;
	bh=rN3dPMR1JOuGrDzajdXQW25mKTmrGL7wUlUXLWNhazY=;
	h=From:Date:Content-Type:To:Subject:Message-Id:Mime-Version:Cc:
	 In-Reply-To:References; b=D83t8Sae+6F6SD3dtIh6mLskKChnhQNUKj59qXPrViXjeO9iawznXErwatO09mWWFLsWQQgWIxTpwJ8SJGQ8lyMLyM4z8yfeFPQX74rqSxOLLzEnhJJAkAXtgIZRk/DqUf7JRA32RY4tilZ9DBPXIle17cCgxKpoye3N7hP4aeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=PcidMJlj; arc=none smtp.client-ip=209.127.231.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="PcidMJlj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783237424;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ByyTgFPvFnt0YRsAseTZxMUjofdmbcKTLGTH5726mDg=;
 b=PcidMJlj/UAddQYv+4w0PaM+Q10WflrwVlR8rnowapDGtSMv8IQP3q0soREurXtpWHhnkc
 wMLOiaPKBUHyYcr6bxQfULu3qkuySKZPLyMIV6NgQUFFd121FvJY+fWam0t53SS8nl/LNu
 n9HMRA1DyjxOi93QLJxYWmfq+9gaK3b931HlAqLz9k5dQspQMJrkOTVrgf0lsgKIxKPXTh
 xixefblyeAeMMnMg17m1qbMdw8Xf/XxWDqv078E8uwUo8TMjYwZ72ZlU93rsVysSo6A+WT
 6ncrC0HE+tT0GAhMxN3rd3mAGi2znqtNEbVhhb9Zu1pD5Tx7n+K54HDpbuXAaA==
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 5 Jul 2026 15:43:38 +0800
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a4a0b2f+6b009c+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Subject: Re: [PATCH v6 1/3] md: suspend array when sync_action=reshape
Message-Id: <9fbba621-964d-4166-93f8-9fc01d56d698@fygo.io>
User-Agent: Mozilla Thunderbird
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sun, 05 Jul 2026 07:43:42 +0000
Cc: <linux-kernel@vger.kernel.org>
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <20260623123840.2521340-2-chencheng@fnnas.com>
References: <20260623123840.2521340-1-chencheng@fnnas.com> <20260623123840.2521340-2-chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable

Hi=EF=BC=8C

=E5=9C=A8 2026/6/23 20:38, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> raid10 needs to resize/swap r10bio_pool when reshape changes
> raid_disks, and, don't let new requests keep allocating r10bio
> objects from the old pool while that transition is in progress.
>
> suspend and lock array before mddev_start_reshape(), and resume
> it on exit.
>
> Other sync_action ops are unchanged.
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/md.c | 17 ++++++++++++-----
>   1 file changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 096bb64e87bd..1377c407614c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5261,25 +5261,29 @@ action_store(struct mddev *mddev, const char *pag=
e, size_t len)
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
> +	ret =3D (action =3D=3D ACTION_RESHAPE) ?
> +		mddev_suspend_and_lock(mddev) :
> +		mddev_lock(mddev);

I already suggestted in previous verions that suspend for retry is too
heavy, please suspend before retry.

>   	if (ret)
>   		return ret;
>  =20
>   	if (work_busy(&mddev->sync_work)) {
> -		mddev_unlock(mddev);
> +		if (action =3D=3D ACTION_RESHAPE)
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
> @@ -5344,11 +5348,14 @@ action_store(struct mddev *mddev, const char *pag=
e, size_t len)
>   	md_wakeup_thread(mddev->thread);
>   	sysfs_notify_dirent_safe(mddev->sysfs_action);
>   	ret =3D len;
>  =20
>   out:
> -	mddev_unlock(mddev);
> +	if (action =3D=3D ACTION_RESHAPE)
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
