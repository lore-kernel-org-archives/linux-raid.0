Received: from sg-1-33.ptr.blmpb.com (sg-1-33.ptr.blmpb.com [118.26.132.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F358A33D6EE
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 16:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770224069; cv=none; b=VSq6bHETjnz8Jkj3OP/2jFbTMvFHSkogAXkbHgJPItZC+tnRh3muZkw0vygTSGFg+aRfk2CzzSA/DIZ0EhceLJ9U6Ho0GxoyD4a06wiFzZVCl0ddvccBCS5DWf97uNZ2WZCb7BEXhX+vjL9K7np0YAg5zTNIyyEBXSD7VJv6b3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770224069; c=relaxed/simple;
	bh=rDcpCiB755euyeKw3H9RuPXIjv4xVG1EGWdJMaPCKEA=;
	h=Message-Id:References:Subject:Date:Mime-Version:In-Reply-To:
	 Content-Type:To:Cc:From; b=WtpWLfOiCVZTx1TVceCmy+fopiM5sMw1+45HDFDvz5JlFhFftZn4E+TK+CLvx1+MLA59bWXS5I09rPOn+hLk+YZsCqR/kLKwsSWyrX+eTo7Hl95LQcnyHSsIZOFYt8deaW5NX8Erl7pKj4wxwdMuWe/GGe7FvJCFrF7207Ut/9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Z9L1BNuB; arc=none smtp.client-ip=118.26.132.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Z9L1BNuB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770224056;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=uButQ8bwmS2AMpzpSbgQWrX+Rz5zRYXwvkk2AZIz8Q8=;
 b=Z9L1BNuB3FR3RhmtbWPu0sRbsocPSHm85TJkDU3RJAmJD67svZx40r7HNfXWrhpli+ttJm
 lwx1LXRTyy/mnQIIw+h/YRsvXJ0xDadyh4YzOpswEVA2vrr0nxAoHivEq6qtqyzkzayfaz
 NDYMSutv8UvlaE2aaSFwm68uAYN+7b2xXON4YP1Krjh+6bQ18uMmP7Zy8WeLTi8FN3lwnh
 fDT0zbnL2ZHQ2FQBcBLcyc0FC5rKe018bWhkLV69oL7XXT9S+9pp2CDK+PhcA687Ck8Q0A
 YW9K1w2d6r776gv5zMtOZPxnhwP48T0mN4FVMDpZesFBt4bJqAnMuE1Tsi8ZKw==
Message-Id: <32d38b25-ac47-4b0e-a630-abb7a058621f@fnnas.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com> <20260128075708.2259525-9-linan666@huaweicloud.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 00:54:14 +0800
Subject: Re: [PATCH v2 08/14] md/raid1: fix IO error at logical block size granularity
Date: Thu, 5 Feb 2026 00:54:12 +0800
Content-Language: en-US
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260128075708.2259525-9-linan666@huaweicloud.com>
X-Lms-Return-Path: <lba+2698379b6+b15465+vger.kernel.org+yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: <linan666@huaweicloud.com>, <song@kernel.org>
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>

=E5=9C=A8 2026/1/28 15:57, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> From: Li Nan<linan122@huawei.com>
>
> RAID1 currently fixes IO error at PAGE_SIZE granularity. Fix at smaller
> granularity can handle more errors, and RAID will support logical block
> sizes larger than PAGE_SIZE in the future, where PAGE_SIZE IO will fail.
>
> Switch IO error fix granularity to logical block size.
>
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/raid1.c | 13 ++++---------
>   1 file changed, 4 insertions(+), 9 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fnnas.com>

--=20
Thansk,
Kuai
