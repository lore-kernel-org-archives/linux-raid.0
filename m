Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5160A1094E;
	Fri, 12 Jul 2024 15:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720797076; cv=none; b=eqUdHzhcQunEDlXnph3w9e4xAsj/TNT0IMsIbj3ubS1DCfvOnu/fIyOe85ifY+vtGaxUDRROmq6rTzZlsqY15KAq3FhhO3j9K5DNS+8HWXeMf/m+BD97b9F+dKpLgKjsjroEIH0Reey3k32+vKOfqrfW0204C7Mc+RmdgAJqlnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720797076; c=relaxed/simple;
	bh=wIYAcLDyOpylbwPhtjdfS2b6CmMl2xwl8ERI8TsCPaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qE4cYEkuAYLswes8V6rvyrldd7aq39HlFO3InI47i7zeDVjB1RSexpUUUBwt7yuX75e2JhwIhr6O/XgPy5K/j9tXdHf4VeBMVGq0gEqBiLm//ZW16kKkG+1g7sqvEifbZ8o/23F6ctvto1RYChuWEZC+gZijPC3APYtZHmLOOiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9V+TCW2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9V+TCW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94B3C4AF07;
	Fri, 12 Jul 2024 15:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720797075;
	bh=wIYAcLDyOpylbwPhtjdfS2b6CmMl2xwl8ERI8TsCPaM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=F9V+TCW27ibmPPT7glABTc/9ZMpnm9+n/eXyOIeoj93KTKX0Ng20Mb7JKEvq3zd6C
	 gRVgni5113IXceV3RfDJQLTJcgqA2mgWEOJweMckI4aG9J0y0dm5ZpOUs9D3vIj6e/
	 mh3RysJsBlwxfao9M20LVOQtXDeU34DoY9pHgQPL7m7LFyiMN+JOuhEXP6TIoIfggm
	 nuOKb7QvX+8cDKtxe7iwyqLjsZ9Nz4ZechaCnkrPiycN5ZQ4Z+dpQHGnPgRUaG35re
	 WrqIaXJ0wIXrARTnGhKqfNpTUOpkmBP5cWOEQe5vFZN5NxthiBw7ldsNcSZ/SXB+34
	 hTVDQEidytL3g==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2eeb1ba040aso26610681fa.1;
        Fri, 12 Jul 2024 08:11:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUlNWakywXJwhQPvf8iN+9B4fkDVXlUSWNdiIL6bezpYCV6/gOYSp1hg9XSrleFYZPo2xACqKpcXkeJh931of8uDA/iRDSEPzumVebz2NC18TsGbekN579tRyHEW50RKAaAujCJTcgheJjBS4moSPjzizxgMnyEJYbrIsHyHJAdPg==
X-Gm-Message-State: AOJu0YxnS4IShyYUgij2gdx37DkI2F8BkGl6Zga523HRnJ4nVIpFrfS2
	l+CZ9lE+0cl/vW/Uw80tFa6G6BVuLPm1nsfmr3RN5LcoaA92+hZXZXYCcwGnJWk7sArgVnghU6O
	77GRYt3s9xyl6YUTBi1c07OjvhWw=
X-Google-Smtp-Source: AGHT+IGcOXMGDgrl5+ItZtV37i+bV/sZ52Kf7tZ2ILokLQEPwLoE4eybv8P3e+2kFNboOyJQmmSCj4ubC/K4KQcpArQ=
X-Received: by 2002:a05:6512:3b8c:b0:52c:6461:e913 with SMTP id
 2adb3069b0e04-52eb999623amr8426356e87.16.1720797074303; Fri, 12 Jul 2024
 08:11:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <349e4894-b6ea-6bc4-b040-4a816b6960ab@huaweicloud.com>
 <20240711202316.10775-1-mat.jonczyk@o2.pl> <e9585300-1666-ca71-8684-8824fe2ddaf1@huaweicloud.com>
In-Reply-To: <e9585300-1666-ca71-8684-8824fe2ddaf1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Fri, 12 Jul 2024 23:11:01 +0800
X-Gmail-Original-Message-ID: <CAPhsuW6sjMr_Eoqc4J7NjfdJDwLtTSEqQOeC_+EyiSVKYq8gvw@mail.gmail.com>
Message-ID: <CAPhsuW6sjMr_Eoqc4J7NjfdJDwLtTSEqQOeC_+EyiSVKYq8gvw@mail.gmail.com>
Subject: Re: [PATCH] md/raid1: set max_sectors during early return from choose_slow_rdev()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Paul Luse <paul.e.luse@linux.intel.com>, 
	Xiao Ni <xni@redhat.com>, Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 12, 2024 at 9:17=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
[...]
> >
> > After investigation, it turned out that choose_slow_rdev() does not set
> > the value of max_sectors in some cases and because of it,
> > raid1_read_request calls bio_split with sectors =3D=3D 0.
> >
> > Fix it by filling in this variable.
> >
> > This bug was introduced in
> > commit dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read=
_balance()")
> > but apparently hidden until
> > commit 0091c5a269ec ("md/raid1: factor out helpers to choose the best r=
dev from read_balance()")
> > shortly thereafter.
> >
> > Cc: stable@vger.kernel.org # 6.9.x+
> > Signed-off-by: Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl>
> > Fixes: dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read=
_balance()")
> > Cc: Song Liu <song@kernel.org>
> > Cc: Yu Kuai <yukuai3@huawei.com>
> > Cc: Paul Luse <paul.e.luse@linux.intel.com>
> > Cc: Xiao Ni <xni@redhat.com>
> > Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> > Link: https://lore.kernel.org/linux-raid/20240706143038.7253-1-mat.jonc=
zyk@o2.pl/
> >
> > --
>
> Thanks for the patch!
>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>

Applied to md-6.11. Thanks!

Song
