Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122FC192D60;
	Fri, 30 Aug 2024 11:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725016353; cv=none; b=jWVc9GbFEJ11UqfVeTKv2RN6BwpAcMSeUz3YNWRDbnM7hTz8fzX9BYyuK6LEmzxn4RoGgAUwJrbMlc39HYkKiB/D+ErEs4jdyyp0OC7gUTCFSZYqlQL1S05fruo7neISrO/chJMcnglf8I8ijIMvFT/Uyrf8fldEnucVtFa4KZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725016353; c=relaxed/simple;
	bh=Mm2ryxK9cgrNWbIdIzIOzLeHvtD9PPpe3P/fDgYZDJs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M5FDLuy03TkMVoXAfotlMxiit3rmlThiyxB/IzCi8Q1UfYRBlUJm+Mt89oTecZku0xyAeXwP3k7Y1l/DVfBu2Z4Yl4296G9F1mQimi0f5yYjZVZRPFE4ArCBzsN8YQ4W0Zwiw3N9voZqjoiSiL8dBdY4jnWTDLbFP3SmRT615hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZDiZCgN4; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZDiZCgN4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725016353; x=1756552353;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mm2ryxK9cgrNWbIdIzIOzLeHvtD9PPpe3P/fDgYZDJs=;
  b=ZDiZCgN48vl5eGkLaM8JnCWNTKJJzl7k6/ouIQbeu4dkoDYN6uXmUKjt
   I1Sk0N9ZkimFNVnRSPjCnHkfEHB0/g/msqlmP1xdbuORLTYPfsFmBlLdL
   9qlWHgTqW+/XNdDRMP2hQQPFLfK4QSjQIemeTshZI/B5u59yP8QnwOGG+
   CIH2+SETTamuCRZumjYxEGZy4bfY6b2s4xBQJjtPj/IAgu6CiJylHD26U
   gjY3oLqiR83NX9DHK8xsEd1q+3joPCDzTKyALlFWzp7sZr8E58ghq6PsY
   KotZCG02zEdn6cDmLDMjpIpKGM2CArBH+3P7dMiA2D9wwszaeidkdhh5Z
   g==;
X-CSE-ConnectionGUID: 8wSZuwVSTZi8PUdT7yZGcQ==
X-CSE-MsgGUID: Rbsm9DPCSqqmEFiK1sLrWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34814833"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="34814833"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:12:32 -0700
X-CSE-ConnectionGUID: zwoFdLDtRIirEWqvOjJprg==
X-CSE-MsgGUID: xFbrO0dgQRK8xO4cY0t//w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="87107713"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.96.27])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:12:29 -0700
Date: Fri, 30 Aug 2024 13:12:24 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: song@kernel.org
Cc: Yu Kuai <yukuai1@huaweicloud.com>, mariusz.tkaczyk@intel.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH md-6.12 0/7] md: enhance faulty chekcing for blocked
 handling
Message-ID: <20240830131224.00001114@linux.intel.com>
In-Reply-To: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
References: <20240830072721.2112006-1-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 30 Aug 2024 15:27:14 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> The lifetime of badblocks:
> 
> - IO error, and decide to record badblocks, and record sb_flags;
> - write IO found rdev has badblocks and not yet acknowledged, then this
> IO is blocked;
> - daemon found sb_flags is set, update superblock and flush badblocks;
> - write IO continue;
> 
> Main idea is that badblocks will be set in memory fist, before badblocks
> are acknowledged, new write request must be blocked to prevent reading
> old data after power failure, and this behaviour is not necessary if rdev
> is faulty in the first place.
> 
> Yu Kuai (7):
>   md: add a new helper rdev_blocked()
>   md: don't wait faulty rdev in md_wait_for_blocked_rdev()
>   md: don't record new badblocks for faulty rdev
>   md/raid1: factor out helper to handle blocked rdev from
>     raid1_write_request()
>   md/raid1: don't wait for Faulty rdev in wait_blocked_rdev()
>   md/raid10: don't wait for Faulty rdev in wait_blocked_rdev()
>   md/raid5: don't set Faulty rdev for blocked_rdev
> 
>  drivers/md/md.c     |  8 +++--
>  drivers/md/md.h     | 24 +++++++++++++++
>  drivers/md/raid1.c  | 75 +++++++++++++++++++++++----------------------
>  drivers/md/raid10.c | 40 +++++++++++-------------
>  drivers/md/raid5.c  | 13 ++++----
>  5 files changed, 92 insertions(+), 68 deletions(-)
> 

Hi Song,
We need to test this with external metadata so please wait for our green light
before you will take this.
I checked the code and it looks safe but I need to double confirm it to avoid
hung tasks.

Thanks,
Mariusz
