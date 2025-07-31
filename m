Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0152DBA33
	for <linux-raid@vger.kernel.org>; Thu, 31 Jul 2025 16:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753979526; cv=none; b=RWzPxqQIkqa2RfZpKN0xwuql7c9o6Ox/m30WIDqOsvFqbKFiYASd/w/749WVEss7j48Dar03LMBDSGlViKzlfX0Z3/ZzetXPWUtKCyNKH4miXzVnUXlhu+bK2l30jdbMiywS69ehIBA8dK4xx+nvlxbL3PucGn2BfXzOL8OkTGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753979526; c=relaxed/simple;
	bh=j3h/CPw/2enrgRsclTtsDWJZ1awyyG6QncJ2SLhQWvc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=LmAlGh+5U4XPcc3VGBqux1qCRgFnjDrmgNQR2T263T0qScF//wQT4lySK9NR9eMiLy9p0QuT4Qf+OGZ4BaYEHf67vnS0CYjnnrwf9C/uQdG8kXAJGZ+Swd0KzpkDQvZ2Ajn72+P0uWz0x37Y6oIgeJ+to7WCFC8ApUGdgAbE2M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Blwet3rf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Blwet3rf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5352C4CEEF;
	Thu, 31 Jul 2025 16:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753979525;
	bh=j3h/CPw/2enrgRsclTtsDWJZ1awyyG6QncJ2SLhQWvc=;
	h=Date:From:Reply-To:Subject:To:Cc:References:In-Reply-To:From;
	b=Blwet3rfSCO9QVFONKr0t0SEU9PyMNyOoTF0Jed+vjoCXOAF72QpgrhJogCu9Z755
	 g+Y8n+/UgWSvyFV2DyAjmoLEpAJfK1Z79/ZuXgigznXhS54j1zjEhfi96RgLAw2uCj
	 5B8hCvgHlKBUCWpuPeFDp1TpfPI58a4IIMRCqN7S29/6Siy3OZChAj2ukwdtd1Bj1N
	 X/i60efbB5A66foD8ff5glN3Bb/NmswvLF/1xN/509cSp8dpBIqaiENk9K4gUN363J
	 7B7XX+XBU0xDF/XwqlTrfV9wjtCfpRel0/nlwFHO8pW+zawBxuCXkMfE3d1V5hWXnw
	 ftb8+AXXxECrQ==
Message-ID: <97e26eaf-bcf3-4f3d-9128-1723607e478f@kernel.org>
Date: Fri, 1 Aug 2025 00:32:02 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: yukuai@kernel.org
Reply-To: yukuai@kernel.org
Subject: Re: [PATCH -next] md: make rdev_addable usable for rcu mode
To: Yang Erkun <yangerkun@huawei.com>, song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, yangerkun@huaweicloud.com
References: <20250731114530.776670-1-yangerkun@huawei.com>
Content-Language: en-US
In-Reply-To: <20250731114530.776670-1-yangerkun@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2025/7/31 19:45, Yang Erkun 写道:
> Our testcase trigger panic:
>
> BUG: kernel NULL pointer dereference, address: 00000000000000e0
> ...
> Oops: Oops: 0000 [#1] SMP NOPTI
> CPU: 2 UID: 0 PID: 85 Comm: kworker/2:1 Not tainted 6.16.0+ #94
> PREEMPT(none)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> 1.16.1-2.fc37 04/01/2014
> Workqueue: md_misc md_start_sync
> RIP: 0010:rdev_addable+0x4d/0xf0
> ...
> Call Trace:
>   <TASK>
>   md_start_sync+0x329/0x480
>   process_one_work+0x226/0x6d0
>   worker_thread+0x19e/0x340
>   kthread+0x10f/0x250
>   ret_from_fork+0x14d/0x180
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
> Modules linked in: raid10
> CR2: 00000000000000e0
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:rdev_addable+0x4d/0xf0
>
> md_spares_need_change in md_start_sync will call rdev_addable which
> protected by rcu_read_lock/rcu_read_unlock. This rcu context will help
> protect rdev won't be released, but rdev->mddev will be set to NULL
> before we call synchronize_rcu in md_kick_rdev_from_array. Fix this by
> using READ_ONCE and check does rdev->mddev still alive.
>
> Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
> Fixes: 570b9147deb6 ("md: use RCU lock to protect traversal in md_spares_need_change()")
> Signed-off-by: Yang Erkun<yangerkun@huawei.com>
> ---
>   drivers/md/md.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
Applied to md-6.17

Thanks
Kuai
