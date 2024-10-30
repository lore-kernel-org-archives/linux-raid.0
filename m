Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83051D14FD;
	Wed, 30 Oct 2024 06:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730269722; cv=none; b=pM8m6aKk0AO7Gl1JM2E03lePK5WJwmJ5bc0n3IVTqFyZ/pABgN4vm8FrEmhC41RKkTlY7WlLh8QWs2BSneyCXvoPHHN0SXAxt64xZzTdj2VTLqaiYV6SYFk1RJETDtiA9Nw7jTerPjXYA3CbYTXF8z10jvdYBcM+GllfylJHW7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730269722; c=relaxed/simple;
	bh=5nZyQDFcP6HcCl/XOGOFRQa3bJUfJ7chiB1P9Pkd34E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YZAuNMK5vRrbVhnvEH0CjRCmJyu2cs7x4VS4Y1wii5zibsbD/igB95ExEPkehoyiX2x/HQv6I0TT+Yhttufu9LIClKWNMPRd11+AkclCxbUuOhVGzBy6/qbqYNipMRmQhJMsC7cafD8xVz1baMWFypq9HFqJggnUW3AMyZ4imoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jTF83Nkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jTF83Nkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ACFC4AF09;
	Wed, 30 Oct 2024 06:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730269721;
	bh=5nZyQDFcP6HcCl/XOGOFRQa3bJUfJ7chiB1P9Pkd34E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jTF83NkdqSKjdfrkAUXgVMzdegm9K1KL8YKr0i5gYRB3uoFH11xrmQNvC5SErzqGH
	 T/dpC5LPQAV+b5wbykK/F6V/QciJLGJ6EhUybcfLxwHigav84lO4s2a7+YVVK9o0Jn
	 6ZUP6yqzAkER4XLI05/gtTMF4r1WwSukHdt6WTx1T0MZoF2OroVdCsW7fyaWz8bjX0
	 kSLePRg9/qqumb2/74yvlNErFRO8mkUECquOroupDnuOS1pawAUeQbxAZaIXWmU2IT
	 HW55+f48G3IX2mMy8hs7fIZeEIfmcPZ85q6oCk+cV4iJAW/zkVTKn+zVWd7J1A8Hr8
	 ZDqJdQswpo9Qg==
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-83ab694ebe5so237779939f.0;
        Tue, 29 Oct 2024 23:28:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU2WaNBSUPJD4VhYpcmIsFUaEPJDt4zPuUtKJmWpjGNhKocEDj/airsKRPWm5L8/JKWLv2vmEsD1gElTns=@vger.kernel.org, AJvYcCUrx8Ei8l6YZr/cCW/UcWc8feuK9E4cnOaacMvk0VzQI/KIrdmrwAtR2NtoOtUlL2s+GggmBFrGzHmekQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yytj6c+/Crk0jdbKQG4iYd3KHo1ZMu4SLWbTYYaedeBtdS9Kuom
	oDkXr2QpK2ogRo4/xH3CZ1s2m5RVn+cq4RXN+4kvq+cT5bUdSmVZODLx5IPAGFAeHKApu2P+Q/x
	aDfa0pkw2AigjYMY/MSetQqjORYs=
X-Google-Smtp-Source: AGHT+IGhYN7/y5CtbkCdpv/f75zaakEf4kpB0787CSzbyc51SDNxG+1Ug8G52MpShDxcq3A2zPPH5rEefqnYD89YAm4=
X-Received: by 2002:a92:c54e:0:b0:3a3:64ab:1e95 with SMTP id
 e9e14a558f8ab-3a4ed2b1ac5mr160562155ab.13.1730269720940; Tue, 29 Oct 2024
 23:28:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
 <20241011011630.2002803-3-yukuai1@huaweicloud.com> <7e069314-4f6d-d291-8650-a37e95268d9b@huaweicloud.com>
In-Reply-To: <7e069314-4f6d-d291-8650-a37e95268d9b@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Tue, 29 Oct 2024 23:28:29 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4ieXOC2YZoN6T-0spiX9iijKkHqThDf3hUY0NZ8oUHrw@mail.gmail.com>
Message-ID: <CAPhsuW4ieXOC2YZoN6T-0spiX9iijKkHqThDf3hUY0NZ8oUHrw@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] md: don't wait faulty rdev in md_wait_for_blocked_rdev()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 6:22=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/10/11 9:16, Yu Kuai =E5=86=99=E9=81=93:
> > From: Yu Kuai <yukuai3@huawei.com>
> >
> > md_wait_for_blocked_rdev() is called for write IO while rdev is
> > blocked, howerver, rdev can be faulty after choosing this rdev to write=
,
> > and faulty rdev should never be accessed anymore, hence there is no poi=
nt
> > to wait for faulty rdev to be unblocked.
> >
> > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > ---
> >   drivers/md/md.c | 4 +---
> >   1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 179ee4afe937..37d1469bfc82 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -9762,9 +9762,7 @@ EXPORT_SYMBOL(md_reap_sync_thread);
> >   void md_wait_for_blocked_rdev(struct md_rdev *rdev, struct mddev *mdd=
ev)
> >   {
> >       sysfs_notify_dirent_safe(rdev->sysfs_state);
> > -     wait_event_timeout(rdev->blocked_wait,
> > -                        !test_bit(Blocked, &rdev->flags) &&
> > -                        !test_bit(BlockedBadBlocks, &rdev->flags),
> > +     wait_event_timeout(rdev->blocked_wait, rdev_blocked(rdev),
>
> Just found that there is a stupid mistake that I should use:
>
> !rdev_blocked(rdev)
>
> Tests can't find this mistake because wait_event_timeout() is used,
> and caller will break out if rdev is unblocked.
>
> Song, since this is still is md-6.13. Do you want to to send a fix, or
> update this version?

Please send a fixed version (the whole set). I will update the branch.

Thanks,
Song
