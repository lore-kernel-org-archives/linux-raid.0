Return-Path: <SRS0=xKAG=B6=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398AEC433DF
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 06:31:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C4862076E
	for <linux-raid@archiver.kernel.org>; Thu, 20 Aug 2020 06:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgHTGbH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 02:31:07 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9792 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725797AbgHTGbH (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 02:31:07 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C8CDE921887A1CB7C952;
        Thu, 20 Aug 2020 14:31:01 +0800 (CST)
Received: from [10.174.179.185] (10.174.179.185) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 20 Aug 2020 14:30:53 +0800
Subject: Re: [PATCH 00/12] Save memory for stripe_head buffer
To:     Song Liu <song@kernel.org>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        NeilBrown <neilb@suse.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Hou Tao <houtao1@huawei.com>
References: <20200812124931.2584743-1-yuyufen@huawei.com>
 <CAPhsuW6rB-+APsw77CqOz8ipdneRyCDBdgx_rxi0ep22xC5gVw@mail.gmail.com>
From:   Yufen Yu <yuyufen@huawei.com>
Message-ID: <bfe3b715-e6d4-4754-dc4f-c4441123e7c7@huawei.com>
Date:   Thu, 20 Aug 2020 14:30:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6rB-+APsw77CqOz8ipdneRyCDBdgx_rxi0ep22xC5gVw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.185]
X-CFilter-Loop: Reflected
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2020/8/20 8:25, Song Liu wrote:
> On Wed, Aug 12, 2020 at 5:48 AM Yufen Yu <yuyufen@huawei.com> wrote:
>>
>> Hi, all
>>
>>   In current implementation, grow_buffers() uses alloc_page() to allocate
>>   the buffers for each stripe_head, i.e. allocate a page for each dev[i]
>>   in stripe_head.
>>
>>   After setting stripe_size as a configurable value by writing sysfs entry,
>>   it means that we always allocate 64K buffers, but just use 4K of them when
>>   stripe_size is 4K in 64KB arm64.
>>
>>   To save memory, we try to let multiple buffers of stripe_head to share only
>>   one real page when page size is bigger than stripe_size. Detail can be
>>   seen in patch #10.
>>
>>   This patch set is subsequent optimization for configurable stripe_size,
>>   which based on the origin patches[1] but reorganized them.
>>
>>   Patch 1 ~ 2 try to replace current page offset '0' with dev[i].offset.
>>   Patch 3 ~ 5 let xor compute functions support different page offset for raid5.
>>   Patch 6 ~ 9 let syndrome and recovery function support different page offset for raid6.
>>   All of these patch are preparing for shared page. There is no functional change.
>>
>>   Patch 10 ~ 11 actually implement shared page between multiple devices of
>>   stripe_head. But they only make sense for PAGE_SIZE != 4096, likely, 64KB arm64
>>   system. It doesn't make any difference for PAGE_SIZE == 4096 system, likely x86.
> 
> Thanks for the patches.
> 
> I went through the first half of the set, most of the code looks fine.
> However, there is
> one issue: the way you split the changes into 12 patches is not ideal. The most
> significant issue is that build failed after 5/12 or 6/12 (and was
> fixed after 9/12). We
> would like every commit build successfully. I think the proper fix is
> to break 9/12 and
> merge changes in raid5.c to proper patches. Also, I think we can merge
> 1/12 and 2/12.
> 
> Please resubmit after these changes.
> 
> Thanks,
> Song
> .
> 

Thanks a lot for your review. These changes can make patch set more reasonable.

Thanks,
Yufen
