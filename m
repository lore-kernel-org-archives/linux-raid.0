Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3300C001DB
	for <linux-raid@archiver.kernel.org>; Tue, 15 Aug 2023 01:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbjHOBe2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 21:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233857AbjHOBeB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 21:34:01 -0400
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F47172E
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 18:33:59 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RPv1c6BWMz4f3q2p
        for <linux-raid@vger.kernel.org>; Tue, 15 Aug 2023 09:33:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP2 (Coremail) with SMTP id Syh0CgCXu28E1tpk3eDrAg--.56841S3;
        Tue, 15 Aug 2023 09:33:57 +0800 (CST)
Subject: Re: [PATCH 2/2] md/raid0: Fix performance regression for large
 sequential writes
To:     Jan Kara <jack@suse.cz>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20230814091452.9670-1-jack@suse.cz>
 <20230814092720.3931-2-jack@suse.cz>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6eec1316-c694-4479-886f-32c077d6469f@huaweicloud.com>
Date:   Tue, 15 Aug 2023 09:33:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230814092720.3931-2-jack@suse.cz>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: Syh0CgCXu28E1tpk3eDrAg--.56841S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGw4fur18Jw18Kr1DZryrWFg_yoW5Cw17pr
        W5Z3WFva1kGrn5Kan7JFW2kF4Ik3W7XrWxuFyfK3sru3ZxZryqkay8ZrW0qrnxuFy8C345
        trW0v3ZrWFyDZ37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
        8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
        2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
        xK8VAvwI8IcIk0rVW8JVW3JwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
        7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwmhFDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

ÔÚ 2023/08/14 17:27, Jan Kara Ð´µÀ:
> Commit f00d7c85be9e ("md/raid0: fix up bio splitting.") among other
> things changed how bio that needs to be split is submitted. Before this
> commit, we have split the bio, mapped and submitted each part. After
> this commit, we map only the first part of the split bio and submit the
> second part unmapped. Due to bio sorting in __submit_bio_noacct() this
> results in the following request ordering:
> 
>    9,0   18     1181     0.525037895 15995  Q  WS 1479315464 + 63392
> 
>    Split off chunk-sized (1024 sectors) request:
> 
>    9,0   18     1182     0.629019647 15995  X  WS 1479315464 / 1479316488
> 
>    Request is unaligned to the chunk so it's split in
>    raid0_make_request().  This is the first part mapped and punted to
>    bio_list:
> 
>    8,0   18     7053     0.629020455 15995  A  WS 739921928 + 1016 <- (9,0) 1479315464
> 
>    Now raid0_make_request() returns, second part is postponed on
>    bio_list. __submit_bio_noacct() resorts the bio_list, mapped request
>    is submitted to the underlying device:
> 
>    8,0   18     7054     0.629022782 15995  G  WS 739921928 + 1016
> 
>    Now we take another request from the bio_list which is the remainder
>    of the original huge request. Split off another chunk-sized bit from
>    it and the situation repeats:
> 
>    9,0   18     1183     0.629024499 15995  X  WS 1479316488 / 1479317512
>    8,16  18     6998     0.629025110 15995  A  WS 739921928 + 1016 <- (9,0) 1479316488
>    8,16  18     6999     0.629026728 15995  G  WS 739921928 + 1016
>    ...
>    9,0   18     1184     0.629032940 15995  X  WS 1479317512 / 1479318536 [libnetacq-write]
>    8,0   18     7059     0.629033294 15995  A  WS 739922952 + 1016 <- (9,0) 1479317512
>    8,0   18     7060     0.629033902 15995  G  WS 739922952 + 1016
>    ...
> 
>    This repeats until we consume the whole original huge request. Now we
>    finally get to processing the second parts of the split off requests
>    (in reverse order):
> 
>    8,16  18     7181     0.629161384 15995  A  WS 739952640 + 8 <- (9,0) 1479377920
>    8,0   18     7239     0.629162140 15995  A  WS 739952640 + 8 <- (9,0) 1479376896
>    8,16  18     7186     0.629163881 15995  A  WS 739951616 + 8 <- (9,0) 1479375872
>    8,0   18     7242     0.629164421 15995  A  WS 739951616 + 8 <- (9,0) 1479374848
>    ...
> 
> I guess it is obvious that this IO pattern is extremely inefficient way
> to perform sequential IO. It also makes bio_list to grow to rather long
> lengths.
> 
> Change raid0_make_request() to map both parts of the split bio. Since we
> know we are provided with at most chunk-sized bios, we will always need
> to split the incoming bio at most once.
> 
LGTM

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> Fixes: f00d7c85be9e ("md/raid0: fix up bio splitting.")
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>   drivers/md/raid0.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index d3c55f2e9b18..595856948dff 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -626,7 +626,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>   		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
>   					      &mddev->bio_set);
>   		bio_chain(split, bio);
> -		submit_bio_noacct(bio);
> +		raid0_map_submit_bio(mddev, bio);
>   		bio = split;
>   	}
>   
> 

