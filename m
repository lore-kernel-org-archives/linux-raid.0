Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C1A2DB7BB
	for <linux-raid@vger.kernel.org>; Sat,  5 Sep 2026 02:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788574580; cv=none; b=I1cLBaxcLMxZBhZUVM7tceGXS/JPTbMjJ0dTE1lb/UWXrMYJMzcV66qqiF6fjFH0whKjOUCHPS4wrZHpiR8Y9PxBEZlf3BRzpf46JwEDYVZaqdX/lFoSkmK2SQ5Az6b4wbmVizP/L3xUC2tVRxHNY/x5OBufGt9BK5q4jmYNi8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788574580; c=relaxed/simple;
	bh=6JCf4Lb1Flv9C5xRWLiwPWrWMIcYGglg2IpRXunXdD0=;
	h=Message-Id:Mime-Version:References:To:Content-Type:In-Reply-To:Cc:
	 From:Subject:Date; b=CCkkEc7Ex/0imeNR8X6HIYfNxUz70tVMFSv01ap2wLFSHlQA9cdOVR6ZCnjri4wtJUTm9p5+w3XlJnXCbdjFuwXnnVyXtlaPsRGHr3EiglEquFzIm+b/6+kXC1a+QO84oV0gq5HKp9v2dHEn74sBzMQvJQNJifhpWQxKnUeKGVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=OeZ9MXP9; arc=none smtp.client-ip=209.127.231.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="OeZ9MXP9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788574567;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=UBlu1yQq6VDuHpWmYNcsoa3rokaSLxbjInLsuZMMfME=;
 b=OeZ9MXP9jVGWTFieG8dA1ym3B+WlgMUz4RIwEQAM3+uDTmSP9yBFwwJzl9c9ChGDCDCWa/
 3r9kAUYUg4RvEF2ByFO5V7gTiefUSlsxWKvLo99BpkTD9PkoSJE4WRpEETFJ9vvqobTRcD
 7Q89pC17J/u9KSHR2IFPvjxJq3xECvo8dz7uIude8SdVV6nWkPxC18knIbx9WyAYD1jKtH
 CiDbUxkvnFGfgl0pP2pnsQnHZvV6CnfE1TsYdWtFCiOYuteLUHq9K2+iKybj7PSxAFI6m/
 aM0OJz4NqePqEV52MEONwTPTcYwt38WoaXsNrQwziOnLQbnbpJzA2gRpyuIojg==
Message-Id: <195e0c6d-829a-4782-8ce3-3ffe10462bc4@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.178]) by smtp.larksuite.com with ESMTPS; Sat, 05 Sep 2026 02:16:06 +0000
References: <20260811101436.458181-1-chencheng@fnnas.com>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260811101436.458181-1-chencheng@fnnas.com>
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>, 
	<syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: fail invalid raid5_set_limits() geometry
Date: Sat, 5 Sep 2026 10:16:02 +0800
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a9b7b66+7c7f93+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/8/11 18:14, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> Prevent raid5_set_limits() from building a stripe size when the array
> geometry reports no data disks.
>
> Reported-by: syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Dde94ddbfff0c9e6fe030
> Fixes: f63f17350e537300312 ("md/raid5: use the atomic queue limit update =
APIs")

The closes link is wrong, please use lore url. And the fix tag is wrong as =
well,
12-character SHA should be used.

>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ffb5fcde54a9..c0adb73b1dd4 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7825,10 +7825,12 @@ static int raid5_set_limits(struct mddev *mddev)
>   	/*
>   	 * The read-ahead size must cover two whole stripes, which is
>   	 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices=
.
>   	 */
>   	data_disks =3D conf->previous_raid_disks - conf->max_degraded;
> +	if (data_disks <=3D 0)
> +		return -EINVAL;

Looks like following is the correct fix:

[syzbot] [raid?] UBSAN: shift-out-of-bounds in raid5_set_limits=20
<https://lore.kernel.org/all/6a778c82.01d0871a.3a0d52.006a.GAE@google.com/T=
/#m635e3614888a7ec9d9a1cc4fd15660d538dedfd0>

Just raid5 should contain at lease 3 disks.

>  =20
>   	/*
>   	 * We can only discard a whole stripe. It doesn't make sense to
>   	 * discard data disk but write parity disk
>   	 */

--=20
Thanks,
Kuai
