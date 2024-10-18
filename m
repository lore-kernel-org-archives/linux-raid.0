Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD102905;
	Fri, 18 Oct 2024 06:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729234031; cv=none; b=rpbX7P1RfU2nVd7yV8Wrvu7on4bUURbxmhVNrqUorIbm8YmTtaNONpRsyriOzGeQIL3gzELQL8dZygAuJQvAKkO5q+ZTOthYNb9QR/pdrmuTpszRUli+ihkJ2wxw1EjgZOseYm1Wylv+0MZUfJ0hgQO6hh6VS+8yrvqml/C0iik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729234031; c=relaxed/simple;
	bh=YRyRyH9R80Yo7aQnUEDftAxW/f0qbotTlHbtvRxYyUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HPkHY8sNFF6gnXw9cPXrpLTAPExwChrKzijfFbys22Hmto5cUZ2/VF2/Ya8SRsHVo7MCu/d9LL5/41ja/bt0EpK2qkreOhIcJL4D0rP2vvugJ4Y4lf3TfvyHyhOOuRaOKkqfHzLH77dkxaACxvnL5FF7Ux7Xwo4TvNLu+YmNj7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=razPfXKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="razPfXKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3754C4CED4;
	Fri, 18 Oct 2024 06:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729234030;
	bh=YRyRyH9R80Yo7aQnUEDftAxW/f0qbotTlHbtvRxYyUM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=razPfXKguhCWAlB6+z2Z/QiB2V24+ZNSVzlU5jSh85xvTfkmVCAtqJFCKb51rjwfW
	 /rK4doSYT6OemiGZdprOscH4tijA4K2bIb+3tuWLZNVRUGdcrX8EqtuRBTDPMbmyRG
	 mCIyEMZRvd9r1uYFzTqFfmk/3eTFimWoF9qqvpQ9Cnd1JMpOEYfqxgEDf48ENNhUZZ
	 J4GZOuvckLRaukH+qvAgD6zCUZlBQMisQj6cvDXpCZWE4dSygd3u+zxhxHK9qwNdyw
	 8W7RRysvaq6sgfdN/bl1+BNB5Ndlmm7adcRSN73FVeUeQBXPN95e/FGRm+AMfZ7gcP
	 2cuneIKlqJvPQ==
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3a3a03399fbso8658365ab.0;
        Thu, 17 Oct 2024 23:47:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVP5GErO13eH/EfEkL9umRhuDHltsNnNK7vqze5Y3uE+YGZGF88lDyIdtXdIKR8KKFs8TYiKzT5uEAWwb4=@vger.kernel.org, AJvYcCXWiF7lRLJUcKxGXO9+StMfhZlSSfLDHjOHNzchVSsaD02GIxz0iBavYjSlLGf7RnS0uoucM+0BdILJ1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwnNZRbExsMSviFjjPEJ5yWrzGVBk8mDRJ2+Xyyh4XDphgOxDYG
	df/4ssG8N82lT03pp5DLQmekqfbNDJRcWHK/nQem3gcuCRM5xHTWpQ9CYHsOFnou1yMzxeirEXF
	HUQdkSkYqpk10gvN6KRQfVqz3pQE=
X-Google-Smtp-Source: AGHT+IHx/muPxMX9RMPU4hPluoG/3rliY4riuP4cEzyaP9BDwiLBURhp/gQh52u6eb4ksZ6QUxY8rYS426PikNX0lRw=
X-Received: by 2002:a05:6e02:1a06:b0:3a0:b0dc:abfe with SMTP id
 e9e14a558f8ab-3a3f409f362mr12313145ab.17.1729234030074; Thu, 17 Oct 2024
 23:47:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
In-Reply-To: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 17 Oct 2024 23:46:58 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4UCFbtrxXVfCaXFvCWYhb8He0tGSHq8UZ_4dWX=ZMs3A@mail.gmail.com>
Message-ID: <CAPhsuW4UCFbtrxXVfCaXFvCWYhb8He0tGSHq8UZ_4dWX=ZMs3A@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] md: enhance faulty checking for blocked handling
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Mariusz, you have run some tests on v1, but didn't give your
Tested-by tag. Would you mind rerun the test and reply with
the tag?

Thanks,
Song

On Thu, Oct 10, 2024 at 6:18=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Changes in v2:
>  - add more comments and commit message in patch 3;
>  - fix some typo;
>
> The lifetime of badblocks:
>
> 1) IO error, and decide to record badblocks, and record sb_flags;
> 2) write IO found rdev has badblocks and not yet acknowledged, then this
> IO is blocked;
> 3) daemon found sb_flags is set, update superblock and flush badblocks;
> 4) write IO continue;
>
> Main idea is that badblocks will be set in memory fist, before badblocks
> are acknowledged, new write request must be blocked to prevent reading
> old data after power failure, and this behaviour is not necessary if rdev
> is faulty in the first place.
>
> Yu Kuai (7):
>   md: add a new helper rdev_blocked()
>   md: don't wait faulty rdev in md_wait_for_blocked_rdev()
>   md: don't record new badblocks for faulty rdev
>   md/raid1: factor out helper to handle blocked rdev from
>     raid1_write_request()
>   md/raid1: don't wait for Faulty rdev in wait_blocked_rdev()
>   md/raid10: don't wait for Faulty rdev in wait_blocked_rdev()
>   md/raid5: don't set Faulty rdev for blocked_rdev
>
>  drivers/md/md.c     | 15 +++++++--
>  drivers/md/md.h     | 24 +++++++++++++++
>  drivers/md/raid1.c  | 75 +++++++++++++++++++++++----------------------
>  drivers/md/raid10.c | 40 +++++++++++-------------
>  drivers/md/raid5.c  | 13 ++++----
>  5 files changed, 99 insertions(+), 68 deletions(-)
>
> --
> 2.39.2
>
