Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58943C77B7A
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 08:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjE2IeE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 May 2023 04:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjE2IeD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 29 May 2023 04:34:03 -0400
Received: from out-54.mta1.migadu.com (out-54.mta1.migadu.com [95.215.58.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B88AC
        for <linux-raid@vger.kernel.org>; Mon, 29 May 2023 01:34:01 -0700 (PDT)
Message-ID: <71c45b69-770a-0c28-3bd2-a4bd1a18bc2d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685349237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m45BHtMMw2H05hOfU0r+mAG/ZkF/CvV3T2U/hIPRvzM=;
        b=J+EsA8njMqheXrmyhWILwte+UMpnhHWgs3sh3Ct058ryk29bMNO99o0W7M9GAEPCUsfPsw
        3Fsby1e87Yola09P3cX4RyYeglwE7Vu0pVP3JG/HsJVViFpqtqtIoUXDtQCXf/wdAGsCSy
        Y6DbxtbWmapRmcoisJOKTXhHuH8k57Q=
Date:   Mon, 29 May 2023 16:33:52 +0800
MIME-Version: 1.0
Subject: Re: The read data is wrong from raid5 when recovery happens
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>
Cc:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
 <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
 <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <f4bff813-343f-6601-b2f8-c1c54fa1e5a1@linux.dev>
 <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CALTww29ww7sOwLFR=waX4b2bik=ZAiCW7mMEtg8jsoAHqxvHcQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/29/23 11:41, Xiao Ni wrote:
> On Mon, May 29, 2023 at 10:27 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>>
>>
>> On 5/26/23 15:23, Xiao Ni wrote:
>>>>>>> 6. mdadm /dev/md126 --add /dev/sdd
>>>>>>> 7. create 31 processes that writes and reads. It compares the content with
>>>>>>> md5sum. The test will go on until the recovery stops
>>>> Could you share the test code/script for step 7? Will try it from my side.
>>> The test scripts are written by people from intel.
>>> Hi, Mariusz. Can I share the test scripts here?
>>>
>>>>>>> 8. wait for about 10 minutes, we can see some processes report checksum is
>>>>>>> wrong. But if it re-read the data again, the checksum will be good.
>>>> So it is interim, I guess it appeared before recover was finished.
>>> Yes, it appears before recovery finishes. The test will finish once
>>> the recovery finishes.
>>>
>>>>>>> I tried to narrow this problem like this:
>>>>>>>
>>>>>>> -       md_account_bio(mddev, &bi);
>>>>>>> +       if (rw == WRITE)
>>>>>>> +               md_account_bio(mddev, &bi);
>>>>>>> If it only do account for write requests, the problem can disappear.
>>>>>>>
>>>>>>> -       if (rw == READ && mddev->degraded == 0 &&
>>>>>>> -           mddev->reshape_position == MaxSector) {
>>>>>>> -               bi = chunk_aligned_read(mddev, bi);
>>>>>>> -               if (!bi)
>>>>>>> -                       return true;
>>>>>>> -       }
>>>>>>> +       //if (rw == READ && mddev->degraded == 0 &&
>>>>>>> +       //    mddev->reshape_position == MaxSector) {
>>>>>>> +       //      bi = chunk_aligned_read(mddev, bi);
>>>>>>> +       //      if (!bi)
>>>>>>> +       //              return true;
>>>>>>> +       //}
>>>>>>>
>>>>>>>             if (unlikely(bio_op(bi) == REQ_OP_DISCARD)) {
>>>>>>>                     make_discard_request(mddev, bi);
>>>>>>> @@ -6180,7 +6180,8 @@ static bool raid5_make_request(struct mddev *mddev,
>>>>>>> struct bio * bi)
>>>>>>>                             md_write_end(mddev);
>>>>>>>                     return true;
>>>>>>>             }
>>>>>>> -       md_account_bio(mddev, &bi);
>>>>>>> +       if (rw == READ)
>>>>>>> +               md_account_bio(mddev, &bi);
>>>>>>>
>>>>>>> I comment the chunk_aligned_read out and only account for read requests,
>>>>>>> this problem can be reproduced.
>> Only write bio and non aligned chunk read bio call md_account_bio, and
>> only account write bio is fine per your test. It means the md5sum didn't match
>> because of non aligned chunk read bio, so it is not abnormal that data in another chunk could
>> be changed with the recovery is not finished, right?
> That's right, only non aligned read requests can cause this problem.
> Good catch. If I understand right, you mean the non aligned read
> request reads data from the chunk which hasn't been recovered, right?

Yes, I don't think compare md5sum for such scenario makes more sense given
the state is interim. And it also appeared in my test with disable io 
accounting.

>> BTW, I had run the test with bio accounting disabled by default, and
>> seems the result is
>> same.
>>
>>> git tag  --sort=taggerdate --contain 10764815f |head -1
>> v5.14-rc1
>>
>> localhost:~/readdata #uname -r
>> 5.15.0-rc4-59.24-default
>> localhost:~/readdata #cat /sys/block/md126/queue/iostats
>> 0
>>
>> And I can still see relevant log from the terminal which runs 01-test.sh
> Hmm, thanks for this. I'll have a try again. Which kind of disks do
> you use for testing?

Four SCSI disks (1G capacity) inside VM.

Thanks,
Guoqing
