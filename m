Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE12212564
	for <linux-raid@vger.kernel.org>; Sun, 22 Mar 2026 18:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774204419; cv=none; b=oeseeDKITNkQ9YE3sF/ocCJXieSgvBUB9KO8taFuVNvdNlD6gFk+hT3vrVKeSnyS0lMEAlE50dVJ7y40iQkK6H+9ruKb3b6tW1UFl99/br7NjFt15eEhL+qOifaWOfz2g9ZvmQzOaKQ6kVvTg3KcqXrwXJADg57KMGJkt7IWtnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774204419; c=relaxed/simple;
	bh=PekQ09BcuJMQzPI/PY/QPOcZBWqTDf62RGqR+cxx2mY=;
	h=Content-Type:Message-Id:Mime-Version:To:Subject:From:Date:
	 In-Reply-To:References:Cc; b=WeeZ8OkqiAHP2Pt1smOTyNQepobVLyna0uqm8OgOM/8YbEZp81qGc7uh5R4s2Qe80BXTcXRUwaXMDGAuLNPDcg9+1t1YyCVgPg9Uvj+k7KZ/zcyNll0Z1V3C2ZW/SfarlKGAoEfo7nJ3O1fZlnyJb1/1UJ/GfQqZVcfmAVijOeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=1Mx9GCeA; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="1Mx9GCeA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1774204414;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Y85aO7RZ/ssHKENWiMnuWQhhvNqoRiJ7NPyT8ssbVP8=;
 b=1Mx9GCeAs8mgojL0a+tmgmLsY8yG3KScqonTwLFFLpSg9C2Np0WFIEw1RnYIIWPuMTMgv2
 71mv3Zdr8v7gk4ZebKoMMeJDXvrqN4VkbK42ZiR2q3u7fcnuMqEMIKUAtE7X4AuloYb6Tk
 LmSuqFRIxF3DrWJbJfWMi6cxSvu5trShyKfOhgkNlbMqI605coTSzMNpwSLZMl9P9wwVNY
 LLbHA0sXfyaUfr7HlBM2NT8d7Lp4iVgZikvnwQmOdq5n57BniRrw+ZkaXl6L9e9coiSHon
 9g7fqlNHi3X70jUKDasCnXzwzL4VenjH3kqVYzUvphUPMC1xE/eb7XU9fNgCoQ==
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Message-Id: <4069e641-7de7-49f7-8553-19aff0b08a90@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yu Kuai <yukuai@fnnas.com>
To: "Chen Cheng" <chencheng@fnnas.com>, "Song Liu" <song@kernel.org>, 
	<yukuai@fnnas.com>
Subject: Re: [PATCH 2/2] md/raid5: move handle_stripe() comment to correct location
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Mon, 23 Mar 2026 02:33:29 +0800
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260304111001.15767-1-chencheng@fnnas.com>
References: <20260304111001.15767-1-chencheng@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.158]) by smtp.feishu.cn with ESMTPS; Mon, 23 Mar 2026 02:33:31 +0800
Reply-To: yukuai@fnnas.com
Cc: "Li Nan" <linan122@huawei.com>, <linux-raid@vger.kernel.org>
X-Lms-Return-Path: <lba+269c035fc+bdfa8c+vger.kernel.org+yukuai@fnnas.com>

=E5=9C=A8 2026/3/4 19:10, Chen Cheng =E5=86=99=E9=81=93:

> Move the handle_stripe() documentation comment from above
> analyse_stripe() to directly above handle_stripe() where it belongs.
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 26 ++++++++++++--------------
>   1 file changed, 12 insertions(+), 14 deletions(-)
Applied

--=20
Thansk,
Kuai
