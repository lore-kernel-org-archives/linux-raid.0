Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F231D12E9
	for <linux-raid@vger.kernel.org>; Fri,  8 Nov 2024 07:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731051637; cv=none; b=WabfJPOfv4V3//fokv1C4c2YTgmIOXtDT6I9npIGNnkboVCkZ1ZyV+7MzwnUPR4NBoUzNWUl0y3K/kBWU6ocvaVq6ouOCCyy4tCW1xNIFe04dVcy0RercO1QtxJi397sbOVhwaAFFlamprfvUR06eDPFsK+dESoD34qW6o31yr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731051637; c=relaxed/simple;
	bh=CUcoB5tMmAWbql2/eH8gFKUy/lPr+suTWZrqIkYID1w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rX3fHfk9kOph2RUJUbYrZmrJg58Uvop2Kll1Lj9VnrksKis9I2d9AEPKHU36CvbLXcSnDORJSf3gAzYcODD89i4U9ub3KHOd47RWPLFVX9B8ZSK5B+NX/bNkXMPqUhNZUtHRyk54OJv2UvU31OPn+4f1m64utz8FPovsUOCnTtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VY/rwTAd; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VY/rwTAd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731051634; x=1762587634;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CUcoB5tMmAWbql2/eH8gFKUy/lPr+suTWZrqIkYID1w=;
  b=VY/rwTAdCm4gbpV9+pSt6158M/QdI1k0fwwEEFMTywe6KJb2n4TYvs8t
   wTLSWPv/szY+9JA4uD0AVGBhqrhBPcGnWTFZzrX9KfcRGjE5TcvZ4ettj
   5VHwmLyeJuU0o5Y3G21XYoeNsGu84mM+JHSzXsqnyYeJZzuhMfBIXYbEA
   SVbX+OZfftTXlAfPoXDL+pfJq8qscvaf3Qn1VwccyCKM7MY3c7vpDO51E
   0F55tUCv8rYBrhYgGF0L2avnXX9SiYMDKsrOCMWsEcRwOyWwXYbl7e8Ok
   h0rimkSh479rvwsYOJ/LYS6mSBZ7E59mFz0NktQbfw+wV6stwG8f5xiCQ
   Q==;
X-CSE-ConnectionGUID: UAthHwBfTamBva+55sKPeA==
X-CSE-MsgGUID: 5JL1q1TFQhmMZ3yyiS4DzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="30326304"
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="30326304"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 23:40:31 -0800
X-CSE-ConnectionGUID: +SIk/8rHTYCHlaQ9pcRilQ==
X-CSE-MsgGUID: 4KaWbD+DRI+Xk62RzLwFFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,137,1728975600"; 
   d="scan'208";a="85664593"
Received: from lkotynix-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.112.32])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 23:40:31 -0800
Date: Fri, 8 Nov 2024 08:40:27 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, yukuai1@huaweicloud.com
Subject: Re: [PATCH] MAINTAINERS: Make Yu Kuai co-maintainer of md/raid
 subsystem
Message-ID: <20241108084027.0000194b@linux.intel.com>
In-Reply-To: <20241108014112.2098079-1-song@kernel.org>
References: <20241108014112.2098079-1-song@kernel.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  7 Nov 2024 17:41:12 -0800
Song Liu <song@kernel.org> wrote:

> In the past couple years, Yu Kuai has been making solid contributions
> to md/raid subsystem. Make Yu Kuai a co-maintainer.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e9659a5a7fb3..eeaa9f59dfe3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -21303,7 +21303,7 @@ F:	include/linux/property.h
>  
>  SOFTWARE RAID (Multiple Disks) SUPPORT
>  M:	Song Liu <song@kernel.org>
> -R:	Yu Kuai <yukuai3@huawei.com>
> +M:	Yu Kuai <yukuai3@huawei.com>
>  L:	linux-raid@vger.kernel.org
>  S:	Supported
>  Q:	https://patchwork.kernel.org/project/linux-raid/list/

Well deserved, Congrats Kuai!

Mariusz
