Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A0F15F301
	for <linux-raid@vger.kernel.org>; Fri, 10 May 2024 08:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715328452; cv=none; b=l0ekXNX04MMtmVCOo/vq4VMKCNomkRquxlMSOxOncxPht3k0dL02vGrcBhmLdQfzQiOjMjonUt4l5tlrDgN8Zil3FQRkjA5qmxu4dYj5XwaJzQ6s9EPdyUKFaoAQZqgmvaV+MdyhORcDOgLlCYgrylpOfPwXLncSFGTYK7e83H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715328452; c=relaxed/simple;
	bh=eFZWO7GsP22cNpdNBOjEgttnPW9wFi4ew1zg4eLKkoE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l32oq1CftH6C0uSAyAOi4ZD1KpUh9S2m9W8tRRx+bQNaAGkz9IxwOn5FXNgqmqCxX+dch4dJkHMLOg7sv8P7HiB9Z3pfnC+ruAvpB5yvUG+dvr+FBoMLqC//rQFVwpT73D0hZ863g4IMkNOhgm6i6EWeFPHm6cisrwamxGY9yRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U8dxdE3H; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U8dxdE3H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715328452; x=1746864452;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eFZWO7GsP22cNpdNBOjEgttnPW9wFi4ew1zg4eLKkoE=;
  b=U8dxdE3HbkAThtCL/v/tJvypbCYjWr3tkmEbK6K8wgZ7TMeg1mDasHG/
   xKmJwAN3RQXLKQft4g0mAF+ekO9UK0Zly90vElduNOZ8eKK9u2Ivdt9NC
   6rJKrX6sxxf/LPGNT7mAtI/1ySTzP9bdEN/DPuBk6+rS5Pc9jIKw4H9hP
   Nka0Y7Gx2PrdLZZLeQg6f3mEsjeukKMFOnxc78TlyrNjK4uVYcSbvkOC9
   VpFVXJP8NU29cP5/DQd/J7ukcNH4J2xW/FqeWBd8MYTRAa5pop7miivXo
   /YF7oqW/v4cSXDPEh0at+4C8V8rNHlKwbR1P2QBdC2jtxvcWtkNyel1w9
   Q==;
X-CSE-ConnectionGUID: ofwhEQIjQgO1A45I+nowag==
X-CSE-MsgGUID: Ec4ckriuSvquolQSUKc1GA==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="22702877"
X-IronPort-AV: E=Sophos;i="6.08,150,1712646000"; 
   d="scan'208";a="22702877"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 01:07:30 -0700
X-CSE-ConnectionGUID: 1SVPxAxOQDyg7E1nj5meOg==
X-CSE-MsgGUID: sPh7qJIKQaqdk4ZMRgcJmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,150,1712646000"; 
   d="scan'208";a="30094836"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 01:07:28 -0700
Date: Fri, 10 May 2024 10:07:20 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] tests/23rdev-lifetime: fix a typo
Message-ID: <20240510100720.0000699d@linux.intel.com>
In-Reply-To: <20240509011059.2685095-1-yukuai1@huaweicloud.com>
References: <20240509011059.2685095-1-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  9 May 2024 09:10:59 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
> From: Yu Kuai <yukuai3@huawei.com>
> 
> "pill" was wrong, while it should be "kill", test will still pass while
> test thread will not be cleaned up.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---

Applied! 

Thanks,
Mariusz
