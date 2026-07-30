Received: from mail-oo2-f9.google.com (mail-oo2-f9.google.com [74.125.231.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E4540FDB9
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 11:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785409641; cv=none; b=mWdekbbqZOGittTObdZF3AyixXYYFGZeHzuz75JYPx/rpvNxjrZi+jyxJcPzd8Z13A9VkxRyKK0dsTSSWh4NPCJRXvMXY0UiO0KZ2xx+ceqzuYJlfFWpX2jQhoKghKv/H23iSANuu7LJ8Br5aBHHHKioLVHalhlZz1DGhYxfaIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785409641; c=relaxed/simple;
	bh=irWaHmZAGIRRdUHsCyazMaPbnaFydrHJHEBjT64HdHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VHYKqquF4HBRWXjvubhQR569nR5awvgjYaufZ84jiLV3aFz/0EGUdIGl+V4eFkJsHA7q/z+10HHery5hdzDMUoAdNmOLQcAsdrjHpD3E5hutTBHimR70A98RthtTuuyNbwW9O0gjdN9DGJWUeMe22qwCTkIWy3P96IlKtfvodiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=vOUPABo+; arc=none smtp.client-ip=74.125.231.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="vOUPABo+"
Received: by mail-oo2-f9.google.com with SMTP id 006d021491bc7-6acae995679so168732eaf.0
        for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 04:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1785409637; x=1786014437; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6ykrmNqt47vR07SUEYkAcFeKnyGvZk3O/7dA2MPCpeI=;
        b=vOUPABo+Tbpig3J6theCbbpF6oJJ3wM26l+pB6XClYfp5iT0TeZvB5X3GlYSkYG9dN
         4dQwoeQU2ZvFE6BAYiakyRDNPd4u2R8CkvG1/j9WFDONwmkOiaaTCFGxdMGD4/+ORjhk
         J7CZbH3njhq1ZILrPd+8t69mgTIzmi5vyWZYR2krWFtS/85KOBlFWvLshvVv//QhEFS2
         SupnWf2ESH2pWRhhfOymGyPVTgwCYFCel/PgUntd2ePHZf5FXwvv4jw2EsDvEbMeX4n/
         1OuyHY/pk0vQqZe9VD4QpiZWYQEc6mA09hpS70DzSPw/+cwiLqwE3UhPxHSK3WzT5e9Z
         b/Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785409637; x=1786014437;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6ykrmNqt47vR07SUEYkAcFeKnyGvZk3O/7dA2MPCpeI=;
        b=mpV4WeC7j0LBiC1hgvh+N3i2+WZsRUHnLcNy043hb/t4PlcJ+W/8RtlnxXtuRhfL3F
         oYg9MBphtz/C6OsAnyvGg07ltNsOF3WXmozhmW8wvp8NQn4xolaw9YJ/0gGD+FrFVS8i
         ZLU6e7L8OPex1Ft+rBa2btAp2oisp1HqQdcUspdTSDTpDnzapMATPFXhjC54ffLeqxWm
         zAU7iNWCk6B1KHTVWGuCgWLp3rKv3DYToYZbnK+wC3O5TocYADTYQy9iDlur3UMGI7CL
         3u4d3gR7gJV66lT4JJmqD42Mjas5kL5X7HBN49veV7Fn2qn1AMDrBGIhS9FD4zpfBrjg
         w4QQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpvwa+tlChlGSsKT72U3OARG/emSCAlLE8B2DfzZSSftrcCESOof9k4c647o2W8f/lqWZP5FFBcorwy@vger.kernel.org
X-Gm-Message-State: AOJu0YxBzAERflP9cS/oOt35cJUrTs3AKooPBRc55gE/PwS9byt3IciV
	+2/bryfrtDC5N2dcMTTZMQsXJBxP1lxGR8wNk3EsI9mye8QvxI2PXySesDseObtATwc=
X-Gm-Gg: AR+sD11t0KYGwvUX1q1cfpOr7o9aGgvKPRLWFMD/1Zklp5+cfsF1D/yQWNIISpaaMDU
	ROQaEDqIfzi5gtmbuihzVWirKDYGGW4ioIY/JtdQmTrwgbmLwyaNJoAzsIiN3SHB6WL3aNK85O0
	JG7l/zKshO6SznT+ZxaadQIJlwA08PuUYexZxwlGO7pD4LmjT+Gj63PZV7inZFyk2/o+Bc4ek6V
	3fOk4xX01HUqrF2UxkqjpyNCIbyRviPeYLTYuOe0m7na05G5/N3tBeoRAt2KBoU3sIQN10Nlfi/
	9VHCUpH6iYubzZoMgP0qtNKXmvnWOihFZ0UfVj0NSdpbye5iUPbUbYcjLIq5gRxklt8MRPvIlJ/
	ZhrQcOL7zaMrNnzFqDhHvmnfyz3/vuWrSdyAih9tk3CVctfAQAQWQMso+T/R5A89UKrX773lKoy
	79CdVAx1KZGul2fI8k2FiVlCwxaXeBqMlcVKkuqzknaeVyzVHBkh6FSb2ad8O3Pw0IzqKJPeqOc
	aqlgeSiXYQ8m1V6ap4qoHKk7onK3ov/ojhubalz5IWwL2A=
X-Received: by 2002:a05:6820:c3da:20b0:6ac:c1b4:1a0c with SMTP id 006d021491bc7-6acc1b4206fmr512948eaf.61.1785409637549;
        Thu, 30 Jul 2026 04:07:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6acbc23238dsm1295940eaf.2.2026.07.30.04.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 04:07:16 -0700 (PDT)
Message-ID: <86d67b99-0bb5-4132-b412-9bb68ee4ca8c@kernel.dk>
Date: Thu, 30 Jul 2026 05:07:15 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: remove REQ_NOWAIT support
To: yukuai@fygo.io, Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
 song@kernel.org, magiclinan@didiglobal.com, xiao@kernel.org,
 vverma@digitalocean.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260628142737.1051059-1-abd.masalkhi@gmail.com>
 <07b0887a-e546-4d2f-b261-1fe7adb1d6e0@fygo.io>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <07b0887a-e546-4d2f-b261-1fe7adb1d6e0@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/30/26 4:50 AM, yu kuai wrote:
> Hi,
> 
> ? 2026/6/28 22:27, Abd-Alrhman Masalkhi ??:
>> REQ_NOWAIT support in md is fundamentally incomplete. While reads can
>> avoid some blocking paths, write requests can still encounter cases
>> where one mirror succeeds while another returns -EAGAIN. At that point
>> md cannot distinguish queue pressure from a real device failure, so it
>> can neither record a bad block nor safely retry the write without
>> REQ_NOWAIT, leaving mirrors with divergent data.
>>
>> Rather than continue advertising REQ_NOWAIT support that cannot be
>> implemented correctly, remove it from md and its raid personalities.
>> This simplifies the waiting paths and avoids exposing incorrect
>> non-blocking semantics.
>>
>> Fixes: bf2c411bb1cf ("md: raid456 add nowait support")
>> Fixes: c9aa889b035f ("md: raid10 add nowait support")
>> Fixes: 5aa705039c4f ("md: raid1 add nowait support")
>> Fixes: f51d46d0e7cb ("md: add support for REQ_NOWAIT")
>> Suggested-by: Yu Kuai<yukuai@fygo.io>
>> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
>> ---
>>   drivers/md/md-bitmap.c   |  9 +---
>>   drivers/md/md-bitmap.h   |  2 +-
>>   drivers/md/md-llbitmap.c | 10 +----
>>   drivers/md/md.c          | 15 ++-----
>>   drivers/md/raid1-10.c    |  8 ++--
>>   drivers/md/raid1.c       | 91 +++++++++-------------------------------
>>   drivers/md/raid10.c      | 80 +++++++++--------------------------
>>   drivers/md/raid5.c       | 13 ------
>>   8 files changed, 51 insertions(+), 177 deletions(-)
> 
> Applied to md-7.3 with a few changes, please check:
> 
> md: remove REQ_NOWAIT support from raid1/10/456 - 
> kernel/git/mdraid/linux.git - song's fork of linux.git <https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git/commit/?h=md-7.3&id=3fe5b7c9fb72ccc29bfd0f955b124892af7e3674>
> 
> - rebase raid1/raid10 with latest code;
> - keep nowait for raid0/linear;
> - keep nowait for md_handle_request, as raid0/linear will need it;

What's the plan for making REQ_NOWAIT _actually_ work with md? Just
yanking it wholesale is a massive performance problem, and it will
regress workloads. Has any time been spent on making this more solid?

-- 
Jens Axboe
