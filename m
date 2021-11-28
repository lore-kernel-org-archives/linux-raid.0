Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADAC6C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 28 Nov 2021 09:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357009AbhK1JaX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Nov 2021 04:30:23 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:14429 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357045AbhK1J2X (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 28 Nov 2021 04:28:23 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mrGQj-0006i0-Bc
        for linux-raid@vger.kernel.org; Sun, 28 Nov 2021 09:25:05 +0000
Message-ID: <1c63e476-b253-cb17-3299-f9d09453ee19@youngman.org.uk>
Date:   Sun, 28 Nov 2021 09:25:05 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Content-Language: en-US
To:     linux-raid <linux-raid@vger.kernel.org>
From:   Wols Lists <antlists@youngman.org.uk>
Subject: Nothing wrong, but is my website advice wonky?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Finally upgrading my system to raid-5 - two Seagate Ironwolves and a 
Barracuda ... :-(

As per my own advice, I added the third drive as a spare, then grew the 
array to raid-5 in two separate commands.

Trying to track what's going on, "cat /proc/mdstat" just shows two 
drives as sync'ing. "mdadm --detail" shows two active drives and a spare.

The drives are quite clearly working away - as I would expect.

So. What I *think* is happening is that my mirror is upgrading to a 
2-disk raid-5, and when that's finished it will add the spare and 
upgrade to a full 3-disk raid-5. Does that sound right?

What I *hoped* would happen (and thought *should* happen) was that it 
would spot the third drive, add it, and just resync straight away to 
full raid-5.

So at 7 or 8hrs per pass (3TB per drive) I'm now looking at my upgrade 
taking about 15 hours. Whoops.

So basically, does my scenario sound right? Would have explicitly 
changing raid-devices to 3 at the same time as converting to raid-5 
improved matters?

Okay, I'm going to build a new raid-testing computer in the near future 
so testing this sort of thing will be easy, but that is predicated on me 
finding enough time without upsetting the wife ...

Cheers,
Wol
