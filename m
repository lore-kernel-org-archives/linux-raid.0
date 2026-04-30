Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA6026E142;
	Thu, 30 Apr 2026 02:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777516711; cv=none; b=s5LcE27lLpkD0K//4DCycNvqdmo1mWPX/obF6sbmoVZ9vArLGjiAUO1Hk37RivOUb7syuXlgif8pMxnwTOeAGmbrACQ3zngy4OlYIy2GounAa8lKmX9fyGNp++tjv9bPVvPExA1xjyy4R4UUP7p+krpd9ArTzGLTHCzUGka8uuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777516711; c=relaxed/simple;
	bh=PkKOmBRTGLs12bBKng/adtfCsJNJYQSLMRRQ5O8w284=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNHiTKs4Iz9NC0oA4ydM8ioHb1iW6LM0hKxUJ2/3b1HHRB8RLHQoq+Nzv6zK0NVPQ3QoL/2SjregqALYtcIl6PTXUgy0Fyr3c3cH1eBKJew+fGs0J1W+95VcZMjjZXFaETxiBUQJOhSb9hcf2ebeV7YXdUr6aNlG7wLFRI5EtRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hqqrxIaC; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hqqrxIaC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777516710; x=1809052710;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PkKOmBRTGLs12bBKng/adtfCsJNJYQSLMRRQ5O8w284=;
  b=hqqrxIaC04mrbTf0hLssikehQ92UXE7N7xgpb3imbIhkaPF95o1PAHP/
   JbJc+s7dyg6yzF4rAM0uh8dr1UtoqQX9LZ+dfoGEgBGR8DZD5YWJRsXSb
   tiyJV+6Pb8xrthOHBMqqo8uAnS7iaIFncTcBRa95Oemlt0NmW89xWaXDa
   nKOcG9dHk/TDSRzvXX8F8cZW4hAGPd7aY3e93x5JWcNGBAc0Ez4vvPGMd
   k/RLp1cQ05CHDaFpcyStjBImTayVFn8atvdi5OJEs9p4sI2V6dMvBFcyJ
   vvn+p6AR3s3lBYRwABaT6vuDUdMuuUOfaKpv/6FK87vJfAi9cC+wytzad
   A==;
X-CSE-ConnectionGUID: OQJPQcKARueXMIHlimKeGg==
X-CSE-MsgGUID: O8fYjpSbRi2gH/IV0IlWsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78326859"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="78326859"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 19:38:29 -0700
X-CSE-ConnectionGUID: nZLfWukqQiCrK8qlh1SBlA==
X-CSE-MsgGUID: 2t/5erncQdKs5X5BtbJO1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="258031101"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 29 Apr 2026 19:38:27 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIHIG-00000000Bpk-3oHl;
	Thu, 30 Apr 2026 02:38:24 +0000
Date: Thu, 30 Apr 2026 10:37:47 +0800
From: kernel test robot <lkp@intel.com>
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai@fnnas.com>, Cheng Cheng <chencheng@fnnas.com>
Subject: Re: [PATCH] md/raid10: wire llbitmap reshape lifecycle
Message-ID: <202604301028.uutGNSgD-lkp@intel.com>
References: <20260419030942.824195-15-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260419030942.824195-15-yukuai@fnnas.com>

Hi Yu,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on song-md/md-next v7.1-rc1 next-20260429]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-raid10-wire-llbitmap-reshape-lifecycle/20260423-170302
base:   linus/master
patch link:    https://lore.kernel.org/r/20260419030942.824195-15-yukuai%40fnnas.com
patch subject: [PATCH] md/raid10: wire llbitmap reshape lifecycle
config: um-randconfig-001-20260430 (https://download.01.org/0day-ci/archive/20260430/202604301028.uutGNSgD-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604301028.uutGNSgD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604301028.uutGNSgD-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/raid10.c:4370:25: error: no member named 'reshape_can_start' in 'struct bitmap_operations'
    4370 |             mddev->bitmap_ops->reshape_can_start) {
         |             ~~~~~~~~~~~~~~~~~  ^
   drivers/md/raid10.c:4371:28: error: no member named 'reshape_can_start' in 'struct bitmap_operations'
    4371 |                 ret = mddev->bitmap_ops->reshape_can_start(mddev);
         |                       ~~~~~~~~~~~~~~~~~  ^
>> drivers/md/raid10.c:4689:26: error: no member named 'reshape_mark' in 'struct bitmap_operations'
    4689 |                     mddev->bitmap_ops->reshape_mark &&
         |                     ~~~~~~~~~~~~~~~~~  ^
   drivers/md/raid10.c:4691:23: error: no member named 'reshape_mark' in 'struct bitmap_operations'
    4691 |                         mddev->bitmap_ops->reshape_mark(mddev, conf->reshape_safe,
         |                         ~~~~~~~~~~~~~~~~~  ^
   drivers/md/raid10.c:4899:25: error: no member named 'reshape_mark' in 'struct bitmap_operations'
    4899 |             mddev->bitmap_ops->reshape_mark &&
         |             ~~~~~~~~~~~~~~~~~  ^
   drivers/md/raid10.c:4901:22: error: no member named 'reshape_mark' in 'struct bitmap_operations'
    4901 |                 mddev->bitmap_ops->reshape_mark(mddev, conf->reshape_safe,
         |                 ~~~~~~~~~~~~~~~~~  ^
>> drivers/md/raid10.c:5043:37: error: no member named 'reshape_finish' in 'struct bitmap_operations'
    5043 |         if (llbitmap && mddev->bitmap_ops->reshape_finish)
         |                         ~~~~~~~~~~~~~~~~~  ^
   drivers/md/raid10.c:5044:22: error: no member named 'reshape_finish' in 'struct bitmap_operations'
    5044 |                 mddev->bitmap_ops->reshape_finish(mddev);
         |                 ~~~~~~~~~~~~~~~~~  ^
>> drivers/md/raid10.c:5107:3: error: field designator 'bitmap_sync_size' does not refer to any field in type 'struct md_personality'
    5107 |         .bitmap_sync_size = raid10_bitmap_sync_size,
         |         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/md/raid10.c:5108:3: error: field designator 'bitmap_array_sectors' does not refer to any field in type 'struct md_personality'
    5108 |         .bitmap_array_sectors = raid10_bitmap_sync_size,
         |         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   10 errors generated.


vim +4370 drivers/md/raid10.c

  4345	
  4346	static int raid10_start_reshape(struct mddev *mddev)
  4347	{
  4348		/* A 'reshape' has been requested. This commits
  4349		 * the various 'new' fields and sets MD_RECOVER_RESHAPE
  4350		 * This also checks if there are enough spares and adds them
  4351		 * to the array.
  4352		 * We currently require enough spares to make the final
  4353		 * array non-degraded.  We also require that the difference
  4354		 * between old and new data_offset - on each device - is
  4355		 * enough that we never risk over-writing.
  4356		 */
  4357	
  4358		unsigned long before_length, after_length;
  4359		sector_t min_offset_diff = 0;
  4360		int first = 1;
  4361		struct geom new;
  4362		struct r10conf *conf = mddev->private;
  4363		struct md_rdev *rdev;
  4364		int spares = 0;
  4365		int ret;
  4366	
  4367		if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
  4368			return -EBUSY;
  4369		if (md_bitmap_enabled(mddev, false) &&
> 4370		    mddev->bitmap_ops->reshape_can_start) {
  4371			ret = mddev->bitmap_ops->reshape_can_start(mddev);
  4372			if (ret)
  4373				return ret;
  4374		}
  4375	
  4376		if (setup_geo(&new, mddev, geo_start) != conf->copies)
  4377			return -EINVAL;
  4378	
  4379		before_length = ((1 << conf->prev.chunk_shift) *
  4380				 conf->prev.far_copies);
  4381		after_length = ((1 << conf->geo.chunk_shift) *
  4382				conf->geo.far_copies);
  4383	
  4384		rdev_for_each(rdev, mddev) {
  4385			if (!test_bit(In_sync, &rdev->flags)
  4386			    && !test_bit(Faulty, &rdev->flags))
  4387				spares++;
  4388			if (rdev->raid_disk >= 0) {
  4389				long long diff = (rdev->new_data_offset
  4390						  - rdev->data_offset);
  4391				if (!mddev->reshape_backwards)
  4392					diff = -diff;
  4393				if (diff < 0)
  4394					diff = 0;
  4395				if (first || diff < min_offset_diff)
  4396					min_offset_diff = diff;
  4397				first = 0;
  4398			}
  4399		}
  4400	
  4401		if (max(before_length, after_length) > min_offset_diff)
  4402			return -EINVAL;
  4403	
  4404		if (spares < mddev->delta_disks)
  4405			return -EINVAL;
  4406	
  4407		conf->offset_diff = min_offset_diff;
  4408		spin_lock_irq(&conf->device_lock);
  4409		if (conf->mirrors_new) {
  4410			memcpy(conf->mirrors_new, conf->mirrors,
  4411			       sizeof(struct raid10_info)*conf->prev.raid_disks);
  4412			smp_mb();
  4413			kfree(conf->mirrors_old);
  4414			conf->mirrors_old = conf->mirrors;
  4415			conf->mirrors = conf->mirrors_new;
  4416			conf->mirrors_new = NULL;
  4417		}
  4418		setup_geo(&conf->geo, mddev, geo_start);
  4419		smp_mb();
  4420		if (mddev->reshape_backwards) {
  4421			sector_t size = raid10_size(mddev, 0, 0);
  4422			if (size < mddev->array_sectors) {
  4423				spin_unlock_irq(&conf->device_lock);
  4424				pr_warn("md/raid10:%s: array size must be reduce before number of disks\n",
  4425					mdname(mddev));
  4426				return -EINVAL;
  4427			}
  4428			mddev->resync_max_sectors = size;
  4429			conf->reshape_progress = size;
  4430		} else
  4431			conf->reshape_progress = 0;
  4432		conf->reshape_safe = conf->reshape_progress;
  4433		spin_unlock_irq(&conf->device_lock);
  4434	
  4435		if (mddev->delta_disks && mddev->bitmap) {
  4436			struct mdp_superblock_1 *sb = NULL;
  4437			sector_t oldsize, newsize;
  4438	
  4439			oldsize = raid10_size(mddev, 0, 0);
  4440			newsize = raid10_size(mddev, 0, conf->geo.raid_disks);
  4441	
  4442			if (!mddev_is_clustered(mddev) &&
  4443			    md_bitmap_enabled(mddev, false)) {
  4444				ret = mddev->bitmap_ops->resize(mddev, newsize, 0);
  4445				if (ret)
  4446					goto abort;
  4447				else
  4448					goto out;
  4449			}
  4450	
  4451			rdev_for_each(rdev, mddev) {
  4452				if (rdev->raid_disk > -1 &&
  4453				    !test_bit(Faulty, &rdev->flags))
  4454					sb = page_address(rdev->sb_page);
  4455			}
  4456	
  4457			/*
  4458			 * some node is already performing reshape, and no need to
  4459			 * call bitmap_ops->resize again since it should be called when
  4460			 * receiving BITMAP_RESIZE msg
  4461			 */
  4462			if ((sb && (le32_to_cpu(sb->feature_map) &
  4463				    MD_FEATURE_RESHAPE_ACTIVE)) || (oldsize == newsize))
  4464				goto out;
  4465	
  4466			/* cluster can't be setup without bitmap */
  4467			ret = mddev->bitmap_ops->resize(mddev, newsize, 0);
  4468			if (ret)
  4469				goto abort;
  4470	
  4471			ret = mddev->cluster_ops->resize_bitmaps(mddev, newsize, oldsize);
  4472			if (ret) {
  4473				mddev->bitmap_ops->resize(mddev, oldsize, 0);
  4474				goto abort;
  4475			}
  4476		}
  4477	out:
  4478		if (mddev->delta_disks > 0) {
  4479			rdev_for_each(rdev, mddev)
  4480				if (rdev->raid_disk < 0 &&
  4481				    !test_bit(Faulty, &rdev->flags)) {
  4482					if (raid10_add_disk(mddev, rdev) == 0) {
  4483						if (rdev->raid_disk >=
  4484						    conf->prev.raid_disks)
  4485							set_bit(In_sync, &rdev->flags);
  4486						else
  4487							rdev->recovery_offset = 0;
  4488	
  4489						/* Failure here is OK */
  4490						sysfs_link_rdev(mddev, rdev);
  4491					}
  4492				} else if (rdev->raid_disk >= conf->prev.raid_disks
  4493					   && !test_bit(Faulty, &rdev->flags)) {
  4494					/* This is a spare that was manually added */
  4495					set_bit(In_sync, &rdev->flags);
  4496				}
  4497		}
  4498		/* When a reshape changes the number of devices,
  4499		 * ->degraded is measured against the larger of the
  4500		 * pre and  post numbers.
  4501		 */
  4502		spin_lock_irq(&conf->device_lock);
  4503		mddev->degraded = calc_degraded(conf);
  4504		spin_unlock_irq(&conf->device_lock);
  4505		mddev->raid_disks = conf->geo.raid_disks;
  4506		mddev->reshape_position = conf->reshape_progress;
  4507		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
  4508	
  4509		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
  4510		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
  4511		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
  4512		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
  4513		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
  4514		conf->reshape_checkpoint = jiffies;
  4515		md_new_event();
  4516		return 0;
  4517	
  4518	abort:
  4519		mddev->recovery = 0;
  4520		spin_lock_irq(&conf->device_lock);
  4521		conf->geo = conf->prev;
  4522		mddev->raid_disks = conf->geo.raid_disks;
  4523		rdev_for_each(rdev, mddev)
  4524			rdev->new_data_offset = rdev->data_offset;
  4525		smp_wmb();
  4526		conf->reshape_progress = MaxSector;
  4527		conf->reshape_safe = MaxSector;
  4528		mddev->reshape_position = MaxSector;
  4529		spin_unlock_irq(&conf->device_lock);
  4530		return ret;
  4531	}
  4532	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
