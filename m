Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95921D7E4E
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 09:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730970178; cv=none; b=eIVQLMQn7tjBBh4LSsGkMPREy369cgK2CWNI/1Ksx4pTwNYLmffBNBTVCkx1mxyhAURUQDXwEogwtxUxWbzhoaAGlH6uDoem9jojDCVoFwSDB0BlzjCvuhR40YFMvgNnvHv7HizywJfKSRQhDDuEW5IQy3+EY+EmVZucBP6T2gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730970178; c=relaxed/simple;
	bh=Rqx/4MgDBiElemiV8URHTs9Ij3VSniRkB4rR+LgW4qo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XGbswQTOpQEp99F9Iv3r+uSXU6l29/BUA8RZRP87ObzcQTFKNBdhUmsedZUrWAGgwPl6VwiOqtvz9MTsJKWNAynXf2/UuXwYDEPPpDbHai0TfSXRR7gpI//emiLzCuCXD4eUI6/laXl6lprYFrvRNzco/PA7cJlBLS0EVtB/tKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bYzqreea; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bYzqreea"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730970177; x=1762506177;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rqx/4MgDBiElemiV8URHTs9Ij3VSniRkB4rR+LgW4qo=;
  b=bYzqreeatJgnmPvBKttLLds7A9mcaSuJn6labyfgyRDwd08RDNWR4nHW
   ui3o/GNtZSA2WRmvqMetaSiqhpCZo5mYwfGpgxpfjVEXBTe3cWt7YA10m
   UEDCqbxWHh4iw5h+yHM6n+pf6Iuxnz8yNqu4ri0IS2TVsyHXBwkVgxB/b
   iQNmB6h64nWK7bghlWmVp4WigllSNpKJYyUI6bV7SE2vlQDmA0JrrcHNB
   Oc/m8L0nZJlBrbg7Kr1bdNpvikqQN9fUdJ0VARXn7+kLSGr8MeJlPGFPz
   qIlUw8faACPDoUhRHguViR7O2ifyuwP0lW6bM9AQ93Lil/RR8biv9MndO
   w==;
X-CSE-ConnectionGUID: JBHTOSnRTgSpusTcjyelyQ==
X-CSE-MsgGUID: di5YQnV5TyOf53IbCWwFgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30660008"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30660008"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 01:02:57 -0800
X-CSE-ConnectionGUID: Sv97RKi7TbaHs1gemT+Fzw==
X-CSE-MsgGUID: sgc0kZS8QAerfgsI1y+i7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="89801652"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 01:02:55 -0800
Date: Thu, 7 Nov 2024 10:02:49 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, yangerkun@huawei.com,
 Song Liu <song@kernel.org>
Subject: Re: [PATCH mdadm/master v2 4/4] mdadm: add support for new lockless
 bitmap
Message-ID: <20241107100249.00000f51@linux.intel.com>
In-Reply-To: <20241107081347.1947132-5-yukuai1@huaweicloud.com>
References: <20241107081347.1947132-1-yukuai1@huaweicloud.com>
	<20241107081347.1947132-5-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  7 Nov 2024 16:13:47 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> +	if (strcmp(val, "lockless") == 0) {
> +		s->btype = BitmapLockless;
> +		pr_info("Experimental lockless bitmap, use at your own
> disk!\n");
> +		return MDADM_STATUS_SUCCESS;
> +	}
> +

Hi Kuai,
I'm fine with previous patches. For this one, I'm not sure If I can take it yet.
The changes you added if for are not merged, therefore merging this looks bad
from process point of view (I'm merging feature that is not available in
kernel upstream). Am I missing something?

I would like to hear Song voice on that.

IMO, you should keep it as your own customization until development of new
bitmap is done but I understand that the topic is not simple and you might want
to people to test it so having mdadm build-in is an option.

If you really want this I would need a detailed process of "way to stable" in commit
message that I can always refer to. I'm challenging something like that first
time so I hope Song can add something.

Thanks,
Mariusz
