Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4000023098F
	for <linux-raid@vger.kernel.org>; Fri, 22 Nov 2024 03:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732245300; cv=none; b=NvjpMJ/mleo8YTWQKX7pXTmfyXEzn5I3WAUSZwDJNui7cc5QLMKHosDMDxl06YqQgAnPXyH5kiaxWQbY2T8SnVY+tDriZYVOUK//E1pl3bJa6nh8gzBozfowja8huSIDkigInHjcEuSAchivWxfk1WcX9nyYIfVYNyUNffP+xss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732245300; c=relaxed/simple;
	bh=7HHjH1ZUZ1lg1lJsT7TZAs2UFC4QcgRu/sE4VMzGLK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rOSMgbg4/Hy1Cn4Y07q/Vrdp0I2JC8SZQtjb61rYUDnfyXC8klY+ZEzttGtAeWcTKpPIkSHblat/ztx1fD0H7Orwm0OIyrmJ8oBp/7zQI/DKON0ssjYYyfeATFZtFzc24/ml13uUQB5+1pd/vaEOZDErYU3tkdOPWU9wCSx499I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gepFAio6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gepFAio6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732245297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7HHjH1ZUZ1lg1lJsT7TZAs2UFC4QcgRu/sE4VMzGLK4=;
	b=gepFAio6T2AJ1/fNHRS7hfR4gDmA27M3k9IPun0l1YGzTZBB1BkZZJUswK5jP6BKzzkExi
	uXODnVY620F/nSMmmbQgS6wi1rY3HyIMwYfM0ym+guOmhwVfZ4A/YqCJxT4coPT1d/hzgj
	B3nMR33MjRGUZzy9uDvXCKCas8DvfyE=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-nD3I5O_aMaKDFe1V0R5DGw-1; Thu, 21 Nov 2024 22:14:55 -0500
X-MC-Unique: nD3I5O_aMaKDFe1V0R5DGw-1
X-Mimecast-MFC-AGG-ID: nD3I5O_aMaKDFe1V0R5DGw
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-53da4ff1673so1352840e87.1
        for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 19:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732245294; x=1732850094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7HHjH1ZUZ1lg1lJsT7TZAs2UFC4QcgRu/sE4VMzGLK4=;
        b=gCmoPqC5uNgaaYU+mX5JCoPp3OtVDS4ZEu9P1PZyC4M/4k2A2tXsHh1hIzwS/OTmJ3
         xxJSBXG6+7A7/93nh/8FuPOGowaxyIsVGqP3F6at27/nhYTeKiIHrgBgbyAJZEi8k2m5
         Ja3xFz1fDsC49K1DXSoWNyU3fVzOceqzMLfj32Zp7cBbfJAK1KI56UbhpJZVBgJNQz8g
         pNe7YMffIGu/MEaazOb+FPsB1FRkY8eYakbShPEjLm/pL5vYh3NuufIBLYMV8eb29CBS
         VqyA9hLaCnW5fpD35xUWcYO5KwFbMOD4BhljmuFQmKMBkSan2CTM7pYyGRKqI9V04iii
         5yMA==
X-Forwarded-Encrypted: i=1; AJvYcCXg8Q3Q5ec9J8mTM7ZoLRdxzgFdnwnpnZ4PSWxZBgL+EgDI2ldcc+64auMMKuSlM3RJEYaDRtcnlgWf@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2qja5gkYzxF0RGdSyg8mKMoZK7b6Ex9NV/6FIWXQ1iW343cN9
	zWzRniqIADT5BEqSJTjfT5WaQztEZLhBPvqob/MBCAa/DBkrww/FIXLVVari8V3B8RW/xtXmsj/
	+N9cn5pjAmMPd5HI7UtF7IXTq+pkeI5toNJ43FDGp9f7aTTUzaEf9/Okd9Ka/LXVs+vLcWizPxd
	BUf+sefogHel1vyJJsZctFcJM5X+pqjWh2VA==
X-Gm-Gg: ASbGncvtb5BD5xSHK/tyGZ7MQhTvheUl/xejdZonAA9BxTCw/2Y7x58B/s3kyC2CHBT
	D//2CSbty0yu2frVPDD2FU2Tfy9zTTiAs
X-Received: by 2002:ac2:4c4b:0:b0:53d:a24c:5c7 with SMTP id 2adb3069b0e04-53dc614d3a9mr1643654e87.10.1732245294168;
        Thu, 21 Nov 2024 19:14:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEX6GI/3zJ5hvdmvo0PlFiwxO986ih9KjwCntiVr9+Vl+/jdjr3hI80vJL43VWModZJKppO5g8lp7zhHKSGMD4=
X-Received: by 2002:ac2:4c4b:0:b0:53d:a24c:5c7 with SMTP id
 2adb3069b0e04-53dc614d3a9mr1643651e87.10.1732245293845; Thu, 21 Nov 2024
 19:14:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118114157.355749-1-yukuai1@huaweicloud.com>
 <20241118114157.355749-6-yukuai1@huaweicloud.com> <CALTww28JrdXoNXQNPxx2Sg9L2iL20jZZ80Y-qZzqcyF780M1fg@mail.gmail.com>
 <e6843d53-c7f4-2e38-0a15-91b49afec8f1@huaweicloud.com>
In-Reply-To: <e6843d53-c7f4-2e38-0a15-91b49afec8f1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 22 Nov 2024 11:14:42 +0800
Message-ID: <CALTww28ZRFo6BwqzriVpoOuqbfygKrU0HuOhhUxLe9cBBDY-ZQ@mail.gmail.com>
Subject: Re: [PATCH md-6.13 5/5] md/md-bitmap: move bitmap_{start, end}write
 to md upper layer
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 22, 2024 at 10:46=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2024/11/22 10:06, Xiao Ni =E5=86=99=E9=81=93:
> > On Mon, Nov 18, 2024 at 7:44=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> There are two BUG reports that raid5 will hang at
> >> bitmap_startwrite([1],[2]), root cause is that bitmap start write and =
end
> >> write is unbalanced, and while reviewing raid5 code, it's found that
> >
> > Hi Kuai
> >
> > It's better to describe more about "unbalanced" in the patch. For
> > raid5, bitmap is set and cleared based on stripe->dev[] now. It looks
> > like the set operation matches the clear operation already.
>
> Ok, one place that I found is that raid5 can do extra end write while
> stripe->dev[].towrite is NULL, the null checking is missing. I'll
> mention that in the next version.

Does this can cause the deadlock?

Regards
Xiao

>
> ...
>
> >
> > This patch looks good to me.
> >
> > Reviewd-by: Xiao Ni <xni@redhat.com>
> >
>
> Thanks for the review. I'll also remove the unused STRIPE_BITMAP_PENDING
> in v2.
>
> Kuai
>
> >
> > .
> >
>

