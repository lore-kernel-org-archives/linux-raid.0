Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BF09C43334
	for <linux-raid@archiver.kernel.org>; Sun,  5 Jun 2022 00:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242455AbiFDXwY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 4 Jun 2022 19:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbiFDXwX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 4 Jun 2022 19:52:23 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B582E0B3
        for <linux-raid@vger.kernel.org>; Sat,  4 Jun 2022 16:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654386740; x=1685922740;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=vRniIPElyclO70nDnYrSEN2/3ZjE7m5ElQkpHDuKGHM=;
  b=l3nlVqV8XI1rJsLIGM3kvQ/f7IWf6znlj/TX2dXflKYvDVFybcEkJzvr
   AmwbMhyLLfnIkaovK0gXv24b/M+aPRg9xqq+rD7q7vZ7Jx7BWXaLEu5ey
   +wGd57tmDcswdHzTXTYAipXlr4N3/q4Cz7Aec4BhxbdGYmLKS8SpPzxq5
   Gvvx+oq0ww/czhXAHwywJm3kKZ24XvPu5PCGNvQ5vZ3YooMo0tu9Thkjn
   0u5W/ZNnOpzvIEBeJnXe3jg8sdouA7YwgJgANkpR5g4NjYeGxl09AtTV4
   YVe2ukolvggatoNklNaZIRevchJ4nnD7cLrnJC129hYQx1DbfSPfVkL4I
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10368"; a="337172667"
X-IronPort-AV: E=Sophos;i="5.91,278,1647327600"; 
   d="scan'208";a="337172667"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2022 16:52:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,278,1647327600"; 
   d="scan'208";a="681701440"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jun 2022 16:52:17 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nxdZ3-000BI7-4L;
        Sat, 04 Jun 2022 23:52:17 +0000
Date:   Sun, 5 Jun 2022 07:51:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     kbuild-all@lists.01.org, linux-raid@vger.kernel.org
Subject: [song-md:test/klp-trampoline 6/6] kernel/bpf/trampoline.c:469:2-3:
 Unneeded semicolon
Message-ID: <202206050734.AsfscvCO-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git test/klp-trampoline
head:   6fbf5243a0d6ac55cae9ed84bb5ef0d49d1c00bc
commit: 6fbf5243a0d6ac55cae9ed84bb5ef0d49d1c00bc [6/6] bpf: trampoline: support FTRACE_OPS_FL_SHARE_IPMODIFY
config: x86_64-randconfig-c002 (https://download.01.org/0day-ci/archive/20220605/202206050734.AsfscvCO-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


cocci warnings: (new ones prefixed by >>)
>> kernel/bpf/trampoline.c:469:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
