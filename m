Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350EF2EB86C;
	Fri,  6 Feb 2026 19:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770405772; cv=none; b=fDuN7XtAwiHgQSqSFYadmw951IZr2gHxc6p7csMlCJHAlXvAlL1SvK0FhTvxewp/HtFtb9zmpwlFKBpGHJz0TMMO3PdLtapZzokv5N6eoxbRiGXWulq3PrfUA77L/lsAxwNvAYW2F7WCfOoI5Cv5+rxbhUHPWltBFGhqNz1HSwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770405772; c=relaxed/simple;
	bh=llPkVaxCJEYAFDVjbKmaczSFyKpG35yasKcIaXAYMTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r7DTWTAGp/c14K9hUs/EF0wsK/RnC7bwilsgbuSVfmPp0RgnmRIbdkz4KbiWfiQD3Us/bXtsv38sjm1QqYG92FMAmxiB8oV3iGdXPUuCwA9TYnftAp2dJpzQF3LhNxaThmXOgFCwa/UbX7nUXWVhS7pukAIE1KqpIJSDL22/YSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H36ehHBK; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H36ehHBK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770405772; x=1801941772;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=llPkVaxCJEYAFDVjbKmaczSFyKpG35yasKcIaXAYMTU=;
  b=H36ehHBKodmEqbkF2kPjxyitJGb/Ad3GOKQnAlUsYxwqxE3NI5JlA0CZ
   2lO4mW+b4Q2fqJXpkGF1P+pvjYWLFjYY7BXC0kXBWffOEdfrkov6tmCgH
   yfayde1/j4f9uvNboBzohAeeCX21NigmiyXxdy0Euf2eeo5/Uz18TZsED
   bWIWk34f2pUaOkCGQd4anWKC0sK2w2pYBtk0jn2LlzqJnx6otAivO8JvQ
   akZXmYSTBgl+V/v8u/5tuK8ZNTWjYA/azTyb4tYghxel8/ZMxb9CxC9oj
   pLpDZlKFQuGqm2rf5MThHNxuwpB36ty+KmFUqNCFbMNFVGx1Cf4hfU+Z1
   g==;
X-CSE-ConnectionGUID: 2laFMSeZTDuwZpH+yAOCsA==
X-CSE-MsgGUID: WntRLvXPShibR1AnoeRH8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="75468353"
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="75468353"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 11:22:52 -0800
X-CSE-ConnectionGUID: qm7SQkvhRxqu0mXlO7r91Q==
X-CSE-MsgGUID: 15DK0z3WRyeAEDX7vape3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="215929553"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by orviesa005.jf.intel.com with ESMTP; 06 Feb 2026 11:22:50 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1voRPj-000000004hB-2y7H;
	Fri, 06 Feb 2026 19:22:47 +0000
Date: Fri, 6 Feb 2026 20:22:00 +0100
From: kernel test robot <lkp@intel.com>
To: sunliming@linux.dev, song@kernel.org, yukuai@fnnas.com
Cc: oe-kbuild-all@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, linan666@huaweicloud.com,
	sunliming <sunliming@kylinos.cn>
Subject: Re: [PATCH v2 2/3] lib/raid6: Optimizing the raid6_select_algo time
 through asynchronous processing
Message-ID: <202602062027.j08UeCWD-lkp@intel.com>
References: <20260206054341.106878-3-sunliming@linux.dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206054341.106878-3-sunliming@linux.dev>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on linus/master v6.16-rc1 next-20260205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/sunliming-linux-dev/lib-raid6-Divide-the-raid6-algorithm-selection-process-into-two-parts/20260206-134850
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260206054341.106878-3-sunliming%40linux.dev
patch subject: [PATCH v2 2/3] lib/raid6: Optimizing the raid6_select_algo time through asynchronous processing
config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260206/202602062027.j08UeCWD-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260206/202602062027.j08UeCWD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602062027.j08UeCWD-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: lib/raid6/raid6_pq: section mismatch in reference: raid6_exit+0xc (section: .text) -> raid6_benchmark_work (section: .init.data)
WARNING: modpost: lib/raid6/raid6_pq: section mismatch in reference: raid6_exit+0x10 (section: .text) -> raid6_benchmark_work (section: .init.data)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
