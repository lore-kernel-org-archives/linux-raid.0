Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE12A247291;
	Thu, 30 Apr 2026 01:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777510825; cv=none; b=lVf7RJyRb2kE9BnzHXJ6SU6+q5rsaNbQHQEeTLHDnxpSM5fUrvC96PqWt4taGrtPGRU4kFpeB1j51TFPxB/ljZgJiHmEStdO0lKt/DDxviaFa63VD5P4zxW5Dv6tjwOHqBENnayRPEy8agG1PTRG3VLmX4eTlFgLl4+6hWED3kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777510825; c=relaxed/simple;
	bh=ZKHysuAxlJ9FcUWvxBuYMoCwUewrG9ZYNHuUm8WZvP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnSzp6KMyVyQSN6DEkdUfgbTMe9S9zJTqMwUOn7ahKCzcfuyrHFqyToFHuZte54HGuX8Fe+AJZXgrM/EPaQeRWfW7V4DfBfE0JJaM8lbMhnY/HXOSJCH7YFRLSJJi3SHs+T0i6lwUHy2hJakLNWcrsIIAtQcjUnPxI5y7VkY664=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oAgPtdXg; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oAgPtdXg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777510824; x=1809046824;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZKHysuAxlJ9FcUWvxBuYMoCwUewrG9ZYNHuUm8WZvP4=;
  b=oAgPtdXgSXBbSZRsQHNGTaPehGP+/tdETuh6sLDQtAKVeufWxj36TqxI
   xYpzW4Asj3Fks2pc5RAAmQFWir0cE+D6Gf5f9GVlMA/j6o2K8tyQZo9RS
   vERMksdQyZZJ32Y2W1c1+d8YfIrX+1jalcGcUuB+ftxZZmaA2NEeHQ//d
   36rekD8WhqbtGhPz0i6pPTZKzY3R5AWYiy6gOREa3AeEBpHPuzfauovgI
   DCmyVSDKRoYKnUgAZnRrJC9mGHpUDAdj9Gf83uG8Ev7AKjMFfS7OwFPMt
   yGNdR3ALQt4SEDxd3bBUsBYnpI7klO0528zMLrczGQnp7waaTOjiJLwgD
   Q==;
X-CSE-ConnectionGUID: 0NAhor4oSpC4ajdH6pFhSQ==
X-CSE-MsgGUID: EOZ8GIzKS6u/87rEiwWzOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="88765231"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="88765231"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 18:00:22 -0700
X-CSE-ConnectionGUID: 9Ka1Rgt7SimwNrti1gqc7Q==
X-CSE-MsgGUID: JV6rOf1SQZW+LQIwbPgHJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="239452396"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 29 Apr 2026 18:00:20 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIFlI-00000000BkE-3QWg;
	Thu, 30 Apr 2026 01:00:16 +0000
Date: Thu, 30 Apr 2026 08:59:55 +0800
From: kernel test robot <lkp@intel.com>
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>, Cheng Cheng <chencheng@fnnas.com>
Subject: Re: [PATCH] md/raid5: split reshape bios before bitmap accounting
Message-ID: <202604300803.nq5tYBQB-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on song-md/md-next v7.1-rc1 next-20260429]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-raid5-split-reshape-bios-before-bitmap-accounting/20260425-083941
base:   linus/master
patch link:    https://lore.kernel.org/r/20260419030942.824195-20-yukuai%40fnnas.com
patch subject: [PATCH] md/raid5: split reshape bios before bitmap accounting
config: um-randconfig-001-20260430 (https://download.01.org/0day-ci/archive/20260430/202604300803.nq5tYBQB-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604300803.nq5tYBQB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604300803.nq5tYBQB-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/md/raid5.c:4221:7: warning: variable 'qread' set but not used [-Wunused-but-set-variable]
    4221 |                 int qread =0;
         |                     ^
>> drivers/md/raid5.c:6126:7: error: call to undeclared function 'mddev_bio_split_at_reshape_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    6126 |         bi = mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
         |              ^
>> drivers/md/raid5.c:6126:5: error: incompatible integer to pointer conversion assigning to 'struct bio *' from 'int' [-Wint-conversion]
    6126 |         bi = mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
         |            ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    6127 |                                                &conf->bio_split);
         |                                                ~~~~~~~~~~~~~~~~~
   1 warning and 2 errors generated.


vim +/mddev_bio_split_at_reshape_offset +6126 drivers/md/raid5.c

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
