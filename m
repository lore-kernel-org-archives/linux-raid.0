Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC16BC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 30 Sep 2021 11:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A25BF615E0
	for <linux-raid@archiver.kernel.org>; Thu, 30 Sep 2021 11:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350400AbhI3LY7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 30 Sep 2021 07:24:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:25448 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350387AbhI3LY6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 30 Sep 2021 07:24:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="247700891"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="247700891"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 04:23:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="618079649"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 30 Sep 2021 04:23:11 -0700
Received: from [10.249.135.75] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.135.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 9B56D5808E0;
        Thu, 30 Sep 2021 04:23:10 -0700 (PDT)
Subject: Re: [PATCH 1/2] md, raid1, raid10: Set MD_BROKEN for RAID1 and RAID10
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com>
 <20210917153452.5593-2-mariusz.tkaczyk@linux.intel.com>
 <CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com>
 <CAPhsuW4HZFaPgKx68mDeWE0F7SAjpnXmHL0TzN1SuZD6_Kds-w@mail.gmail.com>
 <83f06776-891f-dffa-7449-4128c419ada9@linux.intel.com>
 <CAPhsuW7mi9KZBVH8YuUvvbCv8k-82tb=jJnkxU0RJXhj+OxXjg@mail.gmail.com>
 <d41df432-e4e1-9567-b0e6-14736407d808@linux.intel.com>
 <5fc3bc1c-8e12-8d85-64c2-81cd44016073@linux.intel.com>
 <CAPhsuW6PNfCXzYYpPLv3R8LOoK2n+v3u_XDg1sXOpaOONnPU4Q@mail.gmail.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <b42f86e1-f81d-4579-c5f5-443a3386ca63@linux.intel.com>
Date:   Thu, 30 Sep 2021 13:23:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6PNfCXzYYpPLv3R8LOoK2n+v3u_XDg1sXOpaOONnPU4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,
On 29.09.2021 03:29, Song Liu wrote:
>>>>>>>
>>>>>>>>                            set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>>>>>>>>                            set_bit(LastDev, &rdev->flags);
>>>>>>>>                    }
>>>>>>>> @@ -2979,7 +2980,8 @@ state_store(struct md_rdev *rdev, const char *buf,
>>>>>>>> size_t len)
>>>>>>>>            int err = -EINVAL;
>>>>>>>>            if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>>>>>>>>                    md_error(rdev->mddev, rdev);
>>>>>>>> -               if (test_bit(Faulty, &rdev->flags))
>>>>>>>> +
>>>>>>>> +               if (!test_bit(MD_BROKEN, &rdev->mddev->flags))
>>>>>>>
>>>>>>> I don't think this makes much sense. EBUSY for already failed array
>>>>>>> sounds weird.
>>>>>>> Also, shall we also set MD_BROKEN here?
>>>>>>>
>>>>>> Actually, we just called md_error above, so we don't need to set MD_BROKEN
>>>>>> here.
>>>>>> But we shouldn't return EBUSY in such cases, right?
>>>>>>
>>>>> About EBUSY:
>>>>> This is how it is implemented in mdadm, we are expecting it in
>>>>> case of failure. See my fix[2].
>>>>> I agree that it can be confusing, but this is how it is working.
>>>>> Do you want to change it across mdadm and md?
>>>>> This will break compatibility.
>>>>>
>>>>> About MD_BROKEN:
>>>>> As you see we are determining failure by checking rdev state, if "Faulty"
>>>>> in flags after md_error() is not set, then it assumes that array is
>>>>> failed and EBUSY is returned to userspace.
>>>>
>>>> This changed the behavior for raid0, no?
>>>>
>>>> W/o the change mdadm --fail on raid0 will get EBUSY. W/ this change,
>>>> it will get 0, and the device is NOT marked as faulty, right?
>>>>
>>> See commit mentioned in description. MD_BROKEN is used for raid0,
>>> so EBUSY is returned, same as w/o patch.
> 
> Hmm... I am still confused. In state_store(), md_error is a no-op for raid0,
> which will not set Faulty or MD_BROKEN. So we will get -EBUSY w/o
> the patch and 0 w/ the patch, no? It is probably not a serious issue though.
> 
>
Yeah, you are right. There is no error_handler. I missed that.
Now, I reviewed raid0 again.

With my change result won't be clear for raid0, it is correlated with IO.
When drive disappears and there is IO, then it could return -EBUSY,
raid0_make_request() may set MD_BROKEN first.
In there is no IO then 0 will be returned. I need to close this gap.
Thanks for your curiosity.

So, please tell me, are you ok with idea of this patch? I will send
requested details with v2 but I want to know if I choose good way to close
raid5 issue, which is a main problem.

Thanks,
Mariusz


