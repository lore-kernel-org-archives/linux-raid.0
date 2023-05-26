Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF137C77B7A
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 02:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjEZCR7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 May 2023 22:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbjEZCR5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 May 2023 22:17:57 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632A8187
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 19:17:53 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QS7qd0zs1z4f3kJr
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 10:17:49 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgCX_7LMFnBkwPHmKA--.53086S3;
        Fri, 26 May 2023 10:17:50 +0800 (CST)
Subject: Re: Fwd: The read data is wrong from raid5 when recovery happens
To:     Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <1dd27191-a4c7-101a-1d1b-5f71503756a6@huaweicloud.com>
Date:   Fri, 26 May 2023 10:17:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALTww2_4pS=wF6tR0rVejg1ocyGhkTJic0aA=WCcTXDh+cZXQQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgCX_7LMFnBkwPHmKA--.53086S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ur18GFyDAF1kWr48WF15Jwb_yoW5Jr1xpa
        9xXanxtrWkJa4fGasrJasavryjq393Zr9Iq3yUKw1xAwn8trZ3Z340qr4rWF9rJryrWr4F
        vanrWFWUGrW2ga7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
        c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1zuWJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

在 2023/05/26 10:08, Xiao Ni 写道:
> I received an email that this email can't delivered to someone. Resent
> it to linux-raid again.
> 
> ---------- Forwarded message ---------
> From: Xiao Ni <xni@redhat.com>
> Date: Fri, May 26, 2023 at 9:49 AM
> Subject: The read data is wrong from raid5 when recovery happens
> To: Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@linux.dev>
> Cc: linux-raid <linux-raid@vger.kernel.org>, Heinz Mauelshagen
> <heinzm@redhat.com>, Nigel Croxon <ncroxon@redhat.com>
> 
> 
> Hi all
> 
> We found a problem recently. The read data is wrong when recovery
> happens. Now we've found it's introduced by patch 10764815f (md: add
> io accounting for raid0 and raid5). I can reproduce this 100%. This
> problem exists in upstream. The test steps are like this:
> 
> 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
> 2. mkfs.ext4 -F $devname
> 3. mount $devname $mount_point
> 4. mdadm --incremental --fail sdd
> 5. dd if=/dev/zero of=/tmp/pythontest/file1 bs=1M count=100000 status=progress
> 6. mdadm /dev/md126 --add /dev/sdd
Can you try to zero superblock before add sdd? just to bypass readd.

Thanks,
Kuai
> 7. create 31 processes that writes and reads. It compares the content
> with md5sum. The test will go on until the recovery stops
> 8. wait for about 10 minutes, we can see some processes report
> checksum is wrong. But if it re-read the data again, the checksum will
> be good.
> 
> I tried to narrow this problem like this:
> 
> -       md_account_bio(mddev, &bi);
> +       if (rw == WRITE)
> +               md_account_bio(mddev, &bi);
> If it only do account for write requests, the problem can disappear.
> 
> -       if (rw == READ && mddev->degraded == 0 &&
> -           mddev->reshape_position == MaxSector) {
> -               bi = chunk_aligned_read(mddev, bi);
> -               if (!bi)
> -                       return true;
> -       }
> +       //if (rw == READ && mddev->degraded == 0 &&
> +       //    mddev->reshape_position == MaxSector) {
> +       //      bi = chunk_aligned_read(mddev, bi);
> +       //      if (!bi)
> +       //              return true;
> +       //}
> 
>          if (unlikely(bio_op(bi) == REQ_OP_DISCARD)) {
>                  make_discard_request(mddev, bi);
> @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev
> *mddev, struct bio * bi)
>                          md_write_end(mddev);
>                  return true;
>          }
> -       md_account_bio(mddev, &bi);
> +       if (rw == READ)
> +               md_account_bio(mddev, &bi);
> 
> I comment the chunk_aligned_read out and only account for read
> requests, this problem can be reproduced.
> 

