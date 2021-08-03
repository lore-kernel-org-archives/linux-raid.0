Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C62C4338F
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 16:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF16F60F8F
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 16:34:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhHCQer (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Aug 2021 12:34:47 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:27972 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234060AbhHCQeo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 3 Aug 2021 12:34:44 -0400
Received: from host86-162-184-27.range86-162.btcentralplus.com ([86.162.184.27] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mAxN8-0007ST-Fu; Tue, 03 Aug 2021 17:34:31 +0100
Subject: Re: ANNOUNCE: mdadm 4.2-rc2 - A tool for managing md Soft RAID under
 Linux
To:     Jes Sorensen <jes@trained-monkey.org>,
        Felix Lechner <lechner@debian.org>
References: <23ff060b-0958-ffc5-7da6-64948ec3179c@trained-monkey.org>
 <CAFHYt56dQ6NHL+q8vbFvF4+Dq0c7ui+p64fi0uUo=game-hRMw@mail.gmail.com>
 <736a794b-26c5-4ea2-0464-3b2964684a45@trained-monkey.org>
Cc:     "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
From:   Wols Lists <antlists@youngman.org.uk>
Message-ID: <61096F94.8060201@youngman.org.uk>
Date:   Tue, 3 Aug 2021 17:32:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <736a794b-26c5-4ea2-0464-3b2964684a45@trained-monkey.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 03/08/21 15:23, Jes Sorensen wrote:
>> Finally, a question about procedure: Do you folks copy people
>> > explicitly when replying even though they are on the list? Thank you
>> > for all your hard work!

> I generally reply all, I like to have the thread directly in my inbox if
> I am on the CC list.

The raid web site asks people to follow lkml conventions of "reply all
unless otherwise requested in the sig". Not that everybody does that :-)

Cheers,
Wol
