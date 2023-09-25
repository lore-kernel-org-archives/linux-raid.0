Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA2BCE7A8B
	for <linux-raid@archiver.kernel.org>; Mon, 25 Sep 2023 02:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjIYC6q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 24 Sep 2023 22:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjIYC6p (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 24 Sep 2023 22:58:45 -0400
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01A792
        for <linux-raid@vger.kernel.org>; Sun, 24 Sep 2023 19:58:38 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.143])
        by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Rv6yH1gVHz4f3jrk
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 10:58:31 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgBn+dhY9xBlKB9PBQ--.3500S3;
        Mon, 25 Sep 2023 10:58:33 +0800 (CST)
Subject: Re: fstrim on raid1 LV with writemostly PV leads to system freeze
To:     Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
Cc:     Kirill Kirilenko <kirill@ultracoder.org>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
        heinzm@redhat.com, "yukuai (C)" <yukuai3@huawei.com>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6b7c6377-c4be-a1bc-d05d-37680175f84c@huaweicloud.com>
Date:   Mon, 25 Sep 2023 10:58:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20230922030340.2eaa46bc@nvm>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgBn+dhY9xBlKB9PBQ--.3500S3
X-Coremail-Antispam: 1UD129KBjvJXoWxWF43Xr43Gw1kCF1kKrW8Crg_yoW5Gry7pr
        W0gFWakrnrXFy8Cw1kXa4kuFy0yr4aqrZrJryfZw17ZrnxWF90qan7Wa45JrnxCwsYkryj
        vw42y34DWas0qFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
        c7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

ÔÚ 2023/09/22 6:03, Roman Mamedov Ð´µÀ:
> On Thu, 21 Sep 2023 17:45:24 -0400
> Mike Snitzer <snitzer@kernel.org> wrote:
> 
>> I just verified that 6.5.0 does have this DM core fix (needed to
>> prevent excessive splitting of discard IO.. which could cause fstrim
>> to take longer for a DM device), but again 6.5.0 has this fix so it
>> isn't relevant:
>> be04c14a1bd2 dm: use op specific max_sectors when splitting abnormal io
>>
>> Given your use of 'writemostly' I'm inferring you're using lvm2's
>> raid1 that uses MD raid1 code in terms of the dm-raid target.
>>
>> Discards (more generic term for fstrim) are considered writes, so
>> writemostly really shouldn't matter... but I know that there have been
>> issues with MD's writemostly code (identified by others relatively
>> recently).
>>
>> All said: hopefully someone more MD oriented can review your report
>> and help you further.
>>
>> Mike
> 
> I've reported that write-mostly TRIM gets split into 1MB pieces, which can be
> an order of magnitude slower on some SSDs: https://www.spinics.net/lists/raid/msg72471.html

Looks like I missed the report.

Based on code review, it's very clearly where diskcard bio is splited:

raid1_write_request
  for (i = 0;  i < disks; i++)
   if (rdev && test_bit(WriteMostly, &rdev->flags))
    write_behind = true

  if (write_behind && bitmap)
   max_sectors = min_t(int, max_sectors, BIO_MAX_VECS * (PAGE_SIZE >> 9))
   // io size is 512 * (256 * (4k >> 9)) = 1M

  if (max_sectors < bio_sectors(bio))
   bio_split

Roman and Kirill, can you test the following patch?

Thanks,
Kuai

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4b30a1742162..4963f864ef99 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1345,6 +1345,7 @@ static void raid1_write_request(struct mddev 
*mddev, struct bio *bio,
         int first_clone;
         int max_sectors;
         bool write_behind = false;
+       bool is_discard = (bio_op(bio) == REQ_OP_DISCARD);

         if (mddev_is_clustered(mddev) &&
              md_cluster_ops->area_resyncing(mddev, WRITE,
@@ -1405,7 +1406,7 @@ static void raid1_write_request(struct mddev 
*mddev, struct bio *bio,
                  * write-mostly, which means we could allocate write behind
                  * bio later.
                  */
-               if (rdev && test_bit(WriteMostly, &rdev->flags))
+               if (!is_discard && rdev && test_bit(WriteMostly, 
&rdev->flags))
                         write_behind = true;

                 if (rdev && unlikely(test_bit(Blocked, &rdev->flags))) {


> 
> Nobody cared to reply, investigate or fix.
> 
> Maybe your system hasn't frozen too, just taking its time in processing all
> the tiny split requests.
> 

