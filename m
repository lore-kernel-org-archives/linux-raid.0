Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B643F15F330
	for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 15:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709134855; cv=none; b=QiaSAA3FYbrTMN41oZWPwNa2wBBHU/u7nXnie/aA+tuI62VX8FJhO2EkLhUYcZQVuw4dNulpmhiwZ9Y3WmS80xpHZsqxN1yZIK1fvRn32qvphpATcnCNkb/xHYmAd5Sx4+EgpjykpaboUL7O5SewzI40IZqfvGZ8ffAc+c5Myaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709134855; c=relaxed/simple;
	bh=+L+c6zYdLt4IHFU5UgJ7br4dxnL0qqbwuOhFnrRKuCw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=duTOSwB+g8KOlTl1Zmv2Rc94Gaid9hcTQCdial/auFnlIAhOc8vdUFS1Og4U78LxRD7BZacIQGv8CjfQvi/+o46M7h5BvMkAlY3KAixPuiL8jrzMjBEg458YszK7ClEiboddi87C3Fu0xkcrzFCBmuy/Q/XleE2ZmVTawofh2fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yeij3ggZ; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yeij3ggZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709134854; x=1740670854;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+L+c6zYdLt4IHFU5UgJ7br4dxnL0qqbwuOhFnrRKuCw=;
  b=Yeij3ggZATvKlprpqz5Zo3mY9M4yVQ7NCXzpJfAyykbWe6MSDfGf7gQP
   wrkItj3bg/+j3TfUaM977LWoZrpNyTx5cn3jSkhM+K39CUsZ0VpP0458i
   gmVQ1jT15HnSbG3BPC/DsZ6i1A/EtUFP8ZcEPs+ho/ajEW8dCKcKuGRW6
   N8LijCttK+Wu/AXbhA6hSOf/3AZKYD0aE+knyE4nljxOxOlk54IgWH8kg
   WHWR7wQH2s0yCH3qVHU+b40W7edyCZ7OctimUqHnWQAYs3TRcWUWcBTtv
   68JtNGAs+G5kcaXVQyMMPwxJxqfxpiidSBx4zTay0qlX77T3zmE7LJzr1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3656815"
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="3656815"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 07:40:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,190,1705392000"; 
   d="scan'208";a="7401853"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 07:40:52 -0800
Date: Wed, 28 Feb 2024 16:40:46 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Nix <nix@esperi.org.uk>
Cc: jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/6] mdadm: remove ANNOUNCEs
Message-ID: <20240228164046.00001565@linux.intel.com>
In-Reply-To: <871q8wsld5.fsf@esperi.org.uk>
References: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
	<20240223145146.3822-2-mariusz.tkaczyk@linux.intel.com>
	<871q8wsld5.fsf@esperi.org.uk>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 Feb 2024 14:40:22 +0000
Nix <nix@esperi.org.uk> wrote:

> On 23 Feb 2024, Mariusz Tkaczyk uttered the following:
> 
> > Release stuff is not necessary in repository. Remove it.  
> 
> ... it's actually pretty useful to have the ANNOUNCEs there for people
> building from the repo. Given that the changelog is not updated, having
> a summary of changes *somewhere* without having to grovel around in
> mailing list archives seems like a thing that shouldn't just be thrown
> out as "not necessary".
> 

Agree, we have to maintain it but in simpler form. I will create CHANGELOG
instead. I will copy the content of those files to changelog, with some
modifications.

Thanks for comment.
Mariusz
