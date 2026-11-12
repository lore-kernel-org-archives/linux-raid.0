Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794511132;
	b=TwAKypZ0odGNQVBSDuQnMQzSpuMt/HSWsmDxEJ9PeS4MFI4pw7TP+k6TMM/FFsO4Se9c
	 OqYbG8LFO/0nugTFZ740ADzMrUiM6apjXYOZ/MwPqb0LJ4oGV96Dm/h6fR4JStKRlhNs8
	 3qBhtKKNsy+734Jd0eYis2VeEifSGaGxM+sCmaH/z143WUrrVVBn6atTWlLghV0wizfjr
	 r4N++rZgr55or5vTxMJjdZs4Wv93u2m7XGt9dhzANq3eJph/7pqr4Tf8GGFDYm21UACmS
	 kmAjDV8Rh80BpUX+an1WE6/P6KnPJB91R/LKrweDX0+RCFgcMboMl5hn1iv+NfXeI1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794511132;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=n+k8QuVBsbcS7lt+1FuYH5jEsin9o5MtevrgXnCVhMY=;
	b=3/Mo7xr+bipkRTYGzLS1/fux5yl7u4WMeXN0dXqvZwWADFpsjYLE9uK7jqOps+qQpQJM
	 1wUqdGXvOYdVWY3Avm046MN25KsYajUG4bj/ywOxxe3ExEikgzgZvDQWBBJAkkHj75wNy
	 2mBsf8yJ6lrc491F9IsmOvgyNbwPiygHNp7lHSx8B+bgcDtcMtdV5Fd0jZkhQWcHPFo3S
	 IufyxbmP2VYLyb6yHOfbxW2DGou1viQ7TMl7XOwoJUbR1ewXABqPH4g3uTqMObYaTdRfc
	 561ONDYA8HsfSpG5IM7htDZugOORvWreeUJwPwHWBR9f0YxmdLqSIydCLBOHN/dggWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=khMs140n;
	arc=none smtp.remote-ip=198.175.65.15
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B92E606A31C;
	Thu, 12 Nov 2026 19:18:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B92E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=khMs140n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794511132; x=1826047132;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YCnToFH2jDdO0u9ni7OYkpQv2fHW7DDUyxMYmDB7nm0=;
  b=khMs140ny2UFiIARxxDsE4KY5orz5mMEvctCEoqiF70aaDX87/EM8fCN
   FhBh5wRUQCGktHzjJwHZBQ+/UJIJTlVLvE4CUUU82hCfRRCKqU1rmqs2l
   52RwkEvF0+rF6li8g60DT9ZbBvkqVX4TEGRJV4YaTnuZYYvtAFB6Vb4d9
   Zp5seR++ixH9+0llnvm7FSn++RV7Y4LI/XjsoqjWkrCoR2aOmdhnv3rYz
   kYbhUMkknLylYiM/c8oRS7IoeVrMAfOE/lpMAlWKu5Hu3PoU6bH7jYETp
   PdRKNctKEYwf2ljoPrCBbBS/+4Vmu1DP1n1b86aTIv4L5fnlGxlMhZ86J
   Q==;
X-CSE-ConnectionGUID: 8I91yA8dTTSNEtV+hZO01Q==
X-CSE-MsgGUID: QRaoLyknRhG9rVM6fs0U1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11964"; a="3312464"
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="3312464"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 11:18:51 -0800
X-CSE-ConnectionGUID: J349Wq4+Q1CKLjGTR7p67g==
X-CSE-MsgGUID: RpoPHp4nTfyLsRhJrrSQJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,210,1787036400"; 
   d="scan'208";a="9075973"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 12 Nov 2026 11:18:48 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRaJp-000000011xt-0DgA;
	Thu, 12 Nov 2026 19:18:45 +0000
Date: Fri, 13 Nov 2026 03:17:53 +0800
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
Message-ID: <202611130354.oOiDWpa1-lkp@intel.com>
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
config: arm-randconfig-1002-20261112 (https://download.01.org/0day-ci/archive/20261113/202611130354.oOiDWpa1-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 1b1fed44d3dcca649a9877915d57c3357a98124e)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261113/202611130354.oOiDWpa1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611130354.oOiDWpa1-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from block/blk-map.c:12:
>> block/blk.h:680:10: warning: releasing mutex 'disk->queue->limits_lock' that was not held [-Wthread-safety-analysis]
     680 |                 return queue_limits_commit_update(disk->queue, lim);
         |                        ^
   block/blk.h:681:9: warning: releasing mutex 'disk->queue->limits_lock' that was not held [-Wthread-safety-analysis]
     681 |         return queue_limits_commit_update_frozen(disk->queue, lim);
         |                ^
   2 warnings generated.
--
   In file included from block/blk-sysfs.c:14:
>> block/blk.h:680:10: warning: releasing mutex 'disk->queue->limits_lock' that was not held [-Wthread-safety-analysis]
     680 |                 return queue_limits_commit_update(disk->queue, lim);
         |                        ^
   block/blk.h:681:9: warning: releasing mutex 'disk->queue->limits_lock' that was not held [-Wthread-safety-analysis]
     681 |         return queue_limits_commit_update_frozen(disk->queue, lim);
         |                ^
>> block/blk-sysfs.c:909:3: warning: mutex '(kobj - #undefined)->queue->limits_lock' is not held on every path through here [-Wthread-safety-analysis]
     909 |                 blk_disk_resume(disk);
         |                 ^
   block/blk-sysfs.c:897:9: note: mutex acquired here
     897 |                 lim = queue_limits_start_update(q);
         |                       ^
   3 warnings generated.


vim +680 block/blk.h

   675	
   676	static inline int blk_disk_commit_limits(struct gendisk *disk,
   677						 struct queue_limits *lim)
   678	{
   679		if (disk->fops->suspend)
 > 680			return queue_limits_commit_update(disk->queue, lim);
   681		return queue_limits_commit_update_frozen(disk->queue, lim);
   682	}
   683	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
