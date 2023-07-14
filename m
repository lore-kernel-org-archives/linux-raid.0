Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4F2C0015E
	for <linux-raid@archiver.kernel.org>; Fri, 14 Jul 2023 01:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbjGNBaL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Jul 2023 21:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjGNBaK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Jul 2023 21:30:10 -0400
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005AF2D63
        for <linux-raid@vger.kernel.org>; Thu, 13 Jul 2023 18:30:08 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4R2DRt2w1vz4f3mnw
        for <linux-raid@vger.kernel.org>; Fri, 14 Jul 2023 09:30:02 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBnHbEbpbBkGlOtNw--.60166S3;
        Fri, 14 Jul 2023 09:30:04 +0800 (CST)
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Xiao Ni <xni@redhat.com>, Song Liu <song@kernel.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
 <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
 <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <20230526111312.000065f2@linux.intel.com>
 <CAPhsuW4XKYDsEJsbJJX7mDdq_hhF1D8YLN5oyBi746EUtYVv8A@mail.gmail.com>
 <CALTww29YU+ZtbJanzB0buFfofDMv2C68EL2C_Ocr375amCAh+w@mail.gmail.com>
 <1ad13b8c-7601-bbee-3197-cdfcd87173d6@redhat.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <613f9d68-947a-2721-13eb-7fe682972607@huaweicloud.com>
Date:   Fri, 14 Jul 2023 09:30:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1ad13b8c-7601-bbee-3197-cdfcd87173d6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBnHbEbpbBkGlOtNw--.60166S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WryDXF4DurWrXF48KF15Arb_yoW8ZFy3pF
        4kt3W5ArWUXw1kJryDJ34UXFy5Jw1DG345GryUWFy7Aw4Yyr1qqrWUX3Z0gryDXFsYgw12
        vr15WFWUZF1UKa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
        xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/07/11 8:39, Xiao Ni 写道:
> 
> 在 2023/5/27 上午8:56, Xiao Ni 写道:
>> Hi all
>>
>> The attachment is the scripts.
>>
>> 1. It needs to modify the member disks and raid name in 
>> prepare_rebuild_env.sh
>> 2. It needs to modify the member disks and raid name in 01-test.sh
>> 3. Then run 01-test.sh directly
>>
> 
> Hi all
> 
> I have tried with a work around patch and can confirm this problem can't 
> be reproduced again with this patch.
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 4cdb35e54251..96d7f8048876 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6190,7 +6190,8 @@ static bool raid5_make_request(struct mddev 
> *mddev, struct bio * bi)
>                          md_write_end(mddev);
>                  return true;
>          }
> -       md_account_bio(mddev, &bi);
> +       if (rw == WRITE)
> +               md_account_bio(mddev, &bi);

After spending sometime review related code, I still can't figure out
what is wrong and how can this solves anything. ☹️

I assume your testcase doesn't involved io error, and
'rdev->recovery_offset' in only updated after sync io is done
from md_do_sync(), and 'rdev->recovery_offset' is checked while choosing
the rdev to read from analyse_stripe(). (There is a problem from
raid5_read_one_chunk() about checking 'recovery_offset', but as you
said chunk_aligned_read() is not involed here.) Hence I think it's not
possible to read data from the disk that is not recovered.

And again, I don't think there is a difference for what will be with or
without this md_account_bio().

Thanks,
Kuai
> 
>          /*
>           * Lets start with the stripe with the lowest chunk offset in 
> the first
> 
> 
> This patch only disables the accounting for non-align read requests. I 
> know it's not a good one. But the data corruption is more
> 
> serious than io accouting.
> 
> Regards
> 
> Xiao
> 
> .
> 

