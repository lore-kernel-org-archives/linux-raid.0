Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116263382C5;
	Thu, 30 Apr 2026 19:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777578492; cv=none; b=bqyQQkkVsSs0aXmDMG6r1nLo0VyHXSFWer78uzE7RcTS3RH+B6O1CvlcxqOr/Kaw2qS7eAf0SVGUrpJl9uNNtMiWZmljXnx74/tj2kJmcOdFu2h1fGYf+R40++VtitCWXd5JxOmrOm9JjsxALaTbtjzvJIhRCOgk8dQIM6p4C3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777578492; c=relaxed/simple;
	bh=5nl9s94pso3iuR1gXaPCzFTEGeLjFe6KV39n5Pc+bRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eikd2zy4x/jpdRkFnuE2eA24bkKWHwL3h7DOp+64P3Gwhssm3C0S+0/lOgOrT8O6y5fhsJj7Atd3czE6kVNV2NjjsH3Y/FmCdRR6B8LEF+8up0hEyaz6DAJSMHMbgwQeRqStlzoj1PA5DorUOPc5dMKFv0NulWVvlVoHkp8+m1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JsYOpcpv; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JsYOpcpv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777578490; x=1809114490;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5nl9s94pso3iuR1gXaPCzFTEGeLjFe6KV39n5Pc+bRg=;
  b=JsYOpcpvDQVf/6HApl2gVewnS0GgVNjAE2Iml2wqW3iAnuugpT3JSnRw
   A1iD3G7fJyloPM7RCe9pTr+AwSzST+323zRThiqbeyO2ZOCGHIsIMgakz
   O00BoaPlWIw0p0X1Lp47N5rhi6jdI34jKNpQ+8qOcCWhRhZn1Wn7xIOZE
   rAwS6qqM9hDv9do80oO/C51AwWtNMvfFyO+zs1/E33rWwtKgsP5c+xZs2
   4nfyjlndPUZrsNzLzby+8nXAv0SzKUvuxBC+BXdcskmDKO0NLoFdWEmPm
   vDI6+gl6Dhao+rz5K11lL3kHUSetaZ/4b4KFdnOt1StztafrXivDb1WfM
   Q==;
X-CSE-ConnectionGUID: GOkQe5R4Sm6EHChNbkiXGw==
X-CSE-MsgGUID: 1lJRrJIuRMqWD3qocPECSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="78437730"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="78437730"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 12:48:09 -0700
X-CSE-ConnectionGUID: 3CTchPuvS/CTZXdSwaV8yQ==
X-CSE-MsgGUID: O8slR18sSxaluuYIyueL+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="236480462"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 30 Apr 2026 12:48:08 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIXMj-00000000CsW-1kUH;
	Thu, 30 Apr 2026 19:48:05 +0000
Date: Fri, 1 May 2026 03:48:03 +0800
From: kernel test robot <lkp@intel.com>
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Li Nan <linan122@huawei.com>, Yu Kuai <yukuai@fnnas.com>,
	Cheng Cheng <chencheng@fnnas.com>
Subject: Re: [PATCH] md/raid5: split reshape bios before bitmap accounting
Message-ID: <202605010352.oO1uCwCR-lkp@intel.com>
References: <20260419030942.824195-20-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260419030942.824195-20-yukuai@fnnas.com>

Hi Yu,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on song-md/md-next v7.1-rc1 next-20260429]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-raid5-split-reshape-bios-before-bitmap-accounting/20260425-083941
base:   linus/master
patch link:    https://lore.kernel.org/r/20260419030942.824195-20-yukuai%40fnnas.com
patch subject: [PATCH] md/raid5: split reshape bios before bitmap accounting
config: arc-randconfig-001 (https://download.01.org/0day-ci/archive/20260501/202605010352.oO1uCwCR-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260501/202605010352.oO1uCwCR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605010352.oO1uCwCR-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/md/raid5.c: In function 'raid5_make_request':
   drivers/md/raid5.c:6126:7: error: implicit declaration of function 'mddev_bio_split_at_reshape_offset' [-Werror=implicit-function-declaration]
     bi = mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/raid5.c:6126:5: warning: assignment to 'struct bio *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     bi = mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
        ^
   cc1: some warnings being treated as errors


vim +6126 drivers/md/raid5.c

  6083	
  6084	static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
  6085	{
  6086		DEFINE_WAIT_FUNC(wait, woken_wake_function);
  6087		struct r5conf *conf = mddev->private;
  6088		const int rw = bio_data_dir(bi);
  6089		struct stripe_request_ctx *ctx;
  6090		sector_t logical_sector;
  6091		enum stripe_result res;
  6092		int s, stripe_cnt;
  6093		bool on_wq;
  6094	
  6095		if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
  6096			int ret = log_handle_flush_request(conf, bi);
  6097	
  6098			if (ret == 0)
  6099				return true;
  6100			if (ret == -ENODEV) {
  6101				if (md_flush_request(mddev, bi))
  6102					return true;
  6103			}
  6104			/* ret == -EAGAIN, fallback */
  6105		}
  6106	
  6107		md_write_start(mddev, bi);
  6108		/*
  6109		 * If array is degraded, better not do chunk aligned read because
  6110		 * later we might have to read it again in order to reconstruct
  6111		 * data on failed drives.
  6112		 */
  6113		if (rw == READ && mddev->degraded == 0 &&
  6114		    mddev->reshape_position == MaxSector) {
  6115			bi = chunk_aligned_read(mddev, bi);
  6116			if (!bi)
  6117				return true;
  6118		}
  6119	
  6120		if (unlikely(bio_op(bi) == REQ_OP_DISCARD)) {
  6121			make_discard_request(mddev, bi);
  6122			md_write_end(mddev);
  6123			return true;
  6124		}
  6125	
> 6126		bi = mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
  6127						       &conf->bio_split);
  6128		if (!bi) {
  6129			if (rw == WRITE)
  6130				md_write_end(mddev);
  6131			return true;
  6132		}
  6133	
  6134		logical_sector = bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SECTORS(conf)-1);
  6135		bi->bi_next = NULL;
  6136	
  6137		ctx = mempool_alloc(conf->ctx_pool, GFP_NOIO);
  6138		memset(ctx, 0, conf->ctx_size);
  6139		ctx->first_sector = logical_sector;
  6140		ctx->last_sector = bio_end_sector(bi);
  6141		/*
  6142		 * if r5l_handle_flush_request() didn't clear REQ_PREFLUSH,
  6143		 * we need to flush journal device
  6144		 */
  6145		if (unlikely(bi->bi_opf & REQ_PREFLUSH))
  6146			ctx->do_flush = true;
  6147	
  6148		stripe_cnt = DIV_ROUND_UP_SECTOR_T(ctx->last_sector - logical_sector,
  6149						   RAID5_STRIPE_SECTORS(conf));
  6150		bitmap_set(ctx->sectors_to_do, 0, stripe_cnt);
  6151	
  6152		pr_debug("raid456: %s, logical %llu to %llu\n", __func__,
  6153			 bi->bi_iter.bi_sector, ctx->last_sector);
  6154	
  6155		/* Bail out if conflicts with reshape and REQ_NOWAIT is set */
  6156		if ((bi->bi_opf & REQ_NOWAIT) &&
  6157		    get_reshape_loc(mddev, conf, logical_sector) == LOC_INSIDE_RESHAPE) {
  6158			bio_wouldblock_error(bi);
  6159			if (rw == WRITE)
  6160				md_write_end(mddev);
  6161			mempool_free(ctx, conf->ctx_pool);
  6162			return true;
  6163		}
  6164		md_account_bio(mddev, &bi);
  6165	
  6166		/*
  6167		 * Lets start with the stripe with the lowest chunk offset in the first
  6168		 * chunk. That has the best chances of creating IOs adjacent to
  6169		 * previous IOs in case of sequential IO and thus creates the most
  6170		 * sequential IO pattern. We don't bother with the optimization when
  6171		 * reshaping as the performance benefit is not worth the complexity.
  6172		 */
  6173		if (likely(conf->reshape_progress == MaxSector)) {
  6174			logical_sector = raid5_bio_lowest_chunk_sector(conf, bi);
  6175			on_wq = false;
  6176		} else {
  6177			add_wait_queue(&conf->wait_for_reshape, &wait);
  6178			on_wq = true;
  6179		}
  6180		s = (logical_sector - ctx->first_sector) >> RAID5_STRIPE_SHIFT(conf);
  6181	
  6182		while (1) {
  6183			res = make_stripe_request(mddev, conf, ctx, logical_sector,
  6184						  bi);
  6185			if (res == STRIPE_FAIL || res == STRIPE_WAIT_RESHAPE)
  6186				break;
  6187	
  6188			if (res == STRIPE_RETRY)
  6189				continue;
  6190	
  6191			if (res == STRIPE_SCHEDULE_AND_RETRY) {
  6192				WARN_ON_ONCE(!on_wq);
  6193				/*
  6194				 * Must release the reference to batch_last before
  6195				 * scheduling and waiting for work to be done,
  6196				 * otherwise the batch_last stripe head could prevent
  6197				 * raid5_activate_delayed() from making progress
  6198				 * and thus deadlocking.
  6199				 */
  6200				if (ctx->batch_last) {
  6201					raid5_release_stripe(ctx->batch_last);
  6202					ctx->batch_last = NULL;
  6203				}
  6204	
  6205				wait_woken(&wait, TASK_UNINTERRUPTIBLE,
  6206					   MAX_SCHEDULE_TIMEOUT);
  6207				continue;
  6208			}
  6209	
  6210			s = find_next_bit_wrap(ctx->sectors_to_do, stripe_cnt, s);
  6211			if (s == stripe_cnt)
  6212				break;
  6213	
  6214			logical_sector = ctx->first_sector +
  6215				(s << RAID5_STRIPE_SHIFT(conf));
  6216		}
  6217		if (unlikely(on_wq))
  6218			remove_wait_queue(&conf->wait_for_reshape, &wait);
  6219	
  6220		if (ctx->batch_last)
  6221			raid5_release_stripe(ctx->batch_last);
  6222	
  6223		if (rw == WRITE)
  6224			md_write_end(mddev);
  6225	
  6226		mempool_free(ctx, conf->ctx_pool);
  6227		if (res == STRIPE_WAIT_RESHAPE) {
  6228			md_free_cloned_bio(bi);
  6229			return false;
  6230		}
  6231	
  6232		bio_endio(bi);
  6233		return true;
  6234	}
  6235	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
