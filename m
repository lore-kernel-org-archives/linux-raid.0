Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC0832F77B
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 01:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756862270; cv=none; b=ad0tLoXiRFntD71NT91WKP9D8IXnfwHioHoe9SVKnXqZ3SgEbRWfbq2ONfVCA7azuhu70XsC5RWUdMiC6A1cETE1otSKhL9h9yDSqn8eoxGVuMXNpWQ5yOJbyvJ5BrvP9N8lapurKLbp/H2QrPA9uuNEMFGwzfMnw+Q2vo0mPjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756862270; c=relaxed/simple;
	bh=opZBT57ekdEbfpomXg7fPY+H/QcJ8RLEu/MFl8k9xXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxAAWrXRWYq7qwEXyWIrlJiWuioOKK+P9KJmuC6FxJz7j0mkWPA+ILILJGUg4SVX6xJadyOmzKA50cqUxDwkbXKbMoYIHKRrpDbqf6gSAFC9yGe0tPgTHwmKoShJ+GY+SVoQoS4qDVsem4sktvvkWkw2ExFnLiGFpnw5Dl5ce6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iwax5TMr; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iwax5TMr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756862267; x=1788398267;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=opZBT57ekdEbfpomXg7fPY+H/QcJ8RLEu/MFl8k9xXo=;
  b=Iwax5TMrehYzxgPeJFz/wWDorHdUBwT1DneDh1fddx51gxFZLNyy9TV1
   ytUlQX+WmQF5tE9TrjyyEd+ZeRTdMql6cEqK4876C4U/jRWMIsUbrLCc9
   MDJ3ZRb8qQBXGkOjG8hfVhTMAzRRQE8dgpk/PwwLeZu1e3O1CdULG6fqp
   2ZO6UNX3tdtc+EuYsbk2KpaDwfueKe/RLnDyv54Q21oJk/u5nna2zQFXu
   vPBlnxLYzVBm9k/DmntM5uUdR6TMbTE4ui3RyHIzxr5wbuoeYQWL8kbxx
   pr/mTOwsWD/Lggo3pAp5OsPFOWE86VVFDrwhdZ/jH7rEPo4RB5EBXGQ0L
   g==;
X-CSE-ConnectionGUID: 96JdZa4pQIClRZfSYkWKKQ==
X-CSE-MsgGUID: VkNsvVP2SB+Ev7u56gQtnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81748665"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81748665"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 18:17:47 -0700
X-CSE-ConnectionGUID: GqWbRdv7SOOMvCDrTV2HuA==
X-CSE-MsgGUID: Atw3jwqlSACV1nYmCmOYNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="175802721"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 02 Sep 2025 18:17:44 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utc86-0003Dn-1K;
	Wed, 03 Sep 2025 01:17:42 +0000
Date: Wed, 3 Sep 2025 09:16:49 +0800
From: kernel test robot <lkp@intel.com>
To: Damien Le Moal <dlemoal@kernel.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH] md: Correctly disable write zeroes for raid 1, 10 and 5
Message-ID: <202509030804.BSCTfNfn-lkp@intel.com>
References: <20250902093843.187767-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902093843.187767-1-dlemoal@kernel.org>

Hi Damien,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.17-rc4 next-20250902]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Damien-Le-Moal/md-Correctly-disable-write-zeroes-for-raid-1-10-and-5/20250902-174321
base:   linus/master
patch link:    https://lore.kernel.org/r/20250902093843.187767-1-dlemoal%40kernel.org
patch subject: [PATCH] md: Correctly disable write zeroes for raid 1, 10 and 5
config: i386-buildonly-randconfig-004-20250903 (https://download.01.org/0day-ci/archive/20250903/202509030804.BSCTfNfn-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509030804.BSCTfNfn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509030804.BSCTfNfn-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/md/raid5.c:4207:7: warning: variable 'qread' set but not used [-Wunused-but-set-variable]
    4207 |                 int qread =0;
         |                     ^
>> drivers/md/raid5.c:7735:38: error: expected ';' after expression
    7735 |         lim.max_hw_wzeroes_unmap_sectors = 0
         |                                             ^
         |                                             ;
   1 warning and 1 error generated.


vim +7735 drivers/md/raid5.c

  7709	
  7710	static int raid5_set_limits(struct mddev *mddev)
  7711	{
  7712		struct r5conf *conf = mddev->private;
  7713		struct queue_limits lim;
  7714		int data_disks, stripe;
  7715		struct md_rdev *rdev;
  7716	
  7717		/*
  7718		 * The read-ahead size must cover two whole stripes, which is
  7719		 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices.
  7720		 */
  7721		data_disks = conf->previous_raid_disks - conf->max_degraded;
  7722	
  7723		/*
  7724		 * We can only discard a whole stripe. It doesn't make sense to
  7725		 * discard data disk but write parity disk
  7726		 */
  7727		stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
  7728	
  7729		md_init_stacking_limits(&lim);
  7730		lim.io_min = mddev->chunk_sectors << 9;
  7731		lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
  7732		lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
  7733		lim.discard_granularity = stripe;
  7734		lim.max_write_zeroes_sectors = 0;
> 7735		lim.max_hw_wzeroes_unmap_sectors = 0
  7736		mddev_stack_rdev_limits(mddev, &lim, 0);
  7737		rdev_for_each(rdev, mddev)
  7738			queue_limits_stack_bdev(&lim, rdev->bdev, rdev->new_data_offset,
  7739					mddev->gendisk->disk_name);
  7740	
  7741		/*
  7742		 * Zeroing is required for discard, otherwise data could be lost.
  7743		 *
  7744		 * Consider a scenario: discard a stripe (the stripe could be
  7745		 * inconsistent if discard_zeroes_data is 0); write one disk of the
  7746		 * stripe (the stripe could be inconsistent again depending on which
  7747		 * disks are used to calculate parity); the disk is broken; The stripe
  7748		 * data of this disk is lost.
  7749		 *
  7750		 * We only allow DISCARD if the sysadmin has confirmed that only safe
  7751		 * devices are in use by setting a module parameter.  A better idea
  7752		 * might be to turn DISCARD into WRITE_ZEROES requests, as that is
  7753		 * required to be safe.
  7754		 */
  7755		if (!devices_handle_discard_safely ||
  7756		    lim.max_discard_sectors < (stripe >> 9) ||
  7757		    lim.discard_granularity < stripe)
  7758			lim.max_hw_discard_sectors = 0;
  7759	
  7760		/*
  7761		 * Requests require having a bitmap for each stripe.
  7762		 * Limit the max sectors based on this.
  7763		 */
  7764		lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
  7765	
  7766		/* No restrictions on the number of segments in the request */
  7767		lim.max_segments = USHRT_MAX;
  7768	
  7769		return queue_limits_set(mddev->gendisk->queue, &lim);
  7770	}
  7771	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
