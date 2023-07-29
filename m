Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3CC1C001DC
	for <linux-raid@archiver.kernel.org>; Sat, 29 Jul 2023 07:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjG2Hhv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 29 Jul 2023 03:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjG2Hhu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 29 Jul 2023 03:37:50 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D8830FC
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 00:37:48 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RCbv96x8Rz4f3jJ0
        for <linux-raid@vger.kernel.org>; Sat, 29 Jul 2023 15:37:41 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCHLaHFwcRkhVZJPA--.63781S3;
        Sat, 29 Jul 2023 15:37:42 +0800 (CST)
Subject: Re: [PATCH v3 3/3] md/raid1: check array size before reshape
To:     Xueshi Hu <xueshi.hu@smartx.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, song@kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230719070954.3084379-1-xueshi.hu@smartx.com>
 <20230719070954.3084379-4-xueshi.hu@smartx.com>
 <30e1e157-5ce9-3c11-29e1-232756ecffec@molgen.mpg.de>
 <pgxs5btqmgxze4fs4gruhzbpu355duqbm2fpcm3gn7j6qbc5pm@pusexxy2cbzs>
 <f8f45e90-afe4-a5a3-873d-da74f426d1cc@huaweicloud.com>
 <trf4pch7vfi2srosqsccnncoropf6dtr6bdfk3mm6drpfkygih@kvsnmjsa2c4s>
 <cd264593-2258-db9f-8ba7-0a0a1e2f0f77@huaweicloud.com>
 <byhedo2kmchy6e676tfmpqvydlul5ad7kchqds2s34hmdlbu7g@5daabr77ntwb>
 <e4dd94a5-0f03-9b7b-72cf-f0ce17441815@huaweicloud.com>
 <443169b3-4e38-d4fe-0450-5d2698c65988@huaweicloud.com>
 <honxxkye2lhuzkpty2hv3jlrhd72od3mc6rcb27koeo4hq66bs@qsczyfxupqd3>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <0d683096-5084-df23-8c6d-a1725f834b3d@huaweicloud.com>
Date:   Sat, 29 Jul 2023 15:37:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <honxxkye2lhuzkpty2hv3jlrhd72od3mc6rcb27koeo4hq66bs@qsczyfxupqd3>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCHLaHFwcRkhVZJPA--.63781S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr47Xw48GFW5Xw1xJFWrKrg_yoW5tF1Upa
        s5t3Z0grWDJ3s3CrWDtr18X3yjkryUJ3y3Xr18GF17C3s8KFWIv34UXF1DuF1UXrWrKa17
        ta18JFZruF10kaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
        UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/07/29 14:16, Xueshi Hu 写道:
> On Sat, Jul 29, 2023 at 11:51:27AM +0800, Yu Kuai wrote:
>> Hi,
>>
>> 在 2023/07/29 11:36, Yu Kuai 写道:
>>> Hi,
>>>
>>> 在 2023/07/29 11:29, Xueshi Hu 写道:
>>>>>>> I think this is wrong, you should at least keep following:
>>>>>>>
>>>>>>>            set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>>>>>>>            set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>>>>>>            md_wakeup_thread(mddev->thread);
>>>>>>>
>>>>>> I fail to comprehend the rationale behind the kernel's need to invoke
>>>>>> raid1d() repeatedly despite the absence of any modifications.
>>>>>> It appears that raid1d() is responsible for invoking
>>>>>> md_check_recovery()
>>>>>> and resubmit the failed io.
>>>>>
>>>>> No, the point here is to set MD_RECOVERY_NEEDED and MD_RECOVERY_RECOVER,
>>>>> so that md_check_recovery() can start to reshape.
>>>> I apologize, but I am still unable to comprehend your idea.
>>>> If mmdev->delta_disks == 0 , what is the purpose of invoking
>>>> md_check_recovery() again?
>>>
>>> Sounds like you think raid1_reshape() can only be called from
>>> md_check_recovery(), please take a look at other callers.
> Thank you for the quick reply and patience.
> 
> Of course, I have checked all the caller of md_personality::check_reshape.
> 
> - layout_store
> - action_store
> - chunk_size_store
> - md_ioctl
> 	__md_set_array_info
> 		update_array_info
> - md_check_recovery
> - md_ioctl
> 	__md_set_array_info
> 		update_array_info
> 			update_raid_disks
> - process_metadata_update
> 	md_reload_sb
> 		check_sb_changes
> 			update_raid_disks
> - raid_disks_store
> 	update_raid_disks
> 
> There are three categories of callers except md_check_recovery().
> 1. write to sysfs
> 2. ioctl
> 3. revice instructions from md cluster peer
> 
> Using "echo 4 > /sys/devices/virtual/block/md10/md/raid_disks" as an
> example, if the mddev::raid_disks is already 4, I don't think
> raid1_reshape() should set MD_RECOVERY_RECOVER and MD_RECOVERY_NEEDED
> bit, then wake up the mddev::thread to call md_check_recovery().
> 
> Is there any counterexample to demonstrate the issues that may arise if
> md_check_recovery() is not called out of raid1_reshape() ?
> 
>>
>> And even if raid1_reshape() is called from md_check_recovery(),
>> which means reshape is interupted, then MD_RECOVERY_RECOVER
>> and MD_RECOVERY_RECOVER need to be set, so that reshape can
>> continue.
> 
> raid1 only register md_personality::check_reshape, all the work related
> with reshape are handle in md_personality::check_reshape.
> What's the meaning of "reshape can continue" ? In another word, what's
> the additional work need to do if mddev::raid_disks doesn't change ?

Okay, I missed that raid1 doesn't have 'start_reshape', reshape here
really means recovery, synchronize data to new disks. Never mind what
I said "reshape can continue", it's not possible for raid1.

Then the problem is the same from 'recovery' point of view:
if the 'recovery' is interrupted, before this patch, even if raid_disks
is the same, raid1_reshape() will still set the flag and then
md_check_recovery() will try to continue the recovery. I'd like to
keep this behaviour untill it can be sure that no user will be
affected.

Thanks,
Kuai

> 
> Thanks,
> Hu
> 
>>
>> Thanks,
>> Kuai
>>>
>>> Thanks,
>>> Kuai
>>>
>>> .
>>>
>>
> .
> 

