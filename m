Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E4ECC77B7C
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 02:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbjE2C0H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 May 2023 22:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjE2C0G (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 May 2023 22:26:06 -0400
Received: from out-43.mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991A7A0
        for <linux-raid@vger.kernel.org>; Sun, 28 May 2023 19:26:01 -0700 (PDT)
Message-ID: <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685327159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pPDo/ZcLc0d1TgiqTByecyVWhQMBozq4f6ExMlHyOOM=;
        b=FFkwqYYlrS7LGhNbcOSgFkXMiIsvJN3NAZIguAunq/DoFOGyZI0H28lcrSJog+n3eRla3V
        huhSimJ0TkAUVCNaPgPaSyzwtpijMipIRn8zX7qyQUaAm9AE/jxL6+RkTjWmj+h1akV8aw
        FF6CjFYKuNKzYBCVCp4hLx0I6FActdg=
Date:   Mon, 29 May 2023 10:25:51 +0800
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: The read data is wrong from raid5 when recovery happens
To:     Xiao Ni <xni@redhat.com>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>
Cc:     Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
 <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
 <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/26/23 15:23, Xiao Ni wrote:
>
>>>>> 6. mdadm /dev/md126 --add /dev/sdd
>>>>> 7. create 31 processes that writes and reads. It compares the content with
>>>>> md5sum. The test will go on until the recovery stops
>> Could you share the test code/script for step 7? Will try it from my side.
> The test scripts are written by people from intel.
> Hi, Mariusz. Can I share the test scripts here?
>
>>>>> 8. wait for about 10 minutes, we can see some processes report checksum is
>>>>> wrong. But if it re-read the data again, the checksum will be good.
>> So it is interim, I guess it appeared before recover was finished.
> Yes, it appears before recovery finishes. The test will finish once
> the recovery finishes.
>
>>>>> I tried to narrow this problem like this:
>>>>>
>>>>> -       md_account_bio(mddev, &bi);
>>>>> +       if (rw == WRITE)
>>>>> +               md_account_bio(mddev, &bi);
>>>>> If it only do account for write requests, the problem can disappear.
>>>>>
>>>>> -       if (rw == READ && mddev->degraded == 0 &&
>>>>> -           mddev->reshape_position == MaxSector) {
>>>>> -               bi = chunk_aligned_read(mddev, bi);
>>>>> -               if (!bi)
>>>>> -                       return true;
>>>>> -       }
>>>>> +       //if (rw == READ && mddev->degraded == 0 &&
>>>>> +       //    mddev->reshape_position == MaxSector) {
>>>>> +       //      bi = chunk_aligned_read(mddev, bi);
>>>>> +       //      if (!bi)
>>>>> +       //              return true;
>>>>> +       //}
>>>>>
>>>>>            if (unlikely(bio_op(bi) == REQ_OP_DISCARD)) {
>>>>>                    make_discard_request(mddev, bi);
>>>>> @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev *mddev,
>>>>> struct bio * bi)
>>>>>                            md_write_end(mddev);
>>>>>                    return true;
>>>>>            }
>>>>> -       md_account_bio(mddev, &bi);
>>>>> +       if (rw == READ)
>>>>> +               md_account_bio(mddev, &bi);
>>>>>
>>>>> I comment the chunk_aligned_read out and only account for read requests,
>>>>> this problem can be reproduced.

Only write bio and non aligned chunk read bio call md_account_bio, and 
only account
write bio is fine per your test. It means the md5sum didn't match 
because of non aligned
chunk read bio, so it is not abnormal that data in another chunk could 
be changed with
the recovery is not finished, right?

BTW, I had run the test with bio accounting disabled by default, and 
seems the result is
same.

> git tag  --sort=taggerdate --contain 10764815f |head -1
v5.14-rc1

localhost:~/readdata #uname -r
5.15.0-rc4-59.24-default
localhost:~/readdata #cat /sys/block/md126/queue/iostats
0

And I can still see relevant log from the terminal which runs 01-test.sh

file /tmp/pythontest/data.out.nhoBR6 Test failed 
(org_checksum|checksum_to_match) [582df4ccea6f5851462379fe4b17abf6 
  -|d41d8cd98f00b204e9800998ec
f8427e  -]
file /tmp/pythontest/data.out.nhoBR6 calculate checksum again: 
d41d8cd98f00b204e9800998ecf8427e  -

file /tmp/pythontest/data.out.srGqF9 Test failed 
(org_checksum|checksum_to_match) [7a85ec35b171e52ce41ebdd5da86f1d9 
  -|d41d8cd98f00b204e9800998ec
f8427e  -]
file /tmp/pythontest/data.out.srGqF9 calculate checksum again: 
d41d8cd98f00b204e9800998ecf8427e  -
...

file /tmp/pythontest/data.out.q6m1kK Test failed 
(org_checksum|checksum_to_match) [996f5bb5d2a2ddfd378a80a563ab4ad5 
  -|d41d8cd98f00b204e9800998ec
f8427e  -]
file /tmp/pythontest/data.out.q6m1kK calculate checksum again: 
d41d8cd98f00b204e9800998ecf8427e  -

Rebuild ended, testing done!
stresstest end at : Sun May 28 22:23:53 EDT 2023
Sun May 28 22:23:53 EDT 2023

Thanks,
Guoqing
