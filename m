Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039AB1DB551;
	Thu, 27 Nov 2025 00:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764204695; cv=none; b=fjhZc3Qrwe+5cGi24eRuXf04abRaA+unE2MgDV76kgVhkasJxma7D1R9dxb505hVOqFyE+C76KmMemxRf5JP6YK78ESVOfNRB9flHOF+ROKT8Q2V6r2TvSdUfdOcQz5h5ZarmPVjZHgtQ7RmKYc1fDvbAsjTul2JivFnm8/ZuKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764204695; c=relaxed/simple;
	bh=e+vl5giX9WVA9vgapKAivhfKtOevJhbFmGu/8riibKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FfS1vGfNFZ9bHArs0kX5Cx5m/UGayKv+ima1ndYbAFojvNQht2x6I9bbw5OgKhLJv/bMDZ50hSw2KN6OeVJXvkeP31Uy9+IHeH3EfoQ7WizVsvAe937jWOEXUyFqtJi3JjeiFZXLb32WkuGceYZYExkJ/iC6UlstH+xE6bMHkAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ce5KseXj; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ce5KseXj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764204694; x=1795740694;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e+vl5giX9WVA9vgapKAivhfKtOevJhbFmGu/8riibKc=;
  b=Ce5KseXjRI1HgW8cPOjqXNpHGi3VVk1GtLiIahCUxAyosJtWZYCD9Sf3
   tZAiO5ipbBo8vg70QNHICzdcqUa6EREt0o2UNdGHtZT8hofHAmcQVXwCF
   1KmtKrOgaDC1GVy0PYDZxuRiwMfJaC+3KP4eHgJlxQaBtCxrRZ4EUZNzB
   ifiRtpoavI009RAu+Ag0ePl8H0sHW3lnzkoj02FLy8Dl1XRa7/59HxQxl
   3YddxPT1CQ2j1NUkLMsNr39nHV+XG/p00QLkjwaIlHrbeUxNqSlkHqlMB
   rXdKBnVq1M09A+PZXdB7eo75qimqhv+R6hkBBpx/BAHnE01UH4qffj58a
   A==;
X-CSE-ConnectionGUID: JukonjAnT5OnbUL83gnJ9Q==
X-CSE-MsgGUID: VNNbtLTASGCEe4FihhJu/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="65959556"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="65959556"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 16:51:34 -0800
X-CSE-ConnectionGUID: i3k8xmh1TRS510ZLWSJr8A==
X-CSE-MsgGUID: jztcg/nLSZmuLhooWNLIcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="197420131"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 26 Nov 2025 16:51:31 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vOQEL-000000003WL-2Hov;
	Thu, 27 Nov 2025 00:51:29 +0000
Date: Thu, 27 Nov 2025 08:51:09 +0800
From: kernel test robot <lkp@intel.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, linux-raid@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	filippo@debian.org, colyli@fnnas.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 06/11] md: support to align bio to limits
Message-ID: <202511270809.hl08JR8y-lkp@intel.com>
References: <20251124063203.1692144-7-yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124063203.1692144-7-yukuai@fnnas.com>

Hi Yu,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20251121]
[also build test ERROR on v6.18-rc7]
[cannot apply to linus/master song-md/md-next v6.18-rc7 v6.18-rc6 v6.18-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-merge-mddev-has_superblock-into-mddev_flags/20251124-143826
base:   next-20251121
patch link:    https://lore.kernel.org/r/20251124063203.1692144-7-yukuai%40fnnas.com
patch subject: [PATCH v2 06/11] md: support to align bio to limits
config: sparc-randconfig-002-20251127 (https://download.01.org/0day-ci/archive/20251127/202511270809.hl08JR8y-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251127/202511270809.hl08JR8y-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511270809.hl08JR8y-lkp@intel.com/

All errors (new ones prefixed by >>):

   sparc-linux-ld: drivers/md/md.o: in function `md_submit_bio':
>> md.c:(.text+0x85d4): undefined reference to `__umoddi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
