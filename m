Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771D533D6EA
	for <linux-raid@vger.kernel.org>; Tue,  8 Sep 2026 04:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788842524; cv=pass; b=uzMdf8Jp6fqh653CPC7IxLoaqKeuEpDAQSKL4C4jzD27aVBZHBMNU/MbO1Al4Prjo2A0gmc8YQVrp6eFW0fKgExteNgS1wIZysCWGlMe5159gp4UmnZNxr+oyGI74xtN1nl9qXxAT/LGolqc9f74K6IypJDL4Ot15w2Z1z1ityg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788842524; c=relaxed/simple;
	bh=f1XqeoAEip/DeuKd9XScQmPGW2xcgntQWIHluZz8cS8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HaQJnAtb2DTb7BLei4UTJEZhs4bXRLwHDZtYC3nlFP1YaVIPbqbKpX4wLVAaKqMEj7ZvllUNyXeYsSZGlAYAtORNXww73Mpu30QT9arx6VoURXy///xD6ex5td+Cd3OcNaPf7MHBHaBTgD4Ch6De6Qci7lwVlfRoR+iS4JLI+S4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=Z5RQuP3r; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Z5RQuP3r"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c25331b31e8so53220066b.2
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 21:42:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788842519; cv=none;
        d=google.com; s=arc-20260327;
        b=XrO8OIQSnAhEA1PoMUh3ZJhsgN7OEhuXmIZBn/siozUHrFytvP20242awXvnHawvGi
         QOmm8npfJQ2q2ePo9vSXAzOTi8CXYEoccee81U88fXyvDpMzfxpUyiWiLtVA7I8gfc3t
         30Jn/20sMNfZ6yqL/Ssq6kPP6fdIx7yBGIHwHX9jPvzCXLiUC2nl8uyYB8yXmL0cXPoY
         Shh408sOJ7dzB5ifouUTb+GFwqlXZL9oh24BbmHIa8pqxnlVNcOCO2qlw6KMXAylTf3R
         9zYTGJmEjpicdTRciiMSCRpKJH/k2IEkp7K3pVoHnaFTcgw7K7Z6fi/IOODKIU91Bijp
         oXEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ue0jLKQ+Hf10sAp2yxQnkGsowZkX0lyRhEiw2uRiGi8=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=ML7JXNK021evkT099VpSN88C9gnJDXYhuV/NEgGzVUQZLvwXll2jwqud7zCdeSgYK9
         oeBkrjV5kiCZ0uDDDiAp0DspRGafu6hHxRsq0e9KaKANJxhfG/VvzaiU55zwNU3PKp3c
         WlzI79zkOGQTDgZKg0FNRKBmu3+RQPiP94wcXWPzYKbZPxV5VqayMb/se6btz19tiDQH
         nOlzLJegC5T7so7n8DeI/HWMy+vxbqUlGJ1gya1mDxxkxNFEt12mvUJb5ZUcWgy2iR1P
         1x9SYJTDiN98BlT8H8KCINSryMkMxdEC51IWfcpfzoMXu6nTFhd/iKDviTos5/32F3M7
         he2A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1788842519; x=1789447319; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ue0jLKQ+Hf10sAp2yxQnkGsowZkX0lyRhEiw2uRiGi8=;
        b=Z5RQuP3rbjOMU7kSy37ETYuwFRiDPn1afsei7HV0BUoCjjMwi0vdqfBjM0TkcPLIMP
         HxCnFGqWuayI74Izaxp5sfglR3Vhwo4xvtJMUiW455zHg7IzUs7QUbXugpZjduJv4M+M
         Sl6Q1odPqFg90JD/oRmxfNGfjwQRm+bcGv1QmodRyLGUaX83eL2M0McbjVKqwxjhlCGx
         jB0ndY7S1pj7m8c3XKSL3vgCaIjfPjoma0hvARW78azdy11Ezq4QqWvdPJOI5apH0a5l
         ssrkkRCxbcH3Z4diz5jZyGlOkt5D+6ybEa093q+sY5J5tqV6Nn+JhprLSIC3RAaUqbSN
         1u2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788842519; x=1789447319;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ue0jLKQ+Hf10sAp2yxQnkGsowZkX0lyRhEiw2uRiGi8=;
        b=YZsN/FMJ3aisjJD4hqFTJYMdn/zdGxQaRUPy8QhElLYW92J98LjjRHRDuDA+25LR3x
         83aRduDo291VUt8VXjSNpNuUadHhb4Jbx/4Fe6Oh2ccjZEZym35jO0CwdCT4vwlcb+vF
         JHZS5vPlyd0ol8A985VO0KAlYDSgDQwrgWnTIZthT56sbvt8I7cUc5mWToOxs5Kl9a00
         hZOe3J/eMQ29jj2o3FoV+vm1s3Dx1eNdM11Bs7SzadZYcaf2CDTIpCAWR6tgjU15OTw1
         /Oe1C7WZy705gQxK8t6ZMsH0mbSnuSSW5dFcnXRLpY8R2mwT1xd5JtxNX4hybsgNZZuM
         ygbQ==
X-Gm-Message-State: AFuF++lO2VmfXpK8038PaAQfelHHdS8HUjG2tAl9+N6U6GLb27nWRaHi
	Hcjurs4ZfekMCdZGmQ9FJo8yVSgwhcgPDLPNWEWGBkDiMs+I19GNC5O6luFFMq9kAlQ8qCuWF2u
	9+VbyeZigq+xpbx7ccJjMybxGbJyfcD0sZT6oK9p0yK72kYzJ/yZsaBA=
X-Gm-Gg: AYBFou1LUy16jz6DSJnq7Wp8Dw1ol+QsGFmRCArlK1DmZ7suENI8VcNuVSD9U6hRW5K
	h5yyiSGVgKXoLHSrKyEPMmy0ZzicYlEA/xh+ZOXFhB1sDMB/2jNelFGBht0jVaw7yIPS9C33VVj
	LPih1+qf/J2kUbj9WcWzVlrJS8i/STCoJtpR/2gm0WkLfAfGFYKp7BLLV82VXkUFYmit90v0D2q
	koYPF5fu/OqygioGuWNzevxgCCWa9tJ2bF8Z2RxI447dQT1vb7CSOgoHTZ0cNhFwKP9LghBbO+o
	POsU2OyaXtKE96z2RZDwYArXJ4F++clA9cx0eD/qFTi74ebBTArltPVgTwUOvSkrl+Mjuqxfd9P
	/Cw==
X-Received: by 2002:a17:907:1c24:b0:c12:6db4:4bf4 with SMTP id
 a640c23a62f3a-c2624cfedbemr665568666b.0.1788842519398; Mon, 07 Sep 2026
 21:41:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
 <20260907133929.1081540-4-jinpu.wang@ionos.com> <20260907135639.E94091F00A3F@smtp.kernel.org>
In-Reply-To: <20260907135639.E94091F00A3F@smtp.kernel.org>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Tue, 8 Sep 2026 06:41:47 +0200
X-Gm-Features: AcwNN1U9WnkAtjej4J11dl3FcyV5-KnldfWFEEgJbRa0FZLwPFjZ_6PMto2EQHw
Message-ID: <CAMGffEnqEZhZuVJc4vBG6fzDiFBbwx3w0Dv_UEqeS+_80f3eXw@mail.gmail.com>
Subject: Re: [PATCH 3/6] md: don't wait for q->limits_lock in check_sb_changes()
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 3:56=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] The return value of queue_limits_commit_update() is ignored, all=
owing a disk to be permanently added to the array even if its queue limits =
are rejected.
will fix in newer version
> --
>
> commit 9dfb5955d3bac2bdadfd9671f084d71c343b76e2
> Author: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> md: don't wait for q->limits_lock in check_sb_changes()
>
> This patch updates check_sb_changes() to use a non-blocking trylock when
> stacking queue limits for a newly added spare. If the lock is acquired, t=
he
> limits are stacked inline to avoid blocking on I/O while holding the
> reconfig_mutex.
>
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> [ ... ]
> > @@ -10885,7 +10900,24 @@ static void check_sb_changes(struct mddev *mdd=
ev, struct md_rdev *rdev)
> [ ... ]
> >                                       rdev2->saved_raid_disk =3D -1;
> >                               else
> >                                       rdev2->saved_raid_disk =3D role;
> > -                             ret =3D remove_and_add_spares(mddev, rdev=
2, NULL);
> > +                             /*
> > +                              * reconfig_mutex is held, so don't wait =
for
> > +                              * q->limits_lock; MD_RECOVERY_NEEDED bel=
ow
> > +                              * leaves a skipped add to md_start_sync(=
).
> > +                              */
> > +                             if (mddev_stack_limits_trylock(mddev, &li=
m)) {
> > +                                     struct request_queue *q =3D
> > +                                             mddev->gendisk->queue;
> > +
> > +                                     ret =3D remove_and_add_spares(mdd=
ev,
> > +                                                                 rdev2=
, &lim);
> > +                                     queue_limits_commit_update(q, &li=
m);
>
> [Severity: High]
> Is it safe to ignore the return value of queue_limits_commit_update() her=
e?
>
> If blk_validate_limits() fails inside queue_limits_commit_update(), it re=
turns
> an error and the limits are not applied. Because the return value is igno=
red
> here, the disk could still be permanently added to the array even if its =
queue
> limits (such as incompatible integrity profiles or alignments) were rejec=
ted.
>
> Previously, a failure when committing limits would abort the disk additio=
n
> (for example, in mddev_stack_new_rdev()). Does splitting the limit stacki=
ng
> from the commit and dropping the return value bypass this safety check?
>
> > +                             } else if (mddev_is_dm(mddev)) {
> > +                                     ret =3D remove_and_add_spares(mdd=
ev,
> > +                                                                 rdev2=
, NULL);
> > +                             } else {
> > +                                     ret =3D remove_spares(mddev, rdev=
2);
> > +                             }
> >                               pr_info("Activated spare: %pg\n",
> >                                       rdev2->bdev);
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907133929.10=
81540-1-jinpu.wang@ionos.com?part=3D3
