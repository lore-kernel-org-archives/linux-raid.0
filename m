Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9227D331A7B
	for <linux-raid@vger.kernel.org>; Tue, 21 Oct 2025 12:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761051018; cv=none; b=h4jzyk1QQrbJV9h9Ibrl12DZY7nOTmLvRmxYrbEt4uduRkIHcmkJixrrCPZSG1VgUzpJOAZBO4PZs1/ttv6k5cfX0qcF3d3Znd3F2xIXW8uo1OZq2XfyAF5lSfjXyFxTkECKpTMTiG1/n5nsIv5me9oPQ5qREoSxa76fuT9dU3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761051018; c=relaxed/simple;
	bh=7qRsgVoqW/1kgJM3rSjQYFVDEeduXr77x+EnxGyGvwg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=GQJLTiZlnKeX7Th3myUGfH9pKf2c/5WQRlj06b9rQSRq+BAmiGmxSDwe1p43sSCD7h448uD813ycVBS7IwklQ5YP2jfHje32N92uxTI9XYFWkOVQ8X4bKX7kYG6RZhAFeolkQibOxSpUFzgSYA07FNcQ6cA3D19iZBsMPniNev0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [134.104.50.123] (unknown [134.104.50.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id A602F6020D53A;
	Tue, 21 Oct 2025 14:49:36 +0200 (CEST)
Message-ID: <4ee519d3-b216-440c-8c2b-e94c229d536e@molgen.mpg.de>
Date: Tue, 21 Oct 2025 14:49:17 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Update Yu Kuai's E-mail address
To: Yu Kuai <yukuai@fnnas.com>
References: <20251021122800.3158836-1-yukuai@fnnas.com>
Content-Language: en-US
Cc: song@kernel.org, linux-raid@vger.kernel.org
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20251021122800.3158836-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kuai,


Thank you for your patch and congratulations on your new position.

In the summary, I’d write email instead of E-Mail

Am 21.10.25 um 14:28 schrieb Yu Kuai:
> Change to my new email address on fnnas.com.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   MAINTAINERS | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0554bf05b426..ec818c5b8cc8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4269,7 +4269,7 @@ F:	Documentation/filesystems/befs.rst
>   F:	fs/befs/
>   
>   BFQ I/O SCHEDULER
> -M:	Yu Kuai <yukuai3@huawei.com>
> +M:	Yu Kuai <yukuai@fnnas.com>
>   L:	linux-block@vger.kernel.org
>   S:	Odd Fixes
>   F:	Documentation/block/bfq-iosched.rst
> @@ -23610,7 +23610,7 @@ F:	include/linux/property.h
>   
>   SOFTWARE RAID (Multiple Disks) SUPPORT
>   M:	Song Liu <song@kernel.org>
> -M:	Yu Kuai <yukuai3@huawei.com>
> +M:	Yu Kuai <yukuai@fnnas.com>
>   L:	linux-raid@vger.kernel.org
>   S:	Supported
>   Q:	https://patchwork.kernel.org/project/linux-raid/list/

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
