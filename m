Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F013D38D3EC
	for <linux-raid@vger.kernel.org>; Mon,  1 Jun 2026 09:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780305195; cv=none; b=aoet9PxxNPSqhLrRTAsOos0ro5wRDPWaQHWspH26/JJU/NJN5w8NyEFe4jlAqH2SgAz+odoOhaCL0V5SB+iDWouxmN/lDIsIv2UlCDODQbns29Fhgskx1G+EUNEwEiBzXCNQvU30JjRMB/Df8vmHeotZLDQ/cGCK7zVhpWY0Ouk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780305195; c=relaxed/simple;
	bh=YP9TT/jDK1Wv0mZG1HcXOJxjDg6boiyeKaCJrTSv6wY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZvmDB+Mip1Uf+K8IJ7WRDtwrr5b/q4AFVSc149d0EfkJhEMRtl06sO+/kkyAm3qZDie5NwXrblI0MNlC7R954o4/Hu96m66NqJSLEH1M1ALbsWfU7PZbHjFV+yPSt9PXyAfbhpZBfHwrAaD8qBrLVsV+5QlSqWnS7QZSnwbxMTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s88oa40d; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s88oa40d"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490a7876f8cso9609845e9.3
        for <linux-raid@vger.kernel.org>; Mon, 01 Jun 2026 02:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780305192; x=1780909992; darn=vger.kernel.org;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=VUZNHEKSSA2/z4oJjIxKqeXkvJAdwb6U4k7XSheRW0k=;
        b=s88oa40dOM0y0Cps1aD0PjRqs9Rt7ojdBxYO1Ww5EeC+yNV2CWUUmT5WCCX/zZ/Bi5
         QYavvLZmENAiZPtEQ3iS+8UnYtyVP+uDLvrJGPCEzVxOs99m9gQE6sPg8yn6L6PMBJkI
         /+PxuUVSDCE/RlDNMjgOpax6nwfidTNFJ06neFPNnflBd9hZAi9UKsNP0vclN19/Bf+D
         tt6cVmtGBJguM1dVUqlNljh1/X3ezJ6+69S4pcW5WVdkQd1zcCrnnhw6z2kyMOPcaZFa
         rEOvmeLaUvmxW861/P8K4J6eYcuOaG7vfO6rIoS5eXG4cR9WaiqfQIzHC738YxkXGz+U
         LoOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780305192; x=1780909992;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VUZNHEKSSA2/z4oJjIxKqeXkvJAdwb6U4k7XSheRW0k=;
        b=Dx2RXSMrgZmVlQWBLDf3CPifWrPgNObrKuInkfHnpcS98A6IJ/yXUlINk9pVnyoN+w
         zUKkVMMKaEtb/ZSkfZzFN/9Rp+rpAb0kWlIAceOx8KH1OTL3J7qdbzgPaIghXtLCJHlN
         mgmCdNSovGIty7hvsuXZ8xbPMveTT3n8pGcsJm5gl0PNWksdVpYnZjFES432QdiG7I6f
         g13Zo/uur5nBjFNx8A8Xkwn/o5wLMC6kqIdRTgGPBrw1ej6ZgDywCT33Wymw83j5i6y9
         AHVHDZ1werSwS0ju/vdryRRbfeQ7Pa9dXzH3LvLsWTQkzmT+0S03wnLvjSRPMcwoyHrZ
         UVnA==
X-Gm-Message-State: AOJu0YwAsPZv+qbiLQZiiktKxvfZWWSIEM+gb+bwqE8eZWpyCA2AYmCQ
	0zpWF7m2KdwXtf1ieW51dmRU2qYarRYCSl6lP+QfZ/eK+VWzzyWdbIl15DtI3bUf
X-Gm-Gg: Acq92OGPlCasIkHT3D+ElglyzNLbUOq0uGcwl3yL7VHPV+ltxGAcLCvXEejgykRX7im
	A43NUn5AppeoYzArKqaSnvsDnks0NH5hwjq2iAkqpepoUGSbLeMcHFVhPv+x6nOHYulZuYf6OCI
	wtxpJG2bAkdFnA60m66EOAV9qaqQXVE0F9ydMGHyBf6HW6ZlCXEEs5OATAr8lQzGmuDLz2Q2Dok
	naZXcdlt45ucvK6WZATN8Oo1EOxeGTMyDCsMwcrsWVkqBn/kJsAKMvT12WhglnaqsMoA6kkRfO4
	pHRvpAdPY+gznEYf+lbMnuqZKkvB4e7do2TIC7Pd04DZQKzotBf4LWI50MHGJ8xI0GDmxE9hFHb
	cKzMTIpj5F2291fd6cRYKYQGQOpt6Ql1tHpKvBwOw0YMsdKasrB8aJrp5PdyoAFlbcWcM397TNk
	Hq9ghmylfRO/KCBwS0agommOaoic+CKpUQC0zyWh0DkByZp6o+NFpdt64cmIAYg0BO/LrRYCqmW
	nE=
X-Received: by 2002:a05:600c:4f89:b0:490:4717:970f with SMTP id 5b1f17b1804b1-490a292ec27mr193701855e9.14.1780305192290;
        Mon, 01 Jun 2026 02:13:12 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:60b:2e65:8d3:ed5d:6174:8946])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354b7edsm23704665f8f.22.2026.06.01.02.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 02:13:11 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: John Garry <john.g.garry@oracle.com>, song@kernel.org, yukuai@fnnas.com,
 linan122@huawei.com, martin.petersen@oracle.com, axboe@kernel.dk
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] raid1: fix nr_pending leak in REQ_ATOMIC bad-block
 error path
In-Reply-To: <8f8ca66c-aaa6-4b51-bcd7-54203603ba8a@oracle.com>
References: <20260530151411.4119-1-abd.masalkhi@gmail.com>
 <d9c769f5-19a3-4724-b805-3e2f30541c64@oracle.com>
 <m2h5nmljj6.fsf@gmail.com>
 <8f8ca66c-aaa6-4b51-bcd7-54203603ba8a@oracle.com>
Date: Mon, 01 Jun 2026 11:13:09 +0200
Message-ID: <m2eciqlj2y.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


hi,

On Mon, Jun 01, 2026 at 10:05 +0100, John Garry wrote:
> On 01/06/2026 10:03, Abd-Alrhman Masalkhi wrote:
>>>> +++ b/drivers/md/raid1.c
>>>> @@ -1580,8 +1580,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>>>>    				 * complexity of supporting that is not worth
>>>>    				 * the benefit.
>>>>    				 */
>>>> -				if (bio->bi_opf & REQ_ATOMIC)
>>>> +				if (bio->bi_opf & REQ_ATOMIC) {
>>>> +					rdev_dec_pending(rdev, mddev);
>>> It's not so nice that we have 2x locations that does the
>>> rdev_dec_pending work
>>>
>> Are you suggesting deferring atomic_inc(&rdev->nr_pending) until after
>> the if (test_bit(WriteErrorSeen, &rdev->flags)) {..} block? The patch
>> is already in md-7.2; should I send a separate cleanup patch?
>
> I'm not suggesting any further change. I am just mentioning that it is 
> unfortunate that we have 2x locations which does the decrement, which 
> makes error handling harder to follow.

You are absolutely right. Having two decrement paths makes the error
handling harder to follow. Thanks for pointing that out.

-- 
Best Regards,
Abd-Alrhman
