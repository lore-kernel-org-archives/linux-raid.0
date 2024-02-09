Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2214F846D
	for <linux-raid@vger.kernel.org>; Fri,  9 Feb 2024 08:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707466277; cv=none; b=afrHxaQ+UKj5LVewKWktq1n/ubqF8y2GMZzU0PdzuatsAiZLq93aWZwxRvKxHFYIkLGn12Uf6NTNAn7RLuEz8ycKgazvHOBdAZCQGY7zdlMPSQkYbsq68zOzf+BFSQAqPJyr3RB2qFgVA6tNVomqkWW6EMdBguLkUpupdrPJbks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707466277; c=relaxed/simple;
	bh=w2SatZF3b2OODrPA6h0trLAbEwA/SxABfDynK1sEJVY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AScEI1dZTHjrOBULe/KtdsyGQkkTIHDU5o4rR7RvOy/3MD2hAR39NG2QUy2pxpsk+v/2k9+lH0mfzQtK+oBobcSZceWR/JxChlMNuTpaKmh6FdUc2Qzt7veLskbRBk/nZKtWwbmQN0M1NCmMdYhkY5WSw8P0i5OY9zPoaDMYDys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gti/4V95; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gti/4V95"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707466275; x=1739002275;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w2SatZF3b2OODrPA6h0trLAbEwA/SxABfDynK1sEJVY=;
  b=gti/4V95w39xdCkVGbrroo6Pudk5H6PFJPq98EaHqcI2KumkpWJZuIk2
   yFMlOxz4tzid70ewD3xfHhrQ8/T827tmIvnSC6pBSepfJ3hiFkL/TDkYg
   AaaFhiLjR+OZk59rqcALeWyAt1G6VNdW/Gh0nzJ5hazy5RQLoNsH/0SQf
   u6sw9Dbuv0UAh1nPuDQwTaF5IY11CrhJ89ZNxd7z3qE+/acbhxALq5hB0
   o9cgpFnG3h9tv1AjHe7gtjBo02cdexqSUQmwfxlilpYrt8TQ+qYns/5iX
   0Rjk+k50duw6f74GZXa8xn1N7rowkOjK4uNo29SDdbag/cFBw8OC/LGW4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10978"; a="5206853"
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="5206853"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 00:11:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,256,1701158400"; 
   d="scan'208";a="25117204"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2024 00:11:13 -0800
Date: Fri, 9 Feb 2024 09:11:08 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org, Stefan Fleischmann <sfle@kth.se>
Subject: Re: [PATCH] super1: remove support for name= in config
Message-ID: <20240209091108.00006d67@linux.intel.com>
In-Reply-To: <20240201113241.26479-1-mariusz.tkaczyk@linux.intel.com>
References: <20240201113241.26479-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Feb 2024 12:32:41 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> Only super1 provides "name=" to config. It is recoreded in metadata
> so there is no need to duplicate same information.
> UUID is our main key.
> 
> It is not used by Incremental and Assemble handles empty name well
> because other supertypes don't set it in conf.
> 
> Expectation that the name in config is same as in metadata is bug prone.
> Config should be the place where use can define customized settings.
> 
> Remove printing "name=" from mdadm config creation commands. Ignore
> the name in config file to keep backward compatibility. Remove
> description from man mdadm.conf.
> 
> Update 00conftest because "name" is no longer accepted.
> As the name is ignored, error for mdadm --detail is not printed.
> 
> Reported-by: Stefan Fleischmann <sfle@kth.se>
> Fixes: e2eb503bd797 ("mdadm: Follow POSIX Portable Character Set")
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

No comments, Applied! 

Thanks,
Mariusz
