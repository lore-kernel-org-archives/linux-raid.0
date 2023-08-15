Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72022C001DB
	for <linux-raid@archiver.kernel.org>; Tue, 15 Aug 2023 01:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbjHOB1a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 21:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbjHOB10 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 21:27:26 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE71B2
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 18:27:25 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RPtt04WByz4f3pFK
        for <linux-raid@vger.kernel.org>; Tue, 15 Aug 2023 09:27:20 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCXc6Z41NpkeHvxAg--.46850S3;
        Tue, 15 Aug 2023 09:27:21 +0800 (CST)
Subject: Re: [PATCH 2/2] md/raid0: Fix performance regression for large
 sequential writes
To:     Jan Kara <jack@suse.cz>, Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Neil Brown <neilb@suse.de>, "yukuai (C)" <yukuai3@huawei.com>
References: <20230814091452.9670-1-jack@suse.cz>
 <20230814092720.3931-2-jack@suse.cz>
 <7cf84094-c63f-374e-6a24-f35d0816266f@huaweicloud.com>
 <20230814131539.qlsj774c7zxzyiet@quack3>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4fe591b2-7460-6b8e-4746-cba0a3be1828@huaweicloud.com>
Date:   Tue, 15 Aug 2023 09:27:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230814131539.qlsj774c7zxzyiet@quack3>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCXc6Z41NpkeHvxAg--.46850S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWryUAFWfWFyUCw18KryrtFb_yoWrXw1fpr
        WUX3WYva1kXr9Ikws7tFWjka1Iy3W7Xr47WFWrK3s7u3Z0vr1DKayUXr409FnxXry8C34Y
        vr4jvasxWFyqv37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
        2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
        W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
        IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
        6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHU
        DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, Jan!

在 2023/08/14 21:15, Jan Kara 写道:
> On Mon 14-08-23 20:15:58, Yu Kuai wrote:
>> Hi,
>>
>> 在 2023/08/14 17:27, Jan Kara 写道:
>>> Commit f00d7c85be9e ("md/raid0: fix up bio splitting.") among other
>>> things changed how bio that needs to be split is submitted. Before this
>>> commit, we have split the bio, mapped and submitted each part. After
>>> this commit, we map only the first part of the split bio and submit the
>>> second part unmapped. Due to bio sorting in __submit_bio_noacct() this
>>> results in the following request ordering:
>>>
>>>     9,0   18     1181     0.525037895 15995  Q  WS 1479315464 + 63392
>>>
>>>     Split off chunk-sized (1024 sectors) request:
>>>
>>>     9,0   18     1182     0.629019647 15995  X  WS 1479315464 / 1479316488
>>>
>>>     Request is unaligned to the chunk so it's split in
>>>     raid0_make_request().  This is the first part mapped and punted to
>>>     bio_list:
>>>
>>>     8,0   18     7053     0.629020455 15995  A  WS 739921928 + 1016 <- (9,0) 1479315464
>>>
>>>     Now raid0_make_request() returns, second part is postponed on
>>>     bio_list. __submit_bio_noacct() resorts the bio_list, mapped request
>>>     is submitted to the underlying device:
>>>
>>>     8,0   18     7054     0.629022782 15995  G  WS 739921928 + 1016
>>>
>>>     Now we take another request from the bio_list which is the remainder
>>>     of the original huge request. Split off another chunk-sized bit from
>>>     it and the situation repeats:
>>>
>>>     9,0   18     1183     0.629024499 15995  X  WS 1479316488 / 1479317512
>>>     8,16  18     6998     0.629025110 15995  A  WS 739921928 + 1016 <- (9,0) 1479316488
>>>     8,16  18     6999     0.629026728 15995  G  WS 739921928 + 1016
>>>     ...
>>>     9,0   18     1184     0.629032940 15995  X  WS 1479317512 / 1479318536 [libnetacq-write]
>>>     8,0   18     7059     0.629033294 15995  A  WS 739922952 + 1016 <- (9,0) 1479317512
>>>     8,0   18     7060     0.629033902 15995  G  WS 739922952 + 1016
>>>     ...
>>>
>>>     This repeats until we consume the whole original huge request. Now we
>>>     finally get to processing the second parts of the split off requests
>>>     (in reverse order):
>>>
>>>     8,16  18     7181     0.629161384 15995  A  WS 739952640 + 8 <- (9,0) 1479377920
>>>     8,0   18     7239     0.629162140 15995  A  WS 739952640 + 8 <- (9,0) 1479376896
>>>     8,16  18     7186     0.629163881 15995  A  WS 739951616 + 8 <- (9,0) 1479375872
>>>     8,0   18     7242     0.629164421 15995  A  WS 739951616 + 8 <- (9,0) 1479374848
>>>     ...
>>>
>>> I guess it is obvious that this IO pattern is extremely inefficient way
>>> to perform sequential IO. It also makes bio_list to grow to rather long
>>> lengths.
>>>
>>> Change raid0_make_request() to map both parts of the split bio. Since we
>>> know we are provided with at most chunk-sized bios, we will always need
>>> to split the incoming bio at most once.
>>
>> I understand the problem now, but I'm lost here, can you explain why "at
>> most once" more ? Do you mean that the original bio won't be splited
>> again?
> 
> Yes. md_submit_bio() splits the incoming bio by bio_split_to_limits() so we
> are guaranteed raid0_make_request() gets bio at most chunk_sectors long.
> If this bio is misaligned, it will be split in raid0_make_request(). But
> after that we are sure both parts of the bio are meeting requirements of
> the raid0 code so we can just directly map them to the underlying device and
> submit them.

Thanks for the explanation, I understand this now.

Kuai
> 
> 								Honza
> 
>>> Fixes: f00d7c85be9e ("md/raid0: fix up bio splitting.")
>>> Signed-off-by: Jan Kara <jack@suse.cz>
>>> ---
>>>    drivers/md/raid0.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>>> index d3c55f2e9b18..595856948dff 100644
>>> --- a/drivers/md/raid0.c
>>> +++ b/drivers/md/raid0.c
>>> @@ -626,7 +626,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>>>    		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
>>>    					      &mddev->bio_set);
>>>    		bio_chain(split, bio);
>>> -		submit_bio_noacct(bio);
>>> +		raid0_map_submit_bio(mddev, bio);
>>>    		bio = split;
>>>    	}
>>>
>>

