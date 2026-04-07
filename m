Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584593C7E0B
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577873; cv=none; b=gAf5OniC+QtSSZdMfzBsunIt4c/DNREkRcW6PdaYCEfFkmA4c8yLmwpxTGVj8gZkzgsDrNQgZoGFBo3ob7bdeTxHhAKm0S9phNBC/FhqrHgalHrmGPuSNL7Wg/zYhQqUBcc3xmfsdZDJY3J7Vw8yXLjhbkE301CiOsx6zfvxfsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577873; c=relaxed/simple;
	bh=0LtPVIS+58NlXkqq+oYsK+YYFzJQtDyc/TE7ZXg87Ow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O74ekmSe1gZLkwFH43qwtKABT5qqJTNlk0LTrPvHVV02yVTm6bj4jaFPcaHOhy+Rs7B8RtxJ/y+kqvkzMBT6SxlXrt8NnRqgQz3I7TvpXZTtTa1L1rvBm7lQV1L2hw/r+HlQ498k5NFoznPzDrUGk62LqMaehaMgRmKfvQ6bg7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Ts7/lOiM; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Ts7/lOiM"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50b69bf5638so62841641cf.1
        for <linux-raid@vger.kernel.org>; Tue, 07 Apr 2026 09:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1775577865; x=1776182665; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T/Q48D8Y76BF4XdQr4Fvx/gDALKRR3Al5nOab68rKoc=;
        b=Ts7/lOiM0/ljOnIzTPgPjm2I+JZ7SUSC/1tUupd7UfACWDF/H9D1XFzFXJMBZEPgNf
         3eVPM4CYHy0MPhlsywVIUTNuJdVH2fNe9Limjj0soE48OgxZhitgu7km8yrmmbDmeZIg
         kP+sObZhOXyfN3tLSYfIks3vSeOK+Z8UJNSc7QM9ihbkRCufWlWJJWQz3GcLoVHyJETG
         wWnp4l7WhaLAb469ki0fmDwJk3sZeGSI4Lg5W21lZVmQk0qcuyTiJH7Jbnd1ZMwv1XwS
         sWTyCVj1ChJwgajg23ZKeFE2skeNAjD1o3AK6AAq4ylmFfTBA2nBo82xdQdq2y+Sp6od
         LuDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775577865; x=1776182665;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T/Q48D8Y76BF4XdQr4Fvx/gDALKRR3Al5nOab68rKoc=;
        b=D+GlOQ39/vI3yeBiBiT5OfJNd9kEWGUN/cJMkVp96V9i6VEFgvxBvpapr6xPthNKW3
         hyJrtrCLyGHlhLJerynd2xWa4BV54N3yTblCTTqjwKwCVigkqlYLxgkRINKXqsTKeM8g
         IigbTwW6mRwCWsbaMoMqT7v3SJbL09a3qZOxko8rnm1yP8/7GAaBW0MtAJH5Dv8LVrQT
         mbdHDSWtyQCDcPTRkNuphdy7SWj3AtdlOhE8ei/82ZDF2LlG/i1UKTeXV3BLyj3oh4gI
         PbjjBIZCvlI3yAQ9dct3qNbBPZi7cUzKAlroNk8Pwm3xvQLLyNt2KYaqLhJodw4aMN4w
         9+Wg==
X-Forwarded-Encrypted: i=1; AJvYcCXuuEdx6JUbu8XjWzkqBxR7og57+bJ0/ulKxIITGw5P9iCu4UwU6admBEY42aNZ5Ftm3wliDEqJVe/F@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1E/87HnI4/zelRpnLymX4f+8mQIcSrZZQJ3dSW2Mw7FhRp2mD
	lxhfUzUdLnj3gwzIQQtzqY2uu5JWlS54hIJDBAnMKh7kSDY+WV74sxcCkJxtgYrnTamvo/Ylbwd
	u+wCz
X-Gm-Gg: AeBDies9AWBgUsV+arRDGHcMEVd4EziAxqVvJefpT3XzKKafZXY7D5qMS1N+CWKanLp
	y6X7xebjyJlDoVpQFgMcyuy75UmLNjJPHhLnOnaB9sPabRiuzFTdMrAy1tJVZ8z5UTfz69vl/L7
	mdviecKlIp2R1via4HT35bpW5CdIvx06gmgWOe0GdlPUktbYqz4SPta7LQeEF4cP4JeLMG/9o8o
	BRnx2AqlRoXqN8A7n5P/C2ei3qVDd6I9RAi0rFdhcpZYEztYoAT1YAviWnO5dba0IyRHCfu+XWH
	jI3+NKtqv/742jcWgFYpQHXt6xI2vwqy3bKzDW8a8stLPtULbZLNc33F8Jsm9LnLTf37ffIaQ2U
	+W2jHPt5+SVfW6R+kRrNOIvP0UVKTJ/EjjtYQ8QJYbXnGegbTYMS2NBDJORlh/1h8KvvtjxKwst
	GxtFWl2hEZnnMUmtsXM8IsD4aTgbK47tKTKJMhoyLAkJvruq7xVctmaVMuzCiUsKMnMCESKM+My
	SsH3i0OnpQ5
X-Received: by 2002:a05:622a:138a:b0:50d:7c4b:5c5b with SMTP id d75a77b69052e-50d7c4b619dmr186155721cf.5.1775577864437;
        Tue, 07 Apr 2026 09:04:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4b73e7e5sm138468951cf.17.2026.04.07.09.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 09:04:23 -0700 (PDT)
Date: Tue, 7 Apr 2026 12:04:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linan122@huawei.com, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com,
	akpm@linux-foundation.org
Subject: Re: [PATCH] md/raid0: use kvzalloc/kvfree for strip_zone and devlist
 allocations
Message-ID: <adUrBdqowW_XeBJF@gourry-fedora-PF4VCD3F>
References: <69adaba8.a00a0220.b130.0005.GAE@google.com>
 <20260308234202.3118119-1-gourry@gourry.net>
 <13f2856b-a5b6-410d-a39b-94cc48ca546b@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13f2856b-a5b6-410d-a39b-94cc48ca546b@fnnas.com>

On Tue, Apr 07, 2026 at 01:06:19PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2026/3/9 7:42, Gregory Price 写道:
> > syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof()
> > triggered by create_strip_zones() in the RAID0 driver.
> >
> > When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
> > on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).
> >
> > Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs to
> > kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
> > __GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
> > corresponding kfree calls to kvfree.
> >
> > Both arrays are pure metadata lookup tables (arrays of pointers and zone
> > descriptors) accessed only via indexing, so they do not require physically
> > contiguous memory.
> >
> > Reported-by:syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com
> 
> Reported-by should be followed by Closes tag, applied tom md-7.1 with following tag:
> Closes:[syzbot] [mm?] WARNING in create_strip_zones - syzbot <https://lore.kernel.org/all/69adaba8.a00a0220.b130.0005.GAE@google.com/>
>

Ah, gotcha, didn't realize there was automation here, first time i've
poked at a syzbot report.

Thanks!

> > Signed-off-by: Gregory Price<gourry@gourry.net>
> > ---
> >   drivers/md/raid0.c | 18 +++++++++---------
> >   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> -- 
> Thansk,
> Kuai
