Received: from sg-1-19.ptr.blmpb.com (sg-1-19.ptr.blmpb.com [118.26.132.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2022D2D5C76
	for <linux-raid@vger.kernel.org>; Sun, 18 Jan 2026 11:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768735838; cv=none; b=SlY/jBd7qNOE6pzt+xvuW0wyaSwWvsb99j+oZ+L3JQNOXeghk8HYyyhzr7Ib03VRc56LPLAs9qSiIZDBPQz0DRBdA84uyWnM9wRAMoFatFjCdxZB0NsEbYEiUmlzbsYtsa/VsmG0Wwvnb3ZeswknFnY/RquivLqLYlFw+WDxfdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768735838; c=relaxed/simple;
	bh=DeCDR7M+qjtZEpxi3j3+HNzxCqowkcLJOGjdDMWYk3c=;
	h=Message-Id:Date:To:In-Reply-To:Content-Type:Cc:From:Subject:
	 Mime-Version:References; b=BNUPu8eath6xBsKFBsqRKFDIuuFfObG45UuLSf8Od6biFWDkvIVzHjGLu55Ct2Cet1VxXoizbQMYtUfsRkMYL6NGx6sttj0aQkI1NunPqfrgtCUjIiGTtGu+UzCharF8qSzOz7oZ8lAeyrHdb1FYdzjoOOUGHVZcu8unSdF/irI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=s+AsadU7; arc=none smtp.client-ip=118.26.132.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="s+AsadU7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768735824;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=cckyOvHfS6SL1BH6zhxWnvHjt2KZDRn1enURqNG7Cdo=;
 b=s+AsadU7bfl6vCWw47KmwP7/61MiAl1BcrA8U0J7lfklyKm3adUxKxUkz4vU9kfkEmJ5/5
 XX17fhQXslw1fLhIy4+OhRTHFD08MjuhPLEbAh5l+xS7DuzrG/XovI1Bi9rlvBsfBMmppX
 hlVMOcJ+ZctxdXC202NRN6PSqmsmC0lG70fpG6twuII5NnLArXidL8bbmUz1JRkRbji401
 M45CyiAFByZRzONwHklWLmHC3n3anighWwdVZ+cjssm46h9riEf2Nakx6mZPlV6Yg+22KK
 XVuHkKy3Yqck/HghlOCGGVwt/Kh9DTfQdoGREjRo/hU6ewthfb24hIC9tIwDwg==
Message-Id: <54b38628-8ed8-47f2-bc37-ead9cb0d1946@fnnas.com>
X-Lms-Return-Path: <lba+2696cc44e+cedaf7+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Content-Language: en-US
Date: Sun, 18 Jan 2026 19:30:20 +0800
To: "Christoph Hellwig" <hch@infradead.org>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
In-Reply-To: <aWpT2N7S8l560MIP@infradead.org>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.feishu.cn with ESMTPS; Sun, 18 Jan 2026 19:30:21 +0800
Reply-To: yukuai@fnnas.com
Cc: <linux-raid@vger.kernel.org>, <linan122@huawei.com>, <xni@redhat.com>, 
	<dan.carpenter@linaro.org>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v5 02/12] md: merge mddev has_superblock into mddev_flags
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260114171241.3043364-1-yukuai@fnnas.com> <20260114171241.3043364-3-yukuai@fnnas.com> <aWpT2N7S8l560MIP@infradead.org>

Hi,

=E5=9C=A8 2026/1/16 23:06, Christoph Hellwig =E5=86=99=E9=81=93:
> On Thu, Jan 15, 2026 at 01:12:30AM +0800, Yu Kuai wrote:
>> There is not need to use a separate field in struct mddev, there are no
>> functional changes.
> It seems to be that right now the bitfields are persistent "features"
> while the bits are state.  This might not matter much, but it seems like
> there is some rationale behind the current version.

I don't think so, there are already flags like MD_CLOSING, MD_ARRAY_FIRST_U=
SE
that is set only in memory for a long time now. Anyway, it'll make sense to
split feature flags and state flags later.

>
--=20
Thansk,
Kuai
