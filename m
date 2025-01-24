Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E554C1E7C0F
	for <linux-raid@vger.kernel.org>; Fri, 24 Jan 2025 21:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737755321; cv=none; b=QWvfv388LXgWHBgyOX+UKA/LutzHTrLN6rVWopw+RhcKBqN7aw8oy//Xw5IBv3mFApkSxE5U7RY8R5Vz9/2qqm1poTcBVU1o6FJ+1VQbnOQFEkz6g9RUlR2szRABww3ZOVzIbc7iYCyYVjHgnVQbCTOmY1CyKFjC4gzWlB7GBeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737755321; c=relaxed/simple;
	bh=w5z5dw/5BDXUq2g+SBCuJU59nzQuKlKiJTXusWnJ6LI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kLXUofzdWvy+X3Za3l0D0t6NM1wGSC17UUTEOiNuntEEena0wxFyp3XXamU9CFDtJMr2zsFEGWuRr4Tsotin+vXQn0nBf97ad+Huum0SwOTLJM5+zCm96BVcVOxTz3zy5oRfVaGO6Pr2vt0cLQolxuuJJuat5dDd/LqJBm8cvrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aLsdLiRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aLsdLiRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587F2C4CED2
	for <linux-raid@vger.kernel.org>; Fri, 24 Jan 2025 21:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737755319;
	bh=w5z5dw/5BDXUq2g+SBCuJU59nzQuKlKiJTXusWnJ6LI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aLsdLiRR2R7M2NbLPNTnmgreGB1ZHVuaqssHwZtzR3TMgIIGfcozhMHttTXULlPvd
	 mWW95ZWhw18cDh/PVqIJ24rdaeHiO4pHwTufzv1EpW3L0rsI9vxt4FcqLwjf22qTez
	 Wo/u3OZL17L3fGeq84JT+hdS7QTHzGQ0vEtOKH6q2/KGKw0EwbWYerJyIHjZgh64+4
	 kkKCdSqaayKrqTskFogK2nPxHNMH399sK44GqVhy2tzaOjMxBC/vAxH9Bv0p+aeLdk
	 w0zinHTRPLeVb8pmxrm9hhCr/PaT/R20XdhZIgDZHwJlK7I8tqBvwOQ9JpKrhwKJdx
	 INiOaVivcV7kw==
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-844dfe4b136so65157739f.3
        for <linux-raid@vger.kernel.org>; Fri, 24 Jan 2025 13:48:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWw/j9RLsa06/grjDbZ40S38ZeHl1Q9dihxJmPourbQ0tvBct1WMgDVTauE4H0ThntwK3nktV42Z3xk@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0yk8MNsucDBxE0Gpd/RIxXq3pvF9GtPsONPKCNXfQ96I25SQd
	Okm9A+J/mCPE2jGA5mGbX3Oy/DkOh3PpQGc47Uq4au3SWOOTkjtB+19f5I45XSDapGXPrty2rKN
	cGuchQewjn31qR+YZz5J/9QDLGqs=
X-Google-Smtp-Source: AGHT+IEWqgU3EQsr0RjK38VK0rFdQH39lXWAi98evib834jOb0lwlzq/N2N09l07+hiPU+vFDbDkiwfjpcCyx64yelk=
X-Received: by 2002:a92:c245:0:b0:3cf:bc71:94ee with SMTP id
 e9e14a558f8ab-3cfbc719535mr65124095ab.14.1737755318678; Fri, 24 Jan 2025
 13:48:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjqFwETu8ZwE44jdNWk=UYbdoNJr0W7pjkgjkTy0ff8grA@mail.gmail.com>
 <CAPhsuW56KORS78c-buACrq0TWJ+qewwh+QUmC-ePJO3LVVjeyQ@mail.gmail.com> <CAAiJnjpTAXz8TyhKD4DmpgYJ21CRJh-bLEOqZUitWYONumggAw@mail.gmail.com>
In-Reply-To: <CAAiJnjpTAXz8TyhKD4DmpgYJ21CRJh-bLEOqZUitWYONumggAw@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Jan 2025 13:48:27 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7gjyCRdHp3cRFgNxMO2kXAjMOYgW+ekqBMX18d4657Yg@mail.gmail.com>
X-Gm-Features: AWEUYZnqVQuOGQF3LcYC_zfth3wcw01smH9Vw-aIfPcXqMZwsQdkfbGQGPxRitA
Message-ID: <CAPhsuW7gjyCRdHp3cRFgNxMO2kXAjMOYgW+ekqBMX18d4657Yg@mail.gmail.com>
Subject: Re: Huge lock contention during raid5 build time
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: Shushu Yi <firnyee@gmail.com>, yukuai3@huawei.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 24, 2025 at 12:00=E2=80=AFAM Anton Gavriliuk <antosha20xx@gmail=
.com> wrote:
>
> > We need major work to make it faster so that we can keep up with
> > the speed of modern SSDs.
>
> Glad to know that this in your roadmap.
> This is very important for storage server solutions, when you can add
> ten's NVMe SSDs Gen 4/5 in 2U server.
> I'm not a developer, but I can assist you in the testing as much as requi=
red.
>
> > Could you please do a perf-record with '-g' so that we can see
> > which call paths hit the lock contention? This will help us
> > understand whether Shushu's bitmap optimization can help.
>
> default raid5 build performance
>
> [root@memverge2 ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
>       4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] =
[UUU_]
>       [>....................]  recovery =3D  0.3% (5601408/1562681344)
> finish=3D125.0min speed=3D207459K/sec
>       bitmap: 0/12 pages [0KB], 65536KB chunk
>
> after set
>
> [root@memverge2 md]# echo 8 > group_thread_cnt

Yes, group_thread_cnt sometimes (usually?) causes more lock
contention and lower performance.

> [root@memverge2 md]# echo 3600000 > sync_speed_max
>
> [root@memverge2 ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
>       4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] =
[UUU_]
>       [=3D>...................]  recovery =3D  7.9% (124671408/1562681344=
)
> finish=3D16.6min speed=3D1435737K/sec
>       bitmap: 0/12 pages [0KB], 65536KB chunk
>
> perf.data.gz attached.

Could you please run perf-report on the perf.data? I won't be
able to see all the symbols without your kernel.

Thanks,
Song
