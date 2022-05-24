Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C78FDC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 24 May 2022 16:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiEXQN0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 May 2022 12:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbiEXQNZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 May 2022 12:13:25 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCD07E1DA
        for <linux-raid@vger.kernel.org>; Tue, 24 May 2022 09:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=TYKer+5GA5Op2wg4BPSUTjn7jWSMUFsuFJpEPb2Ynsk=; b=hZi6I/brQqQG56nPY7ZcBsAL6H
        /lRL+JMA5Qs3A/VWOVWy+xgqoHY6o59xoIOv43L0n45md6HO9cPgCvsTSAImnSkYsSiB3xQ0fBV8E
        tiUnP4cokUXqqPwdX72FoNtn2gQSNk0OYwcALiMAH+vfa6Mssg6pGzErxxwBd1osY2D3cXWNaI5Fn
        vmW6QQS5giBpHdSaDGnecxvvvT6OQrcgwmunPTzRj7kCuU3u4vsaJWcKHa7yD6wxOZee2+x0UhKoS
        +tEO6LFpSnZAijNYBADzc76YEcRrXlRm0UyNi5yHWozzLUriSuWmMxvObNxF27YBg8zAdg397foM1
        xoeUYJKg==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ntX9s-006RcB-3c; Tue, 24 May 2022 10:13:21 -0600
Message-ID: <82a08e9c-e3f4-4eb6-cb06-58b96c0f01a8@deltatee.com>
Date:   Tue, 24 May 2022 10:13:19 -0600
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
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <954f9c33-7801-b6d2-65e3-9e5237905886@linux.dev>
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



On 2022-05-23 03:51, Guoqing Jiang wrote:
> I have tried with both ubuntu 22.04 kernel which is 5.15 and vanilla 
> 5.12, none of them
> can pass your mentioned tests.
> 
> [root@localhost mdadm]# lsblk|grep vd
> vda          252:0    0    1G  0 disk
> vdb          252:16   0    1G  0 disk
> vdc          252:32   0    1G  0 disk
> vdd          252:48   0    1G  0 disk
> [root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d} 
> --tests=05r1-add-internalbitmap
> Testing on linux-5.12.0-default kernel
> /root/mdadm/tests/05r1-add-internalbitmap... succeeded
> [root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d} 
> --tests=07reshape5intr
> Testing on linux-5.12.0-default kernel
> /root/mdadm/tests/07reshape5intr... FAILED - see 
> /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for details
> [root@localhost mdadm]# ./test --dev=disk --disks=/dev/vd{a..d} 
> --tests=07revert-grow
> Testing on linux-5.12.0-default kernel
> /root/mdadm/tests/07revert-grow... FAILED - see 
> /var/tmp/07revert-grow.log and /var/tmp/fail07revert-grow.log for details
> [root@localhost mdadm]# head -10  /var/tmp/07revert-grow.log | grep mdadm
> + . /root/mdadm/tests/07revert-grow
> *++ mdadm -CR --assume-clean /dev/md0 -l5 -n4 -x1 /dev/vda /dev/vdb 
> /dev/vdc /dev/vdd /dev/vda /dev/vdb /dev/vdc /dev/vdd --metadata=0.9**
> *
> The above line is clearly wrong from my understanding.
> 
> And let's check ubuntu 22.04.
> 
> root@vm:/home/gjiang/mdadm# lsblk|grep vd
> vda    252:0    0     1G  0 disk
> vdb    252:16   0     1G  0 disk
> vdc    252:32   0     1G  0 disk
> root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..d} 
> --tests=05r1-failfast
> Testing on linux-5.15.0-30-generic kernel
> /home/gjiang/mdadm/tests/05r1-failfast... succeeded
> root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..c}   
> --tests=07reshape5intr
> Testing on linux-5.15.0-30-generic kernel
> /home/gjiang/mdadm/tests/07reshape5intr... FAILED - see 
> /var/tmp/07reshape5intr.log and /var/tmp/fail07reshape5intr.log for details
> root@vm:/home/gjiang/mdadm# ./test --dev=disk --disks=/dev/vd{a..c} 
> --tests=07revert-grow
> Testing on linux-5.15.0-30-generic kernel
> /home/gjiang/mdadm/tests/07revert-grow... FAILED - see 
> /var/tmp/07revert-grow.log and /var/tmp/fail07revert-grow.log for details
> 
> So I would not consider it is regression.

I definitely had those test working (at least some of the time) before I
rebased on md-next or if I revert 7e6ba434cc6080. You might need to try
my branch (plus that patch reverted) and my mdadm branch as there are a
number of fixes that may have helped with that specific test.

https://github.com/lsgunth/mdadm/ bugfixes2
https://github.com/sbates130272/linux-p2pmem md-bug

Thanks,

Logan
