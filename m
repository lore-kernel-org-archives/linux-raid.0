Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F0F20E32F
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 07:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748591857; cv=none; b=QfZC+Ahy4ymXwWuyJnWQOg5LsxjyFdZ92F+8xU0q/1VoHFhb/vyosv3Uw9GNwg2LM5ifqKMfwYq1Xn3fMt5wFduihfnrzZ2H/8S6g1qUzV6AcEaEnp7zru7XlywQtyLx5hK1ZG5VCtMILlGlDyHpx9XXbSNfLFRMZKRn3jcBNQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748591857; c=relaxed/simple;
	bh=jOm7BmhHIOtGfRyInt8lJq/imoavKPUtk6+kNEG2f4Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U022nj1BQky89Elo/G8dx7W41aB5RvqqZBC1FJz/StgCoIp02ICJKaTYAJ+f+XAzX+HG9AjZa+Nw0HOEzZtAa8iZUBgjmSFipXy8//urClAPP/8m8nZZK3rq7j4QJElJL6dWzTkE+1r64HEAO5SKnWQMd5xMCAb+/Jqqs8/c1aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FMk5nad3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FMk5nad3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748591854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UyjvQ7ON4hurQSDJyB6MU9v6W/AwJltTZo2cVtIw3e8=;
	b=FMk5nad3AVkYhZ9/MDRYEiPYgsEcu1kTToH9G5pW/r32TF76KzL2BSyeKPhj3kQPOCN3gh
	ZjxoSzKpb2yl8b7NCqUtcBfEOrFy1XBEHFlSvpJ6yJGYkpIyrOTyj6bcA4nCyUOZd+nw1r
	VfqUDgYuCWsMl/UUuPpHj2Sti/ZiYZg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-sNHBNS_kPvabrTjNVlN_pg-1; Fri, 30 May 2025 03:57:33 -0400
X-MC-Unique: sNHBNS_kPvabrTjNVlN_pg-1
X-Mimecast-MFC-AGG-ID: sNHBNS_kPvabrTjNVlN_pg_1748591852
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-30d8365667cso11892141fa.1
        for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 00:57:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748591852; x=1749196652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UyjvQ7ON4hurQSDJyB6MU9v6W/AwJltTZo2cVtIw3e8=;
        b=HcC70POL5pMeONyykj+TI+G7kUY6hVp7rocGBnc0rWgC/8IPhgmxG4vk+Q4q8CeRVA
         RpPXwF6Dp1mKDl74V+x4YPkLwvXXWjKHgeIVjrNyxGaCB1c3lAiCKn+rrHcDTn0fo/l8
         ZFh+GABqPq6/5L/cVN/WwDDZ9gaeM/bVHAiME2veKGlacO060KOmD/sCoDEEYpSoL4gW
         /2FehdbE33lHT51RNspxS3vDLkKqnlyr7mwmquLyrwiqkZMtegUv6LKcnI0ClZ19t9J7
         +WqW4hpEcPyhYnpeZkMPyPTRIziUAvPbLdOT/W5e73E4pr1EZX+LRlbD3tLjiYlQjB1N
         GWFg==
X-Gm-Message-State: AOJu0YyP9NWIvMDEjtp+ErCTVrBzo8366ZMsgMqlPQ4/GnZAim3UydG5
	wJ7mdFvCFMoOF6wTeoEV6ks5sQzHl7zyXyf6imaTSTUe/G5wQIJTUBJkHbkRcUN4xLck0Ok2Bpy
	80WwM5gsT7EjlxI4FCZjifKOWCJ3cVNTGVYQ1pHLzmw6CF+OD11wkCUmR3ElPCsqD2UTXo9hC8T
	BeNFMBaAoaqP6lH1qMsbYRWy/PKKqm9u/854H6sQ==
X-Gm-Gg: ASbGncvJIlLC44GyiP6A3xM3USLSavP5uJl9wcP5DssCBWWMLTC0CCaNluwm1Z5WB47
	VO6eKxwoXAXgpRRxSIb4VacrxPDGpjJ1tjcxX0d7LwFrHCXaePTX6uYM1ggI+v9q0LgZ3AQ==
X-Received: by 2002:a2e:be21:0:b0:30b:d17b:269a with SMTP id 38308e7fff4ca-32a8cd3b6admr7341501fa.7.1748591851621;
        Fri, 30 May 2025 00:57:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHvrdIMNbN5PqjUgIyKtzAPEHAl5jzKHem4/sYgAPjcouK78ZOHgFeHeFc+kXhpnQ+GzUygv6gFvQDKhyoKgFE=
X-Received: by 2002:a2e:be21:0:b0:30b:d17b:269a with SMTP id
 38308e7fff4ca-32a8cd3b6admr7341411fa.7.1748591851192; Fri, 30 May 2025
 00:57:31 -0700 (PDT)
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
Date: Fri, 30 May 2025 15:57:18 +0800
X-Gm-Features: AX0GCFtazZCPIF4Q8hqBdZ34nksVTA-VJM0CbaDd3SqjWWX7bGpSaCTZXEUn1Ow
Message-ID: <CALTww29Q+GiCW3BNQak3BvYD5EWZXQE41P4Tz8H9Kq1dPoDyVA@mail.gmail.com>
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

Hi Kuai

The first patch isn't used to resolve the problem that /dev/md0 can't
be removed. So it's not useful to merge itself. I'll send all patches
in v2, so please remove it from this PR.

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

