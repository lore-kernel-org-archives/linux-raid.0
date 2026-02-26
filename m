Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2A22765ED
	for <linux-raid@vger.kernel.org>; Thu, 26 Feb 2026 05:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772084203; cv=none; b=ikpUZARHjPwpAvkb2Q9aMeM+zv68wvG6FtgjDGaT/fCxZ8O2icMmcIUKfRHwFn/FmHPqpazIROFJ7cN5vIvt/N0BUWiGlIPCRwhu0P2nUlQxQmYf2QrrlWDASU8+SaCWkkcXdpE93jXrrEx5pCK8eS1jIr9S3XD/dhCtTHWsH3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772084203; c=relaxed/simple;
	bh=B7aCG73qPAVwHSVIxg5UMR5xc0Xc4LHlSrjesD2hRYE=;
	h=To:Cc:From:Date:Content-Type:In-Reply-To:Subject:Mime-Version:
	 Message-Id:References; b=VSKIGPgmaXtNCzMKzUnOMC+vCVBhEjZh+JrNCst/9GgDrzLCzh7gFgyVh9+atfvuTahRHgdXGZ+0mYpP05MVDgg9MIUF5LfHLP0m47XZKzth8hIVkx7uqlXQFd8P1iJu7S6XE/Q113B9vDd7rvLW3GS43lIFoD3DbSl+8P89hGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=enaPwxMf; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="enaPwxMf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772084113;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=IrAcACgBllsvJmuN+XWzX+PbAjx/JQij6/HPhkQ2b84=;
 b=enaPwxMfBLSo9F1kyVa6Ze/sPtOaNXGGFg9OLJ60OhGHjCYTPwV9aRFoeh2+QJT/yEYuPQ
 XidQSbwXiK1KOpDPV1a+JSMDgAm0YbCIItQ/eZKUkkwS9Q3xs6266NYY+xkz8FRiK6cI7J
 7GK9TqdPhKoncSm6RpEO8kaQTx8Le7C67PAk6NUILxGwu5vcFOLKUAUBoQdvgchy2hZUM+
 E1sWQD8n77I9GMsoUoVBOQOqJIlmwB9MoNUfidVhGbFiKfdsn9lq6PR6AfQsILar52guJb
 FxytFZ2qRdrUiGcsga5vAa2AaChCeK/yqTCbHoptqC2uYBwUkbPHRErLlLW8eQ==
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fnnas.com>
Cc: <linux-kernel@vger.kernel.org>, <pmenzel@molgen.mpg.de>, 
	<tj.iam.tj@proton.me>
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+2699fdb8f+9d99db+vger.kernel.org+yukuai@fnnas.com>
Date: Thu, 26 Feb 2026 13:35:09 +0800
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260210133847.269986-1-chencheng@fnnas.com>
Subject: Re: [PATCH] md: suppress spurious superblock update error message for dm-raid
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Reply-To: yukuai@fnnas.com
Message-Id: <769a1ae7-b2f0-4336-921c-7685728f7b79@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.140]) by smtp.feishu.cn with ESMTPS; Thu, 26 Feb 2026 13:35:10 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20260210133847.269986-1-chencheng@fnnas.com>

Hi,

=E5=9C=A8 2026/2/10 21:38, Chen Cheng =E5=86=99=E9=81=93:
> dm-raid has external metadata management (mddev->external =3D 1) and
> no persistent superblock (mddev->persistent =3D 0). For these arrays,
> there's no superblock to update, so the error message is spurious.
>
> The error appears as:
> [  123.456789] md_update_sb: can't update sb for read-only array md0
>
> Link: https://lore.kernel.org/all/20260128082430.96788-1-tj.iam.tj@proton=
.me/
> Fixes: 6a5cb53aaa1d ("md: don't ignore read-only array in md_update_sb()"=
)
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

The Link and Fixes tag is incorrect, applied with following commit message:

     md: suppress spurious superblock update error message for dm-raid

     dm-raid has external metadata management (mddev->external =3D 1) and
     no persistent superblock (mddev->persistent =3D 0). For these arrays,
     there's no superblock to update, so the error message is spurious.

     The error appears as:
     md_update_sb: can't update sb for read-only array md0

     Fixes: 8c9e376b9d1a ("md: warn about updating super block failure")
     Reported-by: Tj <tj.iam.tj@proton.me>
     Closes: https://lore.kernel.org/all/20260128082430.96788-1-tj.iam.tj@p=
roton.me/
     Signed-off-by: Chen Cheng <chencheng@fnnas.com>
     Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
     Link: https://lore.kernel.org/linux-raid/20260210133847.269986-1-chenc=
heng@fnnas.com
     Signed-off-by: Yu Kuai <yukuai@fnnas.com>

> ---
>   drivers/md/md.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6d73f6e196a..e30b658641e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2790,7 +2790,9 @@ void md_update_sb(struct mddev *mddev, int force_ch=
ange)
>   	if (!md_is_rdwr(mddev)) {
>   		if (force_change)
>   			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -		pr_err("%s: can't update sb for read-only array %s\n", __func__, mdnam=
e(mddev));
> +		if (!mddev_is_dm(mddev))
> +			pr_err_ratelimited("%s: can't update sb for read-only array %s\n",
> +					   __func__, mdname(mddev));
>   		return;
>   	}
>  =20

--=20
Thansk,
Kuai
