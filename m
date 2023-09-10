Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA60EEE57CC
	for <linux-raid@archiver.kernel.org>; Sun, 10 Sep 2023 02:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbjIJC4D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 9 Sep 2023 22:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbjIJC4C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 9 Sep 2023 22:56:02 -0400
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634031B5
        for <linux-raid@vger.kernel.org>; Sat,  9 Sep 2023 19:55:57 -0700 (PDT)
Received: from [73.207.192.158] (port=49014 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1qfAcA-00040i-2G
        for linux-raid@vger.kernel.org;
        Sat, 09 Sep 2023 21:55:56 -0500
Date:   Sun, 10 Sep 2023 02:55:55 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: all of my drives are spares
Message-ID: <20230910025554.GD1085@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <20230908025035.GB1085@jpo>
 <20230909112656.GC1085@jpo>
 <ed6b9df8-93c6-6f5e-3a1c-7aa5b9d51352@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed6b9df8-93c6-6f5e-3a1c-7aa5b9d51352@youngman.org.uk>
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

Wol, et al --

...and then Wol said...
% On 09/09/2023 12:26, David T-G wrote:
% > 
% > Wow ...  I'm used to responses pointing out either what I've left
% > out or how stupid my setup is, but total silence ...  How did I
% > offend and how can I fix it?
% 
% Sorry, it's usually me that's the quick response, everyone else takes ages,

True!


% and I'm feeling a bit burnt out with life in general at the moment.

Oh!  Sorry to hear that.  Not much I can do from here, but I can think
you a hug :-)  I hope things look up soon.


% > 
% > I sure could use advice on the current hangup before perhaps just
% > destroying my entire array with the wrong commands ...
% 
% I wonder if a controlled reboot would fix it. Or just do a --stop followed

I've tried a couple of reboots; they're stuck that way.  I'll try the
stop and assemble.


% by an assemble. The big worry is the wildly varying event counts. Do your
% arrays have journals.

No, I don't think so, unless they're created automagically.  Alas, I
don't recall the exact creation command :-/

How can I check for usre?  The -D flag output doesn't mention a journal,
whether enabled or missing.


% > 
% > With fingers crossed,
% > :-D
% 
% If the worst comes to the worst, try a forced assemble with the minimum
% possible drives (no redundancy). Pick the drives with the highest event
% counts. You can then re-add the remaining ones if that works.

Hmmmmm ...  For a RAID5 array, the minimum would be one left out, right?
So five instead of all six.  And the event counts seem to be three and
three, which is interesting but also doesn't point to any one favorite to
drop :-/


% 
% Iirc this is actually not uncommon and it shouldn't be hard to recover from.
% I really ought to go through the archives, find a bunch of occasions, and
% write it up.

In your copious free time :-)  That would, indeed, be awesome.


% 
% The only real worry is that the varying event counts mean that some data
% corruption is likely. Recent files, hopefully nothing important. One thing

Gaaaaah!

Fortunately, everything is manually mirrored out to external drives, so
if everything did go tits-up I could reload.  I'll come up with a diff
using the externals as the sources and check ... eventually.


% that's just struck me, this is often caused by a drive failing some while
% back, and then a glitch on a second drive brings the whole thing down. When
% did you last check your array was fully functional?

Let me get back to you on that.  It's actually been a couple of weeks in
this state just waiting to get to it; life has been interesting here,
too.  But I have a heartbeat script that might have captured happy data
...  These are all pretty new drives after the 4T drive disaster a year
(or two?) ago, so they *should* be OK.


% 
% Cheers,
% Wol


Thanks again & stay tuned

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

