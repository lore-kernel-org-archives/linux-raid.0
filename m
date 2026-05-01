Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9838C3D6474;
	Fri,  1 May 2026 18:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777661575; cv=none; b=VQH0JaiJmk8BGP4Rm8+dFSWAFCN3q+ERUzvU89RQVfV6LLWy/WPNwGjyIa2xw57ByVP3MEFcD8yamUIfXRwvM/UKbeU31dHHdEcIZH31LdxmgLKZxwN/Kj6+JPFSsIIlHfb5slAbiLCZTQTNChC3ZV6fUKRPo4nYtlB78gLQlHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777661575; c=relaxed/simple;
	bh=Gb81zF9Tq5L5FBR3lJVIDEkIRRuAY1002gP+x4TmFgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PEkfE+QVUpWq6R2RgrIodhLOG2ESz5ElJRzq2ajMr2OH4EJaBTiafknTded4l3fJ99WnPNZd7KkdGZ0NSYMtQ7/qLBQeRddFiIxzE3Tns8nGePs4YtYEVNLJH47wHfi28IHYYJUIy8/LZbBsWpm32Z7dXtRicvjpVy5sfadcS3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VGDqi1zt; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VGDqi1zt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777661572; x=1809197572;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Gb81zF9Tq5L5FBR3lJVIDEkIRRuAY1002gP+x4TmFgA=;
  b=VGDqi1ztM1JkhiKw9+zlO5we7zJ19+nb9PZ3QDvJscjjqgTSbtqskw+K
   jI3Rh5yhRl6rj0w3SFA7/yT6D0XgTD4yAfqd26C+IPijWczLiHbmyTZdM
   HM4XKJTxI6pKWOmDLWpuu18Eh8mu1sr3f5OuQ5mbd7VLkbiYVA9UXpJCl
   RU4j4h6LmFc3BZME1Rywk5n+gi4UOPVgkAdn02CrXsFjHZPghcVTVaJFo
   u/w/oN1j8tj0bKfy3wYss5RgBk9zdQ9uUgycJVUHDYB3jZDFdB7HgjpR3
   tSQZjDFuiu6mBRWznnITKbgISp/BsvXvRygedKq4KY32xcB0XhIdlYX8s
   g==;
X-CSE-ConnectionGUID: 8sd8KbfhSGaRW1HHb2ua2g==
X-CSE-MsgGUID: 9IMbR3plR3K3hpJ2VG2Mlg==
X-IronPort-AV: E=McAfee;i="6800,10657,11773"; a="78613715"
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="78613715"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2026 11:52:52 -0700
X-CSE-ConnectionGUID: 9DSJie/HSi+Un+oXPDhhiA==
X-CSE-MsgGUID: /pX7oiyERJ2wQOKkYXQhdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,210,1770624000"; 
   d="scan'208";a="238907819"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 01 May 2026 11:52:49 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIsyk-000000000mj-1sql;
	Fri, 01 May 2026 18:52:46 +0000
Date: Sat, 2 May 2026 02:51:52 +0800
From: kernel test robot <lkp@intel.com>
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>, Cheng Cheng <chencheng@fnnas.com>
Subject: Re: [PATCH] md/raid5: add exact old and new llbitmap mapping helpers
Message-ID: <202605020242.1lRKHrkP-lkp@intel.com>
References: <20260419030942.824195-17-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260419030942.824195-17-yukuai@fnnas.com>

Hi Yu,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.1-rc1 next-20260430]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-raid5-add-exact-old-and-new-llbitmap-mapping-helpers/20260421-233709
base:   linus/master
patch link:    https://lore.kernel.org/r/20260419030942.824195-17-yukuai%40fnnas.com
patch subject: [PATCH] md/raid5: add exact old and new llbitmap mapping helpers
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20260502/202605020242.1lRKHrkP-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260502/202605020242.1lRKHrkP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605020242.1lRKHrkP-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/raid5.c:9065:3: error: field designator 'bitmap_sector_map' does not refer to any field in type 'struct md_personality'; did you mean 'bitmap_sector'?
    9065 |         .bitmap_sector_map = raid5_bitmap_sector_map,
         |          ^~~~~~~~~~~~~~~~~
         |          bitmap_sector
   drivers/md/md.h:797:9: note: 'bitmap_sector' declared here
     797 |         void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
         |                ^
>> drivers/md/raid5.c:9065:23: error: incompatible function pointer types initializing 'void (*)(struct mddev *, sector_t *, unsigned long *)' (aka 'void (*)(struct mddev *, unsigned long long *, unsigned long *)') with an expression of type 'void (struct mddev *, sector_t *, unsigned long *, bool)' (aka 'void (struct mddev *, unsigned long long *, unsigned long *, _Bool)') [-Wincompatible-function-pointer-types]
    9065 |         .bitmap_sector_map = raid5_bitmap_sector_map,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9065:23: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
    9065 |         .bitmap_sector_map = raid5_bitmap_sector_map,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9064:19: note: previous initialization is here
    9064 |         .bitmap_sector  = raid5_bitmap_sector,
         |                           ^~~~~~~~~~~~~~~~~~~
>> drivers/md/raid5.c:9066:3: error: field designator 'bitmap_sync_size' does not refer to any field in type 'struct md_personality'
    9066 |         .bitmap_sync_size = raid5_bitmap_sync_size,
         |         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/raid5.c:9067:3: error: field designator 'bitmap_array_sectors' does not refer to any field in type 'struct md_personality'
    9067 |         .bitmap_array_sectors = raid5_bitmap_array_sectors,
         |         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9098:3: error: field designator 'bitmap_sector_map' does not refer to any field in type 'struct md_personality'; did you mean 'bitmap_sector'?
    9098 |         .bitmap_sector_map = raid5_bitmap_sector_map,
         |          ^~~~~~~~~~~~~~~~~
         |          bitmap_sector
   drivers/md/md.h:797:9: note: 'bitmap_sector' declared here
     797 |         void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
         |                ^
   drivers/md/raid5.c:9098:23: error: incompatible function pointer types initializing 'void (*)(struct mddev *, sector_t *, unsigned long *)' (aka 'void (*)(struct mddev *, unsigned long long *, unsigned long *)') with an expression of type 'void (struct mddev *, sector_t *, unsigned long *, bool)' (aka 'void (struct mddev *, unsigned long long *, unsigned long *, _Bool)') [-Wincompatible-function-pointer-types]
    9098 |         .bitmap_sector_map = raid5_bitmap_sector_map,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9098:23: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
    9098 |         .bitmap_sector_map = raid5_bitmap_sector_map,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9097:19: note: previous initialization is here
    9097 |         .bitmap_sector  = raid5_bitmap_sector,
         |                           ^~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9099:3: error: field designator 'bitmap_sync_size' does not refer to any field in type 'struct md_personality'
    9099 |         .bitmap_sync_size = raid5_bitmap_sync_size,
         |         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9100:3: error: field designator 'bitmap_array_sectors' does not refer to any field in type 'struct md_personality'
    9100 |         .bitmap_array_sectors = raid5_bitmap_array_sectors,
         |         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9132:3: error: field designator 'bitmap_sector_map' does not refer to any field in type 'struct md_personality'; did you mean 'bitmap_sector'?
    9132 |         .bitmap_sector_map = raid5_bitmap_sector_map,
         |          ^~~~~~~~~~~~~~~~~
         |          bitmap_sector
   drivers/md/md.h:797:9: note: 'bitmap_sector' declared here
     797 |         void (*bitmap_sector)(struct mddev *mddev, sector_t *offset,
         |                ^
   drivers/md/raid5.c:9132:23: error: incompatible function pointer types initializing 'void (*)(struct mddev *, sector_t *, unsigned long *)' (aka 'void (*)(struct mddev *, unsigned long long *, unsigned long *)') with an expression of type 'void (struct mddev *, sector_t *, unsigned long *, bool)' (aka 'void (struct mddev *, unsigned long long *, unsigned long *, _Bool)') [-Wincompatible-function-pointer-types]
    9132 |         .bitmap_sector_map = raid5_bitmap_sector_map,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9132:23: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
    9132 |         .bitmap_sector_map = raid5_bitmap_sector_map,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9131:19: note: previous initialization is here
    9131 |         .bitmap_sector  = raid5_bitmap_sector,
         |                           ^~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9133:3: error: field designator 'bitmap_sync_size' does not refer to any field in type 'struct md_personality'
    9133 |         .bitmap_sync_size = raid5_bitmap_sync_size,
         |         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/md/raid5.c:9134:3: error: field designator 'bitmap_array_sectors' does not refer to any field in type 'struct md_personality'
    9134 |         .bitmap_array_sectors = raid5_bitmap_array_sectors,
         |         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   3 warnings and 12 errors generated.


vim +9065 drivers/md/raid5.c

  9035	
  9036	static struct md_personality raid6_personality =
  9037	{
  9038		.head = {
  9039			.type	= MD_PERSONALITY,
  9040			.id	= ID_RAID6,
  9041			.name	= "raid6",
  9042			.owner	= THIS_MODULE,
  9043		},
  9044	
  9045		.make_request	= raid5_make_request,
  9046		.run		= raid5_run,
  9047		.start		= raid5_start,
  9048		.free		= raid5_free,
  9049		.status		= raid5_status,
  9050		.error_handler	= raid5_error,
  9051		.hot_add_disk	= raid5_add_disk,
  9052		.hot_remove_disk= raid5_remove_disk,
  9053		.spare_active	= raid5_spare_active,
  9054		.sync_request	= raid5_sync_request,
  9055		.resize		= raid5_resize,
  9056		.size		= raid5_size,
  9057		.check_reshape	= raid6_check_reshape,
  9058		.start_reshape  = raid5_start_reshape,
  9059		.finish_reshape = raid5_finish_reshape,
  9060		.quiesce	= raid5_quiesce,
  9061		.takeover	= raid6_takeover,
  9062		.change_consistency_policy = raid5_change_consistency_policy,
  9063		.prepare_suspend = raid5_prepare_suspend,
  9064		.bitmap_sector	= raid5_bitmap_sector,
> 9065		.bitmap_sector_map = raid5_bitmap_sector_map,
> 9066		.bitmap_sync_size = raid5_bitmap_sync_size,
> 9067		.bitmap_array_sectors = raid5_bitmap_array_sectors,
  9068	};
  9069	static struct md_personality raid5_personality =
  9070	{
  9071		.head = {
  9072			.type	= MD_PERSONALITY,
  9073			.id	= ID_RAID5,
  9074			.name	= "raid5",
  9075			.owner	= THIS_MODULE,
  9076		},
  9077	
  9078		.make_request	= raid5_make_request,
  9079		.run		= raid5_run,
  9080		.start		= raid5_start,
  9081		.free		= raid5_free,
  9082		.status		= raid5_status,
  9083		.error_handler	= raid5_error,
  9084		.hot_add_disk	= raid5_add_disk,
  9085		.hot_remove_disk= raid5_remove_disk,
  9086		.spare_active	= raid5_spare_active,
  9087		.sync_request	= raid5_sync_request,
  9088		.resize		= raid5_resize,
  9089		.size		= raid5_size,
  9090		.check_reshape	= raid5_check_reshape,
  9091		.start_reshape  = raid5_start_reshape,
  9092		.finish_reshape = raid5_finish_reshape,
  9093		.quiesce	= raid5_quiesce,
  9094		.takeover	= raid5_takeover,
  9095		.change_consistency_policy = raid5_change_consistency_policy,
  9096		.prepare_suspend = raid5_prepare_suspend,
  9097		.bitmap_sector	= raid5_bitmap_sector,
  9098		.bitmap_sector_map = raid5_bitmap_sector_map,
  9099		.bitmap_sync_size = raid5_bitmap_sync_size,
  9100		.bitmap_array_sectors = raid5_bitmap_array_sectors,
  9101	};
  9102	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
