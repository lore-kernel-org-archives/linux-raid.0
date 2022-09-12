Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A4D8ECAAD5
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 08:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiILIRB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 04:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiILIQ7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 04:16:59 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B8925EB8
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 01:16:58 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MQzw81sY8zXLZ;
        Mon, 12 Sep 2022 10:16:56 +0200 (CEST)
Message-ID: <fe532dc9-daef-e096-f729-d1cd752f18d2@thelounge.net>
Date:   Mon, 12 Sep 2022 10:16:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: 3 way mirror
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
 <53f5754d-e3e2-a8ba-bedb-07eb2b594595@thelounge.net>
 <CAJH6TXi=pCvV2xcyWcOD4KVDP6BcoPdgdMqhSwyW9BMVEhtzYA@mail.gmail.com>
 <dcef59a2-b8f6-ef8b-2fd6-2c8bfdfba4ad@thelounge.net>
 <2bcebfce-6def-38f8-99be-1f5702905f94@youngman.org.uk>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <2bcebfce-6def-38f8-99be-1f5702905f94@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 11.09.22 um 20:08 schrieb Wols Lists:
> On 11/09/2022 13:20, Reindl Harald wrote:
>>
>>
>> Am 11.09.22 um 13:35 schrieb Gandalf Corvotempesta:
>>> Il giorno dom 11 set 2022 alle ore 12:52 Reindl Harald
>>> <h.reindl@thelounge.net> ha scritto:
>>>> just throw it out of the array - on a RAID 1 with two disk you have
>>>> still redundancy and i won't trust a disk which recognized that it has
>>>> errors on it's own
>>>
>>> Why ? if it's just a single sector, the rest of the disk could be used
>>> properly until the replacement.
>>
>> i simply don't trust drives which have thrown errors
>> you don't lose anything when you push it out of the array
> 
> That's called paranoia

that's called common sense

> ALL drives have hiccups when there's absolutely 
> nothing wrong with them. What are the manufacturer's error figures? 
> Expect at least one error every two or three complete passes of pretty 
> much every large big disk nowadays?
i don't expect any SMART error at all and if one hits after years of 
uptime fine that the drive don't fail completly - but would i trust it? no!
