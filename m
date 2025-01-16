Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988414414;
	Thu, 16 Jan 2025 18:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737053015; cv=none; b=J4sO1I5g63Lrn0DMdVgBr/Wvjb0+Gwh4WfmdF0YjnHdblrX6sOiXd8EWASNzelCVhrDqprIH/35lb/K49zvzJFKcwoV8mrhSDFULyekU+3mQur/b2AAyMZP/pIWUwCCgV2L5dvUyTyrLJsorpcb6AUq3+vquXOVglg4+EdLK/Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737053015; c=relaxed/simple;
	bh=b5S6/d/JhyirBU+ZyTJvGEq5hwDjt/ySOvXYfatARzw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KwcoLwYU/RM90AWYPcHEEoEf3KCY+APYw8ovoyg/Ld27K4MzVYG5rEEkTj29lHUXUk2aDYYS+KsJn/Xbgej7B0s7RYxk10hO9OVKF64lQhIbG5uoguH4Ft1LclOxp4hbFuZfhYgbtnUS7T+MlHv50hsxA1gAm4MoaoYj9PUzfwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmHyNmKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmHyNmKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9A0C4CEE3;
	Thu, 16 Jan 2025 18:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737053015;
	bh=b5S6/d/JhyirBU+ZyTJvGEq5hwDjt/ySOvXYfatARzw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LmHyNmKss0XuhQF5DDWcZqnuFw+IT8DxPWUHXZ9banXNgVW5Up7wWNIOI7ONaAzD1
	 ykayJpmm2xq6DwP5lgMfGbCywvbYRONED0shuIn9/Q2edYUdxcUdBp5/4azIEwlV3z
	 1XF6LY13AgqvXlJvjjFIVh2fY4HjBnWMX8iOvuEDB9JgaiUuLDe9j6lqmz1yDiq+L0
	 /EUQa1IZf7dUhnzFeCy1TxD6slC+dfIMKfwd6G8IplQr5gbaH1hqEVCiHlelD053v3
	 cbEQPPDfIYH4bgdEvTULxdxc6EdCFA3DMJhVsN77Emz/ec6QdNLDU2t2ZFeyt2U19P
	 BPRbUQeDy8tcQ==
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a81324bbdcso8775015ab.1;
        Thu, 16 Jan 2025 10:43:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUD9K/bHUE58s3vUM+Pu7xk9ULCPFUG2W3zE63xXqTqBQTeC//nEKJyUbwj3h1w4fAPVRn2fG0lFc6nlw==@vger.kernel.org, AJvYcCWLVdh1SYE/rRKKN/FKX9LUWqQxk/8LrYH9mDtbZk50o7wLqKBqW0L5VBrAEjh5mJjxcTDPVINdzwIWfTs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhsEKaCLLGBiqxzXRrZbOV0rlHUBN7i1jdrqqjxdMRkyAN6GaA
	eCKWh0Vzgq8YNaqTZdUGJMYOAzVRlTuJs308t+VPXdbIYzhAPGnePjUrZM7GsF+83sleuV0lI1e
	CSq3XCmPIqVq1UKLlJrYLRTEQQVY=
X-Google-Smtp-Source: AGHT+IFGI9BPhdEt9e6kt3wmuo0lscNvXpHpoSiu+1IL4jCGF8MF9JWjuDp43RMcOHmSUTyCTCs+y0Xp/xnXCUk09cw=
X-Received: by 2002:a05:6e02:16cb:b0:3cf:2117:eea2 with SMTP id
 e9e14a558f8ab-3cf2117f9dbmr30013025ab.14.1737053014314; Thu, 16 Jan 2025
 10:43:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250110183503.105201-1-kovalev@altlinux.org>
In-Reply-To: <20250110183503.105201-1-kovalev@altlinux.org>
From: Song Liu <song@kernel.org>
Date: Thu, 16 Jan 2025 10:43:23 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4HV0tkuFA8AQP4hZ9OxuwT_+kiqZiWBfcsXrHoaViw6A@mail.gmail.com>
X-Gm-Features: AbW1kvbSoi3WCktL9fLaSEprFPEwgpj-R2-NxRclpg8YCuT9y8uCuenjv4SUQ_Y
Message-ID: <CAPhsuW4HV0tkuFA8AQP4hZ9OxuwT_+kiqZiWBfcsXrHoaViw6A@mail.gmail.com>
Subject: Re: [PATCH 5.10/5.15] md/raid5: fix atomicity violation in raid5_cache_count
To: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: stable@vger.kernel.org, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Gui-Dong Han <2045gemini@gmail.com>, 
	Yu Kuai <yukuai3@huawei.com>, lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 10:35=E2=80=AFAM Vasiliy Kovalev <kovalev@altlinux.=
org> wrote:
>
> From: Gui-Dong Han <2045gemini@gmail.com>
>
> [ Upstream commit dfd2bf436709b2bccb78c2dda550dde93700efa7 ]
>
> In raid5_cache_count():
>     if (conf->max_nr_stripes < conf->min_nr_stripes)
>         return 0;
>     return conf->max_nr_stripes - conf->min_nr_stripes;
> The current check is ineffective, as the values could change immediately
> after being checked.
>
> In raid5_set_cache_size():
>     ...
>     conf->min_nr_stripes =3D size;
>     ...
>     while (size > conf->max_nr_stripes)
>         conf->min_nr_stripes =3D conf->max_nr_stripes;
>     ...
>
> Due to intermediate value updates in raid5_set_cache_size(), concurrent
> execution of raid5_cache_count() and raid5_set_cache_size() may lead to
> inconsistent reads of conf->max_nr_stripes and conf->min_nr_stripes.
> The current checks are ineffective as values could change immediately
> after being checked, raising the risk of conf->min_nr_stripes exceeding
> conf->max_nr_stripes and potentially causing an integer overflow.
>
> This possible bug is found by an experimental static analysis tool
> developed by our team. This tool analyzes the locking APIs to extract
> function pairs that can be concurrently executed, and then analyzes the
> instructions in the paired functions to identify possible concurrency bug=
s
> including data races and atomicity violations. The above possible bug is
> reported when our tool analyzes the source code of Linux 6.2.
>
> To resolve this issue, it is suggested to introduce local variables
> 'min_stripes' and 'max_stripes' in raid5_cache_count() to ensure the
> values remain stable throughout the check. Adding locks in
> raid5_cache_count() fails to resolve atomicity violations, as
> raid5_set_cache_size() may hold intermediate values of
> conf->min_nr_stripes while unlocked. With this patch applied, our tool no
> longer reports the bug, with the kernel configuration allyesconfig for
> x86_64. Due to the lack of associated hardware, we cannot test the patch
> in runtime testing, and just verify it according to the code logic.
>
> Fixes: edbe83ab4c27 ("md/raid5: allow the stripe_cache to grow and shrink=
.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gui-Dong Han <2045gemini@gmail.com>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Song Liu <song@kernel.org>
> Link: https://lore.kernel.org/r/20240112071017.16313-1-2045gemini@gmail.c=
om
> Signed-off-by: Song Liu <song@kernel.org>
> Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
> ---
> Backport to fix CVE-2024-23307
> Link: https://www.cve.org/CVERecord/?id=3DCVE-2024-23307

Looks good to me.

Thanks,
Song

[...]
