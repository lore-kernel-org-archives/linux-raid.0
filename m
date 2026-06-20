Received: from lf-2-18.ptr.blmpb.com (lf-2-18.ptr.blmpb.com [101.36.218.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E52368D7C
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 19:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781983800; cv=none; b=j1QyXNID8/ipUbDhgFai2vQeSrGVjMP6Pe2zRC/+d6MpmF7m5Un9Xyzk6ms2WJ6VtKH6s3P5c8f12KJmmSgdmfIirCEfttdm8BzPgC3fTRP3+6R2cAO6YjJkchvT0SmGdHut0TuF70CIAHX4xdfbe+L7BOd+khfDRmyTamETCdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781983800; c=relaxed/simple;
	bh=64lvEy0IgikpfF23MQjr9sNZPlqeSqooXxlnxAT+dyg=;
	h=Content-Type:From:References:Message-Id:Mime-Version:Cc:Subject:
	 In-Reply-To:To:Date; b=IKm7jFTvvupl5XnsvQrFy1tyX0VSrjJyeTtytkJGCFsEq+Es5rO1negSR+ZXa0fheodYeqe6pMVr9ESBthp9N7bl+TVccb6QvGQTsjYEMb9r6cErsv+xdahVzFiDUVNK3xFtflIrZZgCfwsiWESYwMsnjr2HwVbH1vgXO9LR6NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Si8QW0a5; arc=none smtp.client-ip=101.36.218.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Si8QW0a5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781983749;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=lrnDzLjdmvtpFzTRloiZTx1I7ehFHfWIxg1adUIkyFY=;
 b=Si8QW0a5E4uvuD1kgkzvG7N0p4wWAjzCxVTdsoq1EXCvBQv11cQqCeyRvQvTFKZTZp+mAX
 dfI3DMGyQ2WPmSDn4KCYEsMg8/lLpxfbdiYbLBTFrl54JL+WYZ2TOtVYg+mjruGDptFCrA
 RGZw3fZjWrgnoB5L+gcz2M9VSopqYdutMKQv6Opzrvw1J4LwX2HVb50bdQ1zgZxHvghVy7
 /W80u1oDAJQFIoE5L5MXqQaS6OiBxAMuUA4pt973AevdfvQMlgRgqguWp0vRI7S1ilNX9E
 wMjm0wx8M39MJ0EgNouA8J2Txsi/u2SxRDh3V5EkYv9avWTOSfzoR8aAbkNAQQ==
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
References: <20260611083510.476945-1-runyu.xiao@seu.edu.cn>
User-Agent: Mozilla Thunderbird
Message-Id: <5ccd58de-da8c-4a31-896d-24d86df4e177@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a36ea04+b3b1d8+vger.kernel.org+yukuai@fygo.io>
Cc: <lilingfeng3@huawei.com>, <linux-kernel@vger.kernel.org>, 
	<jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH] md: use READ_ONCE() for rdev_attr_show() mddev check
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 19:29:07 +0000
In-Reply-To: <20260611083510.476945-1-runyu.xiao@seu.edu.cn>
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Runyu Xiao" <runyu.xiao@seu.edu.cn>, <song@kernel.org>, 
	<linux-raid@vger.kernel.org>, <yukuai@fygo.io>
Date: Sun, 21 Jun 2026 03:29:04 +0800

Hi,

=E5=9C=A8 2026/6/11 16:35, Runyu Xiao =E5=86=99=E9=81=93:
> md_kick_rdev_from_array() clears rdev->mddev with
> WRITE_ONCE(rdev->mddev, NULL), and rdev_attr_store() already snapshots
> that same shared pointer with READ_ONCE(rdev->mddev). rdev_attr_show()
> still tests the pointer with a plain lockless `if (!rdev->mddev)` before
> calling entry->show().
>
> A running system can reach this by reading rdev sysfs attributes while a
> device removal path is tearing the same md_rdev down. In that window,
> rdev_attr_show() can pass a stale plain guard while sibling
> rdev_attr_store() already observes NULL and returns -ENODEV, leaving the
> show path to operate after the shared mddev pointer has been revoked.
>
> Use READ_ONCE() in rdev_attr_show() so this sysfs read side matches the
> existing visibility contract on rdev->mddev.
>
> Fixes: 9cfcf99e7ed6 ("md: get rdev->mddev with READ_ONCE()")
> Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
> ---
>   drivers/md/md.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 92ec4be20db8..a021cf4a798d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3704,7 +3704,7 @@ rdev_attr_show(struct kobject *kobj, struct attribu=
te *attr, char *page)
>  =20
>   	if (!entry->show)
>   		return -EIO;
> -	if (!rdev->mddev)
> +	if (!READ_ONCE(rdev->mddev))
>   		return -ENODEV;

unlike rdev_attr_store(), kernel can panic if abnormal value is read. Howev=
er, this is just a
read and the value is not used at all, READ_ONCE() is not used here on purp=
ose by 9cfcf99e7ed6.

>   	return entry->show(rdev, page);
>   }

--=20
Thanks,
Kuai
