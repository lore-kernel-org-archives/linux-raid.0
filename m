Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7246CC77B73
	for <linux-raid@archiver.kernel.org>; Thu, 27 Apr 2023 09:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243361AbjD0JfO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Apr 2023 05:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243047AbjD0JfM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Apr 2023 05:35:12 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950102D76
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 02:35:11 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.169])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Q6Vvb1QnQz4f3lXk
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 17:35:07 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP3 (Coremail) with SMTP id _Ch0CgBnFCLLQUpk_2FaHg--.53163S3;
        Thu, 27 Apr 2023 17:35:08 +0800 (CST)
Subject: Re: [PATCH] md: Fix bitmap offset type in sb writer
To:     Song Liu <song@kernel.org>,
        Jonathan Derrick <jonathan.derrick@linux.dev>
Cc:     linux-raid@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230425011438.71046-1-jonathan.derrick@linux.dev>
 <CAPhsuW6f+6nqqaap1pP_rETSk_WA68keq6wCxEJojkYcVw-Vhw@mail.gmail.com>
 <CAPhsuW5LMzsus-nvNCj2Fy71cTW04rEN=bwcynqDHc7zrEYxCg@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5a4cba40-6f3a-e5dc-0398-4dd7489de9d8@huaweicloud.com>
Date:   Thu, 27 Apr 2023 17:35:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5LMzsus-nvNCj2Fy71cTW04rEN=bwcynqDHc7zrEYxCg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _Ch0CgBnFCLLQUpk_2FaHg--.53163S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFWDuFy5Zw4xJFyDtryrJFb_yoW8GFWkpr
        WktFWfKrs5tF4Fva47tr4kAFyFy39rt39rCr93W345C3s8tF98Xr1xKFy2g3s8Wr93WF15
        Z3Z8K345urn5XaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/04/27 1:58, Song Liu 写道:
> Hi Jonathan,
> 
> On Tue, Apr 25, 2023 at 8:44 PM Song Liu <song@kernel.org> wrote:
>>
>> On Mon, Apr 24, 2023 at 6:16 PM Jonathan Derrick
>> <jonathan.derrick@linux.dev> wrote:
>>>
>>> Bitmap offset is allowed to be negative, indicating that bitmap precedes
>>> metadata. Change the type back from sector_t to loff_t to satisfy
>>> conditionals and calculations.
> 
> This actually breaks the following tests from mdadm:
> 
> 05r1-add-internalbitmap-v1a

After a quick look of this test, I think the root cause is another
patch:

commit 8745faa95611 ("md: Use optimal I/O size for last bitmap page")

This patch add a new helper bitmap_io_size(), which breaks the condition
that 'negative value < 0'.

And following patch should fix this problem:

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index adbe95e03852..b1b521837156 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -219,8 +219,9 @@ static unsigned int optimal_io_size(struct 
block_device *bdev,
  }

  static unsigned int bitmap_io_size(unsigned int io_size, unsigned int 
opt_size,
-                                  sector_t start, sector_t boundary)
+                                  loff_t start, loff_t boundary)
  {

> 05r1-internalbitmap-v1a
> 05r1-remove-internalbitmap-v1a
> 

The patch is not tested yet, and I don't have time to look other tests
yet...

Thanks,
Kuai
> Please look into these.
> 
> Thanks,
> Song

