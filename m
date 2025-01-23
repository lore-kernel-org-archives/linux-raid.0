Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3751E6F06B
	for <linux-raid@vger.kernel.org>; Thu, 23 Jan 2025 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737655319; cv=none; b=s/atTrr3/034Jy2Ny2s8GdhoyofdiheuIuemJXOeLTNnFKUCgByoxaPPjsZTqNpNefbctuewWcKN4MmdMKl7rdyIWk1CmkRVAAwjSvu7conkUSypFlykU/ZySkwdk9VfSM+p08FuuLmAHnikN7ZtPzDM2f94VL8duXkSaNNmWK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737655319; c=relaxed/simple;
	bh=hYWGhNTCNI2AIhLl617O+rwudkkcKDWjUBOxkauwkjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MiI1LR2VUEDNIhMXF1QLFcgTv8lv2UHkoahmg38u6ZQxLqaj6CwDzgvi3vZo2hOLlMt5/t6jOtaaT841VeX1iHxYXRRS+4NaSG9uKq8KAY4+uCpOAVcUV1U6nlc0aBevabBSCortAEPnIk05bH72ZJcQX/MZs0IW3bYGzCzGAqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aIvxWmRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aIvxWmRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BC5C4CED3
	for <linux-raid@vger.kernel.org>; Thu, 23 Jan 2025 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737655318;
	bh=hYWGhNTCNI2AIhLl617O+rwudkkcKDWjUBOxkauwkjA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aIvxWmRqjCaZ9sRBuINvhOpb34H04O62AojcI8l255KiwlmjlEEwDxZEhqdQBA+id
	 geovmeaLcvKnxRZZIA1eaLnqwz+Wu0rgqSOjs70oAGousCvUaj9Gw7f36YDamsDi/6
	 WIOZr/SArKSd18YzzJ2Bh2yaRoUMTpQqFXBjIzONk50uPV2V7st3akJ4NtRn+dp/nd
	 eC0gd0HG4OBH7bcxd3hY+LtLolkNtJ3qNYnDPBaFSwUX4sG1hcy0KTr+3yC05gq3sP
	 7ZICr+oaat4qVR6G8Rku4sotEvB/rQqdmJVbMcdnGkZ5zrsDhJ/WfdM6nF8KALtTmA
	 cK0IUo0EHyoxw==
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3ce6b289e43so10007925ab.3
        for <linux-raid@vger.kernel.org>; Thu, 23 Jan 2025 10:01:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX42+VnOvr2fjS3Q+ALfgZ833H5pU/fsPoDgZY5465YWMS5uvJOsYm/W6kpir0Ud24I//WYjWN2sp+y@vger.kernel.org
X-Gm-Message-State: AOJu0YzxSLty82icU5otDi7kEdIdFbffi70UkajSueeQL7MLSdNgSlVM
	o9Hzk2s3lSmAr5YIw/hbdHOnFRHFqUxmxKcKWtTa2GHIbOo1e4iQuYgzpR4FU1jVWy6X0vDhcUg
	lF9/VhxAzADHemWl5tMjSzLVsFJQ=
X-Google-Smtp-Source: AGHT+IFaK05OqARHQD6Epa22hMYVF8NasHZxczJ69QvnRqRBoeEOTQ0iDhkooSQfUViB+JE3f2+OJ+Fa6CsiyLuh3V0=
X-Received: by 2002:a05:6e02:b4c:b0:3a7:e86a:e803 with SMTP id
 e9e14a558f8ab-3cf743f8834mr234959075ab.8.1737655317990; Thu, 23 Jan 2025
 10:01:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjqFwETu8ZwE44jdNWk=UYbdoNJr0W7pjkgjkTy0ff8grA@mail.gmail.com>
In-Reply-To: <CAAiJnjqFwETu8ZwE44jdNWk=UYbdoNJr0W7pjkgjkTy0ff8grA@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Thu, 23 Jan 2025 10:01:47 -0800
X-Gmail-Original-Message-ID: <CAPhsuW56KORS78c-buACrq0TWJ+qewwh+QUmC-ePJO3LVVjeyQ@mail.gmail.com>
X-Gm-Features: AWEUYZlgpZA9s5tRkIITEOHvGoSWR9a2yoTXbas5dM7laFef9cFtvZh3sbpVrEU
Message-ID: <CAPhsuW56KORS78c-buACrq0TWJ+qewwh+QUmC-ePJO3LVVjeyQ@mail.gmail.com>
Subject: Re: Huge lock contention during raid5 build time
To: Anton Gavriliuk <antosha20xx@gmail.com>, Shushu Yi <firnyee@gmail.com>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Anton,

Thanks for the report.

On Thu, Jan 23, 2025 at 5:56=E2=80=AFAM Anton Gavriliuk <antosha20xx@gmail.=
com> wrote:
>
> Hi
>
> I'm building mdadm raid5 (3+1), based on Intel's NVMe SSD P4600.
>
> Mdadm next version
>
> [root@memverge2 ~]# /home/anton/mdadm/mdadm --version
> mdadm - v4.4-13-ge0df6c4c - 2025-01-17
>
> Maximum performance I saw ~1.4 GB/s.
>
> [root@memverge2 md]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
>       4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] =
[UUU_]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>......]  recovery =3D 7=
1.8%
> (1122726044/1562681344) finish=3D5.1min speed=3D1428101K/sec
>       bitmap: 0/12 pages [0KB], 65536KB chunk

Given the rebuild speed of 1.4GB/s, which is pretty fast,  I do
not think this is a regression. Lock contentions in raid5 stack,
including but not limited to the bitmap, is a known issue. We
need major work to make it faster so that we can keep up with
the speed of modern SSDs.

>
> Perf top shows huge spinlock contention
>
> Samples: 180K of event 'cycles:P', 4000 Hz, Event count (approx.):
> 175146370188 lost: 0/0 drop: 0/0
> Overhead  Shared Object                             Symbol
>   38.23%  [kernel]                                  [k]
> native_queued_spin_lock_slowpath
>    8.33%  [kernel]                                  [k] analyse_stripe
>    6.85%  [kernel]                                  [k] ops_run_io
>    3.95%  [kernel]                                  [k] intel_idle_irq
>    3.41%  [kernel]                                  [k] xor_avx_4
>    2.76%  [kernel]                                  [k] handle_stripe
>    2.37%  [kernel]                                  [k] raid5_end_read_re=
quest
>    1.97%  [kernel]                                  [k] find_get_stripe

Could you please do a perf-record with '-g' so that we can see
which call paths hit the lock contention? This will help us
understand whether Shushu's bitmap optimization can help.

Thanks,
Song
