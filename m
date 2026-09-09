Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E33526A8B
	for <linux-raid@vger.kernel.org>; Wed,  9 Sep 2026 10:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788950167; cv=pass; b=Cku/WRtSqvO6570ZElUpD3UIX35PZ6a2RgbNlD4ERDgUz/1uz/M+xQEmUyfXYLacSYBlK4ycVGAIXAoBMDWFcdcZPjQAoXUV2RBrSxXkv4F7oyDTopeOTUHjzpTLfdNLCQB06NJfhzT9bFVgSI+X/hMUit6c0Zs2FzfPQe+0R0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788950167; c=relaxed/simple;
	bh=jiUSKPWQHUb8wgWpAcCdYB6GZGkWirt+xiv0f1KbsrE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JbECcLnz0UnrvuyFZay6pv+Ma9OZP+I5FcXcOsJStoSc78APZhQXLvw8JPB+8bNlYY+NwiBJuAUdphfvmHeM/TGFzw+7v6ztyr2eEghH2jPV9ene/8c7DoKCNlrIkBeuTa+x4u1vo0/jhTlAs5RNE8EFwY1FlbrBaZEPY3WV02I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=K2aGm/dj; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="K2aGm/dj"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a5f3317027so434316a12.3
        for <linux-raid@vger.kernel.org>; Wed, 09 Sep 2026 03:36:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788950160; cv=none;
        d=google.com; s=arc-20260327;
        b=cOOVah4JcgckzQjk8SOBtQWqG3D6hVGf28JAeHo7YPoRCF7JYkLjlJbL7hfFStHILG
         949XUVjT+jqPu39UsPaItJrhSxz7/pLTHfrYs/I4yj4NVl4zwA6+s+IV1h/fuN8KAVfu
         EBT531JAvQKFGexf6nLT9AknDg67EVm8h5pac4EJzhc2zuDzQFHtyjsQZhoO088P545M
         Ct/9h7nyoihW2Q6yG4xwjWOt98QL+JH4l1oCpkQrQPwpBbL6dXDnWkxotH+SPYD0rxmO
         pn0hZUlSo8y+AXmhhYWpHphxNWKKyNjjlGp6sLjJCgFnABoI0sP1YOMhVguw7NW+sQx/
         va4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PiYK9hlMysoO7QWt3It5QIF3PriSPcy84exsAliRPN0=;
        fh=wiFvfBxQ/5+Joy2ttka30WBYXXaVaPVDRhIP82JtkRQ=;
        b=IPBIWf7N8Vuk/elD2eWNdcEuRrYJnfJi5RKsdiNCjQx5nJNU73EUht97oLNVWbd2NC
         Prr+CVSfhfKE2DRboNOPYO3tPUKl58qAID9U+wa/dBk7LSCD+btSZprDZKk4TmV+hNcB
         bu9lYXtEwTC8P752rOfNvf6+9r76kGJPk18j/CepzBCwnDE2nT7K3smUYUZF6Bsi2iwZ
         Nd7X4Wbp4k8cNkCydbgJjfUMWdV8+Is8Wbp0tMKEd3lVu6bpy1g5DUmsgLn8RUxlarQQ
         /PaaBO1ssyRDeKljjWKmw+18Bubc+m6WltC+MiX9Yrd732z5vVH4ikv7P/TrKkrxRu4E
         1Rxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1788950160; x=1789554960; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PiYK9hlMysoO7QWt3It5QIF3PriSPcy84exsAliRPN0=;
        b=K2aGm/djq+KyUsHQ4ltRqRnnwRxbM+WSPbrCCiChCKHH8CK9xQRr5L8zYzAx9MDth/
         eLdOWdXEEFTSl4XzBbPGRdg7h4rPEntreCLR8gABJ+LOjQL6XH94d2sAs7lNYaJVFNeI
         ar1yA8r69P80gdUrOcNhlpDxCirdhcPjrZF3ESbb0a30af1hw6C3/fWYm9RVcfZE2QYT
         QZe1WqC+jATZE5bICQ6sfIspkNlFJ31p3cn95IPSL9Ne3kx3mdFIWUJ5kXaN/eYouaIo
         hzqynPwTDpTcuJSaW9uSWpqvq6asfj/PuyNCsjfb3ghaALHcNa8C2JMbanUeJF2scucx
         poIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788950160; x=1789554960;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PiYK9hlMysoO7QWt3It5QIF3PriSPcy84exsAliRPN0=;
        b=kuAI+HBBVRT2Eo9GcEN3ki0e/Z9Q5deJaXRjauIEqbpPfPv1X5jMXDKO+oSxdCdKAD
         W6kDxgP45UW65Ou4T81jYdL484mjSGxqbSffA5it4A748OLQimUpSP6Q26dEzUIS6Fuv
         tTaO1yL/O04G2TeKB+jHhVnEoxIUf8eyYZMSS9OGcHR65HHcwQOA9ZAhWckAeWuz+JDu
         lk4TLCqTevTaDsQqwH+vHOW1NkSRIMCBz8ZdYn6LL1hNOyWlV9fS8UXbYvAlcESCmOii
         fqDH6biFagmVe5VCCzOf5BxmwKhjdB+CVlJNxJD6qrbfr7mxCuQCH1YkqVKmtz4DO35y
         ngYg==
X-Forwarded-Encrypted: i=1; AKwUvBw0RbDmTsf1facwLDPVgtDxAwaZkqwKxPhYVIyqFLN/M484poXpXIzhokYLLIJ5pJwgP76xtOZtoPpq@vger.kernel.org
X-Gm-Message-State: AFuF++nBmzdbMKaJK6OQ1RLj/WlQ+T0pDJwzPjQr4vvZITz5Zeheyf5i
	qSx0Cr1Sa4oFYh4fhnYk2kJ0Tzi/U3+588wXnkPVfozLVNxbNcoZulJ/gPSkuMQjTl8VmRZZGsh
	am57eCmBWMp34kpzd2WMZnUB7GZU9Mffb5DaEY8tJO+HCpx6bsdSEMK/6uw==
X-Gm-Gg: AYBFou3eWiPjfFdowtlQt1duIWIw5Gq/2gCpzcC0W1R65k3fxHMlQP0h5JG11BOctvY
	e9Y7oSuvuuNua/O8X02kLoNEiHVwPukAhGLD7JkYT9V992BBK54edIbWu88madlHDcOumaiiFW6
	qZWqjOZqgjccJ99K8Z345+SvrqGEoeC7JKnfcauClPul5MN03ubcBXR5hZfazEGagsFUUEnZtCf
	NAUQpEJhJktAR5qYGG3dFbgDpiTAxV/J5o09ctRI9ux0ZqycMql5Kk77Lk7WC94qOaAC1B15zRz
	Bu3uOZ10GeRTj+gHaNZ7b+UgyKDDJWSZNas+YrDeeVTtovabTQ2ezv4=
X-Received: by 2002:a17:907:940d:b0:c25:3ccf:bd87 with SMTP id
 a640c23a62f3a-c2624d27f76mr997745066b.0.1788950160219; Wed, 09 Sep 2026
 03:36:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
 <20260907133929.1081540-2-jinpu.wang@ionos.com> <20260909062923.GB29874@lst.de>
In-Reply-To: <20260909062923.GB29874@lst.de>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Wed, 9 Sep 2026 12:35:49 +0200
X-Gm-Features: AcwNN1X-2oF0MYpARsjLKHXLdD4JaJtQpG0Ei6Y9Q2CxFNEsVa4yPYfrtiGyUCo
Message-ID: <CAMGffEngy4GGR0ScFYRAUwsGrnO17gL2HRJE3wBX8tHBaq5SNg@mail.gmail.com>
Subject: Re: [PATCH 1/6] block: add queue_limits_start_update_trylock()
To: Christoph Hellwig <hch@lst.de>
Cc: Nilay Shroff <nilay@linux.ibm.com>, abd.masalkhi@gmail.com, 
	linux-raid <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, 
	Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>, 
	Yu Kuai <yukuai@fygo.io>, tom.leiming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 8:29=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> On Mon, Sep 07, 2026 at 03:39:24PM +0200, Jack Wang wrote:
> > From: Jack Wang <jinpu.wang@cloud.ionos.com>
> >
> > Some callers must not wait for q->limits_lock, because they hold
> > something the current holder waits for.  md is one: its
> > check_sb_changes() runs with reconfig_mutex held, while a
> > queue_attr_store() holding limits_lock waits in blk_mq_freeze_queue()
> > for I/O that can be waiting for a superblock update needing that mutex.
> >
> > Add a trylock variant of queue_limits_start_update() for them.
>
> I don't think this is a good idea, please fix the lock ordering
> instead.
Fair enough, I will drop the trylock.

The ordering fix is the rest of the series: the callers that add a new
leg take q->limits_lock before reconfig_mutex and the suspend.
>
> > Assisted-by: Claude:claude-opus-5
>
> But if not please try to come up with helpers like this based on
> your own.  We don't really need this amount of AI slop.

Noted.

Thanks!
>
> > + * Like queue_limits_start_update(), but fails instead of waiting when=
 another
> > + * update is in flight.  For callers that must not block on q->limits_=
lock
> > + * because they hold something its current owner is waiting for.
> > + *
> > + * Context: process context.
> > + */
> > +static inline bool
> > +queue_limits_start_update_trylock(struct request_queue *q,
> > +                               struct queue_limits *lim)
> > +     __cond_acquires(true, &q->limits_lock)
> > +{
> > +     if (!mutex_trylock(&q->limits_lock))
> > +             return false;
> > +
> > +     *lim =3D q->limits;
> > +
> > +     return true;
> > +}
> > +
> >  int queue_limits_commit_update_frozen(struct request_queue *q,
> >               struct queue_limits *lim) __releases(&q->limits_lock);
> >  int queue_limits_commit_update(struct request_queue *q,
> > --
> > 2.43.0
> ---end quoted text---
