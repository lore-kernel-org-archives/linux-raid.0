Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9F2C433ED
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 00:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AB17611CA
	for <linux-raid@archiver.kernel.org>; Tue, 18 May 2021 00:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344731AbhERAKU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 May 2021 20:10:20 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:8306 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240964AbhERAKR (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 17 May 2021 20:10:17 -0400
Received: from host109-154-217-227.range109-154.btcentralplus.com ([109.154.217.227] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1lileO-0007eu-A0; Mon, 17 May 2021 23:23:48 +0100
Subject: Re: raid10 redundancy
To:     Phillip Susi <phill@thesusis.net>,
        Roy Sigurd Karlsbakk <roy@karlsbakk.net>
References: <CAC6SzHJLG=0_URJUsgQshpk-QLh6b8SBJDrfxiNg4wikQw4uyw@mail.gmail.com>
 <2140221131.2872520.1620837067395.JavaMail.zimbra@karlsbakk.net>
 <87a6oyr64b.fsf@vps.thesusis.net>
 <3f3fd663-77e4-8c23-eb22-1b8223eaf277@turmel.org>
 <87y2ch4c3w.fsf@vps.thesusis.net>
 <947223877.4161967.1621003717636.JavaMail.zimbra@karlsbakk.net>
 <87cztpm68z.fsf@vps.thesusis.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <60A2EC87.9080701@youngman.org.uk>
Date:   Mon, 17 May 2021 23:21:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <87cztpm68z.fsf@vps.thesusis.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/05/21 21:50, Phillip Susi wrote:
> 
> Roy Sigurd Karlsbakk writes:
> 
>> RAID10 is like RAID1+0, only a bit more fancy. That means it's
>> basically striping across mirrors. It's *not* like RAID0+1, which is
>> the other way, when you mirror two RAID0 sets. So when a drive dies in
>> a RAID10, you'll have to read from one or two other drives, depending
>> on redundancy and the number of drives (odd or even).
> 
> Yes... what does that have to do with what I said?  My point was that as
> long as you are IO bound, it doesn't make much difference between having
> to read all of the disks in the stripe for a raid6 and having to read
> some number that is possibly less than that for a raid10.  They both
> take about the same amount of time as just writing the data to the new
> disk.
> 
Possibly less? Or DEFINITELY less!

When rebuilding a mirror (of any sort), one block written requires ONE
block read. When rebuilding a parity array, one block written requires
one STRIPE read.

That's a hell of a lot more load on the machine. And when faced with a
production machine that needs to work (as opposed to a hobbyist machine
which can dedicate itself solely to a rebuild), you have the two
conflicting requirements that you need to finish the rebuild as quickly
as possible for data safety, but you also need the computer to do real
work. Minimising disk i/o is *crucial*.

This general attitude of "oh the computer can do everything, we don't
need to be efficient" is great - until it isn't. If it takes longer to
do the job than the time available, then you're in trouble ... been
there done that ...

Cheers,
Wol
