Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ED110E9
	for <linux-raid@vger.kernel.org>; Sat, 16 Aug 2025 00:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755305465; cv=none; b=XacOfX28Ns69kOEP/b52bp0CRNBg3HMYMgspKuPEN0oSF8cIZKr7u/zxurA/yQ6n46+uwwN0NMzsLQSUMiny0KInc+2OnEd0EdeFBA/ionKrh6J7PorPZJ26UHFcm43mxEXhk+bjYSJguPKgQt4I5qf7TrNzxiMyYKL04kQzPPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755305465; c=relaxed/simple;
	bh=vABayknF5d+TvOnl1DLwLxU5QZGxlOnJwbkRHlmhCQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0e/UOgO1sgv0NJ4s9iS9IoH+gvmerRyZo6c5OMwfRk0/BJlFCY3Vq1Jx4yfvjUR9oXq421xH62knBM1lDukm4fMi+dJCvf1Eo0fXw0jcPOjp952+3g9/daUImM/edVOAFF5VZIbaE7XL+yXh4v+hNvlSsjx9ezHyskGYJxLuE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0dmaNS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0dmaNS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B10DC4CEEB;
	Sat, 16 Aug 2025 00:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755305464;
	bh=vABayknF5d+TvOnl1DLwLxU5QZGxlOnJwbkRHlmhCQg=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O0dmaNS8B5Yo/pDYQ93MnhMrUbJCw90c6d6uDnHllBVpREI5iUy7F4kPcgBPcLRQN
	 /4ps9UOU74ASdhznoMadKAodU4pwfHG7gsirQrIOMFp6HOBgm6s1nC+dKJxDb5IaJR
	 Zv69ylj0D3gMcoydvr6Swut4ACZHxYq8myFbtRnkQw7EMOahjPlpudZ0uAivRu70a2
	 f9UCzieghz4j63VxhNLEfH1DqI1O08KpexGJ3D/6lgyHTA23qxV2oORWEpxmByO7dG
	 Ima9NXq4JkZaRzuvVg7A4NtSmO04/7AowdeJ/hwa+pE6KoV24uTkTeKJc1lNG/sBxi
	 lMCbREDyt+FUw==
Message-ID: <095e7386-a497-4eca-a77e-68e3222bdfca@kernel.org>
Date: Sat, 16 Aug 2025 08:51:01 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH 1/1] md: keep recovery_cp in mdp_superblock_s
To: Xiao Ni <xni@redhat.com>, yukuai3@huawei.com
Cc: linan666@huaweicloud.com, linux-raid@vger.kernel.org,
 yukuai1@huaweicloud.com
References: <20250815040028.18085-1-xni@redhat.com>
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <20250815040028.18085-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2025/8/15 12:00, Xiao Ni 写道:

> commit 907a99c314a5 ("md: rename recovery_cp to resync_offset") replaces
> recovery_cp with resync_offset in mdp_superblock_s which is in md_p.h.
> md_p.h is used in userspace too. So mdadm building fails because of this.
> This patch revert this change.
>
> Fixes: 907a99c314a5 ("md: rename recovery_cp to resync_offset")
> Signed-off-by: Xiao Ni<xni@redhat.com>
> ---
>   drivers/md/md.c                | 6 +++---
>   include/uapi/linux/raid/md_p.h | 2 +-
>   2 files changed, 4 insertions(+), 4 deletions(-)

Applied to md-6.17

Thanks

