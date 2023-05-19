Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DC3C77B75
	for <linux-raid@archiver.kernel.org>; Fri, 19 May 2023 08:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjESIIs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 19 May 2023 04:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjESIIr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 19 May 2023 04:08:47 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A146ED1
        for <linux-raid@vger.kernel.org>; Fri, 19 May 2023 01:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684483722; x=1716019722;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=qwt5XSvotsL6/OoCPhRbxmr6KwouXDESJaWqkjj6sY4=;
  b=D+y+bKLh+axCq9FUEhMCFyZaM6EPyZz26yhX8yTPDezu4ebOq3sW7DTA
   1E4bDWZ2UnS8MznSbpORJajE4xdyb2qjKDHEmCkVYE8SgLVKCFQbKCqfU
   D7vRvVn0ud4Ex3jgwmoSYnplVo7tvK6cDAKXK5ejjEsyW/iD/qLfK0Qry
   /4B6estX7gr1PU6lCcAIvW50ACNImGZJOUccyVefjIakmhnXAkp2oLV0w
   /fIcgKsSuD4gZQ0kJllREq/NKtSo65Xnvv7AJCoaJo943eVR428M2vsOH
   YGOKzRe2G+eT0YRcRpEcAZqdqcKzvxsTAppTO931qWTH4RH8STKg+juw+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="341747662"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="341747662"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 01:08:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="846805360"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="846805360"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2023 01:08:03 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pzv9f-000Ahe-0v;
        Fri, 19 May 2023 08:08:03 +0000
Date:   Fri, 19 May 2023 16:07:18 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev, linux-raid@vger.kernel.org
Subject: [song-md:module_alloc_test 5/6] arch/powerpc/kernel/module.c:108:15:
 error: unused variable 'ptr'
Message-ID: <202305191501.WQ9TlGuW-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git module_alloc_test
head:   7b05e9e4784401342805814b52f3dab621fdb1d1
commit: d4dbd22faf1717ce798327b60fc98cd5b7628ec8 [5/6] powerpc/module: use module_alloc_type
config: powerpc-pcm030_defconfig (https://download.01.org/0day-ci/archive/20230519/202305191501.WQ9TlGuW-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=d4dbd22faf1717ce798327b60fc98cd5b7628ec8
        git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
        git fetch --no-tags song-md module_alloc_test
        git checkout d4dbd22faf1717ce798327b60fc98cd5b7628ec8
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=powerpc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202305191501.WQ9TlGuW-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/powerpc/kernel/module.c: In function 'module_alloc_type_init':
>> arch/powerpc/kernel/module.c:108:15: error: unused variable 'ptr' [-Werror=unused-variable]
     108 |         void *ptr = NULL;
         |               ^~~
   cc1: all warnings being treated as errors


vim +/ptr +108 arch/powerpc/kernel/module.c

d4dbd22faf1717 Song Liu         2023-05-17   98  
d4dbd22faf1717 Song Liu         2023-05-17   99  void __init module_alloc_type_init(struct mod_allocators *allocators)
2ec13df167040c Christophe Leroy 2021-04-01  100  {
4fcc636615b1a3 Jordan Niethe    2021-06-09  101  	pgprot_t prot = strict_module_rwx_enabled() ? PAGE_KERNEL : PAGE_KERNEL_EXEC;
d4dbd22faf1717 Song Liu         2023-05-17  102  	struct mod_alloc_params *params = &powerpc_mod_type_allocator.params;
d4dbd22faf1717 Song Liu         2023-05-17  103  	struct vmalloc_params *vmp = &params->vmp[0];
d4dbd22faf1717 Song Liu         2023-05-17  104  	int i;
4fcc636615b1a3 Jordan Niethe    2021-06-09  105  
8abddd968a303d Nicholas Piggin  2021-05-03  106  #ifdef MODULES_VADDR
2ec13df167040c Christophe Leroy 2021-04-01  107  	unsigned long limit = (unsigned long)_etext - SZ_32M;
2ec13df167040c Christophe Leroy 2021-04-01 @108  	void *ptr = NULL;

:::::: The code at line 108 was first introduced by commit
:::::: 2ec13df167040cd153c25c4d96d0ffc573ac4c40 powerpc/modules: Load modules closer to kernel text

:::::: TO: Christophe Leroy <christophe.leroy@csgroup.eu>
:::::: CC: Michael Ellerman <mpe@ellerman.id.au>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
