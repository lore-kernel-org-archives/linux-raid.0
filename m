Received: from sg-1-31.ptr.blmpb.com (sg-1-31.ptr.blmpb.com [118.26.132.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6962FC02F
	for <linux-raid@vger.kernel.org>; Sat,  8 Nov 2025 10:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762597817; cv=none; b=A7a5AfsiyGqkQ9CabkXqZBdaFInLPj4b9+HJH5pOAWIh7UQpnLdiXC25MYVxk7KxAESiKPZPR34INKtjk00KxDKLdJFAKUkrWDlz22AO77QIk0VdRQth8qsr14Si3c53q0bfRiLSIK5gRetnWM9Ltl3dstU96B0gs2lvWSbTsUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762597817; c=relaxed/simple;
	bh=XvcFtdoPb11B7Q86cSe2ZgwI6rrljqo++OkFc5iBdbI=;
	h=Mime-Version:In-Reply-To:To:Message-Id:From:Subject:Date:
	 Content-Type:References:Cc; b=KXSpG0Fo3d4qTcqz1HCYUhjQmBXcFU/5kKeM9sGy4prH0dbH6U6dxhQ8hRxnIHm0I2Tprox8M/HQ5Yw0x9uZXADOY5vSuLwTR2vIeq0N3IiNOA7bP7/Myx9Aui2vucPYt0kS0mi6WDshNXcKm2Nt3P/SDdNjvJDzXcz4QmTnjxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=G5covuO3; arc=none smtp.client-ip=118.26.132.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="G5covuO3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762597808;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2CsV9iJgg1nuLYx+777LaO3NI+RBFzwp7DebOYVSqJo=;
 b=G5covuO3crpX5dFEw4ObJ2tlWAD9KhYpjDQEYn/zfS0FmFpW/QRQHRjuuo8qKk8giV22zs
 6ealfwZ+vEhOJSp+7ZiFL86h0EzjO8QbmTjequ7wT+CuqvV1xTjv1SwpjeeRbbWbniMDZ1
 YCWDZJIhHBdyAsAgOMy09TyhSUaIz9fSAfSABAqYIi/4Pzs+o+Di5gwLsoxmmIeo4gvrKe
 Ee+bqbPjLytZnjRIwZc2+98238SgLVkQmm9N9v6UqUlolgHgULsFMQ67ZNq0tLzgoMueZo
 eYlAmbuxHSh2LkKlfQClXsL9/HNksm6Xvagma+KZwAaNWKYHjugIYU5V44DYWQ==
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20251106115935.2148714-8-linan666@huaweicloud.com>
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
Message-Id: <9c1867c7-167b-4ce0-a7cb-053bf641a125@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Sat, 08 Nov 2025 18:30:05 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v2 07/11] md: factor out sync completion update into helper
Date: Sat, 8 Nov 2025 18:30:04 +0800
Content-Type: text/plain; charset=UTF-8
References: <20251106115935.2148714-1-linan666@huaweicloud.com> <20251106115935.2148714-8-linan666@huaweicloud.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<xni@redhat.com>, <k@mgml.me>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+2690f1bae+e9cbf9+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>

=E5=9C=A8 2025/11/6 19:59, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> Repeatedly reading 'mddev->recovery' flags in md_do_sync() may introduce
> potential risk if this flag is modified during sync, leading to incorrect
> offset updates. Therefore, replace direct 'mddev->recovery' checks with
> 'action'.
>
> Move sync completion update logic into helper md_finish_sync(), which
> improves readability and maintainability.
>
> The reshape completion update remains safe as it only updated after
> successful reshape when MD_RECOVERY_INTR is not set and 'curr_resync'
> equals 'max_sectors'.
>
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/md.c | 82 ++++++++++++++++++++++++++++---------------------
>   1 file changed, 47 insertions(+), 35 deletions(-)

LGTM
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
