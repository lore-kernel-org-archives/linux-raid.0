Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF4E346773
	for <linux-raid@vger.kernel.org>; Thu,  5 Mar 2026 22:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772750361; cv=none; b=YOfqIQdgJWB3QllwyPBBOHkOhipfvDGCZV8Zj21si0XHVXdT1Zk/nndJz5m+tmzSgvVu1VNMz3LhQujhNMy6RtvWagflthfKfpI7ZhJPBgM895ee8e4ToXGMPFp0rCnGGbqihLgH8xL1JszVR3DYNKgMtVuY7BHwarCDroKaOUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772750361; c=relaxed/simple;
	bh=DFzcJJ/KZDxh+6fM/i/h2J03aqB/7P3r7N4gXvtgbLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VpWpHLrfPsCDxD+WFODHX8l+e0mChIs2fNrImAIg1RHDsKb3MOHoWVyLDqAvhnvtzyK6HlsDSVWB3AjSOT8HzkcwTKoPpqU6yrfS97oZP7+4BTfdlX/uhAwduJNFQAfDYR6IyXacJ50zFnNHOAw4vVAIxGsVDyPMY8esYuKnUKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uny/JMeS; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uny/JMeS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772750359; x=1804286359;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DFzcJJ/KZDxh+6fM/i/h2J03aqB/7P3r7N4gXvtgbLI=;
  b=Uny/JMeSDkMj4FXd8eXF6Ur7/vgxyq9VNgQ9HoHmGFaHteXxYvv1LBCm
   FtxAdDaxIACT5iKB28oMyx6TksfntkUpeZ2ZZP6GNNZ9dutA+rxtb0t1y
   2//8lfyEakBrQz8rsppiKe246YSg4hzlXuELcI1be5sLLbbqi2MS/YjI7
   KTNqLld+tKI80fLx89DjIFwoPtckqQ36s15eVd8exso5VivCw99vHDc1k
   EdznYbcifYHgr93bKlJp6Td2QXRI4qRF4cRTfp5/OOhymB2LkJucTENQu
   uT+QUTebp35hzgkWCpJiaBi1pw8/g0iJ8ASuNWjs3eKxnc8kKxmtZVuoA
   w==;
X-CSE-ConnectionGUID: A00rYftnRs6gV1nG65Q61A==
X-CSE-MsgGUID: uYNYpRIGT6a1XWGSaa4ezA==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85326402"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="85326402"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 14:39:19 -0800
X-CSE-ConnectionGUID: u+j+YSd8QYy/5kUFmSePag==
X-CSE-MsgGUID: 8pRjYiOIQMq9D4glG2oqeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="218068520"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 05 Mar 2026 14:39:16 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyHLc-00000000013-3EN6;
	Thu, 05 Mar 2026 22:39:12 +0000
Date: Fri, 6 Mar 2026 06:38:37 +0800
From: kernel test robot <lkp@intel.com>
To: Su Yue <glass.su@suse.com>, linux-raid@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, song@kernel.org, xni@redhat.com,
	linan122@huawei.com, yukuai@fnnas.com, heming.zhao@suse.com,
	l@damenly.org, Su Yue <glass.su@suse.com>
Subject: Re: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap
 offset while growing
Message-ID: <202603060651.tJ5tGHRo-lkp@intel.com>
References: <20260303033731.83885-2-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303033731.83885-2-glass.su@suse.com>

Hi Su,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.0-rc2 next-20260305]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Su-Yue/md-restore-bitmap-location-to-fix-wrong-bitmap-offset-while-growing/20260303-114108
base:   linus/master
patch link:    https://lore.kernel.org/r/20260303033731.83885-2-glass.su%40suse.com
patch subject: [PATCH 1/3] md: restore bitmap/location to fix wrong bitmap offset while growing
config: i386-randconfig-r064-20260305 (https://download.01.org/0day-ci/archive/20260306/202603060651.tJ5tGHRo-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260306/202603060651.tJ5tGHRo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603060651.tJ5tGHRo-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: md_sysfs_create_common_group
   >>> referenced by md.c:6376 (drivers/md/md.c:6376)
   >>>               drivers/md/md.o:(md_alloc) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
