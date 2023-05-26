Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 363BEC7EE23
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 03:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjEZDPh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 May 2023 23:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjEZDPf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 May 2023 23:15:35 -0400
X-Greylist: delayed 366 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 May 2023 20:15:33 PDT
Received: from out-31.mta0.migadu.com (out-31.mta0.migadu.com [91.218.175.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13D8BB
        for <linux-raid@vger.kernel.org>; Thu, 25 May 2023 20:15:33 -0700 (PDT)
Message-ID: <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685070565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5y9QorU80nxN65V4oHWL61/zocxYd9x6fRKf8p7csao=;
        b=oOuIlt2e+AWW6qBW75hty5gDxelKZJX/om3iDoIP/5veh/okraEdfJGoI9+53LNMbQCuE2
        NV1EakOk8aEvXngKUxGcqBwRYRinsUS42ZsPl5NMSzBCg3XuEgFH60idXgJGp+uWWY/N1Z
        ALh/oeVdS85LDCw/Xo/pgW3l0QTN4lg=
Date:   Fri, 26 May 2023 11:09:24 +0800
MIME-Version: 1.0
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Xiao Ni <xni@redhat.com>, Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/26/23 09:49, Xiao Ni wrote:
> Hi all
>
> We found a problem recently. The read data is wrong when recovery happens.
> Now we've found it's introduced by patch 10764815f (md: add io accounting
> for raid0 and raid5). I can reproduce this 100%. This problem exists in
> upstream. The test steps are like this:
>
> 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
> 2. mkfs.ext4 -F $devname
> 3. mount $devname $mount_point
> 4. mdadm --incremental --fail sdd
> 5. dd if=/dev/zero of=/tmp/pythontest/file1 bs=1M count=100000
> status=progress
> 6. mdadm /dev/md126 --add /dev/sdd
> 7. create 31 processes that writes and reads. It compares the content with
> md5sum. The test will go on until the recovery stops
> 8. wait for about 10 minutes, we can see some processes report checksum is
> wrong. But if it re-read the data again, the checksum will be good.
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
> @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev *mddev,
> struct bio * bi)
>                          md_write_end(mddev);
>                  return true;
>          }
> -       md_account_bio(mddev, &bi);
> +       if (rw == READ)
> +               md_account_bio(mddev, &bi);
>
> I comment the chunk_aligned_read out and only account for read requests,
> this problem can be reproduced.

After a quick look,raid5_read_one_chunk clones bio by itself, so no need to
do it for the chunk aligned readcase. Could you pls try this?

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6120,6 +6120,7 @@static bool raid5_make_request(struct mddev *mddev, 
struct bio * bi)
        const int rw = bio_data_dir(bi);
        enum stripe_result res;
        int s, stripe_cnt;
+bool account_bio = true;

        if (unlikely(bi->bi_opf & REQ_PREFLUSH)) {
                int ret = log_handle_flush_request(conf, bi);
@@ -6148,6 +6149,7 @@static bool raid5_make_request(struct mddev *mddev, 
struct bio * bi)
        if (rw == READ && mddev->degraded == 0 &&
            mddev->reshape_position == MaxSector) {
                bi = chunk_aligned_read(mddev, bi);
+account_bio = false;
                if (!bi)
                        return true;
        }
@@ -6180,7 +6182,8 @@static bool raid5_make_request(struct mddev *mddev, 
struct bio * bi)
                        md_write_end(mddev);
                return true;
        }
-       md_account_bio(mddev, &bi);
+if (account_bio)
+md_account_bio(mddev, &bi);


Thanks,
Guoqing
