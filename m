Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808D074040
	for <linux-raid@vger.kernel.org>; Wed, 20 Nov 2024 10:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732098997; cv=none; b=EKrxRqARe+Rid8WRYqeL2iJqod7Qd7lr2RwHVqmNeRT8944div4GB8sI5g0wwH/GlJLBPBwBwP1TksoiSJtCiy1d2zrHrM8yOXqeB7ot7XGPI8X/j/gitD+avERA4aJxbgbeh4kMT2myz3/SCDbR6If/J9qECQBrSIw3MY2Ahpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732098997; c=relaxed/simple;
	bh=agA5bfOIfUZWS6Ha2gsPG5xn2DC3hubtZOcSpNVTesQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FvK3Q0aFLMAU+wg9BTp83YsO8Wn6Bxm4tkiTx+cdhsOs/AkURdqFVVgEASZ+PodmXe3GZaxR+lI5nKZpLzBY9a7pqtH9Brsy5xvm/ganxKcsRMXDCm7Y7eAXpUjzYeb7Tv4Q3gPCGvdU4wc2NCy45em0LRpA2awuU3PuOLnCeBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BxdqVwLc; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BxdqVwLc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732098995; x=1763634995;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=agA5bfOIfUZWS6Ha2gsPG5xn2DC3hubtZOcSpNVTesQ=;
  b=BxdqVwLco1Sr3/NjP0dvh4oivNfyE9gfOkp6Jh5ojwFio1R77g6uzRte
   ctRRm04a749UEbzo/hDmmZfGsT5UeCrxsJOkwuYyqPezNf4HRDxxRaJeq
   HgtEVVAToPN2f189nl0jTaXW/ryIOfQqKSwdwanINTAYlk/gvW1XjxWT+
   XQkUgYSV1NqD9HTbnf0t2DhPglUKHg6RdGvW9MVll1hjvCrMB8FwVn4EG
   y2TnZw7aqYxOqWoRR4RXyf4YsZpsqOLpd7BySby3hmr8/BV7rZxGj0Kq6
   vo5/A1PF1BNVuQ5Cif1aI1mD0nsHD4YrBF0/fQvdLtgIfRv/f17j41EA1
   w==;
X-CSE-ConnectionGUID: 0kxx1jzrSPe/D1QLZS6SHQ==
X-CSE-MsgGUID: CidYWzgBT4qHzTBcZAf2Hw==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="42769389"
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="42769389"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 02:36:35 -0800
X-CSE-ConnectionGUID: F3kbEdMDQgGlTDKXY0bh+Q==
X-CSE-MsgGUID: livdR4ZbSgycGNBKIJ06fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="94933913"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.20.233])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 02:36:33 -0800
Date: Wed, 20 Nov 2024 11:36:28 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v3 4/4] Manage: forbid re-add to the array without
 metadata
Message-ID: <20241120113628.00002fd0@linux.intel.com>
In-Reply-To: <20241120064637.3657385-5-yukuai1@huaweicloud.com>
References: <20241120064637.3657385-1-yukuai1@huaweicloud.com>
	<20241120064637.3657385-5-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Nov 2024 14:46:37 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> re-add will not trigger full disk recovery, user should add a new disk
> to the array instead. Also update test/05r1-re-add-nosuper to reflect
> this.
> 

Description miss information about blocking --re-add for external :)

Please add something. I know it is not supported, I just need some note like:
"I was never supported for external metadata and behavior is undefined? (please
check at least with IMSM), block it"

If it fallbacks to standard --add I'm also fine with the change because we are
making clear user interface and this will be help to avoid abuses and bug
reports. Probably no one is using that with external- I think we can take a
risk here.

For the code, LGTM.

Thanks!
Mariusz
