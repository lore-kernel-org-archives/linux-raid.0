Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF61C4332F
	for <linux-raid@archiver.kernel.org>; Fri, 25 Nov 2022 13:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiKYN4f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 25 Nov 2022 08:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiKYN4e (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 25 Nov 2022 08:56:34 -0500
X-Greylist: delayed 1189 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 25 Nov 2022 05:56:33 PST
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1329B21E
        for <linux-raid@vger.kernel.org>; Fri, 25 Nov 2022 05:56:32 -0800 (PST)
Received: from [73.207.192.158] (port=50702 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg@justpickone.org>)
        id 1oyYso-0007nH-FJ;
        Fri, 25 Nov 2022 07:36:42 -0600
Date:   Fri, 25 Nov 2022 13:36:40 +0000
From:   David T-G <davidtg@justpickone.org>
To:     Wol <antlists@youngman.org.uk>
Cc:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: and dm-integrity, too (was "Re: how do i fix these RAID5 arrays?")
Message-ID: <20221125133640.GI19721@jpo>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <CAAMCDedMhATuEPx8yFzAwxf5zS7CXFhz6702rmUCg7pXQX4qSA@mail.gmail.com>
 <20221124212007.GF19721@jpo>
 <a0eae02e-8d6e-39ad-19a0-574d92891687@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0eae02e-8d6e-39ad-19a0-574d92891687@youngman.org.uk>
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
...
% 
% (Note also I've got dm-integrity in there too, but that's me.)
% 
% https://raid.wiki.kernel.org/index.php/System2020

I read *so* much of this and so much more trying to recover a different
array after a couple of drive failures.  I never got overlays and integrity
to work :-(  The latter is another thing on the "future enhancements" list!


% 
% Cheers,
% Wol


HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

