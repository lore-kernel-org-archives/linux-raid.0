Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D916156669
	for <linux-raid@vger.kernel.org>; Wed, 20 Nov 2024 10:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732098462; cv=none; b=Dy5EWZnUsc7y6OT8AlEWNNQijSAGKOUzlHhnc2xTDpJq+6lkniqi1liY0KLYIrlZDm4LGX2DZIe29WrxGorC2Owb8EfHB9wjhd+ABe9wAvkRuZF8hhaq6iJPmhW3amAEhp6jiLK6aSq/6Q7zORENoFGZaYOnzltm3bQQUY1pc6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732098462; c=relaxed/simple;
	bh=1qGUxIRAC0IpXfIYnzvHgMvYSB1SJeL0KaSUT7jbay8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WsAm6QTjKsRh4dWdekTaS3RYblZ/YPspkx8NEp3/b73BMPlUlNBUAICtSx6QA+uQ2/xSgXBgEzyU84/4AaC6ug8W/oqYgXeRytbVYJTGfAujALmDDEyEiLbhXLO0nSJ4B2ZCJgbWGzWDg25UGkbHoheo7+P3mxbtFy7Uqa6DoAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oJYSM+MX; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oJYSM+MX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732098460; x=1763634460;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1qGUxIRAC0IpXfIYnzvHgMvYSB1SJeL0KaSUT7jbay8=;
  b=oJYSM+MXpn1krT1rkUnTZnlrr0nGBMbGz2O6yQ1XQDyacfujNwJBt0jM
   M5i5O892IvIRmzBvFFIoyQGmWJyoBdS5ZPzLbnXPV+ELucnE1YOc2w359
   EUlhGKBRYH/AJE3lBwPMkaoyG74Wq0Hg3CpX9J1n06UjmNfp2Ptj/p9SL
   efoIJbIFIEdHvRXv6QUmrInQsZYIQC3ISNncRFOsYbJUccyONEUz2UWaB
   lofpQWyvJjKEnS95ztmLYZ8JjcjMmRQ/lhYHXPHCI6GHqVH9FjdjxFmiQ
   ydcbf1hVSD+pW2P0Mo24sa1Xegb3dtuFKM/rzXTi5wqFvauEZZl8U1RJV
   g==;
X-CSE-ConnectionGUID: tckfoUeUR9mnPRwYC/4n1Q==
X-CSE-MsgGUID: R762GIV4RumqXWOuN5EFkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11261"; a="43547608"
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="43547608"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 02:27:40 -0800
X-CSE-ConnectionGUID: imkipjz2SNSQ/wYwQSbU4A==
X-CSE-MsgGUID: gldxiCEoQcqA2GEdUzxlJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,169,1728975600"; 
   d="scan'208";a="89854480"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.20.233])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 02:27:39 -0800
Date: Wed, 20 Nov 2024 11:27:30 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v3 3/4] mdadm: remove bitmap file support
Message-ID: <20241120112730.00002cbe@linux.intel.com>
In-Reply-To: <20241120064637.3657385-4-yukuai1@huaweicloud.com>
References: <20241120064637.3657385-1-yukuai1@huaweicloud.com>
	<20241120064637.3657385-4-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Nov 2024 14:46:36 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> Because it's marked deprecated for a long time now, and it's not worthy
> to support it for new bitmap.
> 
> Now that we don't need to store filename for bitmap, also declare a new
> enum type bitmap_type to simplify code.

Thanks for the enum! I really appreciate the additional effort you took to
make mdadm better.

I didn't not review it line by line because I see the problem that must
be resolved first.

I see that you added BitmapNone and BitmapUnknown and their usage is not clear,
let me help you!

BitmapUnknown should be used only if we failed to parse bitmap setting in
cmdline. Otherwise first and default value should be always BitmapNone
because data access is always highest priority and dropping bitmap is always
safe. We can print warning in config parse failed or bitmap value is repeated-
it is reasonable. If I'm wrong here, please let me know.

+ It would be nice to add tests to cover these config/cmdline bitmap
  possibilities to define clear set of expected behavior. It is something
  already missed so I do not require that strongly from you know.

I propose you to create mapping_t for bitmap and to use map_name() to match the
bitmap strings, instead of hardcoding them but it is my recommendation not
something strongly required.

Then, you would be able to remove some checks for both (s->btype != BitmapNone
&& s->btype != BitmapUnknown).

The change proposed by my will provide clear differentiation between error
value and set of accepted values, messing that is always confusing for
maintainers end readers. I don't see that kind of mess necessary in this case.

Thanks,
Mariusz
