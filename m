Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8893CC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 13 May 2022 05:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377080AbiEMFco (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 May 2022 01:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344254AbiEMFcl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 May 2022 01:32:41 -0400
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 8B0E277F00
        for <linux-raid@vger.kernel.org>; Thu, 12 May 2022 22:32:38 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id F14A719F373;
        Fri, 13 May 2022 15:32:36 +1000 (AEST)
Authentication-Results: postoffice.wmawater.com.au (amavisd-new);
        dkim=pass (1024-bit key) header.d=wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id kSs_FiJqg8bb; Fri, 13 May 2022 15:32:36 +1000 (AEST)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id C163219F375;
        Fri, 13 May 2022 15:32:36 +1000 (AEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 postoffice.wmawater.com.au C163219F375
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wmawater.com.au;
        s=1D92CC64-C1F9-11E4-96FC-2C1EC0F5F97B; t=1652419956;
        bh=6iqyYYw8gnh6u+TL3bMchTLWGmbcLZQ/tWWHjmcB93g=;
        h=From:To:Date:Message-ID:MIME-Version;
        b=DzFdJE3ZA5Ba1yBdKeTu7GuKKVI6Ko+6B7rf4JzagsFBiYedmRLfeQxmdqZg7ZRha
         hZImmhiQHb9zV/UbHpWv9NaE2C8QCUfrLpxAOnk0Zo6qMQWODtuEjXWYqHRaEuQYKo
         F7BdgTuXTb05B6f3E+WVsTh8t8vIvy+5punoO/EE=
X-Virus-Scanned: amavisd-new at wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CtRv4XeP_PLr; Fri, 13 May 2022 15:32:36 +1000 (AEST)
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 9505819F373;
        Fri, 13 May 2022 15:32:36 +1000 (AEST)
Reply-To: "Bob Brand" <brand@wmawater.com.au>
From:   Bob Brand <brand@wmawater.com.au>
To:     "Reindl Harald" <h.reindl@thelounge.net>,
        "Roger Heflin" <rogerheflin@gmail.com>,
        "Wols Lists" <antlists@youngman.org.uk>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Phil Turmel" <philip@turmel.org>, "NeilBrown" <neilb@suse.com>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au> <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk> <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au> <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk> <00d101d86329$a2a57130$e7f05390$@wmawater.com.au> <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au> <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au> <00eb01d86339$18cc0860$4a641920$@wmawater.com.au> <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk> <CAAMCDecTb69YY+jGzq9HVqx4xZmdVGiRa54BD55Amcz5yaZo1Q@mail.gmail.com> <019701d864f9$7c87ab90$759702b0$@wmawater.com.au> <4fc8c8b4-cfc2-81b2-40d6-13c9d8c940bb@thelounge.net> <01f501d8653a$1ccf8420$566e8c60$@wmawater.com.au> <84b97e58-9884-ca0f-8186-2e046e900334@thelounge.net> <b2a3c4ec-2f86-7775-c84f-2f360ab9cfd0@thelounge.net>
In-Reply-To: <b2a3c4ec-2f86-7775-c84f-2f360ab9cfd0@thelounge.net>
Subject: RE: Failed adadm RAID array after aborted Grown operation
Thread-Topic: Failed adadm RAID array after aborted Grown operation
Date:   Fri, 13 May 2022 15:32:36 +1000 (AEST)
Message-ID: <00b801d8668a$da017c00$8e047400$@wmawater.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
X-Mailer: Zimbra 8.8.15_GA_3894 (Zimbra-ZCO/9.0.0.1903 (10.0.19044  en-AU) P1de8 T376c R3438)
Thread-Index: AQK0Ylmfkg1g1mZGz7yxBx3O0op7hADpZ3mFAYMzo9kBZlg9dAGZ0oLFAdWidsoCQWnqlQI7z0N+AMQVcYoBrcfnAQIP8nq4AeCBcYMB6qMbrQH6ufUdAeBnJDOqpREc8A==
Content-Language: en-au
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This may not be the forum to ask this but what exactly is "compiling the 
kernel". From what I've been reading, it sounds like a somewhat involved and 
complex process - is it? Is compiling a new kernel the same as upgrading the 
OS? I'm getting the impression that it sort of is but sort of isn't. Is it 
possible to compile a kernel for a rescue CD (from the comments I've read, 
it is possible)? If I were to compile a new kernel, would I expect the 
version number for the kernel and mdadm to be the same? Sorry for all the 
question but, as I said at the outset, a lot of this is all very new to me.

Thank you,
Bob

-----Original Message-----
From: Reindl Harald <h.reindl@thelounge.net>
Sent: Thursday, 12 May 2022 12:59 AM
To: Bob Brand <brand@wmawater.com.au>; Roger Heflin <rogerheflin@gmail.com>; 
Wols Lists <antlists@youngman.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>; Phil Turmel 
<philip@turmel.org>; NeilBrown <neilb@suse.com>
Subject: Re: Failed adadm RAID array after aborted Grown operation



Am 11.05.22 um 16:56 schrieb Reindl Harald:
>
>
> Am 11.05.22 um 15:22 schrieb Bob Brand:
>> Sorry Reindl.  I'm not sure I understand. Are you saying I did or
>> didn't do the right thing in booting from a CentOS rescue disk? At
>> the moment it's running from the rescue disk and, be it the best
>> distro to have used (or not), I would imagine that I need to keep
>> running from the rescue disk until the reshape is complete as
>> rebooting in the middle of a reshape is what got me in this mess.

and nowhere did i say reboot now

and i only responded to your "Do I understand that you would recommend 
upgrading our installation of Linux once the repair is complete or are 
advising downloading and compiling a new kernel as part of the repair?"

nobody said that - the only point was use a as recent kernel as possible 
with all rgow/reshape operations

> and i don't understand what you did not understand in the clear
> response below you got days ago!
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
> Distro/whatever is unimportant - what IS important is that you are
> using the latest mdadm, and a kernel that matches.
>
> The problem you have sounds like a long-standing but now-fixed bug. An
> original CentOS disk might be okay (with matched kernel and mdadm),
> but almost certainly has what I consider to be a "dodgy" version of mdadm.
>
> If you can afford the downtime, after you've reverted the reshape, I'd
> try starting it again with the rescue disk. It'll probably run fine.
> Let it complete and then your old CentOS 7 will be fine with it



CAUTION!!! This E-mail originated from outside of WMA Water. Do not click 
links or open attachments unless you recognize the sender and know the 
content is safe.


