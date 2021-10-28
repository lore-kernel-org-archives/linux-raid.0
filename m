Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1291C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 13:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A7F761038
	for <linux-raid@archiver.kernel.org>; Thu, 28 Oct 2021 13:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhJ1NwD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Oct 2021 09:52:03 -0400
Received: from www18.qth.com ([69.16.238.59]:42650 "EHLO www18.qth.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhJ1Nvu (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 28 Oct 2021 09:51:50 -0400
X-Greylist: delayed 831 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Oct 2021 09:51:50 EDT
Received: from [73.207.192.158] (port=44936 helo=justpickone.org)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1mg5Z7-0005x8-T3
        for linux-raid@vger.kernel.org; Thu, 28 Oct 2021 08:35:31 -0500
Date:   Thu, 28 Oct 2021 13:36:27 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: growing a RAID5 array by adding disks later
Message-ID: <20211028133626.GX6557@justpickone.org>
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

It's time to replace a few 4T disks in our little server.  I don't
particularly want to go back with more 4T disks (although the same
model sure are cheap these days! :-) and figure I should put in larger
drives as I go.  I am then left with weighing simple $/G vs total price;
bigger drives can be cheaper per volume but of course more overall.
My first approach is to put newer, larger drives in place and expect to
grow into the empty space when all of the old ones have been swapped out.

But ...  If I were to splurge and buy 3ea big drives to replace all of
the space that I have now, how practical is it to grow that RAID5 array
by adding additional drives later?  My eventual goal would be to get
to 8-10 devices in a RAID6 layout (two "extras"), but of course I can't
afford that today.  Do I have an easy path to get there in the long run?

[BTW, can I convert an array from RAID5 to RAID6, too?]

On the other hand, I do have the empty slots (currently filled with
scratch drives here and there), so I could both replace my aging drives
and add more and just grow this array 1) if the growth idea is practical
and 2) if I don't get to splurge.


TIA

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

