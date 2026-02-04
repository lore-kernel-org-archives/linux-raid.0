Received: from sg-1-31.ptr.blmpb.com (sg-1-31.ptr.blmpb.com [118.26.132.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6AB33E34B
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 16:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770224137; cv=none; b=MSx2Y99QW1Pag2DQhjJTxSgyVXgF0t9n/nq4LeVCgCJMW2JDIedYZJ1Qk2INl3G+1F0v2ajRfrV17e5B5B6ugayotIRZMqz0MaTmqsnIJRql8ki0Y7Fr/NfF+4L+kID/LCOlkWV26SJ64WFoTFcg6SEcn0fxJup2mHADpncvNOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770224137; c=relaxed/simple;
	bh=xdPVMngZ0YwChB66HZirEY6crdcmzx6KAY1k46a1ne8=;
	h=Date:Message-Id:References:Cc:From:Subject:Mime-Version:
	 In-Reply-To:To:Content-Type; b=ge2XdkOKSeCdX12reRQxnMd8ECvxLPkXapGWfIW1BXVkrQMfZ2phh/ilO/6Dd66HGcPvfjVY0Dr/IGW4lbCaEMDmHnfyUzFO3C8WaUbQft2DiPsSb58YK84GsttliAu2EQCxirVqOeSk4rI9FaeLyRZp7+7MKdFsSVxfrs+y8wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=G3/AoF2a; arc=none smtp.client-ip=118.26.132.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="G3/AoF2a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770224124;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=T80fZPcY/zb87bcx9jPYVgo2Id8xJrPREbOUfIvyjG0=;
 b=G3/AoF2ahMZzwKHCCXNDfgJfiqZY6na+qT2J5Wo2faxusWY4x2zRhgx9eR3pgXZFuVPqyD
 JhTSeWJtfg7r2hejEi/Jdfhox0j9OBzIsN61ADjwElQQaD0vrcWpn3kB9PByqJKIRg7ozQ
 LFy1WZWPV38LPZvbu/n7JWoFkrYTS61qRHOiRNRFOtwkm4ZHGyiDZqHuA+IAW9COtaCax+
 PtlacQ5pjxiH2UBCz7FwaLFVM1uN4UeiQ2q+oZULmmj6jz3pGvWSF2TzCRjgmle0g+WXbm
 iF2hEV3v72uNoSwDEO54EhW8s/Jzx7gxh/xlmOv+LfbIn+jgjRieo3iMTf73gg==
Date: Thu, 5 Feb 2026 00:55:19 +0800
Message-Id: <1ea586a7-8c1d-43b1-a4dd-0ecbf13b2935@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com> <20260128075708.2259525-10-linan666@huaweicloud.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v2 09/14] md/raid10: fix IO error at logical block size granularity
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260128075708.2259525-10-linan666@huaweicloud.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 00:55:21 +0800
To: <linan666@huaweicloud.com>, <song@kernel.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+2698379fa+1d4123+vger.kernel.org+yukuai@fnnas.com>
Content-Language: en-US

=E5=9C=A8 2026/1/28 15:57, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> From: Li Nan<linan122@huawei.com>
>
> RAID10 currently fixes IO error at PAGE_SIZE granularity. Fix at smaller
> granularity can handle more errors, and RAID will support logical block
> sizes larger than PAGE_SIZE in the future, where PAGE_SIZE IO will fail.
>
> Switch IO error fix granularity to logical block size.
>
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/raid10.c | 18 +++++-------------
>   1 file changed, 5 insertions(+), 13 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fnnas.com>

--=20
Thansk,
Kuai
