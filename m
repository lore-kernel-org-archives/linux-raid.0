Received: from sg-1-37.ptr.blmpb.com (sg-1-37.ptr.blmpb.com [118.26.132.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6C63074A1
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 10:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767436583; cv=none; b=UmbgGqjHUFGdua1pUU0T1kxza4mkzKrxly+7Fb5Y8HyuKBBKWeU0eS1VBSYmLvgkEQQ6ldl7ZTSZvL2Siq/DeQnT9OYxe0Xo3OhVKONp6lZgIDZO1v+Py0RUVa9WJ/fOzOaCHoMCSRZ7Mm6qXJuxuEfIqCHHR3paOoNHoS8CUcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767436583; c=relaxed/simple;
	bh=X2/ehihUxRMoaP1woVIQwmKi+27iaR0agJWTCC0ymaY=;
	h=Subject:To:Date:Message-Id:Content-Type:Cc:From:In-Reply-To:
	 Mime-Version:References; b=nhuCg/qFPC/f5tUjXj8YBNjL5/0eZ8IMLgxd5szEOZfv4pgthAQdjaqMmGP/uB4e+HhW5xJo/QDgBgEvE/y25ig2ORl1beCJQ94fVsFpHeJdX6MApQfqQxxjuhF9bRT+6xLtmBMNWwCEwq+FztGbHorQvcDjaRWK99pWJFSrjIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=h/5GzTTR; arc=none smtp.client-ip=118.26.132.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="h/5GzTTR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1767436568;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Z3suxR9XyLrWWiQcwicKj7vGqMEHFOsX2laRhE+nQVE=;
 b=h/5GzTTRGFn+1gSoin+SSU/hQfUIbZ69L6RK5olMILs2In3IaqDVZdMLzDofwo14oCG+5A
 bnxGfDnaX2jO1w1YrMNFSNdCp/s/4/egjFhyLGrQNCtjKA6WVEPaQq3J7uknvNVIGfchNT
 YXXKrw6/H9JVWFLr17tVpno8Q+cTgngUONKP2pe+gyUNRWwhzT8m6PPzbO+4/kEJvldWRb
 EEfnlB9b9nUe+HiUj8+4KtKGsBGOa8gx+3aadyh1M2mrm1Dy+92o7uZwxNKPNY/RQ1/pUz
 8UafE7QR/z/revjdxRIVdzIy9cs7KsGZxoErbwVAvEQVZRYrsrgoCU/T4qRN6g==
Subject: Re: [PATCH v3 08/13] md: remove MD_RECOVERY_ERROR handling and simplify resync_offset update
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Lms-Return-Path: <lba+26958f116+9d773e+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
Date: Sat, 3 Jan 2026 18:36:01 +0800
Message-Id: <74d80322-6a84-4d03-b09f-0f9dc5c1bec8@fnnas.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<k@mgml.me>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
From: "Yu Kuai" <yukuai@fnnas.com>
In-Reply-To: <20251215030444.1318434-9-linan666@huaweicloud.com>
Received: from [192.168.1.104] ([39.182.0.186]) by smtp.feishu.cn with ESMTPS; Sat, 03 Jan 2026 18:36:05 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251215030444.1318434-1-linan666@huaweicloud.com> <20251215030444.1318434-9-linan666@huaweicloud.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>

=E5=9C=A8 2025/12/15 11:04, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> From: Li Nan<linan122@huawei.com>
>
> Following previous patch "md: update curr_resync_completed even when
> MD_RECOVERY_INTR is set", 'curr_resync_completed' always equals
> 'curr_resync' for resync, so MD_RECOVERY_ERROR can be removed.
>
> Also, simplify resync_offset update logic.
>
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/md.h |  2 --
>   drivers/md/md.c | 21 ++++-----------------
>   2 files changed, 4 insertions(+), 19 deletions(-)

Reviewed-by: Yu Kuai<yukuai@fnnas.com>

--=20
Thansk,
Kuai
