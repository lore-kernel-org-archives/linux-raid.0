Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FF01DFED
	for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724853411; cv=none; b=bofpukE30gWaXnEB9y+XUn+z0l5fyNUUjLVMh+1viQl0eQvr5bJWkULUP9QPhiA6x40gPeNEMTNUMSeQJJryjDvRjSHXDAnm9DUbO3IkxD/vEMZ6fZwI7fAArzaXq1WM7p++JoADbETN8zzDIOkcfNQ252QEYtTspJuEUUkJtzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724853411; c=relaxed/simple;
	bh=xi9Hzs9nHx59C23nw2peGdtEh7rxcRzrMYwQkLeO+Nc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RhvShiUKyRyepJKAqxyaMANumc9mi2cEGgYshZtR3DFrF6fElswZK/xm0x6Zv7EmqmjYvdwGMk7V8D+/oR4v+Ks5lDYcl2aHkSLNpwfiXYWRGkuGgfxpQ1JpRAKipWp1kqjQSNGi2NREnC0UlsCh4FZ7BZTWVQR+Jd9ULyehRLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PCdYucxB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PCdYucxB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724853408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZYc2/pF5FYs4HW3dqYnyPx5V56pASiod7n57taUU/FE=;
	b=PCdYucxBumOS7CPTBsNHu0s9dYmQM3AgDgIhkZ5ANCSI9hs+EMbw8r1ncROAuPpLzRylWC
	EfLeU6HpBXV1onC17SFNrc0/DwmxD3yXDn/Sl45wIEFNaZ/i9JGtaB9lO2YaQXvFEZ58PZ
	ak3iUyQhgdVRoSz1GtSIuxfk+WaM+0U=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-l4mVhEL1NkCflRur_AWOKw-1; Wed, 28 Aug 2024 09:56:47 -0400
X-MC-Unique: l4mVhEL1NkCflRur_AWOKw-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-7c6b192a39bso5827081a12.2
        for <linux-raid@vger.kernel.org>; Wed, 28 Aug 2024 06:56:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724853406; x=1725458206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZYc2/pF5FYs4HW3dqYnyPx5V56pASiod7n57taUU/FE=;
        b=XG+wr6t66uoFQ2d8Zzv2JGYJspGYF32gACIuHfU75ce5HtyKZ4XdNrKjw8VU99RJqn
         fExFEG0wP8XNl4+pqu7mpAE8Zo7qf/wOsAmxoiybt8PAq59cOUMWCEaqkeWXzdyDshr3
         KxBatBd3t73t9L/NK01n2nOjABmoPgPKr/8QzHkOiN6wQHCsCPoLajuQbw82YYXgmI6e
         fS6aa0oAsTluGYxCwNLuYe187qe1psiX9ReiuR2ucSgB6LhJ2TLtmJilRvYYWP3EpAmq
         XLw8t6o/cCB2jqHtuSET5fYJavG4smBTH6ICS3db5fN74/2ZE0/QBy3Kldsc+iGV2krQ
         aI+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXW3R/OSKEoB2Q2+ndsQpU8ycgzPQ0VxjBb1CXxNcj1X8kDpdLgJj0qSgkkIJ4L6PKZdGVm0FlqmYE9@vger.kernel.org
X-Gm-Message-State: AOJu0YzXXwQnysl0U+MqQ7GhR33yRUeBETmvILkqCIXuQChkXOMz2YAe
	qKjFa8IdNcRi2u0ZgC9Vg8IZInqzQY4okElI7Z5s/oB3tUlilTwp5Dy8+9cennkIY5WtdC2YF2P
	d8cf14u94TaBYzySk+d7A9CxBlMJHV1fZfQF8gvouu9NQ4cyfIKmRmTh19AWdxGp/I8XtgsEe1r
	T3tnAL/3KL9pBme/ZcyRVdaKd5Y0g6SojzOw==
X-Received: by 2002:a17:90b:2342:b0:2cf:f3e9:d5c9 with SMTP id 98e67ed59e1d1-2d646bf0f85mr15347590a91.21.1724853405713;
        Wed, 28 Aug 2024 06:56:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuehRCLbthS2rwCmxuXWFCfpwgc1q8mMh6DIwcTpLxFJdy6SUiDJApObiFHJ1+F/Tl5+U1YkrLFjkShd7uczM=
X-Received: by 2002:a17:90b:2342:b0:2cf:f3e9:d5c9 with SMTP id
 98e67ed59e1d1-2d646bf0f85mr15347549a91.21.1724853404892; Wed, 28 Aug 2024
 06:56:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828021828.63447-1-xni@redhat.com> <810d6b9b-b2fd-4480-a455-413d57a52738@molgen.mpg.de>
 <CALTww28by8qkYeYzS7GzU-2kQ+ddKZZ0g0iFrrdm8PFuCANiVw@mail.gmail.com> <97efa417-bbf9-445e-980c-da2c9c6f6948@molgen.mpg.de>
In-Reply-To: <97efa417-bbf9-445e-980c-da2c9c6f6948@molgen.mpg.de>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 28 Aug 2024 21:56:33 +0800
Message-ID: <CALTww29T=+4DXgx7D5u9xpumyTNiaRYDarDk1AAsJ6RPuPW8gQ@mail.gmail.com>
Subject: Re: [PATCH md-6.12 1/1] md: add new_level sysfs interface
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>, 
	linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 8:33=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de>=
 wrote:
>
> Dear Xiao,
>
>
> Thank you for your reply. Was it intentional, that you only replied to
> me off-list?

Hi Paul

I made a mistake. Thanks for reminding me.

>
> Am 28.08.24 um 10:44 schrieb Xiao Ni:
> > On Wed, Aug 28, 2024 at 1:19=E2=80=AFPM Paul Menzel wrote:
>
> >> Am 28.08.24 um 04:18 schrieb Xiao Ni:
>
> [=E2=80=A6]
>
> >> How can this be tested?
> >
> > mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
> > mdadm --wait /dev/md0
> > mdadm /dev/md0 --grow -l5 --backup=3Dbackup
> > cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
> > md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]
> >        98304 blocks super 1.2 level 6, 512k chunk, algorithm 18 [4/4] [=
UUUU]
> >
> > unused devices: <none>
> >
> > There is a tests directory in mdadm. The case 07changelevels have this
> > test. Now it can't run successfully. This patch is used to fix this.
>
> It=E2=80=99d be great if you mentioned this in the commit message. That t=
his
> test fails, and now it works. Please also mention, if this was a
> regression. (I guess it is, as the test should have been passed, when it
> was added?)

Ok, I'll add them to the commit message. The test cases was created in
2009. So yes, it must be a regression, but it's hard to see what
changes cause the regression.

>
> >>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>> ---
> >>>    drivers/md/md.c | 29 +++++++++++++++++++++++++++++
> >>>    1 file changed, 29 insertions(+)
> >>>
> >>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>> index d3a837506a36..c639eca03df9 100644
> >>> --- a/drivers/md/md.c
> >>> +++ b/drivers/md/md.c
> >>> @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *b=
uf, size_t len)
> >>>    static struct md_sysfs_entry md_level =3D
> >>>    __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
> >>>
> >>> +static ssize_t
> >>> +new_level_show(struct mddev *mddev, char *page)
> >>> +{
> >>> +     return sprintf(page, "%d\n", mddev->new_level);
> >>> +}
> >>> +
> >>> +static ssize_t
> >>> +new_level_store(struct mddev *mddev, const char *buf, size_t len)
> >>> +{
> >>> +     unsigned int n;
> >>> +     int err;
> >>> +
> >>> +     err =3D kstrtouint(buf, 10, &n);
> >>> +     if (err < 0)
> >>> +             return err;
> >>> +     err =3D mddev_lock(mddev);
> >>> +     if (err)
> >>> +             return err;
> >>> +
> >>> +     mddev->new_level =3D n;
> >>> +     md_update_sb(mddev, 1);
> >>> +
> >>> +     mddev_unlock(mddev);
> >>> +     return err ?: len;
> >>
> >> Can `err` be set? Why return `len` if it=E2=80=99s not modified?
> >
> > err is the return value from kstrtouint and mddev_lock. And len is the
> > input value of the buf length. If it can be set successfully, it
> > returns len. It's same with other sysfs functions. For example,
> > raid_disks_store, layout_store and so on.
>
> At least `layout_store` modifies `err` later on. In your new function,
> if there is an error the function returns, so there is no need to check i=
t.

Ah I know what you mean. I'll fix this.
>
> Where is `len` used in your new function? It=E2=80=99s only in the functi=
on
> signature. A colleague also didn=E2=80=99t spot it.

Hmm, functions raid_disks_store, layout_store, chunk_size_sotre don't
use len too. So what's your suggestion here?

Best Regards
Xiao
>
>
> Kind regards,
>
> Paul
>
>
> >>> +}
> >>> +static struct md_sysfs_entry md_new_level =3D
> >>> +__ATTR(new_level, 0664, new_level_show, new_level_store);
> >>> +
> >>>    static ssize_t
> >>>    layout_show(struct mddev *mddev, char *page)
> >>>    {
> >>> @@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, ser=
ialize_policy_show,
> >>>
> >>>    static struct attribute *md_default_attrs[] =3D {
> >>>        &md_level.attr,
> >>> +     &md_new_level.attr,
> >>>        &md_layout.attr,
> >>>        &md_raid_disks.attr,
> >>>        &md_uuid.attr,
>

