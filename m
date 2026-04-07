Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592B6377579
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 05:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775539724; cv=none; b=DgDzESJaC7C0UzBLtpTvFFHTy0yyciNt7OHU566gjNgVzrsVdbdUgHrh3Hmi0U1EOZ2UR8NDKWNo2iEYOXgb/uT/fO8zktgryErVXmPGON54RWjpHGW8elRai6DFY+w252dFtNRLDPY0TWSIyK8jDcrP9I4+2fIIhqdZAW5oJeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775539724; c=relaxed/simple;
	bh=l7YJT4DXiaBKIEsSRPMpDRf9FozgUYDtwg9T+4g/OM4=;
	h=From:Message-Id:References:Cc:Date:Mime-Version:In-Reply-To:
	 Content-Type:To:Subject; b=C+pUYAtADox0LKih4sKjJuhOKsAWWreFH2d6M5LRZn4uG7S+Wc3o0nrWRbeCuv6vvTVkukvTmRd+cPvONyLgMHKjk9vxGeBWThg9FEPA+kWEnxhois61FZw3Yz4u6JhFjUJZzBvABgsfUzyxNZAam8RUsCDaZRF7jyVSRWR9DVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=tweCx11O; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="tweCx11O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775539710;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ry6YbbBi1KZu7bk7Ejs3jV/ttzlMY0yHesmy0HZhKTs=;
 b=tweCx11OxyDkz+T7TVRd7RNAp8R6Y+RgmcNUZHT9BaW+4zroXsvZiQfc3iTgmhZkTFT18o
 S9Kp+PCjNahf2Dao2O4e/G/dcPn/5/KVJYgFN+eAHXVj7YtdCU3ViZqLCohraLs8/AKC/t
 KrQQzqDWoEphEGCmFCdv/w2HDEwf/2lqCKddCRi58jB2TKKxOEQJLicDEhK+UjtSDZqrH0
 YyXNUXD7i+H4c0CkGzPpRLV2NMb+mggBFEnq8bkIUkYdruL1dfX9ipD72Am96WrRSu7AZC
 DFqLljumbsZtbjLuwTXBLryeqfSnx5v6nut+Zz2GbQJEHSdf06541VPpAvKtwg==
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <558d1df2-7a02-47b7-b1dd-cab4cddd23f4@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <SYBPR01MB78815E78D829BB86CD7C8015AF5FA@SYBPR01MB7881.ausprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Cc: "Song Liu" <songliubraving@fb.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, "Yuhao Jiang" <danisjiang@gmail.com>, 
	<stable@vger.kernel.org>, <yukuai@fnnas.com>
Date: Tue, 7 Apr 2026 13:28:25 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <SYBPR01MB78815E78D829BB86CD7C8015AF5FA@SYBPR01MB7881.ausprd01.prod.outlook.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 13:28:28 +0800
To: "Junrui Luo" <moonafterrain@outlook.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <linan122@huawei.com>, "Shaohua Li" <shli@fb.com>
Subject: Re: [PATCH] md/raid5: validate payload size before accessing journal metadata
X-Lms-Return-Path: <lba+269d495fc+8cc503+vger.kernel.org+yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/4/4 15:44, Junrui Luo =E5=86=99=E9=81=93:
> r5c_recovery_analyze_meta_block() and
> r5l_recovery_verify_data_checksum_for_mb() iterate over payloads in a
> journal metadata block using on-disk payload size fields without
> validating them against the remaining space in the metadata block.
>
> A corrupted journal contains payload sizes extending beyond the PAGE_SIZE
> boundary can cause out-of-bounds reads when accessing payload fields or
> computing offsets.
>
> Add bounds validation for each payload type to ensure the full payload
> fits within meta_size before processing.
>
> Fixes: b4c625c67362 ("md/r5cache: r5cache recovery: part 1")
> Reported-by: Yuhao Jiang<danisjiang@gmail.com>

I didn't found a report mail from patchwork, so I remove this tag

> Cc:stable@vger.kernel.org
> Signed-off-by: Junrui Luo<moonafterrain@outlook.com>
> ---
>   drivers/md/raid5-cache.c | 48 +++++++++++++++++++++++++++++++++--------=
-------
>   1 file changed, 33 insertions(+), 15 deletions(-)
Applied to md-7.1

--=20
Thansk,
Kuai
