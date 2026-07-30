Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A40400967
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 10:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408642; cv=none; b=lIi+fUEvKsUTl2QRi9FLRuZWEn7gaAclmKQVGjm89yIFf7BSqUVGYs7HpaIye4ImMqALwWbsHDxQlfKalfHmqWbilbfqLKvYzTrgBFBb87OYTx8eApwfJx1HrmvWrkhZGqwNdGs4hoRdZCr4v5VhtQjVwuFESoVPW8hg8onv1Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408642; c=relaxed/simple;
	bh=/1sE0Bkf/L3HZLyUENBu3d6MjdTf4BLYpYiR6RIGZu4=;
	h=From:Message-Id:References:To:Subject:Mime-Version:Date:
	 In-Reply-To:Content-Type; b=FltLcH/YdhQSWkrDCEYyoUNfzGxL7cozvm3SqhdodBhM1i4WPXE845DN61VP3iUVeYEx44JFM5PDldx4i4jU3kMxrMJ5lCDTROkdWyRXe3pZrBQL3i82yg2BAWCuu3+MwGHoRwtOeCv/wWCMJvQyubTvXgkJBFY8LZjXzo8VSxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RzyDnktz; arc=none smtp.client-ip=209.127.231.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RzyDnktz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785408632;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=O3NayEsacnjJhqbXheSph6Xc0rM/AAUu69minY9rkHg=;
 b=RzyDnktz0QEOv0W5i/NJO2+myZkdsOBjwxjYI5W7ZkV2P+r8eRBB0A6ezTyAljd8xNIOFZ
 XlV0+DNACd34yfFMvCIUIIqQNApCMLheQoR/AQpR2E9+fd9DKpvgMhP7yVSZdSJUP9JlUu
 SWvPcSlCs4inYxNz7NeixE6hsEiBcjhtmkb35qaiPc0g/PrgrJW1GafK7toi0upYBzzjpG
 jqu4K0dhbF5oDAJVnaVPNXHISgIK62RlykShb/nXsWL8G2YuuOVvpCDOaTfV+tz7GqA3hr
 noS50FL3K6HR0ESOdZyJW+dRqc0+3hFh2uuEKjtDrYxh16fK59IcZTqPFQJK9w==
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <07b0887a-e546-4d2f-b261-1fe7adb1d6e0@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 10:50:30 +0000
References: <20260628142737.1051059-1-abd.masalkhi@gmail.com>
Reply-To: yukuai@fygo.io
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<vverma@digitalocean.com>, <axboe@kernel.dk>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md: remove REQ_NOWAIT support
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a6b2c77+6d0a95+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 18:50:26 +0800
In-Reply-To: <20260628142737.1051059-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/6/28 22:27, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> REQ_NOWAIT support in md is fundamentally incomplete. While reads can
> avoid some blocking paths, write requests can still encounter cases
> where one mirror succeeds while another returns -EAGAIN. At that point
> md cannot distinguish queue pressure from a real device failure, so it
> can neither record a bad block nor safely retry the write without
> REQ_NOWAIT, leaving mirrors with divergent data.
>
> Rather than continue advertising REQ_NOWAIT support that cannot be
> implemented correctly, remove it from md and its raid personalities.
> This simplifies the waiting paths and avoids exposing incorrect
> non-blocking semantics.
>
> Fixes: bf2c411bb1cf ("md: raid456 add nowait support")
> Fixes: c9aa889b035f ("md: raid10 add nowait support")
> Fixes: 5aa705039c4f ("md: raid1 add nowait support")
> Fixes: f51d46d0e7cb ("md: add support for REQ_NOWAIT")
> Suggested-by: Yu Kuai<yukuai@fygo.io>
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
>   drivers/md/md-bitmap.c   |  9 +---
>   drivers/md/md-bitmap.h   |  2 +-
>   drivers/md/md-llbitmap.c | 10 +----
>   drivers/md/md.c          | 15 ++-----
>   drivers/md/raid1-10.c    |  8 ++--
>   drivers/md/raid1.c       | 91 +++++++++-------------------------------
>   drivers/md/raid10.c      | 80 +++++++++--------------------------
>   drivers/md/raid5.c       | 13 ------
>   8 files changed, 51 insertions(+), 177 deletions(-)

Applied to md-7.3 with a few changes, please check:

md: remove REQ_NOWAIT support from raid1/10/456 -=20
kernel/git/mdraid/linux.git - song's fork of linux.git <https://git.kernel.=
org/pub/scm/linux/kernel/git/mdraid/linux.git/commit/?h=3Dmd-7.3&id=3D3fe5b=
7c9fb72ccc29bfd0f955b124892af7e3674>

- rebase raid1/raid10 with latest code;
- keep nowait for raid0/linear;
- keep nowait for md_handle_request, as raid0/linear will need it;

--=20
Thanks,
Kuai
