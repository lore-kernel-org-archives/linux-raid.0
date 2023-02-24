Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 316E9C64ED8
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 07:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjBXHXr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 02:23:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjBXHXr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 02:23:47 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE21DCC1E
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 23:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677223425; x=1708759425;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K1CBKhcd8tfeUeLujBKbvbHspMx4+B/cfLq/h1fPxg0=;
  b=EW/Yo0WHUTB9iA+Z7uVTViTH9tIOrSusTzY+vwywklf7KYmadlVBbzPZ
   ViBZ637gEEG0lBqZBgZK4c+BQQJY2ofATwiBCXXRyJR6/uJLdinMuVuRa
   do9YC5iIUu/pdIUezL194+Mmrh36miD6k4j7trW0I2CGWspRh6g1ebF77
   3MabRKfqY06K7RGjXKhaFULJxFLfshIY+omcUB1l83xmqhBDqLRD+q1WG
   lEKLKEaQ75IJMP0G+dXipLQC+GkRWv94hDo9m+jpleiffYAE7r6hwuX2J
   C6K5gKnqOo6laKMIoShxnHGyuBYetzk5t/msxe0W3WcdNMEVumsJJgfAM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="398149789"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="398149789"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 23:23:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="782244551"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="782244551"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 23 Feb 2023 23:23:42 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pVSQf-0002EL-1f;
        Fri, 24 Feb 2023 07:23:41 +0000
Date:   Fri, 24 Feb 2023 15:23:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jonathan Derrick <jonathan.derrick@linux.dev>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Reindl Harald <h.reindl@thelounge.net>,
        Xiao Ni <xni@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>,
        Jon Derrick <jonathan.derrick@linux.dev>
Subject: Re: [PATCH v4 1/3] md: Move sb writer loop to its own function
Message-ID: <202302241507.7JQRJLLW-lkp@intel.com>
References: <20230223195225.534-2-jonathan.derrick@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223195225.534-2-jonathan.derrick@linux.dev>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jonathan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on song-md/md-next]
[also build test WARNING on linus/master v6.2 next-20230224]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jonathan-Derrick/md-Move-sb-writer-loop-to-its-own-function/20230224-035451
base:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
patch link:    https://lore.kernel.org/r/20230223195225.534-2-jonathan.derrick%40linux.dev
patch subject: [PATCH v4 1/3] md: Move sb writer loop to its own function
config: s390-randconfig-r036-20230223 (https://download.01.org/0day-ci/archive/20230224/202302241507.7JQRJLLW-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project db89896bbbd2251fff457699635acbbedeead27f)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/93818e631c76938f9a3ad87d1baf681645d02ba7
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jonathan-Derrick/md-Move-sb-writer-loop-to-its-own-function/20230224-035451
        git checkout 93818e631c76938f9a3ad87d1baf681645d02ba7
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302241507.7JQRJLLW-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/md/md-bitmap.c:31:
   In file included from include/trace/events/block.h:8:
   In file included from include/linux/blktrace_api.h:5:
   In file included from include/linux/blk-mq.h:8:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from drivers/md/md-bitmap.c:31:
   In file included from include/trace/events/block.h:8:
   In file included from include/linux/blktrace_api.h:5:
   In file included from include/linux/blk-mq.h:8:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from drivers/md/md-bitmap.c:31:
   In file included from include/trace/events/block.h:8:
   In file included from include/linux/blktrace_api.h:5:
   In file included from include/linux/blk-mq.h:8:
   In file included from include/linux/scatterlist.h:9:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> drivers/md/md-bitmap.c:273:18: warning: variable 'rdev' is used uninitialized whenever function 'write_sb_page' is called [-Wsometimes-uninitialized]
           struct md_rdev *rdev;
           ~~~~~~~~~~~~~~~~^~~~
   drivers/md/md-bitmap.c:278:35: note: uninitialized use occurs here
                   while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
                                                   ^~~~
   drivers/md/md-bitmap.c:273:22: note: initialize the variable 'rdev' to silence this warning
           struct md_rdev *rdev;
                               ^
                                = NULL
   13 warnings generated.


vim +273 drivers/md/md-bitmap.c

   270	
   271	static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
   272	{
 > 273		struct md_rdev *rdev;
   274		struct mddev *mddev = bitmap->mddev;
   275		int ret;
   276	
   277		do {
   278			while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
   279				ret = __write_sb_page(rdev, bitmap, page);
   280				if (ret)
   281					return ret;
   282			}
   283		} while (wait && md_super_wait(mddev) < 0);
   284	
   285		return 0;
   286	}
   287	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
