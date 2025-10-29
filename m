Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB1B2253A0
	for <linux-raid@vger.kernel.org>; Wed, 29 Oct 2025 05:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761716928; cv=none; b=uTXA5MehfwADbzOpk3n1F3/2V7WPBr/JefzvUuiRsU4301+pscKMtMcbwGnFByS1G1kJP5enTiqIcg3h5/lcHYU6ewpwq51uALSNXEe9I+DObgq1bd4vsVd6hoJelvrAdyd6711fHupOiBB/4NsCEeRLszwgwxbyjf+mCB200Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761716928; c=relaxed/simple;
	bh=PvEBsMRa9lt9XbNXYmHi8nJoX3ohTxGH/qlVFdG/Eic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y6tTNLU0JYGBEZbcSEF+/0jmtkZqJTvzsW5kfMVcpfBAcKyZIvBmgtl73+/+ztHqtnlgZ3+XVxPfArmD4jdd2VK7y70tdhgFGcXaG+Ft6Mg6+inIkcKE+V4M7ooNSlHR7iNHcRQuNaYZp78Pg618AqHlr3XS8pC4EAwcoCjwF4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TsuoqrH3; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TsuoqrH3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761716926; x=1793252926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PvEBsMRa9lt9XbNXYmHi8nJoX3ohTxGH/qlVFdG/Eic=;
  b=TsuoqrH3sxFqj28QKgcSNuqr+4GuGU/yxP388dD8y7p4y/fcRUXiMXWk
   DIryGixV4L6ENQolL8xPA6NwHs5LzBfg32HzIhJxZ6Ec5PJ9QSIhbM931
   HFUcNzd5dolUtU1q1fNOVkBAJsBeEFsHmDKIBUF8PHjx/RlmtcOrcPXss
   +n6OePoQmV0ofTzGcDcPu9WxOY+xXhLn1cLdKhEmi/MbjAj0nIlV1TiHP
   hwN66imC085N4iF00DLd2tOWIO9umkBbNTTn8gXcwsOsu/qSbfaeyBRJV
   gb/mutvuW5c7n9na4RLbWxz+N7EXL9LWrYXc+AS5FYD7PGYLZHI6/E6RT
   g==;
X-CSE-ConnectionGUID: 9GZ09JRnQSedUl7PhWCIDg==
X-CSE-MsgGUID: CBHrvhxeR5KLT2VS4EgnbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63731954"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63731954"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 22:48:46 -0700
X-CSE-ConnectionGUID: 64eUFbcxQ0OkG2KIoNj4mQ==
X-CSE-MsgGUID: 3g+P9elATOy/Rz8RNhwGOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,263,1754982000"; 
   d="scan'208";a="186020065"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 28 Oct 2025 22:48:44 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vDz0j-000KEX-23;
	Wed, 29 Oct 2025 05:46:33 +0000
Date: Wed, 29 Oct 2025 13:42:39 +0800
From: kernel test robot <lkp@intel.com>
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, yukuai@fnnas.com,
	song@kernel.org
Subject: Re: [PATCH 1/1] md: avoid repeated calls to del_gendisk
Message-ID: <202510291337.Y4OTvTsT-lkp@intel.com>
References: <20251028133737.98300-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028133737.98300-1-xni@redhat.com>

Hi Xiao,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.18-rc3 next-20251029]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiao-Ni/md-avoid-repeated-calls-to-del_gendisk/20251028-214651
base:   linus/master
patch link:    https://lore.kernel.org/r/20251028133737.98300-1-xni%40redhat.com
patch subject: [PATCH 1/1] md: avoid repeated calls to del_gendisk
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251029/202510291337.Y4OTvTsT-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251029/202510291337.Y4OTvTsT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510291337.Y4OTvTsT-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/md/md.c:946:4: error: expected ')'
     946 |                         del_gendisk(mddev->gendisk);
         |                         ^
   drivers/md/md.c:944:6: note: to match this '('
     944 |                 if (test_bit(MD_DELETED, &mddev->flags) &&
         |                    ^
   1 error generated.


vim +946 drivers/md/md.c

b6eb127d274385 NeilBrown        2010-04-15  877  
4934b6401a812f Yu Kuai          2023-06-21  878  void mddev_unlock(struct mddev *mddev)
3ce94ce5d05ae8 Yu Kuai          2023-05-23  879  {
3ce94ce5d05ae8 Yu Kuai          2023-05-23  880  	struct md_rdev *rdev;
3ce94ce5d05ae8 Yu Kuai          2023-05-23  881  	struct md_rdev *tmp;
4934b6401a812f Yu Kuai          2023-06-21  882  	LIST_HEAD(delete);
3ce94ce5d05ae8 Yu Kuai          2023-05-23  883  
4934b6401a812f Yu Kuai          2023-06-21  884  	if (!list_empty(&mddev->deleting))
4934b6401a812f Yu Kuai          2023-06-21  885  		list_splice_init(&mddev->deleting, &delete);
3ce94ce5d05ae8 Yu Kuai          2023-05-23  886  
a64c876fd35790 NeilBrown        2010-04-14  887  	if (mddev->to_remove) {
b6eb127d274385 NeilBrown        2010-04-15  888  		/* These cannot be removed under reconfig_mutex as
b6eb127d274385 NeilBrown        2010-04-15  889  		 * an access to the files will try to take reconfig_mutex
b6eb127d274385 NeilBrown        2010-04-15  890  		 * while holding the file unremovable, which leads to
b6eb127d274385 NeilBrown        2010-04-15  891  		 * a deadlock.
bb4f1e9d0e2ef9 NeilBrown        2010-08-08  892  		 * So hold set sysfs_active while the remove in happeing,
bb4f1e9d0e2ef9 NeilBrown        2010-08-08  893  		 * and anything else which might set ->to_remove or my
bb4f1e9d0e2ef9 NeilBrown        2010-08-08  894  		 * otherwise change the sysfs namespace will fail with
bb4f1e9d0e2ef9 NeilBrown        2010-08-08  895  		 * -EBUSY if sysfs_active is still set.
bb4f1e9d0e2ef9 NeilBrown        2010-08-08  896  		 * We set sysfs_active under reconfig_mutex and elsewhere
bb4f1e9d0e2ef9 NeilBrown        2010-08-08  897  		 * test it under the same mutex to ensure its correct value
bb4f1e9d0e2ef9 NeilBrown        2010-08-08  898  		 * is seen.
b6eb127d274385 NeilBrown        2010-04-15  899  		 */
c32dc04059c79d Rikard Falkeborn 2021-05-29  900  		const struct attribute_group *to_remove = mddev->to_remove;
a64c876fd35790 NeilBrown        2010-04-14  901  		mddev->to_remove = NULL;
bb4f1e9d0e2ef9 NeilBrown        2010-08-08  902  		mddev->sysfs_active = 1;
b6eb127d274385 NeilBrown        2010-04-15  903  		mutex_unlock(&mddev->reconfig_mutex);
b6eb127d274385 NeilBrown        2010-04-15  904  
00bcb4ac7ee7e5 NeilBrown        2010-06-01  905  		if (mddev->kobj.sd) {
a64c876fd35790 NeilBrown        2010-04-14  906  			if (to_remove != &md_redundancy_group)
a64c876fd35790 NeilBrown        2010-04-14  907  				sysfs_remove_group(&mddev->kobj, to_remove);
a64c876fd35790 NeilBrown        2010-04-14  908  			if (mddev->pers == NULL ||
a64c876fd35790 NeilBrown        2010-04-14  909  			    mddev->pers->sync_request == NULL) {
b6eb127d274385 NeilBrown        2010-04-15  910  				sysfs_remove_group(&mddev->kobj, &md_redundancy_group);
b6eb127d274385 NeilBrown        2010-04-15  911  				if (mddev->sysfs_action)
b6eb127d274385 NeilBrown        2010-04-15  912  					sysfs_put(mddev->sysfs_action);
e8efa9b88e3c20 Junxiao Bi       2020-08-04  913  				if (mddev->sysfs_completed)
e8efa9b88e3c20 Junxiao Bi       2020-08-04  914  					sysfs_put(mddev->sysfs_completed);
e8efa9b88e3c20 Junxiao Bi       2020-08-04  915  				if (mddev->sysfs_degraded)
e8efa9b88e3c20 Junxiao Bi       2020-08-04  916  					sysfs_put(mddev->sysfs_degraded);
b6eb127d274385 NeilBrown        2010-04-15  917  				mddev->sysfs_action = NULL;
e8efa9b88e3c20 Junxiao Bi       2020-08-04  918  				mddev->sysfs_completed = NULL;
e8efa9b88e3c20 Junxiao Bi       2020-08-04  919  				mddev->sysfs_degraded = NULL;
a64c876fd35790 NeilBrown        2010-04-14  920  			}
00bcb4ac7ee7e5 NeilBrown        2010-06-01  921  		}
bb4f1e9d0e2ef9 NeilBrown        2010-08-08  922  		mddev->sysfs_active = 0;
b6eb127d274385 NeilBrown        2010-04-15  923  	} else
df5b89b323b922 NeilBrown        2006-03-27  924  		mutex_unlock(&mddev->reconfig_mutex);
^1da177e4c3f41 Linus Torvalds   2005-04-16  925  
7deac114be5fb2 Yu Kuai          2023-08-25  926  	md_wakeup_thread(mddev->thread);
7deac114be5fb2 Yu Kuai          2023-08-25  927  	wake_up(&mddev->sb_wait);
7deac114be5fb2 Yu Kuai          2023-08-25  928  
4934b6401a812f Yu Kuai          2023-06-21  929  	list_for_each_entry_safe(rdev, tmp, &delete, same_set) {
4934b6401a812f Yu Kuai          2023-06-21  930  		list_del_init(&rdev->same_set);
4934b6401a812f Yu Kuai          2023-06-21  931  		kobject_del(&rdev->kobj);
4934b6401a812f Yu Kuai          2023-06-21  932  		export_rdev(rdev, mddev);
4934b6401a812f Yu Kuai          2023-06-21  933  	}
9e59d609763f70 Xiao Ni          2025-06-11  934  
25db5f284fb8f3 Xiao Ni          2025-08-13  935  	if (!legacy_async_del_gendisk) {
25db5f284fb8f3 Xiao Ni          2025-08-13  936  		/*
25db5f284fb8f3 Xiao Ni          2025-08-13  937  		 * Call del_gendisk after release reconfig_mutex to avoid
9e59d609763f70 Xiao Ni          2025-06-11  938  		 * deadlock (e.g. call del_gendisk under the lock and an
9e59d609763f70 Xiao Ni          2025-06-11  939  		 * access to sysfs files waits the lock)
9e59d609763f70 Xiao Ni          2025-06-11  940  		 * And MD_DELETED is only used for md raid which is set in
9e59d609763f70 Xiao Ni          2025-06-11  941  		 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
9e59d609763f70 Xiao Ni          2025-06-11  942  		 * doesn't need to check MD_DELETED when getting reconfig lock
9e59d609763f70 Xiao Ni          2025-06-11  943  		 */
eb7b0a59eaddd5 Xiao Ni          2025-10-28  944  		if (test_bit(MD_DELETED, &mddev->flags) &&
eb7b0a59eaddd5 Xiao Ni          2025-10-28  945  			!test_and_set_bit(MD_DO_DELETE, &mddev->flags)
9e59d609763f70 Xiao Ni          2025-06-11 @946  			del_gendisk(mddev->gendisk);
^1da177e4c3f41 Linus Torvalds   2005-04-16  947  	}
25db5f284fb8f3 Xiao Ni          2025-08-13  948  }
5c47daf6e76f65 NeilBrown        2014-12-15  949  EXPORT_SYMBOL_GPL(mddev_unlock);
^1da177e4c3f41 Linus Torvalds   2005-04-16  950  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
