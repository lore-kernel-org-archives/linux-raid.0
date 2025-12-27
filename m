Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D098327E1DC
	for <linux-raid@vger.kernel.org>; Sat, 27 Dec 2025 02:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766801831; cv=none; b=cNsWpm2SuRSEkqMoFb2iLL+NqKDF77M3bKPCiGQNat9nWny3i9Pu9TZTLdKspd9fCBm8YYeT5PyC8+9QshlCRvzyLT+3nuuT3NGTRTd9qy8iIa2q1mP/342sSt38qLUhXQRCoxBIfnsmmMCfnFIRxFjvKdYem2sMNAxWVIeWzQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766801831; c=relaxed/simple;
	bh=OK+fK4+p8R0oaj03oTa78Kwgsi1ZCj/Suc+Y+cTZh+E=;
	h=Subject:Mime-Version:To:Cc:Message-Id:In-Reply-To:Content-Type:
	 From:Date:References; b=f52Ye0htelavkoVAbbDWifeqJKx3j1r/xkjK69aB+mKEk6M3GkNmMUABVCk/0MJBiAhFneEsYLsrCyK6ZMpAKJ5GuXnxoABwMuYOWVZUOWrSjoFu5CS2scoCj8IT/H0p+WZBSuBJbgLVYoSVBCNFeMkXphoCEm2+z4fU5idL3XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=xO+WF6Kg; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="xO+WF6Kg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1766801817;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=tEvsYyPvQCCgSy4PXBFwkP154HtwpHzjea4t8jH1cvo=;
 b=xO+WF6KgAT4KNY4CC+Vac26govYlsnwmrSXQyHoFDsah8tHOJ54TEzDc+BzqiypjzlP5Ef
 8y/jK7hcT1Fen/8ASrLahSIVZpxLYnw57KZ/8t7Nyhqc/sW/pLsAQHCnc09slY2AXsAxzA
 JBvUT4PYjQZxbzLFWQTsM8iuHoZP3m8E2C/yQNAjw6vmXDq3oDqcax0fuSXjsMm/79wMfI
 kA2fPXcrKfsXzQyBbFLAXrUhl9KNk6WZGfXXO3nTUgnzFgm/JidGZGKdDlvT0/ZGM0JnWc
 kre4BLGIz6WqswKZhzLO+KMFpZKa2cKKXfbFq0fEkE01G1Cv8JWX4oAbXjzX7Q==
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+2694f4197+940c65+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH v3 2/2] md: Fix forward incompatibility from configurable logical block size
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
To: <linan666@huaweicloud.com>, <song@kernel.org>, <linan122@huawei.com>, 
	<xni@redhat.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<bugreports61@gmail.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>, 
	<yukuai@fnnas.com>
Message-Id: <2d09972c-a864-45c3-b247-29e3d03ea2ff@fnnas.com>
In-Reply-To: <20251226024221.724201-2-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Sat, 27 Dec 2025 10:16:52 +0800
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Sat, 27 Dec 2025 10:16:54 +0800
References: <20251226024221.724201-1-linan666@huaweicloud.com> <20251226024221.724201-2-linan666@huaweicloud.com>

=E5=9C=A8 2025/12/26 10:42, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> From: Li Nan<linan122@huawei.com>
>
> Commit 62ed1b582246 ("md: allow configuring logical block size") used
> reserved pad to add 'logical_block_size' to metadata. RAID rejects
> non-zero reserved pad, so arrays fail when rolling back to old kernels
> after booting new ones.
>
> Set 'logical_block_size' only for newly created arrays to support rollbac=
k
> to old kernels. Importantly new arrays still won't work on old kernels to
> prevent data loss issue from LBS changes.
>
> For arrays created on old kernels which confirmed not to rollback,
> configure LBS by echo current LBS (queue/logical_block_size) to
> md/logical_block_size.
>
> Fixes: 62ed1b582246 ("md: allow configuring logical block size")
> Reported-by: BugReports<bugreports61@gmail.com>
> Closes:https://lore.kernel.org/linux-raid/825e532d-d1e1-44bb-5581-692b7c0=
91796@huaweicloud.com/T/#t
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
> v3:
>    - fix comment: %s/writing 'enable'/writing current LBS/
>
> v2:
>    - move warn message to mddev_stack_rdev_limits
>    - set current LBS to sysfs to enable feature instead of 'enable'
>
>   drivers/md/md.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 44 insertions(+), 4 deletions(-)

Applied to md-6.19 with a few wording changes:

   | Location            | Before                            | After       =
                               |
   |---------------------|-----------------------------------|-------------=
-------------------------------|
   | Line 5994 (comment) | configured in old kernels array   | configured f=
or arrays from old kernels     |
   | Line 6005 (pr_info) | config logical block size success | logical bloc=
k size configured successfully |
   | Line 6192 (comment) | new array                         | new arrays  =
                               |
   | Line 6197 (pr_info) | configurable lbs support          | configurable=
 LBS support                   |
   | Line 6203 (pr_warn) | data loss issue                   | data loss is=
sues                           |

--=20
Thansk,
Kuai
