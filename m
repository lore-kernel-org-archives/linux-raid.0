Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED62C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 17:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64F6C60FD9
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 17:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344043AbhERRj7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 13:39:59 -0400
Received: from mail.thelounge.net ([91.118.73.15]:22279 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237923AbhERRj7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 13:39:59 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4Fl3Bk6hJ5zXN3;
        Tue, 18 May 2021 19:38:38 +0200 (CEST)
Subject: Re: raid10 redundancy
To:     Phillip Susi <phill@thesusis.net>,
        Wols Lists <antlists@youngman.org.uk>
Cc:     Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net>
 <87a6oyr64b.fsf@vps.thesusis.net>
 <3f3fd663-77e4-8c23-eb22-1b8223eaf277@turmel.org>
 <87y2ch4c3w.fsf@vps.thesusis.net>
 <947223877.4161967.1621003717636.JavaMail.zimbra@karlsbakk.net>
 <87cztpm68z.fsf@vps.thesusis.net> <60A2EC87.9080701@youngman.org.uk>
 <874kf0yq31.fsf@vps.thesusis.net>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <b27c2f22-a88e-520f-57ef-bc84afb938c3@thelounge.net>
Date:   Tue, 18 May 2021 19:38:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <874kf0yq31.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 18.05.21 um 18:05 schrieb Phillip Susi:
> 
> Wols Lists writes:
> 
>> When rebuilding a mirror (of any sort), one block written requires ONE
>> block read. When rebuilding a parity array, one block written requires
>> one STRIPE read.
> 
> Again, we're in agreement here.  What you keep ignoring is the fact that
> both of these take the same amount of time, provided that you are IO bound.
> 
>> That's a hell of a lot more load on the machine. And when faced with a
>> production machine that needs to work (as opposed to a hobbyist machine
>> which can dedicate itself solely to a rebuild), you have the two
>> conflicting requirements that you need to finish the rebuild as quickly
>> as possible for data safety, but you also need the computer to do real
>> work. Minimising disk i/o is *crucial*.
> 
> That is true, it does put less load on the machine giving it more time
> to perform other tasks, but your original argument was that it is more
> likely to fail during a rebuild.  I suppose if you take the two together
> and assume the machine is busy servicing other tasks while doing the
> rebuild, then both are probably going to slow down somewhat leading to
> the rebuild taking a little longer, but I have a hard time believing
> that it is going to be 2-3 times longer, or that it is really very
> likely of having a second failure in that time.

it's common sense that additional load on drives which have the same 
history makes a failure one one of them more likely
