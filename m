Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A6DC433FE
	for <linux-raid@archiver.kernel.org>; Wed, 19 Oct 2022 22:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiJSW42 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Oct 2022 18:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiJSW41 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Oct 2022 18:56:27 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C88187096
        for <linux-raid@vger.kernel.org>; Wed, 19 Oct 2022 15:56:25 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Mt5gq0xdZzXSt;
        Thu, 20 Oct 2022 00:56:18 +0200 (CEST)
Message-ID: <5b2054f3-fa0c-2e9d-f5a6-e45bf755e3c7@thelounge.net>
Date:   Thu, 20 Oct 2022 00:56:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        Umang Agarwalla <umangagarwalla111@gmail.com>,
        linux-raid@vger.kernel.org
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net>
 <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 19.10.22 um 23:25 schrieb Wols Lists:
> On 19/10/2022 22:00, Reindl Harald wrote:
>>
>>
>> Am 19.10.22 um 21:30 schrieb Umang Agarwalla:
>>> Hello all,
>>>
>>> We run Linux RAID 10 in our production with 8 SAS HDDs 7200RPM.
>>> We recently got to know from the application owners that the writes on
>>> these machines get affected when there is one failed drive in this
>>> RAID10 setup, but unfortunately we do not have much data around to
>>> prove this and exactly replicate this in production.
>>>
>>> Wanted to know from the people of this mailing list if they have ever
>>> come across any such issues.
>>> Theoretically as per my understanding a RAID10 with even a failed
>>> drive should be able to handle all the production traffic without any
>>> issues. Please let me know if my understanding of this is correct or
>>> not.
>>
>> "without any issue" is nonsense by common sense
> 
> No need for the sark. And why shouldn't it be "without any issue"? 
> Common sense is usually mistaken. And common sense says to me the exact 
> opposite 

your common sense told me you can change RAID10 to RAID1 because it's 
only a metadata change not long ago

your same common sense told me years ago the "writemostly" on RAID10 
don't work as in RAID1 because RAID10 on mdraid is not the same as 
mirrored RAID0 but the same common sense pretended a few weaks ago the 
opposite

so your common sense is incompatible with my common sense and yours is 
based on assumptions while mine don#t need foreign assumptions and 
guessings because it can do them alone

in other words: keep your assumptions for your own and respond only to 
things you *know* and you have done in real life
