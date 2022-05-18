Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B85C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 18 May 2022 10:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbiERKqN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 18 May 2022 06:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235188AbiERKqG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 18 May 2022 06:46:06 -0400
Received: from mallaury.nerim.net (smtp-103-wednesday.noc.nerim.net [178.132.17.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 982756BFC0
        for <linux-raid@vger.kernel.org>; Wed, 18 May 2022 03:46:01 -0700 (PDT)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 2C78ADB17C;
        Wed, 18 May 2022 12:57:56 +0200 (CEST)
Message-ID: <2a0092f6-f594-bbc3-cf9f-74ab10205ca3@plouf.fr.eu.org>
Date:   Wed, 18 May 2022 12:45:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: failed sector detected but disk still active ?
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
 <Yn6BEym8s0kVLhD0@lazy.lzy>
 <994cb384-3782-dac2-898b-ea02816a904f@youngman.org.uk>
 <056cdd2b-e7c7-d9dc-8e33-cb0727e70d42@plouf.fr.eu.org>
 <169db918-cdc1-e461-f484-058f41cbab87@youngman.org.uk>
 <5e0aea05-0159-a184-d5ea-dee176939b1c@plouf.fr.eu.org>
 <a58016bf-5bc2-4272-7250-33ef9b11b6b2@youngman.org.uk>
 <26b37f8d-7f6b-dc43-c494-6d4370365b27@plouf.fr.eu.org>
 <d95061c0-8332-7e70-9c53-282ecddda226@youngman.org.uk>
 <352b69a4-55dd-6c53-ae61-2506e09388f7@plouf.fr.eu.org>
 <45059b25-63e1-fa4d-f24b-e9ae70f9c47c@youngman.org.uk>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <45059b25-63e1-fa4d-f24b-e9ae70f9c47c@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 18/05/2022 à 05:43, Wols Lists a écrit :
> On 17/05/2022 22:27, Pascal Hambourg wrote:
>> Le 17/05/2022 à 21:00, Wol a écrit :
>>> On 17/05/2022 15:57, Pascal Hambourg wrote:
>>>> On the other hand, I have seen faulty drives report success on write 
>>>> to an unreadable block then failing immediate read at the same 
>>>> location.
>>>
>>> That's exactly what I'd expect from a write (as opposed to a 
>>> write-and-verify, they're not the same thing ... :-(
>>
>> Even when the drive knows that a read of this block previously failed ?
>> On the contrary I would expect from a decent drive to verify after the 
>> write and to reallocate the block if the read still fails.
> 
> The drive knows, or the OS knows? Cheap drives won't remember, 

The drive should know. It was the one which reported read failure to the 
host, ran failed offline self-tests and increased the bad block count in 
SMART attributes (Current_Pending_Sector, Offline_Uncorrectable).

Else how would it be able to decrease the bad block count in SMART 
attributes after a successful write into a bad block if it doesn't 
remember that the block was bad ?
