Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B43C6FD1C
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 09:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCNJ1m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 05:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCNJ1l (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 05:27:41 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965DB98841
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 02:27:39 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PbSpD6trPzrT1K;
        Tue, 14 Mar 2023 17:26:44 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 17:27:37 +0800
Subject: Re: [song-md:md-next 15/18] drivers/md/md-cluster.c:425:42: error:
 use of undeclared identifier 'mddev'; did you mean 'mode'?
To:     kernel test robot <lkp@intel.com>
CC:     <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
        <linux-raid@vger.kernel.org>, Song Liu <song@kernel.org>
References: <202303141758.4EtLtIA1-lkp@intel.com>
From:   Yu Kuai <yukuai3@huawei.com>
Message-ID: <777b8f63-4d41-66dc-3cb5-8ff8c916ce01@huawei.com>
Date:   Tue, 14 Mar 2023 17:27:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <202303141758.4EtLtIA1-lkp@intel.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.73]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, Song

ÔÚ 2023/03/14 17:13, kernel test robot Ð´µÀ:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> head:   ec7246c9455e83f452055cec9c39bd54e72217a4
> commit: 48b34bba06372e5f6645716b57394db28fa7260c [15/18] md: refactor md_wakeup_thread()
> config: s390-randconfig-r032-20230312 (https://download.01.org/0day-ci/archive/20230314/202303141758.4EtLtIA1-lkp@intel.com/config)
> compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project 67409911353323ca5edf2049ef0df54132fa1ca7)
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # install s390 cross compiling tool for clang build
>          # apt-get install binutils-s390x-linux-gnu
>          # https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=48b34bba06372e5f6645716b57394db28fa7260c
>          git remote add song-md git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
>          git fetch --no-tags song-md md-next
>          git checkout 48b34bba06372e5f6645716b57394db28fa7260c
>          # save the config file
>          mkdir build_dir && cp config build_dir/.config
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 olddefconfig
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/md/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202303141758.4EtLtIA1-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>>> drivers/md/md-cluster.c:425:42: error: use of undeclared identifier 'mddev'; did you mean 'mode'?
>                             md_wakeup_thread(&cinfo->recv_thread, mddev);
>                                                                   ^~~~~
>                                                                   mode
>     drivers/md/md-cluster.c:418:37: note: 'mode' declared here
>     static void ack_bast(void *arg, int mode)
>                                         ^
>     1 error generated.
> 
> 
> vim +425 drivers/md/md-cluster.c
> 
>     412	
>     413	/*
>     414	 * The BAST function for the ack lock resource
>     415	 * This function wakes up the receive thread in
>     416	 * order to receive and process the message.
>     417	 */
>     418	static void ack_bast(void *arg, int mode)
>     419	{
>     420		struct dlm_lock_resource *res = arg;
>     421		struct md_cluster_info *cinfo = res->mddev->cluster_info;
>     422	
>     423		if (mode == DLM_LOCK_EX) {
>     424			if (test_bit(MD_CLUSTER_ALREADY_IN_CLUSTER, &cinfo->state))
>   > 425				md_wakeup_thread(&cinfo->recv_thread, mddev);

Sorry that I didn't open md-cluster config, and I failed to test this in
my environment.

Sincerely sorry for the trouble, I'll send new version and make sure all
model is tested.

Thanks,
Kuai

>     426			else
>     427				set_bit(MD_CLUSTER_PENDING_RECV_EVENT, &cinfo->state);
>     428		}
>     429	}
>     430	
> 
