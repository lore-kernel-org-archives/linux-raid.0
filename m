Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624E6111AD
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718210195; cv=none; b=eF74EHBWjXBcnvGDtPeJ4Owx6sQXKNz1bKcopbPweL7qSCQRbHXDWQKfn/b72YQVCGt04fw24vvg0UdeLVCHFSNuoO7HmynxYvR/kLudrO7Fw2l2/14I5IouD5myNZkeAWfGsJn70k6XONuN6JIhKgO1KJxExWsh0c7t5qXcyWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718210195; c=relaxed/simple;
	bh=lDrq0gr27RRF93y+GyH3ahyvRFU9MLzUdFBYsyiurpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ltI1Ryzy9QkqdTcHnLpWIom/AahcKST+pbgWqsOXusDGRnWGbZ4zMsXApAfK0lYoQBDkEcyYLxuLDh7NURcmK+GONuD4rhGWNtoIjbyA673CO4wUCGd33V3Cmq7Hmczu+4d/4SeylJAK9QrUJdzCt1QTgvfa0MzwIP8OdzLS16s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9wMkBzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9wMkBzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43811C116B1
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 16:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718210195;
	bh=lDrq0gr27RRF93y+GyH3ahyvRFU9MLzUdFBYsyiurpg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=H9wMkBzuakwmSHhGXBz92NfhOxxOgpCL/zKtIsCtk2Wno9AdOroECIzDQ2fAefBVP
	 fzbx4M0daHAFasPU+7mp8nziWW+pIGV5XoxQYOhj7Kxw5Y2PjExHIJHJ6Glw/TKXYI
	 8g9PfkNNmGyA8FOgXY3M9rNtigBXQi3sNCNf0h4XI8VYIzcwVktSS072ouUjVbXDdV
	 XRPHUgTV5ho7dCEYbt+2YSC58dLrHuHLn922zP5bJaPnllKyOUi95nOfWWXjUlNUkp
	 8/rBXuK6WrUPX+7yi1ATVgiRmDMshB25oF76aqc3mjHsHMXvmieSDEDU6iFrZI30JM
	 xaRLceOtv6wcw==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2ebe0a81dc8so27758401fa.2
        for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 09:36:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUsu8M4tY1uJ1kQQ2DTRcp98Pbn9fAM25hJDv1JAns35XcSFvoVnQaFutqaIbMqdCiHfG9hTfArv8dL1QY1Ux75BNXrgWpAyD6SVA==
X-Gm-Message-State: AOJu0YzSljTKNG2OUUPYRpvSqBQS7pyeK5yYWlbjWy72b4SmggvlWOKl
	XONaDRJPvrOl/zelM8Dy09jFBciLQwlByLparyQAT2DmWR0PULeG+ED5eV59zR1/N7NBcqFrChb
	FSksIVh68vmv9PC8imnMI/LC7EZE=
X-Google-Smtp-Source: AGHT+IFdnuq9Sb22fjZZMUUPFmXyWmn7XVaOtVLHpd8ffAwnWWxABMnfVtOjiykb+c3NO/wNZXo/39IlLM66CpX521s=
X-Received: by 2002:a2e:9a9a:0:b0:2eb:fe31:cae6 with SMTP id
 38308e7fff4ca-2ebfe31e224mr13709241fa.37.1718210193691; Wed, 12 Jun 2024
 09:36:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240604172607.3185916-1-hch@lst.de> <CAPhsuW7cBhbH9iQQunmVohGkwnGJNnw7PFfExXh3umL1qB=SVw@mail.gmail.com>
 <20240611061320.GA4744@lst.de>
In-Reply-To: <20240611061320.GA4744@lst.de>
From: Song Liu <song@kernel.org>
Date: Wed, 12 Jun 2024 09:36:22 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6ZJ32iV3LKUU5a6uxO+_02rCnh-MdoYbXz=WZZsGmVjQ@mail.gmail.com>
Message-ID: <CAPhsuW6ZJ32iV3LKUU5a6uxO+_02rCnh-MdoYbXz=WZZsGmVjQ@mail.gmail.com>
Subject: Re: fix ->run failure handling
To: Christoph Hellwig <hch@lst.de>
Cc: Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Mon, Jun 10, 2024 at 11:13=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> On Mon, Jun 10, 2024 at 01:58:17PM -0700, Song Liu wrote:
> > > raid10 and raid5 also free conf on failure in their ->run handle,
> > > but set mddev->private to NULL which prevents the double free as well
> > > (but requires more code)
> > >
> > > Diffstat:
> > >  raid0.c |   21 +++++----------------
> > >  raid1.c |   14 +++-----------
> > >  2 files changed, 8 insertions(+), 27 deletions(-)
> >
> > Thanks for the patchset. I applied it to the md-6.11 branch.
>
> I was planning to respin this to also handle failures in the takeover
> path.

How about we do that in a follow up patch?

Thanks for fixing these issues!

Song
