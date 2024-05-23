Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7C5A94C
	for <linux-raid@vger.kernel.org>; Thu, 23 May 2024 14:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716475946; cv=none; b=bOReyyrssKVtoA5+zQXsjkQlQNnWsmztXODvelwDRS+1BrJN561jwh4y6rhjhB8BYVihoSK5T8CumzLKvZHGN36jzj++WasJEIwftyp4ZCDnpn7i/YbVqgrvn2HT0Fe6BVNHNc1jfr7xe3KcaLRIJI4tmDOJ1lDFKLEWed8EitA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716475946; c=relaxed/simple;
	bh=QoapCTTvyS29Itm5R9nWjGnlbCqhIU/ZkRz0/1mM4wc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EI3R6+kgp+SToIprC6yHiyAIGn29hOP+BK+BH6tQasBr8rNB/oiHPqrbf3RFhiY3m2ZEBFYfk6tqFTfsHDW4rLfrW1tXhz062WlEnB1LhM6Y7yuhu4zPD0DGiU4dW5SCkYoaXZmT5zoAq1cuoBt7CMvvCo85GL7RTIpAinRHUBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aMK4Vvgc; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aMK4Vvgc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716475946; x=1748011946;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QoapCTTvyS29Itm5R9nWjGnlbCqhIU/ZkRz0/1mM4wc=;
  b=aMK4VvgcBc6p5xNe0/tMATDeIllGMUVyNBHPzlS6hzNNUKwwPrrrWTBJ
   gL7KjU8s4orrJxecq/cPuFvcfGXbADwh84ZRBBTymLAjCc3o0Wl3F81dC
   ykh6Z0tWAXukFrr69WnfqSyVFvVIRFxq7JMkcTh374EnALCQKmPxVLS2d
   InZjUmVEjxWQTeH+uAFnv8SSUR7xUrwWFiuHZ/4lGwZ+I2c+kyfxjBvsV
   nQSi2kcG0jR8oCF/b8KcekM4LtxnpY9nywrGv0tlzfheK4FgPa2a5tYyh
   bbKKqWAik0+mheZQUrUOvkD+kbNDxGnxh2xA7vaQ72VfjHAYngb1fj+/X
   g==;
X-CSE-ConnectionGUID: COyBd+9KTIKLLMgSImyBzw==
X-CSE-MsgGUID: CAILcMvQSOOjObUbT+UNjg==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="12737661"
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="12737661"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:52:25 -0700
X-CSE-ConnectionGUID: u+j5GfIRTiqlrRm8GEP1Gw==
X-CSE-MsgGUID: w2AvpdafSXe0podTOE1tlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,182,1712646000"; 
   d="scan'208";a="64525511"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 07:52:24 -0700
Date: Thu, 23 May 2024 16:52:18 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, heinzm@redhat.com, ncroxon@redhat.com
Subject: Re: [PATCH 04/19] mdadm/tests: test enhance
Message-ID: <20240523165218.000040bc@linux.intel.com>
In-Reply-To: <CALTww29Y+DMpvCqzOSk+Y4LZYz2oU5Sdh5WnTXZZA-ekCMTVRw@mail.gmail.com>
References: <20240522085056.54818-1-xni@redhat.com>
	<20240522085056.54818-5-xni@redhat.com>
	<20240523162614.000049be@linux.intel.com>
	<CALTww29Y+DMpvCqzOSk+Y4LZYz2oU5Sdh5WnTXZZA-ekCMTVRw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 May 2024 22:39:16 +0800
Xiao Ni <xni@redhat.com> wrote:

> > Hi Xiao,
> > control and restore functions are not used or in this patch. if you want to
> > use them in next patches please highlight it in description.
> > Beside that LGTM.  
> 
> Hi Mariusz
> 
> The record_system_speed_limit and control_system_speed_limit are used
> in this patch. restore_system_speed_limit has been used before my
> patch set already. So I don't need to change it.
> 

Thanks for fast response. The patches are not pushed yet, I will wait. I looped
the code and don't see usages. You just declared them,where they are used?

Thanks,
Mariusz
