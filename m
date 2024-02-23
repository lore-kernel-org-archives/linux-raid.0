Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3A37C0B7
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708696831; cv=none; b=nZTqHsYoKMdqZhRrugN2RMw46FiSFd4yS+F/v54FmvzANFUZlgmSIDJsu0/YzotVMQxdAR7wU2+In9aX6IMllRMQ3VSWN+Q3b03IpFrtG5JRCv6Vbi99W3RKx9rgnQqU9K0LsQM47c9bWrnYpd6jkX3cETI4mWIbJdpGnD1hkNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708696831; c=relaxed/simple;
	bh=PfnXk2r22NN/m0sUCieEBeSFfoHRGT8yZvHO55Hg7TI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i/dzqFndmISRCClTRjUNk/LryHE0TpUB33fwbUUtCuYnKFYihGpluOrXC1ePATyz6P4LEEJ13Pkl5nETIDCI1mRIidrN2zNwtGL9l+e5uoH43hyRsWgGDzgDrFy/2yE+AGk6qEMTFc0WcrRXKOpXSTXeigo5bCws6LssuRWxNSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KWvX6i+h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KWvX6i+h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708696829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eoJldDMvKw/Jo139YUjehPtpro91AmBrg8GEUEOvUtg=;
	b=KWvX6i+h8gDlNVbbz2aIQFB7SplaIzHqQqd/TnoGv9XUnjNqt17N3chIZ6+AUS+zpnpmU3
	+jQBjz0WLdJq5DR1kWc4XNXqPY1ezHqjcdVgyQOEzL+wgtSWsi7Gx33wVVOP85tjvfPVOU
	91rTdI1UZtXvQe+FwvMkR+GJByqnAMo=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-9s2RIpeNPomZvXwGvafbyA-1; Fri, 23 Feb 2024 09:00:27 -0500
X-MC-Unique: 9s2RIpeNPomZvXwGvafbyA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1dbf6b00c8cso1458785ad.0
        for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 06:00:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708696824; x=1709301624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eoJldDMvKw/Jo139YUjehPtpro91AmBrg8GEUEOvUtg=;
        b=kOVDAtxON25vxk0gU77nQRO9dQlfJ8MWOrv27d8ebgmvngZEDU3zbjb7PhpxeyO1VB
         2qyviaWAGh2MVNFuGohxGmRkX/3X67Xdzgve3/T/hsJqZ5oEp8hSqbBvE8QiEWJG7wmk
         hignL1B4HYMtwWGaj1d+Yn+pmmywe7LDrQLVIIBMp22eSVP5xW9ckCtJSOZe0S8+qpoo
         zdJwYTX+mIe1+sKO7z3DwSNBT0PoorW6ofi+n7Cx0HdlfR6joV0hi/9FyBc+Qx5F3OHK
         oJvHjsE/1f7et5/0ciVB61kPDT/n+X2A4vfBkw9ciJ8DkLxDi0RTWKQoJZWmyCgW/1ih
         i3GA==
X-Forwarded-Encrypted: i=1; AJvYcCXUzkeBAUyq3LaI6vbk7PLk/m71U06oCvJM19xsiLNNYWVWlkOxSBPlhhJzYxbRI5DZZg/h4vW23wfxDOySFKkPpNDw6/MalLo/bw==
X-Gm-Message-State: AOJu0Yxz46gCDJWtyl8ILacGv7/sagCK+G8QxAU+oja6MCJgukeEWt+c
	N8tkqrARGuz9i87sU+RcLPOXsIgrH63Aq8nlr8n3+v8WpBLnEbqf/SSMLt7iFES/Q8rkrjQNfLP
	YJ4iRR3iWxOgT5SaCuh48eF9VQmB3F4tCBGwJGplxv05BkVsc/mN99Lfb0S2qG8eUzd8IrqmIBz
	gzi0dEj0wNlHP/0CQKVEECeDVlm8Y2NA6oXg==
X-Received: by 2002:a17:902:9a07:b0:1db:6338:63cf with SMTP id v7-20020a1709029a0700b001db633863cfmr1654355plp.49.1708696824623;
        Fri, 23 Feb 2024 06:00:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFG2pdC0Epz6d0vvQWxI+0aZn/vdp1PJ/tEdIUeGgcmSfWFnkVptXG4g7NkDLCKrWCofRa9P6VGB3GVl9eHF2I=
X-Received: by 2002:a17:902:9a07:b0:1db:6338:63cf with SMTP id
 v7-20020a1709029a0700b001db633863cfmr1654307plp.49.1708696823834; Fri, 23 Feb
 2024 06:00:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <20240220153059.11233-5-xni@redhat.com>
 <d87923c7-ec76-e8c1-7420-3d89728c96f5@huaweicloud.com>
In-Reply-To: <d87923c7-ec76-e8c1-7420-3d89728c96f5@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 23 Feb 2024 22:00:12 +0800
Message-ID: <CALTww2_YO=aowddDTr4rP+Y9cuo8LnsM_xVUdBgHbnT5Y2qMiA@mail.gmail.com>
Subject: Re: [PATCH RFC V2 4/4] md/raid5: Don't check crossing reshape when
 reshape hasn't started
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 11:09=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2024/02/20 23:30, Xiao Ni =E5=86=99=E9=81=93:
> > stripe_ahead_of_reshape is used to check if a stripe region cross the
> > reshape position. So first, change the function name to
> > stripe_across_reshape to describe the usage of this function.
> >
> > For reshape backwards, it starts reshape from the end of array and conf=
->
> > reshape_progress is init to raid5_size. During reshape, if previous is =
true
> > (set in make_stripe_request) and max_sector >=3D conf->reshape_progress=
, ios
> > should wait until reshape window moves forward. But ios don't need to w=
ait
> > if max_sector is raid5_size.
> >
> > And put the conditions into the function directly to make understand th=
e
> > codes easily.
> >
> > This can be reproduced easily by lvm2 test shell/lvconvert-raid-reshape=
.sh
> > For dm raid reshape, before starting sync thread, it needs to reload ta=
ble
> > some times. In one time dm raid uses MD_RECOVERY_WAIT to delay reshape =
and
> > it doesn't start sync thread this time. Then one io comes in and it wai=
ts
> > because stripe_ahead_of_reshape returns true because it's a backward
> > reshape and max_sectors > conf->reshape_progress. But the reshape hasn'=
t
> > started. So skip this check when reshape_progress is raid5_size
>
> Like I said before, after following merged patch:
>
> ad39c08186f8 md: Don't register sync_thread for reshape directly

Hi Kuai

The reason I send this patch set is I don't agree the patch 01 of your
patch set. Does the patch (md: Don't register sync_thread for reshape
directly) rely on patch 01 from your patch set? Because your patch 01
only changes one logic and other patches rely on it. So it's the
reason I can't accept the following patches.

Regards
Xiao
>
> You should not see that sync_thread fo reshape is registered while
> MD_RECOVERY_WAIT is set, so this patch should not be needed.
>
> Thanks,
> Kuai
>
> >
> > Fixes: 486f60558607 ("md/raid5: Check all disks in a stripe_head for re=
shape progress")
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/raid5.c | 22 ++++++++++------------
> >   1 file changed, 10 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 8497880135ee..4c71df4e2370 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -5832,17 +5832,12 @@ static bool ahead_of_reshape(struct mddev *mdde=
v, sector_t sector,
> >                                         sector >=3D reshape_sector;
> >   }
> >
> > -static bool range_ahead_of_reshape(struct mddev *mddev, sector_t min,
> > -                                sector_t max, sector_t reshape_sector)
> > -{
> > -     return mddev->reshape_backwards ? max < reshape_sector :
> > -                                       min >=3D reshape_sector;
> > -}
> > -
> > -static bool stripe_ahead_of_reshape(struct mddev *mddev, struct r5conf=
 *conf,
> > +static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int =
raid_disks);
> > +static bool stripe_across_reshape(struct mddev *mddev, struct r5conf *=
conf,
> >                                   struct stripe_head *sh)
> >   {
> >       sector_t max_sector =3D 0, min_sector =3D MaxSector;
> > +     sector_t reshape_pos =3D 0;
> >       bool ret =3D false;
> >       int dd_idx;
> >
> > @@ -5856,9 +5851,12 @@ static bool stripe_ahead_of_reshape(struct mddev=
 *mddev, struct r5conf *conf,
> >
> >       spin_lock_irq(&conf->device_lock);
> >
> > -     if (!range_ahead_of_reshape(mddev, min_sector, max_sector,
> > -                                  conf->reshape_progress))
> > -             /* mismatch, need to try again */
> > +     reshape_pos =3D conf->reshape_progress;
> > +     if (mddev->reshape_backwards) {
> > +             if (max_sector >=3D reshape_pos &&
> > +                 reshape_pos !=3D raid5_size(mddev, 0, 0))
> > +                     ret =3D true;
> > +     } else if (min_sector < reshape_pos)
> >               ret =3D true;
> >
> >       spin_unlock_irq(&conf->device_lock);
> > @@ -5969,7 +5967,7 @@ static enum stripe_result make_stripe_request(str=
uct mddev *mddev,
> >       }
> >
> >       if (unlikely(previous) &&
> > -         stripe_ahead_of_reshape(mddev, conf, sh)) {
> > +         stripe_across_reshape(mddev, conf, sh)) {
> >               /*
> >                * Expansion moved on while waiting for a stripe.
> >                * Expansion could still move past after this
> >
>

