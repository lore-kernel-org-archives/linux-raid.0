Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E01EB64DB
	for <linux-raid@archiver.kernel.org>; Wed, 14 Jun 2023 12:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244670AbjFNMdq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Jun 2023 08:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244613AbjFNMdm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Jun 2023 08:33:42 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CFE1FF0
        for <linux-raid@vger.kernel.org>; Wed, 14 Jun 2023 05:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686745999; x=1718281999;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=UGghMEvEY8zW301YstEYZBeI+gjrDjnN55hnJ4f4WAU=;
  b=jADeRMjgBZXEjfUmqnTg3Nm8cWwpdJK590vyYfJikNAjc8p8TRPs7+z8
   0nY1q8KyHyRNKVKO7oB7BCw3bP7RJm5kMXT412kGqZYuuc5QjkOmUJhUm
   t8HIKz7FcL7n+ySe0OPPHC3+IM6vqKWfXM0hWxSiPyYlb3Sdb+XX5Y9H4
   bWQXisB2sUDri1kt6CZm7e7yu+eZ8ChThbZe+FCFRlnfL1IGAKUrYHsxu
   JCMUt1eHTuOSv3q+nGKK9aUFiX7MJIBKx1ChtWkGs2gxZM/GhhS6fa7ZL
   OH5D88UBkziBlzZkNK2gDMjag1EM0Yqf8+iepvfkgCS4iYkFbNchYAz0c
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="356091403"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="356091403"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 05:33:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="741823946"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="741823946"
Received: from lkp-server02.sh.intel.com (HELO d59cacf64e9e) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 14 Jun 2023 05:33:16 -0700
Received: from kbuild by d59cacf64e9e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1q9Pga-0000dF-0U;
        Wed, 14 Jun 2023 12:33:16 +0000
Date:   Wed, 14 Jun 2023 20:32:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-raid@vger.kernel.org, Song Liu <song@kernel.org>
Subject: [song-md:md-next 25/29] drivers/md/raid1-10.c:117:25: error: casting
 from randomized structure pointer type 'struct block_device *' to 'struct
 md_rdev *'
Message-ID: <202306142042.fmjfmTF8-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
head:   460af1f9d9e62acce4a21f9bd00b5bcd5963bcd4
commit: 8295efbe68c080047e98d9c0eb5cb933b238a8cb [25/29] md/raid1-10: factor out a helper to submit normal write
config: arm-randconfig-r026-20230612 (https://download.01.org/0day-ci/archive/20230614/202306142042.fmjfmTF8-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm cross compiling tool for clang build
        # apt-get install binutils-arm-linux-gnueabi
        # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=8295efbe68c080047e98d9c0eb5cb933b238a8cb
        git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
        git fetch --no-tags song-md md-next
        git checkout 8295efbe68c080047e98d9c0eb5cb933b238a8cb
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang ~/bin/make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash drivers/

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306142042.fmjfmTF8-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/md/raid10.c:80:
>> drivers/md/raid1-10.c:117:25: error: casting from randomized structure pointer type 'struct block_device *' to 'struct md_rdev *'
     117 |         struct md_rdev *rdev = (struct md_rdev *)bio->bi_bdev;
         |                                ^
   1 error generated.


vim +117 drivers/md/raid1-10.c

   113	
   114	
   115	static inline void raid1_submit_write(struct bio *bio)
   116	{
 > 117		struct md_rdev *rdev = (struct md_rdev *)bio->bi_bdev;
   118	
   119		bio->bi_next = NULL;
   120		bio_set_dev(bio, rdev->bdev);
   121		if (test_bit(Faulty, &rdev->flags))
   122			bio_io_error(bio);
   123		else if (unlikely(bio_op(bio) ==  REQ_OP_DISCARD &&
   124				  !bdev_max_discard_sectors(bio->bi_bdev)))
   125			/* Just ignore it */
   126			bio_endio(bio);
   127		else
   128			submit_bio_noacct(bio);
   129	}
   130	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
