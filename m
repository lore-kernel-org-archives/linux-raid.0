Received: from mail-108-mta69.mxroute.com (mail-108-mta69.mxroute.com [136.175.108.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD7E238C3B
	for <linux-raid@vger.kernel.org>; Sat, 25 Apr 2026 08:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777106817; cv=none; b=owSn0pFS7yWNdjr6CVbwSCmPK4I5vJXPVYQf8tjg8OTvrYDemZHe1ru/3qLTzGJq7D4MA+hGnr4QUz4rRd5/ZWQT1+4tcisPuU/FgShmhWlaqmkHYe5XmmmJG2pq35OVVPMAuftCXJhom7z8Fx8AHCV/ar34sSn7iMh2FAKmYzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777106817; c=relaxed/simple;
	bh=Mf8kX3uVom5w+mO0rvmZFmAlF2VEx6xv/pFp7ddlqDY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nzc9aW0uDu2fUCS48p0jdtpfdWCtUK/aAVEGaDXAtMHGBgYXZs0c2aQ/RwAV6+0X71CtwtDJMk58v4djFvZPyLGhjd7DVhqpVZVOQq0JlQIv1EuQxd+GXg5JVIsPL95RqCa0CeLgN8yIEC5VQdU4Gy6t31HlJJjz0rvswlDZoMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=TX8Pr2F/; arc=none smtp.client-ip=136.175.108.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="TX8Pr2F/"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta69.mxroute.com (ZoneMTA) with ESMTPSA id 19dc3cd4dd400067f7.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Sat, 25 Apr 2026 08:41:45 +0000
X-Zone-Loop: 2f681e1a535e30c95af519d2c291367a5ae0c8187ccb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DwLHyBG+p0hCqcq/H1br0H7dLP9YnGTDFsaesFdN6hk=; b=TX8Pr2F/FS18XimUWYqWG24rsu
	ppxqqz0F62pcLwrHsiSdBZ0tebJKJkKHieLNN/CNkPqoCAckWyzhdBJ/GDi91L1SRnjDk/Yeshqzc
	AF0Z53kZBCoFTZKvBrmb5sHN8TmUqqUl+b2YVBA7GBs6p2w9t1GVOIsbcuymEUNQjW2bbg/yvwjVi
	vllxyx8yEh4C4bbjIzNKi0gqD5Qq4mr99YJJDHpzHeGpriP8E6gfkKqhONzpQcE/+CaRByAEDnCYh
	QAVXexGpgfgr7Tfa/ETb1wweqpJs6bOjVcASDm77jDRF8kxclQxF7LYyw2Dooz2v4q0N7Pk0V1stm
	3hJQOBdg==;
From: Su Yue <l@damenly.org>
To: Yu Kuai <yukuai@fnnas.com>
Cc: Song Liu <song@kernel.org>,  glass.su@suse.com,  Li Nan
 <linan122@huawei.com>,  Xiao Ni <xiao@kernel.org>,
  linux-raid@vger.kernel.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 0/3] md/md-bitmap: restore bitmap grow through sysfs
In-Reply-To: <20260425024615.1696892-1-yukuai@fnnas.com> (Yu Kuai's message of
	"Sat, 25 Apr 2026 10:46:12 +0800")
References: <20260425024615.1696892-1-yukuai@fnnas.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Sat, 25 Apr 2026 16:41:31 +0800
Message-ID: <qzo35t50.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Sat 25 Apr 2026 at 10:46, Yu Kuai <yukuai@fnnas.com> wrote:

> mdadm --grow adds an internal bitmap by writing bitmap/location 
> for an
> array that currently has no bitmap. That requires the bitmap 
> directory
> and location attribute to exist before the classic bitmap 
> backend is
> created.
>
> This series separates bitmap backend lifetime from bitmap sysfs 
> lifetime,
> splits the sysfs layout into common and backend-specific groups, 
> and adds
> a small "none" bitmap backend. The none backend keeps 
> bitmap/location
> available while no real bitmap is active, and the location store 
> path can
> then switch between the none backend and the classic bitmap 
> backend
> without tearing down the common bitmap sysfs directory.
>
> Patch 1 factors bitmap creation and destruction into helpers 
> that do not
> touch sysfs registration.
>
> Patch 2 splits the classic bitmap sysfs files into a common 
> group and an
> internal-bitmap group, and converts bitmap backend operations to 
> use a
> sysfs group array.
>
> Patch 3 adds the none backend and uses it to restore mdadm 
> --grow bitmap
> addition through bitmap/location.
>
> Changes since v12:
> - Keep the factoring patch focused on no-sysfs bitmap lifetime 
> helpers.
> - Make bitmap operation lookup depend only on the current bitmap 
> id
>   matching the installed backend.
> - Trim the none backend to only the operations required by the 
> active
>   call paths.
> - Rework bitmap/location error handling with explicit cleanup 
> labels.
> - Restore the none backend after bitmap removal and 
> creation/load
>   failures so bitmap/location stays available.
>
> Validation:
>   - create a RAID1 array with --bitmap=none
>   - verify /sys/block/md0/md/bitmap/location exists and reports 
>   "none"
>   - mdadm --grow /dev/md0 --bitmap=internal
>   - verify location switches to "+8", mdadm reports "Intent 
>   Bitmap:
>     Internal", and /proc/mdstat reports a bitmap
>   - mdadm --grow /dev/md0 --bitmap=none
>   - verify location switches back to "none" and only the common 
>   location
>     attribute remains under md/bitmap
>   - repeat the internal/none switch once more
> - Checked the QEMU serial log for panic, Oops, BUG, WARNING, 
> Call Trace,
>   RCU stall, and hung-task patterns; none were found.
>
> Yu Kuai (3):
>   md: factor bitmap creation away from sysfs handling
>   md/md-bitmap: split bitmap sysfs groups
>   md/md-bitmap: add a none backend for bitmap grow
>

Thanks for all.
Would you like to add tag Fixes: fb8cc3b0d9db for the whole series 
while merging?

--
Su

>  drivers/md/md-bitmap.c   | 131 
>  +++++++++++++++++++++++++++++++++++----
>  drivers/md/md-bitmap.h   |   2 +-
>  drivers/md/md-llbitmap.c |   7 ++-
>  drivers/md/md.c          | 125 
>  ++++++++++++++++++++++++++-----------
>  drivers/md/md.h          |   3 +
>  5 files changed, 218 insertions(+), 50 deletions(-)
>
> base-commit: c85d314b135ff569c1031f2ef8e40368bcfe72ac
