Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A031AC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 24 Nov 2022 21:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKXVK0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Nov 2022 16:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKXVKZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Nov 2022 16:10:25 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAC891C29
        for <linux-raid@vger.kernel.org>; Thu, 24 Nov 2022 13:10:22 -0800 (PST)
Received: from [73.207.192.158] (port=49590 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1oyJUH-0000eM-9V
        for linux-raid@vger.kernel.org;
        Thu, 24 Nov 2022 15:10:21 -0600
Date:   Thu, 24 Nov 2022 21:10:20 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how do i fix these RAID5 arrays?
Message-ID: <20221124211019.GE19721@jpo>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124032821.628cd042@nvm>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www18.qth.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - justpickone.org
X-Get-Message-Sender-Via: www18.qth.com: authenticated_id: dmail@justpickone.org
X-Authenticated-Sender: www18.qth.com: dmail@justpickone.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Roman, et al --

...and then Roman Mamedov said...
% On Wed, 23 Nov 2022 22:07:36 +0000
% David T-G <davidtg-robot@justpickone.org> wrote:
% 
% >   diskfarm:~ # mdadm -D /dev/md50
...
% >          0       9       51        0      active sync   /dev/md/51
% >          1       9       52        1      active sync   /dev/md/52
% >          2       9       53        2      active sync   /dev/md/53
% >          3       9       54        3      active sync   /dev/md/54
% >          4       9       55        4      active sync   /dev/md/55
% >          5       9       56        5      active sync   /dev/md/56
% 
% It feels you haven't thought this through entirely. Sequential writes to this

Well, it's at least possible that I don't know what I'm doing.  I'm just
a dumb ol' Sys Admin, and career-changed out of the biz a few years back
to boot.  I'm certainly open to advice.  Would changing the default RAID5
or RAID0 stripe size help?


...
% 
% mdraid in the "linear" mode, or LVM with one large LV across all PVs (which
% are the individual RAID5 arrays), or multi-device Btrfs using "single" profile
% for data, all of those would avoid the described effect.

How is linear different from RAID0?  I took a quick look but don't quite
know what I'm reading.  If that's better then, hey, I'd try it (or at
least learn more).

I've played little enough with md, but I haven't played with LVM at all.
I imagine that it's fine to mix them since you've suggested it.  Got any
pointers to a good primer? :-)

I don't want to try BtrFS.  That's another area where I have no experience,
but from what I've seen and read I really don't want to go there yet.


% 
% But I should clarify, the entire idea of splitting drives like this seems
% questionable to begin with, since drives more often fail entirely, not in part,
...
% complete loss of data anyway. Not to mention what you have seems like an insane
% amount of complexity.

To make a long story short, my understanding of a big problem with RAID5
is that rebuilds take a ridiculously long time as the devices get larger.
Using smaller "devices", like partitions of the actual disk, helps get
around that.  If I lose an entire disk, it's no worse than replacing an
entire disk; it's half a dozen rebuilds but at least in small chunks we
can also manage.  If I have read errors or bad sector problems on just a
part, I can toss in a 2T disk to "spare" that piece until I get another
large drive and replace each piece.

As I also understand it, since I wasn't a storage engineer but did have
to automate against big shiny arrays, striping together RAID5 volumes is
pretty straightforward and pretty common.  Maybe my problem is that I
need a couple of orders of magnitude more drives, though.

The whole idea is to allow fault tolerance while also allowing recovery,
with growth by adding another device every once in a while pretty simple.


% 
% To summarize, maybe it's better to blow away the entire thing and restart from
% the drawing board, while it's not too late? :)

I'm open to that idea as well, as long as I can understand where I'm
headed :-)  But what's best?


% 
% >   diskfarm:~ # mdadm -D /dev/md5[13456] | egrep '^/dev|active|removed'
...
% > that are obviously the sdk (new disk) slice.  If md52 were also broken,
% > I'd figure that the disk was somehow unplugged, but I don't think I can
...
% > and then re-add them to build and grow and finalize this?
% 
% If you want to fix it still, without dmesg it's hard to say how this could
% have happened, but what does
% 
%   mdadm --re-add /dev/md51 /dev/sdk51
% 
% say?

Only that it doesn't like the stale pieces:

  diskfarm:~ # dmesg | egrep sdk
  [    8.238044] sd 9:2:0:0: [sdk] 19532873728 512-byte logical blocks: (10.0 TB/9.10 TiB)
  [    8.238045] sd 9:2:0:0: [sdk] 4096-byte physical blocks
  [    8.238051] sd 9:2:0:0: [sdk] Write Protect is off
  [    8.238052] sd 9:2:0:0: [sdk] Mode Sense: 00 3a 00 00
  [    8.238067] sd 9:2:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  [    8.290084]  sdk: sdk51 sdk52 sdk53 sdk54 sdk55 sdk56 sdk128
  [    8.290747] sd 9:2:0:0: [sdk] Attached SCSI removable disk
  [   17.920802] md: kicking non-fresh sdk51 from array!
  [   17.923119] md/raid:md52: device sdk52 operational as raid disk 3
  [   18.307507] md: kicking non-fresh sdk53 from array!
  [   18.311051] md: kicking non-fresh sdk54 from array!
  [   18.314854] md: kicking non-fresh sdk55 from array!
  [   18.317730] md: kicking non-fresh sdk56 from array!

Does it look like --re-add will be safe?  [Yes, maybe I'll start over,
but clearing this problem would be a nice first step.]


% 
% -- 
% With respect,
% Roman


Thanks again & HAND & Happy Thanksgiving in the US

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

