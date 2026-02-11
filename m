Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDCE285CBA
	for <linux-raid@vger.kernel.org>; Wed, 11 Feb 2026 02:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770777360; cv=pass; b=s7khdlepZljAeAUo4pppHDHTdAzn+S3D8Hy+cxRXeSjl9r4/3YBk/YpAV/mxF7ELZ81xzxC5K6+YSDaTr0z+GQad2Y00FKad31mZcRPQsw+s4T9RR0ArV45oiqL3NWNjrHVa33Ule/80HfGvLiKe/dlbnT/I2ixHCtRlYWp68+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770777360; c=relaxed/simple;
	bh=bwN3AqYEMsHdj359rbk39QVT9zy/5BUkvwtfAXuUS1k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p7tbw6J9YqlBCTP//H8m9EQLVxLRRylvo4YdJAs6vzn/NQhPH6w7+1ZdU/Tv25+y5ffL1x2noeOB8qN6PbhscLrVBxbbLYGeqSx84VfKf76ydufVGWocEp2o3igwx//zmuPqrL6od/O5KtDmJdoJYn/FZrflTWz9EDjqyovtFEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eEyH7JVo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=eKD85bng; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eEyH7JVo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="eKD85bng"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770777358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XvL+o58yw7AJG9LxCh1T6J8XamzsG2DrskuNqxQ2m2U=;
	b=eEyH7JVoA5QUtIwqXdNd7arr9zu4DImV54zWMNxye1848neCVP+aAImaFq1ALh1Osndnwj
	o7C5ZU2JddHXO/SRt+WCGNWIpX+xsK7Z2FU+uqaS5W9n1J7tuo0FDSccxGLIxt8q46Uw/g
	pLp27IFy6kHpAZABV9EZBQMCgSL47yI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-a-fDGy8UNECOr7Od89Xf3Q-1; Tue, 10 Feb 2026 21:35:57 -0500
X-MC-Unique: a-fDGy8UNECOr7Od89Xf3Q-1
X-Mimecast-MFC-AGG-ID: a-fDGy8UNECOr7Od89Xf3Q_1770777356
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-59e0a441c8cso814498e87.0
        for <linux-raid@vger.kernel.org>; Tue, 10 Feb 2026 18:35:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770777354; cv=none;
        d=google.com; s=arc-20240605;
        b=ZjsmkZ86D2jEaQiGH94UdOWNLB5eSNM7MB3EHk28WAGLl+befQui2U55cZIDJ/jSy4
         dflVGDaJOtSjpYxsYY3CVlHixCh4RaMuIBRTa8cHG+JZw6ESmOLFldcnVzI85C7uGeIm
         8RgWEmdtILAFevo8I74z4hNpujwAubhN3utQ0C0ZTmYCsYhxln5OG6nEzZrLInILpj9G
         OZpBifmfKqF/AHJU7VnopH7wAVvU6tccgx+qQ5BX1ebs77da1ptaiCmywZy/4a0qsqsK
         P7qkXNlYGTrRc9k5Cp9ICxvLbUsd5qsSeLu8BjYiGKusu73A0UkNYfmdWHu4dc41bnXm
         wHwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XvL+o58yw7AJG9LxCh1T6J8XamzsG2DrskuNqxQ2m2U=;
        fh=m2YFckBGH5/hm6Tz7ErA+PbF3+wSNwWwyYSETY2/H+0=;
        b=hq+kGG0fZ1L6y3H7dvLQldOLdn903Vyn0xNd2GteXVnlFXF6y1y7mSXE5jwkMxGGpp
         rDAt+1xTxYYDfcGwBVCEdVThDSh0JI3XtAqbw7pyA3ynvPkuA9faF6+uncARReS580NK
         KUkYpFobSFyOIyRcIgHcrJqujhWBsLkfeuoVgftKLuj8fzncp4AmmUJEDfRywIeudMj7
         +MOcwWtkPglFaAUXoQZKbyawLQKmEKiPMx4oDzm43cWaNkIz+pYWBKQ+YPRDJ0HFJdok
         QyNgQgB383k7B9dzvQPa7hT74Q1HuHYK1+vi/WebTuw1jPPsgXX4Z0xqW6WaKigGEIoN
         4F7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770777354; x=1771382154; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XvL+o58yw7AJG9LxCh1T6J8XamzsG2DrskuNqxQ2m2U=;
        b=eKD85bng1EXNVfN6P4Pe7DNRzHTlIpgMFdaeRHIsBv4yH500PfgdTYWPH3cciRF77K
         8zx/q5QN175IBjn0GxN2hxI6JOowrDl6bBuoCCFtMqKvblsJkUDYSlUd7lam446t2Pud
         o+lkk6uO2xKv1OS9ehfaQHU4gVfLPzrKVJsqI06kn8+fp0LXgY9XQHyH2zWaa9Y8jpmS
         5Phplwsy8pOFLoULe74pbLtkzhXwvl0P4bReTqqznVi6u3UdGj2xkoCEff9l1MAJHfK9
         FlwZXauzHDtggxFcNYcf/IUIOAr1ufV64ROF0ND+XwDo7sgo6s0CukznsfD7VbkYv2kd
         60HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770777354; x=1771382154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XvL+o58yw7AJG9LxCh1T6J8XamzsG2DrskuNqxQ2m2U=;
        b=oHY/YRGzR3Z7lie8AwDZrKxlwDl70W8lNZyXjduBDJAO9y6iMldgsxyPZYQKHDOEQW
         L8BgePv6aBO6jfzjvDjaRpsKyrPSg+m5Qrd6takq6H+JICftLyit0kXjTMM68npCs/KZ
         fjyCIOo3xRJJZA9W9ddsDgoDsLXhyEtpcPxNEtB46V7kD+9wiVG2X+Qm61iilXLHtSov
         +KiZ5f6uG+1n8ij8NkdZ1uys9acRJNDmT6D/6FUQ6UhvjjSKZZ1fHuESiEWioAQychXL
         MUHhSKtMHLHXMLms3/m/IYnGX9vO3MiQ4dw0pyFWaKfidh7xXQgya2auSf5OASrpP+JP
         zTAg==
X-Forwarded-Encrypted: i=1; AJvYcCUD0NHFTIA9XgsOQQn9rhw91GGoq8DsTAo8yjNKGcrVdSCM8VazPwHSI8fWJDay9ixeHnJVlJMk4DfU@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4N/1QhgGTRmALxPe2y0n1P9HOdOXgomyCEdv/37kuM3YTt5n3
	rK5Q2fzbhMwokPyIsiJCsXIX4UZ0sdA689Xhgc4Xx8jIk10gyD7PdKdUrX8+O1HbJjq1679dB5/
	qPz+79FtdFIF3zf7u0DWShVP7E2AqZTVdEEnUDjpF+mFOt73glYTFzXPY8cVWfQ/BXBfe+vhwgs
	FOBoPh9/u9dW0m/2lXjYGV4FG0IzMWfVr00fW1dUCaYMB/dA==
X-Gm-Gg: AZuq6aKpNP81Gp/WLrY8StDBkSFBkytHn9llACjAS+AzCJ+lbPZciPwfGjwqYklYKhc
	5qLoJY+Rz52EMZh4g3Z4fPJrjYzage+2uubXJcMDw2JZhpP/ej1hBvp7x+WKXuoiKoeQYpEoq2w
	2WIpV3sJlB7JsECd4Wyyocv1cK23kLss3OD69oBa4fdmalWnbpWWT0D+louYZvXNbgSYr+q8pDu
	YWnOenrX+mM/Blb2VX0t0q57+xDHPeGgkUqES1CEpw3H0FXArBbgcSN+AlQvVFbq2Y6VkmuYR6k
	Nc28TA==
X-Received: by 2002:a05:6512:3e08:b0:59e:465d:e32e with SMTP id 2adb3069b0e04-59e465de4a4mr4750851e87.29.1770777354125;
        Tue, 10 Feb 2026 18:35:54 -0800 (PST)
X-Received: by 2002:a05:6512:3e08:b0:59e:465d:e32e with SMTP id
 2adb3069b0e04-59e465de4a4mr4750843e87.29.1770777353711; Tue, 10 Feb 2026
 18:35:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206053826.37416-1-xni@redhat.com> <20260206053826.37416-2-xni@redhat.com>
 <02c05b44-ee43-44c0-ae39-d1c77d31158f@fnnas.com>
In-Reply-To: <02c05b44-ee43-44c0-ae39-d1c77d31158f@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 11 Feb 2026 10:35:42 +0800
X-Gm-Features: AZwV_QgQ492VCnQBaqhhcbC40YpgPVKINpDPgtonLFolV7LYRC1OLRj1ar5x0DQ
Message-ID: <CALTww2_tgyMw71Vscg-xWe952zjHWv16pF8-f2osmSpk5GKoeQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid1: fix the comparing region of interval tree
To: yukuai@fnnas.com
Cc: song@kernel.org, linux-raid@vger.kernel.org, linan666@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 11, 2026 at 10:19=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/2/6 13:38, Xiao Ni =E5=86=99=E9=81=93:
> > Interval tree uses [start, end] as a region which stores in the tree.
> > In raid1, it uses the wrong end value. For example:
> > bio(A,B) is too big and needs to be split to bio1(A,C-1), bio2(C,B).
> > The region of bio1 is [A,C] and the region of bio2 is [C,B]. So bio1 an=
d
> > bio2 overlap which is not right.
> >
> > Fix this problem by using right end value of the region.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/raid1.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
>
> Perhaps also add a fix tag, with this:

Thanks for the suggestion. I'll add it and send V2
>
> Reviewed-by: Yu Kuai <yukuai@fnnas.com>
>
> >
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 867db18bc3ba..a41b1ec3d695 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -62,7 +62,7 @@ static int check_and_add_serial(struct md_rdev *rdev,=
 struct r1bio *r1_bio,
> >       unsigned long flags;
> >       int ret =3D 0;
> >       sector_t lo =3D r1_bio->sector;
> > -     sector_t hi =3D lo + r1_bio->sectors;
> > +     sector_t hi =3D lo + r1_bio->sectors - 1;
> >       struct serial_in_rdev *serial =3D &rdev->serial[idx];
> >
> >       spin_lock_irqsave(&serial->serial_lock, flags);
> > @@ -453,7 +453,7 @@ static void raid1_end_write_request(struct bio *bio=
)
> >       int mirror =3D find_bio_disk(r1_bio, bio);
> >       struct md_rdev *rdev =3D conf->mirrors[mirror].rdev;
> >       sector_t lo =3D r1_bio->sector;
> > -     sector_t hi =3D r1_bio->sector + r1_bio->sectors;
> > +     sector_t hi =3D r1_bio->sector + r1_bio->sectors - 1;
> >       bool ignore_error =3D !raid1_should_handle_error(bio) ||
> >               (bio->bi_status && bio_op(bio) =3D=3D REQ_OP_DISCARD);
> >
>
> --
> Thansk,
> Kuai
>

