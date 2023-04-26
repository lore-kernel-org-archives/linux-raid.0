Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9F5C77B78
	for <linux-raid@archiver.kernel.org>; Wed, 26 Apr 2023 19:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbjDZTPF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Apr 2023 15:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235121AbjDZTO7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 Apr 2023 15:14:59 -0400
X-Greylist: delayed 402 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Apr 2023 12:14:46 PDT
Received: from out-45.mta0.migadu.com (out-45.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EABB7687
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 12:14:46 -0700 (PDT)
Message-ID: <7c1ff2cb-22da-3a44-c1c9-27bb400bcc80@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682536082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HoE3PkadtGKlDL1OMwUAN93vfAXfSIDOindskyxHnJ4=;
        b=SLGr7ZxKe4Lsyyxup9e3sDY6UXyr4Oa7a/l+4natrEQHoZvh6QtD/bCAc6FqZhYpHsy95l
        FLWq9YfD8pBP1yArtx6eGEzm4Ip7vV4oar7smvGMZzRIMu5AEeFmBCL8Vwdc5wvWavF0lW
        waNxSJH7iOwjgdriKK+djxKqCVW0ZEo=
Date:   Wed, 26 Apr 2023 13:08:00 -0600
MIME-Version: 1.0
Subject: Re: [PATCH] md: Fix bitmap offset type in sb writer
To:     Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org,
        Dan Carpenter <dan.carpenter@linaro.org>,
        Sushma Kalakota <sushma.kalakota@intel.com>,
        "Michael Kropaczek (CW)" <Michael.Kropaczek@solidigm.com>,
        Sushma Kalakota <sushma.kalakota@solidigm.com>
References: <20230425011438.71046-1-jonathan.derrick@linux.dev>
 <CAPhsuW6f+6nqqaap1pP_rETSk_WA68keq6wCxEJojkYcVw-Vhw@mail.gmail.com>
 <CAPhsuW5LMzsus-nvNCj2Fy71cTW04rEN=bwcynqDHc7zrEYxCg@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
In-Reply-To: <CAPhsuW5LMzsus-nvNCj2Fy71cTW04rEN=bwcynqDHc7zrEYxCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

On 4/26/2023 11:58 AM, Song Liu wrote:
> Hi Jonathan,
> 
> On Tue, Apr 25, 2023 at 8:44 PM Song Liu <song@kernel.org> wrote:
>>
>> On Mon, Apr 24, 2023 at 6:16 PM Jonathan Derrick
>> <jonathan.derrick@linux.dev> wrote:
>>>
>>> Bitmap offset is allowed to be negative, indicating that bitmap precedes
>>> metadata. Change the type back from sector_t to loff_t to satisfy
>>> conditionals and calculations.
> 
> This actually breaks the following tests from mdadm:
> 
> 05r1-add-internalbitmap-v1a
> 05r1-internalbitmap-v1a
> 05r1-remove-internalbitmap-v1a
> 
> Please look into these.
> 
I no longer work for Solidigm and don't have access to equipment that 
can test this. I'm CCing Sushma and Michael who should be able to test 
and report back.

Thanks,
Jon

> Thanks,
> Song
> 
>>>
>>> Signed-off-by: Jonathan Derrick <jonathan.derrick@linux.dev>
>>
>> I added the following to the patch and applied it to md-next.
>>
>> Thanks,
>> Song
>>
>> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
>> Fixes: 10172f200b67 ("md: Fix types in sb writer")
>>
>>> ---
>>>   drivers/md/md-bitmap.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>> index 920bb68156d2..29ae7f7015e4 100644
>>> --- a/drivers/md/md-bitmap.c
>>> +++ b/drivers/md/md-bitmap.c
>>> @@ -237,8 +237,8 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>>>          struct block_device *bdev;
>>>          struct mddev *mddev = bitmap->mddev;
>>>          struct bitmap_storage *store = &bitmap->storage;
>>> -       sector_t offset = mddev->bitmap_info.offset;
>>> -       sector_t ps, sboff, doff;
>>> +       loff_t sboff, offset = mddev->bitmap_info.offset;
>>> +       sector_t ps, doff;
>>>          unsigned int size = PAGE_SIZE;
>>>          unsigned int opt_size = PAGE_SIZE;
>>>
>>> --
>>> 2.40.0
>>>
