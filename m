Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84252318152
	for <linux-raid@vger.kernel.org>; Mon,  1 Dec 2025 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764598514; cv=none; b=cZhI6lsv3PHwu/RAu6h8xgA4Usyx4NRy4Xn2zGsX13Hh1OCqmYHetjElz+PLlxAXQLHjq8xnBPye7UZ3wbjhErzzf4hjd79rx1vwwHEOSx/TKvlBkWSr80fZoV2+9pHu9G71XY2q+cqVjGwmskn45yX2Gdig3UpTuTr53AT0cOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764598514; c=relaxed/simple;
	bh=nUZmg6mIKsML2KO+xPPWVYxDwTLQ1ULJ0C1rbIr/U18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jimdM/9WyrjyPa3HUyneZbkMC0THdEmgrf5pXIBKMTnD0jkhejUFMOFxwLeooXl1frJqF8u8BMuNgtsvhkvJ+ZQsXK2QWa1FhxgTOglfAj7KePzBDe4UvJ3oKEMh0z+y/UlMRe6fOzhsDYdltvsXijZgDC2AWtVJY4ukzmzJOUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com; spf=pass smtp.mailfrom=lucidpixels.com; dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b=e0wvQm+b; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b="e0wvQm+b"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7c75dd36b1bso2667361a34.2
        for <linux-raid@vger.kernel.org>; Mon, 01 Dec 2025 06:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google; t=1764598511; x=1765203311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nUZmg6mIKsML2KO+xPPWVYxDwTLQ1ULJ0C1rbIr/U18=;
        b=e0wvQm+b3FU/2m0aO2i+NxRimN+jB1pGElzDZnvalgKk5+ogyNNxfkCzifsfxf9K9V
         dWG12beB1X6tsfXSaWVosTxz4wSnnkdMAPI59siW4DPfFM/K2fBrix58qgacBbV+q70S
         y2mu3jSsL8LVTSc9uXnwijCtzMRO32EzsdpfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764598511; x=1765203311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nUZmg6mIKsML2KO+xPPWVYxDwTLQ1ULJ0C1rbIr/U18=;
        b=wyRSvxSbDvRJGmJSqNvFGtKC/F2QhTCUozBqpYDpMrecyP+4rnir2nmIiuu1CkWRFe
         2ZVuOT0UosrO3IU55bknD88sA6Tx7I0N/Z2G/3xK0hAVUEVpbTLwthNogjTZ/DlqUL8I
         ei4xb8bnidXHwZpFO5fBlXk5m8P/4/GR23DA/W3FSx9OzSGxH4h9OuGZZZzCtt/aCqGR
         S06BOYLrBg/gKP7msZeim9fXu3EJ8YJsLO9gwvGdYjDjkik++i0s91blQTFPIZJ9ijuQ
         Rl6JPwbX/9WBcgKZ8lcHzq6BljGD2WNHFUH2Et8zskBjxTO+WOgwl7hXpUhJI++VX6yQ
         QeyA==
X-Forwarded-Encrypted: i=1; AJvYcCUVYUL1hfZztHsxSdeVGQM2hKH8Q7MMO/87cKXkleqJeS2t+KTPKy2vkR3u2/BwTnqmmD2QJHta3Xez@vger.kernel.org
X-Gm-Message-State: AOJu0YwVbPH5GiYxLrApJt4dnUMdeDxOH/GZ9D3293DYi2I083kklkSV
	GVaPUFgPtwnS/rOIzgY7gbEx4aFNh25ihz9M/kfL7iYAVkcQwzqE5/ixgsGkdbBsgNzBWMaFQzj
	dM+MN9d36PdIqq5IU0GviRih385LpWw5pKt5wP3LNeVuWijS1L7OS
X-Gm-Gg: ASbGncuKyA8pxOBHEjMN2wXzOCCppz8e2yxgJnGE3qbWBP0hWHVD0VdHvPuLu0nUeIc
	TgYVWzaA3C2g1IASjcMCLDUQDndu7gzIt/ceUWk4kQ65I5vInt3Tx34qBsYVa5PB+4Ibjo8kYmx
	Ih5cvhvCQI7AoK/dvfTWmsFbQ4CFcE2HWxFM5VXy/xnNxvJDQupfoWspVfh2bJB0JZtVxx/Ieqi
	6uirs0QmBtcWBs808at5KQJc05zLbolzOOdNlFkhVYwZSoPn4V9ABWvG66PzdxthHwHJqqpr8Kn
	31x2Rg/VpaAefXMh0TRrSIIgsG5Qah38+qBLHGzJPr1d11w+TTQtCDIOtYN/Tmk=
X-Google-Smtp-Source: AGHT+IHwLRhS/dOTGy6I8v5RYfy93HQulXXIBuzwmVuIczi0e5dazOauHFCbbBEKS0ayTSTOGt0n/BqP/mu9/5Egnuw=
X-Received: by 2002:a05:6830:6d4d:b0:7c5:2dbf:4a7d with SMTP id
 46e09a7af769-7c7c4417c31mr12280576a34.31.1764598511215; Mon, 01 Dec 2025
 06:15:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO9zADxCYgQVOD9A1WYoS4JcLgvsNtGGr4xEZm9CMFHXsTV8ww@mail.gmail.com>
 <CALtW_ajVLbtUfVkKZU3tsxQbHMZsJR=jHK7PQNmvmSgjVhiUyg@mail.gmail.com>
In-Reply-To: <CALtW_ajVLbtUfVkKZU3tsxQbHMZsJR=jHK7PQNmvmSgjVhiUyg@mail.gmail.com>
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Date: Mon, 1 Dec 2025 09:14:58 -0500
X-Gm-Features: AWmQ_bmQKzJp8vegg4_XTBzVGnygRRMsorS4OWzCZ1CSI1CpVlRXj1d1R7Yz57E
Message-ID: <CAO9zADx+5cNAxaz4R7SAndY5EX1z4V8i1e=rAdBbOTmxLmcopw@mail.gmail.com>
Subject: Re: WD Red SN700 4000GB, F/W: 11C120WD (Device not ready; aborting
 reset, CSTS=0x1)
To: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2025 at 10:19=E2=80=AFAM Dragan Milivojevi=C4=87 <galileo@p=
km-inc.com> wrote:
>
> > Issue/Summary:
> > 1. Usually once a month, a random WD Red SN700 4TB NVME drive will
> > drop out of a NAS array, after power cycling the device, it rebuilds
> > successfully.
> >
>
> Seen the same, although far less frequent, with Samsung SSD 980 PRO on
> a Dell PowerEdge R7525.
> It's the nature of consumer grade drives, I guess.

As this affects multiple NVME manufacturers, are you aware of any
consumer-level NVME drives that do not have this problem or is moving
to U.2/U.3 server drives necessary to avoid drives dropping offline?
