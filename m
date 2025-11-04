Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715352C181
	for <linux-raid@vger.kernel.org>; Tue,  4 Nov 2025 08:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762243505; cv=none; b=SUwoc6mgqTMWEcIEsX/RZ3TmN1zvCkNBNQK3uIiGPSjCQ1TE2adzwxFMIaDmpcw2ForKuxhtTtVVnG3i2f+D45sbkS19Pge/NFhwcYuOA3aOne9KzECzTk8vx49qU66TFd+GX1hXOVp+87nU5ClnHOS1aEiyZDHGn/qPIG9irs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762243505; c=relaxed/simple;
	bh=/yzTsMdskKhQu1paJCOYqDSq9bhZ+LZrRX9oy8qHqjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IM2Swt+i45C6lvhv/ClethjGoDWETs3hSST+qH1yMVHkmPFPyUPMHoL17Y2d+YK1KloQG3gmGKB3YN9VO2m4IapQlMazasj9UhlhWCS/53vja3MCJwdOjDdlzz0XYnydjCVkBZRuyFdxd4NVD7Iw/xHeP73bZbVxRofNxFfWijY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JzuaK8JQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a+CmnK8d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JzuaK8JQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a+CmnK8d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762243502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hpJH/9P6SXk4FNbPrBvyPZj8813+j3KAKeJeMOQg7WM=;
	b=JzuaK8JQ68HTMKFp06ebV4kR8STJaBe8l3JYaIz22WdhSskNGJzs7dYvWYvhA3Q2fiBN15
	enKvXQ6WFyBRVX9WKfptcaxvSxKrUzyeF9WTo9Pyn5t55NHqvB2jW+0aEGpocbQddT4L5L
	PYWUZf90dlT1ze9xDbp8CnvL8M9tSqs=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-tbe0z4GePj-5hBYs5tor3A-1; Tue, 04 Nov 2025 03:05:01 -0500
X-MC-Unique: tbe0z4GePj-5hBYs5tor3A-1
X-Mimecast-MFC-AGG-ID: tbe0z4GePj-5hBYs5tor3A_1762243500
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59436279a69so221704e87.0
        for <linux-raid@vger.kernel.org>; Tue, 04 Nov 2025 00:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762243499; x=1762848299; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hpJH/9P6SXk4FNbPrBvyPZj8813+j3KAKeJeMOQg7WM=;
        b=a+CmnK8du+ctm18H2CbHRg9R/KEA7Olf3dT4wQ3W2ygs61/v2zcBKVutP0MbdXrbUM
         UmHbKZQNiI1K+4T2jZR5+39L0ITE3xodI45SWMVou+9ONE//0Y8BZI+DWRw/4vxIJQVp
         kP7zLr1lTq670NzaV5+h4RX7YCXil7/5mYFtft7sytySuAdhq/42MxrVdDPagwC6Iz43
         +6rHtmmZlzRYMvtGwsT8ijamzCfi0mrbEeDcOtndjieH04dQ8XIcHF04BtiPYM5N/eUW
         bGTaZMCM1+F/fgKCRO+mhY9RXoNcn07M8Jlf6ic6Qoz2ExOkDHYYNnFJVRoKdUmlWaV8
         z7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762243499; x=1762848299;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hpJH/9P6SXk4FNbPrBvyPZj8813+j3KAKeJeMOQg7WM=;
        b=FnJYdu9RDXy2GFVm/ZaHnFoOU93rbU7yoA+5t8UA51HFibDkVhNa6Ymff0SrW5tJAL
         3U9tid1Zk18HA6/EskpWYTkAHKWyd9atefMimqX0/ZqEqb9YU9RgDIT1eG+Et8JmRYMW
         1aIi3rU5669PKoT7rB8A5gVDaVq0IzfnQ7I/Yl52DnuhpFpEmKfIoHvHZC/agd8sWXj9
         TiWgPqVtBeAtiMuFAkpMIa78fO3gLWomjQZ70KmG7W+ROF+NJQHygoz7zGZ9ZUn9XFJw
         zDXfWYB3CsFoefyrtn5dTNtEDRvE2eiKH5u2E1AsfXW8q0iP7y9pr89B9Sh7E+m25vnJ
         deMA==
X-Forwarded-Encrypted: i=1; AJvYcCU9AYidYWB7MvkzbfzBkT4E/gZvK7lKhWcjdojArFJDpEmqji/vpybMCG0LhBh5oZ/Ra+xqsjEAKmxT@vger.kernel.org
X-Gm-Message-State: AOJu0YwJK/SucH9YvExqz9Yl0nTBv+/l/CjL2x/SY2bY11+zCXDwMdJs
	aVe/kHD04ciLRDEDgzkjXAA6w8OGwM2/fjMxxa+DhS8HEOswnetRDW95TtfYBrUvmKGkLHSbyun
	wypCuIIv1PxZn3PFrTfGt64C8ovEII2UBgSTUibp5XDoRiaIgI2k7KqQOf35NgsxD2dv9aXgJAC
	w7flGNK03WZd4PGXIjuqic/yJmLICn1UZvMarzKw==
X-Gm-Gg: ASbGncudPv7JMwQl66Wbe2J14v9sgGn/4DsAcdyVlbGPPhWo4cU4fG4AkeHxflm2AtA
	mK3QAAIo5UQdjATLK3nivLcmy9fFfqG3T1+IGTs9/pdahuFXPotuBCHkpu4x+4MjAeWJu/fjKhP
	ThnE4j6Hk20T+8cPr/IQ9TZZUpbenmI/tG6Y2FvWibWCGzRHpDz2UCXPKP
X-Received: by 2002:a05:6512:3b0d:b0:591:c8ef:f838 with SMTP id 2adb3069b0e04-594348c3813mr708403e87.17.1762243499517;
        Tue, 04 Nov 2025 00:04:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHZgd6F0L+73hwJktp12hgvDYHWIWj5x9emdmzjAQF13GBDuJTprFLPwBs+j1ghQXcA1gyN6xOSkwulauIDILQ=
X-Received: by 2002:a05:6512:3b0d:b0:591:c8ef:f838 with SMTP id
 2adb3069b0e04-594348c3813mr708396e87.17.1762243499109; Tue, 04 Nov 2025
 00:04:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251102152540.871568-1-hehuiwen@kylinos.cn>
In-Reply-To: <20251102152540.871568-1-hehuiwen@kylinos.cn>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Nov 2025 16:04:47 +0800
X-Gm-Features: AWmQ_bnYavI9hI64SjKyEPVXRfR7Mm8S6goViesnbRWVrmUWciFEXEuTuMfqNZw
Message-ID: <CALTww29GVOw3sk2=A_9dj5QMGtfogRjxRsunc1D74AqLFj_MyA@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: remove redundant __GFP_NOWARN
To: Huiwen He <hehuiwen@kylinos.cn>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 2, 2025 at 11:27=E2=80=AFPM Huiwen He <hehuiwen@kylinos.cn> wro=
te:
>
> The __GFP_NOWARN flag was included in GFP_NOWAIT since commit
> 16f5dfbc851b ("gfp: include __GFP_NOWARN in GFP_NOWAIT"). So
> remove the redundant __GFP_NOWARN flag.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> ---
>  drivers/md/raid5-cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index ba768ca7f422..e29e69335c69 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -3104,7 +3104,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rde=
v *rdev)
>                 goto out_mempool;
>
>         spin_lock_init(&log->tree_lock);
> -       INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT | __GFP_NOWARN)=
;
> +       INIT_RADIX_TREE(&log->big_stripe_tree, GFP_NOWAIT);
>
>         thread =3D md_register_thread(r5l_reclaim_thread, log->rdev->mdde=
v,
>                                     "reclaim");
> --
> 2.25.1
>
>

Hi

It still has other places that use __GFP_NOWARN in raid5.c, do you
want to remove it together?

Anyway, the patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

