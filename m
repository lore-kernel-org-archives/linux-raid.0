Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E4B1A0711;
	Thu,  4 Jul 2024 07:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720076912; cv=none; b=Udf+wqUp9okMC05MvI9LmpTqshd4s47pF+PMuTB5V4vcKfQCKaLUfItdGLOuza7ck71NCOeZmJ3mB3f+JLSbl0Un4l0RMPzKWfhPUmB4tr4mANz5AXx2Eod38R1b36fCYhBVGc9vodWdNDD+AmPSQqTtIZoGE0OAcMrz4gRDzeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720076912; c=relaxed/simple;
	bh=5+rcqn9+rh6E0yZ3vaxBWdR5YscXhhj+nwQh+D3SEL4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mnx124zRUbdFfSfL+3FL2YdSIlC4tqyNLkk6euHveEZwTWbsiDHqaRmvSjyJGRFlCRmjwHCBluUSkezkI8x3DEP52pZpdi02mS84iJkEW6dBWLaYX8SqPE+IeeS+tpJ2F0sQT3JowKP7Wrf6aRqUuSBsCEdzrOu83OcjVcC/hPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VeSiIw3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VeSiIw3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D07EC32786;
	Thu,  4 Jul 2024 07:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720076912;
	bh=5+rcqn9+rh6E0yZ3vaxBWdR5YscXhhj+nwQh+D3SEL4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VeSiIw3FY+VlACrFYStJDk8V1HLom6KrWgUyIFix+YSk4+5bZ10sTmZ06GhsATEC/
	 ItkMjbJnP8zEU6oxOuuBSUqVYHwJoDAmjG3jZzTmNsW/p628f3BQZwRt1gByw7Tq7L
	 08vtZMVWg4ftqFHgPwGCAgtFlm8aqt0DWbzff2Vo6BGpkx0vByD1dyiNoWPtU3W3Qs
	 S6lAzxr5UiYFmktH4GATm/Zx5McMGH27Uz8Cbx+is1vLtJBKlm2fSkBrIp7Xx9vTBK
	 ZF0h0yNyOp0JVKS768ug/0uWSHRwaT4IOoWKY/al18zX5YLM2ZnQ/S1wMKPrba0HyL
	 KdifWK9BiUCXA==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52e991fb456so324515e87.0;
        Thu, 04 Jul 2024 00:08:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXl2iYWxZMWECHQLHKd7fRBismbc+XfyZ1SaW2OsNBTsWF+oI8R2eBUtqwLuT/gwnfaiDi59Ht7+anQRgkPcFJ3ki636gwyapfDKLzWR/41d5zGxsKsqxYahWQOYvJjBfYCyWXyTcNtdg==
X-Gm-Message-State: AOJu0YzBRm/3LsKfHvLFy+S08pJjqCztwQT1yQeHTk3+LIDuStez7I9r
	qO8t9mG+Ga+2kn3kNQ/lXYd3zJSSWEhMvx/GNmlJ7ZkvDdghF4TZvsabZ3/mmnyR/cNmxm8+hZJ
	2O9H2wGElINFXCELAPZmN190wRks=
X-Google-Smtp-Source: AGHT+IHaxn7o7s1EVfWyi9BkDO+k9zfBeYb2JovJXDSJlhKW3pabXDhJ4xuVaHMSFmJeG1gmkR4fzNjcuGufU83Cdk0=
X-Received: by 2002:ac2:551d:0:b0:52c:daa7:a421 with SMTP id
 2adb3069b0e04-52ea0dcdc6fmr177198e87.4.1720076910384; Thu, 04 Jul 2024
 00:08:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240627112321.3044744-1-yukuai1@huaweicloud.com>
In-Reply-To: <20240627112321.3044744-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 4 Jul 2024 15:08:17 +0800
X-Gmail-Original-Message-ID: <CAPhsuW7H3=pLA0PKpGhYxa-W-6fOeJLzCkFMLQsLOOS1KZ3tUQ@mail.gmail.com>
Message-ID: <CAPhsuW7H3=pLA0PKpGhYxa-W-6fOeJLzCkFMLQsLOOS1KZ3tUQ@mail.gmail.com>
Subject: Re: [PATCH -next] md: don't wait for MD_RECOVERY_NEEDED for
 HOT_REMOVE_DISK ioctl
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mateusz.kusiak@linux.intel.com, mariusz.tkaczyk@linux.intel.com, 
	nfbrown@suse.de, hare@suse.de, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2024 at 7:24=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Commit 90f5f7ad4f38 ("md: Wait for md_check_recovery before attempting
> device removal.") explained in the commit message that failed device
> must be reomoved from the personality first by md_check_recovery(),
> before it can be removed from the array. That's the reason the commit
> add the code to wait for MD_RECOVERY_NEEDED.
>
> However, this is not the case now, because remove_and_add_spares() is
> called directly from hot_remove_disk() from ioctl path, hence failed
> device(marked faulty) can be removed from the personality by ioctl.
>
> On the other hand, the commit introduced a performance problem that
> if MD_RECOVERY_NEEDED is set and the array is not running, ioctl will
> wait for 5s before it can return failure to user.
>
> Since the waiting is not needed now, fix the problem by removing the
> waiting.
>
> Fixes: 90f5f7ad4f38 ("md: Wait for md_check_recovery before attempting de=
vice removal.")
> Reported-by: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
> Closes: https://lore.kernel.org/all/814ff6ee-47a2-4ba0-963e-cf256ee4ecfa@=
linux.intel.com/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Applied to md-6.11. Thanks!

Song
