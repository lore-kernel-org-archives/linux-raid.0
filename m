Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D3255C1AA
	for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789653532; cv=none; b=QD0BpatMi1MipeT+XAnaatY0M6qKfrhrLdph4/Dnl30Yp22YYFGRPkTAdmFPxYpePZjmMAZLI4dakaplubwe95DipHBHvzJl6yRlCXyHUT3pehJJhtOiAKeqejkwVGXHp34PppZrJ894DPIQpW7xUzE6fvgtmBUX9xVRY7k3mq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789653532; c=relaxed/simple;
	bh=bCFpQtachC1KJwXz7PqZLmT28jPdHjKwLuHYzFZREks=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=snKumtx718VrBcY5D4HgdKOVdMTNcExYA0nKfklZy+EzoVZZdYbfBxSuEJVSKdAZUFWs+jCUzFP8wTmd4ydaAQDy9m0bMRSvlWXWhkP2ASn71V8oPBJEF6WNxYRxZb7wQtwAZkXzJBnNuClLyFOwzm+pS5ZOFN+WIo83iRg1CT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F5Wvvs4q; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F5Wvvs4q"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e620fa473so5319595e9.1
        for <linux-raid@vger.kernel.org>; Thu, 17 Sep 2026 06:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789653528; x=1790258328; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=bCFpQtachC1KJwXz7PqZLmT28jPdHjKwLuHYzFZREks=;
        b=F5Wvvs4qQ85b33FvRPmucAwKHR2HK3OQMrVtjLQRY2WoFr9FQAB3Whx2uitxq3OT7P
         AJR5Yq3aBomTRuP6Nzjk8oQCVfVO0ewRP2gcRy8KRONsXRSmfMCidxgPQdgB/tlo+9qQ
         2jysOGRGwEi5FbhPqpeSElQSvLM8DxRDgAhjsD4OVTuuo+DQfd4uYh47omBK01U4a4Rt
         +Es9XgE4okcIL2eSCAp6prKmknmv2c7HmewzluAmRIJ/Hv5hw9020Y/FG2QHdgUYFcpg
         HF3EWKSKMGhbBX9M0YoIe4j690KHzeoOblefw5bPoeZmYliBXyPxK8s4VG+vhj8X2sg5
         fvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789653528; x=1790258328;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bCFpQtachC1KJwXz7PqZLmT28jPdHjKwLuHYzFZREks=;
        b=XUGnCdjm0mRjWLrStza8xB/R1PWXHQGs0EzZawEGJxN734WnLJYhq7dzkaO3YEx144
         9SJZTO6ZKL+CXB3Xb3nbnTpiAEci2JXwD+rl3D7mU/8f0/sxq/zJhaa7Di5mLEGJTCTi
         wvMKwBdWyHfRo0W+/BNpiFoTF52QhBiD/g/I4uSLxET9HrthglYOZgjh8TXOdqIhtGUi
         zVYtY71IzKIUm2nhs0mlMPvLifzyjc1eEzxbUgq3siyZ9YM4Zhr35RgM0UEp7Zb1YaFL
         LXuGeNqFo+c0hl5ES22dWv9RwTzONJcUM2qrrpQQ8KJVqspFjcr/5D80pL1QuBIf3R0P
         kW+g==
X-Gm-Message-State: AFuF++mA4w4gFxlcBgMsQ7mMqPBrW/CjtOfBxqnWA5/XpaS6nVg9Vbkz
	t/8o41Oih/0dl6EsBwH2fFJEOOKoO3lO0BvOFh+nqy/D9PBuRpH4O7anYSm0sX9VcrI=
X-Gm-Gg: AYBFou0FlbBskh3STA+UlTa5WWg+p+hi8274PBxmq5IFqkvLVaN7/FuY6NYLkP0PQwe
	KoDkLZ+kXIDmCljGff0/T0o48KeddwQe+eC4RzNzrenLSb6UV0BjqHHxu0kEVdEE03KwtvD9ejn
	HeW/2ub96rBRZ5We1DajypopjAXgiE/9QUa9n+xSe4YJ87iJ+O5h1QGjwfxRzAn7vU/DkvUlApu
	dHCDDlU4Wbr5GxBknFRCkYlHyarba1jRfG4nR5hTpZJlifw38mPHDBlwzXN6Aude8f1YP5aJxm7
	6/h2HrpJGMW610BnvPPUwXtGW5CYBtgwo3qO9g4oeIxqrVqQGQf7+NqgJ/YODFFT8amLYsdufE/
	tqsjqI9mfW02W/X6c2E1wHVJDJwHBVWcIuRcw31R8lxoXuotJG0H8dkhVLXLAhXrLM3uSXPxn+X
	I4vBQdjljceaj3cJI6FkDJBX8P9jLvCOPfVD+pUbjIzhuSmtI69KkbXkIUdTj2OMpBAdMzQRPs2
	W8YnPASrbMGHQfpUX7ApKWbLJj7E1AIC1DBgYf5sygShwhNMauWLc89ka9fyBPPXuSw1ZiGr2Fc
	UiIBUABcAsThx/LC2FYiEejGPqD0v1NTxDWNM80MC2OqJg==
X-Received: by 2002:a05:600c:a00e:b0:49e:63cd:31fb with SMTP id 5b1f17b1804b1-49eac4679b3mr92674295e9.9.1789653528216;
        Thu, 17 Sep 2026 06:58:48 -0700 (PDT)
Received: from p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de (p200300de37172700e7f885d729fa4be7.dip0.t-ipconnect.de. [2003:de:3717:2700:e7f8:85d7:29fa:4be7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd2160c2sm81755845e9.6.2026.09.17.06.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 06:58:47 -0700 (PDT)
Message-ID: <0cce3ff7dc782ef2f2618212b6b87889aea8e653.camel@suse.com>
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10
 when using FailFast
From: Martin Wilck <martin.wilck@suse.com>
To: Kenta Akagi <k@mgml.me>, Xiao Ni <xni@redhat.com>,
 linan666@huaweicloud.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 song@kernel.org, 	yukuai@fnnas.com, shli@fb.com, mtkaczyk@kernel.org
Date: Thu, 17 Sep 2026 15:58:46 +0200
In-Reply-To: <b2cc7f6e-b029-48d8-9c1a-cc8bdbdc4f1a@mgml.me>
References: <7944a042-2e1e-1487-1b42-529768afbbd0@huaweicloud.com>
	 <0106019b9349bf39-5460c782-3d63-43cb-a56e-e34760ce51cd-000000@ap-northeast-1.amazonses.com>
	 <CALTww282Kyg9ERXeSiY5Thd-O40vEXjAXsD8A2PxEsd-h-Cg3Q@mail.gmail.com>
	 <b2cc7f6e-b029-48d8-9c1a-cc8bdbdc4f1a@mgml.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hello Kenta, all,

On Fri, 2026-01-16 at 11:04 +0900, Kenta Akagi wrote:
>=20
>=20
> On 2026/01/07 12:35, Xiao Ni wrote:
> > On Tue, Jan 6, 2026 at 8:30=E2=80=AFPM Kenta Akagi <k@mgml.me> wrote:
> > >=20
> > > Hi,
> > > Thank you for reviewing.
> > >=20
> > > On 2026/01/06 11:57, Li Nan wrote:
> > > >=20
> > > >=20
> > > > =E5=9C=A8 2026/1/5 22:40, Kenta Akagi =E5=86=99=E9=81=93:
> > > > > After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and
> > > > > RAID10"),
> > > > > if the error handler is called on the last rdev in RAID1 or
> > > > > RAID10,
> > > > > the MD_BROKEN flag will be set on that mddev.
> > > > > When MD_BROKEN is set, write bios to the md will result in an
> > > > > I/O error.
> > > > >=20
> > > > > This causes a problem when using FailFast.
> > > > > The current implementation of FailFast expects the array to
> > > > > continue
> > > > > functioning without issues even after calling md_error for
> > > > > the last
> > > > > rdev.=C2=A0 Furthermore, due to the nature of its functionality,
> > > > > FailFast may
> > > > > call md_error on all rdevs of the md. Even if retrying I/O on
> > > > > an rdev
> > > > > would succeed, it first calls md_error before retrying.
> > > > >=20
> > > > > To fix this issue, this commit ensures that for RAID1 and
> > > > > RAID10, if the
> > > > > last In_sync rdev has the FailFast flag set and the mddev's
> > > > > fail_last_dev
> > > > > is off, the MD_BROKEN flag will not be set on that mddev.
> > > > >=20
> > > > > This change impacts userspace. After this commit, If the rdev
> > > > > has the
> > > > > FailFast flag, the mddev never broken even if the failing bio
> > > > > is not
> > > > > FailFast. However, it's unlikely that any setup using
> > > > > FailFast expects
> > > > > the array to halt when md_error is called on the last rdev.
> > > > >=20
> > > >=20
> > > > In the current RAID design, when an IO error occurs, RAID
> > > > ensures faulty
> > > > data is not read via the following actions:
> > > > 1. Mark the badblocks (no FailFast flag); if this fails,
> > > > 2. Mark the disk as Faulty.
> > > >=20
> > > > If neither action is taken, and BROKEN is not set to prevent
> > > > continued RAID
> > > > use, errors on the last remaining disk will be ignored.
> > > > Subsequent reads
> > > > may return incorrect data. This seems like a more serious issue
> > > > in my opinion.
> > >=20
> > > I agree that data inconsistency can certainly occur in this
> > > scenario.
> > >=20
> > > However, a RAID1 with only one remaining rdev can considered the
> > > same as a plain
> > > disk. From that perspective, I do not believe it is the mandatory
> > > responsibility
> > > of md raid to block subsequent writes nor prevent data
> > > inconsistency in this situation.
> > >=20
> > > The commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and
> > > RAID10") that introduced
> > > BROKEN for RAID1/10 also does not seem to have done so for that
> > > responsibility.
> > >=20
> > > >=20
> > > > In scenarios with a large number of transient IO errors, is
> > > > FailFast not a
> > > > suitable configuration? As you mentioned: "retrying I/O on an
> > > > rdev would
> > >=20
> > > It seems be right about that. Using FailFast with unstable
> > > underlayer is not good.
> > > However, as md raid, which is issuer of FailFast bios,
> > > I believe it is incorrect to shutdown the array due to the
> > > failure of a FailFast bio.
> >=20
> > Hi all
> >=20
> > I understand @Li Nan 's point now. The badblock can't be recorded
> > in
> > this situation and the last working device is not set to faulty. To
> > be
> > frank, I think consistency of data is more important. Users don't
> > think it's a single disk, they must think raid1 should guarantee
> > the
> > consistency. But the write request should return an error when
> > calling
> > raid1_error for the last working device, right? So there is no
> > consistency problem?
>=20
> Hi all,
>=20
> I understand that when md_error is issued for the last remaining
> rdev,=20
> the array should be stopped except in the failfast case, also,=20
> it is no longer appropriate to treat an RAID1 array that has lost=20
> redundancy as "just a normal single drive" [1].
>=20
> I will post an PATCH v7 based on v5.

I wonder what became of this v7 series. Have you given up on this?
If yes, what is the bottom line - simply not using failfast in setups
like the one you described?

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Stefan Gaiser, Jochen Jaser, Abhinav Puri (HRB
36809,AG N=C3=BCrnberg)
