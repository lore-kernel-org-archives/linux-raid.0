Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B23ECAAA1
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 09:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiILJks (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 05:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiILJkr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 05:40:47 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4CD6342
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 02:40:46 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4MR1mr1s9wzXLZ;
        Mon, 12 Sep 2022 11:40:44 +0200 (CEST)
Message-ID: <e5aabf02-3735-b1eb-d349-e4f1c7bb9d18@thelounge.net>
Date:   Mon, 12 Sep 2022 11:40:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: 3 way mirror
Content-Language: en-US
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
 <53f5754d-e3e2-a8ba-bedb-07eb2b594595@thelounge.net>
 <CAJH6TXi=pCvV2xcyWcOD4KVDP6BcoPdgdMqhSwyW9BMVEhtzYA@mail.gmail.com>
 <dcef59a2-b8f6-ef8b-2fd6-2c8bfdfba4ad@thelounge.net>
 <2bcebfce-6def-38f8-99be-1f5702905f94@youngman.org.uk>
 <fe532dc9-daef-e096-f729-d1cd752f18d2@thelounge.net>
 <20220912142624.63ba4b5c@nvm>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <20220912142624.63ba4b5c@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Am 12.09.22 um 11:26 schrieb Roman Mamedov:
> On Mon, 12 Sep 2022 10:16:55 +0200
> Reindl Harald <h.reindl@thelounge.net> wrote:
> 
>>> That's called paranoia
>>
>> that's called common sense
>>
>>> ALL drives have hiccups when there's absolutely
>>> nothing wrong with them. What are the manufacturer's error figures?
>>> Expect at least one error every two or three complete passes of pretty
>>> much every large big disk nowadays?
>> i don't expect any SMART error at all and if one hits after years of
>> uptime fine that the drive don't fail completly - but would i trust it? no!
> 
> I have multiple drives (Hitachi) which have developed around 3 to 10
> reallocated sectors, and then just continue to work for years, not increasing
> those further. Throwing them away would be uneconomical. 

better safe than sorry

in the past 15 years i replaced 6 drives on 8 machines (each 4 disks) 
while some are running since 2011

on every location with machines i am resposible for is at least one 
replacment disk, switch, order a new reserve disk, case closed

> Generally though, if you are way too concerned about individual drive failures,
> it could be a sign that you do not have a robust enough backup scheme in place

my backup scheme is perfect but my personal lifetime is much more worth 
than a disk costs these days - the backups are regulary testet and in 
the past 20 years i didn't need them which is a good thing

no backup on this planet contains the last 30 minutes of work besides 
that outtakes typically happen in the moment where you have no time to 
deal with such events

come on a restore a backup in a production environment, your customers 
will be not much thankful when they lose the last 30 minutes of all 
mails and work....
