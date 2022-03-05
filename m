Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AC8C433F5
	for <linux-raid@archiver.kernel.org>; Sat,  5 Mar 2022 05:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiCEFB3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Mar 2022 00:01:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiCEFB2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 5 Mar 2022 00:01:28 -0500
X-Greylist: delayed 809 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Mar 2022 21:00:36 PST
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B690E243151
        for <linux-raid@vger.kernel.org>; Fri,  4 Mar 2022 21:00:36 -0800 (PST)
Received: from [73.207.192.158] (port=39162 helo=justpickone.org)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1nQMJv-0003cx-PZ
        for linux-raid@vger.kernel.org; Fri, 04 Mar 2022 22:47:06 -0600
Date:   Fri, 4 Mar 2022 23:47:04 -0500
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID <linux-raid@vger.kernel.org>
Subject: striping 2x500G to mirror 1x1T
Message-ID: <20220305044704.GB4455@justpickone.org>
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

I have a 1T data drive (currently in use with data) that I'd like to
mirror with a pair of 500G drives striped together.  I'll be mirroring
two partitions, and I'll be striping partitions to ensure the correct
size, and my understanding is that I'll have to create the mirror on the
two new drives with half missing, mount it up, copy over the data, dump
the original disk, and add it as the other half of the mirror to sync.
If I've missed anything there, please let me know, but all of that
matches my Googling and I don't think I have any questions.

What I do wonder, and what I don't see in any searches since apparently
nobody talks about striping up half of a mirror, is if I should do
anything special with my two-disk RAID0 stripe.  I was gobsmacked at
the simplicity of RAID10 on only two drives by splitting each in half
and "flipping" one to maximize head movement performance.  Awesome! :-)
Are there any brilliant hacks for simple striping?  If I'm just putting
together two [not terribly large] disks, will I benefit from any other
funny stuff, or should I just stripe together two partitions -- each
half the size of my other drive, of course -- to make a "boring basic"
stripe and run with that?


TIA & HANW

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

