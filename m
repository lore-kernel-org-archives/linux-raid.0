Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A61E56A
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 05:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775539936; cv=none; b=hujHLhQRWOA60OH5Pwe4sZQFrlb+nQLsjIQyR6Vw14wPHS3X28NHUkZItZbZqtcRdQzWDFpfvzdnAHfqcCYzXcNKxbKhlEK0ybBQW+XyOlwJZC53/Iqg98ZlNIqWpt2TBXOXIxm0palFfrY/0pPNyMA3symZF/oTXozYf072I8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775539936; c=relaxed/simple;
	bh=CyKYE4VRJZQCVEM/rWBqbr/+dTsRMS5yTF/Qvji8+uA=;
	h=Message-Id:Content-Type:To:Cc:Subject:In-Reply-To:From:References:
	 Date:Mime-Version; b=ACCgAhcGeahzG/wr02hAg8kKw16WWPbhTD5uQnJC71MsLi4PQtPzGPs179L/bx0ZbXBQ1DqCKJa9DWagnNfcomn/Gi3oPmIJrk8Sho20OShVMkKrUBd822cVnstF9QENArgTYyhyK4gu/jd7IBDUeiSMGtfMCnyvIMpJvnKfOww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=ttx/kov6; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="ttx/kov6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775539930;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=9NlP8gpSVwsjzSzR403/V/MDj8tT7lg95Qv8F44t8qg=;
 b=ttx/kov6yeunRbI9gQGBtVqsycrjkUQ+S75sZG8h8R5Kq/sGJ4m4LRo82LDCwV4cs+f2ad
 IzP8kHswvAqAUqSpa2JyWo12TkcWUqc0U3A3wcpjk5H71gHxn6sFaRMNS0CJJQFRG7PDKH
 gOqcyQLBeCWWam6WwHm25/xRqPqoFW6iQY5P31BMGuweKx8i7Og7Tgtz82SvhtZ+4nfHBc
 +tDn8Zuwb4a+tpKx8E4bx7aGkcw8w5N9dTdNnoFKPOEK9oZaJKdkwSpoF79YmG7RWhpOnR
 F1kNO6mFQGIjP557uex7wHhR8lPmXH/xlhaWYojG9/vqM2HuFdZkYgQBFxnTXw==
Message-Id: <c84c3acd-1c9c-442d-ab17-022b5f3590a3@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
To: <song@kernel.org>, <linux-raid@vger.kernel.org>
Cc: <linan122@huawei.com>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fnnas.com>
Subject: Re: [PATCH] md: wake raid456 reshape waiters before suspend
In-Reply-To: <20260327140729.2030564-1-yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 13:32:07 +0800
References: <20260327140729.2030564-1-yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Date: Tue, 7 Apr 2026 13:32:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+269d496d8+0156ca+vger.kernel.org+yukuai@fnnas.com>

=E5=9C=A8 2026/3/27 22:07, Yu Kuai =E5=86=99=E9=81=93:

> During raid456 reshape, direct IO across the reshape position can sleep
> in raid5_make_request() waiting for reshape progress while still
> holding an active_io reference. If userspace then freezes reshape and
> writes md/suspend_lo or md/suspend_hi, mddev_suspend() kills active_io
> and waits for all in-flight IO to drain.
>
> This can deadlock: the IO needs reshape progress to continue, but the
> reshape thread is already frozen, so the active_io reference is never
> dropped and suspend never completes.
>
> raid5_prepare_suspend() already wakes wait_for_reshape for dm-raid. Do
> the same for normal md suspend when reshape is already interrupted, so
> waiting raid456 IO can abort, drop its reference, and let suspend
> finish.
>
> The mdadm test tests/25raid456-reshape-deadlock reproduces the hang.
>
> Fixes: 714d20150ed8 ("md: add new helpers to suspend/resume array")
> Signed-off-by: Yu Kuai<yukuai@fnnas.com>
> ---
>   drivers/md/md.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
Applied to md-7.1

--=20
Thansk,
Kuai
