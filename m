Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA7DEE14AA
	for <linux-raid@archiver.kernel.org>; Sat,  9 Sep 2023 21:31:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242373AbjIIVbC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 9 Sep 2023 17:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239339AbjIIVbC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 9 Sep 2023 17:31:02 -0400
X-Greylist: delayed 10961 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 09 Sep 2023 14:30:56 PDT
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FD4197
        for <linux-raid@vger.kernel.org>; Sat,  9 Sep 2023 14:30:56 -0700 (PDT)
Received: from host86-155-223-197.range86-155.btcentralplus.com ([86.155.223.197] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1qf2gn-0002e1-Ds;
        Sat, 09 Sep 2023 19:28:13 +0100
Message-ID: <ed6b9df8-93c6-6f5e-3a1c-7aa5b9d51352@youngman.org.uk>
Date:   Sat, 9 Sep 2023 19:28:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: all of my drives are spares
To:     David T-G <davidtg-robot@justpickone.org>,
        Linux RAID list <linux-raid@vger.kernel.org>
References: <20230908025035.GB1085@jpo> <20230909112656.GC1085@jpo>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <20230909112656.GC1085@jpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 09/09/2023 12:26, David T-G wrote:
> Hi, all --
> 
> ...and then David T-G home said...
> % Hi, all --
> %
> % After a surprise reboot the other day, I came home to find diskfarm's
> % RAID5 arrays all offline with all disks marked as spares.  wtf?!?
> [snip]
> 
> Wow ...  I'm used to responses pointing out either what I've left
> out or how stupid my setup is, but total silence ...  How did I
> offend and how can I fix it?

Sorry, it's usually me that's the quick response, everyone else takes 
ages, and I'm feeling a bit burnt out with life in general at the moment.
> 
> I sure could use advice on the current hangup before perhaps just
> destroying my entire array with the wrong commands ...
> 
I wonder if a controlled reboot would fix it. Or just do a --stop 
followed by an assemble. The big worry is the wildly varying event 
counts. Do your arrays have journals.
> 
> With fingers crossed,
> :-D

If the worst comes to the worst, try a forced assemble with the minimum 
possible drives (no redundancy). Pick the drives with the highest event 
counts. You can then re-add the remaining ones if that works.

Iirc this is actually not uncommon and it shouldn't be hard to recover 
from. I really ought to go through the archives, find a bunch of 
occasions, and write it up.

The only real worry is that the varying event counts mean that some data 
corruption is likely. Recent files, hopefully nothing important. One 
thing that's just struck me, this is often caused by a drive failing 
some while back, and then a glitch on a second drive brings the whole 
thing down. When did you last check your array was fully functional?

Cheers,
Wol
