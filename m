Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C99DC636CD
	for <linux-raid@archiver.kernel.org>; Sun,  5 Feb 2023 04:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBEEE2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 4 Feb 2023 23:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBEEE1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 4 Feb 2023 23:04:27 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C113B1EFE2
        for <linux-raid@vger.kernel.org>; Sat,  4 Feb 2023 20:04:25 -0800 (PST)
Received: from [73.207.192.158] (port=47110 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1pOWGN-0006ry-Lh
        for linux-raid@vger.kernel.org;
        Sat, 04 Feb 2023 22:04:23 -0600
Date:   Sun, 5 Feb 2023 04:04:18 +0000
From:   David Thorburn-Gundlach <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: throughput testing (was "Re: how to know a hard drive will mix well")
Message-ID: <20230205040418.GK25616@jpo>
References: <20230202124306.GH25616@jpo>
 <CAAMCDedK==A1q-S97=MZGL2Wv_COC4DCGqh__2atSOHk2YBWAg@mail.gmail.com>
 <20230204022019.GI25616@jpo>
 <CAAMCDeerQZyrUG2FAn-y1MA-grb+zDotAYrJvBykqDBhFmAfeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMCDeerQZyrUG2FAn-y1MA-grb+zDotAYrJvBykqDBhFmAfeQ@mail.gmail.com>
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
% On Fri, Feb 3, 2023 at 8:22 PM David Thorburn-Gundlach <
% davidtg-robot@justpickone.org> wrote:
% >
% > % not notice it, unless you are running your array right at the limit.
% >
% > Hmmph.  I'm not entirely sure I'm not anyway, but it is just a little PC
% > mobo running primary and daughtercard SATA ports.  A Real Server (tm) is
% > far, far beyond the current horizon :-)
% 
% It does not take much of a motherboard/cpu to service a bunch of spinning
% disks.
% 
...
% About the only major thing that makes any difference is making sure that
% whatever card is running the sata ports does not have a bottleneck.
[snip]

Thanks!  It'll be a bit before I can play, but I'll do some reading and
work some tests.  Stay tuned :-)


HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

