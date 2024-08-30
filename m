Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A13F194C86;
	Fri, 30 Aug 2024 11:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725016015; cv=none; b=iebsYmD1XUk75qW6n+K+SCeNkulHDMjaEDN4ZTAHCOc1g5fj7WlQdOaDDZiIu7/zOTpOEoVcPBLtiE9EuRoPf6G5sgT2v4CePwRP8ZpMHo2vbjcOccXJdAiuvrTEwSxwWBVms0MVrLouKATOUi+rXH5RH0rZyXsG0E2sLkvgbTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725016015; c=relaxed/simple;
	bh=5Xd1rgTZWcynNOC66b1JQ+rhSyTf83IcClna7ugABgM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=anMa27BojplGyl1hxTBOqk0tnDffu/oX/soWusyH1dga258GRfZzC1mt8CT9vjww4GtopA4wOlDXocsUR/hKzJoUtjjvoWMz1ai1qgxBSN3X16ZKj9TqxbSNpz9hdLf95xmat/95eVXXTsUThWFAkURSpIXOBjSctFAid2SN+KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EkyMYcCa; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EkyMYcCa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725016014; x=1756552014;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Xd1rgTZWcynNOC66b1JQ+rhSyTf83IcClna7ugABgM=;
  b=EkyMYcCaHUa1RqoV2JKDQUpFM3iZYxA4g/SqaDSl7fBw0y+8nsl02Agl
   xP8mp2VV8vTjsy3SqCbI8FT78PpXE58QyhOYq+aHvm3pJVeTBD13/LteR
   QLkMOfoRkaSKV2xSCYL4Hk/ljyVmpo3Er+3AWNtuj8IxCjF0NoJKZmzWC
   TcxXyuObKM2Qs2T33gSWCHWPNQueGe0WLyFVDAnaJfC/oa5deP44IrVmc
   CfMmtoJRBprcK2GehvO9imTA4d4Gq/z0/5fswNTWSoOd0VMvUd9gkn4YN
   4cBCk4gLbOyGDwAu7dH/TIUFSm2GbRA+AbIHSi+OhDglDC7oNEgyZ9h5i
   g==;
X-CSE-ConnectionGUID: 5QdEEU5bQgylOcJOFnhnKw==
X-CSE-MsgGUID: 8RhKzgFATX+zEZRI4qfNDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23517281"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23517281"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:06:53 -0700
X-CSE-ConnectionGUID: M3EBzl/FQM2Mu6ZTBetULg==
X-CSE-MsgGUID: pCaKrAHhR5iToBrWn4JGPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63706619"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.96.27])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:06:51 -0700
Date: Fri, 30 Aug 2024 13:06:45 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
Subject: Re: [PATCH md-6.12 4/7] md/raid1: factor out helper to handle
 blocked rdev from raid1_write_request()
Message-ID: <20240830130645.000076c6@linux.intel.com>
In-Reply-To: <20240830072721.2112006-5-yukuai1@huaweicloud.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
	<20240830072721.2112006-5-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 30 Aug 2024 15:27:18 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently raid1 is preparing IO for underlying disks while checking if
> any disk is blocked, if so allocated resources must be released, then
> waiting for rdev to be unblocked and try to prepare IO again.
> 
> Make code cleaner by checking blocked rdev first, it doesn't matter if
> rdev is blocked while issuing this IO.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1.c | 84 ++++++++++++++++++++++++++--------------------
>  1 file changed, 48 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f55c8e67d059..aa30c3240c85 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1406,6 +1406,49 @@ static void raid1_read_request(struct mddev *mddev,
> struct bio *bio, submit_bio_noacct(read_bio);
>  }
>  
> +static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
> +{
> +	struct r1conf *conf = mddev->private;
> +	int disks = conf->raid_disks * 2;
> +	int i;
> +
> +retry:
> +	for (i = 0; i < disks; i++) {
> +		struct md_rdev *rdev = conf->mirrors[i].rdev;
> +
> +		if (!rdev)
> +			continue;
> +
> +		if (test_bit(Blocked, &rdev->flags)) {
Don't we need unlikely here?


> +			if (bio->bi_opf & REQ_NOWAIT)
> +				return false;
> +
> +			mddev_add_trace_msg(rdev->mddev, "raid1 wait rdev %d
> blocked",
> +					    rdev->raid_disk);
> +			atomic_inc(&rdev->nr_pending);


retry moves us before for (ugh, ugly) and "theoretically" we can back here
with the same disk and increase nr_pending twice or more because rdve can become
block again from different thread.

This is what I suspect but it could be wrong.

Mariusz

