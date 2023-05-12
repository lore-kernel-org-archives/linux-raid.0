Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6974EC77B7C
	for <linux-raid@archiver.kernel.org>; Fri, 12 May 2023 09:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240405AbjELJoa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 12 May 2023 05:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240619AbjELJnz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 12 May 2023 05:43:55 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5761209B;
        Fri, 12 May 2023 02:43:19 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QHkMl1mgLz4f4W5P;
        Fri, 12 May 2023 17:42:59 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3X7MjCl5koXckJQ--.53181S3;
        Fri, 12 May 2023 17:43:00 +0800 (CST)
Subject: Re: [PATCH -next v2 0/7] limit the number of plugged bio
To:     Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, akpm@osdl.org,
        neilb@suse.de
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230426082031.1299149-1-yukuai1@huaweicloud.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a7246f63-b499-8b26-e27a-3d16abc18ced@huaweicloud.com>
Date:   Fri, 12 May 2023 17:42:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230426082031.1299149-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3X7MjCl5koXckJQ--.53181S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KF48KF43Kry7Zw17XFWxXrb_yoW8WF4kpa
        y3G3yagw1kAr17A3Z3Ar48WFyrJw48Jry7JrnIyr1rCa45ZFWUZr1xGayrGr97AFy3Ga42
        gr45J34UGF1DtFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE14v26r4j
        6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUF9
        a9DUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/04/26 16:20, Yu Kuai Ð´µÀ:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Changes in v2:
>   - remove the patch to rename raid1-10.c
> 
> This patchset tries to limit the number of plugged bio for raid1 and
> raid10, which is done in the last patch, other patches are some refactor
> and optimizations.
> 
> This patchset is tested with a new test [1], this test triggers dirty
> pages writeback for 10s, and in the meantime checks disk inflight.
> 
> Before this patchset, test will fail because inflight exceed threshold
> (threshold is set to 4096 in the test, in theory this can be mutch
>   greater as long as there are enough dirty pages and memory).
> 
> After this patchset, inflight is within 96 (MAX_PLUG_BIO * copies).
> 
> [1] https://lore.kernel.org/linux-raid/20230426073447.1294916-1-yukuai1@huaweicloud.com/

Friendly ping...

Thanks,
Kuai
> 
> Yu Kuai (7):
>    md/raid10: prevent soft lockup while flush writes
>    md/raid1-10: factor out a helper to add bio to plug
>    md/raid1-10: factor out a helper to submit normal write
>    md/raid1-10: submit write io directly if bitmap is not enabled
>    md/md-bitmap: add a new helper to unplug bitmap asynchrously
>    md/raid1-10: don't handle pluged bio by daemon thread
>    md/raid1-10: limit the number of plugged bio
> 
>   drivers/md/md-bitmap.c | 55 +++++++++++++++++++++++++++++++++----
>   drivers/md/md-bitmap.h | 10 +++++++
>   drivers/md/raid1-10.c  | 62 ++++++++++++++++++++++++++++++++++++++++++
>   drivers/md/raid1.c     | 29 ++++----------------
>   drivers/md/raid10.c    | 47 +++++++-------------------------
>   5 files changed, 136 insertions(+), 67 deletions(-)
> 

