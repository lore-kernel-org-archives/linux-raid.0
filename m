Received: from sg-1-34.ptr.blmpb.com (sg-1-34.ptr.blmpb.com [118.26.132.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5088E30101A
	for <linux-raid@vger.kernel.org>; Sat,  8 Nov 2025 10:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762599281; cv=none; b=PevZk5zLwiDoNEahlsJZ2mbT+GSe3gfavtFPgx1F1a0pK+QRJFeLUwtTRL32YOY9hQUUAznbVTNoNTGKtMBXzZyiEi9Nbk0r0sRSs8uiEuzQywyILqw12XZWJIzQGXvRug4P7ce31V1/KoZXxu7npLb1ipxX6CV2qjg8NT5X+KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762599281; c=relaxed/simple;
	bh=0GVj3ACe07K/h+AyMrlczP6e5xM+kLfFdLo2C820kZw=;
	h=In-Reply-To:Cc:From:Subject:Content-Type:References:To:Date:
	 Message-Id:Mime-Version; b=UzZb8bqTU+dupsUY4dwcqcxWlZuTytUmi2l0clRhvvs6+5970so+dU6Ezg3VVI7d9w7tvOjSWL1gN6xDpJeHFuele06g138+5IG3LfOfG4zc3e/J5Ir04L7HGpQyWN7xS/QpVls9OIvrrV4iUoJ/OXT9jpyKrNznIrHPLPfBqUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=Cerf2rmV; arc=none smtp.client-ip=118.26.132.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="Cerf2rmV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762599267;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Guaq5NganD1fb5mtOd6kdK7vET8R+EP9mTN9VfuZrl8=;
 b=Cerf2rmVDsDeRM+SHC2Jfumlvy6Z5UFojHThcm6B8T3nzshdpKV3yyu+HsuZzmQ3slsw1I
 fVSGjPilpTjze5DJZZMXVkPwGVqQU7uwXR/twWu8ij01eG4OMF4P/LKZ+5B0YyeH4RXXrC
 7fc0AggZeAwdGIgXgqwfQ4qtLPF9PB5g4C40jaGtvFkHZNpRjHgvA9ahfZZWB5QgHtB75F
 FcMK1tUY6SP3qytPpNAYBhbReae0iq1oxKHxZK3wO02tVgq5hLiQWwS0eD7TIjNYI/VhxB
 8leQs+sR0HY9Wc2vMGWNS8o6swGoyhe9Pb5n34vEitw4XMpSByZidKNtqPFU0A==
In-Reply-To: <20251106115935.2148714-11-linan666@huaweicloud.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<xni@redhat.com>, <k@mgml.me>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v2 10/11] md/raid10: cleanup skip handling in raid10_sync_request
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Sat, 08 Nov 2025 18:54:24 +0800
Content-Type: text/plain; charset=UTF-8
References: <20251106115935.2148714-1-linan666@huaweicloud.com> <20251106115935.2148714-11-linan666@huaweicloud.com>
Content-Transfer-Encoding: quoted-printable
To: <linan666@huaweicloud.com>, <song@kernel.org>, <neil@brown.name>, 
	<namhyung@gmail.com>
Date: Sat, 8 Nov 2025 18:54:23 +0800
X-Lms-Return-Path: <lba+2690f2161+e75e30+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Message-Id: <0800102c-1b48-4fda-9d32-0a50ec9dfde8@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Original-From: Yu Kuai <yukuai@fnnas.com>

=E5=9C=A8 2025/11/6 19:59, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> Skip a sector in raid10_sync_request() when it needs no syncing or no
> readable device exists. Current skip handling is unnecessary:
>
> - Use 'skip' label to reissue the next sector instead of return directly
> - Complete sync and return 'max_sectors' when multiple sectors are skippe=
d
>    due to badblocks
>
> The first is error-prone. For example, commit bc49694a9e8f ("md: pass in
> max_sectors for pers->sync_request()") removed redundant max_sector
> assignments. Since skip modifies max_sectors, `goto skip` leaves
> max_sectors equal to sector_nr after the jump, which is incorrect.
>
> The second causes sync to complete erroneously when no actual sync occurs=
.
> For recovery, recording badblocks and continue syncing subsequent sectors
> is more suitable. For resync, just skip bad sectors and syncing subsequen=
t
> sectors.
>
> Clean up complex and unnecessary skip code. Return immediately when a
> sector should be skipped. Reduce code paths and lower regression risk.
>
> Fixes: bc49694a9e8f ("md: pass in max_sectors for pers->sync_request()")
> Signed-off-by: Li Nan<linan122@huawei.com>
> ---
>   drivers/md/raid10.c | 96 +++++++++++----------------------------------
>   1 file changed, 22 insertions(+), 74 deletions(-)

LGTM
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
