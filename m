Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98870800
	for <linux-raid@vger.kernel.org>; Mon,  7 Oct 2024 00:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728259764; cv=none; b=Q3CqPRj75T+mSdZnQF+V7aPOjGoXePdxPqMd46zwOLudEdh4x7tOfgAXCuFfR0jydlB/45X/vApktrhZon/rKtQ0WsWKrbqLg3v8RatVzPv+ihcXH9Axx7HRy74hhmwcCuc4UCmh7EDRzM0MYi2LMhzHrOSVeaafwqKl1B+pUzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728259764; c=relaxed/simple;
	bh=0w46/vHpuBqc/Q9thZiNJj6GPr3N1vhtrtpFqarro3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ID78i74JoRMW711fJFKvBPoIXE9Bo/TtPjF9NeCEeFDZsLsKJQ+edScEMDAkOL7uvx9+CbqXXYXAIOBP1+np0Tz0fewyBCw5GVcuJI/aAjVxIX76cpaCw3X9WCxcz1MlbOUyBXjyqBp937GSrew64HAAn7WhQsAW6ZSuCy3OxFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a3aIvHoF; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a3aIvHoF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728259763; x=1759795763;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0w46/vHpuBqc/Q9thZiNJj6GPr3N1vhtrtpFqarro3o=;
  b=a3aIvHoFZqvMB7IyZOhIw8trECQ5bgjAJQ5fimyKSHwBv1Vu98WYm9nT
   dxfxlptkwyU/Kev5rA6j0UmxgAuvrbX72aKEHxgfcnHfCJr21a1CZvdhw
   yzEfmVHEGQi0d7k8lyFF66wwSvkPUDAePeVDKbIf4EhmJxEe7BMJMELu9
   6uAzzZOAPtRpuJ9vEVyez0VroCGnAenVMC3EruvWLYOLPA9X+eP9sfPNE
   xzaHi7TbC89eX+FjuOVhk5NfSg5MtqAiGkzqPYTz3zr0qV2TdeWqQqbL/
   3sJFicGuMIrtZ6glZdNAvXKVX25DrdoeTHeoTgoN4tmNUmsqOZqpZEEBx
   w==;
X-CSE-ConnectionGUID: Ijkoq8PTTjSLVopOXHb27w==
X-CSE-MsgGUID: y1aucpYYTNOmHAWO5rJEEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="30282023"
X-IronPort-AV: E=Sophos;i="6.11,183,1725346800"; 
   d="scan'208";a="30282023"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2024 17:09:22 -0700
X-CSE-ConnectionGUID: 15jfKi68QkmSOU4/XSz/8w==
X-CSE-MsgGUID: 2O8GjKlxT7WjrTT8YFnJBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,183,1725346800"; 
   d="scan'208";a="80261670"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 06 Oct 2024 17:09:21 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sxbJO-0004S4-0g;
	Mon, 07 Oct 2024 00:09:18 +0000
Date: Mon, 7 Oct 2024 08:08:54 +0800
From: kernel test robot <lkp@intel.com>
To: Paul Luse <paulluselinux@gmail.com>, linux-raid@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, paul.e.luse@intel.com,
	Paul Luse <paulluselinux@gmail.com>
Subject: Re: [PATCH] md:  CI log retrival test - do not review
Message-ID: <202410070615.9IATJLEA-lkp@intel.com>
References: <20241004124227.3540-1-paulluselinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004124227.3540-1-paulluselinux@gmail.com>

Hi Paul,

kernel test robot noticed the following build errors:

[auto build test ERROR on song-md/md-next]
[also build test ERROR on linus/master v6.12-rc1 next-20241004]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paul-Luse/md-CI-log-retrival-test-do-not-review/20241004-204420
base:   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
patch link:    https://lore.kernel.org/r/20241004124227.3540-1-paulluselinux%40gmail.com
patch subject: [PATCH] md:  CI log retrival test - do not review
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20241007/202410070615.9IATJLEA-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241007/202410070615.9IATJLEA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410070615.9IATJLEA-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/md/raid1.c: In function 'check_and_add_serial':
>> drivers/md/raid1.c:68:1: error: 'x' undeclared (first use in this function)
      68 | x
         | ^
   drivers/md/raid1.c:68:1: note: each undeclared identifier is reported only once for each function it appears in
   drivers/md/raid1.c:68:2: error: expected ';' before 'do'
      68 | x
         |  ^
         |  ;


vim +/x +68 drivers/md/raid1.c

    54	
    55	#define START(node) ((node)->start)
    56	#define LAST(node) ((node)->last)
    57	INTERVAL_TREE_DEFINE(struct serial_info, node, sector_t, _subtree_last,
    58			     START, LAST, static inline, raid1_rb);
    59	
    60	static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
    61					struct serial_info *si, int idx)
    62	{
    63		unsigned long flags;
    64		int ret = 0;
    65		sector_t lo = r1_bio->sector;
    66		sector_t hi = lo + r1_bio->sectors;
    67		struct serial_in_rdev *serial = &rdev->serial[idx];
  > 68	x
    69		spin_lock_irqsave(&serial->serial_lock, flags);
    70		/* collision happened */
    71		if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
    72			ret = -EBUSY;
    73		else {
    74			si->start = lo;
    75			si->last = hi;
    76			raid1_rb_insert(si, &serial->serial_rb);
    77		}
    78		spin_unlock_irqrestore(&serial->serial_lock, flags);
    79	
    80		return ret;
    81	}
    82	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
