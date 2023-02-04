Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB598C05027
	for <linux-raid@archiver.kernel.org>; Sat,  4 Feb 2023 02:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbjBDCUZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Feb 2023 21:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBDCUY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Feb 2023 21:20:24 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C221CAE3
        for <linux-raid@vger.kernel.org>; Fri,  3 Feb 2023 18:20:22 -0800 (PST)
Received: from [73.207.192.158] (port=33188 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1pO8A9-0002RF-07
        for linux-raid@vger.kernel.org;
        Fri, 03 Feb 2023 20:20:21 -0600
Date:   Sat, 4 Feb 2023 02:20:19 +0000
From:   David Thorburn-Gundlach <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how to know a hard drive will mix well
Message-ID: <20230204022019.GI25616@jpo>
References: <20230202124306.GH25616@jpo>
 <CAAMCDedK==A1q-S97=MZGL2Wv_COC4DCGqh__2atSOHk2YBWAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAMCDedK==A1q-S97=MZGL2Wv_COC4DCGqh__2atSOHk2YBWAg@mail.gmail.com>
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
% I have mixed many drives, I have never really had a major slowness.  At

Good to know.


% worst you will be limited by the drive with the slowest seeks/transfer
% rate.  So long as one disk's RPM is not significantly different you should

That's pretty much what I was wondering, but I imagine if it's the same
RPM and the same cache and the same SATA rate it should be ... about the
same.


% not notice it, unless you are running your array right at the limit.

Hmmph.  I'm not entirely sure I'm not anyway, but it is just a little PC
mobo running primary and daughtercard SATA ports.  A Real Server (tm) is
far, far beyond the current horizon :-)


% 
% Technically you may want to also look at another parm that is the sustained
% transfer rate range coming off the platter.  This will be a range that is
[snip]

Oh, thanks!  Sounds good.


HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

