Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E9F170A2C
	for <linux-raid@vger.kernel.org>; Sun,  6 Oct 2024 22:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728253066; cv=none; b=TgufQgNjovbg8smfeDkGqyV+cMU2siKu75sKbtgwO8wKFSiZU6TEbCmtzDBQyv6xkm2rA6g++QfxR7KQI69ilkogq4Gt+5qSj2uOHAu26jXy9sG6xVjK1votB5+BZDbPiEcLyfpQ4Zl/q3I2wglsC4FOjlOy4AX67K9e8XAXK1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728253066; c=relaxed/simple;
	bh=JURLRwTFb7l8hlgN95q4TPgKQMn02C0KKgLcTADmxdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JaPpQgoDTP2eI3j52d/GHCdjK5czdINzkT2b8XVXINnYmzXaqOkNGg2nPRhdzRm6xRn6Bin3bu4hSZ3UXhx038UVICkGDtR1e/3+vNVsjxBGeheBN8YrLZBz6J5krIBwzJOc9qLEJLfeokVHC3mt+KDN6k5wTflU0jgaC6lpQy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UdtcQHpr; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UdtcQHpr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728253065; x=1759789065;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JURLRwTFb7l8hlgN95q4TPgKQMn02C0KKgLcTADmxdE=;
  b=UdtcQHpr8LK5/leulLcDc/YDGKRAgVQ1IQM6G3Pzamrvf3SOL3OlbRx6
   1atUaWI6XgjRUZyksCeA4si36wN+obGBrigPb6ae2gsDCZEukWXq3sQwF
   WSCsWMsTfDtYqQJpeO47vu77io2KrXyxmvJXAqXtXsf4Sp6teMDWvDVbz
   wgo1bR+GBnTfSQkKeJQno04YFHcJRrUHCL1N48Vepth0dZ8IHdXVNaF7U
   uIYuEYFhvi5A6NRISr8tiDVQft5THN5/rhRAhxjVhM1D3/I7ARaNGSVO3
   tRECCCAxlG+nLL7EbIFd9u6V+vd/bnIm3a3Hb0q51kJw54sxQ/wOUnCN5
   g==;
X-CSE-ConnectionGUID: q2DNH5++QEWZ4BFDPZcx8g==
X-CSE-MsgGUID: GT7iaf48QXKqv66RkAK8iQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11217"; a="27281417"
X-IronPort-AV: E=Sophos;i="6.11,183,1725346800"; 
   d="scan'208";a="27281417"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2024 15:17:44 -0700
X-CSE-ConnectionGUID: xHzcSZmCTI+GnwjeGLp1Cw==
X-CSE-MsgGUID: dL4BMa8UTg6IgVyFM4je0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,183,1725346800"; 
   d="scan'208";a="74959925"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 06 Oct 2024 15:17:42 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sxZZM-0004NA-0N;
	Sun, 06 Oct 2024 22:17:40 +0000
Date: Mon, 7 Oct 2024 06:16:52 +0800
From: kernel test robot <lkp@intel.com>
To: Paul Luse <paulluselinux@gmail.com>, linux-raid@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	paul.e.luse@intel.com, Paul Luse <paulluselinux@gmail.com>
Subject: Re: [PATCH] md:  CI log retrival test - do not review
Message-ID: <202410070623.1WRxUPy0-lkp@intel.com>
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
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20241007/202410070623.1WRxUPy0-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241007/202410070623.1WRxUPy0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410070623.1WRxUPy0-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/raid1.c:68:1: error: use of undeclared identifier 'x'
      68 | x
         | ^
   1 error generated.


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
