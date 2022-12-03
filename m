Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7ABC352A1
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 05:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiLCFlg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 00:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiLCFlf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 00:41:35 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FDCD4B
        for <linux-raid@vger.kernel.org>; Fri,  2 Dec 2022 21:41:33 -0800 (PST)
Received: from [73.207.192.158] (port=34128 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1p1LHI-000473-DJ
        for linux-raid@vger.kernel.org;
        Fri, 02 Dec 2022 23:41:32 -0600
Date:   Sat, 3 Dec 2022 05:41:30 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: md vs LVM and VMs and ... (was "Re: md RAID0 can be grown (was ...")
Message-ID: <20221203054130.GP19721@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
 <20221125194932.GK19721@jpo>
 <20221128142422.GM19721@jpo>
 <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
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

Jani, et al --

...and then Jani Partanen said...
% Hi David,
% 
% Nice to see that there is others who like to take things extreme and live on
% razor edge. ;)

Heh.  And here I didn't know I was doing any such thing ...  My whole
goal was to minimize rebuild time for anything less than a full disk and
to stage rebuilds for a full-disk failure.  If these were all 100M or 1T
disks then we wouldn't be worrying about rebuild time :-/


% 
% I had different side disks, so I made raid5 so that I first joined example
% 1TB and 2TB together with md linear so I could add that as member to other
% 3TB raid5 pool.

The good news here is that I don't mix disk sizes; all of these are not
only the same size but, for the foreseeable future, the exact same model.


% 
...
% Anyway, go LVM if you are planning to slice and dice disks like before. With
% LVM later on if you add space, it will be much more simple task and LVM
% automaticly works like linear but offers much other benefits.

I'll definitely read up on it and see where I might play with learning.


% LVM is very much worth to learn. Start up virtual machine and assign
% multiple small vdisks to it and you have enviroment where it's safe to play
% around with md and lvm.
[snip]

Funny you should mention that ...  Getting into VMs has been on my
list for quite a while *sigh* :-)/2  I haven't even had the time and
opportunity to go and read a primer to boot a "Hello, world" VM.


Thanks again & HANN

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

