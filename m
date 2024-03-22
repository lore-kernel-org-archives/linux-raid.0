Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C551817552
	for <linux-raid@vger.kernel.org>; Fri, 22 Mar 2024 11:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711106381; cv=none; b=UwIvC7VDuiOrpj8BZf8pgrU5mQ2UgTKHHc7velQ3rOhAu0DiKRgg8KxJKs0stRzPDIaEA8eDAafIeIbGU237+dIejxRNOajncInf0zp0XEoWNh7Gf+Alg2p3ZPHmmozTeZk2GzkZ2QXS6t6/5l+1ZT3rMdNA3jPdXHgoa+NPNIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711106381; c=relaxed/simple;
	bh=DykebEljZSPILoOxk0Hd2d0m0HHIqhLJDXS0Qvy6jVA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IFV9ljjbhwDAsnwVd7oWH5fjBTx7kla1Ys9ZMdXaHHijZQ0CnmbPStZn+ZVn4qxB9VbxNKPjx90OrCITye1kNQGhoB7Wu0mQsIZKJ+u1EMv5V8CwOpL4NRzMbOfmF2TrDDAsmFTAuk1YSwrMBYNr5ejIxcKaUZ6cya6Op4kMdfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aisGpFR0; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aisGpFR0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711106380; x=1742642380;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DykebEljZSPILoOxk0Hd2d0m0HHIqhLJDXS0Qvy6jVA=;
  b=aisGpFR0/cbYLYR+InTdGqRJ5mSbm5n+TAtJ9vywefgi54Xchi0peVWI
   oqqIPVLLBxbICPxAPViesYKEj3kWGf0JllJvmvlS1bSaMowBbvZUD94Ro
   2VpxJ9Larqz7/3LKi+V3RKM6yWvBMTeOsFOuLZ0UUdA8IqfEbv9p8OLrM
   lKyBS/Mv9QItjpDNrsIqAFrbry1phE4JpDoQ0WBO9n4/FHtOYRdM876if
   ovrl6CjQOmmuoJkw6CzwzeOUXupCMNf13QDe6FWgEAwjkpf1pSFZdsV4m
   1jO/NpN6q32bct8GD2BiInYK5wpTISMy0kXO3oT52HYst+ySQ7gb1Tm4U
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="9937098"
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="9937098"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,145,1708416000"; 
   d="scan'208";a="14770940"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 04:19:38 -0700
Date: Fri, 22 Mar 2024 12:19:34 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: jes@trained-monkey.org
Subject: Re: [PATCH] mdadm: fix grow segfault for IMSM
Message-ID: <20240322121934.00002ef0@linux.intel.com>
In-Reply-To: <20240318162842.9651-1-mariusz.tkaczyk@linux.intel.com>
References: <20240318162842.9651-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 18 Mar 2024 17:28:42 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> If sc is not initialized, there is possibility that sc.pols is not zeroed
> and it causes segfault.
> 
> Add missing initialization.
> Add missing dev_policy_free() in two places.
> 
> Fixes: f656201188d7 ("mdadm: drop get_required_spare_criteria()")
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---

Applied! 

Thanks,
Mariusz
