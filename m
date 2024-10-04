Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02ECF335A5
	for <linux-raid@vger.kernel.org>; Fri,  4 Oct 2024 21:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728078947; cv=none; b=IDg2M/S6+QKKr8Y6jw8fquYuZlIh6eWWeGc9xfcQG9yjI4iKIsgDNpL0GOZhkcN6i6Br+OmQaDbINVpu+XS43lPFeN998U62khsJchi8npwteVvSFdyKlg2yFX/BxwahJgrsyCVuUoLJHE+2bgsTuT4wOslbYK0Qe3QNIMFLDk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728078947; c=relaxed/simple;
	bh=N+wwXybF45FCFMotJYz3EJLRQUSWIJ8i4mbizFaOtII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cB/4QujiF/uTOAKWNftPyy0BPShc/anAGG4o5ryfjcDiPhRdDNH/SjG6eN5d07mYL5s9aSj+itcncfEjQdH9j+G5QD1d0427F7/4Jm3rk2Nl80kCsF7Rq5Xhe4MISDyeFFJ8l0Ue4efUZUSBfgHGCl9eQi3BYYg3C2CpW7yB4V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1SkFter; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1SkFter"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728078945; x=1759614945;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N+wwXybF45FCFMotJYz3EJLRQUSWIJ8i4mbizFaOtII=;
  b=h1SkFterjturTmbEyGV1ykFPRp3Kr9K99fQqJI8irrTE+jFLMeTwcdKS
   xjf90dw8vhfg2Mu0v85SJEXGr1UsH47IwBVe7nGY9r747Y86gGepI5nYR
   +N5d+X0gRT4y/jQQqe3NREkqaAQHjHrj8skP5KYjZvIXVvyF/V/zGES34
   k5TEpfmKtK/1TXUoMRivaRdRDIUOok7UzmH6LDIeRmQvOiBf2VbIianzK
   6JPoTsAttC3Yq8w9E/BkJRwTpXL4hkAYDwNNIPcOUFvf+Dh9EfRR0OZAN
   xxUhuvcuOa+A1QmVu8Zb2eEbiEhXLSPdWCLjBl+WXbbpAAhasa7DAIy6b
   A==;
X-CSE-ConnectionGUID: TFE8lySURu6mrIq+jbXnmw==
X-CSE-MsgGUID: M3QVtQKoQA6i1cO2/4yAjA==
X-IronPort-AV: E=McAfee;i="6700,10204,11215"; a="27199044"
X-IronPort-AV: E=Sophos;i="6.11,178,1725346800"; 
   d="scan'208";a="27199044"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2024 14:55:44 -0700
X-CSE-ConnectionGUID: 9AAs8KlDTnmUIZULO5ZUVA==
X-CSE-MsgGUID: 4aPnmwn0SeSSGsqcHbD12Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,178,1725346800"; 
   d="scan'208";a="98145796"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 04 Oct 2024 14:55:43 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1swqGz-0002G8-09;
	Fri, 04 Oct 2024 21:55:41 +0000
Date: Sat, 5 Oct 2024 05:55:21 +0800
From: kernel test robot <lkp@intel.com>
To: Paul Luse <paulluselinux@gmail.com>, linux-raid@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, paul.e.luse@intel.com,
	Paul Luse <paulluselinux@gmail.com>
Subject: Re: [PATCH] md: yet another CI email test - do not review
Message-ID: <202410050528.RsgauQz4-lkp@intel.com>
References: <20241003180040.6808-1-paulluselinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241003180040.6808-1-paulluselinux@gmail.com>

Hi Paul,

kernel test robot noticed the following build errors:

[auto build test ERROR on song-md/md-next]
[also build test ERROR on linus/master v6.12-rc1 next-20241004]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paul-Luse/md-yet-another-CI-email-test-do-not-review/20241004-020247
base:   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
patch link:    https://lore.kernel.org/r/20241003180040.6808-1-paulluselinux%40gmail.com
patch subject: [PATCH] md: yet another CI email test - do not review
config: parisc-defconfig (https://download.01.org/0day-ci/archive/20241005/202410050528.RsgauQz4-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241005/202410050528.RsgauQz4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410050528.RsgauQz4-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/md/raid1.c: In function 'check_and_add_serial':
>> drivers/md/raid1.c:68:9: error: 'xxx' undeclared (first use in this function)
      68 |         xxx
         |         ^~~
   drivers/md/raid1.c:68:9: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/md/raid1.c:68:12: error: expected ';' before 'do'
      68 |         xxx
         |            ^
         |            ;


vim +/xxx +68 drivers/md/raid1.c

    54	
    55	#define START(node) ((node)->start)
    56	#define LAST(node) ((node)->last)
    57	INTERVAL_TREE_DEFINE(struct serial_info, node, sector_t, _subtree_last,
    58			     START, LAST, static inline, raid1_rb);
    59	
    60	static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_bio,
    61					struct serial_info *si, int idx)
    62	{
    63		unsigned long flags;
    64		int ret = 0;
    65		sector_t lo = r1_bio->sector;
    66		sector_t hi = lo + r1_bio->sectors;
    67		struct serial_in_rdev *serial = &rdev->serial[idx];
  > 68		xxx
    69		spin_lock_irqsave(&serial->serial_lock, flags);
    70		/* collision happened */
    71		if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
    72			ret = -EBUSY;
    73		else {
    74			si->start = lo;
    75			si->last = hi;
    76			raid1_rb_insert(si, &serial->serial_rb);
    77		}
    78		spin_unlock_irqrestore(&serial->serial_lock, flags);
    79	
    80		return ret;
    81	}
    82	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
