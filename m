Received: from sg-3-30.ptr.tlmpb.com (sg-3-30.ptr.tlmpb.com [101.45.255.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E363115A5
	for <linux-raid@vger.kernel.org>; Fri, 22 May 2026 05:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779427483; cv=none; b=OcFDtvzDSUg5kwnR6I3b/yNYO345TKEOqM9pUNdzuJS6RbItBnaPy3X9oOTp572pKNYLGna0AdoVkctZeVEQ4/XGAShCp8b6mLqi4Rnntn1lxaCyIyx32goTazClB12io54bbZlx9K5wVOj8LWLIM5SvTK0sHDurNMdZAYRzXys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779427483; c=relaxed/simple;
	bh=fZLplu0qARg3rWmqZD/l4xsjhyX+5i3qNtyv2kBSyf8=;
	h=To:Message-Id:Subject:Date:References:Cc:Mime-Version:From:
	 In-Reply-To:Content-Type; b=sAfz6zURi1Q9ZwT/h9xIOjV7EjSbG0KrZTgQfoNp+2vYv/mgV3gTy2LGUyI0/L3a4/h8v+4jgvUGgBx81xMS5TzQy84iVceBh+F1fF+wy3llU+SK9Y7+Daf6p5jkdXPzsz8gUooW/pI0XDHSOfFMHXN4eYOdXWQNUp7oAcSjPCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=bTSmlbjt; arc=none smtp.client-ip=101.45.255.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="bTSmlbjt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779427431;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=AnKZF3Q2HpQjUsMKtbca+rRnkqV2Eb6xS0IGaJc3kqM=;
 b=bTSmlbjtnWHE7JLc+TUrZi1aR29oO8PVKdK8T3qRHkVpiBf3+cnB9bvh0bMkxEzSQQfv74
 KwurbqS/pGBoFzltfK9+akgvEOXt36VGh7pYwBGtA8N7BhUMo06FE0Y2BFO2QiuLBidORE
 zhjyQ+pdaf7cdqkYfd8IF5TBDz3Xu3frq2njucMvPiJ4FX1K7Gyb4y0kNBcPfE/XQE8vGX
 Kd4ieVQ6aZxI2IaOZesni7tMezPVjqjiHcnliA2pGrdUP3ZgMDE9MH0aSXfTsySg++UWsq
 5cE1ztfWjfzgj/aTDf4IFyYx5we4XTep/zFa8dF5Oq5mPAxlP4ZWmpQ2ppzVsw==
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<xni@redhat.com>, <neilb@suse.com>, <shli@fb.com>, <yukuai@fygo.io>
Message-Id: <9ec6fd21-5977-4308-8c58-b84f6332b012@fygo.io>
X-Original-From: Yu Kuai <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 0/3] md/raid1,raid10: fix deadlock and bio accounting in read error path
Date: Fri, 22 May 2026 13:23:46 +0800
References: <20260501114652.590037-1-abd.masalkhi@gmail.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
Reply-To: yukuai@fygo.io
From: "Yu Kuai" <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+26a0fe865+c1a2ea+vger.kernel.org+yukuai@fnnas.com>
In-Reply-To: <20260501114652.590037-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Fri, 22 May 2026 13:23:48 +0800

=E5=9C=A8 2026/5/1 19:46, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> Hi,
>
> This series revisits an issue in the read error recovery path for
> raid1 and raid10 when bios are split and resubmitted.
>
> In v1, the approach was to avoid splitting bios in the raid1 thread
> to prevent recursion and potential deadlocks. However, this was not
> ideal and too restrictive.
>
> As suggested by Yu Kuai, this series instead handles the problem in
> md_handle_request() and allows bio splitting.
>
> Link to Yu Kuai' email: https://lore.kernel.org/linux-raid/m2lde74dtw.fsf=
@gmail.com/T/#m714020a38b60fc5f84b9a24f0c46acbe5d7342d6
>
> This series fixes the above by:
>   - handling md cloned bios explicitly in md_handle_request()
>   - using md_cloned_bio() to reliably detect the error path
>   - fixing bio accounting to avoid double/missing accounting
>
> Changes in v2:
>   - Split fixes into separate patches for clarity.
>   - Use md_cloned_bio() consistently to detect cloned bios.
>   - Recognize that raid10 has the same issue and fix it in this series=09
>   - Allow splitting bios.
>   - Handle md cloned bios explicitly in md_handle_request()
>   - Link v1: https://lore.kernel.org/linux-raid/20260427103446.300378-1-a=
bd.masalkhi@gmail.com/
>
> Abd-Alrhman Masalkhi (3):
>    md/raid1,raid10: fix deadlock in read error recovery path
>    md/raid1,raid10: fix error-path detection with md_cloned_bio()
>    md/raid1,raid10: fix bio accounting for split md cloned bios
>
>   drivers/md/md.c     | 25 ++++++++++++++++---------
>   drivers/md/md.h     |  5 +++++
>   drivers/md/raid1.c  | 15 +++++++++++----
>   drivers/md/raid10.c | 28 ++++++++++++++++++----------
>   4 files changed, 50 insertions(+), 23 deletions(-)

Applied to md-7.2

>
--=20
Thansk,
Kuai
