Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F230B15665C
	for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 08:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766651507; cv=none; b=XiHVi9irrpEgj8b8FTd0yXQ8X95gDHQughW5jHrLAgyDZhYUzueyK9e2aN+WenlXarIcZSzV78rjw6xSMc8Rjv10ZtUjlkIlIJfKnBRnID3aeWQsfzSHHuZpw7lBmFGcyOop49Hglp2JJWWZaH5qLfSUj01SUnQV30yTP+MyVa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766651507; c=relaxed/simple;
	bh=70QGiWbs8tZkgFANiDh0+NkDfZpAmXR5UYg3MK726Bo=;
	h=From:In-Reply-To:References:Content-Type:To:Subject:Cc:Message-Id:
	 Date:Mime-Version; b=tawZvOt8pRyHNqPMRSoqWnrlIJB7DP6FiNz77NXRrFXNqsqkZo1+H/Zr9xtNYhpYkSgQVjxoLl+qX8tTUHL/YTQtMJb/W8CjJl72jMD3RAUdLyoLvsLLel/1djLi4vooJxWhEU5t0uX4GYeBlPxfgs/Oiz0UNqB3lwSScdsw8fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=GZU9lPAH; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="GZU9lPAH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1766651460;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=icTGoePVVcIxj/grYIkGip77d4Hq7eAhcTIy+aryr9w=;
 b=GZU9lPAHf/+TMa4uwdBQIk+qFoxq55whvMiGdLQp8OHO0TzJ7QWUJFC0nhoW1MwObVXO+j
 p8LuAOEwymatYui7ZfT9Ltt6ahIV5Ochkro5YFc78wf88X6Xu+2I99pxbtigYB5tZ8xV2H
 Gz3BAce7pJih2tQloK7Qau41t6V26r8ntQfSX7M3pwtDl9LrBu21v1BPqkeD23jBiDEU77
 oL9bgA5AipiGAHkdUwkI/Hbb+PBRsHmWWPNOUy5Wjtfm0Xxbr3RxYOQTE6Yg4Dzt5T6Kqq
 Mn2+a2XW6MItKJ6f4CI9OShq2oJA5O+JiS1DmkV7HC2K8sDRa9iO/SflBEQWrQ==
From: "Yu Kuai" <yukuai@fnnas.com>
In-Reply-To: <20251219092127.1815922-1-linan666@huaweicloud.com>
References: <20251219092127.1815922-1-linan666@huaweicloud.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fnnas.com
To: <linan666@huaweicloud.com>, <song@kernel.org>, <xni@redhat.com>, 
	<linan122@huawei.com>
Subject: Re: [PATCH 1/2] md: Fix logical_block_size configuration being overwritten
X-Lms-Return-Path: <lba+2694cf642+46ca56+vger.kernel.org+yukuai@fnnas.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>, <bugreports61@gmail.com>, 
	<yukuai@fnnas.com>
Message-Id: <ba265bd3-1585-4a84-9ed0-32a3c6775c3b@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Thu, 25 Dec 2025 16:30:57 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Date: Thu, 25 Dec 2025 16:30:56 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US

=E5=9C=A8 2025/12/19 17:21, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> From: Li Nan<linan122@huawei.com>
>
> In super_1_validate(), mddev->logical_block_size is directly overwritten
> with the value from metadata. This causes the previously configured lbs
> to be lost, making the configuration ineffective. Fix it.
>
> Fixes: 62ed1b582246 ("md: allow configuring logical block size")
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/md.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)\

LGTM
Reviewed-by: Yu Kuai <yukuai@fnnas.com>

--=20
Thansk,
Kuai
