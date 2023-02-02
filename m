Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FF7C05027
	for <linux-raid@archiver.kernel.org>; Thu,  2 Feb 2023 00:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjBBAvr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 19:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBBAvq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 19:51:46 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486554DE2B
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 16:51:43 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4P6gGK4YpLz4f3p1X
        for <linux-raid@vger.kernel.org>; Thu,  2 Feb 2023 08:51:37 +0800 (CST)
Received: from [10.174.176.117] (unknown [10.174.176.117])
        by APP4 (Coremail) with SMTP id gCh0CgDHd6saCdtjpVFbCw--.16828S2;
        Thu, 02 Feb 2023 08:51:39 +0800 (CST)
Subject: Re: [PATCH] md: don't update recovery_cp when curr_resync is ACTIVE
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Logan Gunthorpe <logang@deltatee.com>, houtao1@huawei.com,
        linan122@huawei.com
References: <20230131070719.1702279-1-houtao@huaweicloud.com>
 <CAPhsuW4s9U3FVZOh7NJGZAnWACVeJgWUNd=bZVtjg4B+h+ox1Q@mail.gmail.com>
From:   Hou Tao <houtao@huaweicloud.com>
Message-ID: <6ec2c920-0d88-7bb6-e0aa-ef44865fa935@huaweicloud.com>
Date:   Thu, 2 Feb 2023 08:51:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW4s9U3FVZOh7NJGZAnWACVeJgWUNd=bZVtjg4B+h+ox1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-CM-TRANSID: gCh0CgDHd6saCdtjpVFbCw--.16828S2
X-Coremail-Antispam: 1UD129KBjvJXoWrKrWUWFWrWrWUJryrGw4rZrb_yoW8Jr1kpF
        WfW3W5trs8GrWakwsFqa48Zay8Zr4fKryjyFWxW3yrAw1SyF4kWryUG3WUJF95C392qa18
        Xas5W3y7Zr9ruw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
        80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
        I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
        k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 2/2/2023 12:35 AM, Song Liu wrote:
> On Mon, Jan 30, 2023 at 10:39 PM Hou Tao <houtao@huaweicloud.com> wrote:
>> From: Hou Tao <houtao1@huawei.com>
>>
>> Don't update recovery_cp when curr_resync is MD_RESYNC_ACTIVE, otherwise
>> md may skip the resync of the first 3 sectors if the resync procedure is
>> interrupted before the first calling of ->sync_request() as shown below:
>>
>> md_do_sync thread          control thread
>>   // setup resync
>>   mddev->recovery_cp = 0
>>   j = 0
>>   mddev->curr_resync = MD_RESYNC_ACTIVE
>>
>>                              // e.g., set array as idle
>>                              set_bit(MD_RECOVERY_INTR, &&mddev_recovery)
>>   // resync loop
>>   // check INTR before calling sync_request
>>   !test_bit(MD_RECOVERY_INTR, &mddev->recovery
>>
>>   // resync interrupted
>>   // update recovery_cp from 0 to 3
>>   // the resync of three 3 sectors will be skipped
>>   mddev->recovery_cp = 3
>>
>> Fixes: eac58d08d493 ("md: Use enum for overloaded magic numbers used by mddev->curr_resync")
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
> By the way, how did you find this issue? Is it from users/production?
> Or just from reading the code?
Found the issue when reading the code and reproduced the problem to confirm that.
>
> Thanks,
> Song

