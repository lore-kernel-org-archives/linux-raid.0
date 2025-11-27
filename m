Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A33D314D06;
	Thu, 27 Nov 2025 07:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764227158; cv=none; b=snlO+6FC/BsuT1RI5oWQDsyLHYRNmX1lXDzynUgWofP97NQNkJigyvyR7cdqRkk9yT0Fvb92KFF7f36O3c4j/goEKntmie8KbCLoE12sDdI76H4Q2TZB4tFc2+Hxx2iCg/B2OQTHjhDjsIgZGpILoYjw54m4cYgJ0HlaVCjTOiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764227158; c=relaxed/simple;
	bh=czRbMmH5u2kp7sSyDHZoaIcWeS77FZ/UAjJ3rMVxapQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZN++dxKmjwJecMBh62g6aoobJcs0IS31tsrms4CHm6IHOMcKD2lNxCKyUSb5rAGbZNZ8gWVyGLHE81t4fGc1azqhkx3XZEFcUCxTa9b/m3B4Mt3eg5b+mvSxjmlZuMyTNXKpjUFVNXGIeyBVx4jZ0Qhd26rjW/Eb9w0Nn1LrjQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g4IUe5Qn; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g4IUe5Qn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764227154; x=1795763154;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=czRbMmH5u2kp7sSyDHZoaIcWeS77FZ/UAjJ3rMVxapQ=;
  b=g4IUe5QnTaN8vtmHfwV0CZ3wOcbwLA/i5Hg1DN/TtJ20kjU0gQw6y+yI
   qwiU2Nd/tnDTaGcl8Twaeopsy70pAXZJpO10pW5w/1R/WQhhn7EKH8V0s
   aEUnCJtg8+pfqSlMDieCa/8GL3hwvkLOpKWFgrNRegyqTROrYnBJeexGY
   uB4EgODF0/pt8EqMlD8bl6EE6/TQ4dvmigSH+OV0/vDW+be2fTQNKZPev
   F/eTc2ZgLiwMcBGp0AYkDja3TzD44EkAEPzWCrEHr+wV1ym6eMrENkvnm
   SzODVvaQ7t6SMhFii5+1yWV3uSK6l3qapVcYW7ME0PD9Kb+FJsJD3+Nqd
   A==;
X-CSE-ConnectionGUID: xcz/80U5TrGfpheic3arHA==
X-CSE-MsgGUID: jPEv0KD7S+i+r9H8j6BFDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="76958292"
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="76958292"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 23:05:52 -0800
X-CSE-ConnectionGUID: SkCattLdQm20v6Y3zljjYQ==
X-CSE-MsgGUID: oZZGw/jDRoOpxM0PYc1NdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,230,1758610800"; 
   d="scan'208";a="193379385"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 26 Nov 2025 23:05:49 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vOW4Z-000000003oT-09Pw;
	Thu, 27 Nov 2025 07:05:47 +0000
Date: Thu, 27 Nov 2025 15:05:07 +0800
From: kernel test robot <lkp@intel.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, linux-raid@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	filippo@debian.org, colyli@fnnas.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 06/11] md: support to align bio to limits
Message-ID: <202511271423.CJ3C240z-lkp@intel.com>
References: <20251124063203.1692144-7-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124063203.1692144-7-yukuai@fnnas.com>

Hi Yu,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20251121]
[also build test ERROR on v6.18-rc7]
[cannot apply to linus/master song-md/md-next v6.18-rc7 v6.18-rc6 v6.18-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-merge-mddev-has_superblock-into-mddev_flags/20251124-143826
base:   next-20251121
patch link:    https://lore.kernel.org/r/20251124063203.1692144-7-yukuai%40fnnas.com
patch subject: [PATCH v2 06/11] md: support to align bio to limits
config: xtensa-randconfig-001-20251127 (https://download.01.org/0day-ci/archive/20251127/202511271423.CJ3C240z-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251127/202511271423.CJ3C240z-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511271423.CJ3C240z-lkp@intel.com/

All errors (new ones prefixed by >>):

   cfi_cmdset_0002.c:(.xiptext+0xfe5): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0xff8): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: mutex_lock
   cfi_cmdset_0002.c:(.xiptext+0x1006): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: (.text+0x17b0)
   cfi_cmdset_0002.c:(.xiptext+0x1012): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x101c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1024): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: mutex_unlock
   cfi_cmdset_0002.c:(.xiptext+0x1030): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x103a): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1049): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1053): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1060): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x107c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1094): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_send_gen_cmd
   cfi_cmdset_0002.c:(.xiptext+0x10ac): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_send_gen_cmd
   cfi_cmdset_0002.c:(.xiptext+0x10c4): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_send_gen_cmd
   cfi_cmdset_0002.c:(.xiptext+0x10dc): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_send_gen_cmd
   cfi_cmdset_0002.c:(.xiptext+0x10f2): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_send_gen_cmd
   cfi_cmdset_0002.c:(.xiptext+0x113f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x114b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x1154): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x116e): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: add_wait_queue
   cfi_cmdset_0002.c:(.xiptext+0x1176): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: mutex_unlock
   cfi_cmdset_0002.c:(.xiptext+0x117c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: schedule
   cfi_cmdset_0002.c:(.xiptext+0x1187): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: remove_wait_queue
   cfi_cmdset_0002.c:(.xiptext+0x118f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: mutex_lock
   cfi_cmdset_0002.c:(.xiptext+0x1198): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x11aa): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp1
   cfi_cmdset_0002.c:(.xiptext+0x11b2): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x11d0): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x11e8): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x11f0): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x11fc): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: (.text+0x940)
   cfi_cmdset_0002.c:(.xiptext+0x120a): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x1218): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x122e): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x1237): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1243): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: _printk
   cfi_cmdset_0002.c:(.xiptext+0x124c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1264): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1273): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_cmdset_0002.c:(.xiptext+0x128e): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x12a0): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x12b8): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x12ca): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x12d4): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: (.text+0x167c)
   cfi_cmdset_0002.c:(.xiptext+0x12dc): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: mutex_unlock
   cfi_cmdset_0002.c:(.xiptext+0x12e7): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x12fa): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __stack_chk_fail
   cfi_cmdset_0002.c:(.xiptext+0x131b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1334): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: mutex_lock
   cfi_cmdset_0002.c:(.xiptext+0x1342): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: (.text+0x17b0)
   cfi_cmdset_0002.c:(.xiptext+0x134e): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x1356): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x135e): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: mutex_unlock
   cfi_cmdset_0002.c:(.xiptext+0x1368): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1376): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x137f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x138b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1396): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x139f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x13b4): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x13be): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x13c7): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   drivers/mtd/chips/cfi_cmdset_0002.o: in function `do_erase_oneblock':
   cfi_cmdset_0002.c:(.xiptext+0x13f0): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x13f6): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: (.text.unlikely+0x288)
   cfi_cmdset_0002.c:(.xiptext+0x13fc): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x140b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x141c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1427): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1434): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x145c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_send_gen_cmd
   cfi_cmdset_0002.c:(.xiptext+0x1472): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_send_gen_cmd
   cfi_cmdset_0002.c:(.xiptext+0x1480): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_cmdset_0002.c:(.xiptext+0x14a3): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_cmdset_0002.c:(.xiptext+0x14bf): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x14cd): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x14d7): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x14e0): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x14ec): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x14f6): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x14ff): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1514): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x151f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x152b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x154f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1573): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x158c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1598): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x15a7): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_cmdset_0002.c:(.xiptext+0x15d8): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_cmdset_0002.c:(.xiptext+0x15e0): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x15f0): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1608): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x1615): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_cmdset_0002.c:(.xiptext+0x161f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: (.text+0x167c)
   cfi_cmdset_0002.c:(.xiptext+0x1627): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: mutex_unlock
   cfi_cmdset_0002.c:(.xiptext+0x162d): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   xtensa-linux-ld: drivers/md/md.o: in function `recovery_start_store':
   md.c:(.text+0xa144): undefined reference to `__udivdi3'
>> xtensa-linux-ld: md.c:(.text+0xa148): undefined reference to `__umoddi3'
   xtensa-linux-ld: drivers/md/md.o: in function `md_write_end':
   md.c:(.text+0xa21b): undefined reference to `__udivdi3'
   xtensa-linux-ld: md.c:(.text+0xa284): undefined reference to `__umoddi3'
   drivers/mtd/chips/cfi_util.o:(.xiptext+0x14): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   drivers/mtd/chips/cfi_util.o:(.xiptext+0x28): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   drivers/mtd/chips/cfi_util.o: in function `cfi_qry_present':
   cfi_util.c:(.xiptext+0x38): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x46): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x7f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_cmp4
   cfi_util.c:(.xiptext+0x8d): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x9b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_cmp4
   cfi_util.c:(.xiptext+0xa4): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0xb2): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_cmp4
   cfi_util.c:(.xiptext+0xc2): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0xcf): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __stack_chk_fail
   cfi_util.c:(.xiptext+0xe7): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0xf4): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x10c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x123): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x12c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   drivers/mtd/chips/cfi_util.o: in function `cfi_qry_mode_off':
   cfi_util.c:(.xiptext+0x13b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x144): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x152): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x168): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x177): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x180): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x193): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x1a0): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x1cb): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x1ec): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x1f9): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x207): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x21f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x246): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   drivers/mtd/chips/cfi_util.o: in function `cfi_qry_mode_on':
   cfi_util.c:(.xiptext+0x26b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x274): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x282): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x2ae): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x2d3): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x2dc): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x2eb): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x317): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x343): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_cmp4
   cfi_util.c:(.xiptext+0x357): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x360): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x36c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x398): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x3bb): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x3c4): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x3d2): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x3fe): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x428): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_cmp4
   cfi_util.c:(.xiptext+0x43b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x444): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x450): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x47a): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: cfi_build_cmd
   cfi_util.c:(.xiptext+0x4a2): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x4ab): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x4c7): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x4e0): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp2
   cfi_util.c:(.xiptext+0x4ed): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x4fb): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: _printk
   cfi_util.c:(.xiptext+0x506): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __kmalloc_noprof
   cfi_util.c:(.xiptext+0x51a): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x53c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x556): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x568): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x577): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x582): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x58e): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x59c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x5a6): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x5b4): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x5c9): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x5d3): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x5e0): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x5ea): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   cfi_util.c:(.xiptext+0x5f3): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   drivers/mtd/chips/cfi_util.o: in function `cfi_read_pri':
   cfi_util.c:(.xiptext+0x60f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x618): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x632): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x63e): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_cmp4
   cfi_util.c:(.xiptext+0x64c): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   cfi_util.c:(.xiptext+0x66b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   drivers/mtd/maps/map_funcs.o:(.xiptext+0x7): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   drivers/mtd/maps/map_funcs.o: in function `simple_map_copy_to':
   map_funcs.c:(.xiptext+0x16): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: memcpy_toio
   map_funcs.c:(.xiptext+0x2f): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   map_funcs.c:(.xiptext+0x3b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   drivers/mtd/maps/map_funcs.o: in function `simple_map_copy_from':
   map_funcs.c:(.xiptext+0x47): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: memcpy
   map_funcs.c:(.xiptext+0x50): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   map_funcs.c:(.xiptext+0x5e): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: memcpy_fromio
   map_funcs.c:(.xiptext+0x64): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   map_funcs.c:(.xiptext+0x8b): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc
   map_funcs.c:(.xiptext+0x9a): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_const_cmp4
   map_funcs.c:(.xiptext+0xa8): dangerous relocation: windowed longcall crosses 1GB boundary; return may fail: __sanitizer_cov_trace_pc

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
