Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4948EC77B61
	for <linux-raid@archiver.kernel.org>; Fri, 28 Apr 2023 02:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344621AbjD1CEP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbjD1CEO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Apr 2023 22:04:14 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 362703A86
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 19:04:13 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Q6wrl32Fgz4f3nQn
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 10:04:07 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHcLOYKUtkrF4yIQ--.24432S3;
        Fri, 28 Apr 2023 10:04:09 +0800 (CST)
Subject: Re: [PATCH] md: Fix bitmap offset type in sb writer
To:     Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Jonathan Derrick <jonathan.derrick@linux.dev>,
        linux-raid@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230425011438.71046-1-jonathan.derrick@linux.dev>
 <CAPhsuW6f+6nqqaap1pP_rETSk_WA68keq6wCxEJojkYcVw-Vhw@mail.gmail.com>
 <CAPhsuW5LMzsus-nvNCj2Fy71cTW04rEN=bwcynqDHc7zrEYxCg@mail.gmail.com>
 <5a4cba40-6f3a-e5dc-0398-4dd7489de9d8@huaweicloud.com>
 <CAPhsuW68kkYW_F7u3RZyq+K9VOF1iCb3Y6c+xY_URS+_uXYMZw@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b86778b3-da99-4ef1-850f-b79095fea879@huaweicloud.com>
Date:   Fri, 28 Apr 2023 10:04:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW68kkYW_F7u3RZyq+K9VOF1iCb3Y6c+xY_URS+_uXYMZw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHcLOYKUtkrF4yIQ--.24432S3
X-Coremail-Antispam: 1UD129KBjvJXoW7trWUXr13Wr13WryxWr45Jrb_yoW8Cr48pr
        W8JFWYgF4ktF4Fq3W7tr48AFyFyrZrt3ykWr93W345A3s8tF90qr18GFyjg3s8Wr93uF1Y
        van0g343Zrn5XFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9-UUU
        UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/04/28 1:45, Song Liu 写道:
> On Thu, Apr 27, 2023 at 2:35 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2023/04/27 1:58, Song Liu 写道:
>>> Hi Jonathan,
>>>
>>> On Tue, Apr 25, 2023 at 8:44 PM Song Liu <song@kernel.org> wrote:
>>>>
>>>> On Mon, Apr 24, 2023 at 6:16 PM Jonathan Derrick
>>>> <jonathan.derrick@linux.dev> wrote:
>>>>>
>>>>> Bitmap offset is allowed to be negative, indicating that bitmap precedes
>>>>> metadata. Change the type back from sector_t to loff_t to satisfy
>>>>> conditionals and calculations.
>>>
>>> This actually breaks the following tests from mdadm:
>>>
>>> 05r1-add-internalbitmap-v1a
>>
>> After a quick look of this test, I think the root cause is another
>> patch:
>>
>> commit 8745faa95611 ("md: Use optimal I/O size for last bitmap page")
>>
>> This patch add a new helper bitmap_io_size(), which breaks the condition
>> that 'negative value < 0'.
>>
>> And following patch should fix this problem:
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index adbe95e03852..b1b521837156 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -219,8 +219,9 @@ static unsigned int optimal_io_size(struct
>> block_device *bdev,
>>    }
>>
>>    static unsigned int bitmap_io_size(unsigned int io_size, unsigned int
>> opt_size,
>> -                                  sector_t start, sector_t boundary)
>> +                                  loff_t start, loff_t boundary)
>>    {
>>
>>> 05r1-internalbitmap-v1a
>>> 05r1-remove-internalbitmap-v1a
>>>
>>
>> The patch is not tested yet, and I don't have time to look other tests
>> yet...
> 
> Thanks Kuai! This fixed the test.

Thanks for the test, I'll check more details and try tests myself later.

Kuai
> 
> I will add your Signed-off-by to the patch. Please let me know if you
> prefer not to have it.
> 
> Song
> .
> 

