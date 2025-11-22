Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E96A23D7C8;
	Sat, 22 Nov 2025 21:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763846457; cv=none; b=pcNjJHR71xod6zYWED80lA5ugYaQHJzp8cU58VTp+fPFjRmWh1inJOGqrlIBHwJSWv826MBqG/KWPyCKv3vLVEJzwdJsxO8g/2R0Q8/yShBIp9urTLfjamFRcBqc0K44C3Wuz5Ag58t7rpLh5G3T6ROnz7zPhXGokTpu+PRN5HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763846457; c=relaxed/simple;
	bh=p+B/sM2HUHPQ7mmrORzxhq0BN5FQD1Jp1gGHHxf34oY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OWnUGot2bcophfeog1WFacP5+tnHw41PF6FqJMyG9o/4DR5KI6jC76x0WJIIDLoGQK9vE4PKr/InzvIc3PLAA0dB/NYQBlXxdFPk2RM0kpq/LvozjkX9ePbYqq8UG2cPaEumGKUwWkv8+HS7EU53SxerRenSFQBUgNEVE80hxz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q50EC3LE; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q50EC3LE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763846455; x=1795382455;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p+B/sM2HUHPQ7mmrORzxhq0BN5FQD1Jp1gGHHxf34oY=;
  b=Q50EC3LEutDnpC4ceGwAWMJRxr/9BN8nZ6AqMN9yihi8Fdjg70UBYaZH
   E7EQAm1rGwO52pgAAm/GjDmRmtXtXRWxL7GfwADyqtsIqD8jzHk7j38JB
   YS9xnAPacUZPHWYy827EtLCkVolMIAixzfQ5nLyKr+jiizFMU45t4cFdE
   +bS3RLMI5q5PjYAiyzOKakz9hNU2u1HZOjZBxRshG14m11siLO4Q8A3/Q
   mvcUOTqr8cbNJJlwK9mM+qllyofVl+0mMZ9TCFO8c1n+nDUxq1IlthF8q
   feWjPs3oCtf/w0KWK2yK3ZdSAGgfJxKjVPOvJKXt2kDnIOaRhR8Z2+2af
   Q==;
X-CSE-ConnectionGUID: +8pGGYgTS/i3onniBJjCDg==
X-CSE-MsgGUID: HqdcDr1BTBCLB4WnWKYLxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11621"; a="69767095"
X-IronPort-AV: E=Sophos;i="6.20,219,1758610800"; 
   d="scan'208";a="69767095"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2025 13:20:54 -0800
X-CSE-ConnectionGUID: PZiQvo2JQJSThFIT6qyldw==
X-CSE-MsgGUID: e1owp4/ZTpKzkQ3LQ9YsoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,219,1758610800"; 
   d="scan'208";a="222931947"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 22 Nov 2025 13:20:53 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMv2I-0007pz-1L;
	Sat, 22 Nov 2025 21:20:50 +0000
Date: Sun, 23 Nov 2025 05:20:48 +0800
From: kernel test robot <lkp@intel.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, linan122@huawei.com, xni@redhat.com
Subject: Re: [PATCH 3/7] md: support to align bio to limits
Message-ID: <202511230429.aSwW3knO-lkp@intel.com>
References: <20251121051406.1316884-5-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121051406.1316884-5-yukuai@fnnas.com>

Hi Yu,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.18-rc6 next-20251121]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-raid5-use-mempool-to-allocate-stripe_request_ctx/20251121-131818
base:   linus/master
patch link:    https://lore.kernel.org/r/20251121051406.1316884-5-yukuai%40fnnas.com
patch subject: [PATCH 3/7] md: support to align bio to limits
config: powerpc-randconfig-002-20251123 (https://download.01.org/0day-ci/archive/20251123/202511230429.aSwW3knO-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251123/202511230429.aSwW3knO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511230429.aSwW3knO-lkp@intel.com/

All errors (new ones prefixed by >>):

   powerpc-linux-ld: drivers/md/md.o: in function `md_submit_bio':
>> md.c:(.text+0xf8c4): undefined reference to `__udivdi3'
>> powerpc-linux-ld: md.c:(.text+0xf914): undefined reference to `__umoddi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
