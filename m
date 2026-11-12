Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794514195;
	b=09H58MdK6cZ39oX649mKGU46kp3+qFiNLyaVxLXrhvJ2a/qjz8QgYORFzLztttuji8AY
	 bpEcWlgELQGqqiHfpaPSHRM+6KZbSuyc8+jTKU6Ok/lVsqh8TJT9RMhIQkiLbqBzGdOaW
	 G0kf9rNcicm1PYIEXwMeZSKjwvqMYHXZGtfEl94WkbvX9UWZxdrAc+NRRyowsrvIKUrlC
	 XCYB82PQZG1BMEoK96fmhhBDbBRmBFMAVZsSIz7mOJQx1AI4pJL3j2/pAsq6BpokTWz2c
	 5AbSDrujeKHJMy+EosgNsBROoEgE/dpRYRu0QriG2/nb5rYoKZiXDdXOtR4qb8VkLvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794514195;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=V0x5gM9R4RZz6VFzF3hAmKn3AxcaWq4rZbeIDdG+M3U=;
	b=ADY2HGt3P8yjNzGWJ0pGV2Kf6wZxsC+kHZZZ8UoE4FliQI3fx/QqSnvqBJo4n1/AjQt8
	 ELGod5VSg9N0bz+sFmqS2hRmMjOtTzcfpr9qB0l/oCrIEjZkE9MojBfslalH+3+WrgONJ
	 ihgO0STg4h6QOIo5poBTNdUir9FdEzlLUuhUMfHbgqFWa8idL0O3N+MpYk0KhfbMNu6LA
	 wj8AtN9zMfss7GNzw3n+jyMM4CTtk7ZDZMOKQEGOzTswbvfEsPY1/vDHWFdftJHHSapFE
	 xZo3a9hQEfL6ajRaR6TQZtqNSw9NJOG5f0w21SCUXOc9vn654xsmI0PWoW9d5IiMItw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=h5jvJa1x;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC72606A321;
	Thu, 12 Nov 2026 20:09:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAC72606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=h5jvJa1x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794514195; x=1826050195;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=w/pUbqky+3MybazUz1OqukkycGYf0ZUmSI+0cWXg05s=;
  b=h5jvJa1xJfvACZK1CvBCJjOa7P7MF+RVFGcRMHbPWFmpHMHfUsERA825
   36R/CJx/INB4ju3+KkKSz/cYoWNR+8w2vFHg/WjcL8OuFCVrFbdrXLKtr
   LobbnkRRlC7+st4Fv0t7jtsj7ppaW3c5iRAir635w/UD7GfaJi87LcjVc
   NaqTJ5cmFuHOAth8XmqSYefvHiwtPDSSTWVUk6tvV8HEqmzff323X0Xb5
   8p+TgV8oI1j31mIqEZ+tP39xAMjO1RrqfrL2HbA8D1u+aurXkG+MG2iOt
   LPt/wunej5/XaX5ikQoRqMEx8kMsBE76qplUSV+OlbRmwitlMrAAjbwVg
   g==;
X-CSE-ConnectionGUID: vMwElf7vRlyb8G6CGVUnbw==
X-CSE-MsgGUID: WKTwK0LXQAirJ0jz6XLrHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3315830"
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="3315830"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:09:55 -0800
X-CSE-ConnectionGUID: z7vCoFA6RBGx7KvCOw8FvA==
X-CSE-MsgGUID: rFSjSnl3T6O9oOYID5LUyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="9074007"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 12 Nov 2026 12:09:51 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRb7E-000000011zx-3K1z;
	Thu, 12 Nov 2026 20:09:48 +0000
Date: Fri, 13 Nov 2026 04:09:18 +0800
From: kernel test robot <lkp@intel.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, Yu Kuai <yukuai@fygo.io>,
	Song Liu <song@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] block: suspend bio based disks around queue
 limits updates
Message-ID: <202611130320.U910h0Q4-lkp@intel.com>
References: <20261112134700.372702-2-jinpu.wang@cloud.ionos.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112134700.372702-2-jinpu.wang@cloud.ionos.com>

Hi Jack,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4]

url:    https://github.com/intel-lab-lkp/linux/commits/Jack-Wang/block-suspend-bio-based-disks-around-queue-limits-updates/20261112-144659
base:   6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
patch link:    https://lore.kernel.org/r/20261112134700.372702-2-jinpu.wang%40cloud.ionos.com
patch subject: [PATCH v4 1/2] block: suspend bio based disks around queue limits updates
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20261113/202611130320.U910h0Q4-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 1b1fed44d3dcca649a9877915d57c3357a98124e)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261113/202611130320.U910h0Q4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611130320.U910h0Q4-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from block/blk-integrity.c:18:
   block/blk.h:680:10: warning: releasing mutex 'disk->queue->limits_lock' that was not held [-Wthread-safety-analysis]
     680 |                 return queue_limits_commit_update(disk->queue, lim);
         |                        ^
   block/blk.h:681:9: warning: releasing mutex 'disk->queue->limits_lock' that was not held [-Wthread-safety-analysis]
     681 |         return queue_limits_commit_update_frozen(disk->queue, lim);
         |                ^
>> block/blk-integrity.c:255:1: warning: mutex '(dev - #undefined)->bd_disk->queue->limits_lock' is not held on every path through here [-Wthread-safety-analysis]
     255 | }
         | ^
   block/blk-integrity.c:244:8: note: mutex acquired here
     244 |         lim = queue_limits_start_update(q);
         |               ^
   3 warnings generated.


vim +255 block/blk-integrity.c

e9f5f44ad372533 Christoph Hellwig 2024-06-13  225  
b83bd486b43d2b7 Kanchan Joshi     2024-06-17  226  static ssize_t flag_store(struct device *dev, const char *page, size_t count,
b83bd486b43d2b7 Kanchan Joshi     2024-06-17  227  		unsigned char flag)
1366251a794b149 Christoph Hellwig 2024-06-13  228  {
9a7e3243fd42730 Jack Wang         2026-11-12  229  	struct gendisk *disk = dev_to_disk(dev);
9a7e3243fd42730 Jack Wang         2026-11-12  230  	struct request_queue *q = disk->queue;
c6e56cf6b2e79a4 Christoph Hellwig 2024-06-13  231  	struct queue_limits lim;
1d59857ed2ec4d5 Christoph Hellwig 2024-06-13  232  	unsigned long val;
1d59857ed2ec4d5 Christoph Hellwig 2024-06-13  233  	int err;
1d59857ed2ec4d5 Christoph Hellwig 2024-06-13  234  
1d59857ed2ec4d5 Christoph Hellwig 2024-06-13  235  	err = kstrtoul(page, 10, &val);
1d59857ed2ec4d5 Christoph Hellwig 2024-06-13  236  	if (err)
1d59857ed2ec4d5 Christoph Hellwig 2024-06-13  237  		return err;
1366251a794b149 Christoph Hellwig 2024-06-13  238  
9a7e3243fd42730 Jack Wang         2026-11-12  239  	err = blk_disk_suspend(disk);
9a7e3243fd42730 Jack Wang         2026-11-12  240  	if (err)
9a7e3243fd42730 Jack Wang         2026-11-12  241  		return err;
9a7e3243fd42730 Jack Wang         2026-11-12  242  
c6e56cf6b2e79a4 Christoph Hellwig 2024-06-13  243  	/* note that the flags are inverted vs the values in the sysfs files */
c6e56cf6b2e79a4 Christoph Hellwig 2024-06-13  244  	lim = queue_limits_start_update(q);
1366251a794b149 Christoph Hellwig 2024-06-13  245  	if (val)
c6e56cf6b2e79a4 Christoph Hellwig 2024-06-13  246  		lim.integrity.flags &= ~flag;
9f4aa46f2a74010 Christoph Hellwig 2024-06-13  247  	else
c6e56cf6b2e79a4 Christoph Hellwig 2024-06-13  248  		lim.integrity.flags |= flag;
c6e56cf6b2e79a4 Christoph Hellwig 2024-06-13  249  
9a7e3243fd42730 Jack Wang         2026-11-12  250  	err = blk_disk_commit_limits(disk, &lim);
9a7e3243fd42730 Jack Wang         2026-11-12  251  	blk_disk_resume(disk);
c6e56cf6b2e79a4 Christoph Hellwig 2024-06-13  252  	if (err)
c6e56cf6b2e79a4 Christoph Hellwig 2024-06-13  253  		return err;
1366251a794b149 Christoph Hellwig 2024-06-13  254  	return count;
1366251a794b149 Christoph Hellwig 2024-06-13 @255  }
1366251a794b149 Christoph Hellwig 2024-06-13  256  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
