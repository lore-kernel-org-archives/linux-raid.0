Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74F5C77B73
	for <linux-raid@archiver.kernel.org>; Thu, 27 Apr 2023 07:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243064AbjD0H3d (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Apr 2023 03:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242973AbjD0H32 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Apr 2023 03:29:28 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12B6F0
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 00:29:23 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Q6Rln29XBz4f3l86
        for <linux-raid@vger.kernel.org>; Thu, 27 Apr 2023 15:13:09 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgBnDuyFIEpkLeKXIA--.56074S3;
        Thu, 27 Apr 2023 15:13:10 +0800 (CST)
Subject: Re: [question] solution for raid10 configuration concurrent with io
To:     Xiao Ni <xni@redhat.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>, logang@deltatee.com,
        guoqing.jiang@linux.dev, "yukuai (C)" <yukuai3@huawei.com>
References: <cb390b39-1b1e-04e1-55ad-2ff8afc47e1b@huawei.com>
 <CALTww2__S7y9zZ0Y2R6qOW4A_V0S0Z7Z_ixOvoe6BoGxqbnd4g@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <3ebb2a0a-3a1c-7e76-c331-f0ebfaed2634@huaweicloud.com>
Date:   Thu, 27 Apr 2023 15:13:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww2__S7y9zZ0Y2R6qOW4A_V0S0Z7Z_ixOvoe6BoGxqbnd4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgBnDuyFIEpkLeKXIA--.56074S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AF17Xw1xAF15CF18Jw48tFb_yoW8GryUp3
        yF9F1DtF4DXw4Dtr1qvF1Uur18WFWaqay3Arn5u342v393ZFZ2vayUXrW3urW3ZrZrt3yU
        ZFWUX3y5ZFy2gF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/04/27 14:53, Xiao Ni 写道:
>> for example, null-ptr-dereference:
>>
>> t1:                             t2:
>> raid10_write_request:
>>
>>    // read rdev
>>    rdev = conf->mirros[].rdev;
>>                                  raid10_remove_disk
>>                                   p = conf->mirros + number;
>>                                   rdevp = &p->rdev;
>>                                   // reset rdev
>>                                   *rdevp = NULL
>>    raid10_write_one_disk
>>     // reread rdev got NULL
>>     rdev = conf->mirrors[devnum].rdev
>>       // null-ptr-dereference
>>      mbio = bio_alloc_clone(rdev->bdev...)
>>                                   synchronize_rcu()
> 
> Hi Yu kuai
> 
> raid10_write_request adds the rdev->nr_pending with rcu lock
> protection. Can this case happen? After adding ->nr_pending, the rdev
> can't be removed.

The current rcu protection really is a mess, many places access rdev
after rcu_read_unlock()...

For the above case, noted that raid10_remove_disk is called before
nr_pending is increased, and raid10_write_one_disk() is called after
rcu_read_unlock().

t1:				t2:

raid10_write_request
  rcu_read_lock
  rdev = conf->mirros[].rdev
				raid10_remove_disk
				 ......
				 // nr_pending is 0, remove disk
  // read inside rcu
  rcu_read_unlock

  raid10_write_one_disk
  // trigger null-ptr-dereference
				synchronize_rcu()

Thanks,
Kuai
> 
>>
>> for example, data loss:
>>
>> t1:
>> // assum that rdev is NULL, and replacement is not NULL
> 
> How can trigger this? Could you give the detailed commands?
> 
> Best Regards
> Xiao Ni

