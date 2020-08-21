Return-Path: <SRS0=1IH2=B7=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD77C433DF
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 12:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81DA420724
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 12:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgHUMUy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Aug 2020 08:20:54 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10302 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728413AbgHUMUk (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 21 Aug 2020 08:20:40 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D20E7DD63F5293E4F9AF;
        Fri, 21 Aug 2020 20:20:34 +0800 (CST)
Received: from [10.174.179.185] (10.174.179.185) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Fri, 21 Aug 2020 20:20:24 +0800
Subject: Re: [PATCH v2 00/10] Save memory for stripe_head buffer
To:     Song Liu <song@kernel.org>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>
References: <20200820132214.3749139-1-yuyufen@huawei.com>
 <CAPhsuW473fmPDanrHYwG6NxU3Ai7kd8oo6siKo4A4j1w-pi7rg@mail.gmail.com>
From:   Yufen Yu <yuyufen@huawei.com>
Message-ID: <1f99d02f-0104-8c22-78e8-46a90c4f25b4@huawei.com>
Date:   Fri, 21 Aug 2020 20:20:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW473fmPDanrHYwG6NxU3Ai7kd8oo6siKo4A4j1w-pi7rg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.185]
X-CFilter-Loop: Reflected
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2020/8/21 13:04, Song Liu wrote:
> On Thu, Aug 20, 2020 at 6:21 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>
> [...]
>>
>>   Patch 8 ~ 10 actually implement shared page between multiple devices of
>>   stripe_head. But they only make sense for PAGE_SIZE != 4096, likely, 64KB arm64
>>   system. It doesn't make any difference for PAGE_SIZE == 4096 system, likely x86.
>>
>>   We have run tests of mdadm for raid456 and test raid6test module.
>>   Not found obvious errors.
> 
> Applied series to md-next.
> 
> I noticed there is another case where we allocate page for
> sh->dev[i].orig_page in
> handle_stripe_dirtying(). This only happens with journal devices.
> Please run tests
> with journal device.

For now, raid5 journal and PPL feature are both required PAGE_SIZE == 4096.
(Seen r5l_init_log() and ppl_init_log() return -EINVAL when PAGE_SIZE is not
4096). So, in theory, this patch set should not make any different for them.

But, run tests is also necessary. Tests under mdadm git repository have two
journal cases: 21raid5cache and 20raid5journal. To test PPL, I write a simple
test case: create raid5 array with option '-k ppl'. mkfs and mount the array.
Then, some read and write data test on mount directory. Concurrently remove disk
from array and re-add it. Not found obvious errors.

Thanks,
Yufen

