Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC57182CD
	for <linux-raid@vger.kernel.org>; Sat,  8 Mar 2025 03:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741403189; cv=none; b=VEtGH2xxDJvDJmrAZ+FFva7asKinr2GLHcaNKGip0l6PwwTz81//SGKBq3SuR+ncBQovU6Ui3qrPYoh9r+ObDD/dQI7PdzOwfnz+t1ew0de+0jtfU3nL0d2ORdKvHNtjIcbEdDNbPaY2WIxs9VMT9An7E9b6w+x50VkectenkHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741403189; c=relaxed/simple;
	bh=kjFt5ep+D+h0+oRlTXaTMPsVP4IqdrrY3C1HiMpRWbw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DFvPaNSBsFHYxA4Uxv8Q6cxLnQBv3r8nO+fbsRE3N9jRdVOgATp8x2aXdmkOD7y01XoYIFuUZv0Ctarpz2efFxbMBV+WnheAx30FG6oe3lrfIimQxYVM7xALPjgM6503KOa9YiheJSJWt9Cem7Gu59GQ3JEqb60pXV1lJbGkPAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PHaV3NKj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PHaV3NKj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741403186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nv26Ioboo4wliX4t8G2NF7o9UKyTUZMyYLGsQORzuvg=;
	b=PHaV3NKjlDPYHqM2YUZB3bw6Z7nMOyBlJGsxPEndASUjzqDAhUEDpx7CLTzBq2byKn6q6s
	mOz+sw41u6bpbGG5//KMRYHzhrh0+DPt/Zff2OR11EDiHCDsa+x0FFZBfuiQHDgmrCWatU
	drXYAkMa5XoG/mHgscOO6g8NnxImcvg=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-101-FHHNQopYOOqf6-NKpdfIQQ-1; Fri, 07 Mar 2025 22:06:25 -0500
X-MC-Unique: FHHNQopYOOqf6-NKpdfIQQ-1
X-Mimecast-MFC-AGG-ID: FHHNQopYOOqf6-NKpdfIQQ_1741403183
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-30bf647863fso6984791fa.3
        for <linux-raid@vger.kernel.org>; Fri, 07 Mar 2025 19:06:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741403183; x=1742007983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nv26Ioboo4wliX4t8G2NF7o9UKyTUZMyYLGsQORzuvg=;
        b=HFDBMTwJ+fbvgqCkaYgFqWL0lrvonhRIdpe7DzUguN4d96WU1HFhYCjGu9s7Kx+6UL
         NOKfDMTKGZIVZdJd1uN/pLVCIpW76l0p6AZh4n0SnX9Zq/866XJidn7S3U2Dhcg+VPmQ
         Jtij65gdOSZhE+bZS1CQx1Nf8eovSIwprIjr0B04mALDgYxlJPWVQ4MorZ0iDa7ZmDfG
         AbgHCkyhbRI0sJWkgB9vsPoQpfob2+2h4DLgJoJkgd3Lc7oTwnLq7ju81OZ867iKKgay
         XXg4MZb/7GlukgvnIbRJGEz1rcPyH1j7uNT7IFQgATWzeKL+8xocTuqOUSnOaC98Xh1/
         Iisw==
X-Forwarded-Encrypted: i=1; AJvYcCWiVM/6SaVi9Cm+jGK71MqKBWKXl3V70Hq1Pa4PPeH4lqVTgbXcflhDlT4iHbBOE1mROCHitC/aLanV@vger.kernel.org
X-Gm-Message-State: AOJu0YyLKxMtq5cSS4Dbqr308kJomM6JenV7PQ8mckjYUIeN7FswsexX
	pY6ZFsI1MzsDpL8RRTr1B0u4Ejm9iOoOy4/wNUqyGY6rdFNgVTaOUvmbYXijVXrL65ckqukkiA/
	owqSNVY2HTIf1/5T9MWKSCUiMQSnabicddlGPPJt2Kd8oOyEb9syB/E8qClr4n1+I/ISlKbvSSP
	HSacpsLHHJvfAKVgTGUDBhD7LDkhyvc7AM4w==
X-Gm-Gg: ASbGncssBj2eMTg4wt2NI+skPPKx6sbivwRxpNBhHv4rlGWI6RCR4wYSsDFM69VFYsM
	M4V9+mw1T2Lio77zYlmNf10zJ8/QIpAPyE7P48vMhcTRSpag1xhmtwDjvMrMIMefa7VmbWm6Zig
	==
X-Received: by 2002:a05:6512:159a:b0:549:8ed4:fb4c with SMTP id 2adb3069b0e04-54990e6420bmr2260099e87.24.1741403183351;
        Fri, 07 Mar 2025 19:06:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFm46mbMH1LGckHMTPFNS0Su2aSHPpfaKuDiVbik/Qh2Cpjn29uyxJl/wfFpHRvleSpcdPhYFzUxVvbbIoVL/Y=
X-Received: by 2002:a05:6512:159a:b0:549:8ed4:fb4c with SMTP id
 2adb3069b0e04-54990e6420bmr2260092e87.24.1741403182943; Fri, 07 Mar 2025
 19:06:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d78cbb12-9a9c-7965-db9a-70b4b277f908@huawei.com> <42e56670-e595-1c66-208c-40c103262890@huaweicloud.com>
In-Reply-To: <42e56670-e595-1c66-208c-40c103262890@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sat, 8 Mar 2025 11:06:11 +0800
X-Gm-Features: AQ5f1Jp3N8MiZlqZlzpcKko6NQMVlTWZRuZLRwLhYIeVy3dZsnJaaappiD31MnA
Message-ID: <CALTww2_yMs_QYSWaQgRFNRgkaZi15KDmdH_00QeTOJWmp1YHcQ@mail.gmail.com>
Subject: Re: [PATCH] mdadm: Don't set bad_blocks flag when initializing metadata
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Wu Guanghao <wuguanghao3@huawei.com>, 
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, ncroxon@redhat.com, 
	linux-raid@vger.kernel.org, liubo254@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Guanghao

Thanks for your patch.

On Tue, Mar 4, 2025 at 8:27=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2025/03/04 14:12, Wu Guanghao =E5=86=99=E9=81=93:
> > When testing the raid1, I found that adding disk to raid1 fails.
> > Here's how to reproduce it:
> >
> >       1. modprobe brd rd_nr=3D3 rd_size=3D524288
> >       2. mdadm -Cv /dev/md0 -l1 -n2 -e1.0 /dev/ram0 /dev/ram1
> >
> >       3. mdadm /dev/md0 -f /dev/ram0
> >       4. mdadm /dev/md0 -r /dev/ram0
> >
> >       5. echo "10000 100" > /sys/block/md0/md/dev-ram1/bad_blocks
> >       6. echo "write_error" > /sys/block/md0/md/dev-ram1/state
> >
> >       7. mkfs.xfs /dev/md0

Do we need this step7 here?

> >       8. mdadm --examine-badblocks /dev/ram1  # Bad block records can b=
e seen
> >          Bad-blocks on /dev/ram1:
> >                      10000 for 100 sectors
> >
> >       9. mdadm /dev/md0 -a /dev/ram2
> >          mdadm: add new device failed for /dev/ram2 as 2: Invalid argum=
ent
>
> Can you add a new regression test as well?
>
> >
> > When adding a disk to a RAID1 array, the metadata is read from the exis=
ting
> > member disks for synchronization. However, only the bad_blocks flag are=
 copied,
> > the bad_blocks records are not copied, so the bad_blocks records are al=
l zeros.
> > The kernel function super_1_load() detects bad_blocks flag and reads th=
e
> > bad_blocks record, then sets the bad block using badblocks_set().
> >
> > After the kernel commit 1726c7746("badblocks: improve badblocks_set() f=
or
> > multiple ranges handling"), if the length of a bad_blocks record is 0, =
it will
> > return a failure. Therefore the device addition will fail.

Can you give the specific function replace with "it will return a failure" =
here?

> >
> > So, don't set the bad_blocks flag when initializing the metadata, kerne=
l can
> > handle it.
> >
> > Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> > ---
> >   super1.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/super1.c b/super1.c
> > index fe3c4c64..03578e5b 100644
> > --- a/super1.c
> > +++ b/super1.c
> > @@ -2139,6 +2139,9 @@ static int write_init_super1(struct supertype *st=
)
> >               if (raid0_need_layout)
> >                       sb->feature_map |=3D __cpu_to_le32(MD_FEATURE_RAI=
D0_LAYOUT);
> >
> > +             if (sb->feature_map & MD_FEATURE_BAD_BLOCKS)
> > +                     sb->feature_map &=3D ~__cpu_to_le32(MD_FEATURE_BA=
D_BLOCKS);
>
> There are also other flags that is per rdev, like MD_FEATURE_REPLACEMENT
> and MD_FEATURE_JOURNAL, they should be excluded as well.

Hmm, why do we need to remove these flags too? It's better to use a
separate patch rather than using this patch and describe it in detail.
It's better to give an example also.

Best Regards
Xiao
>
> Thanks,
> Kuai
>
> > +
> >               sb->sb_csum =3D calc_sb_1_csum(sb);
> >               rv =3D store_super1(st, di->fd);
> >
>
>

