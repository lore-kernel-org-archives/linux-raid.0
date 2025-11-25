Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9019A2D7DF2;
	Tue, 25 Nov 2025 08:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764058999; cv=none; b=oYP3rQ9q51EC9/E/dFFzX/ix5jaRuQ1kY57cJMiA8FPnyhyDO5BUEd5kKh9U0LRpEdgx9FXUn/FelSgaSw0GYznShMPUQwsEgUuOcBEXAfGR4QZKc1I8wtnzrCcqJJZXpdpyaCqkgyPqdKV81Gzpewv5cmwKRuzTxS8VklEQkoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764058999; c=relaxed/simple;
	bh=iHnuAzg5Y36JfHrwMOtdYEIY4hCpt8N1qkpMCABSUew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FrL9r1SkFVBzyWPPCZd+G+6xyVLMYlY1qkrDCiwspYAe7TZWijuTzQhmyqnICowZqQLYIfofslsf/yuOP6UA0wj6bbuMDKLAZV204Mi4OHkXIVyJBu6clf3vaTjpsLBX02JTY6E0cmZPOJGOJrjJhV0Lp+DqGAYnGTXZOFwdXTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QM9i2/en; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QM9i2/en"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764058998; x=1795594998;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iHnuAzg5Y36JfHrwMOtdYEIY4hCpt8N1qkpMCABSUew=;
  b=QM9i2/en81uuO3SdSCRQTJ/iqbLkw8dghvHcGAE0Mb3yBQx9uX+RHZBs
   4eO6e33iKh5cPERi+z+OWwP7ucSIKnrzLQE31RP9srCFnB/LDPzTf+WCf
   OBENZ9r2nUn7HgLP5Yb55lILz/t7VoTeGRViJ6O6Q9zH7H/8ZM5aimwCS
   ByI6/0BazSIuTfn0hx/aAcOUzNOiIm5qejuKNsAZ0iVNnjrtz62gpN7Sj
   rQ7rxokZmDNbUNy/yX7kvPHSmEPPw+hK9U0PAd2XbOA22lln1BgS1YWBJ
   H1g0iHDaMqIIZbbgtJwP0O7CwOX7qB60EnF+bEQ8T+zLAUEPqgV8aZsMC
   g==;
X-CSE-ConnectionGUID: Y87Z94tNTfKeUOABnV9v4w==
X-CSE-MsgGUID: PyE2ZCW/T4Gv7cj2MUS8Nw==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="66014918"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="66014918"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 00:23:17 -0800
X-CSE-ConnectionGUID: 5to+wKuSQceNPW/Yh5BG9w==
X-CSE-MsgGUID: w+IJo+MAT0aExu4Zs5430Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="191705924"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 25 Nov 2025 00:23:15 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vNoKP-000000001Vt-0aXi;
	Tue, 25 Nov 2025 08:23:13 +0000
Date: Tue, 25 Nov 2025 16:23:09 +0800
From: kernel test robot <lkp@intel.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, linan122@huawei.com, xni@redhat.com
Subject: Re: [PATCH] md: support to align bio to limits
Message-ID: <202511251523.ariD3O9E-lkp@intel.com>
References: <20251121051406.1316884-3-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121051406.1316884-3-yukuai@fnnas.com>

Hi Yu,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.18-rc7 next-20251124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-support-to-align-bio-to-limits/20251121-131703
base:   linus/master
patch link:    https://lore.kernel.org/r/20251121051406.1316884-3-yukuai%40fnnas.com
patch subject: [PATCH] md: support to align bio to limits
config: arm-randconfig-002-20251125 (https://download.01.org/0day-ci/archive/20251125/202511251523.ariD3O9E-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251125/202511251523.ariD3O9E-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511251523.ariD3O9E-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__aeabi_uldivmod" [drivers/md/md-mod.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
