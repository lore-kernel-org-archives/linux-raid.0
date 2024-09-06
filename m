Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA0D1B85C1
	for <linux-raid@vger.kernel.org>; Fri,  6 Sep 2024 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725646545; cv=none; b=nYyUoW6fPtxsu24frJlVGrHuZv96VZVnqRRNoGCbXzlzdyduayZxIDz0MRv6RmPpyAG2+Pi7kpAmVI1vCMIpxyaeaiJ1X4Jydg5js16MQQcJctZbloTg9NjjLGf6AE8g1MN3aogIOiwmBUc/VzI8DtzUj/GCtU8ArBO/sWDtwwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725646545; c=relaxed/simple;
	bh=ocTdgDnIsZHDwnIzB2MOal/SJpJhqZBEryDDKIGVfa8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jbJTBY0DuPOBsxHHRIBdEyqbAlTr6jjdjAoTDzefXTW6kMrsCrjhdvG2lXtQ7et2qjXEzW2r6cezcQsDm1DdTXA0uhI+KIA9JQutbNZxWVUk9skVgoTMi5rJlGEF104iw1zswBTg+w95gGOTD7gPjsNOzRjcJmVV54dy+Uj3GLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGk7IbPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGk7IbPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E75EC4CEC9
	for <linux-raid@vger.kernel.org>; Fri,  6 Sep 2024 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725646544;
	bh=ocTdgDnIsZHDwnIzB2MOal/SJpJhqZBEryDDKIGVfa8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vGk7IbPro6P+ddvMpp1CS/6zoR6Us/RVzXpXmZaNF1K4TWNqUnJY1QeRDRGGNL2xC
	 0QZBMQYUNIWEs8xH0SD4WQVVh1TKCpBgnxdqKFzCY/isDZF14PBMFZqYvrBmTRDiB2
	 2YYSE+YU+iQFI/vyz0ZLUEHIwCwT4HeQJIZlIKALl1QjxECOUkuaI6I6D7mpzyCIYc
	 G9bJgiLvg8b5Rrlr9+h9s0oAeUn6sLNXEqlJBzBlKBTR3lObepe22imfEpaSDpq9wn
	 hBMEG3230NBtboHgw/gi7xQ5WMkihUNqC8G+yRol9Zvwb2Rru2ThfjCNGgD/DcIry9
	 zOgVGogY4U4oQ==
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-39d3cd4fa49so7479065ab.1
        for <linux-raid@vger.kernel.org>; Fri, 06 Sep 2024 11:15:44 -0700 (PDT)
X-Gm-Message-State: AOJu0YykzB2LZgVV4CvSy8b3kFShp3/UOkI2+AT0VMHTo6crbztQjnLJ
	msZNqjKrde7CuxJx088wgWB01RlslKQ/RBjxOKb+tgOpWzcR57zqzEHYAHoIJn4y2Xc/oyZK5qJ
	+8OdYnUKbvxz7cG15fm/2hXeq7jg=
X-Google-Smtp-Source: AGHT+IFk5L6l3ePi7qNJTOYib8YOFH7mApzql60qroMP8kYYitnITZxf6GCHb/gwUF1LI81oIHAs4yURh0ZUUyFIgaw=
X-Received: by 2002:a05:6e02:1a0f:b0:375:acd3:31b3 with SMTP id
 e9e14a558f8ab-3a04eb8cabbmr36116045ab.5.1725646543984; Fri, 06 Sep 2024
 11:15:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240904235453.99120-1-xni@redhat.com> <CAPhsuW4xb8cuk0kKuLivHVkzzHOyNMDiD4iv7DBqghZ9DmwM6A@mail.gmail.com>
 <CALTww2-FnOaiP3GqF98oWRXn3UUxjyBDBYYn9qOcpomLv=-7Rw@mail.gmail.com>
In-Reply-To: <CALTww2-FnOaiP3GqF98oWRXn3UUxjyBDBYYn9qOcpomLv=-7Rw@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Fri, 6 Sep 2024 11:15:32 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7P1aOHjUbR4k9Ma+XwDyduq=Ar4R+ZceFyEOri+K1fHA@mail.gmail.com>
Message-ID: <CAPhsuW7P1aOHjUbR4k9Ma+XwDyduq=Ar4R+ZceFyEOri+K1fHA@mail.gmail.com>
Subject: Re: [PATCH V3 md-6.12 1/1] md: add new_level sysfs interface
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, yukuai1@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 5, 2024 at 7:07=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
[...]
>
> Hi Song
>
> I rewrite the comments like this:
>
> Now reshape supports two ways: with backup file or without backup file.
> For the situation without backup file, it needs to change data offset.
> It doesn't need systemd service mdadm-grow-continue. So it can finish
> the reshape job in one process environment. It can know the new level
> from mdadm --grow command and can change to new level after reshape
> finishes.
>
> For the situation with backup file, it needs systemd service
> mdadm-grow-continue to monitor reshape progress. So there are two process
> environments. One is mdadm --grow command whick kicks off reshape. It
> doesn't wait reshape to finish and wake up mdadm-grow-continue service.
> Two is the service. But it doesn't know the new level. Because in the
> first step, it doesn't sync the information to kernel space. So the new
> level which reads from superblock is wrong.
>
> In kernel space mddev->new_level is used to record the new level when
> doing reshape. This patch tries to add a new interface to help mdadm
> can update new level and sync it to metadata. So it can read the right
> new level when mdadm-grow-continue starts. And it can change to the new
> level after reshape finishes.
>
> Reproduce steps:
> mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
> mdadm --wait /dev/md0
> mdadm /dev/md0 --grow -l5 --backup=3Dbackup
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
> md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]
>
> Test case 07changelevels from mdadm regression tests can trigger this
> problem.

Applied to md-6.12 with a commit log based on this version.

Thanks,
Song
