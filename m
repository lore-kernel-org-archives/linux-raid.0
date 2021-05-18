Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E57C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 00:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C66661359
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 00:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239113AbhERANx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 May 2021 20:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237199AbhERANx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 May 2021 20:13:53 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EF2C061573
        for <linux-raid@vger.kernel.org>; Mon, 17 May 2021 17:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XA9TcDHgVffi4WkCcGA/tJ2lqF5eEwVDDnDf4PaLsgI=; b=ZZ/LeXpyOq3PU983L1aymmn8P8
        nwnTIl0yWoiqjoqiUnVy+v0DkBcUkJTO57LVrUBJEtzHJfX1XTWlZB4o94Ui9AhsjwlX3S5xPqPwS
        o/7HHJIylksCHFy5Oh/7jSss46ySnbzSAtkg+tLmK7doxwpzj1nfF9cTFm7H/LOeyxbQqfNkUPBVf
        RK4KKDRB+43000Ak/RnSao1Un2TmvXgEtzInk6eUUKOo+bRTmnP52765agOOw0ZasuicFhO0mm77u
        4xxU1POJ+szXYSp8wGaE0cy5C2pXIQZoDcHPQpUUrSkAhMyXlEdIJzKCD+6E+/w1ILvdP1srDJe/s
        FzXogJoA==;
Received: from c-73-43-58-214.hsd1.ga.comcast.net ([73.43.58.214] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1linLd-00022Y-9H; Tue, 18 May 2021 00:12:33 +0000
Subject: Re: raid10 redundancy
To:     Wols Lists <antlists@youngman.org.uk>,
        Phillip Susi <phill@thesusis.net>,
        Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net>
 <87a6oyr64b.fsf@vps.thesusis.net>
 <3f3fd663-77e4-8c23-eb22-1b8223eaf277@turmel.org>
 <87y2ch4c3w.fsf@vps.thesusis.net>
 <947223877.4161967.1621003717636.JavaMail.zimbra@karlsbakk.net>
 <87cztpm68z.fsf@vps.thesusis.net> <60A2EC87.9080701@youngman.org.uk>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <9ea829e3-b6b6-0bf7-328a-7f30bee26cc6@turmel.org>
Date:   Mon, 17 May 2021 20:12:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <60A2EC87.9080701@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/17/21 6:21 PM, Wols Lists wrote:
> On 17/05/21 21:50, Phillip Susi wrote:
>>
>> Roy Sigurd Karlsbakk writes:
>>
>>> RAID10 is like RAID1+0, only a bit more fancy. That means it's
>>> basically striping across mirrors. It's *not* like RAID0+1, which is
>>> the other way, when you mirror two RAID0 sets. So when a drive dies in
>>> a RAID10, you'll have to read from one or two other drives, depending
>>> on redundancy and the number of drives (odd or even).
>>
>> Yes... what does that have to do with what I said?  My point was that as
>> long as you are IO bound, it doesn't make much difference between having
>> to read all of the disks in the stripe for a raid6 and having to read
>> some number that is possibly less than that for a raid10.  They both
>> take about the same amount of time as just writing the data to the new
>> disk.
>>
> Possibly less? Or DEFINITELY less!
> 
> When rebuilding a mirror (of any sort), one block written requires ONE
> block read. When rebuilding a parity array, one block written requires
> one STRIPE read.
> 
> That's a hell of a lot more load on the machine. And when faced with a
> production machine that needs to work (as opposed to a hobbyist machine
> which can dedicate itself solely to a rebuild), you have the two
> conflicting requirements that you need to finish the rebuild as quickly
> as possible for data safety, but you also need the computer to do real
> work. Minimising disk i/o is *crucial*.
> 
> This general attitude of "oh the computer can do everything, we don't
> need to be efficient" is great - until it isn't. If it takes longer to
> do the job than the time available, then you're in trouble ... been
> there done that ...
> 
> Cheers,
> Wol
> 

And don't forget the CPU load computing parity and syndrome.  Which can 
be significant even if the machine isn't loaded down with real work.
