Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C271CC4332F
	for <linux-raid@archiver.kernel.org>; Fri, 25 Nov 2022 19:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiKYTti (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Nov 2022 14:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiKYTtg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Nov 2022 14:49:36 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB82955A88
        for <linux-raid@vger.kernel.org>; Fri, 25 Nov 2022 11:49:34 -0800 (PST)
Received: from [73.207.192.158] (port=51144 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1oyehe-0002eX-Cc
        for linux-raid@vger.kernel.org;
        Fri, 25 Nov 2022 13:49:34 -0600
Date:   Fri, 25 Nov 2022 19:49:32 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how do i fix these RAID5 arrays?
Message-ID: <20221125194932.GK19721@jpo>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
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

Roger, et al --

...and then Roger Heflin said...
% You may not be able to grow with either linear and/or raid0 under mdadm.

Um ...  uh oh.

I did some reading and see that I had confused adding devices with
growing devices.  I'll add devs to the underlying RAID5 volumes, but
there will only ever be six devs in the RAID0 array.

What do you think of

  mdadm -A --update=devicesize /dev/md50

as discussed in

  https://serverfault.com/questions/1068788/how-to-change-size-of-raid0-software-array-by-resizing-partition

recently?


% 
% And in general I do not partition md* devices as it seems most of the time
% to not be useful especially if using lvm.

Well, yes, but I like to have a separate tiny "metadata" partition
at the end of the disk (real or virtual for consistency) where I keep
useful data.  I could live without it on the big array, though.


% 
% so here is roughly how to do it (commands may not be exact)> and assuming
% your devices are /dev/md5[0123]
% 
% PV == physical volume (a disk or md raid device generally).
% VG == volume group (a group of PV).
% LV == logical volume (a block device inside a vg made up of part of a PV or
% several PVs).
% 
% pvcreate /dev/md5[0123]
% vgcreate bigvg /dev/md5[0123]
% lvcreate -L <size> -n mylv bigvg
% 
% commands to see what is going on are : pvs, lvs, vgs.
% Then build a fs on /dev/bigvg/mylv   Note you can replace bigvg with
% whatever name you want, and same with the mylv.
[snip]

Thanks for the pointers.  I'll go off and read LVM docs and see if I
can come up to speed.


Have a great day

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

