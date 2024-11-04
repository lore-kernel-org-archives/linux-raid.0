Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCA57E583;
	Mon,  4 Nov 2024 01:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730682728; cv=none; b=ZOHSHYp7rEJH4uH0A5x+lRMXYjyDjNrVdSkmhf6TOnKNdkmKuff8se7iMEcNenyEDUq8400DiP702jBLniq4pg/uVSd9pW+R3mljgR9Ayi2VZyZ21f5+i0hUQl+4EHDOpHQ0rV3BlfZkXAVSq26eWtEJfwwN36rKFXkkT+qq8e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730682728; c=relaxed/simple;
	bh=pBJCQW4Oet+UlOfycbMG2VqQdA0DEcW5Cw/2nr0Junc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bZoChny5pPdgDublGvYMSE7piH5FvwAZmM5hAYjoJX8URTqPzmqVvq3j13Oo0a6LLTR39CsCh7f0OlhKgD22aF5BDKqzMA5LmOLRhDzQQKXSxpJGtt8mzQZfGeK9UgeDWEqjn9IA3hoSHeAYNgmjy+CPHCEFowiQY+/qyZkYm4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bLSACuN3; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bLSACuN3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730682727; x=1762218727;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pBJCQW4Oet+UlOfycbMG2VqQdA0DEcW5Cw/2nr0Junc=;
  b=bLSACuN3wkfEcKBYOQiryNPLrFAdyeWOAcXAcOtj1fVRBkzaZPu/Disc
   qtfl8wp+Cs02PZH4nKvJV1JuCqB+nr0eH0tOsqAYK8ZtKv6+iaJP+r9Xq
   RHjh3WZ/AaV/MASC3Om6Hv7r8TVBZNXmLQPLLq6sV4aRGyC5/lbHl4Js0
   nxp3B7wYXuwGwhxbJz851H8H9UeT5OnJ12Yw1eWU2GRSnk81qCzJ4THar
   RhG8OHHW6CG2VgVhqiY7zy8sHnHOAcfykzebzBvH3o5z878XJZmc5tRJ1
   Np2Elb9z0g1WkKxaGpWAGZ2n/eDKRgw7na3PZm3h339zYrft4j4aTrRV+
   A==;
X-CSE-ConnectionGUID: f8PHlujPT8+zOqHfNSUXSg==
X-CSE-MsgGUID: lBWWkxGFSkOi8pRnslPgbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30218267"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30218267"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 17:12:06 -0800
X-CSE-ConnectionGUID: rrNHJLK/Q66UPfjhyk36jQ==
X-CSE-MsgGUID: i1joT7kgQDK4/iPzYVXWmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="114308874"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 03 Nov 2024 17:12:03 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t7ldR-000kL9-0x;
	Mon, 04 Nov 2024 01:12:01 +0000
Date: Mon, 4 Nov 2024 09:11:42 +0800
From: kernel test robot <lkp@intel.com>
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
	yukuai3@huawei.com, hch@lst.de
Cc: oe-kbuild-all@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v3 4/5] md/raid1: Atomic write support
Message-ID: <202411040805.745M3bMe-lkp@intel.com>
References: <20241101144616.497602-5-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241101144616.497602-5-john.g.garry@oracle.com>

Hi John,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on linus/master v6.12-rc5 next-20241101]
[cannot apply to song-md/md-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Garry/block-Add-extra-checks-in-blk_validate_atomic_write_limits/20241101-225310
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20241101144616.497602-5-john.g.garry%40oracle.com
patch subject: [PATCH v3 4/5] md/raid1: Atomic write support
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241104/202411040805.745M3bMe-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411040805.745M3bMe-lkp@intel.com/

All errors (new ones prefixed by >>):

   make[1]: Circular tools/testing/selftests/alsa/global-timer <- tools/testing/selftests/alsa/global-timer dependency dropped.
   Makefile:60: warning: overriding recipe for target 'emit_tests'
   ../lib.mk:182: warning: ignoring old recipe for target 'emit_tests'
   make[1]: *** No targets.  Stop.
>> Makefile:47: *** Cannot find a vmlinux for VMLINUX_BTF at any of "  ../../../../vmlinux /sys/kernel/btf/vmlinux /boot/vmlinux-5.9.0-2-amd64".  Stop.
   make[1]: *** No targets.  Stop.
   make[1]: *** No targets.  Stop.


vim +47 Makefile

3812b8c5c5d527 Masahiro Yamada 2019-02-22  46  
3812b8c5c5d527 Masahiro Yamada 2019-02-22 @47  # Do not use make's built-in rules and variables
3812b8c5c5d527 Masahiro Yamada 2019-02-22  48  # (this increases performance and avoids hard-to-debug behaviour)
3812b8c5c5d527 Masahiro Yamada 2019-02-22  49  MAKEFLAGS += -rR
3812b8c5c5d527 Masahiro Yamada 2019-02-22  50  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
