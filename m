Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6223191C8;
	Tue, 10 Feb 2026 11:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770722124; cv=none; b=C6iEr4L5qGiARvcR1PiwWUPIx/SsWX2LuA1mGi80mN1G4rPLV4d6Rng7kfCUyd4zNYNIy8QiDTeWyRMH9GHyTlb7NNVTl7t0IVpnWo2EIcsbk1n2udxSyOUIwwugdUUYUdki4Fbk5V8aZO0souexKls1Gn70nIG7gYWDfiMniCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770722124; c=relaxed/simple;
	bh=hPer5DuuhHwWGWLHiuyjR6VMGR0KWf+Hs6oysMEpB7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxq0pq1bP6GEpAfzI5Z+mwzk47nGWb46nmnVBn+sKmzv4pCQ5OT6zRpfA5dERJ+iGsP3DhdYtYWy2+ec+XfeWsqtx7ox9d+u7VusnZckcVxvbVwrpJtexZXnj1ShZXmkFAfShWG4mJx/hPRoegSvnaUvfRVJyTK1eHBaXayDfZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OWToVBHz; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OWToVBHz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770722122; x=1802258122;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hPer5DuuhHwWGWLHiuyjR6VMGR0KWf+Hs6oysMEpB7M=;
  b=OWToVBHz7q1i+ED5W0iMKlE6uNZRsvxsasdbSZSV+fNWghYbFkcklJMD
   1aElXNOiB3yUklldDPBmOnN5KbznpGff8WNCgKt+cyeAMCXQSCug27XjP
   TlkvxBzxWQXyFNQrob7PmAYjfwURvl2g0R52dTwE17Nu8NG2gkMHBEFOy
   9XTy9pi8ui7E1JrRxFqYsbkxY5K+tcp9CNDfEzCwepembueKZNv1u45bN
   hdAQb4fQjWNa0QwmBGAu7DYOgwEElFyP2ZU76WPQfiqeSOAKHIyOo+lbe
   tWx7scrurYhPX2LKaosf49M6enqlTwTd+chBTKd0nwAw+Ik0rAgSzr9df
   w==;
X-CSE-ConnectionGUID: ZBBhmxEVQCanoa0z8U2j9w==
X-CSE-MsgGUID: SMxWShEoTgSXec7P7Jgulw==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="97307739"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="97307739"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 03:15:21 -0800
X-CSE-ConnectionGUID: AxPKUe/qTE+wrOk9jpf8tg==
X-CSE-MsgGUID: fC92wVP4Se21KDRfvsadnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="216854604"
Received: from igk-lkp-server01.igk.intel.com (HELO e5404a91d123) ([10.211.93.152])
  by orviesa005.jf.intel.com with ESMTP; 10 Feb 2026 03:15:18 -0800
Received: from kbuild by e5404a91d123 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpli2-000000000mL-3z75;
	Tue, 10 Feb 2026 11:15:10 +0000
Date: Tue, 10 Feb 2026 12:14:56 +0100
From: kernel test robot <lkp@intel.com>
To: Josh Hunt <johunt@akamai.com>, song@kernel.org, yukuai@fnnas.com,
	linan122@huawei.com, linux-raid@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, ncroxon@redhat.com,
	Josh Hunt <johunt@akamai.com>, stable@vger.kernel.org
Subject: Re: [PATCH] md/raid10: fix deadlock with check operation and nowait
 requests
Message-ID: <202602101220.J4BofeDD-lkp@intel.com>
References: <20260210050942.3731656-1-johunt@akamai.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210050942.3731656-1-johunt@akamai.com>

Hi Josh,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.19 next-20260209]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Josh-Hunt/md-raid10-fix-deadlock-with-check-operation-and-nowait-requests/20260210-135305
base:   linus/master
patch link:    https://lore.kernel.org/r/20260210050942.3731656-1-johunt%40akamai.com
patch subject: [PATCH] md/raid10: fix deadlock with check operation and nowait requests
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260210/202602101220.J4BofeDD-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602101220.J4BofeDD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602101220.J4BofeDD-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/md/raid10.c: In function 'raid10_read_request':
>> drivers/md/raid10.c:1257:9: error: too few arguments to function 'raid_end_bio_io'
    1257 |         raid_end_bio_io(r10_bio);
         |         ^~~~~~~~~~~~~~~
   drivers/md/raid10.c:321:13: note: declared here
     321 | static void raid_end_bio_io(struct r10bio *r10_bio, bool adjust_pending)
         |             ^~~~~~~~~~~~~~~
   drivers/md/raid10.c: In function 'raid10_write_request':
   drivers/md/raid10.c:1540:9: error: too few arguments to function 'raid_end_bio_io'
    1540 |         raid_end_bio_io(r10_bio);
         |         ^~~~~~~~~~~~~~~
   drivers/md/raid10.c:321:13: note: declared here
     321 | static void raid_end_bio_io(struct r10bio *r10_bio, bool adjust_pending)
         |             ^~~~~~~~~~~~~~~


vim +/raid_end_bio_io +1257 drivers/md/raid10.c

caea3c47ad5152 Guoqing Jiang     2018-12-07  1161  
bb5f1ed70bc3bb Robert LeBlanc    2016-12-05  1162  static void raid10_read_request(struct mddev *mddev, struct bio *bio,
820455238366a7 Yu Kuai           2023-06-22  1163  				struct r10bio *r10_bio, bool io_accounting)
^1da177e4c3f41 Linus Torvalds    2005-04-16  1164  {
e879a8793f915a NeilBrown         2011-10-11  1165  	struct r10conf *conf = mddev->private;
^1da177e4c3f41 Linus Torvalds    2005-04-16  1166  	struct bio *read_bio;
d4432c23be957f NeilBrown         2011-07-28  1167  	int max_sectors;
bb5f1ed70bc3bb Robert LeBlanc    2016-12-05  1168  	struct md_rdev *rdev;
545250f2480911 NeilBrown         2017-04-05  1169  	char b[BDEVNAME_SIZE];
545250f2480911 NeilBrown         2017-04-05  1170  	int slot = r10_bio->read_slot;
545250f2480911 NeilBrown         2017-04-05  1171  	struct md_rdev *err_rdev = NULL;
545250f2480911 NeilBrown         2017-04-05  1172  	gfp_t gfp = GFP_NOIO;
9b622e2bbcf049 Tomasz Majchrzak  2016-07-28  1173  
93decc563637c4 Kevin Vigor       2020-11-06  1174  	if (slot >= 0 && r10_bio->devs[slot].rdev) {
545250f2480911 NeilBrown         2017-04-05  1175  		/*
545250f2480911 NeilBrown         2017-04-05  1176  		 * This is an error retry, but we cannot
545250f2480911 NeilBrown         2017-04-05  1177  		 * safely dereference the rdev in the r10_bio,
545250f2480911 NeilBrown         2017-04-05  1178  		 * we must use the one in conf.
545250f2480911 NeilBrown         2017-04-05  1179  		 * If it has already been disconnected (unlikely)
545250f2480911 NeilBrown         2017-04-05  1180  		 * we lose the device name in error messages.
545250f2480911 NeilBrown         2017-04-05  1181  		 */
545250f2480911 NeilBrown         2017-04-05  1182  		int disk;
545250f2480911 NeilBrown         2017-04-05  1183  		/*
545250f2480911 NeilBrown         2017-04-05  1184  		 * As we are blocking raid10, it is a little safer to
545250f2480911 NeilBrown         2017-04-05  1185  		 * use __GFP_HIGH.
545250f2480911 NeilBrown         2017-04-05  1186  		 */
545250f2480911 NeilBrown         2017-04-05  1187  		gfp = GFP_NOIO | __GFP_HIGH;
545250f2480911 NeilBrown         2017-04-05  1188  
545250f2480911 NeilBrown         2017-04-05  1189  		disk = r10_bio->devs[slot].devnum;
a448af25becf4b Yu Kuai           2023-11-25  1190  		err_rdev = conf->mirrors[disk].rdev;
545250f2480911 NeilBrown         2017-04-05  1191  		if (err_rdev)
900d156bac2bc4 Christoph Hellwig 2022-07-13  1192  			snprintf(b, sizeof(b), "%pg", err_rdev->bdev);
545250f2480911 NeilBrown         2017-04-05  1193  		else {
545250f2480911 NeilBrown         2017-04-05  1194  			strcpy(b, "???");
545250f2480911 NeilBrown         2017-04-05  1195  			/* This never gets dereferenced */
545250f2480911 NeilBrown         2017-04-05  1196  			err_rdev = r10_bio->devs[slot].rdev;
545250f2480911 NeilBrown         2017-04-05  1197  		}
545250f2480911 NeilBrown         2017-04-05  1198  	}
856e08e23762df NeilBrown         2011-07-28  1199  
43806c3d5b9bb7 Nigel Croxon      2025-07-03  1200  	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
4e9814d1943b0e Josh Hunt         2026-02-10  1201  		raid_end_bio_io(r10_bio, false);
c9aa889b035fca Vishal Verma      2021-12-21  1202  		return;
43806c3d5b9bb7 Nigel Croxon      2025-07-03  1203  	}
43806c3d5b9bb7 Nigel Croxon      2025-07-03  1204  
96c3fd1f380237 NeilBrown         2011-12-23  1205  	rdev = read_balance(conf, r10_bio, &max_sectors);
96c3fd1f380237 NeilBrown         2011-12-23  1206  	if (!rdev) {
545250f2480911 NeilBrown         2017-04-05  1207  		if (err_rdev) {
545250f2480911 NeilBrown         2017-04-05  1208  			pr_crit_ratelimited("md/raid10:%s: %s: unrecoverable I/O read error for block %llu\n",
545250f2480911 NeilBrown         2017-04-05  1209  					    mdname(mddev), b,
545250f2480911 NeilBrown         2017-04-05  1210  					    (unsigned long long)r10_bio->sector);
545250f2480911 NeilBrown         2017-04-05  1211  		}
4e9814d1943b0e Josh Hunt         2026-02-10  1212  		raid_end_bio_io(r10_bio, true);
5a7bbad27a4103 Christoph Hellwig 2011-09-12  1213  		return;
^1da177e4c3f41 Linus Torvalds    2005-04-16  1214  	}
545250f2480911 NeilBrown         2017-04-05  1215  	if (err_rdev)
913cce5a1e588e Christoph Hellwig 2022-05-12  1216  		pr_err_ratelimited("md/raid10:%s: %pg: redirecting sector %llu to another mirror\n",
545250f2480911 NeilBrown         2017-04-05  1217  				   mdname(mddev),
913cce5a1e588e Christoph Hellwig 2022-05-12  1218  				   rdev->bdev,
545250f2480911 NeilBrown         2017-04-05  1219  				   (unsigned long long)r10_bio->sector);
fc9977dd069e4f NeilBrown         2017-04-05  1220  	if (max_sectors < bio_sectors(bio)) {
e820d55cb99dd9 Guoqing Jiang     2018-12-19  1221  		allow_barrier(conf);
6fc07785d9b892 Yu Kuai           2025-09-10  1222  		bio = bio_submit_split_bioset(bio, max_sectors,
6fc07785d9b892 Yu Kuai           2025-09-10  1223  					      &conf->bio_split);
c9aa889b035fca Vishal Verma      2021-12-21  1224  		wait_barrier(conf, false);
6fc07785d9b892 Yu Kuai           2025-09-10  1225  		if (!bio) {
6fc07785d9b892 Yu Kuai           2025-09-10  1226  			set_bit(R10BIO_Returned, &r10_bio->state);
4cf58d95290973 John Garry        2024-11-11  1227  			goto err_handle;
4cf58d95290973 John Garry        2024-11-11  1228  		}
22f166218f7313 Yu Kuai           2025-09-10  1229  
fc9977dd069e4f NeilBrown         2017-04-05  1230  		r10_bio->master_bio = bio;
fc9977dd069e4f NeilBrown         2017-04-05  1231  		r10_bio->sectors = max_sectors;
fc9977dd069e4f NeilBrown         2017-04-05  1232  	}
96c3fd1f380237 NeilBrown         2011-12-23  1233  	slot = r10_bio->read_slot;
^1da177e4c3f41 Linus Torvalds    2005-04-16  1234  
820455238366a7 Yu Kuai           2023-06-22  1235  	if (io_accounting) {
820455238366a7 Yu Kuai           2023-06-22  1236  		md_account_bio(mddev, &bio);
820455238366a7 Yu Kuai           2023-06-22  1237  		r10_bio->master_bio = bio;
820455238366a7 Yu Kuai           2023-06-22  1238  	}
abfc426d1b2fb2 Christoph Hellwig 2022-02-02  1239  	read_bio = bio_alloc_clone(rdev->bdev, bio, gfp, &mddev->bio_set);
5fa31c49928139 Zheng Qixing      2025-07-02  1240  	read_bio->bi_opf &= ~REQ_NOWAIT;
^1da177e4c3f41 Linus Torvalds    2005-04-16  1241  
^1da177e4c3f41 Linus Torvalds    2005-04-16  1242  	r10_bio->devs[slot].bio = read_bio;
abbf098e6e1e23 NeilBrown         2011-12-23  1243  	r10_bio->devs[slot].rdev = rdev;
^1da177e4c3f41 Linus Torvalds    2005-04-16  1244  
4f024f3797c43c Kent Overstreet   2013-10-11  1245  	read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
f8c9e74ff0832f NeilBrown         2012-05-21  1246  		choose_data_offset(r10_bio, rdev);
^1da177e4c3f41 Linus Torvalds    2005-04-16  1247  	read_bio->bi_end_io = raid10_end_read_request;
8d3ca83dcf9ca3 NeilBrown         2016-11-18  1248  	if (test_bit(FailFast, &rdev->flags) &&
8d3ca83dcf9ca3 NeilBrown         2016-11-18  1249  	    test_bit(R10BIO_FailFast, &r10_bio->state))
8d3ca83dcf9ca3 NeilBrown         2016-11-18  1250  	        read_bio->bi_opf |= MD_FAILFAST;
^1da177e4c3f41 Linus Torvalds    2005-04-16  1251  	read_bio->bi_private = r10_bio;
c396b90e502691 Christoph Hellwig 2024-03-03  1252  	mddev_trace_remap(mddev, read_bio, r10_bio->sector);
ed00aabd5eb9fb Christoph Hellwig 2020-07-01  1253  	submit_bio_noacct(read_bio);
5a7bbad27a4103 Christoph Hellwig 2011-09-12  1254  	return;
4cf58d95290973 John Garry        2024-11-11  1255  err_handle:
4cf58d95290973 John Garry        2024-11-11  1256  	atomic_dec(&rdev->nr_pending);
4cf58d95290973 John Garry        2024-11-11 @1257  	raid_end_bio_io(r10_bio);
^1da177e4c3f41 Linus Torvalds    2005-04-16  1258  }
^1da177e4c3f41 Linus Torvalds    2005-04-16  1259  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
