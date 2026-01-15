Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50469EACD
	for <linux-raid@vger.kernel.org>; Thu, 15 Jan 2026 23:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768520803; cv=none; b=B/On7JrEWYz+ZpYZG1aQ/k5kA7RM7QotJb2McaGIzOc7A8Jlj5NGDFFKPINtZXieq366ooxPmulBVQK1MOt02WrV4egf8OyY9VW7edr0RcfFIeey6snKL3AQpzYG0p/76qMk6NQLoUSi6P8KOHiSK4iiKzfCxbXrWgu8UW1xpX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768520803; c=relaxed/simple;
	bh=L+EIaSyOM5lBjnsOsp96OkICljBYP6050txWWmTQj/I=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=DR/eGDanCt94QUAfqO32HRpupG6b6svA3xpXx6DJj/rhm2JdrvwvQl2EXS2/oheBLHgZ9F1EZGytsLQht7VWRqkgwAK1pTIuI4IpzJ7VfR5+cM4Wfobh8il4cErDGg1MqNqXUVqBKXyeeXAWXNVj4gDY+X3hMjaIcFaITx9pjsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b=K7ZBo/Yb; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b="K7ZBo/Yb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stoffel.org;
 i=@stoffel.org; q=dns/txt; s=20250308; t=1768520290; h=mime-version :
 content-type : content-transfer-encoding : message-id : date : from :
 to : cc : subject : in-reply-to : references : from;
 bh=L+EIaSyOM5lBjnsOsp96OkICljBYP6050txWWmTQj/I=;
 b=K7ZBo/YbQkXEMrN84qf99CL0UeL6sX5tGe2r0iX3F5D1Es+rE8XA1oUD0HmkLQCAOf0Vw
 lNQ/W/0OH2Moyf6MHsCbB+PN4qpg+OEJBL9vjN3IA8Fe+OGfSpjC+3B5rxD1XzhOSj/7c4B
 QQ7Px6ajvdJxvxeY3EJXmggfNazB4hZnIJCDhisE8MlicfYvCel/KYfKWE4ZigQ0AKqKHpG
 gfuTrIfTPcQrUxmdhiZvXEE9Rk6eNkGbCbi1pR/aOIvMxmD6SFBV2ROE7oaz65pMI3PTqas
 X1uR4YwFX23E9rBcpSpSseZGBvzTGRcpjS++FtzShVfn6+3x4JbI75dwJFjw==
Received: from quad.stoffel.org (unknown [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 3ADF61E6D9;
	Thu, 15 Jan 2026 18:38:10 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 8BF37A25F4; Thu, 15 Jan 2026 18:38:09 -0500 (EST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26985.31329.553315.375744@quad.stoffel.home>
Date: Thu, 15 Jan 2026 18:38:09 -0500
From: "John Stoffel" <john@stoffel.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org,
    linan122@huawei.com,
    xni@redhat.com,
    dan.carpenter@linaro.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: [PATCH v5 00/12] md: align bio to io_opt for better performance
In-Reply-To: <20260114171241.3043364-1-yukuai@fnnas.com>
References: <20260114171241.3043364-1-yukuai@fnnas.com>
X-Mailer: VM 8.3.2 under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Yu" == Yu Kuai <yukuai@fnnas.com> writes:

> This patchset optimizes MD RAID performance by aligning bios to the
> optimal I/O size before splitting. When I/O is aligned to io_opt,
> raid5 can perform full stripe writes without needing to read extra
> data for parity calculation, significantly improving bandwidth.

> Patch 1: Fix a bug in raid5_run() error handling
> Patches 2-4: Cleanup - merge boolean fields into mddev_flags
> Patches 5-6: Preparation - use mempool for stripe_request_ctx and
>              ensure max_sectors >= io_opt
> Patches 7-8: Core - add bio alignment infrastructure
> Patches 9-11: Enable bio alignment for raid5, raid10, and raid0
> Patch 12: Fix abnormal io_opt from member disks

> Performance improvement on 32-disk raid5 with 64kb chunk:
>   dd if=/dev/zero of=/dev/md0 bs=100M oflag=direct
>   Before: 782 MB/s
>   After:  1.1 GB/s

My only comment is how is performance impacted at other block sizes?
And smaller RAID5 arrays?  What about RAID6?  

And more importantly, are random disk writes impacted?  It's great
that you have gotten streaming direct writes faster, but have other
writes slowed down for the common case?




> Changes in v5:
> - Add patch 1 to fix raid5_run() returning success when log_init() fails
> - Patch 12: Fix stale commit message (remove mention of MD_STACK_IO_OPT flag)

> Changes in v4:
> - Patch 12: Simplify by checking rdev_is_mddev() first, remove
>   MD_STACK_IO_OPT flag

> Changes in v3:
> - Patch 5: Remove unnecessary NULL check before mempool_destroy()
> - Patch 7: Use sector_div() instead of roundup()/rounddown() to fix
>   64-bit division issue on 32-bit platforms

> Changes in v2:
> - Fix mempool in patch 5
> - Add prep cleanup patches, 2-4
> - Add patch 12 to fix abnormal io_opt
> - Add Link tags to patches

> Yu Kuai (12):
>   md/raid5: fix raid5_run() to return error when log_init() fails
>   md: merge mddev has_superblock into mddev_flags
>   md: merge mddev faillast_dev into mddev_flags
>   md: merge mddev serialize_policy into mddev_flags
>   md/raid5: use mempool to allocate stripe_request_ctx
>   md/raid5: make sure max_sectors is not less than io_opt
>   md: support to align bio to limits
>   md: add a helper md_config_align_limits()
>   md/raid5: align bio to io_opt
>   md/raid10: align bio to io_opt
>   md/raid0: align bio to io_opt
>   md: fix abnormal io_opt from member disks

>  drivers/md/md-bitmap.c |   4 +-
>  drivers/md/md.c        | 118 +++++++++++++++++++++++++++++++++++------
>  drivers/md/md.h        |  30 +++++++++--
>  drivers/md/raid0.c     |   6 ++-
>  drivers/md/raid1-10.c  |   5 --
>  drivers/md/raid1.c     |  13 ++---
>  drivers/md/raid10.c    |  10 ++--
>  drivers/md/raid5.c     |  95 +++++++++++++++++++++++----------
>  drivers/md/raid5.h     |   3 ++
>  9 files changed, 217 insertions(+), 67 deletions(-)

> -- 
> 2.51.0


