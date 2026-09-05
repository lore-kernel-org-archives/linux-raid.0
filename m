Received: from va-2-43.ptr.blmpb.com (va-2-43.ptr.blmpb.com [209.127.231.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DB42F5A06
	for <linux-raid@vger.kernel.org>; Sat,  5 Sep 2026 02:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788576253; cv=none; b=Pj6mOU8HFX6qMRW9QIWODmdd7hFd6I4GiHwx2aGEeIJCx6qp2HzSgVek62ayBU7b/Sxz9Uy8/eqdjae3b0CvBa4u2L6LdzgwJmgMQF42A/No4Jy/QzYrlnPT8s7tTq7VR4Wpq2S/paxMjuQR127gKivVn8XSyd80nV3AeI3Rbuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788576253; c=relaxed/simple;
	bh=PjLFEOJXzsiksEEWOe9DgEKZdTBW3QPu+gu8TAGEeU4=;
	h=From:Date:References:In-Reply-To:Content-Type:To:Message-Id:Cc:
	 Subject:Mime-Version; b=gtMPSqS69QfCUVRz09qW8oujJn5JrmZUiguGWjbc8fLAhTvQMtycqisFzsr2ZjHOl0/4TtcQn7swo9lPrQ7u+AwkIGeXz6rhx6an81Xq+hOIZGH0aloGsnR7L+VnTMtW9wXDfl6YcpDn7CiYnF40/R9f5SBh0AEh76EU4OSrpwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ADG0m9R5; arc=none smtp.client-ip=209.127.231.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ADG0m9R5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788576238;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=AS1vfi3VihSVIsjeaIeKxQPfiMDmXIiNUcRd+v/2Xx4=;
 b=ADG0m9R5s2QQzZZZBkkOqe/SsyFFECyEhFZv/k2porsr9Kw7fOWKKCbl8FTA/aju3iycpP
 oImifmJ2/WN25sUOZ86TMKwYzMTzZl0r2IkRvd/oxqRDNZ7JiPtt5z+9cU4caSUiFevd1b
 1K0h13Rh5A8waeVReiyHfuhyrYkLYVLVfzyw//145CB4ili/4i9J/+xVJfKF644tAaM1Hq
 adx1aNSofix4e5p6FLPBwO4WpQ2M4Iy3qU/MZpSxj6s5mmBn4j6RW/5gofTlcArcn0lnsi
 hWNpUbuvONpbg0ZQuRDwUb+DFwGTJGX4fNQxPTyX570cl+DCq74bifxWR76aCg==
From: "yu kuai" <yukuai@fygo.io>
Date: Sat, 5 Sep 2026 10:43:53 +0800
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260827075620.3599227-1-dayou5941@163.com>
In-Reply-To: <20260827075620.3599227-1-dayou5941@163.com>
Reply-To: yukuai@fygo.io
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
To: "Li Youhong" <dayou5941@163.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <b0d041de-deed-4a93-804e-5c0503595b81@fygo.io>
Received: from [192.168.1.104] ([39.182.0.178]) by smtp.larksuite.com with ESMTPS; Sat, 05 Sep 2026 02:43:57 +0000
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, "Li Youhong" <liyouhong@kylinos.cn>
Subject: Re: [PATCH 0/3] md: raid helper cleanups
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a9b81ed+4c7877+vger.kernel.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/8/27 15:56, Li Youhong =E5=86=99=E9=81=93:

> From: Li Youhong <liyouhong@kylinos.cn>
>
> This series factors a few repeated md/raid patterns into small helpers.
> There is no intentional behaviour change; each patch is a mechanical
> extract of existing logic.
>
> Patch 1 adds rdev_record_write_error() in md.h for the
> WriteErrorSeen + WantReplacement + MD_RECOVERY_NEEDED sequence shared by
> raid1, raid10 and raid5.
>
> Patches 2 and 3 move raid1/raid10-only helpers into raid1-10.c, which is
> #included by both drivers:
>
>    - rdev_bb_block_sectors() for the badblocks-aligned block size used in
>      narrow_write_error()
>    - flush_bio_list() for the bitmap plug flush path previously duplicate=
d
>      in raid10's flush_pending_writes() and raid10_unplug()
>
> The helpers in raid1-10.c follow the existing static inline convention
> used by raid1_submit_write(), check_decay_read_errors(), and others in
> that file.
>
> Li Youhong (3):
>        md: add rdev_record_write_error() helper
>        md/raid1-10: add rdev_bb_block_sectors() helper
>        md/raid1-10: share flush_bio_list between raid1 and raid10
> ---
>   drivers/md/md.h       |  7 +++++++
>   drivers/md/raid1-10.c | 27 +++++++++++++++++++++++++++
>   drivers/md/raid1.c    | 42 +++++++-----------------------------------
>   drivers/md/raid10.c   | 50 +++++++-------------------------------------=
------
>   drivers/md/raid5.c    |  5 +----
>   5 files changed, 48 insertions(+), 83 deletions(-)

Reviewed-by: Yu Kuai <yukuai@fygo.io>

Noted only bug fix can be accepted for current merge window, cleanup patche=
s
will be applied later for 6.4.

--=20
Thanks,
Kuai
