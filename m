Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E120C433E1
	for <linux-raid@archiver.kernel.org>; Tue, 30 Mar 2021 03:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AECA619A6
	for <linux-raid@archiver.kernel.org>; Tue, 30 Mar 2021 03:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhC3DOk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:14:40 -0400
Received: from u17383850.onlinehome-server.com ([74.208.250.170]:54674 "EHLO
        u17383850.onlinehome-server.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229762AbhC3DNv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 29 Mar 2021 23:13:51 -0400
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id A451A79C; Mon, 29 Mar 2021 23:13:48 -0400 (EDT)
Date:   Mon, 29 Mar 2021 23:13:48 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: why won't this RAID5 device start?
Message-ID: <20210330031348.GE1415@justpickone.org>
References: <20210328021451.GB1415@justpickone.org>
 <6060D8AA.9030504@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6060D8AA.9030504@youngman.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Wol, et al --

...and then Wols Lists said...
% 
% On 28/03/21 03:14, David T-G wrote:
% > 
...
% > system is running.  Soooooo ...  Where do I start?
% > 
% >   diskfarm:~ # cat /proc/mdstat 
% >   Personalities : [raid6] [raid5] [raid4] 
% >   md0 : active raid5 sdc1[3] sdd1[4] sdb1[0]
% >         11720265216 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U_UU]
% 
% This looks wrong - is this supposed to be a four-drive array? U_UU
% implies a missing drive ... as does [4/3]

Yep :-(  I sent a separate note about that one.


% >         
% >   md127 : inactive sdl2[0](S) sdj2[3](S) sdf2[1](S)
% >         2196934199 blocks super 1.2
% >          
...
% >   diskfarm:~ # mdadm --examine /dev/sd[fjl]2 | egrep '/dev|Name|Role|State|Checksum|Events|UUID'
% >   /dev/sdf2:
...
% >            Events : 720
% >      Device Role : Active device 1
% >      Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
% >   /dev/sdj2:
...
% >            Events : 177792
% >      Device Role : Active device 2
% >      Array State : A.A ('A' == active, '.' == missing, 'R' == replacing)
% >   /dev/sdl2:
...
% >            Events : 177794
% >      Device Role : Active device 0
% >      Array State : A.. ('A' == active, '.' == missing, 'R' == replacing)
% > 
% > Slice f2 looks great, but slices j2 & l2 seem to be missing -- even though
% > they are present.  Worse, the Events counter on sdf2 is frighteningly
% > small.  Where did it go?!?  So maybe I consider sdf2 failed and reassemble
% > from the other two [only] and then put f2 back in?
% 
% Yes I'm afraid so. I'd guess you've been running a failed raid-5 for
% ages, and because something hiccuped when you shut it down, the two good
% drives drifted apart, and now they won't start ...

Arrrgh :-(  I was afraid of that ...


% > 
% > Definitely time to stop, take a deep breath, and ask for help :-)
% > 
% Read up about overlays on the web site, use an overlay to force-assemble

Ouch.  I tried that with a hiccup a few years ago and never really got it
down.  This is gonna take some reading again ...


% the two good drives, run fsck etc to check everything's good (you might
% lose a bit of data, hopefully very little), then if everything looks
% okay do it for real. Ie force-assemble the two good drives, then re-add

It looks like I want

  mdadm --assemble --force /dev/md127 /dev/sd[jl]2

for that based on the Go Wrong page and Go Wrogn collection.  Does that
sound right?


% the third. I'd just do a quick smartctl health check on all three drives
% first, just to make sure nothing is obviously wrong with them - a

That looks good, although perhaps quite simple:

  diskfarm:~ # for D in /dev/sd[fjl] ; do echo "### $D" ; smartctl --health $D ; done
  ### /dev/sdf
  smartctl 7.0 2019-05-21 r4917 [x86_64-linux-5.3.18-lp152.63-default] (SUSE RPM)
  Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

  === START OF READ SMART DATA SECTION ===
  SMART overall-health self-assessment test result: PASSED

  ### /dev/sdj
  smartctl 7.0 2019-05-21 r4917 [x86_64-linux-5.3.18-lp152.63-default] (SUSE RPM)
  Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

  === START OF READ SMART DATA SECTION ===
  SMART overall-health self-assessment test result: PASSED

  ### /dev/sdl
  smartctl 7.0 2019-05-21 r4917 [x86_64-linux-5.3.18-lp152.63-default] (SUSE RPM)
  Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

  === START OF READ SMART DATA SECTION ===
  SMART overall-health self-assessment test result: PASSED

But --info is longer and still doesn't give THAT much info, so maybe this
is fine :-)


% problem could kill your array completely! Then add the third drive back
% in (whether you use --add or --re-add probably won't make much difference).

OK.


% 
% Oh - and fix whatever is wrong with md0, too, before that dies on you!

Yeah, about that ...  Haven't seen any replies there yet :-/


% 
% Cheers,
% Wol


Thanks again & HANN

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

