Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5D9C61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 04:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbjBWEFv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Feb 2023 23:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjBWEFu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Feb 2023 23:05:50 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27393D0BA
        for <linux-raid@vger.kernel.org>; Wed, 22 Feb 2023 20:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677125147; x=1708661147;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QTb8mNjYLUSum9kgvm7yoHqLsC2Yt+brW4i0D6VXP0g=;
  b=ejjYM9zcqEAdeuD85v+e7DCWz3DKUO/ArmRIe01Iw40aiCizWEPi+fwI
   M2vo3EgODOFzBClRyarYTG1ULcKGciVDG98ZnQdpJ9gRqP0no0uJlj8Y2
   8jYRWn6Hy31AVsb8psoMN03kOThuCjXWqzHUbziuqBB7unWU8VXsF6dTO
   KpUwORQ3w7vSMUqDK1uXJ3drM4YKYlbQq3HvY7APuvKl3iDpyFN+1t2nu
   A6EbUilxeoeFo8SB18U/eNWOD9dlFOnfQnGmt7ev6J1uP6/G0ZSdN8ofT
   oqv9uv82RmiuzmQFdfR9cPblzPd5y6CjRXnGssHPc6RqUn/TBXkBmiqN8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="397803979"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="397803979"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2023 20:05:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10629"; a="1001256023"
X-IronPort-AV: E=Sophos;i="5.97,320,1669104000"; 
   d="scan'208";a="1001256023"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 22 Feb 2023 20:05:44 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pV2rY-0000zE-0f;
        Thu, 23 Feb 2023 04:05:44 +0000
Date:   Thu, 23 Feb 2023 12:05:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jonathan Derrick <jonathan.derrick@linux.dev>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Xiao Ni <xni@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Sushma Kalakota <sushma.kalakota@intel.com>,
        Jon Derrick <jonathan.derrick@linux.dev>
Subject: Re: [PATCH v3 1/3] md: Move sb writer loop to its own function
Message-ID: <202302231124.oHGZxi0D-lkp@intel.com>
References: <20230222215828.225-2-jonathan.derrick@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222215828.225-2-jonathan.derrick@linux.dev>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jonathan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on song-md/md-next]
[also build test WARNING on linus/master v6.2 next-20230222]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jonathan-Derrick/md-Move-sb-writer-loop-to-its-own-function/20230223-060300
base:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
patch link:    https://lore.kernel.org/r/20230222215828.225-2-jonathan.derrick%40linux.dev
patch subject: [PATCH v3 1/3] md: Move sb writer loop to its own function
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20230223/202302231124.oHGZxi0D-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/17d8d09a65e91fada0801ca9bf4e3560780bb543
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jonathan-Derrick/md-Move-sb-writer-loop-to-its-own-function/20230223-060300
        git checkout 17d8d09a65e91fada0801ca9bf4e3560780bb543
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=alpha olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302231124.oHGZxi0D-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In function 'next_active_rdev',
       inlined from 'write_sb_page' at drivers/md/md-bitmap.c:277:18:
>> drivers/md/md-bitmap.c:192:12: warning: 'rdev' is used uninitialized [-Wuninitialized]
     192 |         if (rdev == NULL)
         |            ^
   drivers/md/md-bitmap.c: In function 'write_sb_page':
   drivers/md/md-bitmap.c:272:25: note: 'rdev' was declared here
     272 |         struct md_rdev *rdev;
         |                         ^~~~


vim +/rdev +192 drivers/md/md-bitmap.c

a654b9d8f851f4 drivers/md/bitmap.c    NeilBrown        2005-06-21  175  
fd01b88c75a718 drivers/md/bitmap.c    NeilBrown        2011-10-11  176  static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mddev)
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  177  {
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  178  	/* Iterate the disks of an mddev, using rcu to protect access to the
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  179  	 * linked list, and raising the refcount of devices we return to ensure
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  180  	 * they don't disappear while in use.
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  181  	 * As devices are only added or removed when raid_disk is < 0 and
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  182  	 * nr_pending is 0 and In_sync is clear, the entries we return will
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  183  	 * still be in the same position on the list when we re-enter
fd177481b440c3 drivers/md/bitmap.c    Michael Wang     2012-10-11  184  	 * list_for_each_entry_continue_rcu.
8532e3439087de drivers/md/bitmap.c    NeilBrown        2015-05-20  185  	 *
8532e3439087de drivers/md/bitmap.c    NeilBrown        2015-05-20  186  	 * Note that if entered with 'rdev == NULL' to start at the
8532e3439087de drivers/md/bitmap.c    NeilBrown        2015-05-20  187  	 * beginning, we temporarily assign 'rdev' to an address which
8532e3439087de drivers/md/bitmap.c    NeilBrown        2015-05-20  188  	 * isn't really an rdev, but which can be used by
8532e3439087de drivers/md/bitmap.c    NeilBrown        2015-05-20  189  	 * list_for_each_entry_continue_rcu() to find the first entry.
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  190  	 */
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  191  	rcu_read_lock();
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01 @192  	if (rdev == NULL)
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  193  		/* start at the beginning */
8532e3439087de drivers/md/bitmap.c    NeilBrown        2015-05-20  194  		rdev = list_entry(&mddev->disks, struct md_rdev, same_set);
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  195  	else {
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  196  		/* release the previous rdev and start from there. */
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  197  		rdev_dec_pending(rdev, mddev);
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  198  	}
fd177481b440c3 drivers/md/bitmap.c    Michael Wang     2012-10-11  199  	list_for_each_entry_continue_rcu(rdev, &mddev->disks, same_set) {
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  200  		if (rdev->raid_disk >= 0 &&
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  201  		    !test_bit(Faulty, &rdev->flags)) {
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  202  			/* this is a usable devices */
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  203  			atomic_inc(&rdev->nr_pending);
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  204  			rcu_read_unlock();
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  205  			return rdev;
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  206  		}
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  207  	}
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  208  	rcu_read_unlock();
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  209  	return NULL;
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  210  }
b2d2c4ceaddc30 drivers/md/bitmap.c    NeilBrown        2008-09-01  211  
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  212  static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  213  			   struct page *page)
a654b9d8f851f4 drivers/md/bitmap.c    NeilBrown        2005-06-21  214  {
a6ff7e089c7fca drivers/md/bitmap.c    Jonathan Brassow 2011-01-14  215  	struct block_device *bdev;
fd01b88c75a718 drivers/md/bitmap.c    NeilBrown        2011-10-11  216  	struct mddev *mddev = bitmap->mddev;
1ec885cdd01a9a drivers/md/bitmap.c    NeilBrown        2012-05-22  217  	struct bitmap_storage *store = &bitmap->storage;
f6af949c567211 drivers/md/bitmap.c    NeilBrown        2009-12-14  218  	loff_t offset = mddev->bitmap_info.offset;
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  219  	int size = PAGE_SIZE;
a6ff7e089c7fca drivers/md/bitmap.c    Jonathan Brassow 2011-01-14  220  
a6ff7e089c7fca drivers/md/bitmap.c    Jonathan Brassow 2011-01-14  221  	bdev = (rdev->meta_bdev) ? rdev->meta_bdev : rdev->bdev;
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  222  	if (page->index == store->file_pages - 1) {
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  223  		int last_page_size = store->bytes & (PAGE_SIZE - 1);
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  224  		if (last_page_size == 0)
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  225  			last_page_size = PAGE_SIZE;
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  226  		size = roundup(last_page_size,
a6ff7e089c7fca drivers/md/bitmap.c    Jonathan Brassow 2011-01-14  227  			       bdev_logical_block_size(bdev));
9b1215c102d4b1 drivers/md/bitmap.c    NeilBrown        2012-05-22  228  	}
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  229  
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  230  	/* Just make sure we aren't corrupting data or metadata */
f6af949c567211 drivers/md/bitmap.c    NeilBrown        2009-12-14  231  	if (mddev->external) {
f6af949c567211 drivers/md/bitmap.c    NeilBrown        2009-12-14  232  		/* Bitmap could be anywhere. */
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  233  		if (rdev->sb_start + offset
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  234  		    + (page->index * (PAGE_SIZE / SECTOR_SIZE))
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  235  		    > rdev->data_offset &&
ac2f40be46ce6a drivers/md/bitmap.c    NeilBrown        2010-06-01  236  		    rdev->sb_start + offset
ac2f40be46ce6a drivers/md/bitmap.c    NeilBrown        2010-06-01  237  		    < (rdev->data_offset + mddev->dev_sectors
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  238  		     + (PAGE_SIZE / SECTOR_SIZE)))
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  239  			return -EINVAL;
f6af949c567211 drivers/md/bitmap.c    NeilBrown        2009-12-14  240  	} else if (offset < 0) {
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  241  		/* DATA  BITMAP METADATA  */
42a04b5078ce73 drivers/md/bitmap.c    NeilBrown        2009-12-14  242  		if (offset
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  243  		    + (long)(page->index * (PAGE_SIZE / SECTOR_SIZE))
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  244  		    + size / SECTOR_SIZE > 0)
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  245  			/* bitmap runs in to metadata */
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  246  			return -EINVAL;
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  247  
58c0fed400603a drivers/md/bitmap.c    Andre Noll       2009-03-31  248  		if (rdev->data_offset + mddev->dev_sectors
42a04b5078ce73 drivers/md/bitmap.c    NeilBrown        2009-12-14  249  		    > rdev->sb_start + offset)
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  250  			/* data runs in to bitmap */
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  251  			return -EINVAL;
0f420358e3a2ab drivers/md/bitmap.c    Andre Noll       2008-07-11  252  	} else if (rdev->sb_start < rdev->data_offset) {
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  253  		/* METADATA BITMAP DATA */
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  254  		if (rdev->sb_start + offset
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  255  		    + page->index * (PAGE_SIZE / SECTOR_SIZE)
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  256  		    + size / SECTOR_SIZE > rdev->data_offset)
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  257  			/* bitmap runs in to data */
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  258  			return -EINVAL;
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  259  	} else {
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  260  		/* DATA METADATA BITMAP - no problems */
f0d76d70bc77b9 drivers/md/bitmap.c    NeilBrown        2007-07-17  261  	}
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  262  
a654b9d8f851f4 drivers/md/bitmap.c    NeilBrown        2005-06-21  263  	md_super_write(mddev, rdev,
42a04b5078ce73 drivers/md/bitmap.c    NeilBrown        2009-12-14  264  		       rdev->sb_start + offset
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  265  		       + page->index * (PAGE_SIZE / SECTOR_SIZE),
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  266  		       size, page);
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  267  	return 0;
ab6085c795a71b drivers/md/bitmap.c    NeilBrown        2007-05-23  268  }
a654b9d8f851f4 drivers/md/bitmap.c    NeilBrown        2005-06-21  269  
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  270  static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  271  {
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  272  	struct md_rdev *rdev;
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  273  	struct mddev *mddev = bitmap->mddev;
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  274  	int ret;
4b80991c6cb9ef drivers/md/bitmap.c    NeilBrown        2008-07-21  275  
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  276  	do {
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22 @277  		while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  278  			ret = __write_sb_page(rdev, bitmap, page);
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  279  			if (ret)
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  280  				return ret;
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  281  		}
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  282  	} while (wait && md_super_wait(mddev) < 0);
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  283  
17d8d09a65e91f drivers/md/md-bitmap.c Jon Derrick      2023-02-22  284  	return 0;
a654b9d8f851f4 drivers/md/bitmap.c    NeilBrown        2005-06-21  285  }
a654b9d8f851f4 drivers/md/bitmap.c    NeilBrown        2005-06-21  286  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
