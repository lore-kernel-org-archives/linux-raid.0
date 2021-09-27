Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A714C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 27 Sep 2021 14:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0668C60FD7
	for <linux-raid@archiver.kernel.org>; Mon, 27 Sep 2021 14:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbhI0O4J (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 27 Sep 2021 10:56:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:46184 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234782AbhI0O4I (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 27 Sep 2021 10:56:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="224522286"
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="224522286"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 07:54:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="486172493"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga008.jf.intel.com with ESMTP; 27 Sep 2021 07:54:30 -0700
Received: from [10.213.2.76] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.2.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id D9F8F580677;
        Mon, 27 Sep 2021 07:54:29 -0700 (PDT)
Subject: Re: [PATCH 1/2] md, raid1, raid10: Set MD_BROKEN for RAID1 and RAID10
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20210917153452.5593-1-mariusz.tkaczyk@linux.intel.com>
 <20210917153452.5593-2-mariusz.tkaczyk@linux.intel.com>
 <CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com>
 <CAPhsuW4HZFaPgKx68mDeWE0F7SAjpnXmHL0TzN1SuZD6_Kds-w@mail.gmail.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <83f06776-891f-dffa-7449-4128c419ada9@linux.intel.com>
Date:   Mon, 27 Sep 2021 16:54:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAPhsuW4HZFaPgKx68mDeWE0F7SAjpnXmHL0TzN1SuZD6_Kds-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,
Thank for review.

On 24.09.2021 23:15, Song Liu wrote:
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index c322841d4edc..ac20eb2ddff7 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -926,8 +926,9 @@ static void super_written(struct bio *bio)
>>>                  pr_err("md: %s gets error=%d\n", __func__,
>>>                         blk_status_to_errno(bio->bi_status));
>>>                  md_error(mddev, rdev);
>>> -               if (!test_bit(Faulty, &rdev->flags)
>>> -                   && (bio->bi_opf & MD_FAILFAST)) {
>>> +               if (!test_bit(Faulty, &rdev->flags) &&
>>> +                    !test_bit(MD_BROKEN, &mddev->flags) &&
>>> +                    (bio->bi_opf & MD_FAILFAST)) {
>>
>> So with MD_BROKEN, we will not try to update the SB?
Array is dead, is there added value in writing failed state?

For external arrays failed state is not written, because drive is
not removed from MD device and metadata manager cannot detect array
failure. This is how it was originally implemented (expect raid5 but I
aligned it around two years ago[1]). I tried to make it consistent for
everyone but I failed. Second patch restores possibility to remove
drive by kernel for raid5 so failed state will be detected (for external)
again.
So, maybe I should drop this change for native. What do you think?

>>
>>>                          set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>>>                          set_bit(LastDev, &rdev->flags);
>>>                  }
>>> @@ -2979,7 +2980,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>>>          int err = -EINVAL;
>>>          if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>>>                  md_error(rdev->mddev, rdev);
>>> -               if (test_bit(Faulty, &rdev->flags))
>>> +
>>> +               if (!test_bit(MD_BROKEN, &rdev->mddev->flags))
>>
>> I don't think this makes much sense. EBUSY for already failed array
>> sounds weird.
>> Also, shall we also set MD_BROKEN here?
>>
> Actually, we just called md_error above, so we don't need to set MD_BROKEN here.
> But we shouldn't return EBUSY in such cases, right?
>
About EBUSY:
This is how it is implemented in mdadm, we are expecting it in
case of failure. See my fix[2].
I agree that it can be confusing, but this is how it is working.
Do you want to change it across mdadm and md?
This will break compatibility.

About MD_BROKEN:
As you see we are determining failure by checking rdev state, if "Faulty"
in flags after md_error() is not set, then it assumes that array is
failed and EBUSY is returned to userspace.

I changed verification to checking MD_BROKEN flag instead. It is
potentially harmful for raid1 and raid10 as old way is working well but
main target was to unify it across levels. Current verification method
is not flexible enough for raid5 (second patch).
Small benefit is that new IO will be failed faster, in md_submit_io().

Thanks,
Mariusz

[1] https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=fb73b3
[2] https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=cb8f5371
