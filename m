Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1891916F295
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 16:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718210347; cv=none; b=qxoQ3UlBa5Bt9vIliLw8HT0bfLqUoIEO2JbzpgXeeHxEFQ7gDwes/LJ7q585pBNEcFWt1vG/5rVgVu0nofkmOHBIhwTiK+YjMYtG6kdTIiycO5WPzAwp+/DnbE/L+kJfYbJpIjIBGeK9LZHdoIgemCvOXt8GIAgQiywM3fSenlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718210347; c=relaxed/simple;
	bh=l/maHTeU7cAMtDxppxyx7oMNBBXGDvuL1ia82Q5xe3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b72De408NQlz/pUa7ecYLvxHhACcufyWnjU0+5ECM1WmESjFAbCf6QeM4g7u5YZSW99w4GHGFLzsu2FNQZ8+m2ghdPHpidDL9YkwFqO65XVP+iJOxuZr3+n+fBOwspvZ2dn5SyOLsdsEJCgcDj434WUW/0cx5xjG80El8zBtuxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CmVhUPS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CmVhUPS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A25C4AF1C
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 16:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718210346;
	bh=l/maHTeU7cAMtDxppxyx7oMNBBXGDvuL1ia82Q5xe3Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CmVhUPS6ccxzKRSDnsk+EQZ6ECfTYkoCTJlREPBoriaUajpmsVFzLsv13YZ3c6jVW
	 BUfjBtConqHds7IFFNzUCJck+sGdSGBD3B4jXwN+szRtR9L/rBkJi0CpWWUMeRymLH
	 c6oaaGfeNg+xMErGQfmT4KFk+ZS5CY2V51D7qLgxFzG0aFdedvTvDLLGDvVfWTmaYC
	 cannzZS/6cj9EKyZOdFXGj9V7ie8kOEepJwgxbUNnr+VXZPQ9Gtm8SKPdxqrKT7ei4
	 E6YdtyXd1AmbkRP7p6c7/preWtyUtiVFOirnWTEow5wLFnpia4cqFW+6AEdlOKeuCR
	 4RmD6LLyjawow==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2eadaac1d28so63795511fa.3
        for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 09:39:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUVqAqsg4BUVzOTtwxkUuOq5BakKVOwmIfDQmu+Ulrpm4cOGHv6BOLgHuol3aSQ95HWkDdFhNUyIyml8jPextTM68xnxGJ3p6p78w==
X-Gm-Message-State: AOJu0Ywg87py3wYvrxPsfud1Xc6P8yUvuNNdXQvnJ4K+m2E4xeSamC4G
	wmZh9bBh6hjmGmGYPVcZka/SoZITHs6bq7jX4MjcGw1lJJYDRPKlcbvUkWquyr6/iWjulSGi86h
	i58tawzOPEEMt9S6se04yv7+4c+I=
X-Google-Smtp-Source: AGHT+IHKocuoGt2TRzdhxvFnyQAgHzZgnCw5xQXU4dxh9ygR1OEOEv9HCsv0fLbIBiAsAGnQ2SLwh4fmnQ138mZBinA=
X-Received: by 2002:a2e:9cd6:0:b0:2eb:fa7b:557c with SMTP id
 38308e7fff4ca-2ebfc8f93ccmr17577061fa.0.1718210345027; Wed, 12 Jun 2024
 09:39:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240607072748.3182199-1-ofir.gal@volumez.com>
In-Reply-To: <20240607072748.3182199-1-ofir.gal@volumez.com>
From: Song Liu <song@kernel.org>
Date: Wed, 12 Jun 2024 09:38:53 -0700
X-Gmail-Original-Message-ID: <CAPhsuW43KFshDwvwT3Nz8S6uMH+MBdjMc+yZ6e8wwrrMX5qANA@mail.gmail.com>
Message-ID: <CAPhsuW43KFshDwvwT3Nz8S6uMH+MBdjMc+yZ6e8wwrrMX5qANA@mail.gmail.com>
Subject: Re: [PATCH v2] md/md-bitmap: fix writing non bitmap pages
To: Ofir Gal <ofir.gal@volumez.com>
Cc: yukuai3@huawei.com, hch@lst.de, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 12:28=E2=80=AFAM Ofir Gal <ofir.gal@volumez.com> wro=
te:
>
> __write_sb_page() rounds up the io size to the optimal io size if it
> doesn't exceed the data offset, but it doesn't check the final size
> exceeds the bitmap length.
>
> For example:
> page count      - 1
> page size       - 4K
> data offset     - 1M
> optimal io size - 256K
>
> The final io size would be 256K (64 pages) but md_bitmap_storage_alloc()
> allocated 1 page, the IO would write 1 valid page and 63 pages that
> happens to be allocated afterwards. This leaks memory to the raid device
> superblock.
>
> This issue caused a data transfer failure in nvme-tcp. The network
> drivers checks the first page of an IO with sendpage_ok(), it returns
> true if the page isn't a slabpage and refcount >=3D 1. If the page
> !sendpage_ok() the network driver disables MSG_SPLICE_PAGES.
>
> As of now the network layer assumes all the pages of the IO are
> sendpage_ok() when MSG_SPLICE_PAGES is on.
>
> The bitmap pages aren't slab pages, the first page of the IO is
> sendpage_ok(), but the additional pages that happens to be allocated
> after the bitmap pages might be !sendpage_ok(). That cause
> skb_splice_from_iter() to stop the data transfer, in the case below it
> hangs 'mdadm --create'.
>
> The bug is reproducible, in order to reproduce we need nvme-over-tcp
> controllers with optimal IO size bigger than PAGE_SIZE. Creating a raid
> with bitmap over those devices reproduces the bug.
>
> In order to simulate large optimal IO size you can use dm-stripe with a
> single device.
> Script to reproduce the issue on top of brd devices using dm-stripe is
> attached below (will be added to blktest).
>
> I have added some logs to test the theory:
> ...
> md: created bitmap (1 pages) for device md127
> __write_sb_page before md_super_write offset: 16, size: 262144. pfn: 0x53=
ee
> =3D=3D=3D __write_sb_page before md_super_write. logging pages =3D=3D=3D
> pfn: 0x53ee, slab: 0 <-- the only page that allocated for the bitmap
> pfn: 0x53ef, slab: 1
> pfn: 0x53f0, slab: 0
> pfn: 0x53f1, slab: 0
> pfn: 0x53f2, slab: 0
> pfn: 0x53f3, slab: 1
> ...
> nvme_tcp: sendpage_ok - pfn: 0x53ee, len: 262144, offset: 0
> skbuff: before sendpage_ok() - pfn: 0x53ee
> skbuff: before sendpage_ok() - pfn: 0x53ef
> WARNING at net/core/skbuff.c:6848 skb_splice_from_iter+0x142/0x450
> skbuff: !sendpage_ok - pfn: 0x53ef. is_slab: 1, page_count: 1
> ...
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ofir Gal <ofir.gal@volumez.com>

Applied to md-6.11. Thanks!

Song
