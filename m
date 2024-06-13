Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264B0146D63
	for <linux-raid@vger.kernel.org>; Thu, 13 Jun 2024 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718285082; cv=none; b=R32ckFqLrAiBXLrtaYVLnPdgqKkRIi02AFBxHhAMMRJqU07gW2FgzMnYNKC+ZXNlRop25csuE8Wj47zXGF3Z1RhB3NAvic5EonN7f7M5XtHPf62LXdC2DbrRj+Bm9yVlqfBn9QQcAwOoN1QlDLQrIIuiDJaAhCBD3uVlNWImEPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718285082; c=relaxed/simple;
	bh=ySegQrairJfhO4YYau/ebmXMZo+IEEBMoSaDBSymczI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwVfVHDkXwGBAHFvP3SCTPtWH7ypTEwVG5RpDTm9nbTFAJHhczs5T9swn+BojS0JfLLbUF89CGXL5A2k2+KQ0OMv52uRk7s+PvT2m5Jxt1QTrGWAp5BaxXt3utq4QVJsDSLHHU+lcBVfHbzDEF/S3/CC3ogaYvcl1YtLDbLhnjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DaWUrXsr; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DaWUrXsr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718285081; x=1749821081;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ySegQrairJfhO4YYau/ebmXMZo+IEEBMoSaDBSymczI=;
  b=DaWUrXsrSy+t4/lX8W5aJnJm34CAC4D3RP0CXo67xW/dS+BDpQZ1eBtd
   /Bgz31deK4L2bHo1YG5UB478J/Fr9JriIklnKaDi6eXoFk3mgOOih5kwf
   RMEANV5DyJd26JFDuTs/1aJhTNH6YvLrUxjH2bnLnQQlLtsEl6/aRySIy
   Dlka83AaBhIfbZooeyLuKGx6xMCL4aFFDOvnpPS/cD1V9l/UFbUo8ly/V
   JxKfpYMrFJzS2QBXleUqvRzQTDNyj23R4m6J5yRztaXnjSckeZjBw6DBP
   HAuqQjhl+VQlPT5enXZHu5l3yInVseZKoKLWeMLoC1ziag7WULNAxGlR2
   w==;
X-CSE-ConnectionGUID: mDxVCeqGTiqzqW9BcQuV8w==
X-CSE-MsgGUID: F4QhUvKESlmwutHBUbRhIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11101"; a="25682527"
X-IronPort-AV: E=Sophos;i="6.08,235,1712646000"; 
   d="scan'208";a="25682527"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 06:24:40 -0700
X-CSE-ConnectionGUID: P+FbNYKbQkyf+i9O6y54lg==
X-CSE-MsgGUID: 1G4GiiIERECcwt2VFtCdow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,235,1712646000"; 
   d="scan'208";a="45088959"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2024 06:24:39 -0700
Date: Thu, 13 Jun 2024 15:24:34 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>, Xiao
 Ni <xni@redhat.com>, Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH mdadm 0/2] Bug fixes for --write-zeros option
Message-ID: <20240613152434.0000633e@linux.intel.com>
In-Reply-To: <20240604163837.798219-1-logang@deltatee.com>
References: <20240604163837.798219-1-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  4 Jun 2024 10:38:35 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> Hi,
> 
> Xiao noticed that the write-zeros tests failed randomly, especially
> with small disks. We tracked this down to an issue with signalfd which
> coallesced SIGCHLD signals into one. This is fixed by checking the
> status of all children after every SIGCHLD.
> 
> While we were at it, we noticed a potential reace with SIGCHLD coming
> in before the signal was blocked in wait_for_zero_forks() and fix this
> by moving the blocking before the child creation.
> 
> Thanks,
> 
> Logan
> 
> --

Applied! 

Thanks,
Mariusz
