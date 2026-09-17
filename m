Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7058F382299
	for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 07:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789631635; cv=none; b=kcb62q53nAr/1uZR6QzZUtY3RZLtDYIRKC61bQONmpzzHjowcaew7MfTqDgWHfz2fhZUTQwK1rX3ZYGMzW88VFj0qcxafW2cHhbv5UjrqB9Qma0b59ah617iuyXZucA0RtLp4acjQKPM+G3U3GXXyPwTocFoEQiFFNkTcVtx0yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789631635; c=relaxed/simple;
	bh=dhdxXdklCeRaUeLKWvS1fppJHdD7P9vgQY218yfZvjM=;
	h=From:Subject:Mime-Version:References:In-Reply-To:To:Date:Cc:
	 Message-Id:Content-Type; b=UvbIN6ikYem3t/NKOQwbRKNO5GQj1UbMFKio1oufjszpb7iLc0UbqBQjwEAuWT5HN63E5bRrjqWKfw7TeHiRLwmmc9Qa5mx6OZfGNohu46X9svYsfr+osqnTHTKi9tmFvhZhUidJwOHEnCAbXKwPRDOdiKBxNM+9MoSe1Gll/kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=fP2oTPFn; arc=none smtp.client-ip=209.127.231.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="fP2oTPFn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789631622;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=TwQZqCn8xiv9CN3QQI/ypl25UsJxhfhLAHxtjxtzMuk=;
 b=fP2oTPFnh/6qjF9V9n7jj4CivCob66f7sQsKnsQ4zAUqKKIa1ZqYa3JUrqal8qIdZzK+1y
 fDdV7NtP/yQ2gmNuofC1P8KpdfHMTS3W/J86QFIalF7boH9lMas5u4DQFlfjheTNm0lgeb
 WS+rL2gtLfHE4T1gAri3lLAB5JCYsmEleFya4Sqro/2ZDMHpJluAb/rpQLh7ipiuzN1sZO
 kLbsRKuQZCQbcDOFy45jp9NHuI2/mQDqfh+oCWSvm2VrhnojVGs6SUZr/6FRA81+KaCiY8
 AxyguO4xnW/d7eaDN/EqeQOI843tjAIaB+DhSrg/hBqKHid2GMg3SJm7N5OX0w==
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Thu, 17 Sep 2026 07:53:41 +0000
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: reject a per-device size smaller than one chunk
X-Original-From: yu kuai <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260916095137.1157801-1-wozizhi@huaweicloud.com>
In-Reply-To: <20260916095137.1157801-1-wozizhi@huaweicloud.com>
Reply-To: yukuai@fygo.io
To: "Zizhi Wo" <wozizhi@huaweicloud.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, "yu kuai" <yukuai@fygo.io>
Date: Thu, 17 Sep 2026 15:53:37 +0800
Cc: <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<chengzhihao1@huawei.com>, <wozizhi@huawei.com>
Message-Id: <a0047cef-9fb7-4f2f-87a0-1d75f1e4e8ac@fygo.io>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26aab9c85+5dbfe4+vger.kernel.org+yukuai@fygo.io>

=E5=9C=A8 2026/9/16 17:51, Zizhi Wo =E5=86=99=E9=81=93:

> From: Zizhi Wo<wozizhi@huawei.com>
>
> Both raid5_run() and raid5_resize() align the per-device size down to a
> whole multiple of the chunk size:
>
> 	mddev->dev_sectors &=3D ~(chunk_sectors - 1);
>
> Neither checks the result, so a size smaller than one chunk silently
> becomes zero.
>
> In raid5_run() that is harmless: the array size is derived from the same
> zero, so the disk just ends up with no capacity.
>
> In raid5_resize() it leaves the array inconsistent -- mddev->dev_sectors
> becomes zero, while mddev->array_sectors and the gendisk capacity keep th=
e
> previous. A later raid4/raid5 -> raid0 takeover copies the zero into ever=
y
> rdev->sectors (raid0_takeover_raid45()), so create_strip_zones() builds a
> strip zone table whose zone_end is zero. Any read then passes
> bio_check_eod() against the stale capacity and hits the BUG() in
> find_zone():
>
>   kernel BUG at drivers/md/raid0.c:318!
>   Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
>   CPU: 45 UID: 0 PID: 1300 Comm: mdadm Not tainted 7.3.0-rc3+ #106 PREEMP=
T(full)
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc=
41 04/01/2014
>   RIP: 0010:raid0_make_request+0x10cb/0x16a0
>   Call Trace:
>     <TASK>
>     md_handle_request+0x566/0xb40
>     __submit_bio+0x2b2/0x600
>     submit_bio_noacct_nocheck+0x509/0xb30
>     block_read_full_folio+0x364/0x6d0
>     filemap_read_folio+0xa2/0x200
>     do_read_cache_folio+0x1b6/0x330
>     read_part_sector+0xb6/0x2a0
>     read_lba+0x17d/0x280
>     efi_partition+0x2a6/0x2520
>     bdev_disk_changed+0x6e0/0xfa0
>     ......
>     bdev_open+0x214/0xc40
>
> Reject a size smaller than one chunk in both functions, so that a running
> raid4/raid5 array always has mddev->dev_sectors >=3D one chunk.
>
> The check is done where the value takes effect, not where it is assigned.
> mddev->dev_sectors is written from several places, and none of them can
> tell whether the value is usable: the chunk size may still change later.
> raid5_run() and raid5_resize() are where every input is final, so one che=
ck
> in each covers them all.
>
> Fixes: eea136d69f9f ("md: fix buglet in RAID5 -> RAID0 conversion.")
> Signed-off-by: Zizhi Wo<wozizhi@huawei.com>
> ---
>   drivers/md/raid5.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
Applied to md-7.4

--=20
Thanks,
Kuai
