Received: from sg-1-21.ptr.blmpb.com (sg-1-21.ptr.blmpb.com [118.26.132.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D1D2E62D1
	for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 07:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766648945; cv=none; b=oFzN7FAUyVWaPa4HkwRX28cvPHc4L94llxs/Fd4C5nQcCAAL9xtbExdNg7WOsygkE/U5F/WB5IlUsNZFVTl0xqvxcuM7ZNKXBPiw2umPXQyKLW9Y4uk1Q8q/JE9TedmoQdcOyRGTDDPIFvzviCFB8Z7q2n4PuIXo9tlbDOg3//w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766648945; c=relaxed/simple;
	bh=LKhB733K/kAUJNaXIQ6jIQ7/mQBN2TZGxE1j06rN4HU=;
	h=Cc:From:In-Reply-To:Message-Id:References:Subject:Date:
	 Mime-Version:To:Content-Type; b=q40emKLIwjVADUbODfMuTsH4Tdss7KCQe6qogdWV+9/QRwWD/Mb8YbnspPVnl3N4Lyl0GQg2Nq2VpHJpdLGIj2rgE4yRiMJ6jA+eftW8JALQ4vRWAlxyJ5/yyai9KBhrABF4PN2Z0GyxO+HWSkixBIkJWx8tK6vNG3y4O9SvRm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=2CIK71Sp; arc=none smtp.client-ip=118.26.132.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="2CIK71Sp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1766648822;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ku6kjQEzarKWtZWqxuoCPuEWT/o6jwhQidpELL9hJFg=;
 b=2CIK71SpiHx0XFU5Z9GmYki0xNap7MvJJ+vnc3Uz4NOh1MhTvyHHIvlgw4KIJXdAB8gBeq
 Hd6Rxb6IbVUyqBm3icY2nU0Xr3y84CwcD0VqXrmrebpE8H6FTRLDuvWxr+9UfJbzPws7uM
 j6nlJO6uhzVqpWehsaLvocFW7RySIhD8XHenKSAXqoYiE80oUwXAxF08cCfzRJ6WyG4zgp
 ZJlMS1wib9FzwFNthxUW0fFUEqJ6hqRs7dfdRfz0pjmXdiQPVF5FsOhaUYkQk90o/2G3jx
 etEyx66ycdfNPT6opiX5U2xEw4PG5WJwMmIP348ulmnifbv8+UDwSCr4EqI8uA==
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+2694cebf4+099540+vger.kernel.org+yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20251215124412.4015572-1-linan666@huaweicloud.com>
Message-Id: <e5c86347-2838-418d-b517-1e487e337972@fnnas.com>
References: <20251215124412.4015572-1-linan666@huaweicloud.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Subject: Re: [PATCH] md: Fix static checker warning in analyze_sbs
Date: Thu, 25 Dec 2025 15:46:58 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
Reply-To: yukuai@fnnas.com
To: <linan666@huaweicloud.com>, <song@kernel.org>, <hare@suse.de>
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Thu, 25 Dec 2025 15:46:59 +0800
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

=E5=9C=A8 2025/12/15 20:44, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> From: Li Nan<linan122@huawei.com>
>
> The following warn is reported:
>
>   drivers/md/md.c:3912 analyze_sbs()
>   warn: iterator 'i' not incremented
>
> Fixes: d8730f0cf4ef ("md: Remove deprecated CONFIG_MD_MULTIPATH")
> Reported-by: Dan Carpenter<dan.carpenter@linaro.org>
> Closes:https://lore.kernel.org/linux-raid/7e2e95ce-3740-09d8-a561-af6bfb7=
67f18@huaweicloud.com/T/#t
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/md.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)

Applied to md-6.19

--=20
Thansk,
Kuai
