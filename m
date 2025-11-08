Received: from sg-1-38.ptr.blmpb.com (sg-1-38.ptr.blmpb.com [118.26.132.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880C925743D
	for <linux-raid@vger.kernel.org>; Sat,  8 Nov 2025 10:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762596795; cv=none; b=h7PglBG/s75NWpOGoStO9fgd1XH6USblDVNsBmvHB/3eMEfXWHAXdHURdsx/FVJ2z2bPsNDWKUsXOZvt+IqbYa4qenfvTHthImAflPU+9Ozbcv7VUVuPyGi8Jl2JCBZx56XXzDrFBC9WPD5R5sND7Hq/WYaKjkd7Abn76IVugLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762596795; c=relaxed/simple;
	bh=UTMz9mZ8CrbmD3tm8n1OmiyowE5CZV81u5Xc34gm1Dg=;
	h=Date:Mime-Version:Content-Type:In-Reply-To:References:To:Cc:From:
	 Subject:Message-Id; b=ukhecUkpCOSk1MG8PAHNm9YK1ChUD0ImC9CWNAtQ/pk/drVLd616wZnhqo5FslwbbR/Ik0EkIzx/HuA8K0p76m8XXE5dcWT05u13Ojb+Ud3rgVQdoPoybjqPkKj1UTDLeckuyvkfS3sapj1/9ur+6vytFJXG7YgYnmk0GRgS6oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=fail smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=inNNDoO1; arc=none smtp.client-ip=118.26.132.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="inNNDoO1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762596667;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=As9vZLyUp565x8WqzAr/AY+rZQ4qn+Bn5PmSh9094bs=;
 b=inNNDoO1smvq5el0LoG1EUH1sZ7GLIdc0NENwM+jbP1AtMwFzgaLgj21+TGF3XrpYv2fnk
 mQqSbpq9ea7HwQcZcqdic0Oji58PCbaIP9Z8lzNxdIkyNls6yZxqiIVQYf9GQrl/EpBlqx
 9h8xw37zFOaSWm/PPom2I4pwt2pNT+LfsrKtFAGCDfZQU8dXfLX/HHs6ZOcRKcio/Ii0Ef
 XO3cOXXjj4LPFjuVrLoJ4AS00YiyVuFHPr94h0FpevVxoYfbo5Tye9NFxorbF5AWv4m4MG
 Wt1jHA3oWR8NJDHk2/3nWb2nkyHqs9VcLeeuNGOLq+hoK5ZjCdXnS5lTKZdCPg==
Date: Sat, 8 Nov 2025 18:11:03 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+2690f1739+32d6b5+vger.kernel.org+yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fnnas.com
X-Original-From: Yu Kuai <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20251106115935.2148714-5-linan666@huaweicloud.com>
References: <20251106115935.2148714-1-linan666@huaweicloud.com> <20251106115935.2148714-5-linan666@huaweicloud.com>
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<xni@redhat.com>, <k@mgml.me>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v2 04/11] md/raid1,raid10: support narrow_write_error when badblocks is disabled
Message-Id: <a66d22ae-8fe7-4af6-99c8-fb052c7affed@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Sat, 08 Nov 2025 18:11:04 +0800

=E5=9C=A8 2025/11/6 19:59, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> When badblocks.shift < 0 (badblocks disabled), narrow_write_error()
> return false, preventing write error handling. Since narrow_write_error()
> only splits IO into smaller sizes and re-submits, it can work with
> badblocks disabled.
>
> Adjust to use the logical block size for block_sectors when badblocks is
> disabled, allowing narrow_write_error() to function in this case.
>
> Suggested-by: Kenta Akagi<k@mgml.me>
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/raid1.c  | 8 ++++----
>   drivers/md/raid10.c | 8 ++++----
>   2 files changed, 8 insertions(+), 8 deletions(-)

LGTM
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
