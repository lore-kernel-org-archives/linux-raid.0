Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9487AC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 11 May 2022 15:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245234AbiEKPAc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 May 2022 11:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245528AbiEKPAV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 May 2022 11:00:21 -0400
Received: from mail.thelounge.net (mail.thelounge.net [91.118.73.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74072173F2
        for <linux-raid@vger.kernel.org>; Wed, 11 May 2022 07:59:18 -0700 (PDT)
Received: from [10.10.10.2] (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256))
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Kyyjc3WBPzXMF;
        Wed, 11 May 2022 16:59:16 +0200 (CEST)
Message-ID: <b2a3c4ec-2f86-7775-c84f-2f360ab9cfd0@thelounge.net>
Date:   Wed, 11 May 2022 16:59:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: Failed adadm RAID array after aborted Grown operation
Content-Language: en-US
From:   Reindl Harald <h.reindl@thelounge.net>
To:     Bob Brand <brand@wmawater.com.au>,
        Roger Heflin <rogerheflin@gmail.com>,
        Wols Lists <antlists@youngman.org.uk>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au>
 <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk>
 <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au>
 <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk>
 <00d101d86329$a2a57130$e7f05390$@wmawater.com.au>
 <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au>
 <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au>
 <00eb01d86339$18cc0860$4a641920$@wmawater.com.au>
 <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk>
 <CAAMCDecTb69YY+jGzq9HVqx4xZmdVGiRa54BD55Amcz5yaZo1Q@mail.gmail.com>
 <019701d864f9$7c87ab90$759702b0$@wmawater.com.au>
 <4fc8c8b4-cfc2-81b2-40d6-13c9d8c940bb@thelounge.net>
 <01f501d8653a$1ccf8420$566e8c60$@wmawater.com.au>
 <84b97e58-9884-ca0f-8186-2e046e900334@thelounge.net>
Organization: the lounge interactive design
In-Reply-To: <84b97e58-9884-ca0f-8186-2e046e900334@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 11.05.22 um 16:56 schrieb Reindl Harald:
> 
> 
> Am 11.05.22 um 15:22 schrieb Bob Brand:
>> Sorry Reindl.  I'm not sure I understand. Are you saying I did or 
>> didn't do
>> the right thing in booting from a CentOS rescue disk? At the moment it's
>> running from the rescue disk and, be it the best distro to have used (or
>> not), I would imagine that I need to keep running from the rescue disk 
>> until
>> the reshape is complete as rebooting in the middle of a reshape is 
>> what got
>> me in this mess.

and nowhere did i say reboot now

and i only responded to your "Do I understand that you would recommend 
upgrading our installation of Linux once the repair is complete or are 
advising downloading and compiling a new kernel as part of the repair?"

nobody said that - the only point was use a as recent kernel as possible 
with all rgow/reshape operations

> and i don't understand what you did not understand in the clear response 
> below you got days ago!
> 
> due reshape you where advised use whatever rescue/live system with a 
> recent kernel and mdadm, not more and not less
> 
> just to avoid probaly long fixed bugs in your old kernel
> 
> ---------------------
> 
> Try and get a CentOS 8.5 disk. At the end of the day, the version of 
> linux doesn't matter. What you need is an up-to-date rescue disk. 
> Distro/whatever is unimportant - what IS important is that you are using 
> the latest mdadm, and a kernel that matches.
> 
> The problem you have sounds like a long-standing but now-fixed bug. An 
> original CentOS disk might be okay (with matched kernel and mdadm), but 
> almost certainly has what I consider to be a "dodgy" version of mdadm.
> 
> If you can afford the downtime, after you've reverted the reshape, I'd 
> try starting it again with the rescue disk. It'll probably run fine. Let 
> it complete and then your old CentOS 7 will be fine with it
