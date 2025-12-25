Received: from sg-1-17.ptr.blmpb.com (sg-1-17.ptr.blmpb.com [118.26.132.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1217123AB98
	for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 07:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766648530; cv=none; b=KvbPiD+hZFIGe2EketVuFJj1fOQo0zN2GbVAQO9kBLABL2YiYB6yqEpjNMuS15vzVZ3eo5vREmmodvqS1VHmZz3q1RtDLcBh9WaD+2LlvLjDqq3/BXMVRxihhddaxDFtx60NOs9a+6cQoWY7BqC/EV3sfZzgC41wjPHCMW43U24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766648530; c=relaxed/simple;
	bh=2pybSaz+P2MVWZrCRAu240fNCO5cJLTzG+FfcnSAN4U=;
	h=Content-Type:References:In-Reply-To:To:From:Cc:Message-Id:
	 Mime-Version:Subject:Date; b=I8xVjXvwdwZ3zdT7ZU/3ByknLihyJBoim6jeQ1iiVUE65v0Sgml3xu4H1ZtiTgwgTv/S7O55oKLwalJM2KSueQHsIRy0zTWiR9gmjPrSMCkdW9Cn6SVePrnts+qGLuhurWzpreOmAqUaddJb3tKNTUijGzzmnAHHqCUXgbIwjbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=x6iDCgvn; arc=none smtp.client-ip=118.26.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="x6iDCgvn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1766648406;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=I1Dlhh2wjh6lo0dOo5R+jK58n3KfJlJL8ulRELYo3uU=;
 b=x6iDCgvnDAVsNqL6DE12yQXDfvfvgCjhz++DVEtkG3NiVqOXYlexEZUA1KBYdqm7nr07eL
 2clq8zH/FfIKIXfjzNS7tYNwI0JApWfVrBF0Ovv+5RGrnzbSk8MbtsKFhYiCPv6GaqFc71
 TbdyJu00loDRz1CpbYOMT37fTIksmbDSzCdylqlMkA0wh0zOcMHw1IV4/enbf8ZnJim1OG
 hSrkDqtt2zwJifzZOXuMCTNyfupdIly2DL9D8rVzrPpkt8jYYSBZU7iOM6J5QgMslb6xDm
 3vafA2VLUMAsrNCBwH2G5/1dFwa6Ol9ymxDz76nDOqOhwXjvXYGY41X4FRWQTQ==
Content-Type: text/plain; charset=UTF-8
References: <20251210074112.3975053-1-islituo@gmail.com>
In-Reply-To: <20251210074112.3975053-1-islituo@gmail.com>
To: "Tuo Li" <islituo@gmail.com>, <song@kernel.org>
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<xni@redhat.com>, <yukuai@fnnas.com>
Message-Id: <55938698-697e-4c2b-b5dc-ea5aff359567@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Thu, 25 Dec 2025 15:40:03 +0800
X-Lms-Return-Path: <lba+2694cea54+8c18bb+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH] md/raid5: fix possible null-pointer dereferences in raid5_store_group_thread_cnt()
Date: Thu, 25 Dec 2025 15:40:02 +0800
Content-Language: en-US

Hi,

=E5=9C=A8 2025/12/10 15:41, Tuo Li =E5=86=99=E9=81=93:
> The variable mddev->private is first assigned to conf and then checked:
>
>    conf =3D mddev->private;
>    if (!conf) ...
>
> If conf is NULL, then mddev->private is also NULL. However, the function
> does not return at this point, and raid5_quiesce() is later called with
> mddev as the argument. Inside raid5_quiesce(), mddev->private is again
> assigned to conf, which is then dereferenced in multiple places, for
> example:
>
>    conf->quiesce =3D 0;
>    wake_up(&conf->wait_for_quiescent);
>    ...
>
> This can lead to several null-pointer dereferences.
>
> To fix these issues, the function should unlock mddev and return early wh=
en
> conf is NULL, following the pattern in raid5_change_consistency_policy().
>
> Signed-off-by: Tuo Li <islituo@gmail.com>
> ---
>   drivers/md/raid5.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e57ce3295292..be3f9a127212 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7190,9 +7190,10 @@ raid5_store_group_thread_cnt(struct mddev *mddev, =
const char *page, size_t len)
>   	raid5_quiesce(mddev, true);
>  =20
>   	conf =3D mddev->private;
> -	if (!conf)
> -		err =3D -ENODEV;
> -	else if (new !=3D conf->worker_cnt_per_group) {
> +	if (!conf) {
> +		mddev_unlock_and_resume(mddev);
> +		return -ENODEV;

+CC Xiao

This is still wrong, please add the NULL check and return early before raid=
5_quise().
And also add a fix tag:

fa1944bbe622 md/raid5: Wait sync io to finish before changing group cnt

> +	} else if (new !=3D conf->worker_cnt_per_group) {
>   		old_groups =3D conf->worker_groups;
>   		if (old_groups)
>   			flush_workqueue(raid5_wq);

--=20
Thansk,
Kuai
