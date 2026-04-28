Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD1E2E717B
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 08:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777364639; cv=none; b=Lpc2ZtloIee4cXcNqInx5/m/XxkXw0TNZAe2WHW23nVGKhnAa+cmSeibTU06B4oTfqmGUzef/9c7NqzbtUzda3Rbbl+hBR/bHmV79S7Czs++IozNqIinUxBLbl+wrDY+UNs3d+QsgFF5ie2q/KxLh3OMZY1ZAARnfrkfJPkcE4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777364639; c=relaxed/simple;
	bh=0WMjLvpKFjFuyhgu3Hq6lHSRCbGuAEa7X/eh+I3okqs=;
	h=Content-Type:Date:Message-Id:References:Cc:Mime-Version:Subject:
	 In-Reply-To:To:From; b=BIg/xKdruxcr/roIOgZrXAjGEPjSgJKo5EsFELgDygWpzG1I9HS9lavR+9IGHXR7+9Y2aF/+KqpxAz+mV8WZU2z5CEMMYY5kXSIAC4jtgs/7gQwQxkNw+xBOInwjA+CycUQI6sXikO1QdLo5f6uZEaaOPSdTMESX/xh1QCNU6NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=ARX7Ns+c; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="ARX7Ns+c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1777364633;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2cMjZeoehSdSdvdUCQKVh3/LRI2Pjm9LjP2wUp6i41Y=;
 b=ARX7Ns+c0oYDx01wHyqun4DqHtZWQw5PMfmZz2vZ4ZPj20aCZkt2CR6OpbYUF44mS/sWgl
 f9+AMDuKnvlqmas6coV4kl360bJMalXH3SR5DQriZwEwczL4FuodatbEp93KaPvG7sCOnV
 R1Y6L9JFFkqowMS3N/wlZ526F/xuJVeveW4tXjndbpLRArH+pg24f5J5ogxxUFviVlpNhP
 vd8yNp8dirbprV32kpKIUAGP5c/Ar1BVTm5UsPoU+vN7OCLlFRgXuPkVLsHMKkK3ri0gBM
 ogzVu1kA7bxsvJhW5zADHUnVWtrTLO4GxGsk1SuhwZzP+aA89fNUy8Q9es+eQw==
Received: from [192.168.1.104] ([39.182.0.183]) by smtp.feishu.cn with ESMTPS; Tue, 28 Apr 2026 16:23:49 +0800
Content-Type: text/plain; charset=UTF-8
Date: Tue, 28 Apr 2026 16:23:47 +0800
Message-Id: <5c71cb6b-d860-4bcb-a900-a27544be7a17@fnnas.com>
References: <20260426093506.14316-1-abd.masalkhi@gmail.com>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+269f06e97+0a40f1+vger.kernel.org+yukuai@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: Re: [PATCH] md/raid1: fix len reuse across rdevs in choose_first_rdev()
In-Reply-To: <20260426093506.14316-1-abd.masalkhi@gmail.com>
Content-Language: en-US
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<paul.e.luse@linux.intel.com>, <xni@redhat.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/4/26 17:35, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> choose_first_rdev() initializes the variable len before iterating over
> all rdevs, but passes it by reference to raid1_check_read_range(), which
> it might update *len and return 0 depending on the layout of the bad
> block region. As a result, 'len' can be modified during the first
> iteration and reused for subsequent rdevs, causing later devices to be
> evaluated with an incorrect length value.
>
> Fixes: 31a73331752d3 ("md/raid1: factor out read_first_rdev() from read_b=
alance()")
> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> ---
>   drivers/md/raid1.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index b549be9174bb..5f5dbf79c903 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -591,12 +591,12 @@ static int choose_first_rdev(struct r1conf *conf, s=
truct r1bio *r1_bio,
>   			     int *max_sectors)
>   {
>   	sector_t this_sector =3D r1_bio->sector;
> -	int len =3D r1_bio->sectors;
>   	int disk;
>  =20
>   	for (disk =3D 0 ; disk < conf->raid_disks * 2 ; disk++) {
>   		struct md_rdev *rdev;
>   		int read_len;
> +		int len =3D r1_bio->sectors;
>  =20
>   		if (r1_bio->bios[disk] =3D=3D IO_BLOCKED)
>   			continue;

This patch is wrong, choose_first_rdev() is used when raid1_should_read_fir=
st() is true,
meaning the read overlaps an unsynced/resyncing area. Reset len can cause t=
he problem that
reading the same area can return different data.

--=20
Thansk,
Kuai
