Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AC2C433B4
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 05:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2BE9610F8
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 05:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhDBFFz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Apr 2021 01:05:55 -0400
Received: from u17383850.onlinehome-server.com ([74.208.250.170]:45022 "EHLO
        u17383850.onlinehome-server.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229522AbhDBFFz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Apr 2021 01:05:55 -0400
Received: by u17383850.onlinehome-server.com (Postfix, from userid 5001)
        id 8556479E; Fri,  2 Apr 2021 01:05:54 -0400 (EDT)
Date:   Fri, 2 Apr 2021 01:05:54 -0400
From:   David T-G <davidtg-robot@justpickone.org>
To:     antlists <antlists@youngman.org.uk>
Cc:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: how do i bring this disk back into the fold?
Message-ID: <20210402050554.GF1415@justpickone.org>
References: <20210328021210.GA1415@justpickone.org>
 <20210402004001.GH1711@justpickone.org>
 <62cc89ea-b9cf-d8a3-3d52-499fd84f7cc3@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62cc89ea-b9cf-d8a3-3d52-499fd84f7cc3@youngman.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Wol, et al --

...and then antlists said...
% 
% mdadm --re-add?
[snip]

Thanks!  Sure enough, --re-add didn't work, but --add happily got under
way.  Only nine hours to go ... :-)


Thanks again & HANW

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

