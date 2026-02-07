Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC0B29ACC0;
	Sat,  7 Feb 2026 07:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770449031; cv=none; b=DOEqdh8R4DajSGQqf+QTUtSMWq8scqGA1zhOzbxA4R4S1j7WVrYkZ65e2YXNPJ1UChjA361l+vLVsV9IzNB02G2BUKSaek0i70kANPPkrB5uUnldAEzphtg71dnFwcg2Oq4b4Fy9PF3kWfd7UpaXQrW59RmCbKdKZOGSwFK4WgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770449031; c=relaxed/simple;
	bh=2yJLt7YQffzBF7aZCupilEkAINWCTMeXVEKmgh0bokU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4Zc6Y4rbVmdNFIS9BS4r/714qY4/gCjFxX/nCJaiZTKQFEDkF2PxXBHJA8j9o847VDl0iWR8Ao74jKZwMlz1Bk8tTKHy1jweIcJIPp92fm9WAuVdu6EeZ8vkGxToFzNphSHBuzgifeu2VHjGdizz/0u54yKy/jMZcpX/vNj11U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cf+3iDc8; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cf+3iDc8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770449031; x=1801985031;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2yJLt7YQffzBF7aZCupilEkAINWCTMeXVEKmgh0bokU=;
  b=Cf+3iDc8WcobDoODgQJLWWpyTOkIF/1+c6U7jIUt9nMI5KxQUOoP8pYB
   hO6E5zL1TwWYQlG9z82GKETFNywlibPL8LobgPV9xED07zFlO91+Qi2+G
   B2AZfy1RifDoUsuFf9g5vR+Vl8JmLTh15ILwZVqFdHAhybF7dYTyMsuwH
   sbGoUOyucuWCkAF8+gCtEVo2Svfv2jMMGe+DZ4nqT/M9tZQhz1S/SbiSO
   a/l27neSaSQ//AKAnH/TNDh5YjCYeC61dlf0phYjfC0dvrn3EMX0VCBN+
   TV36vF3eV49iFYZJtlPFvlsZaIh6mlWgdxKAmcb1kkQQCstyau9tqKiJi
   w==;
X-CSE-ConnectionGUID: uXhjqtP6QTCje6G0LjjMpg==
X-CSE-MsgGUID: Z02ms+7gQ8+pcyikr8H2Ig==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="71830214"
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="71830214"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 23:23:37 -0800
X-CSE-ConnectionGUID: ut+ogVPRQquwpyY3GEMznA==
X-CSE-MsgGUID: 9nNmFlMoROmtzl1gD05VGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="216055406"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 06 Feb 2026 23:23:35 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vocfE-00000000lTs-2ww9;
	Sat, 07 Feb 2026 07:23:32 +0000
Date: Sat, 7 Feb 2026 15:22:53 +0800
From: kernel test robot <lkp@intel.com>
To: sunliming@linux.dev, song@kernel.org, yukuai@fnnas.com
Cc: oe-kbuild-all@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, linan666@huaweicloud.com,
	sunliming <sunliming@kylinos.cn>
Subject: Re: [PATCH v2 2/3] lib/raid6: Optimizing the raid6_select_algo time
 through asynchronous processing
Message-ID: <202602071500.ctQs6ZeY-lkp@intel.com>
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
[also build test WARNING on linus/master v6.19-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/sunliming-linux-dev/lib-raid6-Divide-the-raid6-algorithm-selection-process-into-two-parts/20260206-134850
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260206054341.106878-3-sunliming%40linux.dev
patch subject: [PATCH v2 2/3] lib/raid6: Optimizing the raid6_select_algo time through asynchronous processing
config: i386-buildonly-randconfig-001-20260207 (https://download.01.org/0day-ci/archive/20260207/202602071500.ctQs6ZeY-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260207/202602071500.ctQs6ZeY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602071500.ctQs6ZeY-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux: section mismatch in reference: raid6_exit+0x9 (section: .text) -> raid6_benchmark_work (section: .init.data)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
