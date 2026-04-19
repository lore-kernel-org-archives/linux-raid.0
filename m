Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D01188713
	for <linux-raid@vger.kernel.org>; Sun, 19 Apr 2026 04:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776573760; cv=none; b=NTXrOskNw0SA9xrVho3knyOZ097uTMfKocy7jSAfxOuGzaXTAqgg2SdL217ERD5TEJ16RF30d1csPK2T6wu0usnTGfskr9qBP3hvOtYs7bYZ9zzY4+AZz0T+pGJYpYUL8dvEsnJ3j0JB/AnzxGJsi4hC7sy2e7NDyx1pp+1/qJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776573760; c=relaxed/simple;
	bh=o92FNG+o8yVlytdVp9668qDC9TykpyHWOXrALR21bQQ=;
	h=Cc:Subject:Content-Type:References:Date:To:From:Message-Id:
	 Mime-Version:In-Reply-To; b=F2Xh6w22EmnOQhmuI/upBaF5m/TO5YddJLT0p49rdc7Vda6T8ZeLXHDcDy0ZR/fI9cyPxJgOZ7e36QiQb7OmcmmaUgHkoOkKKS1+6xME9aH85WkXqT206grHYiP7K1McyOvpNTL69Hl3/C2MkU11TiqENLCD/690/LhmkybW6to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=KYaA8dW0; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="KYaA8dW0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776573753;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=7Bgv2tBKVpKFjQdOeZ5XJrGcrpcG4WqyuCOUQGmT50o=;
 b=KYaA8dW0Uoa4iw1tTQMaF/V/Nel6DbcBj6PuTX+CIKAnXFjvbwoi3ti7h1P7tjg8sLzLPY
 oeVFDUaOerLuiDPHg1Av8mak3SrPUblkeDmNG4NvZED1usrFys2bhQZTOGDT8FrXaeBTOS
 RNfoX7qGtIYV6OrhDSaz4Waqc56wM3cPPW2jMIjEN3g+ULTibOQNVKpsX3GcyRtXcU0qYE
 MsEMIZ1dh6IpPbPJMb0SWM1n8w5sg8bH4DyZ5fos81nHzANBg7y4gavMcelNin3cfirQ8M
 AVKgIGEqzrxh1hRzI/a3GuWjMcl17m5Aq+ZM+Hisa4jr+2LcnokagUccaHzh5w==
Reply-To: yukuai@fnnas.com
Cc: <stable@vger.kernel.org>
Subject: Re: [PATCH v2] md: fix kobject reference leak in md_import_device()
X-Lms-Return-Path: <lba+269e45d38+a9bcb4+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.feishu.cn with ESMTPS; Sun, 19 Apr 2026 12:42:31 +0800
Content-Type: text/plain; charset=UTF-8
References: <20260413141759.2970973-1-lgs201920130244@gmail.com>
Content-Language: en-US
Date: Sun, 19 Apr 2026 12:42:29 +0800
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
To: "Guangshuo Li" <lgs201920130244@gmail.com>, "Song Liu" <song@kernel.org>, 
	"Greg Kroah-Hartman" <gregkh@suse.de>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <cdc869dc-ba1a-4cc2-a44c-3d147ca6bbbc@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260413141759.2970973-1-lgs201920130244@gmail.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/4/13 22:17, Guangshuo Li =E5=86=99=E9=81=93:
> md_import_device() initializes rdev->kobj with kobject_init() before
> checking the device size and loading the superblock.
>
> When one of the later checks fails, the error path still frees rdev
> directly with kfree(). This bypasses the kobject release path and leaves
> the kobject reference unbalanced.
>
> The issue was identified by a static analysis tool I developed and
> confirmed by manual review.
>
> After kobject_init(), release rdev through kobject_put() instead of
> kfree().
>
> Fixes: f9cb074bff8e ("Kobject: rename kobject_init_ng() to kobject_init()=
")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
> v2:
>    - note that the issue was identified by my static analysis tool
>    - and confirmed by manual review
>
>   drivers/md/md.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6d73f6e196a9..4ce7512dc834 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3871,6 +3871,9 @@ static struct md_rdev *md_import_device(dev_t newde=
v, int super_format, int supe
>  =20
>   out_blkdev_put:
>   	fput(rdev->bdev_file);
> +	md_rdev_clear(rdev);
> +	kobject_put(&rdev->kobj);
> +	return ERR_PTR(err);

I think it's cleaner to move kobject_init() after everything in rdev
is ready.

>   out_clear_rdev:
>   	md_rdev_clear(rdev);
>   out_free_rdev:

--=20
Thansk,
Kuai
