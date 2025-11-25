Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B73B1F4615;
	Tue, 25 Nov 2025 01:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764034738; cv=none; b=RFE0W9tXXgemwp8cJ62EmGhUgphtNgHktYb/bo0GWqabgAbsoDVPlVOd3+c1Kvt8/kIG+1yFYuJHwSPv2VmV2SNCk8V7JBlwSP4cciJVb0GVYFOtkpK05Kd5LhEVYHpZ+1KsSjlF9RRTH/juF4ZEKqCGozJEL2AWMEHjiD6d6Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764034738; c=relaxed/simple;
	bh=Pft5LWJIY2MXzAvKHSUGWMJ75mPNbAVfEiL7WiPSweU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYTWqX5OmX/GIjJNT+75j7YBdPsK1sUmX+HUcrzFev5QEaIWW45E56F3Ez7UWw5/x4Fu7Nf1hYfvO+d+v0E/FTVOnSwKj7pS/ymF59m9bK442GCPpiqIcCstArh3GfUhIhuucMA/ynhNVHiYEiEno3YvJg2BsepSgjcKZiCvxxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cXHd5Wye; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cXHd5Wye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764034737; x=1795570737;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Pft5LWJIY2MXzAvKHSUGWMJ75mPNbAVfEiL7WiPSweU=;
  b=cXHd5WyeKmMwkYqCI5oob3VEKWT7h/vOywUYL0/I4T6n+a7kpX5CcMHC
   rbzAf26tEpZrRiBPY3BtVlYl+LZQBORPCTzRSFPD1CBPBNipM6FYdnApQ
   yvcWTJUiTi3ICg7/ptknJcj8HaPBh3YSabThevDFp/A1xe9qzHdMa9XUr
   ymL/R9OZZesH+cBmKlWHk0kAa+nWlkqlG7n/IjJZFlBRDrm3A/DMrdStr
   xk2Z8tRdDjVVQO6rwiyi4LZ4OkNZAyplFjN5HdjVg7ztZ6J9x8SOlkwVy
   plCYLZRPwxwI6IZoYKc+VDQFLTNFyTSjgySz7h90zAmHAHLG7levAIYxG
   Q==;
X-CSE-ConnectionGUID: /klTnpiqQp+DH1Z9asleRQ==
X-CSE-MsgGUID: PEsqxHTIQcCtAFyckM7S5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="69668524"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="69668524"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 17:38:56 -0800
X-CSE-ConnectionGUID: pb7vgqUqTkqdTS6m2pKljQ==
X-CSE-MsgGUID: KrQjKqiERHewYF7ZG57l6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="197409322"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 24 Nov 2025 17:38:53 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vNi14-000000001Gf-27iI;
	Tue, 25 Nov 2025 01:38:50 +0000
Date: Tue, 25 Nov 2025 09:37:54 +0800
From: kernel test robot <lkp@intel.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, linan122@huawei.com, xni@redhat.com
Subject: Re: [PATCH] md: support to align bio to limits
Message-ID: <202511250848.gq6d7JeR-lkp@intel.com>
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
config: i386-randconfig-002-20251125 (https://download.01.org/0day-ci/archive/20251125/202511250848.gq6d7JeR-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251125/202511250848.gq6d7JeR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511250848.gq6d7JeR-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: drivers/md/md.o: in function `__md_bio_align_to_limits':
>> drivers/md/md.c:434:(.text+0x68e4): undefined reference to `__umoddi3'
>> ld: drivers/md/md.c:443:(.text+0x693a): undefined reference to `__umoddi3'


vim +434 drivers/md/md.c

   428	
   429	static struct bio *__md_bio_align_to_limits(struct mddev *mddev,
   430						    struct bio *bio)
   431	{
   432		unsigned int max_sectors = mddev->gendisk->queue->limits.max_sectors;
   433		sector_t start = bio->bi_iter.bi_sector;
 > 434		sector_t align_start = roundup(start, max_sectors);
   435		sector_t end;
   436		sector_t align_end;
   437	
   438		/* already aligned */
   439		if (align_start == start)
   440			return bio;
   441	
   442		end = start + bio_sectors(bio);
 > 443		align_end = rounddown(end, max_sectors);
   444	
   445		/* bio is too small to split */
   446		if (align_end <= align_start)
   447			return bio;
   448	
   449		return bio_submit_split_bioset(bio, align_start - start,
   450					       &mddev->gendisk->bio_split);
   451	}
   452	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
