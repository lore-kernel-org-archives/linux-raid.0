Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D713242B0
	for <linux-raid@vger.kernel.org>; Fri, 24 Apr 2026 07:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777014290; cv=none; b=j5abKFGMxtusgBdio8uXB1O3hSwGWiKdldApSABi2IjpavSYke2140E8MKwJN1ClUTi+lvPpjEpSWs5uR7yDoUOV2MH2nF6ERcFwiX8d75udrcY/Ni7w+tvOjBonj7NHy1wvYw74r975WsuzF0iyy0YE32iwvvMGfZFMXNwPgiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777014290; c=relaxed/simple;
	bh=fckn8rK0lIyrgv74sriDRd/xVjhcOPKTg3lkKdaug1Q=;
	h=From:References:Content-Type:Mime-Version:To:Date:Cc:Subject:
	 Message-Id:In-Reply-To; b=cD97dIR9UxwD92JUFIk2xsktR+KO+iCQSGRtc0hQblMgVsNlB1ehkJxpMzPqrdh43b/7EPNzvunUqEzkQQeY+C+y89sRq2/D/DhVhcxJxL6nEqfzLtaKc1treE65LyBl2fuzVxJGeQhQGqQvhFZ9n1D94+pFqNrsZG5GnKACzWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=jX9DjlNg; arc=none smtp.client-ip=209.127.231.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="jX9DjlNg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1777014271;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=C/1PyJgQMGQlQwEd6BxGipN8aeFh8QjdSBEShKnYhOs=;
 b=jX9DjlNgYLX19xxZOQGzE3LWwdmfxV+4yRF5bi3Q7Pt8smVxC+sXVAewgyGP5zk5zKSG7I
 rbnePggRjaNm3OsI40zd08HgXRGTqOOd1zy07B1/8CwQdH48VGPWD33UD76wMxlUc8FQz/
 VQd1a3Q5gpbEfkNaWFiDduZ2pYH0w/yoafCExSRLjWqkwaCE/XpwUPmI1Ext3rJGLjSMop
 wVpvufAnL4rm3j4aM/bPrtd9lQfe/9mvL9bvKuU47oeQsAv8ay1VBMcrvKF68U633pQnyg
 eX+UFJjhMVl2oJZyv3Zq7GARf7/01R8XwqQcT0T4+BKgt2ykGMqVypQbyTwO7A==
From: "Yu Kuai" <yukuai@fnnas.com>
References: <20260422023317.796326-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.183]) by smtp.feishu.cn with ESMTPS; Fri, 24 Apr 2026 15:04:28 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fnnas.com>
Date: Fri, 24 Apr 2026 15:04:26 +0800
X-Lms-Return-Path: <lba+269eb15fd+4cba6f+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Cc: <chenchneg33@gmail.com>
Subject: Re: [PATCH 1/4] md/raid10: prepare per-r10bio dev slot tracking
Message-Id: <d9ac1717-47e7-48d3-9f59-bb3a4b23c578@fnnas.com>
In-Reply-To: <20260422023317.796326-1-chencheng@fnnas.com>
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/4/22 10:33, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> raid10 reuses r10bio objects from both r10bio_pool and r10buf_pool. Track
> the number of devs[] slots used by each request in the r10bio itself and
> initialize it whenever one of these objects is reused.
>
> No functional change yet. A later patch will use this width when reshape
> changes conf->geo.raid_disks.
> ---
>   drivers/md/raid10.c | 4 ++++
>   drivers/md/raid10.h | 1 +
>   2 files changed, 5 insertions(+)

For patchset please also add a patch 0.

This solution looks incorrect. The usage of r10bio_pool() is wrong in the f=
irst
place. Noted for mempool, it will preallocate elements and such elements ca=
n be
reused in following mempool allocation. Which means:

1) preallocate elements with old raid disks;
2) rehsape update raid disks;
3) allocate new r10bio, elements from 1) can be used.

The solution can refer to raid1.

1) convert mempool to fixed size;
2) during reshape, suspend/quiesce the array first to wait for all pralloca=
ted
r10bios to return first.

>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0653b5d8545a..e93933632893 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1540,6 +1540,7 @@ static void __make_request(struct mddev *mddev, str=
uct bio *bio, int sectors)
>   	r10_bio->sector =3D bio->bi_iter.bi_sector;
>   	r10_bio->state =3D 0;
>   	r10_bio->read_slot =3D -1;
> +	r10_bio->used_nr_devs =3D conf->geo.raid_disks;
>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
>   			conf->geo.raid_disks);
>  =20
> @@ -1727,6 +1728,7 @@ static int raid10_handle_discard(struct mddev *mdde=
v, struct bio *bio)
>   	r10_bio->mddev =3D mddev;
>   	r10_bio->state =3D 0;
>   	r10_bio->sectors =3D 0;
> +	r10_bio->used_nr_devs =3D geo->raid_disks;
>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
>   	wait_blocked_dev(mddev, r10_bio);
>  =20
> @@ -3061,6 +3063,8 @@ static struct r10bio *raid10_alloc_init_r10buf(stru=
ct r10conf *conf)
>   	else
>   		nalloc =3D 2; /* recovery */
>  =20
> +	r10bio->used_nr_devs =3D nalloc;
> +
>   	for (i =3D 0; i < nalloc; i++) {
>   		bio =3D r10bio->devs[i].bio;
>   		rp =3D bio->bi_private;
> diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
> index ec79d87fb92f..92e8743023e6 100644
> --- a/drivers/md/raid10.h
> +++ b/drivers/md/raid10.h
> @@ -127,6 +127,7 @@ struct r10bio {
>   	 * if the IO is in READ direction, then this is where we read
>   	 */
>   	int			read_slot;
> +	unsigned int		used_nr_devs;
>  =20
>   	struct list_head	retry_list;
>   	/*

--=20
Thansk,
Kuai
