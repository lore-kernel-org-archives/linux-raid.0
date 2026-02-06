Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D171A9F82;
	Fri,  6 Feb 2026 19:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770406493; cv=none; b=RNy7sNxdpyDRJb6pAzcoVlz0FOJmHSoICmTYAii/GK1JCdgSyUDV2A/BBU+ztQA6Bd4Db++S4ncGuzYsOWNa/n1g6sG5j7R0hoM0GADk2dfE/CAcFJIXfk07HgHyaVc2L6IfnSLikIRuH9annskhMEpkIglB8H7MAzr6BXV5xBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770406493; c=relaxed/simple;
	bh=ITV7RnoHh0t7L+qb1wBTQ/KdocFTjVOticfmMkZAynE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gc2uPwEcay5cBUFxGHMrJTlVDrPSCOIrNt/DHRIcOi4WB1GlNRu6c5RL3Yt2egyT7MpCxQQ/LtICXW8hGUhZRPTQK7R8gqTEfwS76XlSS91ikt+jmbyTmqf8u+EAFKCalcLpkQpQCPYJXyObYy/5W3TMFPqqgcUtGHFCsdegXzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mgUzey+p; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mgUzey+p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770406493; x=1801942493;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ITV7RnoHh0t7L+qb1wBTQ/KdocFTjVOticfmMkZAynE=;
  b=mgUzey+pjSvbwjbIWEWgowZxbAOtjC+pBsUMY7phownRqal5bADg/2lt
   VZIxMCof7NLcNykttVttx6A6tXHx2nZ//iCjq5jRF5gdMxG6qUbrWDfLM
   2yURc+KZoITxma6qH7k3Z5M3qLxtsxXNGBUzR0M1mEtwt6fVtKPYTkJYA
   VPlxfSketyd0uk9O8UIKXogfISD3wZj5o4x0ih3wVW3WLSgci2UoJGRkd
   gtvusF4TNtlvJZ/uZ8D8w4N8tfw7zCTPUmmAEexk6pPbauqJZbg1J69/Z
   SHUgoExmJqy4DSa5q7uB6kforKMxfab1Ns2fX/w7/eanwKtQS7+0hZXqG
   w==;
X-CSE-ConnectionGUID: 7a4t9i9/Qv2BWJ+I9/gL0A==
X-CSE-MsgGUID: rHoRHe/qQT2PrQtuXEq2LA==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="71801413"
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="71801413"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 11:34:52 -0800
X-CSE-ConnectionGUID: 9j8E7j0pSyOGDkUdUxONGA==
X-CSE-MsgGUID: ps3E8N1/TnS7CZjTXI6ixQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="210755278"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by orviesa009.jf.intel.com with ESMTP; 06 Feb 2026 11:34:49 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1voRbL-000000004hJ-3QgN;
	Fri, 06 Feb 2026 19:34:47 +0000
Date: Fri, 6 Feb 2026 20:34:20 +0100
From: kernel test robot <lkp@intel.com>
To: sunliming@linux.dev, song@kernel.org, yukuai@fnnas.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com, sunliming <sunliming@kylinos.cn>
Subject: Re: [PATCH v2 2/3] lib/raid6: Optimizing the raid6_select_algo time
 through asynchronous processing
Message-ID: <202602062049.sdwQ1NiZ-lkp@intel.com>
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260206/202602062049.sdwQ1NiZ-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260206/202602062049.sdwQ1NiZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602062049.sdwQ1NiZ-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: lib/raid6/raid6_pq: section mismatch in reference: cleanup_module+0xc (section: .text) -> raid6_benchmark_work (section: .init.data)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
