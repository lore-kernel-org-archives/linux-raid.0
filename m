Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D6914A096;
	Thu, 15 Aug 2024 20:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723754516; cv=none; b=kUJCq3xUYcS/Fy06ucTaFtSx3wCqzYh2wxCCCT01khQAE9DRBtjhzXqjJo9VtpDMEbFT/iKZ51lutQ72fdhxCIGREu/Fc18tPno/uXC+cMeg4DcPYYPNmZSm0PfJm3WPIRBjZf+5s4rEAUpQo9ruBB7A5Vmf4QySGja+IF7zqo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723754516; c=relaxed/simple;
	bh=bltzrFzpplIY5A3AClMkcWd9BZbMj1RdKr3vpJUH5Vw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a2gYmdFYWMQPSxwVJKa3ZAtiT7S+7Qr0g3FGU4I8DaDP3I8HSq0kwd/RUH1CpnQ2cw7bBWo4XWBASz0QynOB06XiDptZRcajlThyh+YFOYWXWzg28kGGbaI7KCjQLLMM0wQtclFTcN6/OxZ0vSjvO9FFwN88e/EGb6RCOVEBBac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CkP1GTLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkP1GTLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984CBC4AF0E;
	Thu, 15 Aug 2024 20:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723754515;
	bh=bltzrFzpplIY5A3AClMkcWd9BZbMj1RdKr3vpJUH5Vw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CkP1GTLXDK/os0/zTkd5wgLAIPer3WmGN8BZ5b2IDEea8nrIA5w61HNpz+ohF2vHf
	 XasRtFmLyU3LpicylGOaEHKoqRlhSM7+6Oa+tcpxFJ3PfZHxxd6dnAmE+pdS53g7K/
	 EcBp+QGrrxhrWCJRxs+I6E8TYkKSwwwd2KVvPx+y+7OFwM1+g6LoSHOWdznmYsaXIZ
	 HKlTAWdnsLIGB2MhHSmidHVMqCRS3IwIObg/JSFKuR4dcvPXKXXl5GNgIdVwWRBm3A
	 CL6qiIQujDTpvY1w6jQVuIamLQtkix5CdNNrB4aZuf2AwIaJ/3VGTxM31yn3FY6AEF
	 z7Fgk6CqJSd4A==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2ef1c12ae23so12122841fa.0;
        Thu, 15 Aug 2024 13:41:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWUw2ceaJaXFXLuQ6J6l5T9v3RTc1VK6I7TIYcnCTzDOAOxsiPwuQ8cxazsRQDoLSlAPEbzPExIixvSxki1vYHW3Hg3QS05JrWZh9kIen7DTB1jFdme2jqoy9npQIKGP6wi6Ss7wrOiag==
X-Gm-Message-State: AOJu0YwxCdLs5r9qsbrPg1c/+R0nLUhIVH58vT2+dtR9PH1AKweOzj8E
	xCxCLWcl0QgKHPrkXqWIpuBwmDi2OEJU7BICyFk/e5hedc7EgLyq3gXmlSn4OXXPEiNBs1yKE9X
	O7Iw5tKXZtclGjHgeD65pB+IYsLk=
X-Google-Smtp-Source: AGHT+IGaKZ7/XhYdh2qE8EeQNF0sp1g1b9yQ9FNmNriOuR4Ts2JKMiZyPfWBbWB7teSeSK6gp2BwW5VMKADLJvD+nWY=
X-Received: by 2002:a2e:b041:0:b0:2ef:2bac:bb50 with SMTP id
 38308e7fff4ca-2f3be586938mr5698001fa.11.1723754513934; Thu, 15 Aug 2024
 13:41:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240803091137.3197008-1-yukuai1@huaweicloud.com>
In-Reply-To: <20240803091137.3197008-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 15 Aug 2024 13:41:41 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Q9_RymaSKHtfn1XUqmCG1Se-e9oT+iCh2Rb62-b4Svg@mail.gmail.com>
Message-ID: <CAPhsuW5Q9_RymaSKHtfn1XUqmCG1Se-e9oT+iCh2Rb62-b4Svg@mail.gmail.com>
Subject: Re: [PATCH -next] md/raid1: fix data corruption for degraded array
 with slow disk
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mat.jonczyk@o2.pl, yukuai3@huawei.com, xni@redhat.com, 
	paul.e.luse@linux.intel.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 3, 2024 at 2:15=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> read_balance() will avoid reading from slow disks as much as possible,
> however, if valid data only lands in slow disks, and a new normal disk
> is still in recovery, unrecovered data can be read:
>
> raid1_read_request
>  read_balance
>   raid1_should_read_first
>   -> return false
>   choose_best_rdev
>   -> normal disk is not recovered, return -1
>   choose_bb_rdev
>   -> missing the checking of recovery, return the normal disk
>  -> read unrecovered data
>
> Root cause is that the checking of recovery is missing in
> choose_bb_rdev(). Hence add such checking to fix the problem.
>
> Also fix similar problem in choose_slow_rdev().
>
> Fixes: 9f3ced792203 ("md/raid1: factor out choose_bb_rdev() from read_bal=
ance()")
> Fixes: dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_b=
alance()")
> Reported-and-tested-by: Mateusz Jo=C5=84czyk <mat.jonczyk@o2.pl>
> Closes: https://lore.kernel.org/all/9952f532-2554-44bf-b906-4880b2e88e3a@=
o2.pl/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Applied to md-6.11. Thanks for the fix!

Song
