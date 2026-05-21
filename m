Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C844A342509
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 07:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779347297; cv=none; b=Ra6nwlO39hLxLtlF76qVcN5ZI6AW0Avmof5i4hoBm4gV8rf5hExv7k57HkuQiuAIgcDkoJa0X6QoIg3hKm0ms4CGy+imfdD0uw0bUxnlkKNHh9DOiMt1p+JtXHsxF8Lp/UN+a9bHePX4HCpAlwkOjV0hYbDQHoQIkM1p/GI7IXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779347297; c=relaxed/simple;
	bh=Ylr48vuN72dBi62uPhx1OTm9JL+R6Kk//IA7s2syulA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=essiWKfEoW7IURJcL14MXHz29js0bJ/Y7oJtvA7jqtCLAykGcapO23Zk5WWbIDOomLZmEy2SDSwo5w7b/BeywuOVcQHiFaTob1A/T2nSaz8FcOpwziFQm0G/+gav9mqQNkBB3k8yOF6tq/812GuvK2rKjkILVY0S2X/uPS48P/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwwW9BlH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwwW9BlH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A9D1F00A3F
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 07:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779347295;
	bh=3y47e5rguVN/9BLBRn5La9SokkrRhoST+PLlRImDqxQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PwwW9BlHUY1F/eVl5WRF9Gj59sNWlwGvSif4InLVUpgEXglC7FW5PPx7DBy1Wfzwp
	 e35R+LI+oG9ruonlsyJh3+jzl2Gc38jxv3WanWvXPgpx2H5x1lumtdCFN4FvS12Xp3
	 C5gQm0UGCL3oNj4sdUuQcZs1xJ4EfgP/iaiwbGXwMa8xzw8cc+TdvfRt+nBpY/OowS
	 41EnSUcxTA9pAVdXPHkr+1OXD272jUDH19X2jlGdagi0dBJ/5C0kfx9UqQR8qM+zyc
	 3FU6BQhQeVd4RE+5kP/JO2+YvCVgH+S6APGHltOHXuNuQj7qCgFU9M45DRo8FIBjaT
	 +gjVEt+WQQUlw==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50d880e6fbbso71609441cf.0
        for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 00:08:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+IG9w+ucD0EMT0d9sSVO1PBTC7AWkCIRYl2TYfXuqRFNVfqqQ3/dMnaz++CvGR7LpSrQvtMjI8HIjf@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5MFdK0PhzDA1bZKJ5nTlkdlIILmStPeGAljLDPYoAFw73CfFW
	2+lE4QVZjbqTVF0WUo5NTLsZQsQATVRp4AITzP2KUZhlnA4XaiJmT/0uxG80KD1aDfeqwmuRPTP
	O1cL+k3KPHOpvq6SW4H4CkU3huNM0OQ==
X-Received: by 2002:ac8:7d8e:0:b0:50d:8ed0:7f10 with SMTP id
 d75a77b69052e-516c58c7d8dmr18357441cf.13.1779347295054; Thu, 21 May 2026
 00:08:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260501114652.590037-1-abd.masalkhi@gmail.com>
 <20260501114652.590037-3-abd.masalkhi@gmail.com> <71990de4-1113-4b7d-8a50-ca1d82802a03@fygo.io>
In-Reply-To: <71990de4-1113-4b7d-8a50-ca1d82802a03@fygo.io>
From: Xiao Ni <xiao@kernel.org>
Date: Thu, 21 May 2026 15:08:02 +0800
X-Gmail-Original-Message-ID: <CAF-RUYVK34e4ShHLd4nYGBdB3yxX4BBkS-woxBnmCuj_6vUisg@mail.gmail.com>
X-Gm-Features: AVHnY4ICOD_Rjv5X8ICuP-X1J90Njupja8SCsBQ2c-4cgJzWsT-6IdIDhhjFQ2s
Message-ID: <CAF-RUYVK34e4ShHLd4nYGBdB3yxX4BBkS-woxBnmCuj_6vUisg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] md/raid1,raid10: fix error-path detection with md_cloned_bio()
To: yukuai@fygo.io
Cc: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>, song@kernel.org, xni@redhat.com, neilb@suse.com, 
	shli@fb.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 21, 2026 at 9:25=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/5/1 19:46, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
> > Detect the error path using md_cloned_bio() instead of relying
> > on r1_bio in raid1 or r10_bio->read_slot in raid10, which may be
> > NULL or -1 after splitting and resubmitting a failed bio.
> >
> > As a result, the error path may not be recognized and memory
> > allocations can incorrectly use GFP_NOIO instead of
> > (GFP_NOIO | __GFP_HIGH), which can lead to a deadlock under
> > memory pressure.
>
> I don't think this patch will fix this problem. Because split bio
> is a new bio that will be resubmit by md_submit_bio(), such bio is
> not a md_cloned_bio yet until md_account_bio().

Hi Kuai

        bio =3D bio_submit_split_bioset(bio, max_sectors,
                          &conf->bio_split);
bio_submit_split_bioset returns the split bio and the remainder bio
will be submitted again which is already a md_cloned_bio.

Regards
Xiao
>
> >
> > Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
> > Fixes: 545250f24809 ("md/raid10: simplify handle_read_error()")
> > Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
> > ---
> > This patch depends on patch 1.
> >
> > Changes in v2:
> >   - New patch.
> > ---
> >   drivers/md/raid1.c  | 13 ++++++++++---
> >   drivers/md/raid10.c | 20 ++++++++++++++------
> >   2 files changed, 24 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index cc9914bd15c1..c52ecd38c163 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -1321,11 +1321,18 @@ static void raid1_read_request(struct mddev *md=
dev, struct bio *bio,
> >       bool r1bio_existed =3D !!r1_bio;
> >
> >       /*
> > -      * If r1_bio is set, we are blocking the raid1d thread
> > -      * so there is a tiny risk of deadlock.  So ask for
> > +      * An md cloned bio indicates we are in the error path.
> > +      * This is more reliable than checking r1_bio, which might
> > +      * be NULL even in the error path if a failed bio was split.
> > +      */
> > +     bool err_path =3D md_cloned_bio(mddev, bio);
> > +
> > +     /*
> > +      * If we are in the error path, we are blocking the raid1d
> > +      * thread so there is a tiny risk of deadlock.  So ask for
> >        * emergency memory if needed.
> >        */
> > -     gfp_t gfp =3D r1_bio ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
> > +     gfp_t gfp =3D err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
> >
> >       /*
> >        * Still need barrier for READ in case that whole
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 3a591e60a144..8c6fc398260e 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1155,7 +1155,20 @@ static void raid10_read_request(struct mddev *md=
dev, struct bio *bio,
> >       char b[BDEVNAME_SIZE];
> >       int slot =3D r10_bio->read_slot;
> >       struct md_rdev *err_rdev =3D NULL;
> > -     gfp_t gfp =3D GFP_NOIO;
> > +
> > +     /*
> > +      * An md cloned bio indicates we are in the error path.
> > +      * This is more reliable than checking slot, which might
> > +      * be -1 even in the error path if a failed bio was split.
> > +      */
> > +     bool err_path =3D md_cloned_bio(mddev, bio);
> > +
> > +     /*
> > +      * If we are in the error path, we are blocking the raid10d
> > +      * thread so there is a tiny risk of deadlock.  So ask for
> > +      * emergency memory if needed.
> > +      */
> > +     gfp_t gfp =3D err_path ? (GFP_NOIO | __GFP_HIGH) : GFP_NOIO;
> >
> >       if (slot >=3D 0 && r10_bio->devs[slot].rdev) {
> >               /*
> > @@ -1166,11 +1179,6 @@ static void raid10_read_request(struct mddev *md=
dev, struct bio *bio,
> >                * we lose the device name in error messages.
> >                */
> >               int disk;
> > -             /*
> > -              * As we are blocking raid10, it is a little safer to
> > -              * use __GFP_HIGH.
> > -              */
> > -             gfp =3D GFP_NOIO | __GFP_HIGH;
> >
> >               disk =3D r10_bio->devs[slot].devnum;
> >               err_rdev =3D conf->mirrors[disk].rdev;
>
> --
> Thansk,
> Kuai
>
