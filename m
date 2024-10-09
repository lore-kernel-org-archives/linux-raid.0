Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD1A17CA09;
	Wed,  9 Oct 2024 07:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728458081; cv=none; b=aET0e9wTEfkROzufGUqiOL/8VZXDklameXx4Jl+YzpNpCX1NQEfTqtuQNu+dgLH8q6MqbxU7SrO/QLLxFCFzPxyB54DDJLn1lPpXFnbfhkV2/a6CZ/+By61Rsx0xKZCoW5WNdwqUGYAh3SjzcFtK8pnSa+AyZIqHp6hZyoxlUdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728458081; c=relaxed/simple;
	bh=CyqdWzPrkB0dFXNWvRNB5w1mYjYxOS+k9dp5IAy4x0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eS0tjs3ja+b16TzGiGWGBidhcW6oOaB6eIxcX37sZK3DxzCPSlns+u0stC24oyLd/6D7wT1Aev9aoBtIpAdACGNicWQFRuuHUGQ33cEY6HnweEF72XcqU7QPDtrgjYwexPrSz63VIGLhpnnxQ8EZ0auBADhbEp/B3eBMq5chhkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f9j2YbiH; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f9j2YbiH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728458079; x=1759994079;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CyqdWzPrkB0dFXNWvRNB5w1mYjYxOS+k9dp5IAy4x0Y=;
  b=f9j2YbiHen+pe9IJAdVM8Rbf7PSYZi/sgcZPu6oBrN3aYY+CleYiwIMB
   iZxjZdJ9gCab2Hdsr2Bu/YxddKFcklSVCwf55+vgvkkWQHO0yjDBr/MjV
   WolPSJM2oKBeswh5lSlC/XY+nyG/FGcieqPueH+cLPywZaf3fTA91Y2jS
   LHoP1wNUO75XVTsInE45HzBSZHCEmuHpLSkmsYpy7G8GgV9QE5BuvBB07
   BA4gErmT2qbcvInwZkG8EXYyq+kdq8TOngl+/KvwPm0vCthTQVhkwfeQZ
   iV168Y/aNmGntUJNgRuRvZ7jbwlviVJR/MdY8d3My+yQrEHUIaDlLdzdy
   A==;
X-CSE-ConnectionGUID: kfPiCW8QR1iRQNtYLo8DwQ==
X-CSE-MsgGUID: Pt/ugWM2QTaYKfh7HENrOw==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="30614648"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="30614648"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 00:14:38 -0700
X-CSE-ConnectionGUID: aa/m5ifNTpGTEA0KW3TXyA==
X-CSE-MsgGUID: CS+l9GoJRUO0Bf+zx2LF2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="80732847"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 00:14:36 -0700
Date: Wed, 9 Oct 2024 09:14:32 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
Subject: Re: [PATCH md-6.12 0/7] md: enhance faulty chekcing for blocked
 handling
Message-ID: <20241009091432.00001c26@linux.intel.com>
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


Hi,
We tested this patchset.

mdmon rework:
https://github.com/md-raid-utilities/mdadm/pull/66 

Kernel build torvalds/linux.git master:
commit e32cde8d2bd7d251a8f9b434143977ddf13dcec6

I applied this patchset on top of that.

My tests proved that:
- If only mdmon PR is applied - hangs are reproducible.
- If only this patchset is applied - hangs are reproducible.
- If both kernel patchset and mdmon rework are applied- hangs are not
  reproducible (at least until now).

It was tricky topic (I needed to deal with weird issues related to shared
descriptors in mdmon).

What the most important- there is no regression detected.

Thanks,
Mariusz
