Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45551EEE0
	for <linux-raid@vger.kernel.org>; Sun,  7 Apr 2024 14:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712501827; cv=none; b=aCUxY/GIzNyAsLw/MGYqWnZk/4v9EBN2xW5Vyhu99UvGvgFSaiFK0uLwV/XR4bF3S2uIN1GMlSHW8e4+gmoImRCUtua+uN0KPZDZvdMJz/Rwu/Ll4GiBBphF87pOAFC3nO/kkQhnbgD5vOo6sn1OsO3g0mTgDSDyQavVZaAt5tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712501827; c=relaxed/simple;
	bh=e4fwXOUyYq6mV6uhvLjPhbnGjuszMvN9URKWpUlfXvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7mYl8glPV9MOwkI8oEQknA3WiC/Ycua8AdtkKMIu4JMxodc4fDvKHkfzfL+jZezvB030VeH7yuw9ep42Vq+MgsdeOsk3VzVwOJKxW+x95f9F1CDFlFu8mYDh4MQzY/0+pXoyX162WwfeYSF0nxIOjP1UFAx9TaUZ49JUFBUVgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-78be3087929so256023685a.1
        for <linux-raid@vger.kernel.org>; Sun, 07 Apr 2024 07:57:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712501825; x=1713106625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9UKQt8oRXG6Dh8pSrRfOqttC99MPstJOYP5P6LSjTI=;
        b=SJAJZ/MWTG0pGGvKV1P40fyiy/IpFrutjJov976orVKZ0ZOV6LrT7ldU7t1lfB6gyA
         FDVNmUPAhkzVuVC+RwC7OrreNM1qyQcfa87E0y1leWSbAQP3Fcy+Puy5xYnKAXqclTZB
         dtMLi3XFWWV79ZfcRT4yZZUSYOCYZlJxkzXanlEG/ssct/9VyEGCgWrh/Sc68uxfNPBc
         yrldmGrToVF4b3kPvuD9ch7/AkkGw1Go10GlAFiIqAcOjsyCaA1STP+P+osYc/aWZfVu
         CNIMdfp0zTdo2gqkJxi7wohyeob4D8LhwyxNSD4AqASw/v0a6DJHjvyCvs0IDpNEey3s
         TvQw==
X-Forwarded-Encrypted: i=1; AJvYcCWPzDsL31bNvS1QBzkNwgsCG1vlQzrnMVrPxxRHmpn/B93PF+K49Z3cnL8rD+PReOpbARzM435FdNNviSDO34llVkpSE8sTA2RkBQ==
X-Gm-Message-State: AOJu0YwKvk6wsDvVuJqohB8P09ehcK+GrU1gBJGmTVknJHn3EP99PESx
	QfYbfI8tSOTn1qadVfJNVnyqHqXgqrRMfvE9hEqH/v7N0Y0DgtiBajTD9/puCw==
X-Google-Smtp-Source: AGHT+IFOCt5ITUSZM9yD/CST7Tn+uc5Nrf1bq7XmB0Gqa35jK1G/uyfDDNQaypFMkPS1UTQNfQ/K9w==
X-Received: by 2002:ae9:e412:0:b0:78a:22bd:d980 with SMTP id q18-20020ae9e412000000b0078a22bdd980mr7153654qkc.64.1712501824869;
        Sun, 07 Apr 2024 07:57:04 -0700 (PDT)
Received: from localhost ([64.44.118.111])
        by smtp.gmail.com with ESMTPSA id bq12-20020a05620a468c00b0078d64195031sm328312qkb.31.2024.04.07.07.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 07:57:04 -0700 (PDT)
Date: Sun, 7 Apr 2024 10:57:02 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	janpieter.sollie@edpnet.be, Christoph Hellwig <hch@lst.de>,
	dm-devel@lists.linux.dev, Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org
Subject: Re: block: allow device to have both virt_boundary_mask and max
 segment size
Message-ID: <ZhK0PvAtXfIfHG4t@redhat.com>
References: <20240407131931.4055231-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240407131931.4055231-1-ming.lei@redhat.com>

On Sun, Apr 07 2024 at  9:19P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> When one stacking device is over one device with virt_boundary_mask and
> another one with max segment size, the stacking device have both limits
> set. This way is allowed before d690cb8ae14b ("block: add an API to
> atomically update queue limits").
> 
> Relax the limit so that we won't break such kind of stacking setting.
> 
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218687
> Reported-by: janpieter.sollie@edpnet.be
> Fixes: d690cb8ae14b ("block: add an API to atomically update queue limits")
> Link: https://lore.kernel.org/linux-block/ZfGl8HzUpiOxCLm3@fedora/
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Snitzer <snitzer@kernel.org>
> Cc: dm-devel@lists.linux.dev
> Cc: Song Liu <song@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-settings.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index cdbaef159c4b..d2731843f2fc 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -182,17 +182,13 @@ static int blk_validate_limits(struct queue_limits *lim)
>  		return -EINVAL;
>  
>  	/*
> -	 * Devices that require a virtual boundary do not support scatter/gather
> -	 * I/O natively, but instead require a descriptor list entry for each
> -	 * page (which might not be identical to the Linux PAGE_SIZE).  Because
> -	 * of that they are not limited by our notion of "segment size".
> +	 * Stacking device may have both virtual boundary and max segment
> +	 * size limit, so allow this setting now, and long-term the two
> +	 * might need to move out of stacking limits since we have immutable
> +	 * bvec and lower layer bio splitting is supposed to handle the two
> +	 * correctly.
>  	 */
> -	if (lim->virt_boundary_mask) {
> -		if (WARN_ON_ONCE(lim->max_segment_size &&
> -				 lim->max_segment_size != UINT_MAX))
> -			return -EINVAL;
> -		lim->max_segment_size = UINT_MAX;
> -	} else {
> +	if (!lim->virt_boundary_mask) {
>  		/*
>  		 * The maximum segment size has an odd historic 64k default that
>  		 * drivers probably should override.  Just like the I/O size we
> -- 
> 2.41.0
> 

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
