Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA60C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 30 May 2022 16:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbiE3Qfo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 May 2022 12:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiE3Qfm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 May 2022 12:35:42 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41229CF5B
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 09:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=u/LkOc+UraL9y9LE6qDUk8HMmPi1IzB/1ALHXThEdRc=; b=bZXhMx3af+TG6EBDOUcD4EcrX6
        5oWUreaiZ7e2DS/a5ZHCZ6YjsSxo3cBDFfQ74+taWyKPfJ+0AnljmCLWjXthRZyIZtnzwuF3HNGMh
        9MntT2S/UzI+YHhYSH05IqiHbOc5nLhiFDo1TUkwqDItQezR5I/bRhJsyVSGSu0L/D+mLsVc/UiA9
        aBX+qpaFSM6usoe1k2lRIcaqMeIOR1HMKrJ70dqrbWRX90Tk3OpIQ1YFnHk7Yvwn5Qu2tWkRUn9iG
        zNpbNyopw+M8Ma8Ckef5C2tWsjeaHVyjSJQkMGPQO1bb/za4QWsC63HsvWnxucXCworBOweBx3zYR
        Qdk2VBug==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nviMh-00BocX-3c; Mon, 30 May 2022 10:35:36 -0600
Message-ID: <a894c9a2-26c8-2328-1980-7a184a3dc311@deltatee.com>
Date:   Mon, 30 May 2022 10:35:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-CA
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <b4244eab-d9e2-20a0-ebce-1a96e8fadb91@deltatee.com>
 <836b2a93-65be-8d6c-8610-18373b88f86d@molgen.mpg.de>
 <5b0584a3-c128-cb53-7c8a-63744c60c667@linux.dev>
 <4edc9468-d195-6937-f550-211bccbd6756@molgen.mpg.de>
 <954f9c33-7801-b6d2-65e3-9e5237905886@linux.dev>
 <31a9aed2-16cf-663a-5da3-0f9543ceb8c9@linux.dev>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <31a9aed2-16cf-663a-5da3-0f9543ceb8c9@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: guoqing.jiang@linux.dev, buczek@molgen.mpg.de, song@kernel.org, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-05-30 03:55, Guoqing Jiang wrote:
> I tried with 5.18.0-rc3, no problem for 07reshape5intr (will investigate 
> why it failed with this patch), but 07revert-grow still failed without
> apply this one.
> 
>  From fail07revert-grow.log, it shows below issues.
> 
> [ 7856.233515] mdadm[25246]: segfault at 0 ip 000000000040fe56 sp 
> 00007ffdcf252800 error 4 in mdadm[400000+81000]
> [ 7856.233544] Code: 00 48 8d 7c 24 30 e8 79 30 ff ff 48 8d 7c 24 30 31 
> f6 31 c0 e8 db 34 ff ff 85 c0 79 77 bf 26 50 46 00 b9 04 00 00 00 48 89 
> de <f3> a6 0f 97 c0 1c 00 84 c0 75 18 e8 fa 36 ff ff 48 0f be 53 04 48
> 
> [ 7866.871747] mdadm[25463]: segfault at 0 ip 000000000040fe56 sp 
> 00007ffe91e39800 error 4 in mdadm[400000+81000]
> [ 7866.871760] Code: 00 48 8d 7c 24 30 e8 79 30 ff ff 48 8d 7c 24 30 31 
> f6 31 c0 e8 db 34 ff ff 85 c0 79 77 bf 26 50 46 00 b9 04 00 00 00 48 89 
> de <f3> a6 0f 97 c0 1c 00 84 c0 75 18 e8 fa 36 ff ff 48 0f be 53 04 48
> 
> [ 7876.779855] ======================================================
> [ 7876.779858] WARNING: possible circular locking dependency detected
> [ 7876.779861] 5.18.0-rc3-57-default #28 Tainted: G            E
> [ 7876.779864] ------------------------------------------------------
> [ 7876.779867] mdadm/25444 is trying to acquire lock:
> [ 7876.779870] ffff991817749938 ((wq_completion)md_misc){+.+.}-{0:0}, 
> at: flush_workqueue+0x87/0x470
> [ 7876.779879]
>                 but task is already holding lock:
> [ 7876.779882] ffff9917c5c1c2c0 (&mddev->reconfig_mutex){+.+.}-{3:3}, 
> at: action_store+0x11a/0x2c0 [md_mod]
> [ 7876.779892]
>                 which lock already depends on the new lock.
> 

Hmm, strange. I'm definitely running with lockdep and even if I try the
test on my machine, on v5.18-rc3, I don't get this error. Not sure why.

In any case it looks like we recently added a
flush_workqueue(md_misc_wq) call in action_store() which runs with the
mddev_lock() held. According to your lockdep warning, that can deadlock.

That call was added in this commit:

Fixes: cc1ffe61c026 ("md: add new workqueue for delete rdev")

Can we maybe run flush_workqueue() before we take mddev_lock()?

Logan
