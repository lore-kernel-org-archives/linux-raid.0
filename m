Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EB3376F3
	for <linux-raid@vger.kernel.org>; Tue, 13 Feb 2024 15:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707837490; cv=none; b=GWxR17SKiJwWgGLEALXZV3ycCBTsrCk6/iPTJBWZSgfIl4DdvWYU5+JMatzRTJ5HfpUxIGpLF4lZqR56gN/qu4fqBIXYrccZ3J3haesCqwbgPZoh+DR73lIAqCTEH+InOdirSq0JD90LrGlVd+7YHG2t4Ns1dspfQDjR3JPhtb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707837490; c=relaxed/simple;
	bh=oNFqHHwqWgxDP7MkXHXsi5H9oNr3q7FfH3vjUFlblCI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pDO2VY9EZDAkr8Kq93wP3J0BOvfB6LjPiXuTlGloUgctnDlaXgJSMo2Scs6nmXf4WFvxJWNm102mGbdmrf5ZfQRr6/5cmVw2Qf+SxznIlhGDntQ6XXsGUFxnNryDSZznnyTY62VXWCjkkbgKkEdKuuNhJ3Bc7ve9sTYcdpLZMO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QbdT8OHR; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QbdT8OHR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707837489; x=1739373489;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oNFqHHwqWgxDP7MkXHXsi5H9oNr3q7FfH3vjUFlblCI=;
  b=QbdT8OHRKHJuCpBtp4XjwC0D6VPyvuPAsgo8KzD5vSx+7WYsR3L/rtPp
   zRDS1OZMykEwUwFfS6rZO/DhAvd6wLtvRBYKW6nSpwUWLKRndVoCJP96u
   V24N7IUElPnTvcL4fB2quxtKuLQ5JSjAjXXYaFA4ozcCvy+2wRJ0V/Ewy
   ANv576rc1h9vMkD3PMX40iucPZ+Ezj0IFCL/Fff5sNm8P59ua5Ey2Vgl9
   Vniu94fk5TZOMxsS9TeUYXzzG5Z0q1T5tPZxK5mDL7mULdqnhcw+6lms3
   wodIBh68nyod5sHcnIxdEgUm8Qb9pl/Qm9Wum6ceDdHmr1mTUeNFqeB6I
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10982"; a="1971103"
X-IronPort-AV: E=Sophos;i="6.06,157,1705392000"; 
   d="scan'208";a="1971103"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 07:18:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,157,1705392000"; 
   d="scan'208";a="2865150"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.29.120])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2024 07:18:07 -0800
Date: Tue, 13 Feb 2024 16:18:02 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v2] mdadm: fix update=resync regression
Message-ID: <20240213161802.000015a1@linux.intel.com>
In-Reply-To: <20240209130216.19055-1-mariusz.tkaczyk@linux.intel.com>
References: <20240209130216.19055-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  9 Feb 2024 14:02:16 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> mdadm --assemble --update=resync started failing  with the error
> "mdadm: --update=resync not understood for 1.x metadata".
> 
> It is a regression. Add omitted branch to fix error.
> 
> Resubmitted, original author is not responding.
> https://lore.kernel.org/linux-raid/ZZqJlCToUS3Qrl4J@bianca.dpss.psy.unipd.it/
> 
> Fixes: 7e8daba8b793 ("super1: refactor the code for enum")
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---

No comments, Applied! 

Thanks,
Mariusz
