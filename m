Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDBCDC77B7A
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 09:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbjEXJL3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 05:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjEXJL2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 05:11:28 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5469A97
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 02:11:27 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QR55l44dVz4f4bmC
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 17:11:23 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgD3rLC81G1kTTppKA--.32081S3;
        Wed, 24 May 2023 17:11:24 +0800 (CST)
Subject: Re: [PATCH tests 0/5] tests: add some regression tests
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Yu Kuai <yukuai1@huaweicloud.com>
Cc:     yangerkun@huawei.com, linux-raid@vger.kernel.org,
        mariusz.tkaczyk@linux.intel.com, jes@trained-monkey.org,
        logang@deltatee.com, song@kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
 <b2cd227c-cca0-12a8-5716-79e7b690a591@molgen.mpg.de>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <debb2c5b-2101-0bd6-c206-a8713776554b@huaweicloud.com>
Date:   Wed, 24 May 2023 17:11:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <b2cd227c-cca0-12a8-5716-79e7b690a591@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgD3rLC81G1kTTppKA--.32081S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYF7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
        6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
        kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
        cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
        Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
        6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72
        CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0
        xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
        1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
        14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
        IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUbE_M3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/24 15:56, Paul Menzel 写道:
> Dear Yu,
> 
> 
> Thank you so very much for adding tests. For those unfamiliar with the 
> test framework, could you add one line how to run the newly added tests?

Ok, ./test -h can show how to run these tests, and I'm using, for
example:

./test --dev=disk --disks=/dev/sd[abcd] --tests=24raid10deadlock

I'll add such line in commit message.

Thanks,
Kuai
> 
> 
> Kind regards,
> 
> Paul
> 
> 
> PS: Your participation in and contributions to the Linux kernel are very 
> much appreciated. Great work, and good to have you.
> 
> .
> 

