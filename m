Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EA927A12F
	for <linux-raid@vger.kernel.org>; Sun, 21 Jun 2026 11:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782039960; cv=none; b=hIHkOxGdZzM8JGjOSphjwp5Rk7xIAWtgSn4gG0zxNtdV8o/No/6iVPtpCa2VcAdvTJb40sibFnlqZMzQ6IpRgmscz/bLkxXX6KJwk9UbfsaHGsUuV8o/BpfmOmbYbjRLWmFpfdDwFWhnWsD5DPnrUuFXTU0hsNbtGd7oZqYswKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782039960; c=relaxed/simple;
	bh=S8g+Yb4LC3835NdJW21zFgho7+utbXRp9nSrlT2Nuro=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JlyFCWZdXyddIJet8N8wvbIRa/HlPNOptSL8M0Ov8LTAXb8gw2Fq0JccvYMWphGEVgTVRsSr2E7pc1bA2aKcnPEwKGznyVA7GYH968y9Et0j26chZJD1qt6lYACWHt1qldExvZTDD2qP2FFiLzf/badjIPQYP4JCRhCb5vJ6YHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J6mXhEwb; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6mXhEwb"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4905529b933so33440875e9.0
        for <linux-raid@vger.kernel.org>; Sun, 21 Jun 2026 04:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782039957; x=1782644757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P6qCbctGU9YtgCNvyYnx6Q2LOX2NS4PdIhxDYYp5m4k=;
        b=J6mXhEwbLMFoSV2U4fLU4cwxYt9a92rHIqQY+oHIuBwAaInsU2igvw7a2Z3xPEZIak
         5OHvXO9fzV8lrDlSzn90idCetpfMxvKpWcp/3M52vbA4kKyd3xK0RdCeEWerTJ/E7eJo
         WQUaemyiJzZd4CfWSftOSuUWRrG0460xJQRvoPVbx2o8AJ91/ku4Xw9FbTx5Jnynvxkr
         ybWqG3eSb6hIrDr96kxR0dY28QusjMb5Hd4X/0RZBnrKrEQUlg4llcFTUKxacWutINuT
         npBOx1JgQi2iYOwI8FEFBJ4wrPXcXkhmIA1e+1YeL3dOrg0EItrUJr97/X1gEtd4dfrm
         SmOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782039957; x=1782644757;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=P6qCbctGU9YtgCNvyYnx6Q2LOX2NS4PdIhxDYYp5m4k=;
        b=quEJ/EDA307YZudGX+BKnP9nwLVuQaBjcd5lUbJImwap8COJUv3tXvy06yU99RIjDF
         ufkBEqHZduNzOmCiySUVWIqFUyoMPgPlArzT0uF7WLpfQVVHRjwskp5xWw6LaKuUB0Ht
         Dju24cFsxX2EEyT6+32C7yDQvMnPh5HLLa3xex1lX9s6WCamAN3qy9Mj+OdPqHqqBVaU
         vu9THdBgGgb+LB07yKu3iOHDOYQbyYIO4YBv5UZNe2DRsjhlTrjT10csRU0CWzKd0tkm
         x5hTu5cxMoB9h4unZ3Y24YwdfhWznOyamfthnSKlq1812omh1Ah3kWDg4NEf4zcyjaBA
         6LKg==
X-Gm-Message-State: AOJu0Yz3RbxgFylvtasL8MwQz8Vm2pQJxCy7DQJELHS/wTolIJi/OJWu
	w9eu8g1N2m0mBMsJAKYlhQ6l2nD5DRrMxt4rkIufsEVBNmx6J9PbaMU6
X-Gm-Gg: AfdE7clVPyakGdBzAaceVHpshKw7S9zMN9s9lDbVJAx2yd3oLgIDFGbFoRJoBeIc7tm
	/1DhX1qh7qdKkGuFWSclj/PRE7gxE4BClrSYSoJsM/KKveXF0hganq5yLujZ+Ri+Q4czztdsTDW
	1FPPCASDVStOdZLwRZfAk0YOA8CCGSPjv9BTOUAvuW7ZPnqFR1P0Sf4O496WC/7EG9xb6dBucgF
	QzgHHo+W8WL8ecQNlGWy4DLWioJFg2todPfu2R/zsup0CQxpeOVsak9Y2xxehClqjTs000Il/hv
	flMOzmlm+5G5kv2rx4QnMFfzlr3wyjs8t02l3Q+J1//dUHp4BmsXByPLXyggzy8Ru5FVo1zvRBr
	hqYSkY3tXVp9565GLMC8PLN9VuiB/lpbQHS2qnHZl0a71mQRnYDb2Fzzy1QNZpXOczbP/dzLWUC
	gktCKQ7T1A/qUp6B5uyOngZ2+FU99bfdyEaB/cUKGJlcksKeghKimkGic=
X-Received: by 2002:a05:600c:3507:b0:492:433a:53af with SMTP id 5b1f17b1804b1-492433a552bmr156437115e9.16.1782039956683;
        Sun, 21 Jun 2026 04:05:56 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:615:2c89:25c9:4e1a:3e26:ebb0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49240084928sm219169335e9.15.2026.06.21.04.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 04:05:56 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: yu kuai <yukuai@fygo.io>, sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Subject: Re: [PATCH v2 2/4] md/raid10: fix writes_pending leak on write
 request failures
In-Reply-To: <ecaef394-23a2-43ec-a85b-2e25786914aa@fygo.io>
References: <20260613182810.1317258-3-abd.masalkhi@gmail.com>
 <20260613184042.BCEC01F000E9@smtp.kernel.org>
 <ecaef394-23a2-43ec-a85b-2e25786914aa@fygo.io>
Date: Sun, 21 Jun 2026 13:05:46 +0200
Message-ID: <m21pe02lx1.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kaui,

On Sun, Jun 21, 2026 at 02:25 +0800, yu kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/6/14 2:40, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
>> Thank you for your contribution! Sashiko AI review found 1 potential iss=
ue(s) to consider:
>>
>> Pre-existing issues:
>> - [High] The `r10_bio` structure allocated from the mempool is leaked wh=
en `raid10_write_request()` bails out early due to `REQ_NOWAIT`.
>> --
> This looks like a real issue, do you plan to fix this as well?

Yes, I plan to fix that issue as well. I'll include this fix along with
the other patches.

>>
>> commit 3940ccdb4c7c7e19c20f9b5e2e1d12545c2558b5
>> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>>
>> md/raid10: fix writes_pending leak on write request failures
>>
>> raid10_make_request() acquires a writes_pending reference with
>> md_write_start() before dispatching write requests. Several failure
>> paths in raid10_write_request() complete the bio and return without
>> reaching the normal write completion path, causing the corresponding
>> md_write_end() to be skipped.
>>
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index cee5a253a281d..c123a8c76ddcd 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>> [ ... ]
>>> @@ -1365,7 +1365,7 @@ static void raid10_write_request(struct mddev *md=
dev, struct bio *bio,
>>>   		/* Bail out if REQ_NOWAIT is set for the bio */
>>>   		if (bio->bi_opf & REQ_NOWAIT) {
>>>   			bio_wouldblock_error(bio);
>>> -			return;
>>> +			return false;
>> [Severity: High]
>> This isn't a bug introduced by this patch, but does this early return le=
ak
>> the r10_bio structure?
>>
>> __make_request() allocates r10_bio using:
>>      r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
>>
>> It then passes it to raid10_write_request(). When the bio has REQ_NOWAIT=
 set
>> during a clustered area resync, we complete the bio with an error and re=
turn
>> false without freeing the r10_bio. Could repeatedly triggering this exha=
ust
>> the r10bio_pool, causing deadlocks on subsequent operations?
>>
>> Note that the regular_request_wait() error path right below correctly ca=
lls
>> free_r10bio(r10_bio) before returning.
>>
>>>   		}
>>>   		for (;;) {
>> [ ... ]
>>> @@ -1398,7 +1398,7 @@ static void raid10_write_request(struct mddev *md=
dev, struct bio *bio,
>>>   		if (bio->bi_opf & REQ_NOWAIT) {
>>>   			allow_barrier(conf);
>>>   			bio_wouldblock_error(bio);
>>> -			return;
>>> +			return false;
>> [Severity: High]
>> This is a pre-existing issue, but does this path also leak the r10_bio
>> mempool allocation when waiting for a reshape metadata update?
>>
>> Similar to the clustered area resync case above, the r10_bio allocated in
>> __make_request() does not appear to be freed before returning here.
>>
>>>   		}
>>>   		mddev_add_trace_msg(conf->mddev,
>
> --=20
> Thanks,
> Kuai

--=20
Best Regards,
Abd-Alrhman
