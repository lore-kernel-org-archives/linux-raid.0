Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9403783AE
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 05:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775539801; cv=none; b=rfy6dIc2yl5twSGkEL4XCnxSyGoV/zJuHG+B+DqAR9RKwwmakyVKQxf5jTyF9HGCwW9cbdwWTbMh96JCoI7QxvREKbov+t79e9IvDSlrFJFMHKT9F/nVav38lffFlRssT1PvqgaCYU/10HqhQyZJCgkEhDhihKytE9gCmn8MCe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775539801; c=relaxed/simple;
	bh=2BRbOAC8WxFw4bj3xKZStvgQ5MyY6XGxQGM1nph4d7c=;
	h=To:Mime-Version:Subject:Message-Id:In-Reply-To:References:
	 Content-Type:Cc:From:Date; b=peXb/0a05kw4g60+gghWWMK5IIWMVfihEtjVvP+GYtdH1UDZugw5QALvqkz3R9ltq8CRnwf57rUwXntSS6LKZrldS14bgQy9DayhKkSuRhOhExvDsKSTUPrVCCcIni8b8YFQkuxZTE6MNq9UMovYK0Nzh4OQtIa7cdiOiJ1uedw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=OmvjOAhm; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="OmvjOAhm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775539788;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=PZgWL0HSBnkvmesJPKQf5yuJyS9664Wb9IXE9bYDUT8=;
 b=OmvjOAhmfjoiWvnGg/a71GJMW1S9MC+im6RNtuEjyKGnAMJrnrIsc9E3wZDk+grE2xu7Nr
 ObHQvOAFIV1wnlY/1ztVuJs5mnoBLPGBsPTJBc5cW8JvFa1WzuF4HNPb10kp7cOzaCG7L7
 OgB/VxVvtIKLs718xQjhO1nVQRxADNKw3PV2NoIBBr8bfUVfpbfn1vrfD/swuMxVVyIfZJ
 Fwqhtux/9wH5md9aKo+dvUtFS+0/FVg9jzypTdRbEoL9Bt688BW2LDFX/KXgICJ6yllBaY
 TbmbIDaP6JmxSIiAVgPU5Am4d/P4n647db0qHkz/cCZF3eHaJVH/8QBex+U/4g==
To: <linux-raid@vger.kernel.org>, <song@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+269d4964a+8004d1+vger.kernel.org+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 13:29:45 +0800
Subject: Re: [PATCH v3 0/3] md/md-llbitmap: add CleanUnwritten support
Content-Transfer-Encoding: quoted-printable
Message-Id: <dd81d0d8-b027-43dd-b2bb-4d29ba96706b@fnnas.com>
In-Reply-To: <20260323054644.3351791-1-yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20260323054644.3351791-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linan122@huawei.com>, <xni@redhat.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Tue, 7 Apr 2026 13:29:43 +0800

=E5=9C=A8 2026/3/23 13:46, Yu Kuai =E5=86=99=E9=81=93:

> Patch 1 improves compatibility with older mdadm versions by detecting
> on-disk bitmap version and falling back to the correct bitmap_ops when
> there's a version mismatch.
>
> Patch 2 adds support for proactive XOR parity building in RAID-456 arrays=
.
> This allows users to pre-build parity for unwritten regions via sysfs
> before any user data is written, which can improve write performance for
> workloads that will eventually use all storage. New states (CleanUnwritte=
n,
> NeedSyncUnwritten, SyncingUnwritten) are added to track these regions
> separately from normal dirty/syncing states.
>
> Patch 3 optimizes initial array sync for RAID-456 arrays on devices that
> support write_zeroes with unmap. By zeroing all disks upfront, parity is
> automatically consistent (0 XOR 0 =3D 0), allowing the bitmap to be
> initialized to BitCleanUnwritten and skipping the initial sync entirely.
> This significantly reduces array initialization time on modern NVMe SSDs.
>
> Yu Kuai (3):
>    md: add fallback to correct bitmap_ops on version mismatch
>    md/md-llbitmap: add CleanUnwritten state for RAID-5 proactive parity
>      building
>    md/md-llbitmap: optimize initial sync with write_zeroes_unmap support
>
>   drivers/md/md-llbitmap.c | 202 ++++++++++++++++++++++++++++++++++++---
>   drivers/md/md.c          | 111 ++++++++++++++++++++-
>   2 files changed, 299 insertions(+), 14 deletions(-)
Applied to md-7.1

--=20
Thansk,
Kuai
