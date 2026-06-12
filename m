Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0BE3A6F1C
	for <linux-raid@vger.kernel.org>; Fri, 12 Jun 2026 05:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781242082; cv=none; b=jo4EjlKwDqzcHoXmchR0e4ycfC2mJyXWGNlKjI0Km9lWZELWVa6E9moMKjdR6g3y7ddB+18CrcyZC3Vs1soGFbIhIMCGUYAPdlemYc9AL59hgx9Nm4zy4Ihhd1hnklY/E/L6FhSfji9LVzuVQlbdFcV5LKeRxF5kqT4sdc5iGY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781242082; c=relaxed/simple;
	bh=rdXPLTFUgYIy0frkdpv9H0elzJlKyrrYcklSjkxA7DE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rBPe1AZ7rJ9SM9NDTGPS3b1tXjNBLEgzvxWpwKUm+u66GZfarj4crbmSz7bzdgGiEr0rJciYr54PB63//FjzD9uEZRSzPdGysptBvDt7LmeEhRSRHhocT2HDPEDCruPH3r+6VGn6d6qKMSH90b5+7bUrGT2ms5JPKPOP/dDno8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hSCnMcYQ; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hSCnMcYQ"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490acbb0f89so3097845e9.0
        for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 22:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781242080; x=1781846880; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V2amOK/xSJHghV7y5jK8dUWQNl2Cve6eXEqKCPHjYc0=;
        b=hSCnMcYQhf3hoNOfvR+XJPzOkDBF338qU5x99s7CSNRmNvVJXyK9EhLxgOmv8lesqG
         6TpRuEhM6CHwmqGNtwjjunJaICbSQvijGK55fpE5jTVa8kd59WRU9KCoPFCNLiuLp0Ak
         nbIIaAO6gTvIG7j76Dn5E4ga2hq1uRNJat4vNHkvbULtOdcutgg/TD72nfe6KCMiLrZM
         pQCXAScoPE+lutiBOysAP0unqxTxR0hM9HT6T/TxEqlqrvHLOAaVWMKieTlO0dr7XSC3
         AVXLpNPuFImxOk3nqml/sSTb838UOUDhxohEqvChzAPawuMC365qO0Ph9IXbmF3dm1Fy
         TI9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781242080; x=1781846880;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=V2amOK/xSJHghV7y5jK8dUWQNl2Cve6eXEqKCPHjYc0=;
        b=bUIfQ7+fkV2/vOE1bEwmKRhFyQ9NeWp4E631CqwE8mUl/e6ZdXO++EiBN/Qi8Ctr8v
         uztQfXSmFIGmNua9VIonfkdIPXLnzKFq8ioZUeMNEzeH3hYP/2+gS2WRSYfagmHZ/gAH
         SR04UoTJooWxrvqEBH68KUKupSDsw9RGEOeexEHBq37Sbo824N7KhvpUsYRorF4HRczU
         oZuwJC9Zkyf5HRyYWz57FQO+YRxTdBZRDnt8BnRpwGJkqBbWHINtPI4GhyEU3uESQGhP
         9tsMTypN7trle9JaD5VRtA70Q4N1jZwp4iceBxcd4dUJQ2OM49G6SCqWFVNNCIkQTssI
         wHmA==
X-Forwarded-Encrypted: i=1; AFNElJ83l2oV4wh4LQ4xjg7PiWD70Zv06IWxxoDAX3TzdX/OKB6PQN57127F9PTdPt6dTGjfJmS/v1heJDF7@vger.kernel.org
X-Gm-Message-State: AOJu0YwmVSOTaatnuXiZlsQM0BgD2bsk06YKiaBrDrjTW2lFpOP0bUvY
	pQ/fb2wY7DSEIn8qhkmNq+LqV031mMdp8OEMXe0kh+FKNDk8t8WxXekShxkBig==
X-Gm-Gg: Acq92OHcwbPMQd3r37YHaTvomHJundV53cOWVtr1upaHjVHqSyqHFRx3ujqqcsr3LKi
	VzeTRNy5zq0ySgZig/2Vt8Ijtabhpb5+3ZLDi7ypDqpBcoZBJCg+V999X14+56uiVMD7JPPJuVQ
	sefHIVV5QJYJ5LIPRet2mvwCtB4iune8kpkf5U/xt1iB1+ZyY2qcm/imgUnbt/Aez86Pj6bZOxH
	IjjfIl3quhxIsL0IxJNJ5Rkl2vMmrkoajJy0nsDVOvgbzVU7tIgtKtoWmRCbQzt8zZUEtJzqVGZ
	8W5MxJLrcIVOuMqsUAebKQ27wp2WGdZ9NcRWNfnzrSPFkWEj7a4POeFowL7LRa4ii02tuTwYMLD
	S8rUxWwiwLDs/3gdfkVoc/KNRyv4HQB0TF7xKigs9yrP5dkeLlv6YapO0C+2hFYb4xJ3a63eJGf
	wKTMYgXxAsC+fzkJWZz0d7MamIKbt8YYojly8Cj8gDC9d8dvhcJiNpadmvYXH0G+JZ
X-Received: by 2002:a05:600d:6451:10b0:485:3abe:ab86 with SMTP id 5b1f17b1804b1-490ec480989mr7282255e9.4.1781242079515;
        Thu, 11 Jun 2026 22:27:59 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:612:1ff:bc98:79f0:79a6:5f77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea7c0960sm33027605e9.3.2026.06.11.22.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 22:27:59 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
Subject: Re: [PATCH] md/raid1: release barrier when REQ_NOWAIT write would
 block
In-Reply-To: <20260611134130.B4E911F00893@smtp.kernel.org>
References: <20260611132500.763528-1-abd.masalkhi@gmail.com>
 <20260611134130.B4E911F00893@smtp.kernel.org>
Date: Fri, 12 Jun 2026 07:27:54 +0200
Message-ID: <m24ij8xr8l.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2026 at 13:41 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] Missing RCU read lock around `conf->mirrors[i].rdev` access =
in `wait_blocked_rdev()`.
I'm not quite sure whether this is a real bug.

> - [High] Early failure paths in `raid1_write_request()` leak the `mddev->=
writes_pending` reference.
I'll submit a v2 containing this fix, along with the fix for the
mddev->writes_pending

> - [High] Allocating bios and r1bios can sleep even when the `REQ_NOWAIT` =
flag is set.
@kuai, Should I handle this issue as well, or should I just ignore it
for now?

> --
>
> commit 3db9da0ec804800aa3afb93361ccd18de39ce5f0
> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>
> md/raid1: release barrier when REQ_NOWAIT write would block
>
> raid1_write_request() leaks the barrier reference taken by wait_barrier()
> if wait_blocked_rdev() fails for a REQ_NOWAIT write. This patch releases
> the barrier on this failure path to prevent array freeze hangs.
>
> Closes: https://sashiko.dev/#/patchset/20260611083514.754922-1-abd.masalk=
hi@gmail.com?part=3D1
>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 5b9368bd9e700..f3cc30932ba2b 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1512,6 +1512,7 @@ static void raid1_write_request(struct mddev *mdde=
v, struct bio *bio,
>>  	int max_sectors;
>>  	bool write_behind =3D false;
>>  	bool is_discard =3D (bio_op(bio) =3D=3D REQ_OP_DISCARD);
>> +	sector_t sector =3D bio->bi_iter.bi_sector;
>>=20=20
>>  	if (mddev_is_clustered(mddev) &&
>>  	    mddev->cluster_ops->area_resyncing(mddev, WRITE,
>> @@ -1540,6 +1541,7 @@ static void raid1_write_request(struct mddev *mdde=
v, struct bio *bio,
>>=20=20
>>  	if (!wait_blocked_rdev(mddev, bio)) {
>>  		bio_wouldblock_error(bio);
>> +		allow_barrier(conf, sector);
>
> [Severity: High]
> This is a pre-existing issue, but does this early return path also leak t=
he
> mddev->writes_pending reference?
>
> In raid1_make_request(), md_write_start() unconditionally takes a per-cpu
> reference on mddev->writes_pending before calling raid1_write_request().
> Normally, this is released via md_write_end() inside close_write().
>
> By directly returning here after bio_wouldblock_error(bio), we never call
> md_write_end(). Does this permanently leak the writes_pending counter and
> prevent the array from transitioning to a clean state?
>
> It looks like this same leak exists on the clustered area_resyncing and
> wait_barrier REQ_NOWAIT failure paths earlier in this function, as well as
> the err_handle path if bio_submit_split_bioset() fails.
>
>>  		return;
>>  	}
>
> [Severity: Critical]
> This is a pre-existing issue, but is it safe to call wait_blocked_rdev()
> here without holding the RCU read lock?
>
> Looking at wait_blocked_rdev():
>
> 	for (i =3D 0; i < disks; i++) {
> 		struct md_rdev *rdev =3D conf->mirrors[i].rdev;
>
> 		if (!rdev)
> 			continue;
>
> 		/* don't write here until the bad block is acknowledged */
> 		if (test_bit(WriteErrorSeen, &rdev->flags) &&
>
> It accesses the rdev pointer and its fields without rcu_read_lock().
> Could a concurrent device removal (via md_ioctl -> raid1_remove_conf)
> replace the pointer with NULL and free the rdev structure while we are
> dereferencing it here, resulting in a use-after-free?
>
> [Severity: High]
> This is also a pre-existing issue, but if we proceed past this point for a
> REQ_NOWAIT bio, we call alloc_r1bio() and eventually bio_alloc_clone(),
> both of which use GFP_NOIO.
>
> Since memory pool allocations with GFP_NOIO can block when the mempool is
> exhausted under memory pressure, could this cause REQ_NOWAIT writes to
> sleep, defeating the purpose of the REQ_NOWAIT flag?
>
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611132500.76=
3528-1-abd.masalkhi@gmail.com?part=3D1

--=20
Best Regards,
Abd-Alrhman
