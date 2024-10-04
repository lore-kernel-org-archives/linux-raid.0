Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A91B4F0C
	for <linux-raid@vger.kernel.org>; Fri,  4 Oct 2024 22:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728081468; cv=none; b=mt+jSPXwel3WEigrz6AVneR/AoKyy/DtkCaX8kj2XLtvjR6R8KXEAPVcFnyaFkGsl0kefRvaJXHkv2+GTUqLoEApg3Xgo3ER5cYeT1Qx8hjXorKyJP8Nr9AE08AX8JLHAIBbnvkFAaOwgRjXW7PFfmkXitcZ6joic8EeLJRATKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728081468; c=relaxed/simple;
	bh=N1PZz918WTY+y/j1h+9zVefApJBymLca0boCsonoE6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LL1KhcOM8N/EUajrOpdPjk99iDo7hfNM2NAy2SCbiVPvC6KJcjz9RJSXGcKlmfyz4ZdUrL7KG5qInyVAwaGc7fGs7kYJTW7waRnVjuhLEMD1r5p5OTUuz3nNGyR5x8aElEP/gtL4pGU8FttvxQxtkvzftw9vSFDERsqQI7RyYRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lMjtR8dE; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lMjtR8dE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728081466; x=1759617466;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N1PZz918WTY+y/j1h+9zVefApJBymLca0boCsonoE6Y=;
  b=lMjtR8dEFDJm+gVt/pAw/5ImiNZlNbL5rk2Of6UXUhwnLJfeSIVUccms
   UJcwK1y3xB+WE/1HN8UktPetYFbxz8ovShrH2A0kTNeRRTPyot3w5LDVV
   VrATJU/hm9mXKwvJjv8Qchb0vyjW/4HAFgsQ8nm1RrR1n492lzWXzX6ix
   ABTWa1gT+34seFrgmrEy/mlWUEdt/QB1sVKYuqihoBdJYuUXNcfwJFTHl
   uqfu5j90yrClHDNpt1TEwuzq9eBcR/gTsJidmpoxx4TzxgPWKgkn2zYR+
   K8RuziiRL4WbFEx/hFrLzpUo66tkN9DUMP8iwzUGL8J4Mt0TOOLgKfn18
   w==;
X-CSE-ConnectionGUID: KpcYzN1LQ4q/GysJ0m88IA==
X-CSE-MsgGUID: PNPpNUL1QJGz+ZGA4USwtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11215"; a="26783232"
X-IronPort-AV: E=Sophos;i="6.11,178,1725346800"; 
   d="scan'208";a="26783232"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2024 15:37:46 -0700
X-CSE-ConnectionGUID: js0ut/axSMa9HrpAdcOufQ==
X-CSE-MsgGUID: 8EU2jffSStyO45Rqo9ABhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,178,1725346800"; 
   d="scan'208";a="74519374"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 04 Oct 2024 15:37:44 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1swqve-0002Is-1k;
	Fri, 04 Oct 2024 22:37:42 +0000
Date: Sat, 5 Oct 2024 06:37:01 +0800
From: kernel test robot <lkp@intel.com>
To: Paul Luse <paulluselinux@gmail.com>, linux-raid@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, paul.e.luse@intel.com,
	Paul Luse <paulluselinux@gmail.com>
Subject: Re: [PATCH] md: yet another CI email test - do not review
Message-ID: <202410050657.UecRCw2W-lkp@intel.com>
References: <20241003180040.6808-1-paulluselinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241003180040.6808-1-paulluselinux@gmail.com>

Hi Paul,

kernel test robot noticed the following build errors:

[auto build test ERROR on song-md/md-next]
[also build test ERROR on linus/master v6.12-rc1 next-20241004]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paul-Luse/md-yet-another-CI-email-test-do-not-review/20241004-020247
base:   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
patch link:    https://lore.kernel.org/r/20241003180040.6808-1-paulluselinux%40gmail.com
patch subject: [PATCH] md: yet another CI email test - do not review
config: um-randconfig-r072-20241005 (https://download.01.org/0day-ci/archive/20241005/202410050657.UecRCw2W-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project fef3566a25ff0e34fb87339ba5e13eca17cec00f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241005/202410050657.UecRCw2W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410050657.UecRCw2W-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/md/raid1.c:28:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/um/include/asm/cacheflush.h:4:
   In file included from arch/um/include/asm/tlbflush.h:9:
   In file included from include/linux/mm.h:2177:
   include/linux/vmstat.h:522:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     522 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   In file included from drivers/md/raid1.c:28:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     547 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     560 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   In file included from drivers/md/raid1.c:28:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     573 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   In file included from drivers/md/raid1.c:28:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     584 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     594 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     604 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     692 |         readsb(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     700 |         readsw(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     708 |         readsl(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     717 |         writesb(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     726 |         writesw(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     735 |         writesl(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
>> drivers/md/raid1.c:68:2: error: use of undeclared identifier 'xxx'
      68 |         xxx
         |         ^
   13 warnings and 1 error generated.


vim +/xxx +68 drivers/md/raid1.c

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
  > 68		xxx
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
