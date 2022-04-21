Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02162C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 21 Apr 2022 16:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390446AbiDUQF1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Apr 2022 12:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390436AbiDUQF0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Apr 2022 12:05:26 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D77E4504A;
        Thu, 21 Apr 2022 09:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=wD5oA5p9R1NM73pV8BZS7Ea5XXuMt1jTCb1Rn1lw4Is=; b=DwnIS9SEraPO5q1Tbb1etZht4o
        HC8dXBodXlMV1MBhu+uF3QV1ugM0vSMqjwBNaTwPte1nyojJEye1kWKDM7eKq9aXCUW/AvcyPojf2
        3waMAvDgMjgAaZQFGS0+Cm9yAzSlBEsufUnsXknqKgQe85WiVPzOOOi7Fuwfmp0Cz6aFRK8iz3842
        4vhMAzCrQBIIalyBgMTvV847wOiTgnBGaxreuNhThq1CucPRVRiaQ6rmg4g4HKSoDKDIf1bIm8GA5
        O94RDABEQ2L+ZzpiJ3bWjDjhqV+O0nbQH2C/nBS3PZGAt2l23X5cD/y+LNtEhk1C/5BYEQojPe0FR
        3KSW37ww==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nhZGM-00DBPK-AH; Thu, 21 Apr 2022 10:02:35 -0600
Message-ID: <c14c0103-9cbd-7d0f-486b-344dd33725ab@deltatee.com>
Date:   Thu, 21 Apr 2022 10:02:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-CA
To:     Xiao Ni <xni@redhat.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220420195425.34911-1-logang@deltatee.com>
 <CALTww28fwNpm0O_jc7-2Xr0JSX9i6F1kgoUQ8m_k6ZgPa1XxXw@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CALTww28fwNpm0O_jc7-2Xr0JSX9i6F1kgoUQ8m_k6ZgPa1XxXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: xni@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, hch@infradead.org, guoqing.jiang@linux.dev, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v2 00/12] Improve Raid5 Lock Contention
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-04-21 02:45, Xiao Ni wrote:
> Could you share the commands to get the test result (lock contention
> and performance)?

Sure. The performance we were focused on was large block writes. So we
setup raid5 instances with varying number of disks and ran the following
fio script directly on the drive.

[simple]
filename=/dev/md0
ioengine=libaio
rw=write
direct=1
size=8G
blocksize=2m
iodepth=16
runtime=30s
time_based=1
offset_increment=8G
numjobs=12
￼
(We also played around with tuning this but didn't find substantial
changes once the bottleneck was hit)

We tuned md with parameters like:

echo 4 > /sys/block/md0/md/group_thread_cnt
echo 8192 > /sys/block/md0/md/stripe_cache_size

For lock contention stats, we just used lockstat[1]; roughly like:

echo 1 > /proc/sys/kernel/lock_stat
fio test.fio
echo 0 > /proc/sys/kernel/lock_stat
cat /proc/lock_stat

And compared the before and after.

Logan

[1] https://www.kernel.org/doc/html/latest/locking/lockstat.html
