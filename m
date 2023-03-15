Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C04CC6FD1D
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 15:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjCOPie (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 11:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbjCOPiY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 11:38:24 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B54A2D56
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 08:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678894698; x=1710430698;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=my+1eaYYbjkuQi8/aV/P27e7gqYYBgLvC5nNOOiwsmM=;
  b=Qfwvnr6dnyXX6csID00S8Re1lYPkNqICT+ZwcvQVTEA83HZ/k4Skl3Bw
   mP/wJu52CTovvvIqlRqWA95DA0pOyNMgJwelq1xLgNP8+9EKnciT3e1Vw
   YeJb5EKfgAsL0Xyc22HSE7n3mFxfjMW8qItDlDBzyZObA0EngKCdEWQgq
   7yqFKSnqmCkghJr9d3IUqI2UFQt8j2xULTpQ+4ma+5OchkNCvDVke/d2g
   /7xlXF2d/isVncFaoZcD+zhavGaFlnsZYmCQtWzqmTEoyc9oSEXCo3+Zx
   6faGiMWxFsf6caISjq4ryHg6dfpE7CPN35a/YUQ9bAesEDhA6TwQ7Yj8y
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="321577058"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="321577058"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 08:37:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="711965134"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="711965134"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 15 Mar 2023 08:37:56 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcTCM-0007pP-1x;
        Wed, 15 Mar 2023 15:37:54 +0000
Date:   Wed, 15 Mar 2023 23:37:15 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jon Derrick <jonathan.derrick@linux.dev>
Cc:     oe-kbuild-all@lists.linux.dev, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: [song-md:md-next 6/14] drivers/md/md-bitmap.c:242 __write_sb_page()
 warn: unsigned 'offset' is never less than zero.
Message-ID: <202303152311.cmIqIgUw-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
head:   703c560db9a7b61c6ac7cb5fd634d7d5c1c4f38f
commit: d0c7aab97dbfa289ea6ac06acf65c5191f41f9c6 [6/14] md: Fix types in sb writer
config: ia64-randconfig-m031-20230312 (https://download.01.org/0day-ci/archive/20230315/202303152311.cmIqIgUw-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 12.1.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303152311.cmIqIgUw-lkp@intel.com/

smatch warnings:
drivers/md/md-bitmap.c:242 __write_sb_page() warn: unsigned 'offset' is never less than zero.

vim +/offset +242 drivers/md/md-bitmap.c

b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  211  
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  212  static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  213  			   struct page *page)
a654b9d8f851f4 drivers/md/bitmap.c    NeilBrown        2005-06-21  214  {
a6ff7e089c7fca drivers/md/bitmap.c    Jonathan Brassow 2011-01-14  215  	struct block_device *bdev;
fd01b88c75a718 drivers/md/bitmap.c    NeilBrown        2011-10-11  216  	struct mddev *mddev = bitmap->mddev;
1ec885cdd01a9a drivers/md/bitmap.c    NeilBrown        2012-05-22  217  	struct bitmap_storage *store = &bitmap->storage;
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  218  	sector_t offset = mddev->bitmap_info.offset;
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  219  	sector_t ps, sboff, doff;
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  220  	unsigned int size = PAGE_SIZE;
a6ff7e089c7fca drivers/md/bitmap.c    Jonathan Brassow 2011-01-14  221  
a6ff7e089c7fca drivers/md/bitmap.c    Jonathan Brassow 2011-01-14  222  	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  223  	if (page->index == store->file_pages - 1) {
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  224  		unsigned int last_page_size = store->bytes & (PAGE_SIZE - 1);
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  225  
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  226  		if (last_page_size == 0)
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  227  			last_page_size = PAGE_SIZE;
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  228  		size = roundup(last_page_size,
a6ff7e089c7fca drivers/md/bitmap.c    Jonathan Brassow 2011-01-14  229  			       bdev_logical_block_size(bdev));
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  230  	}
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  231  
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  232  	ps = page->index * PAGE_SIZE / SECTOR_SIZE;
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  233  	sboff = rdev->sb_start + offset;
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  234  	doff = rdev->data_offset;
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  235  
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  236  	/* Just make sure we aren't corrupting data or metadata */
f6af949c567211 drivers/md/bitmap.c    NeilBrown        2009-12-14  237  	if (mddev->external) {
f6af949c567211 drivers/md/bitmap.c    NeilBrown        2009-12-14  238  		/* Bitmap could be anywhere. */
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  239  		if (sboff + ps > doff &&
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  240  		    sboff < (doff + mddev->dev_sectors + PAGE_SIZE / SECTOR_SIZE))
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  241  			return -EINVAL;
f6af949c567211 drivers/md/bitmap.c    NeilBrown        2009-12-14 @242  	} else if (offset < 0) {
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  243  		/* DATA  BITMAP METADATA  */
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  244  		if (offset + ps + size / SECTOR_SIZE > 0)
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  245  			/* bitmap runs in to metadata */
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  246  			return -EINVAL;
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  247  
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  248  		if (doff + mddev->dev_sectors > sboff)
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  249  			/* data runs in to bitmap */
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  250  			return -EINVAL;
0f420358e3a2ab drivers/md/bitmap.c    Andre Noll       2008-07-11  251  	} else if (rdev->sb_start < rdev->data_offset) {
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  252  		/* METADATA BITMAP DATA */
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  253  		if (sboff + ps + size / SECTOR_SIZE > doff)
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  254  			/* bitmap runs in to data */
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  255  			return -EINVAL;
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  256  	} else {
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  257  		/* DATA METADATA BITMAP - no problems */
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  258  	}
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  259  
d0c7aab97dbfa2 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  260  	md_super_write(mddev, rdev, sboff + ps, (int) size, page);
459bd47c515277 drivers/md/md-bitmap.c Jon Derrick      2023-02-24  261  	return 0;
ab6085c795a71b drivers/md/bitmap.c    NeilBrown        2007-05-23  262  }
a654b9d8f851f4 drivers/md/bitmap.c    NeilBrown        2005-06-21  263  

:::::: The code at line 242 was first introduced by commit
:::::: f6af949c5672115313cc3c976d85b0533f607d7e md: support bitmap offset appropriate for external-metadata arrays.

:::::: TO: NeilBrown <neilb@suse.de>
:::::: CC: NeilBrown <neilb@suse.de>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
