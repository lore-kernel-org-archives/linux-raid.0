Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24BCDC001B0
	for <linux-raid@archiver.kernel.org>; Thu, 20 Jul 2023 01:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjGTB3A (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjGTB26 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Jul 2023 21:28:58 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E9F2110
        for <linux-raid@vger.kernel.org>; Wed, 19 Jul 2023 18:28:40 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4R5w7R4XkDz4f4040
        for <linux-raid@vger.kernel.org>; Thu, 20 Jul 2023 09:28:35 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHvbDCjbhkXNJ6OQ--.19578S3;
        Thu, 20 Jul 2023 09:28:36 +0800 (CST)
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
To:     Xueshi Hu <xueshi.hu@smartx.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-4-xueshi.hu@smartx.com>
 <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
 <pgxs5btqmgxze4fs4gruhzbpu355duqbm2fpcm3gn7j6qbc5pm@pusexxy2cbzs>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
Date:   Thu, 20 Jul 2023 09:28:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <pgxs5btqmgxze4fs4gruhzbpu355duqbm2fpcm3gn7j6qbc5pm@pusexxy2cbzs>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHvbDCjbhkXNJ6OQ--.19578S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF4xGw13KrykWry3Gw17KFg_yoW8ZFWUpa
        yktFyrZryUZ343KF1jvw1vqFW0vws7KFy8tFy7Ww4rJF9FgrWxGF4YgrW5Kryqv34xCr40
        va1DGrZrXFyUuaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/07/19 19:51, Xueshi Hu 写道:
> On Wed, Jul 19, 2023 at 09:38:26AM +0200, Paul Menzel wrote:
>> Dear Xueshi,
>>
>>
>> Thank you for your patches.
>>
>> Am 19.07.23 um 09:09 schrieb Xueshi Hu:
>>> If array size doesn't changed, nothing need to do.
>>
>> Maybe: … nothing needs to be done.
> What a hurry, I'll be cautious next time and check the sentences with
> tools.
>>
>> Do you have a test case to reproduce it?
>>
> Userspace command:
> 
> 	echo 4 > /sys/devices/virtual/block/md10/md/raid_disks
> 
> Kernel function calling flow:
> 
> md_attr_store()
> 	raid_disks_store()
> 		update_raid_disks()
> 			raid1_reshape()
> 
> Maybe I shall provide more information when submit patches, thank you for
> reminding me.
>>
>> Kind regards,
>>
>> Paul
>>
>>
>>> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
>>> ---
>>>    drivers/md/raid1.c | 9 ++++++---
>>>    1 file changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 62e86b7d1561..5840b8b0f9b7 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -3282,9 +3282,6 @@ static int raid1_reshape(struct mddev *mddev)
>>>    	int d, d2;
>>>    	int ret;
>>> -	memset(&newpool, 0, sizeof(newpool));
>>> -	memset(&oldpool, 0, sizeof(oldpool));
>>> -
>>>    	/* Cannot change chunk_size, layout, or level */
>>>    	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
>>>    	    mddev->layout != mddev->new_layout ||
>>> @@ -3295,6 +3292,12 @@ static int raid1_reshape(struct mddev *mddev)
>>>    		return -EINVAL;
>>>    	}
>>> +	if (mddev->delta_disks == 0)
>>> +		return 0; /* nothing to do */

I think this is wrong, you should at least keep following:

         set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
         set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
         md_wakeup_thread(mddev->thread);

Thanks,
Kuai

>>> +
>>> +	memset(&newpool, 0, sizeof(newpool));
>>> +	memset(&oldpool, 0, sizeof(oldpool));
>>> +
>>>    	if (!mddev_is_clustered(mddev))
>>>    		md_allow_write(mddev);
> .
> 

