Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B0831ED66
	for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 12:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766666104; cv=none; b=nlCfEhHrk5jqG6VrFkdZuVBv1le3oaSrVEEWv1DaMQRb3R1Y3hg7tqZhHvhLLa/axBsYKvNzGDjbozyoFTtQnNU4CIEifSoWM82xPoXZpo3584yexNy9Hq7tXZlIIn/FbKkOg28+YSeVnTN/zIMN3MWTldfXlb1bN2UoGaNZT5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766666104; c=relaxed/simple;
	bh=2BKCRDYh5sQo5onnP5k2VYrfZUcMH7XhdnpgXXiCIrY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F9oLxPB9VI/HikvIba79WWovna6a3MqfNw2uR+s2HwEjwiSxd/AhvdbY5DKSi4iV+EN+Bgp4GKIcoIrp/dqbepO1gE2BKTjeV0Bpx/C6TLi/GFYGXg+xbQc4W97BaNCOjMXo66qAC2b7THzPlIMKWxWWwSZ84hALe2eNcO0sYP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b1PTBs28; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b1PTBs28"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a12ebe4b74so115759115ad.0
        for <linux-raid@vger.kernel.org>; Thu, 25 Dec 2025 04:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766666101; x=1767270901; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0/DzbC/iwvk/KNNxhuzvGkny2DEDxz/+yKXfojccH8=;
        b=b1PTBs28ihpDymPO4eXtRvPvcI6F7BHcHMBZj2kfYQr57yfxwLvA1iX3cK+Kd0dliJ
         aNT6pPQFzbWB0HE5P1ZJhX+m6XKS9XodYLeKg4EoheXtDPeGfveE9aXj6sbJjM9BAVcQ
         oagWsrV946Sg8McfEv7K903I+jbEUrpobsOG2Ovrbn60oKv7WRzI0HxLZkLvkTdy5OB+
         kEtU/vIYWDkeqobmZzhQJLLuJlSZXscQqOP4bAePwR/Cv95Ju0wT3Uv9QtsXVaY32KIy
         ZMlvfWEtQvU9VJm4rv7Vqpcqvt8lwDyd5VESpphykILuY+ByglOx3lucXVL3+6R0LV5E
         Rrhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766666101; x=1767270901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M0/DzbC/iwvk/KNNxhuzvGkny2DEDxz/+yKXfojccH8=;
        b=pthUO38p/1ya7ZGON+DKbXncljPhMX/z2gmOyrgOgcPNOcM4mnMMdj6lFGGzSJptb4
         /YGDkZl2nHFv4PaMpGDumP3cs/WUTbBYaccrVGiwfumd8xUZu97zEqWPLlLUnYGCpH93
         tcIrKMuL9vtxvhFVpMe2Q1bNN9eGIB34VLJ01xj1spEupGNIcDEOXLXx7m663UaUfduy
         0ARVxoGN/QgRdvUrptDsIsymluzHbuV9GL4Z3/g6gD6RnG3woR1Noa2NkyGuXSPS94He
         OiK3sUboDGkDe7O3rLAZftFfgmC4zoDYlHVnldnqUFrKjOgqL9IAXnZzoQEfNV2zoUT2
         T8dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsjxhWNKAjp6YeLPlBdvAkKdqeTCg0dA8rLdQieRPsnZdU5edgLch4/ae8SCtmqcqICEatVlraKeBl@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw5YjxYoDWwId+pKanHAgL/oYYpfx/2yJvzQ0Kv7OldVrM3Sbk
	DfecLKImhHtLW8ba/NJ93+uOsAIwNOGbN5tiWd/7M9dMnfErsH/HRheTtTSP9oj3MVORniWTEpK
	PtKj+bJqax+pZbGkFuIPUmOtAlQxGK4qX5VSN0aEcAw==
X-Gm-Gg: AY/fxX6pincbzo+MEPOPmd05KckNhs37m+NS9T+3ObID8Oxcc3oRrG4WeT77tf+BqEd
	/QtyBXq+E+snCkWxAJbskAxvCpPdpzgAJN7DeD0KEdQzsIZxwSvh4X6iHDG4K6Rm4NMGREvsh2F
	FTKaN43a5k+mMu436LcOmNaEG4vlmfRN28ch0wT6F4+le4IgnKhBB1PgruFrFl9JITc5ort8Z2V
	paoA7uGB/mfQ+zpuV5TwElf/Mc7UbyYtB/+jqButVU0VAM6fgJpBphEVOzsD6g+Gz6BRFU=
X-Google-Smtp-Source: AGHT+IG4KeQFYp5Th2Dgmzw9rbyC5CVFyBOUskmsxsVe/icnmOMvI0NzhtXjCtEdUxE/WbQv3S2m8Jxxtbzq3yvMtrY=
X-Received: by 2002:a05:7022:618d:b0:11a:49bd:be28 with SMTP id
 a92af1059eb24-121722a7da4mr23990372c88.4.1766666100829; Thu, 25 Dec 2025
 04:35:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251210074112.3975053-1-islituo@gmail.com> <55938698-697e-4c2b-b5dc-ea5aff359567@fnnas.com>
In-Reply-To: <55938698-697e-4c2b-b5dc-ea5aff359567@fnnas.com>
From: Tuo Li <islituo@gmail.com>
Date: Thu, 25 Dec 2025 20:34:42 +0800
X-Gm-Features: AQt7F2pgnLaFB2rJFBJbHSrGmbTS4NfJ6t-MnZsh3Wm4TQNP-VkQy05KDg62xP8
Message-ID: <CADm8TekmvebrapiVCUA8D7tJPdDBGG1cS4sV0-ymqMHNG4JnSA@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: fix possible null-pointer dereferences in raid5_store_group_thread_cnt()
To: yukuai@fnnas.com
Cc: song@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai,

On Thu, Dec 25, 2025 at 3:40=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2025/12/10 15:41, Tuo Li =E5=86=99=E9=81=93:
> > The variable mddev->private is first assigned to conf and then checked:
> >
> >    conf =3D mddev->private;
> >    if (!conf) ...
> >
> > If conf is NULL, then mddev->private is also NULL. However, the functio=
n
> > does not return at this point, and raid5_quiesce() is later called with
> > mddev as the argument. Inside raid5_quiesce(), mddev->private is again
> > assigned to conf, which is then dereferenced in multiple places, for
> > example:
> >
> >    conf->quiesce =3D 0;
> >    wake_up(&conf->wait_for_quiescent);
> >    ...
> >
> > This can lead to several null-pointer dereferences.
> >
> > To fix these issues, the function should unlock mddev and return early =
when
> > conf is NULL, following the pattern in raid5_change_consistency_policy(=
).
> >
> > Signed-off-by: Tuo Li <islituo@gmail.com>
> > ---
> >   drivers/md/raid5.c | 7 ++++---
> >   1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index e57ce3295292..be3f9a127212 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -7190,9 +7190,10 @@ raid5_store_group_thread_cnt(struct mddev *mddev=
, const char *page, size_t len)
> >       raid5_quiesce(mddev, true);
> >
> >       conf =3D mddev->private;
> > -     if (!conf)
> > -             err =3D -ENODEV;
> > -     else if (new !=3D conf->worker_cnt_per_group) {
> > +     if (!conf) {
> > +             mddev_unlock_and_resume(mddev);
> > +             return -ENODEV;
>
> +CC Xiao
>
> This is still wrong, please add the NULL check and return early before ra=
id5_quise().
> And also add a fix tag:
>
> fa1944bbe622 md/raid5: Wait sync io to finish before changing group cnt
>
> > +     } else if (new !=3D conf->worker_cnt_per_group) {
> >               old_groups =3D conf->worker_groups;
> >               if (old_groups)
> >                       flush_workqueue(raid5_wq);
>
> --
> Thansk,
> Kuai

Thanks for your reply!
I=E2=80=99ll prepare and submit a v2 patch shortly following your advice.

Sincerely,
Tuo
