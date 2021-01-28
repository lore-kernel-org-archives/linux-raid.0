Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E68C433E0
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jan 2021 13:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AFAE64DDE
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jan 2021 13:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhA1NNe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jan 2021 08:13:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:35916 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231948AbhA1NNX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 28 Jan 2021 08:13:23 -0500
IronPort-SDR: VZ//gs/H8SvR+ul3ngMdVqaH09E41tVXqOYL+ckFp/IjapoCUgENjXA40jWSwlI1tXnb8cXEOU
 93buWIQe6OdQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9877"; a="167325789"
X-IronPort-AV: E=Sophos;i="5.79,382,1602572400"; 
   d="scan'208";a="167325789"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 05:11:36 -0800
IronPort-SDR: iET11nVb36LishUF1mEm0DA53JARP5vym9iANZNKCvsBi61fdeViaszo8NNKns+j3nTW3Fsvi7
 2O/8UnMuAIjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,382,1602572400"; 
   d="scan'208";a="473758017"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 28 Jan 2021 05:11:36 -0800
Received: from [10.213.25.38] (jradtke-MOBL1.ger.corp.intel.com [10.213.25.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id B96DB580781;
        Thu, 28 Jan 2021 05:11:35 -0800 (PST)
Subject: Re: [PATCH] md: change bitmap offset verification in write_sb_page
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20210105150635.2551-1-jakub.radtke@linux.intel.com>
 <CAPhsuW5TdVgh2RaxxJQkdUAKm2k-Eo11fOdWk1Mti=qsu7ZzUg@mail.gmail.com>
From:   "Radtke, Jakub" <jakub.radtke@linux.intel.com>
Message-ID: <6452c7ad-9879-ef8e-3eee-88d86c951aaa@linux.intel.com>
Date:   Thu, 28 Jan 2021 14:11:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW5TdVgh2RaxxJQkdUAKm2k-Eo11fOdWk1Mti=qsu7ZzUg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: pl
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Please ignore the patch.
I see that the calculation is working for the other metadata formats too.
The problem was related to my environment, and I misinterpret the 
calculation in write_sb_page, which correctly reports the error.
> On Tue, Jan 5, 2021 at 7:06 AM Jakub Radtke
> <jakub.radtke@linux.intel.com> wrote:
>> From: Jakub Radtke <jakub.radtke@intel.com>
>>
>> Removes the code that is correct only for the native metadata.
>> Write-intent bitmap support for the other metadata formats is blocked.
>>
>> rdev->sb_start is used in the calculations.
>> The sb_start is only set and used for native metadata format, and
>> the bitmap offset check will always fail if it is not set.
> Can we use different logic for native and other metadata, so that we can
> keep the check for native metadata? Maybe we can use the combination
> of mddev->major_version, mddev->minor_version, and rdev->sb_start?
>
> Thanks,
> Song
>
>> In the case of external metadata, the bitmap can be placed in various
>> places e.g. like the PPL between two volumes (the boundary checks are
>> performed on the sysfs level and in the mdadm).
>>
>> Signed-off-by: Jakub Radtke <jakub.radtke@linux.intel.com>
>> ---
>>   drivers/md/md-bitmap.c | 8 --------
>>   1 file changed, 8 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 200c5d0f08bf..a78b15df4d82 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -236,14 +236,6 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
>>                   */
>>                  if (mddev->external) {
>>                          /* Bitmap could be anywhere. */
>> -                       if (rdev->sb_start + offset + (page->index
>> -                                                      * (PAGE_SIZE/512))
>> -                           > rdev->data_offset
>> -                           &&
>> -                           rdev->sb_start + offset
>> -                           < (rdev->data_offset + mddev->dev_sectors
>> -                            + (PAGE_SIZE/512)))
>> -                               goto bad_alignment;
>>                  } else if (offset < 0) {
>>                          /* DATA  BITMAP METADATA  */
>>                          if (offset
>> --
>> 2.17.1
>>

