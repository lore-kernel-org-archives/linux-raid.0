Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8E72C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 21 Jan 2022 16:59:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379584AbiAUQ7R (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Jan 2022 11:59:17 -0500
Received: from www18.qth.com ([69.16.238.59]:43480 "EHLO www18.qth.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382096AbiAUQ6W (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 21 Jan 2022 11:58:22 -0500
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jan 2022 11:58:21 EST
Received: from c-73-207-192-158.hsd1.ga.comcast.net ([73.207.192.158]:32986 helo=justpickone.org)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <davidtg+robot@justpickone.org>)
        id 1nAx56-00041L-Ry
        for linux-raid@vger.kernel.org; Fri, 21 Jan 2022 10:48:08 -0600
Date:   Fri, 21 Jan 2022 11:48:06 -0500
From:   David T-G <davidtg+robot@justpickone.org>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: hardware recovery and RAID5 services
Message-ID: <20220121164804.GE14596@justpickone.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Hi, all --

After the holidays and the hand surgery and the other "important"
projects, I am finally able to circle back to my 4 x 4T RAID5 disk
problem.  I've been promised that I can get 30 - 60 minutes each night
to do more poking and send responses ... but that was a week ago and here
is my first chance to sit down, so I don't know how much I believe it!

Has anyone worked with any recovery companies in the US?  One of the 4T
devices failed, possibly just because of motor issues, and one is
throwing read errors, while two are just fine.  This would probably be
easy for the right folks to fix, of course at some cost; the question is
are there any folks that you might recommend and how much is that cost.

I'd appreciate any input anyone can provide ...  Meanwhile, I'm also
refreshing myself and going through all of the steps to be able to ask
good questions and present necessary information in case I do indeed get
to scrape my knuckles against this stuff enough to recover the data.


Thanks again & HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

