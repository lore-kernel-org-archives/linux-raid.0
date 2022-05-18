Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62405C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 18 May 2022 03:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiERDql (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 May 2022 23:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiERDqi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 May 2022 23:46:38 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74416386
        for <linux-raid@vger.kernel.org>; Tue, 17 May 2022 20:46:30 -0700 (PDT)
Received: from host86-156-102-78.range86-156.btcentralplus.com ([86.156.102.78] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nrAak-0009S9-3w;
        Wed, 18 May 2022 04:43:18 +0100
Message-ID: <45059b25-63e1-fa4d-f24b-e9ae70f9c47c@youngman.org.uk>
Date:   Wed, 18 May 2022 04:43:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: failed sector detected but disk still active ?
Content-Language: en-GB
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>
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
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <352b69a4-55dd-6c53-ae61-2506e09388f7@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/05/2022 22:27, Pascal Hambourg wrote:
> Le 17/05/2022 à 21:00, Wol a écrit :
>> On 17/05/2022 15:57, Pascal Hambourg wrote:
>>> On the other hand, I have seen faulty drives report success on write 
>>> to an unreadable block then failing immediate read at the same location.
>>
>> That's exactly what I'd expect from a write (as opposed to a 
>> write-and-verify, they're not the same thing ... :-(
> 
> Even when the drive knows that a read of this block previously failed ?
> On the contrary I would expect from a decent drive to verify after the 
> write and to reallocate the block if the read still fails.

The drive knows, or the OS knows? Cheap drives won't remember, 
Enterprise drives maybe. Unless the OS explicitly asks for a "write and 
verify", it's unlikely to happen, and cheap drives probably won't even 
recognise such a request.

Cheers,
Wol
