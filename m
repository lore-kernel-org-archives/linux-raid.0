Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D538F17C7B2;
	Fri, 30 Aug 2024 10:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725013721; cv=none; b=rDJv2+JCcsYP/AdLctFCQoA5XBaMbpUWrLiyLBUXj2/ICfeDXXdHcZUaL9DeAI7F3GRi5rMuEua6RHlANVhceWe0FV9juJ1Kh3tvgpb5/EO5UvJ29mWEK3Id4nY6Xj/f4cNzWujU5JtMK4/K02LSMKF5bRSeTor2Xa39HAaojHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725013721; c=relaxed/simple;
	bh=hXUY+AQd6KJpCly0JZEeWSdkAfynclTeDsNGVvGmBQw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvHGlWWrSzkbs3Ctore7E3gCcueqA4zhg7cBwTx9neMp0lLGrTXbsYe3SISHAdW00lMfZ8NE5MRYzKIkiFMq9orQG7YRF0SuMsWvcZF5T0BSDdA8e7zCLTNeFSggbD2gqWqHMA7dI4CkNmtmp01FkTKB/SzN8b0/uwTxi/9u5IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fXYck+dX; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fXYck+dX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725013720; x=1756549720;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hXUY+AQd6KJpCly0JZEeWSdkAfynclTeDsNGVvGmBQw=;
  b=fXYck+dXnhmraMZF9KKsC8g7QX8lmlm7E+K9NlYJn9jd86xPglw3IgaG
   0aaDZJf2hXnq+57NOnLny9ugiAwWKRm+w2c2pHg8HQydPZ2zr7vH1u7Qw
   qyZb2wZwK5YH67h//lQpXgCoRkw9qjhzbcYJLVR0NPHfnpRBv3F8yEDQO
   kFa0XTHX2YHBEKLqaB5MvIiJxw7FBsZ5atjilPJC5HuhhAveppDoeo20U
   7rB6XW6D6Bg19J7OptCDYWnWamBk+b0vD93TRMZ65z3wfAS1EyltNhnxU
   9BIdNIw+ZIBhfWSbm/P0LiKipMU6RSyPP4LG24/x02RqvX+MaK4RxL22g
   A==;
X-CSE-ConnectionGUID: 2QXNpAs5Sl6tLFxl8iiMmQ==
X-CSE-MsgGUID: 63YCZ9tcTIOtDOOjygSh/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23805790"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23805790"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 03:28:39 -0700
X-CSE-ConnectionGUID: AX2UbQRzQ16Zj3rO651L/Q==
X-CSE-MsgGUID: tY2MFGHtRx6L5tVXAWCgDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63557482"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.96.27])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 03:28:36 -0700
Date: Fri, 30 Aug 2024 12:28:31 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
Subject: Re: [PATCH md-6.12 3/7] md: don't record new badblocks for faulty
 rdev
Message-ID: <20240830122831.0000127d@linux.intel.com>
In-Reply-To: <20240830072721.2112006-4-yukuai1@huaweicloud.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
	<20240830072721.2112006-4-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 30 Aug 2024 15:27:17 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> Faulty will be checked before issuing IO to the rdev, however, rdev can
> be faulty at any time, hence it's possible that rdev_set_badblocks()
> will be called for faulty rdev. In this case, mddev->sb_flags will be
> set and some other path can be blocked by updating super block.
> 
> Since faulty rdev will not be accesed anymore, there is no need to
> record new babblocks for faulty rdev and forcing updating super block.
> 
> Noted this is not a bugfix, just prevent updating superblock in some
> corner cases, and will help to slice a bug related to external
> metadata[1].
> 
> [1]
> https://lore.kernel.org/all/f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com/
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 675d89597c7b..a3f7f407fe42 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9757,6 +9757,10 @@ int rdev_set_badblocks(struct md_rdev *rdev, sector_t
> s, int sectors, {
>  	struct mddev *mddev = rdev->mddev;
>  	int rv;
> +
> +	if (test_bit(Faulty, &rdev->flags))
> +		return 1;
> +

Blame is volatile, this is why we need a comment here :)
Otherwise, someone may remove that.

Thanks,
Mariusz
