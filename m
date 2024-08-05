Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4763115746B;
	Mon,  5 Aug 2024 09:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722850837; cv=none; b=MQdB8KCTz6nOQmkTZqWAJl9B+W5Xz7xEb3DmZpGpgCTu3MrYayQrthbzO+VSrBxIBY+8OIQ0oFaToEanQcw5uj3lqAPvIn8olZwUyGI5rkDABJ1TLmXpm4eQkzn4AYy2N1PAqGFJKZPRyND4J1sdUmWt0KazDPJ3uOayzCN2a48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722850837; c=relaxed/simple;
	bh=SfG+bs3jPLqxWBAd+Jhpti3avHcQZ0RNdFgOa5GJiV4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TF5I8P2djImnZAFaUB7aS1Iq/ode9ZrpYH4QN3+pzosbcNCIM+HUbEqYI9Hp74OYPd4IVjQEM96478rkhSpBqYZ3lWErqqfUfCMfKdJ9NxXLv4RSwuqf2BpmYkpEMPMvuCkIAKG33eWgSajlZMpI2Ki6tzLOEhLUIu3N+SNa+Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=THZmTc+1; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="THZmTc+1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722850835; x=1754386835;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SfG+bs3jPLqxWBAd+Jhpti3avHcQZ0RNdFgOa5GJiV4=;
  b=THZmTc+1LPapDBiUNb0v0vIXSbzIKskLTyANc6oFyK4sXAjr3xPx6rPF
   DgpcviFBAWVdgqDA7XvnsGPRz314o7Rx4UK0na0Oiir3QTD+rM6nS2E7P
   x6MMzHmTMCrRAuRvPTJjzhNe6519DNjWNZgm08O15MS0m5KNFRGpXqWRP
   OAnTO0Ppr3E8IPToQ3z35bpue6rl5Q7seKUs7b3uHR0BUbDXeHFBaNCdM
   VggKo0w/gM+fSDaMZ99H8d1G3Xevm6p01qsJOeL3dFHg+QVi5LwwUFItH
   WYhLytCS6EWFYGRWq3EHXfzpfjMbjdcwM8+URHBXLskh/eb137UGVub/G
   w==;
X-CSE-ConnectionGUID: fwdZ5H2cRPm+FDTW6f4ilg==
X-CSE-MsgGUID: zyGjfuH4Sd6fAABaywFo0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11154"; a="20648323"
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="20648323"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 02:40:32 -0700
X-CSE-ConnectionGUID: 6xckBkAuS6GlS5cQzUIvyg==
X-CSE-MsgGUID: uIAuXj0PRMi6P01ESDjRDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="56667497"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 02:40:29 -0700
Date: Mon, 5 Aug 2024 11:40:24 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
Subject: Re: [PATCH -next] md: wake up mdmon after setting badblocks
Message-ID: <20240805114024.00007877@linux.intel.com>
In-Reply-To: <20240801125148.251986-1-yukuai1@huaweicloud.com>
References: <20240801125148.251986-1-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Aug 2024 20:51:48 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> For external super_block, mdmon rely on "mddev->sysfs_state" to update
> super_block. However, rdev_set_badblocks() will set sb_flags without
> waking up mdmon, which might cauing IO hang due to suepr_block can't be
> updated.
> 
> This problem is found by code review.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 23cc77d51676..06d6ee8cd543 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9831,10 +9831,12 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t
> s, int sectors, /* Make sure they get written out promptly */
>  		if (test_bit(ExternalBbl, &rdev->flags))
>  			sysfs_notify_dirent_safe(rdev->sysfs_unack_badblocks);
> -		sysfs_notify_dirent_safe(rdev->sysfs_state);
>  		set_mask_bits(&mddev->sb_flags, 0,
>  			      BIT(MD_SB_CHANGE_CLEAN) |
> BIT(MD_SB_CHANGE_PENDING)); md_wakeup_thread(rdev->mddev->thread);
> +
> +		sysfs_notify_dirent_safe(rdev->sysfs_state);
> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
>  		return 1;
>  	} else
>  		return 0;


Hey Kuai,
Later, I realized that mdmon is attached to various fds:

Here a mdmon code:

add_fd(&rfds, &maxfd, a->info.state_fd);	#mddev->sysfs_state
add_fd(&rfds, &maxfd, a->action_fd);		#mddev->sysfs_action
add_fd(&rfds, &maxfd, a->sync_completed_fd);	#mddev->resync_position


for (mdi = a->info.devs ; mdi ; mdi = mdi->next) { #for each rdev
	add_fd(&rfds, &maxfd, mdi->state_fd);		#rdev->sysfs_state
	add_fd(&rfds, &maxfd, mdi->bb_fd);		#rdev->sysfs_badblocks
	add_fd(&rfds, &maxfd, mdi->ubb_fd);
#rdev->sysfs_unack_badblocks }

Notification in rdev->sysfs_state is fine. The problem was somewhere else
(mdmon blocked on "rdev remove"). And It will be fixed by moving rdev remove to
managemon because it is blocking action now.

https://github.com/md-raid-utilities/mdadm/pull/66

I think it is fine to move this down after set_mask_bits, but we don't
have to repeat notification to mddev->state.

Thanks,
Mariusz
