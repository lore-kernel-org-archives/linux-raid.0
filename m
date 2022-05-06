Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAF2DC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  6 May 2022 02:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388338AbiEFCh7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 May 2022 22:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238963AbiEFCh6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 May 2022 22:37:58 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1556128F
        for <linux-raid@vger.kernel.org>; Thu,  5 May 2022 19:34:16 -0700 (PDT)
Subject: Re: [PATCH V3 1/2] md: don't unregister sync_thread with
 reconfig_mutex held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651804453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sWNCfL+KyKJVmWvYC5pPueBwE81ya3vREwEvTZB0Obg=;
        b=hgS/dPXxSLWGoIvAcjsp3DOJ4OFDgtamtjtWkZgrHD4Cn8LJUuMQ1E/VbaTgfeD4nLwYVK
        +4vH74Tz5AZHpIYQ4gpXrOHpvJYHe6tllG3Qn8Lhqvs+AmHCZRal3Hywa09d+KRksG/Zjp
        02ivCghoKPfHbylqH7xHUjcH6umcsM8=
To:     kernel test robot <lkp@intel.com>, song@kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        buczek@molgen.mpg.de, linux-raid@vger.kernel.org
References: <20220505081641.21500-2-guoqing.jiang@linux.dev>
 <202205060116.J42KgtCW-lkp@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <47083765-b65c-17a3-5c73-4fcbe40e9a52@linux.dev>
Date:   Fri, 6 May 2022 10:34:10 +0800
MIME-Version: 1.0
In-Reply-To: <202205060116.J42KgtCW-lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/6/22 2:04 AM, kernel test robot wrote:
> Hi Guoqing,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on song-md/md-next]
> [also build test WARNING on v5.18-rc5 next-20220505]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Guoqing-Jiang/two-fixes-for-md/20220505-162202
> base:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> config: hexagon-randconfig-r045-20220505 (https://download.01.org/0day-ci/archive/20220506/202205060116.J42KgtCW-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 5e004fb787698440a387750db7f8028e7cb14cfc)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/intel-lab-lkp/linux/commit/e8e9c97eb79c337a89a98a92106cfa6139a7c9e0
>          git remote add linux-review https://github.com/intel-lab-lkp/linux
>          git fetch --no-tags linux-review Guoqing-Jiang/two-fixes-for-md/20220505-162202
>          git checkout e8e9c97eb79c337a89a98a92106cfa6139a7c9e0
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/md/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>>> drivers/md/md.c:9448:3: warning: ignoring return value of function declared with 'warn_unused_result' attribute [-Wunused-result]
>                     mddev_lock(mddev);
>                     ^~~~~~~~~~ ~~~~~
>     1 warning generated.

Thanks! I should call mddev_lock_nointr here.

Guoqing
