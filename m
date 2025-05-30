Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600B019B5B4
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 06:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748588331; cv=none; b=KgKAdEdfAIxk3kNcCUcRagXzcQFDv7gunxFtq0HJ3uMFuaeC3tJ/PyBQ6j3vSStnR/fYJb6ppbt+MLAUX2Uv8hCWJpHaV66998qlcYKDGbcySreo1hF7G80dfzECgJjYviWzfQq5boGqwjCSFHAn4iKFBqmVkFh7a+lVAnQSw+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748588331; c=relaxed/simple;
	bh=aMD6JPc+zAreDwmfVVJjEaYW/6w4NNjKtn5WsnxYqQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tw9zW8AFAnlbSQPmx4zQkVXi90fJKImKX/VSndSo/y8c59KwMJVXYtksmDjDXCRuVGCJflXeNlMNiS3338/rRumh67Vu6qQ0tNwWKw2K9KBVXqVQaWKbc91NKEwhvTCbkeh+Iz/EKTjyFiQ7PRnyUSVUOY2ZpM8be4z49XEXKOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h7M5+fMc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h7M5+fMc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748588328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zUoCbrrTZZhWQkkA0yDLETtZDcOvFZCMrMuJ94we6L4=;
	b=h7M5+fMcQJezM+MTZGgXuiRmqN2wCRnVS7sbM0o5ZE0uezChqnc6h0Wn+mbuHgc5EYHVCp
	PrVX9Cct6cARfqQRDNkijzuNSKEpKqP/PdpGrs4zVr5PxVNJuWGISMTWy51qgO/IZeF0cP
	/4c6NAObk/9cKEiDWJLQS1Bj8nKuYyg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-112-3r0YHaQWPaKQU1q3ZUG4aQ-1; Fri, 30 May 2025 02:58:46 -0400
X-MC-Unique: 3r0YHaQWPaKQU1q3ZUG4aQ-1
X-Mimecast-MFC-AGG-ID: 3r0YHaQWPaKQU1q3ZUG4aQ_1748588325
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-32a85b6a67dso3595311fa.2
        for <linux-raid@vger.kernel.org>; Thu, 29 May 2025 23:58:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748588325; x=1749193125;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zUoCbrrTZZhWQkkA0yDLETtZDcOvFZCMrMuJ94we6L4=;
        b=g9ab7eRrQ81JR2uRzz4YghCrEu7S3+ydUI/sjDLb4nmZvYSdbrxLD28+ClcFYX1yqg
         +SZ27c3RZXt1KFrT7t3yTi97cErvjo/dUqZHBr/98RXtU1/bjZmO2VnCXJPgRT1Bk7cE
         qwyZ1N8WpP/T/KM2OQh2FHkjbZctldOkDULHUnuq9dWkpd6MvNhR7ctk0m+EA6KmciX/
         DhxU2Xo5+67kjn7YkXzZY9+4KMUHoK/WnBJ5cxezA8qYU2U1ITZkVow3gp4dvtLhmIyF
         zH5guJwZHHa3z1llevVeHV+VL7hfieS4EF5U2c2wnIf/HhQtqWhok12iGpKxqzayQMa3
         DEJw==
X-Gm-Message-State: AOJu0Yy6+XlnwoCUzSFe36YyyHb+xuX7kh/77LCxzVsjbVP5ZVegQW5E
	37Caodc1F6ZCYnl+X1ixkvFfCDxno+ZOciAw9EJrdqWpfu5KxruXYY/brIQFjmgDKrit6du161p
	EiuXzhg73xRLjHJ680HppWJs5tHdrJRALK/fImmhOm3nBMobZ9R8Z10iVk1QEB+EYd9dL8wFeV5
	z+JCRBp71TJvzncoqEEkOOL5lH7a03DvMcRAE9QA==
X-Gm-Gg: ASbGncvZrWxfVOes/DihabFYbr5rkph9Wlc32+F5/AC0Z2kOcmH4FRhu34rvKwHSNxX
	vznPlzFIhNovBy4TyaHgGSWLBMtSF69fppivoZkPBNSDAhqS5iAPGLfopSJWnrDI5DmXxwA==
X-Received: by 2002:a05:651c:4206:b0:32a:8311:2d2f with SMTP id 38308e7fff4ca-32a907e734emr1902051fa.31.1748588324882;
        Thu, 29 May 2025 23:58:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7zYmgaz06X9i9PjzPSjvb+hZwPAuRazoP12S/9SxNfuWs1Ae7fgx+jm3OlBB2Rn5D6hWV9SecV+tI1l8LaZo=
X-Received: by 2002:a05:651c:4206:b0:32a:8311:2d2f with SMTP id
 38308e7fff4ca-32a907e734emr1901991fa.31.1748588324461; Thu, 29 May 2025
 23:58:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250515090847.2356-1-xni@redhat.com> <20250515090847.2356-2-xni@redhat.com>
 <fed9d361-7005-d82c-d03b-6b6e5f12d4d5@huaweicloud.com>
In-Reply-To: <fed9d361-7005-d82c-d03b-6b6e5f12d4d5@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 30 May 2025 14:58:32 +0800
X-Gm-Features: AX0GCFuf-mq73MPYm4zeGOGDD2rXAuYoCEZHL6jOboqA-I0liy8qqLGEAaY-Dds
Message-ID: <CALTww2_XhTGYi_sY50EFSh3V7-vn=OoZnLGVtVwX-5RSP4vFXA@mail.gmail.com>
Subject: Re: [PATCH 1/2] md: Don't clear MD_CLOSING until mddev is freed
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, song@kernel.org, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2025 at 2:48=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> =E5=9C=A8 2025/05/15 17:08, Xiao Ni =E5=86=99=E9=81=93:
> > UNTIL_STOP is used to avoid mddev is freed on the last close before add=
ing
> > disks to mddev. And it should be cleared when stopping an array which i=
s
> > mentioned in commit efeb53c0e572 ("md: Allow md devices to be created b=
y
> > name."). So reset ->hold_active to 0 in md_clean.
> >
> > And MD_CLOSING should be kept until mddev is freed to avoid reopen.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/md.c | 15 ++++-----------
> >   1 file changed, 4 insertions(+), 11 deletions(-)
> >
>
> Patch 1 applied to md-6.16
>
> BTW, please send a new version for patch 2, we might consider it for
> the next merge window.

Thanks. I'm preparing patches for other changes.

Regards
Xiao
>
> Thanks,
> Kuai
>
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 9daa78c5fe33..9b9950ed6ee9 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -6360,15 +6360,10 @@ static void md_clean(struct mddev *mddev)
> >       mddev->persistent =3D 0;
> >       mddev->level =3D LEVEL_NONE;
> >       mddev->clevel[0] =3D 0;
> > -     /*
> > -      * Don't clear MD_CLOSING, or mddev can be opened again.
> > -      * 'hold_active !=3D 0' means mddev is still in the creation
> > -      * process and will be used later.
> > -      */
> > -     if (mddev->hold_active)
> > -             mddev->flags =3D 0;
> > -     else
> > -             mddev->flags &=3D BIT_ULL_MASK(MD_CLOSING);
> > +     /* if UNTIL_STOP is set, it's cleared here */
> > +     mddev->hold_active =3D 0;
> > +     /* Don't clear MD_CLOSING, or mddev can be opened again. */
> > +     mddev->flags &=3D BIT_ULL_MASK(MD_CLOSING);
> >       mddev->sb_flags =3D 0;
> >       mddev->ro =3D MD_RDWR;
> >       mddev->metadata_type[0] =3D 0;
> > @@ -6595,8 +6590,6 @@ static int do_md_stop(struct mddev *mddev, int mo=
de)
> >               export_array(mddev);
> >
> >               md_clean(mddev);
> > -             if (mddev->hold_active =3D=3D UNTIL_STOP)
> > -                     mddev->hold_active =3D 0;
> >       }
> >       md_new_event();
> >       sysfs_notify_dirent_safe(mddev->sysfs_state);
> >
>

