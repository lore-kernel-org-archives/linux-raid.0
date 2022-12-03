Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788A6C352A1
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 05:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiLCF62 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 00:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiLCF6U (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 00:58:20 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51311326C1
        for <linux-raid@vger.kernel.org>; Fri,  2 Dec 2022 21:58:19 -0800 (PST)
Received: from [73.207.192.158] (port=34148 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1p1LXW-0002lE-Jy
        for linux-raid@vger.kernel.org;
        Fri, 02 Dec 2022 23:58:18 -0600
Date:   Sat, 3 Dec 2022 05:58:17 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: about linear and about RAID10
Message-ID: <20221203055816.GT19721@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
 <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
 <25477.7682.651953.966662@quad.stoffel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25477.7682.651953.966662@quad.stoffel.home>
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

John, et al --

...and then John Stoffel said...
% >>>>> "Reindl" == Reindl Harald <h.reindl@thelounge.net> writes:
% 
...
% > keep it SIMPLE!
% 
% This is my mantra as well here.  For my home system, I prefer
% symplicity and robustness and performance, so I tend just use RAID1

I've finally convinced The Boss to spring for additional disks so that I
can mirror, so our two servers both have SSD mirroring; yay.  The web
server doesn't need much space, so it has a pair of 4T HDDs mirrored as
well ... but as RAID10 since I thought that that was cool.  Ah, well.


% mirrors of all my disks.  I really don't have all that much stuff I
% need lots of disk space for.  And for that I have a scratch volume.  
[snip]

Heh.  Not only do we have scratch space on diskfarm, but that's where
we have 30T-plus of data that continues to grow with every video made.
Mirroring just won't do there, both because I'd have to have little
chunks of mirror and because I don't know that I can convince her to pay
for THAT much storage (plus plugging in all of those drives).  We need
RAID5 there ... but the devices are just really frickin' huge.


Thanks & HANN

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

