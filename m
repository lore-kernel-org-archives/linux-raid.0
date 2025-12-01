Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591EE31619C
	for <linux-raid@vger.kernel.org>; Mon,  1 Dec 2025 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764610172; cv=none; b=gpdvwRldVxKsDUsqGwfKxuXmVIDbsWxDT4PwmVzyhBGLjFdMlatDCEtJHCOt6WNwanCTDfZk6gMWCg4BYDlXfO7gcmMUCJit0RwoiWy9wYdxE7J4//lqwR2EnZrMl3CpNJXQ/rGJCJ4yNRXXqrhUpwSjZywqQe3Hdh+TeFqMpfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764610172; c=relaxed/simple;
	bh=1XF4sGasc+EhbCDZPiAFKcYYt7VYFXu9HvmmGuhW9Ns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZahX3SePhuO5izTyO/KFMUmdI1DPkYmwbNJOl+f31lnavcYnq7tuCIt5bNXXwzeg7FCkGyoBOcuCAkaOW9JYY1xnCfeMx4ywtfvNcEjjLrafZ0RdkIroO4nQbFFLYhZpP8lMqSZL861zO80WdZRJ1X5v1ZT444R7yKMdINifUl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=YUDJrZnR; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="YUDJrZnR"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6417313bddaso7145125a12.3
        for <linux-raid@vger.kernel.org>; Mon, 01 Dec 2025 09:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764610169; x=1765214969; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=botBZfS2t5PMgME695nyRVlb/1VmFmEmJKJoWEZMTDE=;
        b=YUDJrZnR8nlpRqIL+GXF6Z7ur6veEgFvVkDkYNZ40yVvVAlLHUdIVTAc5JfTiMVoz0
         HebGJZ8UZt5Ry3TA1vum7GB8s7s1I9l7yeWE2SSx5OhdK5d953/QFDZgjhfP2aYOuEjF
         iL0HHdDgyml8p3Umqkff+sxnTOKCE4VTPRpZAYoLpQlJY2UoxlxZoQ9ztWUdT4m9eEyu
         m9cwVEQJrmT96bnImAMH2NdNNO97XfhEAOLjSLSSVvZbK6MFpyA9N1TrizPZOooG3sdO
         Y/yYneGhUPFgj4zhOxoQ9TNwdGUiwpVFk/QpnmOaXJNqyLF2KiycZc9pdpBFBLHAdIXn
         qEXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764610169; x=1765214969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=botBZfS2t5PMgME695nyRVlb/1VmFmEmJKJoWEZMTDE=;
        b=v9evFA55nhaCiFItVLRpoa/r03nKZT1sP3bg8G/gnFPF/JGfCpjouER0lQZqSTWlYc
         T2OqFq0juhoz1PROq02Ws8GEq8W7UVzlLUmNGlfrLzHucHzN8RKLIegZxvl7MbZvJVFZ
         QUbST7XaUxaPG+JP+94kz2mQgxrFaOF94ysMh6YufNDBXeTBgWh9Ixzwo2jCd2ey4Xn1
         WxsWpNU3VQh0weLQFirpIaWb1uR71j3rceHVWVcmYNJnbozdqITh2GZivKmK4d2pFkpL
         E2xP2Vvx+MUrlS44NFCK6TBNHR+cDp2RO4X3KIUtboC6Ya6fCNVzpdfgkSVotBX7o1ef
         lp7A==
X-Forwarded-Encrypted: i=1; AJvYcCVg0CgLr8l+jdQw4dMOFVKTV9GjXrPJClJZRqWPAgG/qf5y5iS8GvG4mW3QH3q05alGWm0xP72f3wcX@vger.kernel.org
X-Gm-Message-State: AOJu0YyZIWlIrintcesb/VuqcH56KvkbQQgvHDOZ5oYlOgmwHC3+p/YX
	RtWGe16WOGjZRgNR+diE1zePWo2ZAzZF/Yf/52q2btThsU4fFUuUM5IF51hHbNwYke9C24BNbuq
	RJnTx9be12KN2K13YcDvOF/ZMo3hPUv4i4UZ7g/n9+9dMBigAPRCS
X-Gm-Gg: ASbGncseMVURdDt5NAaJh8fhu+hstn6euRj3+cOFsvL2cmGs5+tsjiD6hiS5i9tPlh7
	wwd1z9hxQERGOcfGI+7l7Rn3mG215sttMN4vrVquMdSo3YzY7AJtENypLL5oW+BSfd1AVkqpWTO
	p6CaYG1wZ8tU/kNi9pMT27mMFSsUiAtCgXln219AGyO0+Fh/MNuE9JvN6BEX3mOCXDsZhO+d61Q
	RgED7fiAU25ZCwpKeTtGxAhtc6rwA6Vd/HdwK30jZecjvc3mal/dqkFdeKPEdpzDPcs
X-Google-Smtp-Source: AGHT+IEonAoHpMMw69ILk5izdQTgY0KESHpESPx6NQAkAf0GvWrIYTTNVlFQ6Aj81H47IPobVV7oT60jRjxSMEP5+rA=
X-Received: by 2002:a05:6402:5253:b0:63b:feb1:3288 with SMTP id
 4fb4d7f45d1cf-645eb7867d6mr23749098a12.25.1764610168487; Mon, 01 Dec 2025
 09:29:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251121191422.2758555-1-tarunsahu@google.com> <a5066e6e-40ec-4c58-a60d-55510191bf27@fnnas.com>
In-Reply-To: <a5066e6e-40ec-4c58-a60d-55510191bf27@fnnas.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 1 Dec 2025 12:28:52 -0500
X-Gm-Features: AWmQ_bl5IvZWjRP7WOEBGs4H1jh4S0Zck379mafFl_drFZmAnSKs7zZ8P9FOUiY
Message-ID: <CA+CK2bAdR06ZtU7XLjZvyRGG4h_sUqnA+75YqotoPRGcJ7+65w@mail.gmail.com>
Subject: Re: [RFC PATCH v2] md: remove legacy 1s delay in md_notify_reboot
To: yukuai@fnnas.com
Cc: Tarun Sahu <tarunsahu@google.com>, linux-raid@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, song@kernel.org, 
	berrange@redhat.com, neil@brown.name, hch@lst.de, mclapinski@google.com, 
	khazhy@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 29, 2025 at 8:58=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> =E5=9C=A8 2025/11/22 3:14, Tarun Sahu =E5=86=99=E9=81=93:
>
> > During system shutdown, the md driver registered notifier function
> > (md_notify_reboot) currently imposes a hardcoded one-second delay.
> >
> > This delay was introduced approximately 23 years ago and was likely
> > necessary for the hardware generation of that time. Proposing this
> > patch to make sure there are no known devices that need this delay.
> >
> > Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> > ---
> > v2:
> >       Added linux-scsi mailing list
> >
> >   drivers/md/md.c | 11 -----------
> >   1 file changed, 11 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index b086cbf24086..66c4d66b4b86 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -9704,7 +9704,6 @@ static int md_notify_reboot(struct notifier_block=
 *this,
> >                           unsigned long code, void *x)
> >   {
> >       struct mddev *mddev;
> > -     int need_delay =3D 0;
> >
> >       spin_lock(&all_mddevs_lock);
> >       list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
> > @@ -9718,21 +9717,11 @@ static int md_notify_reboot(struct notifier_blo=
ck *this,
> >                               mddev->safemode =3D 2;
> >                       mddev_unlock(mddev);
> >               }
> > -             need_delay =3D 1;
> >               spin_lock(&all_mddevs_lock);
> >               mddev_put_locked(mddev);
> >       }
> >       spin_unlock(&all_mddevs_lock);
> >
> > -     /*
> > -      * certain more exotic SCSI devices are known to be
> > -      * volatile wrt too early system reboots. While the
> > -      * right place to handle this issue is the given
> > -      * driver, we do want to have a safe RAID driver ...
> > -      */
> > -     if (need_delay)
> > -             msleep(1000);
> > -
> >       return NOTIFY_DONE;
> >   }
> >
>
> Applied to md-6.19

Awesome, thanks.

Pasha
