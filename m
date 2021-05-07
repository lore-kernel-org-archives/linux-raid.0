Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84347C433B4
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 03:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5258B613E4
	for <linux-raid@archiver.kernel.org>; Fri,  7 May 2021 03:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhEGD1d (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 23:27:33 -0400
Received: from mail.thelounge.net ([91.118.73.15]:34147 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbhEGD1a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 23:27:30 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 4FbwpZ10W0zXN5;
        Fri,  7 May 2021 05:26:30 +0200 (CEST)
To:     d tbsky <tbskyd@gmail.com>, Phillip Susi <phill@thesusis.net>
Cc:     Xiao Ni <xni@redhat.com>,
        list Linux RAID <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <8626adeb-696c-7778-2d5e-0718ed6aefdb@redhat.com>
 <CAC6SzHK1A=4wsbLRaYy9RTFZhda6EZs+2FjuKxahoos_zAd0iw@mail.gmail.com>
 <871rakovki.fsf@vps.thesusis.net>
 <CAC6SzHKKPCk4fOx7b2CxMWorPghRPMH3GD2v7vcC_YLKbDn7KA@mail.gmail.com>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Subject: Re: raid10 redundancy
Message-ID: <9b57e1bf-a573-e6a1-2db8-080ab05205b1@thelounge.net>
Date:   Fri, 7 May 2021 05:26:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAC6SzHKKPCk4fOx7b2CxMWorPghRPMH3GD2v7vcC_YLKbDn7KA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Am 07.05.21 um 03:47 schrieb d tbsky:
> Phillip Susi <phill@thesusis.net>
>> No, it only depends on the number of copies.  They layout just effects
>> the performance.
> 
> I thought someone test the performance of two ssd, raid-1 outperforms
> all the layout. so maybe under ssd it's not important?
> 
>> No; 2 copies means you can lose one disk and still have the other copy.
>> Where those copies are stored doesn't matter for redundancy, only performance.
> 
>   I am trying to figure out how to lose two disks without losing two
> copies. in history there are time bombs in ssd (like hp ssd made by
> samsung) caused by buggy firmware.
> if I put the orders correct, it will be safe even the same twin ssd
> died together.

forget what you try to figure out, you can't control which two disks 
fail at the same time, period

you can minimize the risk by using different disk types and/or 
distribute their age (i am doing that currently by replacing all disks 
on a backup server with two weeks between)

in case of a frimware timebomb you have no chance in case of identical 
disks and when you seek a soluton whuch survives two failures then for 
the sake of god use one which is called RAID6 and not RAID10

that you can lose two disk in a RAID10 with luck is exactly that: LUCK - 
period
