Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E10C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 00:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE69F61222
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 00:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbhHXAoT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 Aug 2021 20:44:19 -0400
Received: from out1.migadu.com ([91.121.223.63]:61747 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233101AbhHXAoK (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 23 Aug 2021 20:44:10 -0400
Subject: Re: [PATCH V3] raid1: ensure write behind bio has less than
 BIO_MAX_VECS sectors
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1629765805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JnRJoSVaRqHIZkKhzvuzuQ1A7N7puBWYd81TcQ3vXYQ=;
        b=GpfEjz3z1TVApq0OANpSKTkarBWo9RcsQFV4mfpMQDkxiGYLw9ITddIzZHRYTSbdvp+RPX
        odvzyMdUE9Qybwuadx+tUY3q3nVVagJYtUNR0nGo2+XOdVNaz4/0mkFl9FIRiajwI/ebl4
        axZ6Wn8SUm/DWI66GY3N3zkrtnJcWvo=
To:     kernel test robot <lkp@intel.com>, axboe@kernel.dk
Cc:     kbuild-all@lists.01.org, song@kernel.org, hch@infradead.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20210823074513.3208278-1-guoqing.jiang@linux.dev>
 <202108232012.No5kysqW-lkp@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <f9748b7c-2c3f-ce4e-66a0-46c126c6b7dd@linux.dev>
Date:   Tue, 24 Aug 2021 08:43:18 +0800
MIME-Version: 1.0
In-Reply-To: <202108232012.No5kysqW-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Thanks for the report!

On 8/23/21 8:19 PM, kernel test robot wrote:
> Hi Guoqing,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on song-md/md-next]
> [also build test ERROR on v5.14-rc7 next-20210820]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Guoqing-Jiang/raid1-ensure-write-behind-bio-has-less-than-BIO_MAX_VECS-sectors/20210823-154653
> base:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> config: sh-allmodconfig (attached as .config)
> compiler: sh4-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/0day-ci/linux/commit/302a06a55fac4a9fb10f57dc96f6a618f3e853b4
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Guoqing-Jiang/raid1-ensure-write-behind-bio-has-less-than-BIO_MAX_VECS-sectors/20210823-154653
>          git checkout 302a06a55fac4a9fb10f57dc96f6a618f3e853b4
>          # save the attached .config to linux build tree
>          mkdir build_dir
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=sh SHELL=/bin/bash drivers/md/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>     drivers/md/raid1.c: In function 'raid1_write_request':
>>> drivers/md/raid1.c:1393:44: error: 'mirror' undeclared (first use in this function); did you mean 'md_error'?
>      1393 |                 if (test_bit(WriteMostly, &mirror->rdev->flags))
>           |                                            ^~~~~~
>           |                                            md_error

Oops, will fix it.

> drivers/md/raid1.c:1477:52: error: 'PAGE_SECTORS' undeclared (first use in this function)
>      1477 |                                     BIO_MAX_VECS * PAGE_SECTORS);
>           |                                                    ^~~~~~~~~~~~

This patch is supposed to be merged by block tree due to dependency.

Thanks,
Guoqing
