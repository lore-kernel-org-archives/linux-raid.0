Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DAB13E024;
	Thu,  4 Jul 2024 07:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720076857; cv=none; b=DTd/9003Gh4zGVgR+DlijAh8rFsPkCU9YyJnPJrnpetlHYg6+X+15v9RtOt86gvGtt6AkfrB08hYYcQcZqQ0kdS8mXSG3RKxCIOxOAAQci2kyMNIsbNqdolGxNjV/+aN4aSkR6XvfIyDN17aU1AfpN2pf4nELwf45tb2yRc8bl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720076857; c=relaxed/simple;
	bh=7tHjEgxLF6D3N7x7Mn/S5C4zsq33ZNyCftsNFYoXxuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TCD6KJm304h30pw6sZVz3dEameqdiuzYiuvlbYLQ9U4LgbdhiOg4TK1jKg81hULq5Xh/7xdbvuqbOCbJHvZEpuAsXVsUZYDICGWY2FmTW6ZBRg1gqKCVJSsGGs+QSlLcP0R3/Pq/mOuqDHY7+3q+3X6uIN45qNZ6y1VxGPAYY+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFkU8jaT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFkU8jaT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334A6C4AF0B;
	Thu,  4 Jul 2024 07:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720076857;
	bh=7tHjEgxLF6D3N7x7Mn/S5C4zsq33ZNyCftsNFYoXxuc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eFkU8jaTCwdFdZNYvUP6rjOKJR92ZeRaaj+LBNkJ1YVRrsALMbSl6VBdUJEw0kgG/
	 2ZD2wWZZgYjFI6qRivISI2X2aRg6lCiAU3R3PLQxo7ticXDwBBu1PAFga7asWdmUwP
	 NckRJ7iRTO4QppYZmjLiCu2Znx3U99e5Mj73U0ptgZTf4WVHwEhVjiITPdgY1id3qK
	 uosal/Tm6vm8EaFMLSYdlw8v/HJjB7WbfZ4MT0Z5MbAJ8iufREpTDcYgBAs+jLumUL
	 9ZK1kUW4I+hhJ0YWbnJQt7OTDYQmkuOjZPU9uuuciJABtSEP2AoZ1lBsEZh/RyMLu8
	 L5foWguew74Hw==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52e991fb456so323786e87.0;
        Thu, 04 Jul 2024 00:07:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUEbMawgNNZoaPD7S8jSA2rhUif4PrrI+k59VDoU5K7C3sseOvIRdqsxAmROx5S2EwdjkoovB1/TL6o3y4U5pEFX1T0C+KZeEV46ejRyz86rCCBdsG2QdDZu5zWTZqmwwxVX9SmGFt4vg==
X-Gm-Message-State: AOJu0YxiXMc+nedpzuMwp8F57qq4MpAVBlaZnLeFw3nl2nYV5EL+AcEP
	Sjq3AsMPfIretA8ncaSoMVFjQmDkdgSOppBWAMiJIFfM5j5DhPeRrdkIpVYO9/6//5ByzQOymon
	wwZs8uP85U0QVS0Y8Rp8mycQ6S7Y=
X-Google-Smtp-Source: AGHT+IEvCJFpVEFFDyQwBZIDINy8/ck6TwDciOQiRbfdwRftLedpoK16ri0k+dbjhQs4maLjozc6JS/hW0KLCJJ1vfM=
X-Received: by 2002:a05:6512:3e24:b0:52c:ca8d:d1c with SMTP id
 2adb3069b0e04-52ea0dcdbb8mr232910e87.2.1720076855574; Thu, 04 Jul 2024
 00:07:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618010759.85416-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20240618010759.85416-1-yang.lee@linux.alibaba.com>
From: Song Liu <song@kernel.org>
Date: Thu, 4 Jul 2024 15:07:23 +0800
X-Gmail-Original-Message-ID: <CAPhsuW5WnfCJHP08zLr1uYZSCEGVCddKXEkU_v_GDerC31mpZQ@mail.gmail.com>
Message-ID: <CAPhsuW5WnfCJHP08zLr1uYZSCEGVCddKXEkU_v_GDerC31mpZQ@mail.gmail.com>
Subject: Re: [PATCH -next] md: Remove unneeded semicolon
To: Yang Li <yang.lee@linux.alibaba.com>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 18, 2024 at 9:08=E2=80=AFAM Yang Li <yang.lee@linux.alibaba.com=
> wrote:
>
> ./drivers/md/md.c:630:21-22: Unneeded semicolon
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=3D9344
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>

Applied to md-6.11. Thanks!

Song
