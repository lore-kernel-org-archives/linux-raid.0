Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716471D1726;
	Thu, 22 Aug 2024 22:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724364490; cv=none; b=hrmG2ECU9PyumQU9CswYdZsXE2KUVWCut6RGjctZZ22icX0pJBlL8Oqz/wY8u9dBG/oBj2vEL4gQfpZbzPU6l/5brrwtSpBvDxFuhfUrS0EChI2nBTuW6i4/W34Rean8Ig/tGO5p06R2u4dSQkST/3u+Z6Uugl8UHG9MIB/RUoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724364490; c=relaxed/simple;
	bh=SKeCR3aepMCJp8PsMCBEO9vQI7iqOgVY8Vselt1nZaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gQMQ2x3CWikPPgdWsxVrnN5Vt2ZMS9+RbkbjHTDitoVCxNY3eJIkktGKGJ5B93G2HlSzORcGhykr4uE/e/6l4Z4pLOQZAbf8NVCLOm0kIl67BnY1p/Ai8bVOXux22kzA6eAKzHtf2c0jREP1rpMhpH6UfxK5NAaOOU/8LENTuxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pd4JAvhA; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pd4JAvhA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724364489; x=1755900489;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SKeCR3aepMCJp8PsMCBEO9vQI7iqOgVY8Vselt1nZaM=;
  b=Pd4JAvhALUwnEIRGDRfj81BbfwSgQIRVJDFtigdnMHhM3shCKxhS0W9m
   G39gWLrvYO0gFEqHkTarDuTAv/qpLzFY01hvPMVPINw18P8ukwyHpoZFj
   lqgAAQpd5f0lKKhobU7Ut9ENGOXWxArGMHWCYTGagccd40JVg89rokwJ7
   bOWxp3H3NyfDCwecP9/WH3k0YJmRYsvhhnfNfVTsPqbXP9Q7/tQ1n8N5K
   JF8oCHYxOa4pa4oSFN/J2h7mP0CyykVLceevTfrY2nKTj6SAYlpmBADF7
   lMWuGuiW3CtY3cOU259mgJPLohkunbAcAAaYlnE88cJiWQ5U7drOIZtaa
   w==;
X-CSE-ConnectionGUID: H3zDzldvQc2g+uSl3hHy8A==
X-CSE-MsgGUID: w4LAiboFSeaeyH8dMC6qWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11172"; a="22677747"
X-IronPort-AV: E=Sophos;i="6.10,168,1719903600"; 
   d="scan'208";a="22677747"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2024 15:08:08 -0700
X-CSE-ConnectionGUID: 1qR69IqqTg+OhZmK7uK4kA==
X-CSE-MsgGUID: fWT2TuyQSWmTiFyCfi1fgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,168,1719903600"; 
   d="scan'208";a="92384742"
Received: from lkp-server01.sh.intel.com (HELO 9a732dc145d3) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 22 Aug 2024 15:08:04 -0700
Received: from kbuild by 9a732dc145d3 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1shFyN-000DEc-0S;
	Thu, 22 Aug 2024 22:08:03 +0000
Date: Fri, 23 Aug 2024 06:07:06 +0800
From: kernel test robot <lkp@intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org,
	mariusz.tkaczyk@linux.intel.com, l@damenly.org, xni@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, yukuai3@huawei.com,
	yukuai1@huaweicloud.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH md-6.12 05/41] md/md-bitmap: add 'sync_size' into struct
 md_bitmap_stats
Message-ID: <202408230544.w18wb47U-lkp@intel.com>
References: <20240822024718.2158259-6-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822024718.2158259-6-yukuai1@huaweicloud.com>

Hi Yu,

kernel test robot noticed the following build warnings:

[auto build test WARNING on device-mapper-dm/for-next]
[also build test WARNING on linus/master v6.11-rc4 next-20240822]
[cannot apply to song-md/md-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-raid1-use-md_bitmap_wait_behind_writes-in-raid1_read_request/20240822-110233
base:   https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git for-next
patch link:    https://lore.kernel.org/r/20240822024718.2158259-6-yukuai1%40huaweicloud.com
patch subject: [PATCH md-6.12 05/41] md/md-bitmap: add 'sync_size' into struct md_bitmap_stats
config: x86_64-randconfig-121-20240822 (https://download.01.org/0day-ci/archive/20240823/202408230544.w18wb47U-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240823/202408230544.w18wb47U-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408230544.w18wb47U-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/md/md-bitmap.c:2106:26: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long sync_size @@     got restricted __le64 [usertype] sync_size @@
   drivers/md/md-bitmap.c:2106:26: sparse:     expected unsigned long sync_size
   drivers/md/md-bitmap.c:2106:26: sparse:     got restricted __le64 [usertype] sync_size
   drivers/md/md-bitmap.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/xarray.h, ...):
   include/linux/page-flags.h:235:46: sparse: sparse: self-comparison always evaluates to false
   include/linux/page-flags.h:235:46: sparse: sparse: self-comparison always evaluates to false

vim +2106 drivers/md/md-bitmap.c

  2096	
  2097	int md_bitmap_get_stats(struct bitmap *bitmap, struct md_bitmap_stats *stats)
  2098	{
  2099		struct bitmap_counts *counts;
  2100		bitmap_super_t *sb;
  2101	
  2102		if (!bitmap)
  2103			return -ENOENT;
  2104	
  2105		sb = kmap_local_page(bitmap->storage.sb_page);
> 2106		stats->sync_size = sb->sync_size;
  2107		kunmap_local(sb);
  2108	
  2109		counts = &bitmap->counts;
  2110		stats->missing_pages = counts->missing_pages;
  2111		stats->pages = counts->pages;
  2112	
  2113		stats->events_cleared = bitmap->events_cleared;
  2114		stats->file = bitmap->storage.file;
  2115	
  2116		return 0;
  2117	}
  2118	EXPORT_SYMBOL_GPL(md_bitmap_get_stats);
  2119	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
