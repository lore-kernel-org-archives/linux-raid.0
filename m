From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 2/2] md/r5cache: enable chunk_aligned_read with write
 back cache
Date: Wed, 11 Jan 2017 21:47:44 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1701112146240.2158@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: neilb@suse.com, shli@fb.com, kernel-team@fb.com, dan.j.williams@intel.com, hch@infradead.org, liuzhengyuan@kylinos.cn, liuyun01@kylinos.cn, Song Liu <songliubraving@fb.com>, Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org, kbuild-all@01.org
List-Id: linux-raid.ids

Please check on the type of reclaimable.  With respect to the test on lime
1437, it should not be unsigned.

julia

---------- Forwarded message ----------
Date: Thu, 12 Jan 2017 02:18:47 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 2/2] md/r5cache: enable chunk_aligned_read with write
    back cache

In-Reply-To: <20170111014251.3236610-2-songliubraving@fb.com>

Hi Song,

[auto build test WARNING on next-20170111]
[cannot apply to linus/master linux/master v4.9-rc8 v4.9-rc7 v4.9-rc6 v4.10-rc3]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Song-Liu/EXPORT_SYMBOL-radix_tree_lookup_slot/20170112-000003
:::::: branch date: 2 hours ago
:::::: commit date: 2 hours ago

>> drivers/md/raid5-cache.c:1437:8-19: WARNING: Unsigned expression compared with zero: reclaimable < 0

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 325354ecd953e312b0109229d654ef52db1f35a7
vim +1437 drivers/md/raid5-cache.c

17036461 Christoph Hellwig 2015-10-05  1421  		if (reclaimable >= reclaim_target ||
0576b1c6 Shaohua Li        2015-08-13  1422  		    (list_empty(&log->running_ios) &&
0576b1c6 Shaohua Li        2015-08-13  1423  		     list_empty(&log->io_end_ios) &&
a8c34f91 Shaohua Li        2015-09-02  1424  		     list_empty(&log->flushing_ios) &&
04732f74 Christoph Hellwig 2015-10-05  1425  		     list_empty(&log->finished_ios)))
0576b1c6 Shaohua Li        2015-08-13  1426  			break;
0576b1c6 Shaohua Li        2015-08-13  1427
17036461 Christoph Hellwig 2015-10-05  1428  		md_wakeup_thread(log->rdev->mddev->thread);
17036461 Christoph Hellwig 2015-10-05  1429  		wait_event_lock_irq(log->iounit_wait,
17036461 Christoph Hellwig 2015-10-05  1430  				    r5l_reclaimable_space(log) > reclaimable,
17036461 Christoph Hellwig 2015-10-05  1431  				    log->io_list_lock);
0576b1c6 Shaohua Li        2015-08-13  1432  	}
17036461 Christoph Hellwig 2015-10-05  1433
a39f7afd Song Liu          2016-11-17  1434  	next_checkpoint = r5c_calculate_new_cp(conf);
0576b1c6 Shaohua Li        2015-08-13  1435  	spin_unlock_irq(&log->io_list_lock);
0576b1c6 Shaohua Li        2015-08-13  1436
17036461 Christoph Hellwig 2015-10-05 @1437  	BUG_ON(reclaimable < 0);
a39f7afd Song Liu          2016-11-17  1438
a39f7afd Song Liu          2016-11-17  1439  	if (reclaimable == 0 || !write_super)
0576b1c6 Shaohua Li        2015-08-13  1440  		return;
0576b1c6 Shaohua Li        2015-08-13  1441
0576b1c6 Shaohua Li        2015-08-13  1442  	/*
0576b1c6 Shaohua Li        2015-08-13  1443  	 * write_super will flush cache of each raid disk. We must write super
0576b1c6 Shaohua Li        2015-08-13  1444  	 * here, because the log area might be reused soon and we don't want to
0576b1c6 Shaohua Li        2015-08-13  1445  	 * confuse recovery

:::::: The code at line 1437 was first introduced by commit
:::::: 170364619ac21c2b14869571eeaf767ae825f96c raid5-cache: free I/O units earlier

:::::: TO: Christoph Hellwig <hch@lst.de>
:::::: CC: NeilBrown <neilb@suse.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
