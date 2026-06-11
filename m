Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0794E3D1705
	for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 10:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781174982; cv=none; b=qKqz1IHUfazu1+JWSDWKQFThddclT10VWpncQDz6uOfw9P2F+UZEcgOLRzbsIHSA2CmN4sbVALTAdA1FeMrjRm5crIjdEvMqnJ+EkZ/Sl0S6KKT7AdVYEtkwbB/YqJqYOOzub0F8lJ4iTSigtj3x2rcOpTTiKfe7KFSSE8Pudso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781174982; c=relaxed/simple;
	bh=QxGt/qZpuh428S/K37oa/qKWhwxFOqVXN3XsqIbVzE4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=pd6cTUA1JHhknG0DhbSSfsOups8iY5vSMJ3A0AzcU9HwQX1XrgW5PU536fxhQvyDFOL5AMnh6eViRiIDU+OTqy8DWErFnc52qNku5wNj9hncdvPQjw1v3EIH3ESFBPuS6Cs20W7Ln9U+h7P1cxbWsxHcZsJsQPqrEbTNMiLPndo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rXE4CZet; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rXE4CZet"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so52347025e9.1
        for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 03:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781174978; x=1781779778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SwscJafaBugtAFcCVftAtVPNwhT6yYdKLLF+cCtGgwU=;
        b=rXE4CZetg2GVCbWjwydhmR7ToMFRbFAAW1yvfHYMDRgDh1i56SFZxObNbZ7iuC4nvC
         8GCS0Kem3JNXzhjDEH8d0ccG7/5dbHeEgYT5emdThG1M0JTERh1fFGUMFaWeub0yNQ5N
         cw8o0bEX8S4AT4SNRKAUhnmgrzCTt3oXrH+MrX5KaET2s64WCFPwy7jn71RRl9p5+D9s
         ipoi6FZW7KMRwi42xKVtvcc0xkVKLiC4N6GNWRuSc7h30fudeyvw7iI2Nb6rWqbogOuC
         1HNXi3z2JiRN7xpHUjL1mBzXt0gRCqaLjZJhZqRuXAcOGsUcP7DI4n9JVI3liVmmaJlJ
         FBqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781174978; x=1781779778;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SwscJafaBugtAFcCVftAtVPNwhT6yYdKLLF+cCtGgwU=;
        b=IV6lnN+X7t/DfcMY4/DCmgzaqN8nDwBglyZEWQ86HYuH7s9Y1MCcLZQoEkdPruCDNL
         987e4pnglcP2WqSaTyBiawvkY/sGQXyPnYhd9nBumamiXwkm8oTD/4yZ7bnirotwZFrT
         IxMDxqTElsdUrB/5GWFuMJlFmWT8JitJ072vIAXoqQh5rym6TKSJKRajVbhZW0LZerJ8
         phCf9h6npoCtcfCeXxLI5Xo6tYl9a7qNWd1fo4yNISESubQS995w2VegxTQ0XuMexJIW
         dcJvt+2AHdXppauR15pYjjJrnyXq8zfTWdCELzT6q4ig6wwimllg8eF+QuimBW7uQJ2Y
         pL5Q==
X-Forwarded-Encrypted: i=1; AFNElJ+1s+R3nwIs1wH0ygl4UEJmWGDkA3/T/77+ySakCkg0+z0sTqS7YQ/vzfHJIsKXTW04Pg4AaE6ZFY+/@vger.kernel.org
X-Gm-Message-State: AOJu0YypLM0/Zb1RwGduuEz4xTdJGM28TjyLBacIWdajkYI6rn4+XtXh
	01k/P04qT3gupD+PsdzaX1DRhVSo3lGEsWv22+DTc77u/Ls2UQdM/xUE+ddhyQ==
X-Gm-Gg: Acq92OEkVZTn4UrVLtnSh7Nu2L3vBd54jQhBtTXRFgfYvj2NWw8lt4kpH3U5PMUUi4c
	f8FH/N8KpP0ab9VENsbm4ch69I7roBJOO8aUUtHpXp3ve+WRX6FqdUpFZwcByRrlurXNtx2ULbB
	SS5xDrAkxy36hQM/PW8S7ymJR8GDf8z6F9yFphVvMnsk6OegsvxJFfbfn9BnW2S0ORspmu1NNzZ
	FK/45VHRLid85Sx39xb63O3ebp5VWTXGzYWvFzD4Ifnr4m6N5/pBWSpi1DjR82UXopavJH0ono0
	Nwz2o75eub/UeFiwVlnqvUlGGMU7oWCnjqf2l4PyopmhdX061tcEKTNOKn221BhUIyn6ppuSLmS
	aaowSoYGU3UYzTzrEm1VQp0RuG5SxcLV86aIOK7Bhl6czT3XvUgyHdXFribUzx088biwY0wk4A5
	6DdwHEBVjuQMlqMR4DrTuc4UjFBDKlW/zuZjlbnlfZJy3NiHHcESdiQfadTb1j/T/8mJQ=
X-Received: by 2002:a05:600c:4e0c:b0:490:bb45:79ee with SMTP id 5b1f17b1804b1-490e5379dbbmr34829715e9.0.1781174978208;
        Thu, 11 Jun 2026 03:49:38 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.162])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2cf582bsm60351095e9.10.2026.06.11.03.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 03:49:37 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: sashiko-reviews@lists.linux.dev
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
Subject: Re: [PATCH] md/raid1: honor REQ_NOWAIT when waiting for behind writes
In-Reply-To: <20260611084953.E078E1F00898@smtp.kernel.org>
References: <20260611083514.754922-1-abd.masalkhi@gmail.com>
 <20260611084953.E078E1F00898@smtp.kernel.org>
Date: Thu, 11 Jun 2026 12:49:30 +0200
Message-ID: <m2y0gll5c5.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2026 at 08:49 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Leaking pre-allocated `r1_bio` when `REQ_NOWAIT` reads fail `wai=
t_read_barrier()` during retry.
> - [High] Permanent barrier leak if a REQ_NOWAIT write encounters a blocke=
d device.
> - [Medium] REQ_NOWAIT semantics violation: memory allocations use GFP_NOI=
O unconditionally.

These appear to be pre-existing issues rather than being introduced by
this patch. I plan to address them in separate patches.

> --
>
> commit 7fed7389f4fe20e79eece974eaf3b8d317519e27
> Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>
> md/raid1: honor REQ_NOWAIT when waiting for behind writes
>
> This commit ensures that raid1 consistently honors REQ_NOWAIT reads
> across paths that may otherwise wait for behind writes. It modifies
> bitmap_wait_behind_writes() to return early instead of sleeping if
> the nowait flag is set.
>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 5b9368bd9e700..d03da046a5920 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
> [ ... ]
>> @@ -1360,8 +1361,7 @@ static void raid1_read_request(struct mddev *mddev=
, struct bio *bio,
>>  	 * Still need barrier for READ in case that whole
>>  	 * array is frozen.
>>  	 */
>> -	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
>> -				bio->bi_opf & REQ_NOWAIT)) {
>> +	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
>>  		bio_wouldblock_error(bio);
>>  		return;
>>  	}
>
> [Severity: High]
> This is a pre-existing issue, but does this early return leak the=20
> pre-allocated r1_bio when wait_read_barrier() fails during a retry?
>
> When a REQ_NOWAIT read fails its initial attempt, it is queued to the=20
> retry_list and handled by the raid1d thread via handle_read_error().
>
> That function passes the existing, pre-allocated r1_bio back to=20
> raid1_read_request():
>
> drivers/md/raid1.c:handle_read_error() {
>     ...
>     raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
>     allow_barrier(conf, sector);
>     ...
> }
>
> If the array is concurrently frozen, wait_read_barrier() returns false=20
> since REQ_NOWAIT is still set on the master bio. The code handles this=20
> by returning immediately, bypassing the err_handle cleanup path and=20
> failing to call raid_end_bio_io().
>
> Since handle_read_error() assumes ownership was taken and only releases=20
> its old barrier, does this result in a permanent memory leak of the=20
> r1_bio from the r1bio_pool mempool?
>
> [Severity: Medium]
> This is another pre-existing issue, but does the allocation path for=20
> REQ_NOWAIT bios violate block layer non-blocking semantics by=20
> unconditionally using GFP_NOIO?
>
> Even when REQ_NOWAIT is requested, alloc_r1bio() uses GFP_NOIO=20
> unconditionally:
>
> drivers/md/raid1.c:alloc_r1bio() {
>     ...
>     r1_bio =3D mempool_alloc(conf->r1bio_pool, GFP_NOIO);
>     ...
> }
>
> Similarly, bio_alloc_clone() in raid1_read_request() unconditionally=20
> uses gfp flags that include __GFP_DIRECT_RECLAIM.
>
> Since mempool-backed allocations will sleep under memory pressure=20
> instead of failing immediately when these flags are used, will this=20
> cause unexpected high latencies and potential priority inversion in=20
> asynchronous contexts?
>
> [Severity: High]
> This isn't a bug introduced by this patch, but does=20
> raid1_write_request() permanently leak the barrier if a REQ_NOWAIT=20
> write encounters a blocked device?
>
> In raid1_write_request(), the code successfully acquires a barrier by=20
> calling wait_barrier(), which internally increments conf->nr_pending.
>
> Immediately after, it calls wait_blocked_rdev():
>
> drivers/md/raid1.c:raid1_write_request() {
>     ...
>     if (!wait_blocked_rdev(mddev, bio)) {
>         bio_wouldblock_error(bio);
>         return;
>     }
>     ...
> }
>
> If the device is blocked and the request is REQ_NOWAIT,=20
> wait_blocked_rdev() returns false and the function returns early.=20
> However, it fails to call allow_barrier() before returning to drop=20
> the previously acquired barrier increment.
>
> Because freeze_array() waits for nr_pending to reach 0, could this=20
> permanently prevent the array from ever freezing again, deadlocking=20
> resyncs, reconfiguration, and array teardown?
>
> --=20
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611083514.75=
4922-1-abd.masalkhi@gmail.com?part=3D1

--=20
Best Regards,
Abd-Alrhman
