Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B593EA68
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 07:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713511231; cv=none; b=osSu11AuS2JVJXOGqvH35gmqRkF19tOhRqb4gZqhRj1C1Be2AUt8afiF/jiV7Izwt8IQi2aaCBkgA+zXN6JJt9I9QccYzLjOvUlcJojcTdV5n7AftTA0hrNWVrR0JB0Roww77YGqlW0/uQwTjP0kpR0D1mkw8jhS8H0n7BpNSaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713511231; c=relaxed/simple;
	bh=RYf36SOnL6L5w03VR4ZL3VjqH5o/chFpqd6wNODQ/AM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YM6jHX289n9oZN6+bK/6mKJadZLSPAmycIbZ1D+EuDOVPJCsYgKow6DjB2VCgc5nvWHEZXnPol7nlwX64pifYXxitIDC/gHCkLR1bm7LkvsJGczUNkugw+scq5z+QQs64WYN9JZrA+ZUDyUsgPGCIepDSIC8/2HajTyj0kLTwQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M4Hc7sFr; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M4Hc7sFr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713511230; x=1745047230;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RYf36SOnL6L5w03VR4ZL3VjqH5o/chFpqd6wNODQ/AM=;
  b=M4Hc7sFrLxNEjSQzc78qhvEdX9wlk03bMXhiK3GmAAxRl96V9NdEvFLd
   OlPei3iEYy+oiP8a11/KRkPabRYUm+o7I88lMSQo+04JXlDWUTRqO3Ch6
   sY+lZflBMI4dGnpOS5Dj6FaSbYMsnTNc+KxovQTQNJ9i3fIcNbOU+WdMl
   vsTiNot4c+jIWw50ETwMnpdBPm/zyACOYKnid5iFTiyePdpFrQSIwggqz
   FIAK96CuIHU+Ntf3bVDyT8TMCxIuTluG2vwDzs7ltmSk6BpPJnb9BooXq
   2aHdeak79tj9nIJgChvXNnfNfuZ4r2GWu6QwXHzgKP1QjWNWZsjTV6POT
   w==;
X-CSE-ConnectionGUID: z5we3VnQRA6neLkV5lMJjQ==
X-CSE-MsgGUID: v16ti0kcROyYE3kYvf0g4Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="19709553"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="19709553"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 00:20:29 -0700
X-CSE-ConnectionGUID: 3e1zL7J+Q06vebZ+fRFIcw==
X-CSE-MsgGUID: XScNBrEhSmiPk1RwCyRUOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23333696"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 00:20:27 -0700
Date: Fri, 19 Apr 2024 09:20:21 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Subject: Re: [PATCH 2/5] tests/00createnames enhance
Message-ID: <20240419092021.00003bc1@linux.intel.com>
In-Reply-To: <20240418102321.95384-3-xni@redhat.com>
References: <20240418102321.95384-1-xni@redhat.com>
	<20240418102321.95384-3-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Apr 2024 18:23:18 +0800
Xiao Ni <xni@redhat.com> wrote:

> Now 00createnames doesn't check Create names=yes config. Without this
> config, mdadm creates /dev/md127 device node when mdadm --create
> /dev/md/test. With this config, it creates /dev/md_test. This patch
> only adds the check. If it has this config, it returns directly
> without error.

Hi Xiao,
Thanks for patches I will review them all later (probably next week).

About this one:

The proposed change is not complete as config may be read from both
/etc/mdadm.conf and /etc/mdadm/mdadm.conf. Ideally, you should check them
both in the approach you proposed.

There is also possible to have /etc/mdadm.d/ directory - it is always checked
and read if exists and it cannot be disabled. See load_conffile() and
CONFFILEFLAGS in makefile for details.

Test relies on the global configuration and user may forgot that it is set.
That will give us positive test result because test was not run due to
configuration issue. This is risky, I would prefer fail to indicate
that something is wrong. User can skip this test.

What about adding empty mdadm config to the command `-c ./mdadm_empty.conf`? I
see it as the best option for now. That save use from checking 2 config
locations and any user defined behaviors. Do you see any disadvantages?

As config directory is not configurable we have to accept the risk that
something could be there.
Ideally, you can propose patch with confdir customization to apply same
solution as for conffile (just set it to empty directory) but as it is probably
rarely used we can accept risk here for now (unless somebody reported). I give
it up to you as it not having confdir customization is more like new
feature.

Another possible solution would be to learn mdadm print it's configuration and
print it before running test and fail if not compatible setting detected.

I did not realize that it would be a problem, that for catching!

Thanks,
Mariusz
