Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8933412A177
	for <linux-raid@vger.kernel.org>; Thu, 29 Feb 2024 14:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709215886; cv=none; b=dPggcq2qkdK1iIVGQsvUqmc+fR/Zx6JcaDAfttHRlm1Wt+GOenJVjq8v22zGbSn3hRcjDZ1qKR3b2XuClyMiEQiYQbXUt9NXBTyBVsDXL2mvSs3q5Ql4yrSVevM5IdKm2N6XbY2msjxJq76/9DJHUYTMrijzUo8al0pdJ5EvgmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709215886; c=relaxed/simple;
	bh=uGBYIcbZfpP8QImsB/cDDwg1HvhWfEZiYprLb0UPqDo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vphxdbepqa3dElX3sRhTiYHPb43EvSHgfHSQGj/bqaVH2RrZuXygM9d3TA0EpCjdGC48YPriDHRP86Emrb0bcIJVmvHLwwzjwTDHz7OR968mokFTvPM5y9giPyxldJytc+5X1uKftGimUPhMACXToaqJ9F1Q2I5OvwFTgG6FWlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bTY8kVq+; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bTY8kVq+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709215885; x=1740751885;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uGBYIcbZfpP8QImsB/cDDwg1HvhWfEZiYprLb0UPqDo=;
  b=bTY8kVq++ih355E+gRVSgHAqQk6GA4/2P9uje31uzxN6JkLR4mFWcPzs
   mYPmAp10xCAXczSBwNU26uHgEdG4vCMdmFvjUXBFE7JsGz8Odx+dzkrq7
   dohgReHmaNoJj4GDWvlCzmYrrT8mgYgL+/6hXhXZPGxyJkOk9tG0CfZs2
   I01aD1SqIYeSQUKCGfyLIqz78VdmOFdBGQ0DLmtILG7ZVFI63XcdVvDBH
   8XwifjHTa8A2fjDI+DheTQIlBSq3rLmzUP41Bmli7xyPuo0nWDi8cbO/g
   fltEMq8D3ufNjgwIe16zzV3jJ3xqss9XZiF4T1T9tUCy60mFPQ6WkhXYF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3609138"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3609138"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 06:11:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7870384"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 06:11:22 -0800
Date: Thu, 29 Feb 2024 15:11:17 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH 0/6] Repository cleanup
Message-ID: <20240229151117.00003883@linux.intel.com>
In-Reply-To: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
References: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 Feb 2024 15:51:40 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> Remove legacy files and ANNOUNCEs. They can still be reverted on demand.
> Create special documentation folder and move text files out from main
> directory.
> 
> Mariusz Tkaczyk (6):
>   mdadm: remove ANNOUNCEs
>   mdadm: remove TODO
>   mdadm: remove makedist
>   mdadm: remove mdadm.spec
>   mdadm: remove mkinitramfs stuff
>   mdadm: move documentation to folder
> 

I applied them expect first one.
ANNOUNCEs stay for now.

Thanks,
Mariusz
