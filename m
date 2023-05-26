Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F065AC77B7C
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 07:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242320AbjEZHMF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 03:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242180AbjEZHME (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 03:12:04 -0400
Received: from out-14.mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787659E
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 00:12:02 -0700 (PDT)
Message-ID: <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685085120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=678Dpb2U5Mzwp0mqtRaqlHqASOKouM8EvvtbA6jNAhA=;
        b=t4YjCrHUspJuutdOkjrIfceNjOz4UR5wMMnDChxuGss0eCUJHjNqfG34eAPZkmmpSWoB7h
        w+HNc0yOHoXrtJ3Q3n7m4YsaQG99gxFBs6DMXYraP9GEZW+UiLYJ0jpKPAuPw/c/urBPbV
        0qq9r5FfwvFxfpnqoz0ll+9PddTWlnc=
Date:   Fri, 26 May 2023 15:12:01 +0800
MIME-Version: 1.0
Subject: Re: The read data is wrong from raid5 when recovery happens
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
 <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/26/23 14:45, Xiao Ni wrote:
> On Fri, May 26, 2023 at 11:09 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>
>>
>> On 5/26/23 09:49, Xiao Ni wrote:
>>> Hi all
>>>
>>> We found a problem recently. The read data is wrong when recovery happens.
>>> Now we've found it's introduced by patch 10764815f (md: add io accounting
>>> for raid0 and raid5). I can reproduce this 100%. This problem exists in
>>> upstream. The test steps are like this:
>>>
>>> 1. mdadm -CR $devname -l5 -n4 /dev/sd[b-e] --force --assume-clean
>>> 2. mkfs.ext4 -F $devname
>>> 3. mount $devname $mount_point
>>> 4. mdadm --incremental --fail sdd
>>> 5. dd if=/dev/zero of=/tmp/pythontest/file1 bs=1M count=100000 status=progress

I suppose /tmp is the mount point.

>>> 6. mdadm /dev/md126 --add /dev/sdd
>>> 7. create 31 processes that writes and reads. It compares the content with
>>> md5sum. The test will go on until the recovery stops

Could you share the test code/script for step 7? Will try it from my side.

>>> 8. wait for about 10 minutes, we can see some processes report checksum is
>>> wrong. But if it re-read the data again, the checksum will be good.

So it is interim, I guess it appeared before recover was finished.

>>> I tried to narrow this problem like this:
>>>
>>> -       md_account_bio(mddev, &bi);
>>> +       if (rw == WRITE)
>>> +               md_account_bio(mddev, &bi);
>>> If it only do account for write requests, the problem can disappear.
>>>
>>> -       if (rw == READ && mddev->degraded == 0 &&
>>> -           mddev->reshape_position == MaxSector) {
>>> -               bi = chunk_aligned_read(mddev, bi);
>>> -               if (!bi)
>>> -                       return true;
>>> -       }
>>> +       //if (rw == READ && mddev->degraded == 0 &&
>>> +       //    mddev->reshape_position == MaxSector) {
>>> +       //      bi = chunk_aligned_read(mddev, bi);
>>> +       //      if (!bi)
>>> +       //              return true;
>>> +       //}
>>>
>>>           if (unlikely(bio_op(bi) == REQ_OP_DISCARD)) {
>>>                   make_discard_request(mddev, bi);
>>> @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev *mddev,
>>> struct bio * bi)
>>>                           md_write_end(mddev);
>>>                   return true;
>>>           }
>>> -       md_account_bio(mddev, &bi);
>>> +       if (rw == READ)
>>> +               md_account_bio(mddev, &bi);
>>>
>>> I comment the chunk_aligned_read out and only account for read requests,
>>> this problem can be reproduced.
>> After a quick look,raid5_read_one_chunk clones bio by itself, so no need to
>> do it for the chunk aligned readcase. Could you pls try this?

[...]

>> Hi Guoqing
>>
>> When chunk_aligned_read runs successfully, it just returns. In this
>> case, it does the account by itself. If it fails to execute, it still
>> needs run md_account_bio in raid5_make_request. So now the logic
>> should be right.

Hmm, I was confused.

Thanks,
Guoqing
