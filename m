Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03912123CD
	for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 17:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731433357; cv=none; b=YHLA/fqVYeHZwcDNwJpc45Wl1yaA7E2VIj3bQjOYEJ+FdKdywHFZDowvi9yp2gisoxgP8hgzt2LzsS+oMkCHRqi85V/0Cjvioppfpkj/sAFJa8KuCNZWt3h2fgAOyE4rKiWfKHSukBFt+GyXtaN/ziB5SjvzRMo6qjh0bJD/GNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731433357; c=relaxed/simple;
	bh=t1xjc/W8nzq35iRGf1j5ZjpZ/MwhmgktkLBIBKyBM/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O96Hs3OSEdiiQP9YVrMAlS4wtIFBp1lI8T1g+ZWDRGMN/BvIFCPZMfg/Fnhk/VivGC8gljZex9L7xl7zQ9Maj1qOoT+QsmwgIAdLHRD2/ZAkP9Nkc7BTy+ZuSXsKN+KbMXgVWsrWcUHb727mo9LnVWKGiujkCIfW3Flfw6mp3Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJYXDnqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJYXDnqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F97C4CED4
	for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 17:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731433355;
	bh=t1xjc/W8nzq35iRGf1j5ZjpZ/MwhmgktkLBIBKyBM/s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GJYXDnqi3MX3TNtLISVOTh32qvDeomj2HxK1vPsMQyWV23oYRIQRm72YNatpuRC84
	 ss3CxZ8Pn1MjgciZyTGX48Bts+xJ52WTT2gBespGf4HEokmPvfKMQTv1MhTZ7sUOYX
	 p4x/esJJcrdkLvE2MzzQDUSPkTUIeSeqiv76uqJ3czZOFcgCrXNi8fFjklu33m7g7m
	 GmRams25oIfwowYxDaL2ZsQUaANe/t6s11OKFMiVFXhHHeibVt6lyrF020b5ayriOT
	 KSzVyRGx5swa57EEDoDI8iWLV+b2TKV4q07o0wCUD1JCsQfVgB6lyOPhmvQWD3PPb+
	 Y2UmFADQKPJPg==
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83b83f83b63so198153439f.1
        for <linux-raid@vger.kernel.org>; Tue, 12 Nov 2024 09:42:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXNbOjkkUt0g0Bk4QVuNepsmxdhyx/Zq+O9re7Ue7o7kwDOxgOSPaFD/QMyLXdy+cuFnQEaH2Ddt2nh@vger.kernel.org
X-Gm-Message-State: AOJu0YwBLGIaHxT9o7n96ucVbe8jFIrTEBvMZ5jvX0NvW7OSoLPujDKj
	fyNL+uQXe5mRP62ZZUOk77AQl2DJmt94v/GYENFr4ZxyymvS1TII+jBEnleLacZbo1zwtVk8NYH
	JhWAcY1yxsyIuAaWziFJl/6CsXyc=
X-Google-Smtp-Source: AGHT+IFRCaH+LZRAfiwtSQW3rYVeimZ4ydtRhvlc046EptEAwArAokPk5y0LzyYfIU2PKt2wOQXBe/8x9g0sRDPvmm8=
X-Received: by 2002:a05:6e02:b4b:b0:3a6:e960:ef9b with SMTP id
 e9e14a558f8ab-3a6f24b0f33mr162568655ab.4.1731433354689; Tue, 12 Nov 2024
 09:42:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112161019.4154616-1-john.g.garry@oracle.com> <20241112161019.4154616-2-john.g.garry@oracle.com>
In-Reply-To: <20241112161019.4154616-2-john.g.garry@oracle.com>
From: Song Liu <song@kernel.org>
Date: Tue, 12 Nov 2024 09:42:23 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4JstsuyDnXfWuDocr+uVfq72SnmF82f-6KBy2tu3-XOQ@mail.gmail.com>
Message-ID: <CAPhsuW4JstsuyDnXfWuDocr+uVfq72SnmF82f-6KBy2tu3-XOQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid5: Increase r5conf.cache_name size
To: John Garry <john.g.garry@oracle.com>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 8:10=E2=80=AFAM John Garry <john.g.garry@oracle.com=
> wrote:
>
> For compiling with W=3D1, the following warning can be seen:
>
> drivers/md/raid5.c: In function =E2=80=98setup_conf=E2=80=99:
> drivers/md/raid5.c:2423:12: error: =E2=80=98%s=E2=80=99 directive output =
may be truncated writing up to 31 bytes into a region of size between 16 an=
d 26 [-Werror=3Dformat-truncation=3D]
>     "raid%d-%s", conf->level, mdname(conf->mddev));
>             ^~
> drivers/md/raid5.c:2422:3: note: =E2=80=98snprintf=E2=80=99 output betwee=
n 7 and 48 bytes into a destination of size 32

This is a bit confusing. Does this mean we actually need 48 bytes?
I played with it myself, and 38 bytes is indeed enough to silent the
warning. With 38 bytes, we have 4 bytes hole right behind
cache_name, so I am thinking we should just use 40.

WDYT?

Thanks,
Song

>    snprintf(conf->cache_name[0], namelen,
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     "raid%d-%s", conf->level, mdname(conf->mddev));
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
>
> Increase the array size to avoid this warning.
>
> Signed-off-by: John Garry <john.g.garry@oracle.com>

[...]
