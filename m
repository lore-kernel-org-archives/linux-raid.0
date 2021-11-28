Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A55C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 28 Nov 2021 20:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239909AbhK1U3x (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Nov 2021 15:29:53 -0500
Received: from li1843-175.members.linode.com ([172.104.24.175]:40012 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240135AbhK1U1x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Nov 2021 15:27:53 -0500
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Nov 2021 15:27:53 EST
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id CC79E20614;
        Sun, 28 Nov 2021 15:15:31 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 2C30FA7661; Sun, 28 Nov 2021 15:15:31 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24995.58211.78152.138025@quad.stoffel.home>
Date:   Sun, 28 Nov 2021 15:15:31 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Wol <antlists@youngman.org.uk>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Nothing wrong, but is my website advice wonky?
In-Reply-To: <12dd9f53-aab2-c487-9663-b799c2d0e8dd@youngman.org.uk>
References: <1c63e476-b253-cb17-3299-f9d09453ee19@youngman.org.uk>
        <12dd9f53-aab2-c487-9663-b799c2d0e8dd@youngman.org.uk>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Wol" == Wol  <antlists@youngman.org.uk> writes:

Wol> Problem solved! My usual problem of missing the detail...

How was the problem solved?  Can you provide details on the before and
after setup?  It should be trivial to test with loop back devices.

Wol> I'd described starting with a 2-drive mirror and converting it to
Wol> a 3-drive raid-5. I was actually starting with a 2-active-1-spare
Wol> mirror ...

So if you had removed the spare before hand, would it have jumped
straight to a three drive RAID 5 setup?  And curious why you didn't
goto RAID6?  RAID5 just makes me nervous these days, I don't trust it
since drives tend to fail in waves.

But in my home system, I also mostly just mirror (or even triple
mirror!) my important data for both speed and ease of recovery.  

Wol> On 28/11/2021 09:25, Wols Lists wrote:
>> Finally upgrading my system to raid-5 - two Seagate Ironwolves and a 
>> Barracuda ... :-(
>> 
>> As per my own advice, I added the third drive as a spare, then grew the 
>> array to raid-5 in two separate commands.
>> 
>> Trying to track what's going on, "cat /proc/mdstat" just shows two 
>> drives as sync'ing. "mdadm --detail" shows two active drives and a spare.
>> 
>> The drives are quite clearly working away - as I would expect.
>> 
>> So. What I *think* is happening is that my mirror is upgrading to a 
>> 2-disk raid-5, and when that's finished it will add the spare and 
>> upgrade to a full 3-disk raid-5. Does that sound right?
>> 
>> What I *hoped* would happen (and thought *should* happen) was that it 
>> would spot the third drive, add it, and just resync straight away to 
>> full raid-5.
>> 
>> So at 7 or 8hrs per pass (3TB per drive) I'm now looking at my upgrade 
>> taking about 15 hours. Whoops.
>> 
>> So basically, does my scenario sound right? Would have explicitly 
>> changing raid-devices to 3 at the same time as converting to raid-5 
>> improved matters?
>> 
>> Okay, I'm going to build a new raid-testing computer in the near future 
>> so testing this sort of thing will be easy, but that is predicated on me 
>> finding enough time without upsetting the wife ...
>> 
>> Cheers,
>> Wol
