Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD3EEB64DC
	for <linux-raid@archiver.kernel.org>; Fri,  7 Jul 2023 01:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjGGBZ1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 Jul 2023 21:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjGGBZ0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 Jul 2023 21:25:26 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68807113;
        Thu,  6 Jul 2023 18:25:25 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Qxwgj64hBz4f3mHx;
        Fri,  7 Jul 2023 09:25:21 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHvbCAaadk7FSHNQ--.59609S3;
        Fri, 07 Jul 2023 09:25:22 +0800 (CST)
Subject: Re: [PATCH -next 0/2] md: clean up and fix for mddev_suspend()
To:     Yu Kuai <yukuai1@huaweicloud.com>, xni@redhat.com, song@kernel.org,
        colyli@suse.de
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yi.zhang@huawei.com, yangerkun@huawei.com,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230628012931.88911-1-yukuai1@huaweicloud.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a2bf6819-224f-4b2d-89c9-67528469b03f@huaweicloud.com>
Date:   Fri, 7 Jul 2023 09:25:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230628012931.88911-1-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHvbCAaadk7FSHNQ--.59609S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GrWkury7ur4fCw4ftr48Xrb_yoW3Jrb_uF
        n5urZFg34Uury7WwnY93WxXrWUKFWrGF9rAa4UtF1DtF1aqFn3JrZ5Jry5G390yFW5JwnY
        yFySqr47AF4IqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4xFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUp6wZUUU
        UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/06/28 9:29, Yu Kuai Ð´µÀ:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> This patchset is minor changes that I found by code review while I'm
> working on synchronize io and array configuration. I'm planing to
> refactor mddev_suspend() from:
> 
> mddev_lock
> // array configuration
> mddev_unlock
> 
> and:
> 
> mddev_lock
> mddev_suspend
> // array configuration
> mddev_resume
> mddev_unlock
> 
> to:
> 
> mddev_suspend
> mddev_lock
> // array configuration
> mddev_unlock
> mddev_resume
> 

Friendly ping ...

Thanks,
Kuai

> Yu Kuai (2):
>    md: don't quiesce in mddev_suspend()
>    md: restore 'noio_flag' for the last mddev_resume()
> 
>   drivers/md/md.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 

