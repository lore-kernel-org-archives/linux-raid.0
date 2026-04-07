Received: from va-2-28.ptr.blmpb.com (va-2-28.ptr.blmpb.com [209.127.231.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0596B264A97
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 05:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775539841; cv=none; b=dz2YuxzO2z0RcbQv80xq1JhDVxmMaABvRogWwSHUwimXJtoX9kCbmsUPMy8WaiizTA78u/UrqXrDp7C8cHUz0UwHX8wrzl1TJ02jo2rU3UpI6P0eMUKrLKxVIwodxFMS4ISkWNMotwSyFrSEIIYIZCDS5nKggwraU90wl8lyxGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775539841; c=relaxed/simple;
	bh=MQKGkSVFDFTg/zU76UuYcCkGsGxQS2fMtSLYaNKM0Lk=;
	h=To:Date:References:Content-Type:From:Subject:Message-Id:
	 In-Reply-To:Cc:Mime-Version; b=sgVrZhrdh9b2TXZiPydSWrnsjQXUnxC9caEQ2G2DXwmNKKkDCtN9PJ2Whuth/e6d7pHtAxJCmjjssuJEhSnoIFjbOmn1KWWhznkQiKsERTXpcdMDaPrvi6xSu/Km7bHZhrNOGSSuWJ6lWjWYkrFZeEZX3ngIadG5YAp0BonjOVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=DMdbA4pe; arc=none smtp.client-ip=209.127.231.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="DMdbA4pe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775539832;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=u93gac+WLRz8UbZnDBa7qEKxhiAPbn1Yrzy4QJCKjvg=;
 b=DMdbA4peD1dclIOZq4SsTLlwa7VcyXaiJu8GSJjYu+XjnWRF6yU3SxPJle5D7cTR+N5GBc
 KmBl8QLZ0F/MxwHT7Jl2RzI5/x9qegjGjPF28NdQKk1XrazO53XDHlmmAxV3ALdP2PVsfC
 lLKo7VEPsitn81ndhYijffeKcm7Gxo5WXDetcz/J0ohwOZrnXuvKK/Y3MdjJ2oMRFJ3sSX
 qrBLqL2EmT/k+vt4qZ44fzLGUSB7wxXxl9kLJNRhgZDe8cqCN0B6h9bakDS0nv6XRlWxU0
 sBfUjBk6FwHqPjhIGhra8hh2Sd0Isj35/T/pbwjjKnsUzQdOcgEGNMixZ/rkkQ==
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "Xiao Ni" <xni@redhat.com>
Date: Tue, 7 Apr 2026 13:30:26 +0800
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 13:30:28 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269d49676+270090+vger.kernel.org+yukuai@fnnas.com>
References: <20260324072501.59865-1-xni@redhat.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v3 1/1] md/raid1: serialize overlap io for writemostly disk
Message-Id: <aafc7d27-ae0d-4580-b1f9-752d3e3e7324@fnnas.com>
In-Reply-To: <20260324072501.59865-1-xni@redhat.com>
Reply-To: yukuai@fnnas.com
Cc: <ncroxon@redhat.com>, <linux-raid@vger.kernel.org>, <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

=E5=9C=A8 2026/3/24 15:24, Xiao Ni =E5=86=99=E9=81=93:

> Previously, using wait_event() would wake up all waiters simultaneously,
> and they would compete for the tree lock. The bio which gets the lock
> first will be handled, so the write sequence cannot be guaranteed.
>
> For example:
> bio1(100,200)
> bio2(150,200)
> bio3(150,300)
>
> The write sequence of fast device is bio1,bio2,bio3. But the write sequen=
ce
> of slow device could be bio1,bio3,bio2 due to lock competition. This caus=
es
> data corruption.
>
> Replace waitqueue with a fifo list to guarantee the write sequence. And i=
t
> also needs to iterate the list when removing one entry. If not, it may mi=
ss
> the opportunity to wake up the waiting io.
>
> For example:
> bio1(1,3), bio2(2,4)
> bio3(5,7), bio4(6,8)
> These four bios are in the same bucket. bio1 and bio3 are inserted into
> the rbtree. bio2 and bio4 are added to the waiting list and bio2 is the
> first one. bio3 returns from slow disk and tries to wake up the waiting
> bios. bio2 is removed from the list and will be handled. But bio1 hasn't
> finished. So bio2 will be added into waiting list again. Then bio1 return=
s
> from slow disk and wakes up waiting bios. bio4 is removed from the list
> and will be handled. Now bio1, bio3 and bio4 all finish and bio2 is left
> on the waiting list. So it needs to iterate the waiting list to wake up
> the right bio.
>
> Signed-off-by: Xiao Ni<xni@redhat.com>
> ---
> v2: use prepare_to_wait_exclusive
> v3: return back to self managed fifo list to find the right waiting node
>   drivers/md/md.c    |  1 -
>   drivers/md/md.h    |  5 ++++-
>   drivers/md/raid1.c | 45 ++++++++++++++++++++++++++++++++++-----------
>   3 files changed, 38 insertions(+), 13 deletions(-)
Applied to md-7.1

--=20
Thansk,
Kuai
