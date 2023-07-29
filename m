Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F1CEB64DD
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jul 2023 02:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjG2CQu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Jul 2023 22:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjG2CQs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Jul 2023 22:16:48 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D444696
        for <linux-raid@vger.kernel.org>; Fri, 28 Jul 2023 19:16:47 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RCR2w2Zmsz4f3lDl
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 08:58:48 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgAHcLNFZMRkmpwzPA--.50987S3;
        Sat, 29 Jul 2023 08:58:47 +0800 (CST)
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
To:     Xueshi Hu <xueshi.hu@smartx.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-4-xueshi.hu@smartx.com>
 <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
 <pgxs5btqmgxze4fs4gruhzbpu355duqbm2fpcm3gn7j6qbc5pm@pusexxy2cbzs>
 <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
 <trf4pch7vfi2srosqsccnncoropf6dtr6bdfk3mm6drpfkygih@kvsnmjsa2c4s>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cd264593-2258-db9f-8ba7-0a0a1e2f0f77@huaweicloud.com>
Date:   Sat, 29 Jul 2023 08:58:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <trf4pch7vfi2srosqsccnncoropf6dtr6bdfk3mm6drpfkygih@kvsnmjsa2c4s>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgAHcLNFZMRkmpwzPA--.50987S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWF4UWFyrZw18Cw48XFyUGFg_yoW5CFy3pa
        ykta4Ykr4UC34ayF12qw1kKFW0vw1xKrWIqFy7Ww1UJr9rKFn7JF1Yqry5GryDZryxGw40
        qa1UJrZrXa4UCaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
        Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8
        JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUU
        UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/07/28 22:42, Xueshi Hu 写道:
> On Thu, Jul 20, 2023 at 09:28:34AM +0800, Yu Kuai wrote:
>> Hi,
>>
>> 在 2023/07/19 19:51, Xueshi Hu 写道:
>>> On Wed, Jul 19, 2023 at 09:38:26AM +0200, Paul Menzel wrote:
>>>> Dear Xueshi,
>>>>
>>>>
>>>> Thank you for your patches.
>>>>
>>>> Am 19.07.23 um 09:09 schrieb Xueshi Hu:
>>>>> If array size doesn't changed, nothing need to do.
>>>>
>>>> Maybe: … nothing needs to be done.
>>> What a hurry, I'll be cautious next time and check the sentences with
>>> tools.
>>>>
>>>> Do you have a test case to reproduce it?
>>>>
>>> Userspace command:
>>>
>>> 	echo 4 > /sys/devices/virtual/block/md10/md/raid_disks
>>>
>>> Kernel function calling flow:
>>>
>>> md_attr_store()
>>> 	raid_disks_store()
>>> 		update_raid_disks()
>>> 			raid1_reshape()
>>>
>>> Maybe I shall provide more information when submit patches, thank you for
>>> reminding me.
>>>>
>>>> Kind regards,
>>>>
>>>> Paul
>>>>
>>>>
>>>>> Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
>>>>> ---
>>>>>     drivers/md/raid1.c | 9 ++++++---
>>>>>     1 file changed, 6 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>>> index 62e86b7d1561..5840b8b0f9b7 100644
>>>>> --- a/drivers/md/raid1.c
>>>>> +++ b/drivers/md/raid1.c
>>>>> @@ -3282,9 +3282,6 @@ static int raid1_reshape(struct mddev *mddev)
>>>>>     	int d, d2;
>>>>>     	int ret;
>>>>> -	memset(&newpool, 0, sizeof(newpool));
>>>>> -	memset(&oldpool, 0, sizeof(oldpool));
>>>>> -
>>>>>     	/* Cannot change chunk_size, layout, or level */
>>>>>     	if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
>>>>>     	    mddev->layout != mddev->new_layout ||
>>>>> @@ -3295,6 +3292,12 @@ static int raid1_reshape(struct mddev *mddev)
>>>>>     		return -EINVAL;
>>>>>     	}
>>>>> +	if (mddev->delta_disks == 0)
>>>>> +		return 0; /* nothing to do */
>>
>> I think this is wrong, you should at least keep following:
>>
>>          set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>>          set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>          md_wakeup_thread(mddev->thread);
>>
> I fail to comprehend the rationale behind the kernel's need to invoke
> raid1d() repeatedly despite the absence of any modifications.
> It appears that raid1d() is responsible for invoking md_check_recovery()
> and resubmit the failed io.

No, the point here is to set MD_RECOVERY_NEEDED and MD_RECOVERY_RECOVER,
so that md_check_recovery() can start to reshape.

Thanks,
Kuai
> 
> Evidently, it is not within the scope of raid1_reshape() to resubmit
> failed io.
> 
> Moreover, upon reviewing the Documentation[1], I could not find any
> indications that reshape must undertake the actions as specified in
> md_check_recovery()'s documentation, such as eliminating faulty devices.
> 
> [1]: https://www.kernel.org/doc/html/latest/admin-guide/md.html
>> Thanks,
>> Kuai
>>
>>>>> +
>>>>> +	memset(&newpool, 0, sizeof(newpool));
>>>>> +	memset(&oldpool, 0, sizeof(oldpool));
>>>>> +
>>>>>     	if (!mddev_is_clustered(mddev))
>>>>>     		md_allow_write(mddev);
>>> .
>>>
>>
> Thanks,
> Hu
> .
> 

