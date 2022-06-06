Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE8BC43334
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 23:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbiFFXxh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 19:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbiFFXxg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 19:53:36 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A36BBA566
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 16:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654559615; x=1686095615;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Pn9gJGaKelF3S6kXLuvZQb+xN39UpGWw6CBRvZTPKUw=;
  b=ZGcFb+bUbHp6Hrs030u1FLlopACNXkD4pbTpiMv6gN6tQ5uaQYbox2NH
   FV8eFMZdqQMQlskW3QZXCZirgkp4xYiRKOFXPk9yg7MwvRsqYsSlI60Dd
   lvoZmpSD2udXHW8JFQAtYbqqx+KuFe/oZp3DL8qMJH5JBZLWboaxyZ4Bi
   9eR1dCUr5wr98hLnfs3QwmXYXD7MvPWuVsmDmEltKS8BUbk+34HTg38ZD
   sKv8I6r2MHF9DWqnG8WtavNoA7MTBSIndVS4/Uq6E9UwyejWXlcY/oSrN
   SmRTc73wfJMSvv4yJBlKVOVO0LsNYxg+PhEUYbYe3hGRdysPahLW4uVLt
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="363043596"
X-IronPort-AV: E=Sophos;i="5.91,282,1647327600"; 
   d="scan'208";a="363043596"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 16:53:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,282,1647327600"; 
   d="scan'208";a="709255533"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 06 Jun 2022 16:53:33 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nyMXM-000D90-8a;
        Mon, 06 Jun 2022 23:53:32 +0000
Date:   Tue, 7 Jun 2022 07:52:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Song Liu <song@kernel.org>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-raid@vger.kernel.org
Subject: [song-md:test/klp-trampoline 4/6] kernel/trace/ftrace.c:8006:14:
 error: no member named 'func_hash' in 'struct ftrace_ops'
Message-ID: <202206070722.yx7Ff8v1-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git test/klp-trampoline
head:   6fbf5243a0d6ac55cae9ed84bb5ef0d49d1c00bc
commit: 7970d53b6d04732808d677f072446b59451d032c [4/6] ftrace: introduce FTRACE_OPS_FL_SHARE_IPMODIFY
config: x86_64-randconfig-c007-20220606 (https://download.01.org/0day-ci/archive/20220607/202206070722.yx7Ff8v1-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project b92436efcb7813fc481b30f2593a4907568d917a)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=7970d53b6d04732808d677f072446b59451d032c
        git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
        git fetch --no-tags song-md test/klp-trampoline
        git checkout 7970d53b6d04732808d677f072446b59451d032c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   kernel/trace/ftrace.c:8004:14: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
           mutex_lock(&direct_mutex);
                       ^~~~~~~~~~~~
                       event_mutex
   include/linux/mutex.h:187:44: note: expanded from macro 'mutex_lock'
   #define mutex_lock(lock) mutex_lock_nested(lock, 0)
                                              ^
   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
   extern struct mutex event_mutex;
                       ^
>> kernel/trace/ftrace.c:8006:14: error: no member named 'func_hash' in 'struct ftrace_ops'
           hash = ops->func_hash->filter_hash;
                  ~~~  ^
>> kernel/trace/ftrace.c:8019:9: error: call to undeclared function 'ops_references_ip'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                                   if (ops_references_ip(op, ip)) {
                                       ^
>> kernel/trace/ftrace.c:8027:14: error: no member named 'ops_func' in 'struct ftrace_ops'
                                   if (!op->ops_func) {
                                        ~~  ^
   kernel/trace/ftrace.c:8031:15: error: no member named 'ops_func' in 'struct ftrace_ops'
                                   ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY);
                                         ~~  ^
   kernel/trace/ftrace.c:8046:16: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
           mutex_unlock(&direct_mutex);
                         ^~~~~~~~~~~~
                         event_mutex
   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
   extern struct mutex event_mutex;
                       ^
   kernel/trace/ftrace.c:8083:17: error: use of undeclared identifier 'direct_mutex'; did you mean 'event_mutex'?
                   mutex_unlock(&direct_mutex);
                                 ^~~~~~~~~~~~
                                 event_mutex
   kernel/trace/trace.h:1523:21: note: 'event_mutex' declared here
   extern struct mutex event_mutex;
                       ^
   7 errors generated.


vim +8006 kernel/trace/ftrace.c

  7973	
  7974	/*
  7975	 * When registering ftrace_ops with IPMODIFY (not direct), it is necessary
  7976	 * to make sure it doesn't conflict with any direct ftrace_ops. If there is
  7977	 * existing direct ftrace_ops on a kernel function being patched, call
  7978	 * FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY on it to enable sharing.
  7979	 *
  7980	 * @ops:     ftrace_ops being registered.
  7981	 *
  7982	 * Returns:
  7983	 *         0 - @ops does have IPMODIFY or @ops itself is DIRECT, no change
  7984	 *             needed;
  7985	 *         1 - @ops has IPMODIFY, hold direct_mutex;
  7986	 *         -EBUSY - currently registered DIRECT ftrace_ops does not support
  7987	 *                  SHARE_IPMODIFY, we need to abort the register.
  7988	 *         -EAGAIN - cannot make changes to currently registered DIRECT
  7989	 *                   ftrace_ops at the moment, but we can retry later. This
  7990	 *                   is needed to avoid potential deadlocks.
  7991	 */
  7992	static int prepare_direct_functions_for_ipmodify(struct ftrace_ops *ops)
  7993		__acquires(&direct_mutex)
  7994	{
  7995		struct ftrace_func_entry *entry;
  7996		struct ftrace_hash *hash;
  7997		struct ftrace_ops *op;
  7998		int size, i, ret;
  7999	
  8000		if (!(ops->flags & FTRACE_OPS_FL_IPMODIFY) ||
  8001		    (ops->flags & FTRACE_OPS_FL_DIRECT))
  8002			return 0;
  8003	
  8004		mutex_lock(&direct_mutex);
  8005	
> 8006		hash = ops->func_hash->filter_hash;
  8007		size = 1 << hash->size_bits;
  8008		for (i = 0; i < size; i++) {
  8009			hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
  8010				unsigned long ip = entry->ip;
  8011				bool found_op = false;
  8012	
  8013				mutex_lock(&ftrace_lock);
  8014				do_for_each_ftrace_op(op, ftrace_ops_list) {
  8015					if (!(op->flags & FTRACE_OPS_FL_DIRECT))
  8016						continue;
  8017					if (op->flags & FTRACE_OPS_FL_SHARE_IPMODIFY)
  8018						break;
> 8019					if (ops_references_ip(op, ip)) {
  8020						found_op = true;
  8021						break;
  8022					}
  8023				} while_for_each_ftrace_op(op);
  8024				mutex_unlock(&ftrace_lock);
  8025	
  8026				if (found_op) {
> 8027					if (!op->ops_func) {
  8028						ret = -EBUSY;
  8029						goto err_out;
  8030					}
  8031					ret = op->ops_func(op, FTRACE_OPS_CMD_ENABLE_SHARE_IPMODIFY);
  8032					if (ret)
  8033						goto err_out;
  8034				}
  8035			}
  8036		}
  8037	
  8038		/*
  8039		 * Didn't find any overlap with any direct function, or the direct
  8040		 * function can share with ipmodify. Hold direct_mutex to make sure
  8041		 * this doesn't change until we are done.
  8042		 */
  8043		return 1;
  8044	
  8045	err_out:
  8046		mutex_unlock(&direct_mutex);
  8047		return ret;
  8048	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
