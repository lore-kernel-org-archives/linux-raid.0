Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5EB51C23
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 04:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709009382; cv=none; b=hfwoWbmrH8SVyFRwj6CEnnHPbe4KuEFqrQXUGlFQbP/GYnHLvPVLfSFJs2g8lOEJieaSJ6YtENtk2q/QhS9JVickny6RRvQB3wkkeXc+baiqJy1wFdGyp8oNekwbF44NcABn69IiGO4vXGDcG8+G/t4eO89XHp2jiI8SnbJzu5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709009382; c=relaxed/simple;
	bh=FuHYOldpPnqbaKrdQRI+3loAuTSXbdWRUieVFpn6n6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NWhdNKLKrWj4Hpm4uTzbHEm3xQsdSwuwlHDkWuKtjcbbTR571CMDltWupZpdZNJ17XDgoCt/YDTca7nUobJhzieP4euGmqyPoXhnPAAJcEwNFDUzYkuJ3SRn31JX1Jcp2oJsXpRGrkotA8+o4gj5h6mr2UF29WOrB1j6siwwn7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h6ExSm/S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h6ExSm/S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709009379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w/eq9c918teT3asFeHzf8cTm6jZIDfMNRa5Rd6esSYg=;
	b=h6ExSm/SFwtRrLNw1Pc20mQt/c83XeUYFLS6i8C/SSk2912oRgBN9T6kfM06IyPw40jGEx
	Y45GQsAxwUAy/IBduU/zbrvyP8ggIeAuxktpS+3mg6JrnrXsA/q/7bXnxvZvFpJFal4zmx
	YhvlT2nzL6lv/229D2dLKg4kkIoZ4H8=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-ypCIQVIbOmuOSAMtSTZZug-1; Mon, 26 Feb 2024 23:49:15 -0500
X-MC-Unique: ypCIQVIbOmuOSAMtSTZZug-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1dbcf647a9dso29384295ad.1
        for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 20:49:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709009354; x=1709614154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/eq9c918teT3asFeHzf8cTm6jZIDfMNRa5Rd6esSYg=;
        b=KD/X1Kup9CEHmzxpsN7xdb5nIKzpFd7UTSQ96guHT9O3PTtUQudLeZF+8+7jy3Sh18
         rE9AqrtgWSwVQ5a0ATJnYiUJN3O+lwLM/rJUlr2hwmZpVckiTjBCRTa+RW7LdMCCUmJp
         oEJ+9KCvCURKjijTAlLYj8bsLeRf3H15FauImwZQKT1KE/o8tf8qeDCtUnQT3RQYTFRt
         17H6K2Pv5g48vOCpfi1uWwmohWACuLQlhnYQAppsg4moktsP5Oy1Z6vx+pnndMSXzocx
         km8S3pHRl2/UMP86KZL1iHiPByv8BqloxATlqJjpLabBhj5lyx3apgcxXpHg1vKwQFuv
         1wLw==
X-Forwarded-Encrypted: i=1; AJvYcCUwm9RgQDUP54Twfzx5+R4ozku9lZQIvOA56k7C3zYnhay0JQTu4I9pUJdiQBgt1FeFvB5hEt9FKs7Pz1y8gHK+7TvYA0/x/icImQ==
X-Gm-Message-State: AOJu0YxjuEC3pUhoKkSWejYGyaABDNl7c8awlXCC5zuGJ/XjxqjoNpn6
	p9qCqnngiwpndn6tq9vgBCfD6DL4tjN8J6qSWgRrvikSv2GgVzpxJglXAbmsyRfXjmQPFOWcIug
	1h4VCh8kAhCmIlAQNAHCcBlGL/OqPu/R0XHFikgfOjJK8wSUvM8PaMKLs1TpzzSUwDzNaquXQs3
	n8qNyUQqc3v97Y9NMmvP+1l3IVQpXHdITpAw==
X-Received: by 2002:a17:902:c404:b0:1d7:836d:7b3f with SMTP id k4-20020a170902c40400b001d7836d7b3fmr12471170plk.9.1709009354665;
        Mon, 26 Feb 2024 20:49:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGcQHKqVXo0WXICXk9+Xsnh8f59Fw9GO8bR1Tyz59KHSKC2XmtaJOO764mlIcroPKV+fGliO39IJ8JdCQit7ZQ=
X-Received: by 2002:a17:902:c404:b0:1d7:836d:7b3f with SMTP id
 k4-20020a170902c40400b001d7836d7b3fmr12471157plk.9.1709009354330; Mon, 26 Feb
 2024 20:49:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222075806.1816400-1-yukuai1@huaweicloud.com>
 <20240222075806.1816400-4-yukuai1@huaweicloud.com> <CALTww28PJPdqRkSEarwATG5GmkuMmEtT0La5s-9c9r5UPy4siA@mail.gmail.com>
 <6114e6f5-87a6-216e-027d-cbb0a7e8e429@huaweicloud.com>
In-Reply-To: <6114e6f5-87a6-216e-027d-cbb0a7e8e429@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 27 Feb 2024 12:49:03 +0800
Message-ID: <CALTww2_iPFJiX17ORbN2+ssdYWVk0=M4pCgJDoWh_-jJPn0bRA@mail.gmail.com>
Subject: Re: [PATCH md-6.9 03/10] md/raid1: fix choose next idle in read_balance()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, neilb@suse.com, shli@fb.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 10:38=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2024/02/27 10:23, Xiao Ni =E5=86=99=E9=81=93:
> > On Thu, Feb 22, 2024 at 4:04=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> Commit 12cee5a8a29e ("md/raid1: prevent merging too large request") ad=
d
> >> the case choose next idle in read_balance():
> >>
> >> read_balance:
> >>   for_each_rdev
> >>    if(next_seq_sect =3D=3D this_sector || disk =3D=3D 0)
> >>    -> sequential reads
> >>     best_disk =3D disk;
> >>     if (...)
> >>      choose_next_idle =3D 1
> >>      continue;
> >>
> >>   for_each_rdev
> >>   -> iterate next rdev
> >>    if (pending =3D=3D 0)
> >>     best_disk =3D disk;
> >>     -> choose the next idle disk
> >>     break;
> >>
> >>    if (choose_next_idle)
> >>     -> keep using this rdev if there are no other idle disk
> >>     contine
> >>
> >> However, commit 2e52d449bcec ("md/raid1: add failfast handling for rea=
ds.")
> >> remove the code:
> >>
> >> -               /* If device is idle, use it */
> >> -               if (pending =3D=3D 0) {
> >> -                       best_disk =3D disk;
> >> -                       break;
> >> -               }
> >>
> >> Hence choose next idle will never work now, fix this problem by
> >> following:
> >>
> >> 1) don't set best_disk in this case, read_balance() will choose the be=
st
> >>     disk after iterating all the disks;
> >> 2) add 'pending' so that other idle disk will be chosen;
> >> 3) set 'dist' to 0 so that if there is no other idle disk, and all dis=
ks
> >>     are rotational, this disk will still be chosen;
> >>
> >> Fixes: 2e52d449bcec ("md/raid1: add failfast handling for reads.")
> >> Co-developed-by: Paul Luse <paul.e.luse@linux.intel.com>
> >> Signed-off-by: Paul Luse <paul.e.luse@linux.intel.com>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> ---
> >>   drivers/md/raid1.c | 21 ++++++++++++---------
> >>   1 file changed, 12 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> index c60ea58ae8c5..d0bc67e6d068 100644
> >> --- a/drivers/md/raid1.c
> >> +++ b/drivers/md/raid1.c
> >> @@ -604,7 +604,6 @@ static int read_balance(struct r1conf *conf, struc=
t r1bio *r1_bio, int *max_sect
> >>          unsigned int min_pending;
> >>          struct md_rdev *rdev;
> >>          int choose_first;
> >> -       int choose_next_idle;
> >>
> >>          /*
> >>           * Check if we can balance. We can balance on the whole
> >> @@ -619,7 +618,6 @@ static int read_balance(struct r1conf *conf, struc=
t r1bio *r1_bio, int *max_sect
> >>          best_pending_disk =3D -1;
> >>          min_pending =3D UINT_MAX;
> >>          best_good_sectors =3D 0;
> >> -       choose_next_idle =3D 0;
> >>          clear_bit(R1BIO_FailFast, &r1_bio->state);
> >>
> >>          if ((conf->mddev->recovery_cp < this_sector + sectors) ||
> >> @@ -712,7 +710,6 @@ static int read_balance(struct r1conf *conf, struc=
t r1bio *r1_bio, int *max_sect
> >>                          int opt_iosize =3D bdev_io_opt(rdev->bdev) >>=
 9;
> >>                          struct raid1_info *mirror =3D &conf->mirrors[=
disk];
> >>
> >> -                       best_disk =3D disk;
> >>                          /*
> >>                           * If buffered sequential IO size exceeds opt=
imal
> >>                           * iosize, check if there is idle disk. If ye=
s, choose
> >> @@ -731,15 +728,21 @@ static int read_balance(struct r1conf *conf, str=
uct r1bio *r1_bio, int *max_sect
> >>                              mirror->next_seq_sect > opt_iosize &&
> >>                              mirror->next_seq_sect - opt_iosize >=3D
> >>                              mirror->seq_start) {
> >> -                               choose_next_idle =3D 1;
> >> -                               continue;
> >> +                               /*
> >> +                                * Add 'pending' to avoid choosing thi=
s disk if
> >> +                                * there is other idle disk.
> >> +                                * Set 'dist' to 0, so that if there i=
s no other
> >> +                                * idle disk and all disks are rotatio=
nal, this
> >> +                                * disk will still be chosen.
> >> +                                */
> >> +                               pending++;
> >> +                               dist =3D 0;
> >> +                       } else {
> >> +                               best_disk =3D disk;
> >> +                               break;
> >>                          }
> >> -                       break;
> >>                  }
> >
> > Hi Kuai
> >
> > I noticed something. In patch 12cee5a8a29e, it sets best_disk if it's
> > a sequential read. If there are no other idle disks, it will read from
> > the sequential disk. With this patch, it reads from the
> > best_pending_disk even min_pending is not 0. It looks like a wrong
> > behaviour?
>
> Yes, nice catch, I didn't notice this yet... So there is a hidden
> logical, sequential IO priority is higher than minimal 'pending'
> selection, it's only less than 'choose_next_idle' where idle disk
> exist.

Yes.


>
> Looks like if we want to keep this behaviour, we can add a 'sequential
> disk':
>
> if (is_sequential())
>   if (!should_choose_next())
>    return disk;
>   ctl.sequential_disk =3D disk;
>
> ...
>
> if (ctl.min_pending !=3D 0 && ctl.sequential_disk !=3D -1)
>   return ctl.sequential_disk;

Agree with this, thanks :)

Best Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Best Regards
> > Xiao
> >>
> >> -               if (choose_next_idle)
> >> -                       continue;
> >> -
> >>                  if (min_pending > pending) {
> >>                          min_pending =3D pending;
> >>                          best_pending_disk =3D disk;
> >> --
> >> 2.39.2
> >>
> >>
> >
> > .
> >
>

