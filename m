Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1780E13D882;
	Thu, 31 Oct 2024 04:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730350500; cv=none; b=anWrQ/uq53Mz8ZE/fAZIHHAipGqZc8rMNHKTdeQAZcr+mQVurUBIrVMfJS2yYOJ5gih01ISAlnVMoBoSc/qXRN2i/3VTaQeFMQc09j810Rcec5CyPdv5q+bTD34V4FcuWmOwz3vJpPS3ZALY8vJ/YjZAvMuxC6FfnThz7zuf95Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730350500; c=relaxed/simple;
	bh=k2EJmP2CuBz2UPbonz6DNMdjH6Oi+YKfrabtGtG0sjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ExKUF25CCSgKammN9/Dv+NY5jxLQdagFB3AMktVwnK3tbCv0xggsGlEXZr4M1PpihnDHt4zd2SA0roumCLIcUQjU1mTyKQaBpWmhd2nV1A/yyQMCTkbWcke4fkDRuerKh0Qn8FHvFesRGZ8FBxTw8mt71cjftmjsTc1abV4y8Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kxblf9Ye; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kxblf9Ye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730350498; x=1761886498;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k2EJmP2CuBz2UPbonz6DNMdjH6Oi+YKfrabtGtG0sjk=;
  b=Kxblf9YeFMKQB9APDjHyITu1OMh44UR6PgX0xr9Dffy7O46yrk8QpriP
   nrVajgCqnqP/EbUn/YKLvdOqI5KCpOxYJiYG6BqY6235GNfr9LhYZ0DqU
   tHkBvfDjEQQ8wrSUpmm0DKONYa29c7sVBe7IKkiEzzez4rjrgVA2vVsJx
   rCsM/red/WhPtceaiZQKMtyumDUbbXb3M2pYvbaqDTsn3manraRPTd8kk
   1V2842bgIYAH39zZvpyFbJb10pbp334/BGFE8ghj2WhNHBoslxfDQcYnV
   1LX3BfwbO/oP5OBk5KUVHu9vzOsX44fJO+lAoruDTOJgJOlrS8Cy31RVa
   Q==;
X-CSE-ConnectionGUID: 9mpQL2zHQDGkWkwqbqp9Og==
X-CSE-MsgGUID: v6Y/27vXQpil1sfhIxvzsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="30285868"
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="30285868"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 21:54:57 -0700
X-CSE-ConnectionGUID: UUM1N/cCQZOfkYnFWiY4Qw==
X-CSE-MsgGUID: iGGApLbIT0KUw4YadyfFHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="82435844"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 30 Oct 2024 21:54:54 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t6NCu-000ffw-16;
	Thu, 31 Oct 2024 04:54:52 +0000
Date: Thu, 31 Oct 2024 12:53:57 +0800
From: kernel test robot <lkp@intel.com>
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
	yukuai3@huawei.com, hch@lst.de
Cc: oe-kbuild-all@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	martin.petersen@oracle.com, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v2 5/5] md/raid10: Atomic write support
Message-ID: <202410311223.WHxXOaS2-lkp@intel.com>
References: <20241030094912.3960234-6-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030094912.3960234-6-john.g.garry@oracle.com>

Hi John,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe-block/for-next]
[also build test ERROR on linus/master v6.12-rc5 next-20241030]
[cannot apply to song-md/md-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/John-Garry/block-Add-extra-checks-in-blk_validate_atomic_write_limits/20241030-175428
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next
patch link:    https://lore.kernel.org/r/20241030094912.3960234-6-john.g.garry%40oracle.com
patch subject: [PATCH v2 5/5] md/raid10: Atomic write support
config: x86_64-rhel-8.3 (https://download.01.org/0day-ci/archive/20241031/202410311223.WHxXOaS2-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241031/202410311223.WHxXOaS2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410311223.WHxXOaS2-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/md/raid10.c: In function 'raid10_write_request':
>> drivers/md/raid10.c:1448:33: error: 'error' undeclared (first use in this function); did you mean 'md_error'?
    1448 |                                 error = -EFAULT;
         |                                 ^~~~~
         |                                 md_error
   drivers/md/raid10.c:1448:33: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/md/raid10.c:1449:33: error: label 'err_handle' used but not defined
    1449 |                                 goto err_handle;
         |                                 ^~~~


vim +1448 drivers/md/raid10.c

  1345	
  1346	static void raid10_write_request(struct mddev *mddev, struct bio *bio,
  1347					 struct r10bio *r10_bio)
  1348	{
  1349		struct r10conf *conf = mddev->private;
  1350		int i;
  1351		sector_t sectors;
  1352		int max_sectors;
  1353	
  1354		if ((mddev_is_clustered(mddev) &&
  1355		     md_cluster_ops->area_resyncing(mddev, WRITE,
  1356						    bio->bi_iter.bi_sector,
  1357						    bio_end_sector(bio)))) {
  1358			DEFINE_WAIT(w);
  1359			/* Bail out if REQ_NOWAIT is set for the bio */
  1360			if (bio->bi_opf & REQ_NOWAIT) {
  1361				bio_wouldblock_error(bio);
  1362				return;
  1363			}
  1364			for (;;) {
  1365				prepare_to_wait(&conf->wait_barrier,
  1366						&w, TASK_IDLE);
  1367				if (!md_cluster_ops->area_resyncing(mddev, WRITE,
  1368					 bio->bi_iter.bi_sector, bio_end_sector(bio)))
  1369					break;
  1370				schedule();
  1371			}
  1372			finish_wait(&conf->wait_barrier, &w);
  1373		}
  1374	
  1375		sectors = r10_bio->sectors;
  1376		if (!regular_request_wait(mddev, conf, bio, sectors))
  1377			return;
  1378		if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
  1379		    (mddev->reshape_backwards
  1380		     ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
  1381			bio->bi_iter.bi_sector + sectors > conf->reshape_progress)
  1382		     : (bio->bi_iter.bi_sector + sectors > conf->reshape_safe &&
  1383			bio->bi_iter.bi_sector < conf->reshape_progress))) {
  1384			/* Need to update reshape_position in metadata */
  1385			mddev->reshape_position = conf->reshape_progress;
  1386			set_mask_bits(&mddev->sb_flags, 0,
  1387				      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
  1388			md_wakeup_thread(mddev->thread);
  1389			if (bio->bi_opf & REQ_NOWAIT) {
  1390				allow_barrier(conf);
  1391				bio_wouldblock_error(bio);
  1392				return;
  1393			}
  1394			mddev_add_trace_msg(conf->mddev,
  1395				"raid10 wait reshape metadata");
  1396			wait_event(mddev->sb_wait,
  1397				   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
  1398	
  1399			conf->reshape_safe = mddev->reshape_position;
  1400		}
  1401	
  1402		/* first select target devices under rcu_lock and
  1403		 * inc refcount on their rdev.  Record them by setting
  1404		 * bios[x] to bio
  1405		 * If there are known/acknowledged bad blocks on any device
  1406		 * on which we have seen a write error, we want to avoid
  1407		 * writing to those blocks.  This potentially requires several
  1408		 * writes to write around the bad blocks.  Each set of writes
  1409		 * gets its own r10_bio with a set of bios attached.
  1410		 */
  1411	
  1412		r10_bio->read_slot = -1; /* make sure repl_bio gets freed */
  1413		raid10_find_phys(conf, r10_bio);
  1414	
  1415		wait_blocked_dev(mddev, r10_bio);
  1416	
  1417		max_sectors = r10_bio->sectors;
  1418	
  1419		for (i = 0;  i < conf->copies; i++) {
  1420			int d = r10_bio->devs[i].devnum;
  1421			struct md_rdev *rdev, *rrdev;
  1422	
  1423			rdev = conf->mirrors[d].rdev;
  1424			rrdev = conf->mirrors[d].replacement;
  1425			if (rdev && (test_bit(Faulty, &rdev->flags)))
  1426				rdev = NULL;
  1427			if (rrdev && (test_bit(Faulty, &rrdev->flags)))
  1428				rrdev = NULL;
  1429	
  1430			r10_bio->devs[i].bio = NULL;
  1431			r10_bio->devs[i].repl_bio = NULL;
  1432	
  1433			if (!rdev && !rrdev) {
  1434				set_bit(R10BIO_Degraded, &r10_bio->state);
  1435				continue;
  1436			}
  1437			if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
  1438				sector_t first_bad;
  1439				sector_t dev_sector = r10_bio->devs[i].addr;
  1440				int bad_sectors;
  1441				int is_bad;
  1442	
  1443				is_bad = is_badblock(rdev, dev_sector, max_sectors,
  1444						     &first_bad, &bad_sectors);
  1445	
  1446				if (is_bad && bio->bi_opf & REQ_ATOMIC) {
  1447					/* We just cannot atomically write this ... */
> 1448					error = -EFAULT;
> 1449					goto err_handle;
  1450				}
  1451	
  1452				if (is_bad && first_bad <= dev_sector) {
  1453					/* Cannot write here at all */
  1454					bad_sectors -= (dev_sector - first_bad);
  1455					if (bad_sectors < max_sectors)
  1456						/* Mustn't write more than bad_sectors
  1457						 * to other devices yet
  1458						 */
  1459						max_sectors = bad_sectors;
  1460					/* We don't set R10BIO_Degraded as that
  1461					 * only applies if the disk is missing,
  1462					 * so it might be re-added, and we want to
  1463					 * know to recover this chunk.
  1464					 * In this case the device is here, and the
  1465					 * fact that this chunk is not in-sync is
  1466					 * recorded in the bad block log.
  1467					 */
  1468					continue;
  1469				}
  1470				if (is_bad) {
  1471					int good_sectors = first_bad - dev_sector;
  1472					if (good_sectors < max_sectors)
  1473						max_sectors = good_sectors;
  1474				}
  1475			}
  1476			if (rdev) {
  1477				r10_bio->devs[i].bio = bio;
  1478				atomic_inc(&rdev->nr_pending);
  1479			}
  1480			if (rrdev) {
  1481				r10_bio->devs[i].repl_bio = bio;
  1482				atomic_inc(&rrdev->nr_pending);
  1483			}
  1484		}
  1485	
  1486		if (max_sectors < r10_bio->sectors)
  1487			r10_bio->sectors = max_sectors;
  1488	
  1489		if (r10_bio->sectors < bio_sectors(bio)) {
  1490			struct bio *split = bio_split(bio, r10_bio->sectors,
  1491						      GFP_NOIO, &conf->bio_split);
  1492			bio_chain(split, bio);
  1493			allow_barrier(conf);
  1494			submit_bio_noacct(bio);
  1495			wait_barrier(conf, false);
  1496			bio = split;
  1497			r10_bio->master_bio = bio;
  1498		}
  1499	
  1500		md_account_bio(mddev, &bio);
  1501		r10_bio->master_bio = bio;
  1502		atomic_set(&r10_bio->remaining, 1);
  1503		mddev->bitmap_ops->startwrite(mddev, r10_bio->sector, r10_bio->sectors,
  1504					      false);
  1505	
  1506		for (i = 0; i < conf->copies; i++) {
  1507			if (r10_bio->devs[i].bio)
  1508				raid10_write_one_disk(mddev, r10_bio, bio, false, i);
  1509			if (r10_bio->devs[i].repl_bio)
  1510				raid10_write_one_disk(mddev, r10_bio, bio, true, i);
  1511		}
  1512		one_write_done(r10_bio);
  1513	}
  1514	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
