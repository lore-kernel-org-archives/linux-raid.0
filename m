Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E15919995B;
	Thu,  9 Jan 2025 18:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736449050; cv=none; b=asxfAESBnmKl/9VIUBvTmA+GZJv8NT5c6GiDOOmYyIPZp3qyFki48xwxNHJ+WOSaRvSPkgnHBFQeLvuKJULkunf1q3eREpun25x5r3pjUGgPnXY6KDCau+BbPparhVk06JmspWMQJF1qNd/sdscfpBdDYVjQsndoVsFvGRmqgtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736449050; c=relaxed/simple;
	bh=I2hZnJr8vEnRwukPAz9Dr3bQqDl13XPEgiz5ImvHHt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FC9F0wE5bAYmJCzKtBiJnNe8S9MWQLnSzS52brqTrGPBD9wT+p/fvqiMnYHdC6T4XXllalvci3Fv+aCAmA0zT4/6vKcDjK+bIvFuikzWBZErphmd+IIt/CK1a0d9i//Hzj/uYWeNF5kxuZU/ZF79LOtYZEKRTDfYQ0U6skCsL9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGdB1Nlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGdB1Nlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0751BC4CED2;
	Thu,  9 Jan 2025 18:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736449049;
	bh=I2hZnJr8vEnRwukPAz9Dr3bQqDl13XPEgiz5ImvHHt0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lGdB1NljzZ37kU2KLxFIygi/FO1urZ6khnuj0rsTHyQQ0VUqw5e7iyGVbRhVWlCwN
	 ozbDHjKHXbuPcH+kZmXq8Pw/9vyJ8nGqt1uuJZCwJ3Q9Sfs5WIE8uYLTgt88wDiZDn
	 c0zkrf6Cn1lzOxRasG6qioYV3s6ll2aAkJghv+nESTui1LgXUY1u4GZik9G3yYY+64
	 lrWD/nNfMeXy7YH/uOQorX4qDsTZzT+CXv5Pt2rk72/5q/j2RXO3XqaoNZsuC63EJP
	 867z0+lohs4uPB6subkuGQrrRgfq5aG3wJDQrS6ur+dCa6EdEjI1Bi8MlcW2v5nGGa
	 qWob6pn8wgZbw==
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-844d7f81dd1so41187539f.2;
        Thu, 09 Jan 2025 10:57:29 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVHWitlMBgeQJ/R4/O68DYyLmiYD23q6afQEd6g7FPrI9eb0gSbyMPIZhHTYtw9NF1zpPNG5KqzLVzN9f4=@vger.kernel.org, AJvYcCXK/viegn4T6plHY9RqTG4qf8YgWkOLiYED49jmYpHTT2hz8evJ+n8lK3ymSz6zdbecJzDmDxdlebZpng==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDGuzG9FlLw676SyXF4oOtWqQxcx2XMOsgOlQWsdsGVzZ02Z/c
	rvZ4UfD8rY2iBhRZhscph7pCNUT3C2OCo7uRlkbUcZfoJds4bw2/uWtk7moaS/Bpk04x8/YnNGT
	8NizRevlw/grRAPnnJkYyeTrVX9k=
X-Google-Smtp-Source: AGHT+IH4Z1pkQNJIxF2aD+YoVcl4etJ4H3tgSUSRL3qr0pQdsLlegN/FIr7s2lapet84DTLg0+F+rPFInX9m66fg/ok=
X-Received: by 2002:a05:6e02:1c87:b0:3a7:a69c:9692 with SMTP id
 e9e14a558f8ab-3ce3aa74970mr65843025ab.21.1736449048411; Thu, 09 Jan 2025
 10:57:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109015145.158868-1-yukuai1@huaweicloud.com>
In-Reply-To: <20250109015145.158868-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 9 Jan 2025 10:57:17 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6mddYO4=TNhxqMOW4ki-yuN-JDxW=ycwxP1Et6zSEDNw@mail.gmail.com>
X-Gm-Features: AbW1kva-hCLHwKaVltA_MrV4PJg2SzKL2KeudBKLIsxDgqq_pd_UE7Q-TSFvy8g
Message-ID: <CAPhsuW6mddYO4=TNhxqMOW4ki-yuN-JDxW=ycwxP1Et6zSEDNw@mail.gmail.com>
Subject: Re: [PATCH v2 md-6.14 0/5] md/md-bitmap: move bitmap_{start,
 end}write to md upper layer
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 5:56=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Changes in v2:
>  - add commit message in patch 2;
>  - also remove unsed flags in patch 2;
>  - handle rehspae in patch 4;
>
> Yu Kuai (5):
>   md/md-bitmap: factor behind write counters out from
>     bitmap_{start/end}write()
>   md/md-bitmap: remove the last parameter for bimtap_ops->endwrite()
>   md: add a new callback pers->bitmap_sector()
>   md/raid5: implement pers->bitmap_sector()
>   md/md-bitmap: move bitmap_{start, end}write to md upper layer

With some minor changes, applied this set to md-6.14.

Thanks,
Song
