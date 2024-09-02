Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1227186601;
	Mon,  2 Sep 2024 08:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725267348; cv=none; b=uhK1snKCrRbKFvw6xSRfONCPz51w8XfoQTpxIP2seaJOHVRwJZkZVTSTaABoQFWyJyPyH+knbCGoqlAMrFIWPnBAGs0Vp7HNtmxSo7VcF5fIuh8ZkIrvKRO7WxztK3aKHqjucrLAPYAjxVSy59mTaWZkKu5MP6Xd9ZsQbsccsJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725267348; c=relaxed/simple;
	bh=RjPpSsWM3JGhvlOM4iXwIuBLlcY7GXRTmC+3FAd7xqc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OjfYS44KWUlhGe8IKIKjW4tbnQ4eWFf36K+Q8ajoGtAcuyhUtn8Boc188IdWCvatFiUhpjZlcj5GU9y5+34zFlGHVrg/bNyYObhJg0cvmJNykp62qTkgCDJM+6d2xJ78A7TpxDnC3lp8PX1HLf+56v6U3+Ss5EmgzGPJE9PUIIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NryBVvZW; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NryBVvZW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725267347; x=1756803347;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RjPpSsWM3JGhvlOM4iXwIuBLlcY7GXRTmC+3FAd7xqc=;
  b=NryBVvZW1QlTPzXydD8Z9xpYskMY/Udh2QJ31MSse+jtGCKFjf/mfWDj
   ojpulIERvU0Rg9zQsyz0WeFLcZWqQwg0ewiT/ANI1BGXDrhuX2MriiKXV
   DgvPlBrxCVtqbwgVUE6JKU9yXxnvNOAXxfjAw8QSHzwrbhJ6wC2i38HhQ
   PGjlINnahXEQYbF0xIDJn7oNHdRc4T7YzlgGTU2VIxDNHGc94Xb3n9OSR
   4p3iy4uvtBBNQtGzoDT11QGakrOonfVw+wFkmOTmFUjmK2v0aDo2tO+LC
   Hf+kZmtOszxny/P9Q1Xa4VQGKngUV1NhfB4vpdQDUDahb53B5WuBZnu8r
   Q==;
X-CSE-ConnectionGUID: NRChuXxRQaShu4jHi96ezw==
X-CSE-MsgGUID: wBD1mpflTaSgd2lVOa2O+w==
X-IronPort-AV: E=McAfee;i="6700,10204,11182"; a="23646093"
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="23646093"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 01:55:46 -0700
X-CSE-ConnectionGUID: R5S1sudLTGihBBpmjgwdFQ==
X-CSE-MsgGUID: iYXs/cqPQoe8Tt1c9wEh2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,195,1719903600"; 
   d="scan'208";a="65047877"
Received: from unknown (HELO localhost) ([10.217.182.6])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2024 01:55:44 -0700
Date: Mon, 2 Sep 2024 10:55:39 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH md-6.12 3/7] md: don't record new badblocks for faulty
 rdev
Message-ID: <20240902105539.00007655@linux.intel.com>
In-Reply-To: <c9af88ac-111e-19a2-b135-d2a379ed23fc@huaweicloud.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
	<20240830072721.2112006-4-yukuai1@huaweicloud.com>
	<20240830122831.0000127d@linux.intel.com>
	<c9af88ac-111e-19a2-b135-d2a379ed23fc@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit

On Sat, 31 Aug 2024 09:14:39 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> Hi,
> 
> ÔÚ 2024/08/30 18:28, Mariusz Tkaczyk Ð´µÀ:
> > On Fri, 30 Aug 2024 15:27:17 +0800
> > Yu Kuai <yukuai1@huaweicloud.com> wrote:
> >   
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> Faulty will be checked before issuing IO to the rdev, however, rdev can
> >> be faulty at any time, hence it's possible that rdev_set_badblocks()
> >> will be called for faulty rdev. In this case, mddev->sb_flags will be
> >> set and some other path can be blocked by updating super block.
> >>
> >> Since faulty rdev will not be accesed anymore, there is no need to
> >> record new babblocks for faulty rdev and forcing updating super block.
> >>
> >> Noted this is not a bugfix, just prevent updating superblock in some
> >> corner cases, and will help to slice a bug related to external
> >> metadata[1].
> >>
> >> [1]
> >> https://lore.kernel.org/all/f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com/
> >>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> ---
> >>   drivers/md/md.c | 4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 675d89597c7b..a3f7f407fe42 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -9757,6 +9757,10 @@ int rdev_set_badblocks(struct md_rdev *rdev,
> >> sector_t s, int sectors, {
> >>   	struct mddev *mddev = rdev->mddev;
> >>   	int rv;
> >> +
> >> +	if (test_bit(Faulty, &rdev->flags))
> >> +		return 1;
> >> +  
> > 
> > Blame is volatile, this is why we need a comment here :)
> > Otherwise, someone may remove that.  
> 
> Perhaps something like following?
> 
> /*
>   * record new babblocks for faulty rdev will force unnecessary
>   * super block updating.
>   */
> 

Almost, we need to refer to external context because this is important to
mention where to expect issues:

/*
 * Recording new badblocks for faulty rdev will force unnecessary
 * super block updating. This is fragile for external management because
 * userspace daemon may trying to remove this device and deadlock may
 * occur. This will be probably solved in the mdadm, but it is safer to avoid
 * it.
 */

In my testing, I observed that it improves failing bios and device removal
path (recording badblock is simply expensive if there are many badblocks) so
the devices are removed faster but I don't have data here, this is what I saw.

Obviously, it is optimization.

Mariusz
