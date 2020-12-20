Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CE6C3526C
	for <linux-raid@archiver.kernel.org>; Sun, 20 Dec 2020 09:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 633462343B
	for <linux-raid@archiver.kernel.org>; Sun, 20 Dec 2020 09:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbgLTJu6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 20 Dec 2020 04:50:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:34202 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726377AbgLTJu5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 20 Dec 2020 04:50:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3483CAC7F;
        Sun, 20 Dec 2020 09:50:16 +0000 (UTC)
Subject: Re: [RFC PATCH] badblocks: Improvement badblocks_set() for handling
 multiple ranges
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Vishal L Verma <vishal.l.verma@intel.com>,
        linux-block@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        NeilBrown <neilb@suse.de>
References: <20201203171535.67715-1-colyli@suse.de>
 <CAPcyv4j6n-ZQMS3b3JoRGcr6kEFdHxtLqimyouMP93KXLZFamA@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <e58ff56f-4995-b2f6-fb0d-7b1ef8d8deb8@suse.de>
Date:   Sun, 20 Dec 2020 17:50:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j6n-ZQMS3b3JoRGcr6kEFdHxtLqimyouMP93KXLZFamA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/18/20 11:25 AM, Dan Williams wrote:
> [ add Neil, original gooodguy who wrote badblocks ]
> 
> 
> On Thu, Dec 3, 2020 at 9:16 AM Coly Li <colyli@suse.de> wrote:
>>
>> Recently I received a bug report that current badblocks code does not
>> properly handle multiple ranges. For example,
>>         badblocks_set(bb, 32, 1, true);
>>         badblocks_set(bb, 34, 1, true);
>>         badblocks_set(bb, 36, 1, true);
>>         badblocks_set(bb, 32, 12, true);
>> Then indeed badblocks_show() reports,
>>         32 3
>>         36 1
>> But the expected bad blocks table should be,
>>         32 12
>> Obviously only the first 2 ranges are merged and badblocks_set() returns
>> and ignores the rest setting range.
>>
>> This behavior is improper, if the caller of badblocks_set() wants to set
>> a range of blocks into bad blocks table, all of the blocks in the range
>> should be handled even the previous part encountering failure.
>>
>> The desired way to set bad blocks range by badblocks_set() is,
>> - Set as many as blocks in the setting range into bad blocks table.
>> - Merge the bad blocks ranges and occupy as less as slots in the bad
>>   blocks table.
>> - Fast.
>>
>> Indeed the above proposal is complicated, especially with the following
>> restrictions,
>> - The setting bad blocks range can be ackknowledged or not acknowledged.


Hi Dan,

> 
> s/ackknowledged/acknowledged/
> 
> I'd run checkpatch --codespell for future versions...

Thanks for the hint. I will do it next time.


> 
>> - The bad blocks table size is limited.
>> - Memory allocation should be avoided.
>>
>> This patch is an initial effort to improve badblocks_set() for setting
>> bad blocks range when it covers multiple already set bad ranges in the
>> bad blocks table, and to do it as fast as possible.
>>
>> The basic idea of the patch is to categorize all possible bad blocks
>> range setting combinationsinto to much less simplified and more less
>> special conditions. Inside badblocks_set() there is an implicit loop
>> composed by jumping between labels 're_insert' and 'update_sectors'. No
>> matter how large the setting bad blocks range is, in every loop just a
>> minimized range from the head is handled by a pre-defined behavior from
>> one of the categorized conditions. The logic is simple and code flow is
>> manageable.
>>
>> This patch is unfinished yet, it only improves badblocks_set() and not
>> touch badblocks_clear() and badblocks_show() yet. I post it earlier
>> because this patch will be large (more then 1000 lines of change), I
>> want more people to give me comments earlier before I go too far away.
>>
> 
> I wonder if this isn't indication that the base data structure should
> be replaced... but I have not had a chance to devote deeper thought to
> this.
> 

No existing data structure changed. Even the in-memory badblocks table I
don't change it at all. I just fix the report issue by handle more
corner cases, on-disk and in-memory stuffs are untouched and consistent.


Coly Li

> 
>> The code logic is tested as user space programmer, this patch passes
>> compiling but not tested in kernel mode yet. Right now it is only for
>> RFC purpose. I will post tested patch in further versions.
>>
>> Thank you in advance for any review or comments on this patch.
>>

[snipped]

