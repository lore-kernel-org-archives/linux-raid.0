Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA951C3BF7
	for <linux-raid@vger.kernel.org>; Thu,  5 Feb 2026 01:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770256616; cv=pass; b=r03dQ5/CzF/UflnghWV//JL7OPewLKzIKorDi3Ya5uCurKW5Lg8/LfX4Tfd+YWNzK5U7NKdMwToFjlXS1Gt3AKU5nFuDe37qLzxActI+zukHgvEiW3bG7F4DILfuRJDjuhXGBgg8lW/xUKg4MzeJHxzOgp0hn5rru17mAWrIe+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770256616; c=relaxed/simple;
	bh=cESck4JuqOwri83VP+yTciqsi4a7vJEtL7cTYCXWfJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HS6Vo6olWwnmhoDvBsva1W9ZmeyLyevnyvya4ZKgTdEmHukZQOATH8rEevp1fLn0NSazIJXg1azfWtK5DH4BscfvxcSMpp6CptZRPVYqe9PnGFc9rWWYXT+m9oK95gJPPHg28F1k645GJVNHCy+SKg3OSMqTxVjIbAmPfjDgK0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QonfAySA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=H8G0OhxG; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QonfAySA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="H8G0OhxG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770256615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cESck4JuqOwri83VP+yTciqsi4a7vJEtL7cTYCXWfJ4=;
	b=QonfAySAN07mnNEswUPErqpP6T2ZSj/bPRSlMhgzwuN0R5YBXgq7jG98/JyEs9dfKTEmie
	n4IrgrRkPRiGSeVrR6Hbzn1wqvkthh2cgXrSA23cYPn3f17EUsKbJUWa7axnmpNQUFg9de
	dJphCTsk3EhrFSOn7Y+wASGDjFuyf9I=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-1b6X2rAMN1-szhIEUAFlCQ-1; Wed, 04 Feb 2026 20:56:54 -0500
X-MC-Unique: 1b6X2rAMN1-szhIEUAFlCQ-1
X-Mimecast-MFC-AGG-ID: 1b6X2rAMN1-szhIEUAFlCQ_1770256612
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59b7e9f0af5so376659e87.2
        for <linux-raid@vger.kernel.org>; Wed, 04 Feb 2026 17:56:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770256611; cv=none;
        d=google.com; s=arc-20240605;
        b=B+2/SZrRJIlzqLg+BSto7kiIKcYARIvreo+xC70wtYJJF9WRgXRHesoOw+cQvf7KmD
         rnXGRs3t47OqMdy5Jlzym0HikaL6QwTAUT2qcvyYAxauGsB6THNQ6dr3uHUa2dGoWjvu
         pzU/l3rZ5ceSOJM2HG6uBmciwLrcp+zxC6kaw2zODwTNqS8kV6CDin1J3NjI+cV1CJ79
         xKU5ocOKcfsxWMLA7yTOI0JWvrAr6M2SBAcHXF9+5+IxUFziJLlSkUxRoJVXhiJIyGqC
         yZAZ6kcoQSOQ1lNk8BYlrv9IPWUfBhoUrHg6xvBklg8NO6j5ZhOHtD08cnNpm7oCdm+Q
         JrtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cESck4JuqOwri83VP+yTciqsi4a7vJEtL7cTYCXWfJ4=;
        fh=Zr0Gmz5K2XVnY7DhlR+Mkq3b//E82H/QrSYkAntOeE0=;
        b=bqmRglWrBS9z9jvII7YEHCrAf6oAHPSgk0g0uLgCgmaWHY3n8KZvAAl9idfoBMDIbG
         US1sK+pcHpfEW6GfLroCyRVf3QOSeq2vjoqEVF3KaUvWoXA9RIFsfEgRxdUJedUos2Yy
         23Jo7oVZqt8deKMHGd+qcV7qUgYnDP8AMQFcKPBdi2Ednh+VymaCsFm+OiH7rrmRBTQp
         jztYzR5oWR2Zcn6YLtkzUI8tlryb2gheWIbbr/CORc6mMJuOSTuIjd1NDoBdE4VDoZH7
         vbr6tO1Yl/aP7xjsqcnj3RgNRZsn7NFjkyCyGvvmeKgNL89TL2N7frMpRmQUYQ1YDxkc
         c4oQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770256611; x=1770861411; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cESck4JuqOwri83VP+yTciqsi4a7vJEtL7cTYCXWfJ4=;
        b=H8G0OhxGCX+uiN5g0oCDj+hf04eTSJTcM7gq3wJal+9H2S/m/3oOAI0n/41C24X+Yk
         sYfHMHhY4XRmCbCpdpYlsGaZ9jiSWpFEfO83FhrAiHDoFLHYUyMJNRBJch65o0SJ3oMx
         joivl1rFEp6gzBp+xpwxyONCTbxJpIbaLTwKO78UQnb9ZNhUxOIby/LqvhaMgLwz7Yok
         Q5Iq8737U2TBMkYeXZtfuyzycBuodhBsjwA1JYkv+2rEdPR1TIfuIi9kURKfcgmzLRsX
         +CTQHfmOiLUNGYRQG+42k7WOT7LqrlcTIImnSPnFiyxr115r4yI8NojNptlFOiB6ohUj
         Y8gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770256611; x=1770861411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cESck4JuqOwri83VP+yTciqsi4a7vJEtL7cTYCXWfJ4=;
        b=J4VUCyZbyuAuD650m8VSl0y4w8lF/SkYSPZrarT11Jl073QiXPvsU6sU+R7xf9WNRq
         6385NhhIooKw8LFY9udzxafY6yAHJmgE4rWaJdOkfZA1zFUuc3FU7yb/ivHR+NWBpxYX
         RAyJKugIsFGNfQWZEkXv1trY02GA7RUTM8fLSn/bzyMWn0GC0JIoz1yv9pCpVcnkpdGX
         knuGR1iWkojIPW9kyfVz7zpRLECVzlDT13iEk7bVmIj3LaHaMn93PWbeF1JFpQr8vKCh
         /rr/++Ib65amc3svfYpGqevqYVNfyv0fgVbPzfU59MnK2KJqQH6aQkCFCrlzKH0+g2Tx
         7Trw==
X-Gm-Message-State: AOJu0YwIhc6e3iilqvCSA+zyxySIW5BS7NE08UQmx1+8vzqeEpPmrIR3
	3DeWiQxOXzIyM0z/pDmd2U8AhomBiMf2XowZjP+oVO5rEWC/HRdP2nPCy5j8Vn6OF/SvcJ59bIX
	OLl6EV/7HC39E5ZBxM+s3MpPnP9cCgozTnMgXO4mU/bSUPOAS2aRGAaIgVdP6i9wlkPFujeOdBi
	Fop06X7+crBawelXLpsBKkURdovbhyZcGypPY8DZs2uhd1d2JS
X-Gm-Gg: AZuq6aJjngPlscMeUoE0qvCHwyLFn/XubCHcDXHiYL5i9Ma/t6gVcKESUDt4cIeTexN
	buP5mN6v8ikhJsnELNklvZXc2hbgm8OFaLX4YSGoUuEDonsiTbMGM1WdFQXQbteTy7xoD4aSElc
	ZVzQkeeBRP77vCjJRB3LotnNoeaus5BcI5/G1wRJsfONxAR2fn7oBMHlGkMDBw/0AriENqOA9DY
	d2I/5GmCaerEFMM8H4Ou7vXY4fM4+Eb+8Ck9Z9ElxjJOZDgi+aOnebhu3aYx2AXCA5yjg==
X-Received: by 2002:a05:6512:3b99:b0:59d:f47b:a0da with SMTP id 2adb3069b0e04-59e38c03be7mr1978778e87.10.1770256611258;
        Wed, 04 Feb 2026 17:56:51 -0800 (PST)
X-Received: by 2002:a05:6512:3b99:b0:59d:f47b:a0da with SMTP id
 2adb3069b0e04-59e38c03be7mr1978772e87.10.1770256610835; Wed, 04 Feb 2026
 17:56:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204145912.9463-1-xni@redhat.com> <a058e5a3-e96c-4feb-8f9d-e1135951973c@fnnas.com>
 <CALTww28vHeWNf7kejN_R_-K_nu4JJRig6ieQRBv63N1Xy7FXhw@mail.gmail.com> <744a8650-ac7d-485e-bc65-cde38e2507a0@fnnas.com>
In-Reply-To: <744a8650-ac7d-485e-bc65-cde38e2507a0@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 5 Feb 2026 09:56:39 +0800
X-Gm-Features: AZwV_QgStvf68oa58LBjrjTpYEjfiURN1h2Lw29ygsVFZH3qBjfimelnuD0Ih6s
Message-ID: <CALTww2_AQW23xLLp=ErMyO0P_ByT9_=Sj+S4XgnMJJcPVBeuEA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] md/raid1: data corruption with serialization
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 9:44=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> =E5=9C=A8 2026/2/5 8:34, Xiao Ni =E5=86=99=E9=81=93:
> > I know the reason why it needs serialization for writemostly case. At
> > first, I asked the same question if we need to handle overlap if a
> > filesystem is on raid. I got the answer from AI, filesystem can submit
> > overlap bios simultaneously, maybe it's the reason why
> > serialize_policy was introduced? And database is another case which
> > can write to raid1 directly without a filesystem. So I started this
> > job. If we don't need to consider overlap, why do we need
> > serialize_policy? cc guoqing who is the author of serialize_policy
> > also.
>
> Please don't just trust answer from AI, filesystem can't submit overlap

Thanks for pointing out this.

> bios concurrently. And I already said serialize_policy is for writemostly
> case.

de31ee949739aba9ce7dbb8b10e72c6fce0e76c7 (md: reorgnize
mddev_create/destroy_serial_pool). serialize_policy is not for
writemostly.

>
> And I also said we don't need to consider user manage data on raw disk
> and write to same area concurrently, database will not do this.
>
> The reason is not complicated, if you write to the same LBA concurrent,
> it's pointless because you don't know what you'll read after that.

Thanks for the explanation.

>
> --
> Thansk,
> Kuai
>

