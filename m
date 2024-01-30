Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBBA6BB3C
	for <linux-raid@vger.kernel.org>; Tue, 30 Jan 2024 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.115
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706619064; cv=none; b=IP111pEwS8Sq5ch2ztYDLqhBF60W1a4w9zJtPCDwrzVRnHeFL2yIcP58IfNFLFNB6facmQOaAuwgWAKzu6Pls7VgQBft6Rvq6zX1KACIok0bzf63cuV3Hh/LB1vkUGkN2R6WOBIHI7j5xsPhsekDPMSkNsZDPSIb4aQ0TpieyMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706619064; c=relaxed/simple;
	bh=yXDUjuuR6NSr/KBZySO2s5IsPMrgC2texvutp2KCqpk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HaBSrxwEoc83NfvK54eSrZbqNnTHyv7n8fDJ8M7IPGQHePoeOqm+oWTd+IpB/6cTI3oA3bEwtLtN2l4t36fxbMzd4U1KnJW39kW03Fp7yCRGPrlYI3+NhrDVTtYob1e5BojO1cpw4GzRp40XUonnMWRHqZiBQjT+G2BlGTA5n28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZZzROluQ; arc=none smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZZzROluQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706619061; x=1738155061;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yXDUjuuR6NSr/KBZySO2s5IsPMrgC2texvutp2KCqpk=;
  b=ZZzROluQBFGCTs+RxBI45LjpXZpn4+4sALhtDu60AMx/HpC6QKMbqNsW
   Loifxks5sf3ok2B+LyBYIyInRo3kpzitK8LD2tNQNbLdrnVNs4cEeB0wR
   QR97x9JCfYysLp53/rbuKnWkQZvbIOMH4no4lccTn7GQob4aOmJKIOYPS
   NuQpaJRDOYbiVaPMGZSPNHoQAVjP0PAoYL/p5rPsqOZoxrJmcrIp+SdB7
   Q+8fAlfxiWCbglmgpSR2T/yUrEGh/bmS6l4/J5QCQ7q4jbO6GSgwZJRPp
   4Mw29Iyt28XAIAbpMvpOKSAf98ITTM/yvGYzXkTSuz3UG28bvqoMO5Oum
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="402897224"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="402897224"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 04:51:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="22424889"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 04:50:59 -0800
Date: Tue, 30 Jan 2024 13:50:52 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Stephen Haran <steveharan@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: Help compiling mdadm 4.2 for static binary
Message-ID: <20240130135052.00006d23@linux.intel.com>
In-Reply-To: <CAKcp_7a7tw-oheF8E_KtYjv6kmFTG3AMkX=UEQWuFGFV4SkaAA@mail.gmail.com>
References: <CAKcp_7a7tw-oheF8E_KtYjv6kmFTG3AMkX=UEQWuFGFV4SkaAA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 Jan 2024 14:37:09 -0500
Stephen Haran <steveharan@gmail.com> wrote:

> Hello,
> Compiling mdadm 4.2 from source by just running the "make" command
> works fine on Ubuntu 18.04.6.
> 
> But I want a static binary so I run "make everything" but it fails.
> Any idea where I'm going wrong? Thank you!
> 

Hi Stephen,
You cannot do something wrong when building is broken. The true is that
wea re not testing static library compilation. We should consider
removing it for now.
If you want this, feel free to take challenge to make it working. If not, I can
remove mdadm.static target (if there are no objections). Let me know.

There is more work to make a good library in mdadm. I believe that
removing current mdadm.static target is reasonable to start building library
API from scratch in the future- if there will be need to.

Thanks,
Mariusz
