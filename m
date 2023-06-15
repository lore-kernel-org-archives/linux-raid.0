Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7C7EB64D9
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jun 2023 03:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237117AbjFODb1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Jun 2023 23:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbjFODbY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Jun 2023 23:31:24 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DD81FF9;
        Wed, 14 Jun 2023 20:31:22 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QhSWB4kRYz4f3pJX;
        Thu, 15 Jun 2023 11:31:18 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCH77IFhopkUxHyLg--.45217S3;
        Thu, 15 Jun 2023 11:31:19 +0800 (CST)
Subject: Re: [PATCH 0/3] md/raid10: record rdev/replacement in r10bio
To:     linan666@huaweicloud.com, song@kernel.org, neilb@suse.de
Cc:     linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        linan122@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20230614084740.1493969-1-linan666@huaweicloud.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5c6ff37b-4285-f62a-c910-67401b0b9c1f@huaweicloud.com>
Date:   Thu, 15 Jun 2023 11:31:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230614084740.1493969-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCH77IFhopkUxHyLg--.45217S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtryUtFyktw1rXr45tryDGFg_yoWfZwbE9F
        yjyFy3Gw10q3WIkayYkr1xZFZxWF4UuryxJ3Z0qrWFqFZxuF47Jrn0grWxWw4fWFyvyryj
        yr18uFySyr17ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3AFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
        c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
        AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
        3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
        nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/06/14 16:47, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> Replacement can replace rdev during replacement io pending.
> mirror->rdev/replacement might be changed during io pending. Get rdev from
> it is risky. This patch series record rdev/replacement in r10bio, and get
> rdev from r10bio to fix bugs in normal write. And I want to do
> this for each io type later.

I personally don't like this, do things by half. I'm good with this
approch for raid10, but can you send a new version to use this for all
io?

Thanks,
Kuai
> 
> Li Nan (3):
>    md/raid10: record rdev/replacement in struct r10bio
>    md/raid10: get rdev/replacemenet from r10bio for normal write
>    md/raid10: improve raid10_end_write_request()
> 
>   drivers/md/raid10.c | 96 ++++++++++++++++++++++-----------------------
>   drivers/md/raid10.h | 12 +++---
>   2 files changed, 54 insertions(+), 54 deletions(-)
> 

