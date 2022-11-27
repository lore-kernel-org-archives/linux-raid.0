Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DB0C4321E
	for <linux-raid@archiver.kernel.org>; Sun, 27 Nov 2022 20:04:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiK0UEA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Nov 2022 15:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiK0UD7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Nov 2022 15:03:59 -0500
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CD6E0E
        for <linux-raid@vger.kernel.org>; Sun, 27 Nov 2022 12:03:58 -0800 (PST)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4NL00r4yD1zXLf;
        Sun, 27 Nov 2022 21:03:56 +0100 (CET)
Message-ID: <a2f9f95b-6b1d-1d0a-b1d2-6f89535ed055@thelounge.net>
Date:   Sun, 27 Nov 2022 21:03:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: change UUID of RAID devcies
Content-Language: en-US
From:   Reindl Harald <h.reindl@thelounge.net>
To:     Wol <antlists@youngman.org.uk>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <2341a2a9-b86e-f0e5-784a-05dbd474dec5@thelounge.net>
 <729bdc01-b0ae-887a-6d2a-5135d287636c@youngman.org.uk>
 <05a1161b-d798-c68f-d37c-a9fc373c6e73@thelounge.net>
 <0023fefe-aad1-e692-48dd-e354497f6e41@plouf.fr.eu.org>
 <1fb05e0f-34b7-3ec4-bc00-ec540e592f19@thelounge.net>
 <15fabdc2-b5d1-785d-b082-765d0650f475@youngman.org.uk>
 <46df9e38-e842-1b4a-2491-52961c42aefc@thelounge.net>
 <d6f7f391-ba1a-8afb-48b6-57ddb620c7c1@youngman.org.uk>
 <9c425005-ea35-6260-a476-4bf1fc6a941f@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <9c425005-ea35-6260-a476-4bf1fc6a941f@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 13.09.22 um 21:53 schrieb Reindl Harald:
> Am 13.09.22 um 21:44 schrieb Wol:
>> I don't know. I'll have to defer to the experts

than let experts talk

>> but a raid-10 across 
>> two drives has to be a plain mirror in order to provide redundancy.

a degraded RAID10 with two present drives out of 4 is not a mirror but a 
stripe - it's more or less RAID0

> So I don't know why it doesn't just change the array definition, 
> because the on-disk layout *should* be the same

the on-disk layout of a degraded RAID10 is exatcly the opposite of a 
RAID1 - it has two stripes with no bit mirrorred at all

honestly: for 8 years that i am present on this list you are always one 
of the first repsonders but don't know anything

for guessing nobody needs a mailing-list because trial&error can be done 
alone without the the response-delays of a list

