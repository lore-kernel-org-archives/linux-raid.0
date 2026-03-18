Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F372C329E46;
	Wed, 18 Mar 2026 11:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773833100; cv=none; b=mG+5DnDmh9SfA1JEzzxzTR+WE0XjG7EllzZmA6RU47svu16X0205dUDTUCtVbzeohAhP6Rz+rNIgoVD+Hg3VOQPnr29aHoYrUomDXEmbqP9OzZP//Rk16vO/QBWLO1h4AeYwsNg+uWrqDohLupAKc5fj4HUyRufM6zkI9pNfb5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773833100; c=relaxed/simple;
	bh=h1VUC5nIknOJQz5j8kp1F6tG58vDtYbfl897Py5tPfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C/6vKUkAJTZggfanegKcMfGbBo9M/P4pelTaWIxFNsuYZzNtfLBDKw20Cga+4bPbyivVUBchoKjMD1tYWqo8JaTSV/dP+CmnCqY5gSCewFHf+SIU1vd18SNFyqBXDYl0bqLU1a2dbWSdAEoPaizEHjkFYAGI+2xVUPb382wsa/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AQ8bsUYL; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AQ8bsUYL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773833096; x=1805369096;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h1VUC5nIknOJQz5j8kp1F6tG58vDtYbfl897Py5tPfc=;
  b=AQ8bsUYL15ogeIhH98hVflQ/EJPov7ZMwb0X1MNvaUcmhxlmSUv39dGz
   ba4q2XgYD77FJrXG7D1xtpbXZ/gUPWBlBjRFq9PgutEd3JAJWEGMJn8Y+
   hd2W17CZIqioUFkFBIeYPrxLWCXSlFCPsV2zlWhWdv2RcJM7Wz/ILo4C2
   P3magsaBkbcFoKGGfgGMCJ7eKZNJqKec5qo2JtabSKvyAbIaz9K67ogOO
   MCv1gtfdvuo6iXrrJNaA78/TOrlzHEz3MBHzwKodo5vQyLEstfs3HP7Y0
   5QUYkbTNsnUj80zZbNaMiW9yRYLWGxhTR2e7cMBFHafylMzWSBCuvozem
   Q==;
X-CSE-ConnectionGUID: 8DTxfmmjQ+iqO4uAlj2ABQ==
X-CSE-MsgGUID: oS3AiWpCTKSoRWrN9stY2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="92453185"
X-IronPort-AV: E=Sophos;i="6.23,127,1770624000"; 
   d="scan'208";a="92453185"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 04:24:55 -0700
X-CSE-ConnectionGUID: Rn7cnvnyR7qMlKBp6lLffQ==
X-CSE-MsgGUID: IJuzDVBCQiWKgnx6YSyKWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,127,1770624000"; 
   d="scan'208";a="222654933"
Received: from lkp-server01.sh.intel.com (HELO 63737dd503cb) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 18 Mar 2026 04:24:53 -0700
Received: from kbuild by 63737dd503cb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2p17-000000002qH-47M2;
	Wed, 18 Mar 2026 11:24:49 +0000
Date: Wed, 18 Mar 2026 19:24:47 +0800
From: kernel test robot <lkp@intel.com>
To: Demian Shulhan <demyansh@gmail.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, Demian Shulhan <demyansh@gmail.com>
Subject: Re: [PATCH] raid6: arm64: add SVE optimized implementation for
 syndrome generation
Message-ID: <202603181940.cFwYmYoi-lkp@intel.com>
References: <20260317111706.2756977-1-demyansh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317111706.2756977-1-demyansh@gmail.com>

Hi Demian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on linus/master v7.0-rc4 next-20260317]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Demian-Shulhan/raid6-arm64-add-SVE-optimized-implementation-for-syndrome-generation/20260317-224300
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260317111706.2756977-1-demyansh%40gmail.com
patch subject: [PATCH] raid6: arm64: add SVE optimized implementation for syndrome generation
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20260318/202603181940.cFwYmYoi-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260318/202603181940.cFwYmYoi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603181940.cFwYmYoi-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/raid6/sve.c:70:34: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
      70 |                 : [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
         |                                                ^
   lib/raid6/sve.c:34:22: note: use constraint modifier "w"
      34 |                 "ldr x6, [%[dptr], %[z0], lsl #3]\n"
         |                                    ^~~~~
         |                                    %w[z0]
   lib/raid6/sve.c:151:34: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
     151 |                 : [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
         |                                                ^
   lib/raid6/sve.c:96:22: note: use constraint modifier "w"
      96 |                 "ldr x6, [%[dptr], %[z0], lsl #3]\n"
         |                                    ^~~~~
         |                                    %w[z0]
   lib/raid6/sve.c:229:34: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
     229 |                 : [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
         |                                                ^
   lib/raid6/sve.c:176:22: note: use constraint modifier "w"
     176 |                 "ldr x6, [%[dptr], %[z0], lsl #3]\n"
         |                                    ^~~~~
         |                                    %w[z0]
   lib/raid6/sve.c:340:34: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
     340 |                 : [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
         |                                                ^
   lib/raid6/sve.c:256:22: note: use constraint modifier "w"
     256 |                 "ldr x6, [%[dptr], %[z0], lsl #3]\n"
         |                                    ^~~~~
         |                                    %w[z0]
   lib/raid6/sve.c:455:34: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
     455 |                 : [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
         |                                                ^
   lib/raid6/sve.c:366:22: note: use constraint modifier "w"
     366 |                 "ldr x6, [%[dptr], %[z0], lsl #3]\n"
         |                                    ^~~~~
         |                                    %w[z0]
   lib/raid6/sve.c:634:34: warning: value size does not match register size specified by the constraint and modifier [-Wasm-operand-widths]
     634 |                 : [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
         |                                                ^
   lib/raid6/sve.c:484:22: note: use constraint modifier "w"
     484 |                 "ldr x6, [%[dptr], %[z0], lsl #3]\n"
         |                                    ^~~~~
         |                                    %w[z0]
   6 warnings generated.


vim +70 lib/raid6/sve.c

    15	
    16	static void raid6_sve1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
    17	{
    18		u8 **dptr = (u8 **)ptrs;
    19		u8 *p, *q;
    20		int z0 = disks - 3;
    21	
    22		p = dptr[z0 + 1];
    23		q = dptr[z0 + 2];
    24	
    25		asm volatile(
    26			".arch armv8.2-a+sve\n"
    27			"ptrue p0.b\n"
    28			"cntb x3\n"
    29			"mov w4, #0x1d\n"
    30			"dup z4.b, w4\n"
    31			"mov x5, #0\n"
    32	
    33			"0:\n"
    34			"ldr x6, [%[dptr], %[z0], lsl #3]\n"
    35			"ld1b z0.b, p0/z, [x6, x5]\n"
    36			"mov z1.d, z0.d\n"
    37	
    38			"mov w7, %w[z0]\n"
    39			"sub w7, w7, #1\n"
    40	
    41			"1:\n"
    42			"cmp w7, #0\n"
    43			"blt 2f\n"
    44	
    45			"mov z3.d, z1.d\n"
    46			"asr z3.b, p0/m, z3.b, #7\n"
    47			"lsl z1.b, p0/m, z1.b, #1\n"
    48	
    49			"and z3.d, z3.d, z4.d\n"
    50			"eor z1.d, z1.d, z3.d\n"
    51	
    52			"sxtw x8, w7\n"
    53			"ldr x6, [%[dptr], x8, lsl #3]\n"
    54			"ld1b z2.b, p0/z, [x6, x5]\n"
    55	
    56			"eor z1.d, z1.d, z2.d\n"
    57			"eor z0.d, z0.d, z2.d\n"
    58	
    59			"sub w7, w7, #1\n"
    60			"b 1b\n"
    61			"2:\n"
    62	
    63			"st1b z0.b, p0, [%[p], x5]\n"
    64			"st1b z1.b, p0, [%[q], x5]\n"
    65	
    66			"add x5, x5, x3\n"
    67			"cmp x5, %[bytes]\n"
    68			"blt 0b\n"
    69			:
  > 70			: [dptr] "r" (dptr), [z0] "r" (z0), [bytes] "r" (bytes),
    71			  [p] "r" (p), [q] "r" (q)
    72			: "memory", "p0", "x3", "x4", "x5", "x6", "x7", "x8",
    73			  "z0", "z1", "z2", "z3", "z4"
    74		);
    75	}
    76	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
