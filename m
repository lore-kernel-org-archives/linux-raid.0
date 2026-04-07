Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB041FF1B4
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 05:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775538391; cv=none; b=sHGktFS0nqnbCNAr4oT1dbkgyNtcmYpQh+90Rjh0ZZtS73M/gXshzXGcWQfNeCNYdnsTsQW83qngw4DmX+KIiiQG+BMDYPsZq8XC3Teq7g4kRHwmHTpKU9Gv7HODfpsOyXfiHolt34g87WHRSMHzX9gdPbSBYZHoNfgVOC01dT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775538391; c=relaxed/simple;
	bh=6r9vhZ1gwu2XznT5ZMylTasEqVB6FpVKpUl6vAKGh1E=;
	h=References:From:Subject:Date:Mime-Version:To:Cc:Content-Type:
	 In-Reply-To:Message-Id; b=L0G3K3g37UDoQJBYKNzQVYksYV1kQBcPJdrj0Higx1eA9BWMQTxJGsVi1ogW8uTynHljU1ieTTSBeSKrJyn7jkGfV1f8LcTcxh9k/J6S9k21oMCe3wpWoB5Pu3ou3j/CzwTuKvxRA9g8GE54CexTeZ6llQo/XsNrIwIsEV0ZLac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=MRhmzOTd; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="MRhmzOTd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775538384;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=MKPi8y8PdSpFcyowFDm1DUvLNnMU05AcHVXRyi7Ek60=;
 b=MRhmzOTdlg67zi/8ZKGOYd1NTalQiQTfU9guf4IjslsRqGJgEm87HaOzJdoFzXPbrbSYFP
 yc+ZLVXY/oHiTnw1NRYfsX4RxALZ0/wpNQtSPRayCD3vXfFiBaMjevQXInWuKj7p9bLxIR
 3ftSUTrP4eO2iaODQIMaMYyzdWxoZrDfhL6qgdbfnPhCb9uG0SUn0+gc6ECZuMcd0sP9BI
 IWz1Lo0A9uA28n5WvzFr/8pVr/unnHNRNrwmpN5nYKLJES6wP3qaptSm2thobSp2RhFdvq
 GqHUO2SUHzKRoSFvDRRBbchTtCvcQDKEk+ME2hV6+ro0jUChCxb17KmgDLI1eg==
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
References: <69adaba8.a00a0220.b130.0005.GAE@google.com> <20260308234202.3118119-1-gourry@gourry.net>
User-Agent: Mozilla Thunderbird
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH] md/raid0: use kvzalloc/kvfree for strip_zone and devlist allocations
Date: Tue, 7 Apr 2026 13:06:19 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: "Gregory Price" <gourry@gourry.net>, <song@kernel.org>, 
	<linan122@huawei.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, 
	<syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com>, 
	<akpm@linux-foundation.org>, <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20260308234202.3118119-1-gourry@gourry.net>
X-Lms-Return-Path: <lba+269d490ce+be8262+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Message-Id: <13f2856b-a5b6-410d-a39b-94cc48ca546b@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 13:06:21 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/3/9 7:42, Gregory Price =E5=86=99=E9=81=93:
> syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof(=
)
> triggered by create_strip_zones() in the RAID0 driver.
>
> When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
> on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).
>
> Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs =
to
> kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
> __GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
> corresponding kfree calls to kvfree.
>
> Both arrays are pure metadata lookup tables (arrays of pointers and zone
> descriptors) accessed only via indexing, so they do not require physicall=
y
> contiguous memory.
>
> Reported-by:syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com

Reported-by should be followed by Closes tag, applied tom md-7.1 with follo=
wing tag:
Closes:[syzbot] [mm?] WARNING in create_strip_zones - syzbot <https://lore.=
kernel.org/all/69adaba8.a00a0220.b130.0005.GAE@google.com/>

> Signed-off-by: Gregory Price<gourry@gourry.net>
> ---
>   drivers/md/raid0.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)

--=20
Thansk,
Kuai
