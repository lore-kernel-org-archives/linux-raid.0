Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89A1CC4332F
	for <linux-raid@archiver.kernel.org>; Wed, 19 Oct 2022 21:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbiJSVZM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Oct 2022 17:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiJSVZJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Oct 2022 17:25:09 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDB91217C4
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 14:25:06 -0700 (PDT)
Received: from host86-161-232-249.range86-161.btcentralplus.com ([86.161.232.249] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1olGYj-000All-A0;
        Wed, 19 Oct 2022 22:25:05 +0100
Message-ID: <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
Date:   Wed, 19 Oct 2022 22:25:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
To:     Reindl Harald <h.reindl@thelounge.net>,
        Umang Agarwalla <umangagarwalla111@gmail.com>,
        linux-raid@vger.kernel.org
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19/10/2022 22:00, Reindl Harald wrote:
> 
> 
> Am 19.10.22 um 21:30 schrieb Umang Agarwalla:
>> Hello all,
>>
>> We run Linux RAID 10 in our production with 8 SAS HDDs 7200RPM.
>> We recently got to know from the application owners that the writes on
>> these machines get affected when there is one failed drive in this
>> RAID10 setup, but unfortunately we do not have much data around to
>> prove this and exactly replicate this in production.
>>
>> Wanted to know from the people of this mailing list if they have ever
>> come across any such issues.
>> Theoretically as per my understanding a RAID10 with even a failed
>> drive should be able to handle all the production traffic without any
>> issues. Please let me know if my understanding of this is correct or
>> not.
> 
> "without any issue" is nonsense by common sense

No need for the sark. And why shouldn't it be "without any issue"? 
Common sense is usually mistaken. And common sense says to me the exact 
opposite - with a drive missing that's one fewer write, so if anything 
it should be quicker.

Given that - on the system my brother was using - the ops guys didn't 
notice their raid-6 was missing TWO drives, it seems like lost drives 
aren't particularly noticeable by their absence ...

Okay, with a drive missing it's DANGEROUS, but it should not have any 
noticeable impact on a production system until you replace the drive and 
it's rebuilding.

Unfortunately, I don't know enough to say whether a missing drive would, 
or should, impact performance.

Cheers,
Wol
