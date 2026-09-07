Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B8C3FF1D0
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 06:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763770; cv=none; b=LgV51AotCRO+92oQRbIPrzDo99b0pDgfPxe32tR5rzR/ZgRFV3HzxUDWYibXB0mV0q3PG+ba0jcoAA8CJQhbUi3TrsZNlpn0hL1iDsLpb1IssV+QBOV6gjI31whlLQwlYZK3efGPsuA7rzXvJ3LNcS6yav6w1jMCxcIwv+88mnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763770; c=relaxed/simple;
	bh=PUkd9XVvw3JA8R/e7pRNDV22AvJTtU+3EqHoU3TXr9c=;
	h=Content-Type:Date:Subject:Message-Id:To:Cc:In-Reply-To:References:
	 From:Mime-Version; b=Nd1xANoFoOOCgbJ2yt5MbJGogPv37zy/YOk0u6REMuUP0VImBk1ckqH+PK2tkimy7TUlB7uU4T+K+8UcxAaVJqESI/KvJeHaYFcigTBjsFMKfnT46njfCEQrQvG2Gg51QcQVxDQFyQpTxdC0vzBP72LK4Azv9gx4Q9cGUk3fjH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=R1jhHUrk; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="R1jhHUrk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788763762;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=tjx4nYlEdvMkKa+4XKr7qNE//HL1DSGFGYD8GEIfeU4=;
 b=R1jhHUrk3wr75st3AILga1G1d4GWn3lFJbDSKXgAcRfNv2v5LJehr87DCBeCDFg0s0lWnN
 ugrdqd8RoMVZdKGQ/gMooHkpC/1+9e7daDXZXLtvr8sL977rMyQ8hANCw6xpEhC2iDb5YX
 iY4tbQGdr0gLuEQhjlLXlRNpccOf7PvAuZ1CvTVjHUGjLYF6y7X6vObe8ikf57LKGkkdJE
 /Pu/MQAbfHhSxqBuDMk15gGGOtGuCv28XTVeaV8VFsWMYYXBIcMifjVSWqScwAkSxJQFe7
 w3Z2mvu8MydyA93bwJMA4RgP6bINxpoKkO+UehLt0m21VwoJ0Hbj+LLmMB4YrQ==
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Date: Mon, 7 Sep 2026 14:49:17 +0800
X-Lms-Return-Path: <lba+26a9e5e72+fb0b37+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Subject: Re: [PATCH v2] md/raid0: validate device count before allocating devlist
Message-Id: <b89b96ce-36cb-4e98-bcba-26ba2dbd461a@fygo.io>
Received: from [192.168.1.104] ([39.182.0.161]) by smtp.larksuite.com with ESMTPS; Mon, 07 Sep 2026 06:49:21 +0000
To: "Chandradhar Kumar" <chandradhar.2003@gmail.com>, <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-kernel@vger.kernel.org>, 
	<syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com>
In-Reply-To: <20260906184406.2141-1-chandradhar.2003@gmail.com>
References: <20260906184406.2141-1-chandradhar.2003@gmail.com>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

Hi,

=E5=9C=A8 2026/9/7 2:44, Chandradhar Kumar =E5=86=99=E9=81=93:
> create_strip_zones() allocates conf->devlist based on mddev->raid_disks
> before verifying that enough devices are present. Validate the number of
> member devices before allocating devlist to reject invalid
> configurations early.
>
> The existing validation later in the function already rejects this
> condition, but it occurs after the potentially excessive allocation.

Since there is already a checking cnt !=3D mddev->raid_disks, it doesn't ma=
ke
sense to introduce redundant checking. Please move the checking forward to
fix the problem.

>
> Reported-by: syzbot+a32ff75e417c0f49a8e9@syzkaller.appspotmail.com
> Closes: https://syzbot.org/bug?extid=3Da32ff75e417c0f49a8e9

Please add a fix tag.

> Signed-off-by: Chandradhar Kumar <chandradhar.2003@gmail.com>
>
> v2:
> - Reject non-positive raid-disks values, which can bypass the device
>    count validation and result in an oversized allocation.
> ---

And change log should not be placed in commit message. Just move them here,=
 and they
will be dropped when I apply the patch.

>   drivers/md/raid0.c | 20 +++++++++++++++++++-
>   1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 35e103f0c2c3..8eaf078606d6 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -69,7 +69,7 @@ static int create_strip_zones(struct mddev *mddev, stru=
ct r0conf **private_conf)
>   	sector_t curr_zone_end, sectors;
>   	struct md_rdev *smallest, *rdev1, *rdev2, *rdev, **dev;
>   	struct strip_zone *zone;
> -	int cnt;
> +	int cnt, nr_devs;
>   	struct r0conf *conf =3D kzalloc_obj(*conf);
>   	unsigned int blksize =3D 512;
>  =20
> @@ -79,7 +79,10 @@ static int create_strip_zones(struct mddev *mddev, str=
uct r0conf **private_conf)
>   	*private_conf =3D ERR_PTR(-ENOMEM);
>   	if (!conf)
>   		return -ENOMEM;
> +
> +	nr_devs =3D 0;
>   	rdev_for_each(rdev1, mddev) {
> +		nr_devs++;
>   		pr_debug("md/raid0:%s: looking at %pg\n",
>   			 mdname(mddev),
>   			 rdev1->bdev);
> @@ -144,6 +147,21 @@ static int create_strip_zones(struct mddev *mddev, s=
truct r0conf **private_conf)
>   	}
>  =20
>   	err =3D -ENOMEM;
> +
> +	if (mddev->raid_disks <=3D 0) {
> +		pr_warn("md/raid0:%s: invalid number of disks %d - aborting!\n",
> +			mdname(mddev), mddev->raid_disks);
> +		err =3D -EINVAL;
> +		goto abort;
> +	}
> +
> +	if (nr_devs < mddev->raid_disks) {
> +		pr_warn("md/raid0:%s: too few disks (%d of %d) - aborting!\n",
> +			mdname(mddev), nr_devs, mddev->raid_disks);
> +		err =3D -EINVAL;
> +		goto abort;
> +	}
> +
>   	conf->strip_zone =3D kvzalloc_objs(struct strip_zone, conf->nr_strip_z=
ones);
>   	if (!conf->strip_zone)
>   		goto abort;

--=20
Thanks,
Kuai
