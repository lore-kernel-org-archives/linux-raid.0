Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131C71836CB
	for <linux-raid@vger.kernel.org>; Wed, 10 Apr 2024 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712785020; cv=none; b=mczBabeCv6OajxhvGSGAR3/2sSDdd39QW7/dEcR+YQkk/PsF4SWFkHTkAEUBzpnypm1EbjBFCWU4oGlaeVclxUHa5nsD+D33BCuDC5kHohVgm2LCGOpulvPxMtwX3uY3U0kRgbPpOl0QFd2Sk6pDSGf5DejVo1RlLZSgXsH9iUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712785020; c=relaxed/simple;
	bh=WYDgR8qaRzJOlArK+2/wrAZsnMDiRHpZRRCY9I1H5uo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UPFKRRMUMcfF1pyIhhEd687pypNnO7FONyO74K6iewanBJEsCnIfyEEZgnmIPM1zLtzJHHJC60ue64PnbGgjFpAcF5FsZbXpXm4JxO/mRWU0gmdbAw0BlCBuiZRUCudGP0iMNwmooeyCjqBGNXEuGhwM8CXRvUx7A1LHgU4WMqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XNYDFejR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XNYDFejR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A26C433C7
	for <linux-raid@vger.kernel.org>; Wed, 10 Apr 2024 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712785019;
	bh=WYDgR8qaRzJOlArK+2/wrAZsnMDiRHpZRRCY9I1H5uo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XNYDFejR+dQfiu5GSWqt0joEBLc4E5WOhOS3mlnIcfW5BAJ2Wzhdl1mUdQf4AFinf
	 5yPENB6GdEmfPEK76JMTzs85ME8whsQSVdU840k1TAerYaxIGfoPWeD5YlOwqKU5/M
	 wqES6UeeJq5cGwsAbnTLctQ8Ov6rfpKo5vmNa65tHOATkr6z0wZ0f/qRWkHZ+s18VN
	 AV6xjMO9HF948Kf/heAMGLz0Gqf9pg8re6HdhkNOIFVGsPBfYzZSIQ9lluNzgGXNc8
	 0+22ue3Jly49+xOjaeMxyyIv7E00CttK+Mp7UXHl2W5mBM+4ZzlwMU+hczxgBRP8fH
	 UTg5jKcZ3Ygqg==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-516d536f6f2so6189037e87.2
        for <linux-raid@vger.kernel.org>; Wed, 10 Apr 2024 14:36:59 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzb72kmlZ9pMcDD/rK92YZlGPanNoTWKSxc5rx+Yefui3oM/MuA
	2Z2vRtdlk3suDdOyRk/piGbkzBOkLHy/NMUphG2yeY2DznayNVvz47+zDTD3pRpRuqmgoQGzH/T
	eIdRMAIyWIgg1G5nTDFFX99U17yk=
X-Google-Smtp-Source: AGHT+IHOi0zhMijUyIgFnNxrfJD374WfV7z3yPYsLwp2nOX8sYBfHp7wXR4w8HwvX1ELg/TE+4vRdSqm+Z/hKZq6y04=
X-Received: by 2002:ac2:4d03:0:b0:516:ce9a:fb73 with SMTP id
 r3-20020ac24d03000000b00516ce9afb73mr2736491lfi.43.1712785017911; Wed, 10 Apr
 2024 14:36:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240327114022.74634-1-jinpu.wang@ionos.com>
In-Reply-To: <20240327114022.74634-1-jinpu.wang@ionos.com>
From: Song Liu <song@kernel.org>
Date: Wed, 10 Apr 2024 14:36:46 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6hXm3nZd_BbD2=LriZwiLRGSiCx_ZMsC1qx8C4huCgzw@mail.gmail.com>
Message-ID: <CAPhsuW6hXm3nZd_BbD2=LriZwiLRGSiCx_ZMsC1qx8C4huCgzw@mail.gmail.com>
Subject: Re: [PATCH] md: add check for sleepers in md_wakeup_thread()
To: Jack Wang <jinpu.wang@ionos.com>
Cc: linux-raid@vger.kernel.org, 
	Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>, Yu Kuai <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 27, 2024 at 4:40=E2=80=AFAM Jack Wang <jinpu.wang@ionos.com> wr=
ote:
>
> From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
>
> Check for sleeping thread before attempting its wake_up in
> md_wakeup_thread() to avoid unnecessary spinlock contention.
>
> With a 6.1 kernel, fio random read/write tests on many (>=3D 100)
> virtual volumes, of 100 GiB each, on 3 md-raid5s on 8 SSDs each
> (building a raid50), show by 3 to 4 % improved IOPS performance.
>
> Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>

Applied to md-6.10. Thanks!

Song
